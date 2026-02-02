# 📱 Resumen Completo del Sistema de Notificaciones - QuePlan

## 📋 Índice
1. [Tipos de Notificaciones](#tipos-de-notificaciones)
2. [Arquitectura del Sistema](#arquitectura-del-sistema)
3. [Configuración de Usuario](#configuración-de-usuario)
4. [Edge Functions Backend](#edge-functions-backend)
5. [Flujo de Datos](#flujo-de-datos)
6. [Base de Datos](#base-de-datos)
7. [Configuración Técnica](#configuración-técnica)
8. [Estado de Implementación](#estado-de-implementación)

---

## 🔔 Tipos de Notificaciones

### 1. **Notificaciones de Moderación** (Administración)

#### ✅ Evento Aprobado
- **Cuándo:** Cuando un admin aprueba un evento creado por un usuario
- **Destinatario:** Usuario creador del evento (`created_by`)
- **Título:** `✅ Tu evento ha sido aprobado`
- **Cuerpo:** `"[Título del evento]" ya está publicado en QuePlan`
- **Navegación:** Abre `EventDetailScreen` del evento
- **Código:** `lib/services/admin_moderation_service.dart`

#### ❌ Evento Rechazado
- **Cuándo:** Cuando un admin rechaza un evento creado por un usuario
- **Destinatario:** Usuario creador del evento (`created_by`)
- **Título:** `❌ Tu evento ha sido rechazado`
- **Cuerpo:** `"[Título del evento]" ha sido rechazado: [motivo]`
- **Navegación:** Abre `MyEventsScreen`
- **Código:** `lib/services/admin_moderation_service.dart`

#### 🏢 Solicitud de Ownership de Venue
- **Cuándo:** Cuando un usuario solicita ser dueño de un venue
- **Destinatario:** Todos los administradores con tokens FCM
- **Título:** `Nueva solicitud de ownership de venue`
- **Cuerpo:** `[email] solicita ser dueño de "[nombre del venue]"`
- **Código:** `supabase/functions/notify_venue_ownership_request/index.ts`

---

### 2. **Notificaciones de Engagement** (Usuario Final)

#### ❤️ Recordatorio de Favoritos (24h antes)
- **Cuándo:** Diariamente a las 10:00 AM UTC, para eventos que empiezan mañana
- **Destinatario:** Usuarios que tienen el evento en favoritos
- **Título:** `¡Mañana es el gran día!`
- **Cuerpo:** `No te pierdas [Nombre Evento]`
- **Trigger:** CRON Job diario
- **Código:** `supabase/functions/send-favorite-reminders/index.ts`

#### ⚠️ Alerta de Modificación Crítica
- **Cuándo:** Cuando cambia la fecha, hora, lugar o estado (cancelado) de un evento
- **Destinatario:** Usuarios que tienen el evento en favoritos
- **Título:** `⚠️ Cambio importante en [Nombre Evento]`
- **Cuerpo:** `Se ha modificado el horario o lugar. Revisa los detalles.`
- **Trigger:** Database Webhook (UPDATE en tabla `events`)
- **Código:** `supabase/functions/handle-event-update/index.ts`

#### 🏙️ Nuevo Evento en Ciudad
- **Cuándo:** Cuando se publica un evento nuevo (`status` cambia de `pending` a `published`)
- **Destinatario:** Usuarios suscritos al topic FCM de esa ciudad
- **Título:** `¡Nuevo plan en [Ciudad]! 🌊`
- **Cuerpo:** `[Nombre Evento] acaba de publicarse.`
- **Trigger:** Database Webhook (UPDATE en tabla `events`)
- **Método:** FCM Topics (no requiere leer tokens individuales)
- **Código:** `supabase/functions/handle-event-update/index.ts`

---

## 🏗️ Arquitectura del Sistema

### Componentes Frontend (Flutter)

#### Servicios
1. **`FCMTokenService`** (`lib/services/fcm_token_service.dart`)
   - Gestiona tokens FCM del dispositivo
   - Guarda tokens en Supabase (`user_fcm_tokens`)
   - Maneja permisos de notificaciones
   - Elimina tokens inválidos automáticamente

2. **`FCMTopicService`** (`lib/services/fcm_topic_service.dart`)
   - Gestiona suscripciones a FCM Topics
   - Suscribe/desuscribe ciudades y categorías
   - Persiste preferencias en SharedPreferences
   - Normaliza nombres para topics válidos

3. **`NotificationSenderService`** (`lib/services/notification_sender_service.dart`)
   - Envía notificaciones desde el cliente
   - Maneja tokens inválidos (`UNREGISTERED`)
   - Intenta con múltiples tokens del usuario

4. **`NotificationHandler`** (`lib/services/notification_handler.dart`)
   - Procesa notificaciones recibidas
   - Navega a pantallas según el tipo
   - Maneja deep links

#### Pantallas
1. **`NotificationPreferencesScreen`** (`lib/ui/onboarding/notification_preferences_screen.dart`)
   - Pantalla de onboarding para configurar notificaciones
   - Selección de ciudades y categorías
   - Explicación simple de cuándo recibirán notificaciones

2. **`NotificationSettingsScreen`** (`lib/ui/notifications/notification_settings_screen.dart`)
   - Pantalla accesible desde el perfil
   - Permite cambiar preferencias en cualquier momento
   - Carga preferencias actuales

---

### Componentes Backend (Supabase)

#### Edge Functions
1. **`send-favorite-reminders`** (`supabase/functions/send-favorite-reminders/index.ts`)
   - Ejecutada por CRON Job diario
   - Busca eventos que empiezan mañana
   - Envía notificaciones a usuarios con favoritos

2. **`handle-event-update`** (`supabase/functions/handle-event-update/index.ts`)
   - Ejecutada por Database Webhook
   - Detecta cambios críticos y nuevas publicaciones
   - Envía notificaciones individuales o por topic

3. **`notify_venue_ownership_request`** (`supabase/functions/notify_venue_ownership_request/index.ts`)
   - Notifica a admins sobre solicitudes de ownership
   - Usa FCM API V1 con autenticación JWT

4. **`send_fcm_notification`** (`supabase/functions/send_fcm_notification/index.ts`)
   - Función genérica para enviar notificaciones
   - Usa FCM API Legacy (HTTP)

#### Database Triggers
- **`event_update_webhook`**: Trigger en tabla `events` que llama a `handle-event-update`
- **CRON Job**: Ejecuta `send-favorite-reminders` diariamente a las 10:00 AM UTC

---

## 👤 Configuración de Usuario

### Flujo de Onboarding
1. **Splash Video** → Siempre se muestra primero
2. **Permissions Onboarding** → Solicita permisos de ubicación y fotos
3. **Notification Preferences** → Configuración de ciudades y categorías (NUEVO)
4. **Dashboard** → Pantalla principal

### Pantalla de Configuración
- **Acceso:** Perfil → Preferencias de Notificaciones
- **Funcionalidad:**
  - Selección de ciudades (checkboxes)
  - Selección opcional de categorías (expandible)
  - Explicación de cuándo recibirán notificaciones
  - Guardado inmediato de preferencias

### Explicación Mostrada al Usuario

1. **Recordatorios de favoritos** ❤️
   - Te avisamos 24 horas antes de tus eventos favoritos

2. **Nuevos eventos en tus ciudades** 🏙️
   - Te notificamos cuando se publique un evento en las ciudades que selecciones

3. **Cambios importantes** ⚠️
   - Te avisamos si cambia la fecha, hora o lugar de tus eventos favoritos

---

## 🔄 Flujo de Datos

### Notificación de Evento Aprobado/Rechazado
```
Admin aprueba/rechaza evento
  ↓
AdminModerationService.approveEvent() / rejectEvent()
  ↓
Obtiene información del evento (title, created_by)
  ↓
NotificationSenderService.sendEventApprovedNotification()
  ↓
Obtiene tokens FCM del usuario creador
  ↓
Para cada token:
  - Invoca Edge Function: send_fcm_notification
  - Si token inválido (UNREGISTERED) → Elimina de BD
  - Si token válido → Envía notificación
  ↓
Usuario recibe notificación
  ↓
NotificationHandler procesa y navega
```

### Recordatorio de Favoritos (CRON)
```
CRON Job ejecuta (10:00 AM UTC)
  ↓
Edge Function: send-favorite-reminders
  ↓
Busca eventos que empiezan mañana (starts_at = hoy + 1 día)
  ↓
Para cada evento:
  - Busca usuarios con evento en favoritos
  - Obtiene tokens FCM de esos usuarios
  - Envía notificación a cada token
  ↓
Usuarios reciben notificación
```

### Cambio Crítico en Evento
```
Admin actualiza evento (fecha/hora/lugar)
  ↓
Database Trigger: event_update_webhook
  ↓
Edge Function: handle-event-update
  ↓
Detecta cambio crítico (starts_at, place, venue_id, status)
  ↓
Busca usuarios con evento en favoritos
  ↓
Obtiene tokens FCM y envía notificaciones
```

### Nuevo Evento Publicado
```
Admin publica evento (status: pending → published)
  ↓
Database Trigger: event_update_webhook
  ↓
Edge Function: handle-event-update
  ↓
Detecta cambio de status a 'published'
  ↓
Normaliza nombre de ciudad → topic FCM (ej: city_barbate)
  ↓
Envía notificación al topic FCM
  ↓
Todos los usuarios suscritos reciben notificación
```

---

## 🗄️ Base de Datos

### Tabla: `user_fcm_tokens`
Almacena tokens FCM de cada usuario para enviar notificaciones.

**Columnas:**
- `id`: UUID (PK)
- `user_id`: UUID (FK a `auth.users`)
- `token`: String (token FCM)
- `device_type`: String (`android`, `ios`, `web`)
- `device_info`: JSONB (información del dispositivo)
- `created_at`: Timestamp
- `updated_at`: Timestamp

**Índices:**
- `user_id` (para búsquedas rápidas)
- `user_id, token` (unique constraint)

**Limpieza:**
- Los tokens inválidos (`UNREGISTERED`) se eliminan automáticamente
- Se detectan en las respuestas de FCM y se eliminan de la BD

### Tabla: `user_favorites`
Almacena eventos marcados como favoritos por usuarios.

**Uso:**
- Para recordatorios 24h antes
- Para alertas de cambios críticos

### Tabla: `events`
Almacena información de eventos.

**Columnas relevantes:**
- `id`: UUID
- `title`: String
- `starts_at`: Timestamp
- `place`: String
- `venue_id`: UUID
- `status`: String (`pending`, `published`, `cancelled`)
- `city_name`: String (para FCM Topics)
- `city_id`: Integer
- `created_by`: UUID (FK a `auth.users`)

**Triggers:**
- `event_update_webhook`: Detecta cambios y llama a Edge Function

---

## ⚙️ Configuración Técnica

### Secrets en Supabase

1. **`FIREBASE_PROJECT_ID`**
   - ID del proyecto de Firebase
   - Ejemplo: `queplan-5b9da`

2. **`FIREBASE_SERVICE_ACCOUNT_KEY`**
   - JSON completo de la Service Account de Firebase
   - Debe tener permisos para Firebase Cloud Messaging
   - Usado para autenticación con FCM API V1

3. **`SUPABASE_SERVICE_ROLE_KEY`** (usado en triggers/CRON)
   - Service Role Key de Supabase
   - Usado para autenticar llamadas a Edge Functions desde triggers

4. **`SUPABASE_URL`** (usado en triggers/CRON)
   - URL de tu proyecto Supabase
   - Ejemplo: `https://xxxxx.supabase.co`

### FCM Topics

**Formato:**
- Ciudades: `city_[nombre_normalizado]`
  - Ejemplo: `city_barbate`, `city_zahara_de_los_atunes`
- Categorías: `category_[nombre_normalizado]`
  - Ejemplo: `category_musica`, `category_gastronomia`

**Normalización:**
- Convertir a minúsculas
- Reemplazar caracteres especiales con `_`
- Eliminar guiones bajos múltiples
- Eliminar guiones bajos al inicio/final

**Persistencia:**
- Guardado en SharedPreferences (Flutter)
- Sincronizado con FCM Topics automáticamente

### CRON Job

**Configuración:**
- **Nombre:** `send-favorite-reminders-daily`
- **Schedule:** `0 10 * * *` (10:00 AM UTC diariamente)
- **SQL:** Ejecuta HTTP POST a Edge Function

**Archivo:** `docs/migrations/040_setup_cron_job_completo.sql`

### Database Webhook

**Trigger:**
- **Tabla:** `events`
- **Evento:** `UPDATE`
- **Función:** `notify_event_update()`
- **Edge Function:** `handle-event-update`

**Archivo:** `docs/migrations/041_setup_event_update_webhook.sql`

---

## ✅ Estado de Implementación

### ✅ Completado

#### Frontend
- [x] Servicio FCM Token (`FCMTokenService`)
- [x] Servicio FCM Topics (`FCMTopicService`)
- [x] Servicio de envío de notificaciones (`NotificationSenderService`)
- [x] Handler de notificaciones (`NotificationHandler`)
- [x] Pantalla de onboarding de notificaciones
- [x] Pantalla de configuración en perfil
- [x] Integración en flujo de onboarding
- [x] Manejo de tokens inválidos
- [x] Navegación desde notificaciones

#### Backend
- [x] Edge Function: `send-favorite-reminders`
- [x] Edge Function: `handle-event-update`
- [x] Edge Function: `notify_venue_ownership_request`
- [x] Edge Function: `send_fcm_notification`
- [x] Database Trigger: `event_update_webhook`
- [x] CRON Job: `send-favorite-reminders-daily`
- [x] Autenticación FCM API V1 con JWT
- [x] Manejo de tokens inválidos en backend

#### Notificaciones
- [x] Evento aprobado
- [x] Evento rechazado
- [x] Solicitud de ownership de venue
- [x] Recordatorio de favoritos (24h antes)
- [x] Alerta de modificación crítica
- [x] Nuevo evento en ciudad (FCM Topics)

### ⏳ Pendiente

- [ ] Configuración de APNs para iOS
- [ ] Pruebas end-to-end completas
- [ ] Monitoreo y métricas de notificaciones
- [ ] Rate limiting para evitar spam
- [ ] Notificaciones por categorías (filtrado)

---

## 🧪 Cómo Probar

### 1. Probar Recordatorio de Favoritos
```bash
# Ejecutar manualmente la Edge Function
curl -X POST \
  'https://[TU-PROJECT-REF].supabase.co/functions/v1/send-favorite-reminders' \
  -H 'Authorization: Bearer [TU-ANON-KEY]' \
  -H 'Content-Type: application/json'
```

### 2. Probar Cambio Crítico
```sql
-- Actualizar fecha de un evento que tengas en favoritos
UPDATE events 
SET starts_at = NOW() + INTERVAL '3 days'
WHERE id = 'tu-event-id';
```

### 3. Probar Nuevo Evento Publicado
```sql
-- Publicar un evento nuevo
UPDATE events 
SET status = 'published'
WHERE id = 'nuevo-event-id' AND status = 'pending';
```

### 4. Verificar Suscripciones FCM Topics
- Firebase Console → Cloud Messaging → Topics
- Deberías ver topics como `city_barbate`, `city_zahara`, etc.

---

## 📊 Monitoreo

### Logs de Edge Functions
- **Ubicación:** Supabase Dashboard → Edge Functions → [Función] → Logs
- **Información:** Errores, tokens inválidos, notificaciones enviadas

### Logs de CRON Job
- **Ubicación:** Supabase Dashboard → Database → Cron Jobs → [Job] → History
- **Información:** Ejecuciones, errores, tiempos de ejecución

### Firebase Console
- **Cloud Messaging:** Ver estadísticas de notificaciones enviadas
- **Topics:** Ver suscripciones activas por topic

---

## 🔧 Troubleshooting

### Tokens Inválidos
- **Síntoma:** Notificaciones no llegan
- **Solución:** Los tokens `UNREGISTERED` se eliminan automáticamente
- **Verificación:** Revisar logs de Edge Functions

### Notificaciones No Llegan
- **Verificar:** Tokens FCM válidos en `user_fcm_tokens`
- **Verificar:** Permisos de notificaciones en el dispositivo
- **Verificar:** Conexión a internet
- **Verificar:** Logs de Edge Functions para errores

### CRON Job No Ejecuta
- **Verificar:** Extensión `pg_cron` habilitada
- **Verificar:** Configuración del schedule
- **Verificar:** Service Role Key correcta en el SQL

### Webhook No Se Dispara
- **Verificar:** Trigger `event_update_webhook` existe
- **Verificar:** Función `notify_event_update()` existe
- **Verificar:** Extensión `pg_net` habilitada

---

## 📚 Referencias

- [Documentación de Notificaciones](./NOTIFICACIONES.md)
- [Configuración de Engagement](./CONFIGURACION_NOTIFICACIONES_ENGAGEMENT.md)
- [Resumen de Configuración](./RESUMEN_CONFIGURACION_NOTIFICACIONES.md)
- [Supabase Edge Functions Docs](https://supabase.com/docs/guides/functions)
- [Firebase Cloud Messaging API](https://firebase.google.com/docs/cloud-messaging/server)
- [FCM Topics](https://firebase.google.com/docs/cloud-messaging/send-message#send-messages-to-topics)

---

**Última actualización:** Febrero 2026
