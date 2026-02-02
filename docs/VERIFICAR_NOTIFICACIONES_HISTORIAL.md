# 🔍 Verificación: Notificaciones en Historial

## Problema
Las notificaciones no aparecen en el buzón de notificaciones.

## Solución Implementada

### 1. Backend (Edge Functions)
He actualizado las Edge Functions para que guarden en `notifications_history`:
- ✅ `handle-event-update`: Guarda notificaciones de cambio crítico
- ✅ `send-favorite-reminders`: Guarda recordatorios de favoritos
- ✅ `handle-event-update`: Guarda notificaciones por topic (pero sin user_id)

### 2. Frontend (Flutter)
He agregado lógica para guardar notificaciones recibidas:
- ✅ `NotificationHandler`: Guarda notificaciones cuando se reciben
- ✅ Evita duplicados verificando si ya existe en las últimas 24 horas

## ⚠️ IMPORTANTE: Desplegar Edge Functions Actualizadas

Las Edge Functions necesitan ser redesplegadas para que los cambios surtan efecto:

```bash
npx supabase functions deploy handle-event-update
npx supabase functions deploy send-favorite-reminders
```

## Verificación

### 1. Verificar que las notificaciones se están guardando

Ejecuta en SQL Editor:

```sql
-- Ver las últimas notificaciones guardadas
SELECT 
  id,
  user_id,
  title,
  body,
  notification_type,
  sent_at,
  delivery_status
FROM notifications_history
ORDER BY sent_at DESC
LIMIT 20;
```

### 2. Verificar notificaciones de tu usuario

```sql
-- Reemplaza 'TU-USER-ID' con tu user_id real
SELECT 
  id,
  title,
  body,
  notification_type,
  sent_at,
  read_at,
  delivery_status
FROM notifications_history
WHERE user_id = 'TU-USER-ID'
ORDER BY sent_at DESC;
```

### 3. Verificar que el buzón carga correctamente

En la app, abre el panel de notificaciones y verifica:
- Si hay notificaciones en la BD pero no aparecen → Problema de consulta
- Si no hay notificaciones en la BD → Problema de guardado en Edge Functions

## Troubleshooting

### Las notificaciones no se guardan en historial

1. **Verificar logs de Edge Functions:**
   - Supabase Dashboard → Edge Functions → `handle-event-update` → Logs
   - Buscar errores relacionados con `saveNotificationToHistory`

2. **Verificar permisos RLS:**
   ```sql
   -- Verificar políticas RLS
   SELECT * FROM pg_policies 
   WHERE tablename = 'notifications_history';
   ```

3. **Verificar que la tabla existe:**
   ```sql
   SELECT COUNT(*) FROM notifications_history;
   ```

### Las notificaciones se guardan pero no aparecen en el buzón

1. **Verificar que el usuario está autenticado:**
   - La consulta filtra por `user_id`
   - Si el usuario no está autenticado, no aparecerán

2. **Verificar la consulta:**
   ```sql
   -- Probar la consulta manualmente
   SELECT * FROM notifications_history
   WHERE user_id = 'TU-USER-ID'
     AND read_at IS NULL
   ORDER BY sent_at DESC;
   ```

3. **Verificar errores en la app:**
   - Revisar logs de Flutter
   - Buscar errores relacionados con `notifications_inbox_screen`

## Notas Importantes

1. **Notificaciones por Topic:** Las notificaciones enviadas por topic (como "nuevo evento en ciudad") se guardan con `topic_name` pero sin `user_id`. Estas NO aparecerán en el buzón individual del usuario a menos que se implemente lógica adicional para asociarlas con usuarios suscritos.

2. **Duplicados:** El sistema evita duplicados verificando si existe una notificación similar en las últimas 24 horas.

3. **Despliegue:** Los cambios en las Edge Functions requieren redesplegar las funciones para que surtan efecto.
