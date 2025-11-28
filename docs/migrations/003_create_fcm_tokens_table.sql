-- Migración: Crear tabla para tokens FCM
-- Ejecutar en Supabase SQL Editor
-- Fecha: Diciembre 2024

-- ============================================
-- 1. Tabla de tokens FCM
-- ============================================
CREATE TABLE IF NOT EXISTS public.user_fcm_tokens (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id uuid NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
  token text NOT NULL,
  device_type text, -- 'android', 'ios', 'web'
  device_info text, -- Información adicional del dispositivo (opcional)
  created_at timestamptz NOT NULL DEFAULT now(),
  updated_at timestamptz NOT NULL DEFAULT now(),
  UNIQUE(user_id, token)
);

-- Índices para búsquedas rápidas
CREATE INDEX IF NOT EXISTS idx_user_fcm_tokens_user_id ON public.user_fcm_tokens(user_id);
CREATE INDEX IF NOT EXISTS idx_user_fcm_tokens_token ON public.user_fcm_tokens(token);

-- ============================================
-- 2. Row Level Security (RLS)
-- ============================================
ALTER TABLE public.user_fcm_tokens ENABLE ROW LEVEL SECURITY;

-- Política: Los usuarios solo pueden gestionar sus propios tokens
DROP POLICY IF EXISTS "Users can manage own tokens" ON public.user_fcm_tokens;
CREATE POLICY "Users can manage own tokens"
  ON public.user_fcm_tokens
  FOR ALL
  USING (auth.uid() = user_id)
  WITH CHECK (auth.uid() = user_id);

-- ============================================
-- 3. Trigger para actualizar updated_at
-- ============================================
CREATE OR REPLACE FUNCTION update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = now();
    RETURN NEW;
END;
$$ language 'plpgsql';

-- Trigger para actualizar updated_at automáticamente
DROP TRIGGER IF EXISTS update_user_fcm_tokens_updated_at ON public.user_fcm_tokens;
CREATE TRIGGER update_user_fcm_tokens_updated_at
    BEFORE UPDATE ON public.user_fcm_tokens
    FOR EACH ROW
    EXECUTE FUNCTION update_updated_at_column();

-- ============================================
-- 4. Comentarios
-- ============================================
COMMENT ON TABLE public.user_fcm_tokens IS 'Tokens FCM de usuarios para notificaciones push';
COMMENT ON COLUMN public.user_fcm_tokens.user_id IS 'ID del usuario propietario del token';
COMMENT ON COLUMN public.user_fcm_tokens.token IS 'Token FCM del dispositivo';
COMMENT ON COLUMN public.user_fcm_tokens.device_type IS 'Tipo de dispositivo (android/ios/web)';
COMMENT ON COLUMN public.user_fcm_tokens.device_info IS 'Información adicional del dispositivo';

-- ============================================
-- NOTAS:
-- ============================================
-- Esta tabla almacena los tokens FCM de cada usuario.
-- Un usuario puede tener múltiples tokens (uno por dispositivo).
-- Los tokens se eliminan automáticamente cuando se elimina el usuario (CASCADE).
-- La política RLS asegura que los usuarios solo puedan ver/editar sus propios tokens.
