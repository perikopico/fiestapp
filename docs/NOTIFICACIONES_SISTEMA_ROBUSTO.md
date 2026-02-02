# 🏗️ Sistema de Notificaciones Robusto - Documentación Técnica

## 📋 Resumen Ejecutivo

Este documento describe la implementación de un sistema de notificaciones robusto para Supabase + FCM que incluye:

1. **Persistencia completa** en historial para buzón de notificaciones
2. **Cola de espera** para horas de silencio (quiet hours)
3. **Módulo común** centralizado para envío inteligente
4. **Procesamiento automático** de cola pendiente

---

## 🗄️ Estructura de Base de Datos

### Tabla: `notifications_history`

**Propósito:** Buzón de notificaciones dentro de la app

**Columnas principales:**
- `id`: UUID (PK)
- `user_id`: UUID (destinatario usuario) o `NULL` si es por topic
- `topic_name`: TEXT (destinatario topic) o `NULL` si es usuario específico
- `title`, `body`: Contenido de la notificación
- `data`: JSONB con payload completo para deep linking
- `notification_type`: Tipo de notificación (`event_approved`, `favorite_reminder`, etc.)
- `event_id`: UUID del evento relacionado (opcional)
- `sent_at`: Timestamp de envío
- `read_at`: Timestamp cuando el usuario abrió la notificación
- `delivery_status`: Estado (`sent`, `delivered`, `failed`, `pending`)
- `fcm_message_id`: ID del mensaje FCM (para tracking)

**Índices:**
- `user_id` + `read_at` (para consultar no leídas)
- `sent_at` DESC (para ordenar por fecha)
- `event_id` (para filtrar por evento)

### Tabla: `pending_notifications`

**Propósito:** Cola temporal para notificaciones durante quiet hours

**Columnas principales:**
- `id`: UUID (PK)
- `user_id` / `topic_name`: Destinatario (igual que historial)
- `title`, `body`, `data`: Contenido
- `scheduled_for`: TIMESTAMPTZ (cuándo debe enviarse)
- `priority`: INTEGER (0=normal, 1=alta, 2=urgente)
- `status`: Estado (`pending`, `processing`, `sent`, `failed`)
- `retry_count`: Contador de reintentos
- `max_retries`: Límite de reintentos (default: 3)

**Índices:**
- `scheduled_for` + `status` (para queries de procesamiento)
- `status` (para filtrar por estado)

---

## 🔧 Módulo Común: SmartNotificationSender

### Ubicación
`supabase/functions/_shared/smart-notification-sender.ts`

### Funcionalidades

1. **Detección automática de Quiet Hours**
   - Horario: 22:00 - 08:00 (configurable)
   - Encola automáticamente si está en quiet hours
   - Puede forzarse con `skipQuietHours: true`

2. **Persistencia en Historial**
   - Guarda cada notificación enviada
   - Incluye estado de entrega
   - Permite tracking de lectura

3. **Manejo de Errores**
   - Detecta tokens inválidos (`UNREGISTERED`)
   - Elimina tokens inválidos automáticamente
   - Reintenta con backoff exponencial

4. **Soporte Múltiple**
   - Envío directo por token FCM
   - Envío por topic FCM
   - Envío a usuario (obtiene tokens automáticamente)

### Uso Básico

```typescript
import { SmartNotificationSender } from '../_shared/smart-notification-sender.ts'

// Inicializar
const sender = new SmartNotificationSender(supabase, accessToken, firebaseProjectId)

// Enviar notificación
const result = await sender.send({
  title: 'Título',
  body: 'Cuerpo',
  data: { view: 'event_detail', id: 'event-id' },
  notificationType: 'favorite_reminder',
  eventId: 'event-id',
  target: {
    userId: 'user-id'
    // o topic: 'city_barbate'
    // o fcmToken: 'token-especifico'
  },
  priority: 0 // 0=normal, 1=alta, 2=urgente
})

if (result.success) {
  if (result.wasQueued) {
    console.log('Encolada para quiet hours')
  } else {
    console.log('Enviada inmediatamente')
  }
}
```

### Opciones Avanzadas

```typescript
// Forzar envío incluso en quiet hours
await sender.send({
  // ... opciones
  skipQuietHours: true
})

// Programar para más tarde
await sender.send({
  // ... opciones
  scheduledFor: new Date('2026-02-03T08:00:00Z')
})
```

---

## ⚙️ Edge Functions

### 1. `process-pending-notifications`

**Propósito:** Procesar cola de notificaciones pendientes

**Trigger:** CRON cada 5 minutos (`*/5 * * * *`)

**Lógica:**
1. Obtiene notificaciones con `scheduled_for <= NOW()` y `status = 'pending'`
2. Marca como `processing`
3. Envía usando `SmartNotificationSender` (con `skipQuietHours: true`)
4. Si éxito: marca como `sent`
5. Si falla: incrementa `retry_count` y programa retry con backoff exponencial
6. Si `retry_count >= max_retries`: marca como `failed`

**Configuración CRON:**
```sql
-- Ver docs/migrations/043_setup_process_pending_notifications_cron.sql
```

### 2. `send-favorite-reminders-v2`

**Propósito:** Versión mejorada de recordatorios de favoritos

**Mejoras sobre v1:**
- Usa `SmartNotificationSender` para manejo automático de quiet hours
- Persiste en historial automáticamente
- Encola notificaciones si es necesario

**Uso:** Reemplazar la función v1 cuando se migre

---

## 🔄 Flujos de Datos

### Flujo Normal (Fuera de Quiet Hours)

```
1. Edge Function genera notificación
   ↓
2. SmartNotificationSender.send()
   ↓
3. Verifica quiet hours → NO está en quiet hours
   ↓
4. Envía a FCM inmediatamente
   ↓
5. Guarda en notifications_history (status: 'sent')
   ↓
6. Usuario recibe notificación
```

### Flujo Quiet Hours

```
1. Edge Function genera notificación
   ↓
2. SmartNotificationSender.send()
   ↓
3. Verifica quiet hours → SÍ está en quiet hours
   ↓
4. Calcula siguiente fin de quiet hours (08:00)
   ↓
5. Guarda en pending_notifications (scheduled_for: 08:00)
   ↓
6. [Espera hasta 08:00]
   ↓
7. CRON process-pending-notifications ejecuta
   ↓
8. Envía a FCM (skipQuietHours: true)
   ↓
9. Guarda en notifications_history
   ↓
10. Marca pending_notifications como 'sent'
   ↓
11. Usuario recibe notificación
```

### Flujo con Retry

```
1. Envío falla (token inválido, red, etc.)
   ↓
2. SmartNotificationSender detecta error
   ↓
3. Si shouldRetry = true:
   - Guarda en pending_notifications
   - scheduled_for = NOW() + backoff exponencial
   - retry_count++
   ↓
4. CRON process-pending-notifications procesa
   ↓
5. Reintenta envío
   ↓
6. Si éxito: marca como 'sent'
   Si falla y retry_count < max_retries: programa nuevo retry
   Si retry_count >= max_retries: marca como 'failed'
```

---

## 📊 Consultas Útiles

### Obtener Notificaciones No Leídas de un Usuario

```sql
SELECT * FROM get_unread_notifications('user-id', 50);
```

### Marcar Notificación como Leída

```sql
SELECT mark_notification_as_read('notification-id', 'user-id');
```

### Ver Notificaciones Pendientes Listas para Procesar

```sql
SELECT * FROM get_pending_notifications_ready(100);
```

### Estadísticas de Notificaciones

```sql
-- Notificaciones enviadas hoy
SELECT COUNT(*) 
FROM notifications_history 
WHERE sent_at >= CURRENT_DATE;

-- Notificaciones no leídas por usuario
SELECT user_id, COUNT(*) 
FROM notifications_history 
WHERE read_at IS NULL 
GROUP BY user_id;

-- Notificaciones fallidas pendientes
SELECT COUNT(*) 
FROM pending_notifications 
WHERE status = 'failed';
```

---

## 🚀 Despliegue

### 1. Ejecutar Migraciones SQL

```bash
# En Supabase SQL Editor o usando psql
psql -h [host] -U postgres -d postgres -f docs/migrations/042_create_notifications_system.sql
psql -h [host] -U postgres -d postgres -f docs/migrations/043_setup_process_pending_notifications_cron.sql
```

**IMPORTANTE:** Reemplazar placeholders en `043_setup_process_pending_notifications_cron.sql`:
- `[TU-PROJECT-REF]` → Tu project reference de Supabase
- `[TU-SERVICE-ROLE-KEY]` → Tu Service Role Key

### 2. Desplegar Edge Functions

```bash
# Desplegar módulo compartido (se copia automáticamente)
# Desplegar función de procesamiento
npx supabase functions deploy process-pending-notifications

# Desplegar versión mejorada de favoritos (opcional)
npx supabase functions deploy send-favorite-reminders-v2
```

### 3. Verificar Secrets

Asegúrate de tener configurados en Supabase Dashboard:
- `FIREBASE_PROJECT_ID`
- `FIREBASE_SERVICE_ACCOUNT_KEY`

---

## 🧪 Testing

### Probar Quiet Hours

```typescript
// En una Edge Function de prueba
const sender = new SmartNotificationSender(supabase, accessToken, projectId)

// Simular quiet hours cambiando la hora del sistema
// O usar skipQuietHours: false y ejecutar a las 23:00

const result = await sender.send({
  title: 'Test',
  body: 'Test notification',
  notificationType: 'test',
  target: { userId: 'test-user-id' },
  skipQuietHours: false
})

console.log('Was queued:', result.wasQueued)
```

### Probar Procesamiento de Cola

```sql
-- Insertar notificación pendiente manualmente
INSERT INTO pending_notifications (
  user_id,
  title,
  body,
  notification_type,
  scheduled_for,
  status
) VALUES (
  'user-id',
  'Test',
  'Test notification',
  'test',
  NOW() - INTERVAL '1 minute', -- Ya debería procesarse
  'pending'
);

-- Esperar 5 minutos y verificar que se procesó
SELECT * FROM pending_notifications WHERE status = 'sent';
```

---

## 📝 Notas Importantes

1. **Quiet Hours:** Configuradas para 22:00 - 08:00. Puede modificarse en `smart-notification-sender.ts`

2. **Retry Logic:** Backoff exponencial: 2^retry_count minutos

3. **Límites:** 
   - `get_pending_notifications_ready()` procesa máximo 100 por ejecución
   - Ajustar según volumen esperado

4. **RLS:** Las políticas permiten que usuarios vean solo sus propias notificaciones

5. **Auditoría:** Las notificaciones pendientes NO se eliminan automáticamente después de enviarse (se mantienen para auditoría). Puede agregarse cleanup si es necesario.

---

## 🔐 Seguridad

- **RLS habilitado** en ambas tablas
- **Service Role Key** solo para Edge Functions (nunca exponer en cliente)
- **Validación de targets** (debe tener userId O topic, no ambos)
- **Funciones SECURITY DEFINER** para operaciones privilegiadas

---

## 📚 Referencias

- [Supabase Edge Functions](https://supabase.com/docs/guides/functions)
- [Firebase Cloud Messaging API V1](https://firebase.google.com/docs/cloud-messaging/server)
- [pg_cron Extension](https://github.com/citusdata/pg_cron)
