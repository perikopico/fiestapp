-- Migration: Setup Engagement Notifications
-- Description: Configura triggers y funciones para notificaciones de engagement
-- Date: 2026-02-02

-- ============================================================================
-- 1. HABILITAR EXTENSIÓN pg_net (si no está habilitada)
-- ============================================================================
CREATE EXTENSION IF NOT EXISTS pg_net;

-- ============================================================================
-- 2. FUNCIÓN PARA NOTIFICAR CAMBIOS EN EVENTOS
-- ============================================================================
CREATE OR REPLACE FUNCTION notify_event_update()
RETURNS TRIGGER AS $$
DECLARE
  payload JSONB;
  project_ref TEXT;
  service_role_key TEXT;
BEGIN
  -- Solo procesar si hay cambios relevantes
  IF (OLD.status IS DISTINCT FROM NEW.status) OR
     (OLD.starts_at IS DISTINCT FROM NEW.starts_at) OR
     (OLD.place IS DISTINCT FROM NEW.place) OR
     (OLD.venue_id IS DISTINCT FROM NEW.venue_id) THEN
    
    -- Obtener project_ref y service_role_key desde las variables de entorno
    -- Nota: En producción, estos valores deben configurarse como secrets
    -- Por ahora, los obtenemos de las variables de entorno de Supabase
    project_ref := current_setting('app.settings.project_ref', true);
    service_role_key := current_setting('app.settings.service_role_key', true);
    
    -- Si no están configuradas, usar valores por defecto (debes reemplazarlos)
    -- IMPORTANTE: Reemplaza estos valores con los de tu proyecto
    IF project_ref IS NULL THEN
      project_ref := 'TU-PROJECT-REF'; -- ⚠️ REEMPLAZAR
    END IF;
    
    IF service_role_key IS NULL THEN
      service_role_key := 'TU-SERVICE-ROLE-KEY'; -- ⚠️ REEMPLAZAR
    END IF;
    
    payload := jsonb_build_object(
      'type', TG_OP,
      'table', TG_TABLE_NAME,
      'record', row_to_json(NEW),
      'old_record', row_to_json(OLD)
    );
    
    -- Llamar a la Edge Function de forma asíncrona
    PERFORM net.http_post(
      url := format('https://%s.supabase.co/functions/v1/handle-event-update', project_ref),
      headers := jsonb_build_object(
        'Content-Type', 'application/json',
        'Authorization', format('Bearer %s', service_role_key)
      ),
      body := payload,
      timeout_milliseconds := 30000
    );
  END IF;
  
  RETURN NEW;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- ============================================================================
-- 3. CREAR TRIGGER EN TABLA events
-- ============================================================================
DROP TRIGGER IF EXISTS event_update_webhook ON events;
CREATE TRIGGER event_update_webhook
  AFTER UPDATE ON events
  FOR EACH ROW
  EXECUTE FUNCTION notify_event_update();

-- ============================================================================
-- 4. COMENTARIOS Y DOCUMENTACIÓN
-- ============================================================================
COMMENT ON FUNCTION notify_event_update() IS 
'Función trigger que notifica cambios críticos en eventos y nuevos eventos publicados mediante Edge Function handle-event-update';

COMMENT ON TRIGGER event_update_webhook ON events IS 
'Trigger que ejecuta notify_event_update() cuando se actualiza un evento, detectando cambios críticos (fecha, lugar, estado) y nuevas publicaciones';

-- ============================================================================
-- 5. CONFIGURAR VARIABLES DE ENTORNO (OPCIONAL)
-- ============================================================================
-- Para configurar las variables de entorno en Supabase:
-- 1. Ve a Settings → Database → Custom Config
-- 2. Agrega estas configuraciones:
--    app.settings.project_ref = 'tu-project-ref'
--    app.settings.service_role_key = 'tu-service-role-key'
--
-- O simplemente edita la función para usar valores hardcodeados (menos seguro)

-- ============================================================================
-- 6. VERIFICACIÓN
-- ============================================================================
-- Verificar que el trigger existe
SELECT 
  trigger_name, 
  event_manipulation, 
  event_object_table, 
  action_statement
FROM information_schema.triggers
WHERE trigger_name = 'event_update_webhook';

-- Verificar que la función existe
SELECT 
  routine_name, 
  routine_type
FROM information_schema.routines
WHERE routine_name = 'notify_event_update';

-- ============================================================================
-- NOTAS IMPORTANTES:
-- ============================================================================
-- 1. ANTES DE EJECUTAR ESTE SCRIPT:
--    - Reemplaza 'TU-PROJECT-REF' con tu project reference de Supabase
--    - Reemplaza 'TU-SERVICE-ROLE-KEY' con tu Service Role Key
--    - O configura las variables de entorno como se indica arriba
--
-- 2. PARA CONFIGURAR EL CRON JOB:
--    Ve a Supabase Dashboard → Database → Cron Jobs y crea un nuevo cron job
--    con el siguiente SQL:
--
--    SELECT net.http_post(
--      url := 'https://[TU-PROJECT-REF].supabase.co/functions/v1/send-favorite-reminders',
--      headers := jsonb_build_object(
--        'Content-Type', 'application/json',
--        'Authorization', 'Bearer [TU-SERVICE-ROLE-KEY]'
--      ),
--      body := '{}'::jsonb
--    ) AS request_id;
--
--    Schedule: 0 10 * * * (10:00 AM UTC diariamente)
--
-- 3. PARA PROBAR EL TRIGGER:
--    UPDATE events 
--    SET starts_at = NOW() + INTERVAL '2 days'
--    WHERE id = 'algún-event-id';
--
-- 4. PARA DESHABILITAR TEMPORALMENTE:
--    DROP TRIGGER IF EXISTS event_update_webhook ON events;
--
-- 5. PARA REHABILITAR:
--    CREATE TRIGGER event_update_webhook
--      AFTER UPDATE ON events
--      FOR EACH ROW
--      EXECUTE FUNCTION notify_event_update();
