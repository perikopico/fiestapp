# 📱 Resumen de Notificaciones Push

Este documento describe todas las notificaciones push que se envían en la aplicación QuePlan.

## 🔔 Tipos de Notificaciones

### 1. **Evento Aprobado** ✅
**Cuándo se envía:** Cuando un administrador aprueba un evento creado por un usuario.

**Destinatario:** Usuario que creó el evento (`created_by`)

**Contenido:**
- **Título:** `✅ Tu evento ha sido aprobado`
- **Cuerpo:** `"[Título del evento]" ya está publicado en QuePlan`
- **Datos:**
  - `type`: `event_approved`
  - `event_id`: ID del evento aprobado
  - `route`: `/event_detail`

**Navegación:** Al tocar la notificación, abre la pantalla de detalle del evento (`EventDetailScreen`)

**Código:** `lib/services/admin_moderation_service.dart` → `approveEvent()` → `NotificationSenderService.sendEventApprovedNotification()`

---

### 2. **Evento Rechazado** ❌
**Cuándo se envía:** Cuando un administrador rechaza un evento creado por un usuario.

**Destinatario:** Usuario que creó el evento (`created_by`)

**Contenido:**
- **Título:** `❌ Tu evento ha sido rechazado`
- **Cuerpo:** 
  - Con motivo: `"[Título del evento]" ha sido rechazado: [motivo]`
  - Sin motivo: `"[Título del evento]" ha sido rechazado`
- **Datos:**
  - `type`: `event_rejected`
  - `event_id`: ID del evento rechazado
  - `route`: `/my_events`

**Navegación:** Al tocar la notificación, abre la pantalla de "Mis Eventos" (`MyEventsScreen`)

**Código:** `lib/services/admin_moderation_service.dart` → `rejectEvent()` → `NotificationSenderService.sendEventRejectedNotification()`

---

### 3. **Solicitud de Ownership de Venue** 🏢
**Cuándo se envía:** Cuando un usuario solicita ser dueño de un venue (lugar/recinto).

**Destinatario:** Todos los administradores que tengan tokens FCM registrados

**Contenido:**
- **Título:** `Nueva solicitud de ownership de venue`
- **Cuerpo:** `[email del usuario] solicita ser dueño de "[nombre del venue]"`
- **Datos:**
  - `type`: `venue_ownership_request`
  - `request_id`: ID de la solicitud
  - `venue_id`: ID del venue
  - `venue_name`: Nombre del venue
  - `user_id`: ID del usuario solicitante
  - `user_email`: Email del usuario solicitante
  - `verification_method`: Método de verificación
  - `contact_info`: Información de contacto
  - `verification_code`: Código de verificación

**Navegación:** La navegación específica depende de la implementación en el panel de administración.

**Código:** `supabase/functions/notify_venue_ownership_request/index.ts`

**Nota:** Esta notificación se envía desde una Edge Function de Supabase, no desde el cliente Flutter.

---

## 🔧 Componentes del Sistema de Notificaciones

### Servicios Flutter

1. **`NotificationSenderService`** (`lib/services/notification_sender_service.dart`)
   - Servicio principal para enviar notificaciones
   - Métodos:
     - `sendToToken()`: Envía a un token FCM específico
     - `sendToUser()`: Envía a todos los tokens de un usuario
     - `sendEventApprovedNotification()`: Notificación de evento aprobado
     - `sendEventRejectedNotification()`: Notificación de evento rechazado
   - **Características:**
     - Elimina automáticamente tokens FCM inválidos (`UNREGISTERED`)
     - Intenta con todos los tokens del usuario hasta encontrar uno válido

2. **`AdminModerationService`** (`lib/services/admin_moderation_service.dart`)
   - Maneja la aprobación/rechazo de eventos
   - Llama a `NotificationSenderService` después de aprobar/rechazar

3. **`NotificationHandler`** (`lib/services/notification_handler.dart`)
   - Maneja las notificaciones recibidas
   - Navega a la pantalla correspondiente según el `type` y `event_id`

### Edge Functions de Supabase

1. **`send_fcm_notification`** (`supabase/functions/send_fcm_notification/index.ts`)
   - Edge Function genérica para enviar notificaciones FCM
   - Usa Firebase Cloud Messaging API Legacy (HTTP)
   - Requiere secret: `FCM_LEGACY_SERVER_KEY`

2. **`notify_venue_ownership_request`** (`supabase/functions/notify_venue_ownership_request/index.ts`)
   - Edge Function específica para notificar solicitudes de ownership
   - Usa Firebase Cloud Messaging API V1 (con JWT)
   - Requiere secrets: `FIREBASE_PROJECT_ID`, `FIREBASE_SERVICE_ACCOUNT_KEY`

## 📊 Flujo de Notificaciones

### Notificación de Evento Aprobado/Rechazado

```
1. Admin aprueba/rechaza evento
   ↓
2. AdminModerationService.approveEvent() / rejectEvent()
   ↓
3. Obtiene información del evento (title, created_by)
   ↓
4. NotificationSenderService.sendEventApprovedNotification() / sendEventRejectedNotification()
   ↓
5. Obtiene todos los tokens FCM del usuario creador
   ↓
6. Para cada token:
   - NotificationSenderService.sendToToken()
   - Invoca Edge Function: send_fcm_notification
   - Si token inválido (UNREGISTERED) → Elimina de BD
   - Si token válido → Envía notificación
   ↓
7. Usuario recibe notificación
   ↓
8. NotificationHandler procesa la notificación
   ↓
9. Navega a EventDetailScreen o MyEventsScreen según el tipo
```

### Notificación de Solicitud de Ownership

```
1. Usuario solicita ownership de venue
   ↓
2. Se crea registro en venue_ownership_requests
   ↓
3. Se invoca Edge Function: notify_venue_ownership_request
   ↓
4. Edge Function:
   - Obtiene información de la solicitud
   - Obtiene todos los administradores
   - Obtiene tokens FCM de todos los admins
   ↓
5. Para cada admin con token:
   - Envía notificación FCM usando API V1
   ↓
6. Admins reciben notificación
```

## 🗄️ Base de Datos

### Tabla: `user_fcm_tokens`
Almacena los tokens FCM de cada usuario para poder enviarles notificaciones.

**Columnas:**
- `id`: UUID (PK)
- `user_id`: UUID (FK a auth.users)
- `token`: String (token FCM)
- `created_at`: Timestamp
- `updated_at`: Timestamp

**Nota:** Los tokens inválidos se eliminan automáticamente cuando Firebase devuelve `UNREGISTERED`.

## ⚙️ Configuración Requerida

### Secrets en Supabase

1. **`FIREBASE_PROJECT_ID`**
   - ID del proyecto de Firebase
   - Ejemplo: `queplan-5b9da`

2. **`FIREBASE_SERVICE_ACCOUNT_KEY`**
   - JSON completo de la Service Account de Firebase
   - Usado para autenticación con FCM API V1
   - Se usa en `notify_venue_ownership_request`

3. **`FCM_LEGACY_SERVER_KEY`** (opcional)
   - Clave de servidor heredada de Firebase Cloud Messaging
   - Se usa en `send_fcm_notification` si está disponible

## 📱 Plataformas Soportadas

- ✅ **Android:** Completamente funcional
- ⏳ **iOS:** Pendiente de configuración (requiere APNs)

## 🔍 Manejo de Errores

### Tokens Inválidos
- Cuando Firebase devuelve `UNREGISTERED`, el token se elimina automáticamente de la BD
- El sistema intenta con todos los tokens del usuario hasta encontrar uno válido
- Si ningún token es válido, la notificación no se envía (pero el evento se aprueba/rechaza igualmente)

### Eventos sin Creador
- Si un evento no tiene `created_by` (creado sin autenticación), no se envía notificación
- Se registra un warning en los logs

## 📝 Notas Importantes

1. **Tokens múltiples:** Un usuario puede tener múltiples tokens FCM (diferentes dispositivos)
2. **Limpieza automática:** Los tokens inválidos se eliminan automáticamente
3. **No bloqueante:** Si falla el envío de notificación, el proceso de aprobación/rechazo continúa normalmente
4. **Navegación:** Las notificaciones incluyen datos para navegar a la pantalla correcta al tocarlas
