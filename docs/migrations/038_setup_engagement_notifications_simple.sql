-- Migration: Setup Engagement Notifications (Versión Simplificada)
-- Description: Versión simplificada que requiere editar manualmente los valores
-- Date: 2026-02-02
--
-- INSTRUCCIONES:
-- 1. Reemplaza [TU-PROJECT-REF] con tu project reference de Supabase
-- 2. Reemplaza [TU-SERVICE-ROLE-KEY] con tu Service Role Key
-- 3. Ejecuta este script en el SQL Editor de Supabase

-- ============================================================================
-- HABILITAR EXTENSIÓN pg_net
-- ============================================================================
CREATE EXTENSION IF NOT EXISTS pg_net;

-- ============================================================================
-- FUNCIÓN PARA NOTIFICAR CAMBIOS EN EVENTOS
-- ============================================================================
CREATE OR REPLACE FUNCTION notify_event_update()
RETURNS TRIGGER AS $$
DECLARE
  payload JSONB;
BEGIN
  -- Solo procesar si hay cambios relevantes
  IF (OLD.status IS DISTINCT FROM NEW.status) OR
     (OLD.starts_at IS DISTINCT FROM NEW.starts_at) OR
     (OLD.place IS DISTINCT FROM NEW.place) OR
     (OLD.venue_id IS DISTINCT FROM NEW.venue_id) THEN
    
    payload := jsonb_build_object(
      'type', TG_OP,
      'table', TG_TABLE_NAME,
      'record', row_to_json(NEW),
      'old_record', row_to_json(OLD)
    );
    
    -- Llamar a la Edge Function
    -- ⚠️ REEMPLAZA [TU-PROJECT-REF] y [TU-SERVICE-ROLE-KEY] con tus valores reales
    PERFORM net.http_post(
      url := 'https://[TU-PROJECT-REF].supabase.co/functions/v1/handle-event-update',
      headers := jsonb_build_object(
        'Content-Type', 'application/json',
        'Authorization', 'Bearer [TU-SERVICE-ROLE-KEY]'
      ),
      body := payload,
      timeout_milliseconds := 30000
    );
  END IF;
  
  RETURN NEW;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- ============================================================================
-- CREAR TRIGGER EN TABLA events
-- ============================================================================
DROP TRIGGER IF EXISTS event_update_webhook ON events;
CREATE TRIGGER event_update_webhook
  AFTER UPDATE ON events
  FOR EACH ROW
  EXECUTE FUNCTION notify_event_update();

-- ============================================================================
-- VERIFICACIÓN
-- ============================================================================
-- Verificar que el trigger existe
SELECT 
  trigger_name, 
  event_manipulation, 
  event_object_table
FROM information_schema.triggers
WHERE trigger_name = 'event_update_webhook';
