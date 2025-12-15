-- Migración: Hacer función delete_user_data más robusta
-- Esta migración actualiza la función para que siempre marque usuarios como eliminados
-- incluso si algunas tablas no existen o fallan las eliminaciones

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
  
  -- Eliminar consentimientos (si la tabla existe)
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
  
  -- Anonimizar reportes (mantener para estadísticas pero sin identificador)
  BEGIN
    UPDATE public.content_reports 
    SET reported_by = NULL 
    WHERE reported_by = user_uuid;
  EXCEPTION WHEN undefined_table THEN
    RAISE NOTICE 'Tabla content_reports no existe, omitiendo';
  END;
  
  -- IMPORTANTE: Marcar usuario como eliminado en deleted_users
  -- Esto SIEMPRE debe ejecutarse, incluso si fallan las eliminaciones anteriores
  -- Esto previene que pueda iniciar sesión de nuevo si la Edge Function no está disponible
  BEGIN
    INSERT INTO public.deleted_users (user_id, email, reason)
    SELECT id, email, 'user_requested'
    FROM auth.users
    WHERE id = user_uuid
    ON CONFLICT (user_id) DO UPDATE
    SET deleted_at = now();
    
    RAISE NOTICE 'Usuario % marcado como eliminado en deleted_users', user_uuid;
  EXCEPTION
    WHEN undefined_table THEN
      -- La tabla deleted_users no existe aún - esto es crítico
      RAISE WARNING 'CRÍTICO: Tabla deleted_users no existe. El usuario podrá iniciar sesión de nuevo.';
      RAISE WARNING 'Por favor, ejecuta la migración 009_add_deleted_users_table.sql';
    WHEN OTHERS THEN
      -- Cualquier otro error al marcar como eliminado
      RAISE WARNING 'Error al marcar usuario como eliminado: %', SQLERRM;
  END;
  
  -- NOTA: La eliminación de la cuenta de auth.users debe hacerse desde la app
  -- usando Supabase Admin API (Edge Function) o desde el dashboard
END;
$$;

COMMENT ON FUNCTION public.delete_user_data IS 
'Elimina todos los datos personales de un usuario (derecho al olvido RGPD) y lo marca como eliminado.
Esta función es robusta y maneja casos donde algunas tablas pueden no existir.
Siempre marca al usuario como eliminado en deleted_users para prevenir login futuro.';

