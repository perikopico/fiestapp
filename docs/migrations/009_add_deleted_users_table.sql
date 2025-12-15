-- Migración: Tabla para marcar usuarios eliminados
-- Esto permite prevenir que usuarios eliminados puedan iniciar sesión
-- cuando la Edge Function no está disponible para eliminar de auth.users

-- Crear tabla para usuarios eliminados
CREATE TABLE IF NOT EXISTS public.deleted_users (
    user_id uuid PRIMARY KEY REFERENCES auth.users(id) ON DELETE CASCADE,
    deleted_at timestamptz NOT NULL DEFAULT now(),
    email text,
    reason text DEFAULT 'user_requested'
);

-- Índice para búsquedas rápidas
CREATE INDEX IF NOT EXISTS idx_deleted_users_deleted_at ON public.deleted_users(deleted_at);
CREATE INDEX IF NOT EXISTS idx_deleted_users_email ON public.deleted_users(email);

-- Comentarios
COMMENT ON TABLE public.deleted_users IS 'Usuarios que han solicitado eliminación de cuenta pero aún existen en auth.users';
COMMENT ON COLUMN public.deleted_users.user_id IS 'ID del usuario en auth.users';
COMMENT ON COLUMN public.deleted_users.deleted_at IS 'Fecha y hora de eliminación';
COMMENT ON COLUMN public.deleted_users.email IS 'Email del usuario (para referencia)';
COMMENT ON COLUMN public.deleted_users.reason IS 'Razón de la eliminación';

-- Política RLS: Solo el propio usuario puede ver su registro (aunque no debería poder iniciar sesión)
ALTER TABLE public.deleted_users ENABLE ROW LEVEL SECURITY;

-- Eliminar política si existe y recrearla
DROP POLICY IF EXISTS "Users can view their own deletion record" ON public.deleted_users;

CREATE POLICY "Users can view their own deletion record"
    ON public.deleted_users
    FOR SELECT
    USING (auth.uid() = user_id);

-- Actualizar función delete_user_data para marcar usuario como eliminado
-- Esta versión es robusta y maneja tablas que pueden no existir
CREATE OR REPLACE FUNCTION public.delete_user_data(user_uuid uuid)
RETURNS void
LANGUAGE plpgsql
SECURITY DEFINER
AS $$
BEGIN
    -- Eliminar favoritos (si la tabla existe)
    BEGIN
        DELETE FROM public.user_favorites WHERE user_id = user_uuid;
    EXCEPTION WHEN undefined_table THEN
        RAISE NOTICE 'Tabla user_favorites no existe, omitiendo';
    END;
    
    -- Eliminar tokens FCM (si la tabla existe)
    BEGIN
        DELETE FROM public.user_fcm_tokens WHERE user_id = user_uuid;
    EXCEPTION WHEN undefined_table THEN
        RAISE NOTICE 'Tabla user_fcm_tokens no existe, omitiendo';
    END;
    
    -- Eliminar consentimientos GDPR (si la tabla existe)
    BEGIN
        DELETE FROM public.user_consents WHERE user_id = user_uuid;
    EXCEPTION WHEN undefined_table THEN
        RAISE NOTICE 'Tabla user_consents no existe, omitiendo';
    END;
    
    -- Anonimizar eventos creados (mantener eventos pero sin creador)
    BEGIN
        UPDATE public.events 
        SET created_by = NULL 
        WHERE created_by = user_uuid;
    EXCEPTION WHEN undefined_table THEN
        RAISE NOTICE 'Tabla events no existe, omitiendo';
    END;
    
    -- Anonimizar lugares creados (si la tabla existe)
    BEGIN
        UPDATE public.venues 
        SET created_by = NULL 
        WHERE created_by = user_uuid;
    EXCEPTION WHEN undefined_table THEN
        RAISE NOTICE 'Tabla venues no existe, omitiendo';
    END;
    
    -- Eliminar de admins (si la tabla existe)
    BEGIN
        DELETE FROM public.admins WHERE user_id = user_uuid;
    EXCEPTION WHEN undefined_table THEN
        RAISE NOTICE 'Tabla admins no existe, omitiendo';
    END;
    
    -- Eliminar de venue_managers (si la tabla existe)
    BEGIN
        DELETE FROM public.venue_managers WHERE user_id = user_uuid;
    EXCEPTION WHEN undefined_table THEN
        RAISE NOTICE 'Tabla venue_managers no existe, omitiendo';
    END;
    
    -- Anonimizar reportes (si la tabla existe)
    BEGIN
        UPDATE public.content_reports 
        SET reported_by = NULL 
        WHERE reported_by = user_uuid;
    EXCEPTION WHEN undefined_table THEN
        RAISE NOTICE 'Tabla content_reports no existe, omitiendo';
    END;
    
    -- IMPORTANTE: Marcar usuario como eliminado en deleted_users
    -- Esto SIEMPRE debe ejecutarse para prevenir que pueda iniciar sesión de nuevo
    INSERT INTO public.deleted_users (user_id, email, reason)
    SELECT id, email, 'user_requested'
    FROM auth.users
    WHERE id = user_uuid
    ON CONFLICT (user_id) DO UPDATE
    SET deleted_at = now();
    
    RAISE NOTICE 'Usuario % marcado como eliminado en deleted_users', user_uuid;
END;
$$;

COMMENT ON FUNCTION public.delete_user_data IS 
'Elimina todos los datos personales del usuario y lo marca como eliminado en deleted_users. 
Esto previene que el usuario pueda iniciar sesión de nuevo si la Edge Function no está disponible.';

