-- Migración: Funcionalidades legales (eliminación de cuenta, exportación de datos, reportes, consentimientos)
-- Ejecutar en Supabase SQL Editor
-- Fecha: Diciembre 2024

-- ============================================
-- 1. TABLA DE CONSENTIMIENTOS GDPR
-- ============================================
CREATE TABLE IF NOT EXISTS public.user_consents (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id uuid NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
  consent_location boolean DEFAULT false,
  consent_notifications boolean DEFAULT false,
  consent_profile boolean DEFAULT false,
  consent_analytics boolean DEFAULT false,
  accepted_terms boolean DEFAULT false,
  accepted_privacy_policy boolean DEFAULT false,
  consent_date timestamptz DEFAULT now(),
  updated_at timestamptz DEFAULT now(),
  UNIQUE(user_id)
);

CREATE INDEX IF NOT EXISTS idx_user_consents_user_id ON public.user_consents(user_id);

-- RLS para consentimientos
ALTER TABLE public.user_consents ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Users can manage own consents" ON public.user_consents
  FOR ALL
  USING (auth.uid() = user_id)
  WITH CHECK (auth.uid() = user_id);

-- ============================================
-- 2. TABLA DE REPORTES DE CONTENIDO
-- ============================================
CREATE TABLE IF NOT EXISTS public.content_reports (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  reported_by uuid REFERENCES auth.users(id) ON DELETE SET NULL,
  content_type text NOT NULL, -- 'event', 'venue'
  content_id uuid NOT NULL,
  reason text NOT NULL, -- 'inappropriate', 'spam', 'false_info', 'copyright', 'other'
  description text,
  status text DEFAULT 'pending', -- 'pending', 'reviewed', 'resolved', 'dismissed'
  reviewed_by uuid REFERENCES auth.users(id),
  reviewed_at timestamptz,
  created_at timestamptz DEFAULT now()
);

CREATE INDEX IF NOT EXISTS idx_content_reports_status ON public.content_reports(status);
CREATE INDEX IF NOT EXISTS idx_content_reports_content ON public.content_reports(content_type, content_id);
CREATE INDEX IF NOT EXISTS idx_content_reports_reported_by ON public.content_reports(reported_by);

-- RLS para reportes
ALTER TABLE public.content_reports ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Users can create reports" ON public.content_reports
  FOR INSERT
  WITH CHECK (auth.uid() = reported_by);

CREATE POLICY "Users can read own reports" ON public.content_reports
  FOR SELECT
  USING (auth.uid() = reported_by);

CREATE POLICY "Admins can read all reports" ON public.content_reports
  FOR SELECT
  USING (
    EXISTS (
      SELECT 1 FROM public.admins
      WHERE admins.user_id = auth.uid()
    )
  );

CREATE POLICY "Admins can update reports" ON public.content_reports
  FOR UPDATE
  USING (
    EXISTS (
      SELECT 1 FROM public.admins
      WHERE admins.user_id = auth.uid()
    )
  );

-- ============================================
-- 3. FUNCIÓN: ELIMINAR DATOS DE USUARIO (Derecho al Olvido)
-- ============================================
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
'Elimina todos los datos personales de un usuario (derecho al olvido RGPD)';

-- ============================================
-- 4. FUNCIÓN: EXPORTAR DATOS DE USUARIO (Derecho de Portabilidad)
-- ============================================
CREATE OR REPLACE FUNCTION public.export_user_data(user_uuid uuid)
RETURNS jsonb
LANGUAGE plpgsql
SECURITY DEFINER
AS $$
DECLARE
  result jsonb;
BEGIN
  SELECT jsonb_build_object(
    'profile', (
      SELECT jsonb_build_object(
        'id', id,
        'email', email,
        'created_at', created_at,
        'updated_at', updated_at,
        'email_confirmed_at', email_confirmed_at
      )
      FROM auth.users
      WHERE id = user_uuid
    ),
    'favorites', (
      SELECT COALESCE(
        jsonb_agg(
          jsonb_build_object(
            'event_id', event_id,
            'created_at', created_at
          )
        ),
        '[]'::jsonb
      )
      FROM public.user_favorites
      WHERE user_id = user_uuid
    ),
    'events_created', (
      SELECT COALESCE(
        jsonb_agg(
          jsonb_build_object(
            'id', id,
            'title', title,
            'place', place,
            'starts_at', starts_at,
            'status', status,
            'created_at', created_at
          )
        ),
        '[]'::jsonb
      )
      FROM public.events
      WHERE created_by = user_uuid
    ),
    'venues_created', (
      SELECT COALESCE(
        jsonb_agg(
          jsonb_build_object(
            'id', id,
            'name', name,
            'address', address,
            'status', status,
            'created_at', created_at
          )
        ),
        '[]'::jsonb
      )
      FROM public.venues
      WHERE created_by = user_uuid
    ),
    'fcm_tokens', (
      SELECT COALESCE(
        jsonb_agg(
          jsonb_build_object(
            'device_type', device_type,
            'created_at', created_at,
            'updated_at', updated_at
          )
        ),
        '[]'::jsonb
      )
      FROM public.user_fcm_tokens
      WHERE user_id = user_uuid
    ),
    'consents', (
      SELECT jsonb_build_object(
        'consent_location', consent_location,
        'consent_notifications', consent_notifications,
        'consent_profile', consent_profile,
        'consent_analytics', consent_analytics,
        'accepted_terms', accepted_terms,
        'accepted_privacy_policy', accepted_privacy_policy,
        'consent_date', consent_date
      )
      FROM public.user_consents
      WHERE user_id = user_uuid
    ),
    'is_admin', EXISTS(
      SELECT 1 FROM public.admins WHERE user_id = user_uuid
    ),
    'reports_made', (
      SELECT COALESCE(
        jsonb_agg(
          jsonb_build_object(
            'content_type', content_type,
            'content_id', content_id,
            'reason', reason,
            'status', status,
            'created_at', created_at
          )
        ),
        '[]'::jsonb
      )
      FROM public.content_reports
      WHERE reported_by = user_uuid
    ),
    'export_date', now()
  ) INTO result;
  
  RETURN result;
END;
$$;

COMMENT ON FUNCTION public.export_user_data IS 
'Exporta todos los datos personales de un usuario en formato JSON (derecho de portabilidad RGPD)';

-- ============================================
-- 5. TRIGGER PARA ACTUALIZAR updated_at EN CONSENTIMIENTOS
-- ============================================
CREATE OR REPLACE FUNCTION update_user_consents_updated_at()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = now();
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

DROP TRIGGER IF EXISTS update_user_consents_updated_at_trigger ON public.user_consents;
CREATE TRIGGER update_user_consents_updated_at_trigger
    BEFORE UPDATE ON public.user_consents
    FOR EACH ROW
    EXECUTE FUNCTION update_user_consents_updated_at();

-- ============================================
-- 6. COMENTARIOS
-- ============================================
COMMENT ON TABLE public.user_consents IS 'Consentimientos GDPR de los usuarios';
COMMENT ON TABLE public.content_reports IS 'Reportes de contenido inapropiado';

-- ============================================
-- NOTAS IMPORTANTES:
-- ============================================
-- 1. La función delete_user_data elimina datos pero NO la cuenta de auth.users
--    Para eliminar la cuenta completamente, usar Supabase Admin API o dashboard
--
-- 2. La función export_user_data devuelve todos los datos en formato JSON
--    para cumplir con el derecho de portabilidad (RGPD Art. 20)
--
-- 3. Los reportes se mantienen anonimizados cuando se elimina un usuario
--    para mantener estadísticas de moderación
--
-- 4. Los consentimientos se eliminan cuando se elimina el usuario (CASCADE)
-- ============================================

