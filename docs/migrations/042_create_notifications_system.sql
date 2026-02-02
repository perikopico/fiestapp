-- ============================================================================
-- Sistema de Notificaciones Robusto: Historial y Cola de Espera
-- ============================================================================
-- 
-- Este script crea las estructuras necesarias para:
-- 1. Historial de notificaciones (buzón dentro de la app)
-- 2. Cola de espera para horas de silencio (quiet hours)
-- 3. Índices y políticas de seguridad (RLS)
--
-- Fecha: 2026-02-02
-- ============================================================================

-- ============================================================================
-- 1. TABLA: notifications_history
-- ============================================================================
-- Objetivo: Persistencia para el "Buzón de notificaciones" dentro de la App
-- Lógica: Cada vez que se envíe un push, se debe guardar aquí una copia
-- ============================================================================

CREATE TABLE IF NOT EXISTS notifications_history (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  
  -- Destinatario
  user_id UUID REFERENCES auth.users(id) ON DELETE CASCADE,
  topic_name TEXT, -- Para notificaciones por topic (ej: "city_barbate")
  
  -- Contenido de la notificación
  title TEXT NOT NULL,
  body TEXT NOT NULL,
  data JSONB DEFAULT '{}'::jsonb, -- Payload completo para deep linking
  
  -- Metadatos
  notification_type TEXT NOT NULL, -- 'event_approved', 'event_rejected', 'favorite_reminder', 'critical_change', 'new_event', etc.
  event_id UUID REFERENCES events(id) ON DELETE SET NULL,
  
  -- Estado de entrega
  sent_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  delivered_at TIMESTAMPTZ, -- Cuando FCM confirma entrega (opcional, requiere tracking)
  read_at TIMESTAMPTZ, -- Cuando el usuario abre la notificación en la app
  
  -- Información técnica
  fcm_token TEXT, -- Token usado (si fue envío directo)
  fcm_message_id TEXT, -- ID del mensaje de FCM (para tracking)
  delivery_status TEXT DEFAULT 'sent', -- 'sent', 'delivered', 'failed', 'pending'
  error_message TEXT, -- Si falló el envío
  
  -- Timestamps
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

-- Constraint: Debe tener user_id O topic_name (pero no ambos)
ALTER TABLE notifications_history
  ADD CONSTRAINT notifications_history_target_check 
  CHECK (
    (user_id IS NOT NULL AND topic_name IS NULL) OR 
    (user_id IS NULL AND topic_name IS NOT NULL)
  );

-- Índices para consultas rápidas
CREATE INDEX IF NOT EXISTS idx_notifications_history_user_id ON notifications_history(user_id);
CREATE INDEX IF NOT EXISTS idx_notifications_history_topic_name ON notifications_history(topic_name);
CREATE INDEX IF NOT EXISTS idx_notifications_history_sent_at ON notifications_history(sent_at DESC);
CREATE INDEX IF NOT EXISTS idx_notifications_history_read_at ON notifications_history(read_at) WHERE read_at IS NULL;
CREATE INDEX IF NOT EXISTS idx_notifications_history_event_id ON notifications_history(event_id);
CREATE INDEX IF NOT EXISTS idx_notifications_history_notification_type ON notifications_history(notification_type);

-- Índice compuesto para consultas comunes (buzón de usuario)
CREATE INDEX IF NOT EXISTS idx_notifications_history_user_unread 
  ON notifications_history(user_id, read_at) 
  WHERE user_id IS NOT NULL AND read_at IS NULL;

-- ============================================================================
-- 2. TABLA: pending_notifications
-- ============================================================================
-- Objetivo: Almacenamiento temporal para notificaciones generadas durante 
--          "Horas de Silencio" (Quiet Hours)
-- Lógica: Si es de madrugada, el sistema guarda aquí en lugar de enviar
-- Ciclo de vida: Se inserta por la noche -> Se procesa/elimina por la mañana
-- ============================================================================

CREATE TABLE IF NOT EXISTS pending_notifications (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  
  -- Destinatario
  user_id UUID REFERENCES auth.users(id) ON DELETE CASCADE,
  topic_name TEXT, -- Para notificaciones por topic
  
  -- Contenido de la notificación
  title TEXT NOT NULL,
  body TEXT NOT NULL,
  data JSONB DEFAULT '{}'::jsonb,
  
  -- Metadatos
  notification_type TEXT NOT NULL,
  event_id UUID REFERENCES events(id) ON DELETE SET NULL,
  
  -- Programación
  scheduled_for TIMESTAMPTZ NOT NULL, -- Cuándo debe enviarse (ej: 08:00 del día siguiente)
  priority INTEGER DEFAULT 0, -- 0 = normal, 1 = alta, 2 = urgente
  
  -- Estado
  status TEXT DEFAULT 'pending', -- 'pending', 'processing', 'sent', 'failed'
  retry_count INTEGER DEFAULT 0,
  max_retries INTEGER DEFAULT 3,
  last_error TEXT,
  
  -- Información técnica
  fcm_token TEXT, -- Token específico (si aplica)
  
  -- Timestamps
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  processed_at TIMESTAMPTZ
);

-- Constraint: Debe tener user_id O topic_name
ALTER TABLE pending_notifications
  ADD CONSTRAINT pending_notifications_target_check 
  CHECK (
    (user_id IS NOT NULL AND topic_name IS NULL) OR 
    (user_id IS NULL AND topic_name IS NOT NULL)
  );

-- Índices para procesamiento eficiente
CREATE INDEX IF NOT EXISTS idx_pending_notifications_status ON pending_notifications(status);
CREATE INDEX IF NOT EXISTS idx_pending_notifications_scheduled_for ON pending_notifications(scheduled_for);
CREATE INDEX IF NOT EXISTS idx_pending_notifications_user_id ON pending_notifications(user_id);
CREATE INDEX IF NOT EXISTS idx_pending_notifications_topic_name ON pending_notifications(topic_name);

-- Índice compuesto para queries de procesamiento (CRON)
-- Nota: No podemos usar NOW() en el predicado (no es IMMUTABLE)
-- El filtro scheduled_for <= NOW() se hace en la consulta, no en el índice
CREATE INDEX IF NOT EXISTS idx_pending_notifications_process_queue 
  ON pending_notifications(scheduled_for, status) 
  WHERE status = 'pending';

-- ============================================================================
-- 3. FUNCIONES AUXILIARES
-- ============================================================================

-- Función para actualizar updated_at automáticamente
CREATE OR REPLACE FUNCTION update_notifications_updated_at()
RETURNS TRIGGER AS $$
BEGIN
  NEW.updated_at = NOW();
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Triggers para updated_at
CREATE TRIGGER update_notifications_history_updated_at
  BEFORE UPDATE ON notifications_history
  FOR EACH ROW
  EXECUTE FUNCTION update_notifications_updated_at();

CREATE TRIGGER update_pending_notifications_updated_at
  BEFORE UPDATE ON pending_notifications
  FOR EACH ROW
  EXECUTE FUNCTION update_notifications_updated_at();

-- ============================================================================
-- 4. ROW LEVEL SECURITY (RLS)
-- ============================================================================

-- Habilitar RLS
ALTER TABLE notifications_history ENABLE ROW LEVEL SECURITY;
ALTER TABLE pending_notifications ENABLE ROW LEVEL SECURITY;

-- Política: Los usuarios solo pueden ver sus propias notificaciones
CREATE POLICY "Users can view their own notifications"
  ON notifications_history
  FOR SELECT
  USING (auth.uid() = user_id);

-- Política: Los usuarios pueden marcar sus notificaciones como leídas
CREATE POLICY "Users can update their own notifications"
  ON notifications_history
  FOR UPDATE
  USING (auth.uid() = user_id)
  WITH CHECK (auth.uid() = user_id);

-- Política: Solo el sistema puede insertar notificaciones (service_role)
-- (No hay política INSERT para usuarios normales, solo service_role puede)

-- Política: Los usuarios NO pueden ver pending_notifications (solo sistema)
-- (No hay políticas SELECT/INSERT/UPDATE para usuarios normales)

-- ============================================================================
-- 5. FUNCIONES DE UTILIDAD
-- ============================================================================

-- Función para obtener notificaciones no leídas de un usuario
CREATE OR REPLACE FUNCTION get_unread_notifications(p_user_id UUID, p_limit INTEGER DEFAULT 50)
RETURNS TABLE (
  id UUID,
  title TEXT,
  body TEXT,
  data JSONB,
  notification_type TEXT,
  event_id UUID,
  sent_at TIMESTAMPTZ,
  read_at TIMESTAMPTZ
) AS $$
BEGIN
  RETURN QUERY
  SELECT 
    nh.id,
    nh.title,
    nh.body,
    nh.data,
    nh.notification_type,
    nh.event_id,
    nh.sent_at,
    nh.read_at
  FROM notifications_history nh
  WHERE nh.user_id = p_user_id
    AND nh.read_at IS NULL
  ORDER BY nh.sent_at DESC
  LIMIT p_limit;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- Función para marcar notificación como leída
CREATE OR REPLACE FUNCTION mark_notification_as_read(p_notification_id UUID, p_user_id UUID)
RETURNS BOOLEAN AS $$
DECLARE
  v_updated INTEGER;
BEGIN
  UPDATE notifications_history
  SET read_at = NOW(),
      updated_at = NOW()
  WHERE id = p_notification_id
    AND user_id = p_user_id
    AND read_at IS NULL;
  
  GET DIAGNOSTICS v_updated = ROW_COUNT;
  RETURN v_updated > 0;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- Función para obtener notificaciones pendientes listas para procesar
CREATE OR REPLACE FUNCTION get_pending_notifications_ready(p_limit INTEGER DEFAULT 100)
RETURNS TABLE (
  id UUID,
  user_id UUID,
  topic_name TEXT,
  title TEXT,
  body TEXT,
  data JSONB,
  notification_type TEXT,
  event_id UUID,
  fcm_token TEXT,
  priority INTEGER
) AS $$
BEGIN
  RETURN QUERY
  SELECT 
    pn.id,
    pn.user_id,
    pn.topic_name,
    pn.title,
    pn.body,
    pn.data,
    pn.notification_type,
    pn.event_id,
    pn.fcm_token,
    pn.priority
  FROM pending_notifications pn
  WHERE pn.status = 'pending'
    AND pn.scheduled_for <= NOW()
    AND pn.retry_count < pn.max_retries
  ORDER BY pn.priority DESC, pn.scheduled_for ASC
  LIMIT p_limit;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- ============================================================================
-- 6. COMENTARIOS Y DOCUMENTACIÓN
-- ============================================================================

COMMENT ON TABLE notifications_history IS 'Historial de todas las notificaciones enviadas. Usado para el buzón de notificaciones en la app.';
COMMENT ON TABLE pending_notifications IS 'Cola de espera para notificaciones generadas durante horas de silencio. Se procesa automáticamente por la mañana.';

COMMENT ON COLUMN notifications_history.user_id IS 'Usuario destinatario (NULL si es notificación por topic)';
COMMENT ON COLUMN notifications_history.topic_name IS 'Topic FCM (NULL si es notificación directa a usuario)';
COMMENT ON COLUMN notifications_history.data IS 'Payload JSON completo para deep linking y navegación';
COMMENT ON COLUMN notifications_history.read_at IS 'Timestamp cuando el usuario abrió la notificación en la app';

COMMENT ON COLUMN pending_notifications.scheduled_for IS 'Cuándo debe enviarse esta notificación (ej: 08:00 del día siguiente)';
COMMENT ON COLUMN pending_notifications.priority IS 'Prioridad: 0=normal, 1=alta, 2=urgente';
COMMENT ON COLUMN pending_notifications.status IS 'Estado: pending, processing, sent, failed';
