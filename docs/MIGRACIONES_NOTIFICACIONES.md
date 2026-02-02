# 📋 Guía de Migraciones: Sistema de Notificaciones Robusto

## ✅ Migraciones a Ejecutar

Debes ejecutar **2 migraciones SQL** en este orden:

### 1️⃣ Migración 042: Crear Tablas y Funciones
**Archivo:** `docs/migrations/042_create_notifications_system.sql`

**Qué hace:**
- Crea tabla `notifications_history` (buzón de notificaciones)
- Crea tabla `pending_notifications` (cola de espera)
- Crea índices optimizados
- Configura RLS (Row Level Security)
- Crea funciones auxiliares:
  - `get_unread_notifications()`
  - `mark_notification_as_read()`
  - `get_pending_notifications_ready()`

**Cómo ejecutar:**
1. Ve a **Supabase Dashboard** → Tu proyecto → **SQL Editor**
2. Abre el archivo `docs/migrations/042_create_notifications_system.sql`
3. Copia todo el contenido
4. Pégalo en el SQL Editor
5. Haz clic en **Run** o presiona `Ctrl+Enter`

**Tiempo estimado:** 5-10 segundos

---

### 2️⃣ Migración 043: Configurar CRON Job
**Archivo:** `docs/migrations/043_setup_process_pending_notifications_cron.sql`

**Qué hace:**
- Habilita extensiones `pg_cron` y `pg_net` (si no están habilitadas)
- Crea CRON job que ejecuta cada 5 minutos
- El CRON procesa automáticamente notificaciones pendientes

**⚠️ IMPORTANTE: Antes de ejecutar, debes reemplazar:**

1. **`[TU-PROJECT-REF]`** → Tu Project Reference de Supabase
   - Lo encuentras en: Dashboard → Settings → General → Reference ID
   - Ejemplo: `oudofaiekedtaovrdqeo`

2. **`[TU-SERVICE-ROLE-KEY]`** → Tu Service Role Key
   - Lo encuentras en: Dashboard → Settings → API → `service_role` key
   - ⚠️ **NUNCA** compartas esta clave públicamente

**Cómo ejecutar:**
1. Abre el archivo `docs/migrations/043_setup_process_pending_notifications_cron.sql`
2. Busca y reemplaza los placeholders:
   ```sql
   -- Buscar:
   'https://[TU-PROJECT-REF].supabase.co/functions/v1/process-pending-notifications'
   'Bearer [TU-SERVICE-ROLE-KEY]'
   
   -- Reemplazar con tus valores reales:
   'https://oudofaiekedtaovrdqeo.supabase.co/functions/v1/process-pending-notifications'
   'Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...' (tu key completa)
   ```
3. Copia el contenido modificado
4. Pégalo en Supabase SQL Editor
5. Ejecuta

**Tiempo estimado:** 2-3 segundos

---

## 🚀 Después de las Migraciones

### 1. Desplegar Edge Functions

```bash
# Desde la raíz del proyecto
npx supabase functions deploy process-pending-notifications
```

### 2. Verificar que el CRON Job se Creó

Ejecuta esta consulta en SQL Editor:

```sql
SELECT 
  jobid,
  schedule,
  command,
  active
FROM cron.job
WHERE jobname = 'process-pending-notifications-job';
```

Deberías ver:
- `schedule`: `*/5 * * * *` (cada 5 minutos)
- `active`: `true`

### 3. Verificar que las Tablas se Crearon

```sql
-- Verificar notifications_history
SELECT COUNT(*) FROM notifications_history;

-- Verificar pending_notifications
SELECT COUNT(*) FROM pending_notifications;

-- Verificar funciones
SELECT routine_name 
FROM information_schema.routines 
WHERE routine_schema = 'public' 
  AND routine_name IN (
    'get_unread_notifications',
    'mark_notification_as_read',
    'get_pending_notifications_ready'
  );
```

---

## ✅ Checklist de Verificación

- [ ] Migración 042 ejecutada sin errores
- [ ] Tabla `notifications_history` existe
- [ ] Tabla `pending_notifications` existe
- [ ] Funciones auxiliares creadas
- [ ] Migración 043 ejecutada sin errores (con placeholders reemplazados)
- [ ] CRON job creado y activo
- [ ] Edge Function `process-pending-notifications` desplegada
- [ ] Secrets configurados (`FIREBASE_PROJECT_ID`, `FIREBASE_SERVICE_ACCOUNT_KEY`)

---

## 🧪 Prueba Rápida

Después de ejecutar las migraciones, puedes probar insertando una notificación de prueba:

```sql
-- Insertar notificación de prueba en historial
INSERT INTO notifications_history (
  user_id,
  title,
  body,
  notification_type,
  delivery_status
) VALUES (
  (SELECT id FROM auth.users LIMIT 1), -- Reemplaza con un user_id real
  'Notificación de Prueba',
  'Esta es una notificación de prueba del sistema',
  'test',
  'sent'
);

-- Verificar que se insertó
SELECT * FROM notifications_history WHERE notification_type = 'test';
```

---

## 📝 Notas Importantes

1. **Orden de ejecución:** Debes ejecutar primero la 042 y luego la 043
2. **Service Role Key:** Es muy sensible, úsala solo en el SQL del CRON job
3. **pg_cron:** Si tu proyecto no tiene `pg_cron` habilitado, la migración 043 lo habilitará automáticamente
4. **Backup:** Considera hacer un backup antes de ejecutar migraciones en producción

---

## 🆘 Troubleshooting

### Error: "extension pg_cron does not exist"
- La migración 043 debería habilitarlo automáticamente
- Si persiste, ejecuta manualmente: `CREATE EXTENSION IF NOT EXISTS pg_cron;`

### Error: "permission denied for schema cron"
- Necesitas permisos de superusuario
- En Supabase Cloud, esto debería funcionar automáticamente

### El CRON no se ejecuta
- Verifica que `active = true` en la tabla `cron.job`
- Revisa los logs de Supabase para errores
- Verifica que la Edge Function esté desplegada correctamente

---

## 📚 Referencias

- Documentación completa: `docs/NOTIFICACIONES_SISTEMA_ROBUSTO.md`
- Código del módulo compartido: `supabase/functions/_shared/smart-notification-sender.ts`
