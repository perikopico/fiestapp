# 🔔 Guía: Implementar Notificaciones Push Completas

Esta guía te llevará paso a paso para completar el sistema de notificaciones push.

## 📋 Estado Actual

✅ **Ya implementado:**
- Firebase Messaging configurado
- Obtención de token FCM
- Solicitud de permisos de notificación
- Escucha de cambios de token

❌ **Falta implementar:**
- Handlers para notificaciones en foreground/background/terminated
- Tabla en Supabase para guardar tokens FCM
- Guardar token cuando usuario inicia sesión
- Servicio para gestionar tokens FCM
- Función para enviar notificaciones desde backend

---

## 🚀 Plan de Implementación

### **PASO 1: Crear tabla en Supabase para tokens FCM**

### **PASO 2: Crear servicio para gestionar tokens FCM**

### **PASO 3: Implementar handlers de notificaciones**

### **PASO 4: Integrar guardado de tokens al iniciar sesión**

### **PASO 5: Crear función en Supabase para enviar notificaciones**

### **PASO 6: Probar notificaciones**

---

## 📝 PASO 1: Crear Tabla en Supabase

Ejecuta este SQL en el **SQL Editor** de Supabase:

```sql
-- Crear tabla para almacenar tokens FCM de usuarios
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

-- Habilitar RLS
ALTER TABLE public.user_fcm_tokens ENABLE ROW LEVEL SECURITY;

-- Política: Los usuarios solo pueden ver/insertar/actualizar sus propios tokens
DROP POLICY IF EXISTS "Users can manage own tokens" ON public.user_fcm_tokens;
CREATE POLICY "Users can manage own tokens"
  ON public.user_fcm_tokens
  FOR ALL
  USING (auth.uid() = user_id)
  WITH CHECK (auth.uid() = user_id);

-- Función para actualizar updated_at automáticamente
CREATE OR REPLACE FUNCTION update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = now();
    RETURN NEW;
END;
$$ language 'plpgsql';

-- Trigger para actualizar updated_at
DROP TRIGGER IF EXISTS update_user_fcm_tokens_updated_at ON public.user_fcm_tokens;
CREATE TRIGGER update_user_fcm_tokens_updated_at
    BEFORE UPDATE ON public.user_fcm_tokens
    FOR EACH ROW
    EXECUTE FUNCTION update_updated_at_column();

-- Comentarios
COMMENT ON TABLE public.user_fcm_tokens IS 'Tokens FCM de usuarios para notificaciones push';
COMMENT ON COLUMN public.user_fcm_tokens.user_id IS 'ID del usuario propietario del token';
COMMENT ON COLUMN public.user_fcm_tokens.token IS 'Token FCM del dispositivo';
COMMENT ON COLUMN public.user_fcm_tokens.device_type IS 'Tipo de dispositivo (android/ios/web)';
```

---

## 📝 PASO 2: Crear Servicio para Gestionar Tokens FCM

Voy a crear un servicio que gestionará todo lo relacionado con tokens FCM.

---

## 📝 PASO 3: Implementar Handlers de Notificaciones

Necesitamos manejar notificaciones en tres estados:
- **Foreground**: App abierta y visible
- **Background**: App minimizada
- **Terminated**: App cerrada

---

## 📝 PASO 4: Integrar con Sistema de Autenticación

Cuando un usuario inicie sesión, debemos guardar su token FCM automáticamente.

---

## 📝 PASO 5: Función para Enviar Notificaciones

Crearemos una función en Supabase que permita enviar notificaciones a usuarios.

---

## 🧪 PASO 6: Probar Notificaciones

Cómo probar que todo funciona correctamente.

---

**Sigue estos pasos en orden y te guiaré en cada uno.** 🚀
