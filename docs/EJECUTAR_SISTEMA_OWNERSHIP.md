# ⚠️ EJECUTAR EN SUPABASE - Sistema de Ownership de Venues

**Fecha**: Enero 2025  
**Prioridad**: 🔴 CRÍTICO - Sin esto el sistema de ownership NO funcionará

---

## 📋 Resumen

Para que el sistema de ownership de venues funcione correctamente, necesitas ejecutar:

1. **Migración SQL** (obligatorio) - `011_create_venue_ownership_system.sql`
2. **Edge Function** (opcional pero recomendado) - `notify_venue_ownership_request`

---

## ✅ Paso 1: Ejecutar Migración SQL (OBLIGATORIO)

### Dependencias Previas

Antes de ejecutar la migración 011, asegúrate de que estas migraciones ya están ejecutadas:

- ✅ `001_create_auth_tables.sql` - Tabla `admins` (probablemente ya ejecutada)
- ✅ `005_create_venues_system.sql` - Tabla `venues` y función `update_updated_at_column()` (probablemente ya ejecutada)

**Si no estás seguro**, ejecuta primero la migración 005 (es segura, usa `IF NOT EXISTS`).

### Instrucciones

1. **Abre Supabase Dashboard**
   - Ve a tu proyecto en https://supabase.com
   - Navega a **SQL Editor** (menú lateral izquierdo)

2. **Abre el archivo de migración**
   - Archivo: `docs/migrations/011_create_venue_ownership_system.sql`
   - Copia TODO el contenido del archivo

3. **Pega y ejecuta en SQL Editor**
   - Pega el contenido completo en el editor
   - Haz clic en **RUN** o presiona `Ctrl+Enter` (Windows/Linux) o `Cmd+Enter` (Mac)
   - Espera a que termine la ejecución

4. **Verifica que no hay errores**
   - Deberías ver un mensaje de éxito
   - Si hay errores, léelos cuidadosamente
   - Los errores más comunes:
     - Si dice que falta la tabla `venues` → Ejecuta primero `005_create_venues_system.sql`
     - Si dice que falta la función `update_updated_at_column()` → Ejecuta primero `005_create_venues_system.sql`

### ¿Qué crea esta migración?

- ✅ Tabla `venue_ownership_requests` - Solicitudes de ownership
- ✅ Tabla `admin_notifications` - Notificaciones para admins
- ✅ Campos nuevos en `venues` (owner_id, verified_at, verified_by)
- ✅ Campos nuevos en `events` (owner_approved, owner_approved_at, owner_rejected_reason)
- ✅ 5 funciones SQL:
  - `generate_verification_code()` - Genera códigos únicos
  - `create_venue_ownership_request()` - Crea solicitudes
  - `verify_venue_ownership()` - Verifica códigos
  - `reject_venue_ownership()` - Rechaza solicitudes
  - `approve_event_by_owner()` - Aprobación de eventos por dueños
- ✅ Políticas RLS (Row Level Security)
- ✅ Triggers para actualización automática
- ✅ Vista `venue_ownership_view` para consultas

### Verificación Post-Ejecución

Después de ejecutar, verifica que todo se creó correctamente:

```sql
-- Verificar que las tablas existen
SELECT table_name 
FROM information_schema.tables 
WHERE table_schema = 'public' 
  AND table_name IN ('venue_ownership_requests', 'admin_notifications');

-- Verificar que las funciones existen
SELECT routine_name 
FROM information_schema.routines 
WHERE routine_schema = 'public' 
  AND routine_name IN (
    'generate_verification_code',
    'create_venue_ownership_request',
    'verify_venue_ownership',
    'reject_venue_ownership',
    'approve_event_by_owner'
  );

-- Verificar que los campos nuevos existen en venues
SELECT column_name 
FROM information_schema.columns 
WHERE table_schema = 'public' 
  AND table_name = 'venues' 
  AND column_name IN ('owner_id', 'verified_at', 'verified_by');

-- Verificar que los campos nuevos existen en events
SELECT column_name 
FROM information_schema.columns 
WHERE table_schema = 'public' 
  AND table_name = 'events' 
  AND column_name IN ('owner_approved', 'owner_approved_at', 'owner_rejected_reason');
```

Si todas las consultas devuelven resultados, ¡la migración se ejecutó correctamente! ✅

---

## ✅ Paso 2: Desplegar Edge Function (OPCIONAL pero recomendado)

La Edge Function `notify_venue_ownership_request` envía notificaciones push a los admins cuando alguien solicita ownership de un venue.

### Opción A: Desplegar con Supabase CLI (Recomendado)

```bash
# Desde la raíz del proyecto
cd supabase/functions/notify_venue_ownership_request
supabase functions deploy notify_venue_ownership_request
```

### Opción B: Desplegar manualmente desde Dashboard

1. Ve a Supabase Dashboard > **Edge Functions**
2. Haz clic en **Create a new function**
3. Nombre: `notify_venue_ownership_request`
4. Copia el contenido de `supabase/functions/notify_venue_ownership_request/index.ts`
5. Pega en el editor
6. Haz clic en **Deploy**

### Variables de Entorno Necesarias

La función necesita estas variables de entorno en Supabase:

1. Ve a **Project Settings** > **Edge Functions** > **Secrets**
2. Añade estas variables:
   - `FIREBASE_PROJECT_ID` - ID de tu proyecto Firebase
   - `FIREBASE_SERVICE_ACCOUNT_KEY` - JSON del Service Account de Firebase

**Nota**: Si no tienes estas configuradas, la función no funcionará, pero el sistema seguirá funcionando (solo no enviará notificaciones push automáticas).

---

## ⚠️ Problemas Comunes y Soluciones

### Error: "relation 'venues' does not exist"

**Solución**: Ejecuta primero la migración `005_create_venues_system.sql`

```sql
-- Ejecuta esto primero
-- docs/migrations/005_create_venues_system.sql
```

### Error: "function update_updated_at_column() does not exist"

**Solución**: La función está en la migración 005. Ejecuta:

```sql
CREATE OR REPLACE FUNCTION update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = now();
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;
```

O ejecuta la migración 005 completa.

### Error: "relation 'admins' does not exist"

**Solución**: Ejecuta primero la migración `001_create_auth_tables.sql`

### Error al ejecutar funciones desde la app

**Verifica**:
1. Que las políticas RLS están creadas correctamente
2. Que el usuario está autenticado
3. Que el usuario tiene permisos (es admin para verificar ownership)

---

## ✅ Checklist de Verificación

Después de ejecutar todo, verifica:

- [ ] Migración SQL ejecutada sin errores
- [ ] Tablas `venue_ownership_requests` y `admin_notifications` existen
- [ ] Funciones SQL existen (5 funciones)
- [ ] Campos nuevos en `venues` y `events` existen
- [ ] Edge Function desplegada (opcional)
- [ ] Variables de entorno configuradas (opcional, solo si desplegaste Edge Function)

---

## 🧪 Probar que Funciona

### Test 1: Crear Solicitud de Ownership

Desde la app:
1. Busca un venue
2. Toca el botón "Reclamar"
3. Completa el formulario
4. Envía la solicitud

**Verifica en Supabase**:
```sql
SELECT * FROM venue_ownership_requests 
ORDER BY created_at DESC 
LIMIT 1;
```

Deberías ver una solicitud con:
- `status = 'pending'`
- `verification_code` con 6 dígitos
- `expires_at` en 7 días

### Test 2: Verificar Notificación a Admin

**Verifica en Supabase**:
```sql
SELECT * FROM admin_notifications 
WHERE type = 'venue_ownership_request' 
ORDER BY created_at DESC 
LIMIT 1;
```

Deberías ver una notificación con el código de verificación.

### Test 3: Verificar Ownership (como Admin)

Desde la app (como admin):
1. Ve a Perfil > Solicitudes de ownership
2. Deberías ver la solicitud
3. Verifica el código
4. El usuario debería convertirse en dueño

**Verifica en Supabase**:
```sql
SELECT v.name, v.owner_id, u.email as owner_email
FROM venues v
LEFT JOIN auth.users u ON u.id = v.owner_id
WHERE v.owner_id IS NOT NULL;
```

---

## 📝 Notas Importantes

1. **La migración es segura**: Usa `IF NOT EXISTS` y `CREATE OR REPLACE`, así que puedes ejecutarla múltiples veces sin problemas.

2. **La Edge Function es opcional**: El sistema funcionará sin ella, solo no enviará notificaciones push automáticas. Las notificaciones se crearán en la base de datos de todas formas.

3. **Orden de ejecución**: Si ejecutas las migraciones en orden (001 → 005 → 011), no deberías tener problemas de dependencias.

4. **Tiempo estimado**: 
   - Migración SQL: 2-3 minutos
   - Desplegar Edge Function: 5-10 minutos (si decides hacerlo)

---

## 🆘 ¿Necesitas Ayuda?

Si encuentras algún error:

1. **Copia el mensaje de error completo**
2. **Verifica qué migraciones ya has ejecutado**
3. **Revisa las dependencias** (001, 005 deben estar ejecutadas antes de 011)

---

**Última actualización**: Enero 2025

