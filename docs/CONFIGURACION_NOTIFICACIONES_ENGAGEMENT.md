# 📱 Configuración de Notificaciones de Engagement

Este documento explica cómo configurar las Edge Functions para notificaciones de engagement usando Firebase Cloud Messaging (FCM).

## 🎯 Escenarios Implementados

### 1. Recordatorio de Favoritos (24h antes)
**Edge Function:** `send-favorite-reminders`  
**Tipo:** Scheduled Function (CRON)  
**Frecuencia:** Diaria a las 10:00 AM UTC

### 2. Alerta de Modificación Crítica
**Edge Function:** `handle-event-update`  
**Tipo:** Database Webhook  
**Trigger:** UPDATE en tabla `events`

### 3. Nuevo Evento en Ciudad (FCM Topics)
**Edge Function:** `handle-event-update` (mismo webhook)  
**Tipo:** Database Webhook  
**Trigger:** UPDATE cuando `status` cambia de `pending` a `published`

---

## 📋 Requisitos Previos

### Secrets en Supabase

Asegúrate de tener configurados estos secrets en el Dashboard de Supabase:

1. **`FIREBASE_PROJECT_ID`**
   - ID de tu proyecto de Firebase
   - Ejemplo: `queplan-5b9da`

2. **`FIREBASE_SERVICE_ACCOUNT_KEY`**
   - JSON completo de la Service Account de Firebase
   - Debe tener permisos para Firebase Cloud Messaging

**Cómo configurarlos:**
1. Ve a **Supabase Dashboard** → Tu proyecto → **Settings** → **Edge Functions**
2. En la sección **Secrets**, agrega cada secret con su valor

---

## 🚀 Despliegue de Edge Functions

### Opción 1: Usando Supabase CLI (Recomendado)

```bash
# Instalar Supabase CLI si no lo tienes
npm install -g supabase

# Login en Supabase
supabase login

# Enlazar tu proyecto local con Supabase
supabase link --project-ref tu-project-ref

# Desplegar las funciones
supabase functions deploy send-favorite-reminders
supabase functions deploy handle-event-update
```

### Opción 2: Usando el Dashboard de Supabase

1. Ve a **Supabase Dashboard** → Tu proyecto → **Edge Functions**
2. Haz clic en **Create a new function**
3. Nombre: `send-favorite-reminders`
4. Copia el contenido de `supabase/functions/send-favorite-reminders/index.ts`
5. Haz clic en **Deploy**
6. Repite para `handle-event-update`

---

## ⏰ Configuración del CRON Job (Escenario 1)

### Paso 1: Crear el CRON Job en Supabase

1. Ve a **Supabase Dashboard** → Tu proyecto → **Database** → **Cron Jobs**
2. Haz clic en **Create a new cron job**
3. Configura:
   - **Name:** `send-favorite-reminders-daily`
   - **Schedule:** `0 10 * * *` (10:00 AM UTC diariamente)
   - **SQL Command:**
   ```sql
   SELECT net.http_post(
     url := 'https://[TU-PROJECT-REF].supabase.co/functions/v1/send-favorite-reminders',
     headers := jsonb_build_object(
       'Content-Type', 'application/json',
       'Authorization', 'Bearer [TU-SERVICE-ROLE-KEY]'
     ),
     body := '{}'::jsonb
   ) AS request_id;
   ```
   - Reemplaza `[TU-PROJECT-REF]` con tu project reference
   - Reemplaza `[TU-SERVICE-ROLE-KEY]` con tu Service Role Key (encuéntralo en Settings → API)

### Paso 2: Verificar el CRON Job

Después de crear el cron job, puedes probarlo manualmente ejecutando el SQL:

```sql
SELECT net.http_post(
  url := 'https://[TU-PROJECT-REF].supabase.co/functions/v1/send-favorite-reminders',
  headers := jsonb_build_object(
    'Content-Type', 'application/json',
    'Authorization', 'Bearer [TU-SERVICE-ROLE-KEY]'
  ),
  body := '{}'::jsonb
) AS request_id;
```

---

## 🔗 Configuración de Webhooks (Escenarios 2 y 3)

### Paso 1: Habilitar la extensión `pg_net` (si no está habilitada)

```sql
-- Verificar si está habilitada
SELECT * FROM pg_available_extensions WHERE name = 'pg_net';

-- Si no está, habilitarla
CREATE EXTENSION IF NOT EXISTS pg_net;
```

### Paso 2: Crear el Trigger en la tabla `events`

```sql
-- Función que será llamada cuando se actualice un evento
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
    PERFORM net.http_post(
      url := 'https://[TU-PROJECT-REF].supabase.co/functions/v1/handle-event-update',
      headers := jsonb_build_object(
        'Content-Type', 'application/json',
        'Authorization', 'Bearer [TU-SERVICE-ROLE-KEY]'
      ),
      body := payload
    );
  END IF;
  
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Crear el trigger
DROP TRIGGER IF EXISTS event_update_webhook ON events;
CREATE TRIGGER event_update_webhook
  AFTER UPDATE ON events
  FOR EACH ROW
  EXECUTE FUNCTION notify_event_update();
```

**Importante:** Reemplaza `[TU-PROJECT-REF]` y `[TU-SERVICE-ROLE-KEY]` con tus valores reales.

### Paso 3: Verificar el Trigger

Puedes probar el trigger actualizando un evento:

```sql
-- Probar cambio crítico
UPDATE events 
SET starts_at = NOW() + INTERVAL '2 days'
WHERE id = 'algún-event-id';

-- Probar publicación de evento
UPDATE events 
SET status = 'published'
WHERE id = 'algún-event-id' AND status = 'pending';
```

---

## 📱 Configuración en Flutter (FCM Topics)

Para que los usuarios reciban notificaciones por ciudad, necesitas suscribirlos al topic correspondiente cuando se registren o cambien su ciudad preferida.

### Ejemplo de código Flutter:

```dart
import 'package:firebase_messaging/firebase_messaging.dart';

class FCMTopicService {
  final FirebaseMessaging _messaging = FirebaseMessaging.instance;

  /// Suscribir usuario a notificaciones de una ciudad
  Future<void> subscribeToCity(String cityName) async {
    // Normalizar nombre de ciudad (igual que en la Edge Function)
    final normalizedCity = cityName
        .toLowerCase()
        .replaceAll(RegExp(r'[^a-z0-9]'), '_')
        .replaceAll(RegExp(r'_+'), '_')
        .replaceAll(RegExp(r'^_|_$'), '');
    
    final topic = 'city_$normalizedCity';
    
    try {
      await _messaging.subscribeToTopic(topic);
      print('✅ Suscrito al topic: $topic');
    } catch (e) {
      print('❌ Error al suscribirse al topic: $e');
    }
  }

  /// Desuscribir usuario de una ciudad
  Future<void> unsubscribeFromCity(String cityName) async {
    final normalizedCity = cityName
        .toLowerCase()
        .replaceAll(RegExp(r'[^a-z0-9]'), '_')
        .replaceAll(RegExp(r'_+'), '_')
        .replaceAll(RegExp(r'^_|_$'), '');
    
    final topic = 'city_$normalizedCity';
    
    try {
      await _messaging.unsubscribeFromTopic(topic);
      print('✅ Desuscrito del topic: $topic');
    } catch (e) {
      print('❌ Error al desuscribirse del topic: $e');
    }
  }
}
```

### Uso en la app:

```dart
// Cuando el usuario selecciona una ciudad
void onCitySelected(String cityName) async {
  final topicService = FCMTopicService();
  await topicService.subscribeToCity(cityName);
}

// Cuando el usuario cambia de ciudad
void onCityChanged(String oldCity, String newCity) async {
  final topicService = FCMTopicService();
  await topicService.unsubscribeFromCity(oldCity);
  await topicService.subscribeToCity(newCity);
}
```

---

## 🧪 Pruebas

### Probar Recordatorio de Favoritos

1. Crea un evento que empiece mañana
2. Marca ese evento como favorito con un usuario
3. Asegúrate de que el usuario tenga un token FCM válido
4. Ejecuta manualmente la función:
   ```bash
   curl -X POST \
     'https://[TU-PROJECT-REF].supabase.co/functions/v1/send-favorite-reminders' \
     -H 'Authorization: Bearer [TU-ANON-KEY]' \
     -H 'Content-Type: application/json'
   ```

### Probar Cambio Crítico

1. Actualiza un evento que tengas en favoritos:
   ```sql
   UPDATE events 
   SET starts_at = NOW() + INTERVAL '3 days'
   WHERE id = 'tu-event-id';
   ```
2. Deberías recibir una notificación de cambio crítico

### Probar Nuevo Evento en Ciudad

1. Publica un evento nuevo:
   ```sql
   UPDATE events 
   SET status = 'published'
   WHERE id = 'nuevo-event-id' AND status = 'pending';
   ```
2. Si estás suscrito al topic de esa ciudad, deberías recibir la notificación

---

## 📊 Monitoreo y Logs

### Ver logs de Edge Functions

1. Ve a **Supabase Dashboard** → Tu proyecto → **Edge Functions**
2. Selecciona la función que quieres revisar
3. Haz clic en **Logs** para ver los logs en tiempo real

### Ver logs del CRON Job

1. Ve a **Supabase Dashboard** → Tu proyecto → **Database** → **Cron Jobs**
2. Selecciona tu cron job
3. Revisa el historial de ejecuciones

---

## 🔧 Troubleshooting

### Error: "Firebase credentials not configured"
- Verifica que los secrets `FIREBASE_PROJECT_ID` y `FIREBASE_SERVICE_ACCOUNT_KEY` estén configurados en Supabase

### Error: "Failed to get access token"
- Verifica que el JSON de la Service Account sea válido
- Asegúrate de que la Service Account tenga permisos para Firebase Cloud Messaging

### Las notificaciones no llegan
- Verifica que los tokens FCM sean válidos
- Revisa los logs de la Edge Function para ver errores específicos
- Asegúrate de que el dispositivo tenga conexión a internet
- Verifica que la app tenga permisos de notificaciones

### Los tokens inválidos no se eliminan
- La función debería eliminar automáticamente tokens con error `UNREGISTERED`
- Revisa los logs para confirmar que se están detectando correctamente

---

## 📝 Notas Importantes

1. **FCM Topics:** Los topics deben seguir el formato `city_[nombre_normalizado]`
2. **Tokens inválidos:** Se eliminan automáticamente cuando FCM devuelve `UNREGISTERED`
3. **Horario CRON:** El cron job está configurado para UTC. Ajusta según tu zona horaria si es necesario
4. **Límites de FCM:** Firebase tiene límites de tasa. Si envías muchas notificaciones, considera usar batching

---

## 🔐 Seguridad

- **Service Role Key:** Nunca expongas tu Service Role Key en el código del cliente
- **Secrets:** Los secrets solo deben estar en Supabase Dashboard, nunca en el código
- **Validación:** Las Edge Functions validan las credenciales antes de procesar

---

## 📚 Referencias

- [Supabase Edge Functions Docs](https://supabase.com/docs/guides/functions)
- [Firebase Cloud Messaging API](https://firebase.google.com/docs/cloud-messaging/server)
- [FCM Topics](https://firebase.google.com/docs/cloud-messaging/send-message#send-messages-to-topics)
