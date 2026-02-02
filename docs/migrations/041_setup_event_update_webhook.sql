-- ============================================================================
-- SETUP COMPLETO: Webhook para Cambios Críticos en Eventos
-- ============================================================================
-- INSTRUCCIONES:
-- 1. Ve a Supabase Dashboard → SQL Editor
-- 2. Copia y pega TODO este archivo
-- 3. Reemplaza [TU-SERVICE-ROLE-KEY] con tu Service Role Key real
--    (Encuéntralo en: Settings → API → service_role key)
-- 4. Ejecuta el script
-- ============================================================================

-- Paso 1: Habilitar extensión pg_net (necesaria para hacer HTTP requests)
CREATE EXTENSION IF NOT EXISTS pg_net;

-- Verificar que pg_net está habilitada
DO $$
BEGIN
  IF NOT EXISTS (SELECT 1 FROM pg_extension WHERE extname = 'pg_net') THEN
    RAISE EXCEPTION 'pg_net no está disponible. Contacta con soporte de Supabase.';
  END IF;
  RAISE NOTICE '✅ Extensión pg_net habilitada';
END $$;

-- Paso 2: Crear función para notificar cambios en eventos
CREATE OR REPLACE FUNCTION notify_event_update()
RETURNS TRIGGER AS $$
DECLARE
  payload JSONB;
BEGIN
  -- Solo procesar si hay cambios relevantes (críticos)
  IF (OLD.status IS DISTINCT FROM NEW.status) OR
     (OLD.starts_at IS DISTINCT FROM NEW.starts_at) OR
     (OLD.place IS DISTINCT FROM NEW.place) OR
     (OLD.venue_id IS DISTINCT FROM NEW.venue_id) THEN
    
    -- Construir payload con información del cambio
    payload := jsonb_build_object(
      'type', TG_OP,                    -- 'UPDATE'
      'table', TG_TABLE_NAME,           -- 'events'
      'record', row_to_json(NEW),       -- Datos nuevos del evento
      'old_record', row_to_json(OLD)    -- Datos antiguos del evento
    );
    
    -- Llamar a la Edge Function de forma asíncrona
    -- ⚠️ IMPORTANTE: Reemplaza [TU-SERVICE-ROLE-KEY] con tu Service Role Key real
    PERFORM net.http_post(
      url := 'https://oudofaiekedtaovrdqeo.supabase.co/functions/v1/handle-event-update',
      headers := jsonb_build_object(
        'Content-Type', 'application/json',
        'Authorization', 'Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Im91ZG9mYWlla2VkdGFvdnJkcWVvIiwicm9sZSI6InNlcnZpY2Vfcm9sZSIsImlhdCI6MTc2MjI3NTg4MywiZXhwIjoyMDc3ODUxODgzfQ.DmsxMPWEAtn-TJNLpGvWY6Lqvu4KeYz83BYYslqLCFA'
      ),
      body := payload,
      timeout_milliseconds := 30000  -- 30 segundos de timeout
    );
    
    RAISE NOTICE '📤 Webhook enviado para evento %: cambios detectados', NEW.id;
  ELSE
    RAISE NOTICE '⏭️  Evento % actualizado pero sin cambios críticos, omitiendo webhook', NEW.id;
  END IF;
  
  RETURN NEW;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- Paso 3: Eliminar trigger existente si existe (para evitar duplicados)
DROP TRIGGER IF EXISTS event_update_webhook ON events;

-- Paso 4: Crear el trigger
CREATE TRIGGER event_update_webhook
  AFTER UPDATE ON events
  FOR EACH ROW
  EXECUTE FUNCTION notify_event_update();

-- Paso 5: Verificar que el trigger se creó correctamente
DO $$
DECLARE
  trigger_count INTEGER;
BEGIN
  SELECT COUNT(*) INTO trigger_count
  FROM information_schema.triggers
  WHERE trigger_name = 'event_update_webhook'
    AND event_object_table = 'events';
  
  IF trigger_count > 0 THEN
    RAISE NOTICE '✅ Trigger creado exitosamente: event_update_webhook';
    RAISE NOTICE '📡 Se ejecutará automáticamente cuando se actualice un evento';
  ELSE
    RAISE EXCEPTION '❌ Error: El trigger no se creó. Verifica los logs.';
  END IF;
END $$;

-- Paso 6: Mostrar información del trigger
SELECT 
  trigger_name,
  event_manipulation,
  event_object_table,
  action_statement,
  action_timing
FROM information_schema.triggers
WHERE trigger_name = 'event_update_webhook'
  AND event_object_table = 'events';

-- ============================================================================
-- PRUEBAS
-- ============================================================================

-- Prueba 1: Cambio crítico (fecha)
-- Descomenta y ejecuta para probar (reemplaza 'event-id-aqui' con un ID real):
/*
UPDATE events 
SET starts_at = NOW() + INTERVAL '3 days'
WHERE id = 'event-id-aqui'
RETURNING id, title, starts_at;
*/

-- Prueba 2: Cambio crítico (lugar)
-- Descomenta y ejecuta para probar:
/*
UPDATE events 
SET place = 'Nuevo Lugar de Prueba'
WHERE id = 'event-id-aqui'
RETURNING id, title, place;
*/

-- Prueba 3: Publicar evento nuevo (debe enviar notificación por topic)
-- Descomenta y ejecuta para probar:
/*
UPDATE events 
SET status = 'published'
WHERE id = 'event-id-aqui' AND status = 'pending'
RETURNING id, title, status;
*/

-- Prueba 4: Cambio no crítico (solo descripción - NO debe enviar webhook)
-- Descomenta y ejecuta para probar:
/*
UPDATE events 
SET description = 'Nueva descripción de prueba'
WHERE id = 'event-id-aqui'
RETURNING id, title, description;
*/

-- ============================================================================
-- GESTIÓN DEL TRIGGER
-- ============================================================================

-- Deshabilitar temporalmente el trigger (descomenta para usar)
-- ALTER TABLE events DISABLE TRIGGER event_update_webhook;

-- Rehabilitar el trigger (descomenta para usar)
-- ALTER TABLE events ENABLE TRIGGER event_update_webhook;

-- Eliminar el trigger completamente (descomenta para usar)
-- DROP TRIGGER IF EXISTS event_update_webhook ON events;
-- DROP FUNCTION IF EXISTS notify_event_update();

-- ============================================================================
-- VERIFICACIÓN DE LOGS
-- ============================================================================

-- Ver logs recientes de pg_net (si están disponibles)
-- SELECT * FROM net.http_request_queue 
-- ORDER BY created_at DESC 
-- LIMIT 10;

-- ============================================================================
-- NOTAS IMPORTANTES:
-- ============================================================================
-- 1. El trigger se ejecuta DESPUÉS de cada UPDATE en la tabla events
-- 2. Solo envía webhook si hay cambios críticos (fecha, lugar, venue, estado)
-- 3. Los cambios en descripción, imagen, etc. NO activan el webhook
-- 4. El webhook es asíncrono (no bloquea la actualización del evento)
-- 5. El Service Role Key es muy sensible. NUNCA lo compartas públicamente.
-- 6. Si necesitas ver los logs, revisa la Edge Function en Supabase Dashboard
--    → Edge Functions → handle-event-update → Logs
