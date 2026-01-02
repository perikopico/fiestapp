# ⚠️ RESUMEN: Qué Ejecutar en Supabase para Ownership

**Fecha**: Enero 2025  
**Estado**: 🔴 CRÍTICO - Sin esto el sistema NO funcionará

---

## ✅ OBLIGATORIO: Migración SQL

### Archivo a ejecutar:
**`docs/migrations/011_create_venue_ownership_system.sql`**

### Dónde ejecutarlo:
1. Supabase Dashboard → **SQL Editor**
2. Copiar TODO el contenido del archivo
3. Pegar y ejecutar (botón RUN o Ctrl+Enter)

### Tiempo estimado: 2-3 minutos

### ¿Qué crea?
- ✅ 2 tablas nuevas (`venue_ownership_requests`, `admin_notifications`)
- ✅ Campos nuevos en `venues` (owner_id, verified_at, verified_by)
- ✅ Campos nuevos en `events` (owner_approved, owner_approved_at, owner_rejected_reason)
- ✅ 5 funciones SQL para gestionar ownership
- ✅ Políticas de seguridad (RLS)
- ✅ Triggers automáticos

### Dependencias (verificar que existen):
- ✅ Tabla `venues` (de migración 005) - **Probablemente ya existe**
- ✅ Tabla `admins` (de migración 001) - **Probablemente ya existe**
- ✅ Función `update_updated_at_column()` (de migración 005) - **Probablemente ya existe**

**Si no estás seguro**, ejecuta primero `005_create_venues_system.sql` (es segura, usa IF NOT EXISTS).

---

## ⚠️ OPCIONAL: Edge Function

### Archivo a desplegar:
**`supabase/functions/notify_venue_ownership_request/index.ts`**

### Por qué es opcional:
- El sistema funcionará sin ella
- Solo envía notificaciones push automáticas a admins
- Las notificaciones se crean en la BD de todas formas

### Cómo desplegarla:
1. Supabase Dashboard → **Edge Functions**
2. Crear nueva función: `notify_venue_ownership_request`
3. Copiar contenido del archivo TypeScript
4. Configurar variables de entorno (FIREBASE_PROJECT_ID, FIREBASE_SERVICE_ACCOUNT_KEY)

**Nota**: La función tiene un problema con JWT signing que necesita resolverse. Por ahora, puedes omitirla.

---

## ✅ Verificación Rápida

Después de ejecutar la migración SQL, ejecuta esto en SQL Editor:

```sql
-- Verificar tablas
SELECT 'venue_ownership_requests' as tabla, COUNT(*) as existe
FROM information_schema.tables 
WHERE table_name = 'venue_ownership_requests'
UNION ALL
SELECT 'admin_notifications', COUNT(*)
FROM information_schema.tables 
WHERE table_name = 'admin_notifications';

-- Verificar funciones
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
```

Si ves las tablas y las 5 funciones, ✅ **¡Todo está correcto!**

---

## 🎯 Acción Inmediata

**AHORA MISMO**:
1. Abre Supabase Dashboard
2. Ve a SQL Editor
3. Ejecuta `docs/migrations/011_create_venue_ownership_system.sql`
4. Verifica con las queries de arriba

**Tiempo total**: 5 minutos

---

## 📝 Nota Importante

La migración usa `IF NOT EXISTS` y `CREATE OR REPLACE`, así que:
- ✅ Es segura ejecutarla múltiples veces
- ✅ No borrará datos existentes
- ✅ Solo creará lo que falta

---

**¿Listo para ejecutar?** → Ve a `docs/EJECUTAR_SISTEMA_OWNERSHIP.md` para instrucciones detalladas.

