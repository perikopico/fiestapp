# 🗑️ Gestionar Eliminación Definitiva de Cuentas

Esta guía explica cómo gestionar la eliminación definitiva de usuarios de `auth.users` en Supabase.

## 📋 Situación Actual

Cuando un usuario elimina su cuenta:
1. ✅ Se eliminan los datos personales (tablas relacionadas)
2. ✅ Se marca como eliminado en `deleted_users`
3. ✅ Se cierra sesión
4. ❌ **PERO el usuario sigue en `auth.users`** (requiere Admin API)

## 🎯 Opciones para Eliminación Definitiva

### Opción 1: Edge Function + Cron Job (Recomendado)

**Ventajas:**
- ✅ Automático
- ✅ No requiere intervención manual
- ✅ Puede ejecutarse semanalmente o diariamente

**Cómo funciona:**
1. Usuario elimina cuenta → Se marca en `deleted_users`
2. Edge Function `cleanup_deleted_users` se ejecuta periódicamente
3. Elimina usuarios de `auth.users` que están en `deleted_users` hace X días
4. Limpia la entrada de `deleted_users`

**Configurar:**

1. **Desplegar la Edge Function:**
   ```bash
   cd /home/perikopico/StudioProjects/fiestapp
   supabase functions deploy cleanup_deleted_users
   ```

2. **Configurar Service Role Key:**
   ```bash
   supabase secrets set SUPABASE_SERVICE_ROLE_KEY=tu_service_role_key
   ```

3. **Programar ejecución semanal:**
   - Ve a Supabase Dashboard → Edge Functions → `cleanup_deleted_users`
   - Configura un cron job o usa Supabase Cron (si está disponible)
   - O ejecuta manualmente cuando lo necesites

**Ejecutar manualmente:**
```bash
curl -X POST https://tu-proyecto.supabase.co/functions/v1/cleanup_deleted_users \
  -H "Authorization: Bearer tu_service_role_key" \
  -H "Content-Type: application/json" \
  -d '{"days": 7, "limit": 100}'
```

**Parámetros:**
- `days`: Eliminar usuarios eliminados hace X+ días (default: 7)
- `limit`: Máximo de usuarios a procesar por ejecución (default: 100)

### Opción 2: Eliminación Manual desde Dashboard

**Cuándo usar:**
- Pocos usuarios eliminados
- Eliminación inmediata necesaria
- No quieres configurar automatización

**Pasos:**
1. Ve a [Supabase Dashboard](https://app.supabase.com)
2. Selecciona tu proyecto
3. Ve a **Authentication** → **Users**
4. Busca el usuario por email
5. Haz clic en los tres puntos → **Delete user**

### Opción 3: Script SQL Manual

Puedes crear un script SQL que elimine usuarios de `auth.users` basándose en `deleted_users`:

```sql
-- Ejemplo: Eliminar usuarios eliminados hace 7+ días
DO $$
DECLARE
    user_record RECORD;
    deleted_count INTEGER := 0;
BEGIN
    FOR user_record IN 
        SELECT user_id, email 
        FROM public.deleted_users 
        WHERE deleted_at < NOW() - INTERVAL '7 days'
        LIMIT 100
    LOOP
        -- Eliminar de auth.users usando Admin API (requiere función)
        -- O eliminar manualmente desde dashboard
        deleted_count := deleted_count + 1;
        RAISE NOTICE 'Usuario a eliminar: % (%)', user_record.email, user_record.user_id;
    END LOOP;
    
    RAISE NOTICE 'Total usuarios a eliminar: %', deleted_count;
END $$;
```

**Nota:** Este script solo lista usuarios. Para eliminar realmente de `auth.users` necesitas Admin API.

## 🔄 Flujo Recomendado

### Configuración Inicial:

1. ✅ Aplicar migración `009_add_deleted_users_table.sql`
2. ✅ Desplegar Edge Function `cleanup_deleted_users`
3. ✅ Configurar Service Role Key
4. ✅ Programar ejecución semanal (o ejecutar manualmente)

### Flujo Diario:

1. Usuario elimina cuenta → Marcado en `deleted_users`
2. Usuario intenta login → Rechazado (verificación en código)
3. Semanalmente → Edge Function elimina de `auth.users`
4. Limpieza → Entrada eliminada de `deleted_users`

## 📊 Verificar Estado

```sql
-- Ver usuarios marcados como eliminados
SELECT 
    user_id,
    email,
    deleted_at,
    NOW() - deleted_at AS tiempo_eliminado
FROM public.deleted_users
ORDER BY deleted_at DESC;

-- Contar usuarios pendientes de eliminación definitiva
SELECT COUNT(*) as pendientes
FROM public.deleted_users
WHERE deleted_at < NOW() - INTERVAL '7 days';
```

## ⚙️ Configuración de la Edge Function

La función `cleanup_deleted_users` acepta parámetros:

**GET request:**
```
https://tu-proyecto.supabase.co/functions/v1/cleanup_deleted_users?days=7&limit=100
```

**POST request:**
```json
{
  "days": 7,
  "limit": 100
}
```

**Parámetros:**
- `days` (opcional): Eliminar usuarios eliminados hace X+ días. Default: 7
- `limit` (opcional): Máximo usuarios a procesar. Default: 100

## 🛡️ Seguridad

- ✅ La función requiere Service Role Key
- ✅ Solo procesa usuarios en `deleted_users`
- ✅ Solo elimina usuarios eliminados hace X+ días (período de gracia)
- ✅ Limita el número de usuarios por ejecución

## 📝 Notas Importantes

1. **Período de gracia**: Por defecto, la función solo elimina usuarios eliminados hace 7+ días. Esto permite:
   - Recuperación si fue un error
   - Tiempo para backups
   - Cumplimiento legal (algunas jurisdicciones requieren períodos de retención)

2. **Límite por ejecución**: Procesa máximo 100 usuarios por ejecución para evitar timeouts.

3. **Ejecución manual**: Puedes ejecutar la función manualmente cuando lo necesites.

---

**Última actualización**: Diciembre 2024

