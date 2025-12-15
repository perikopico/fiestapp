# 🔧 Aplicar Migración: Tabla deleted_users

Esta migración crea una tabla para marcar usuarios eliminados y previene que puedan iniciar sesión de nuevo.

## 📋 Problema que Soluciona

Cuando un usuario elimina su cuenta pero la Edge Function `delete_user_account` no está desplegada:
- ✅ Los datos personales se eliminan
- ✅ La sesión se cierra
- ❌ El usuario sigue en `auth.users` y puede iniciar sesión de nuevo

Esta migración soluciona esto marcando al usuario como eliminado y verificando esto en el login.

## 🚀 Aplicar la Migración

### Opción 1: Desde Supabase Dashboard (Recomendado)

1. Ve a [Supabase Dashboard](https://app.supabase.com)
2. Selecciona tu proyecto
3. Ve a **SQL Editor**
4. Copia y pega el contenido de `docs/migrations/009_add_deleted_users_table.sql`
5. Haz clic en **Run**

### Opción 2: Desde Supabase CLI

```bash
cd /home/perikopico/StudioProjects/fiestapp
supabase db push
```

O ejecutar directamente:

```bash
psql -h tu-host.supabase.co -U postgres -d postgres -f docs/migrations/009_add_deleted_users_table.sql
```

## ✅ Verificar que Funciona

1. **Registra un usuario de prueba**
2. **Elimina la cuenta** desde la app
3. **Intenta iniciar sesión** con las mismas credenciales
4. **Deberías ver el error**: "Esta cuenta ha sido eliminada. No puedes iniciar sesión."

## 🔍 Verificar la Tabla

```sql
-- Ver usuarios eliminados
SELECT * FROM public.deleted_users ORDER BY deleted_at DESC;

-- Verificar que un usuario específico está marcado como eliminado
SELECT * FROM public.deleted_users WHERE email = 'tu-email@ejemplo.com';
```

## 📝 Qué Hace la Migración

1. **Crea tabla `deleted_users`**:
   - Almacena `user_id`, `deleted_at`, `email`, `reason`
   - Tiene índices para búsquedas rápidas
   - Tiene políticas RLS configuradas

2. **Actualiza función `delete_user_data`**:
   - Ahora marca al usuario como eliminado cuando se eliminan sus datos
   - Esto previene que pueda iniciar sesión de nuevo

3. **El código de la app**:
   - Verifica en `signInWithEmail` si el usuario está marcado como eliminado
   - Si está eliminado, rechaza el login y cierra sesión inmediatamente

## 🐛 Solución de Problemas

### Error: "relation deleted_users does not exist"
- Asegúrate de ejecutar la migración `009_add_deleted_users_table.sql` primero

### Error: "permission denied for table deleted_users"
- Verifica que las políticas RLS estén configuradas correctamente
- La migración incluye las políticas necesarias

### El usuario puede iniciar sesión después de eliminar cuenta
- Verifica que la migración se aplicó correctamente
- Verifica que la función `delete_user_data` esté actualizada
- Revisa los logs de la app para ver si hay errores

---

**Última actualización**: Diciembre 2024

