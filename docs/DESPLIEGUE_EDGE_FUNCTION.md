# 🚀 Desplegar Edge Function delete_user_account

La Edge Function `delete_user_account` es necesaria para eliminar completamente usuarios de `auth.users` en Supabase.

## ⚠️ Problema Actual

Si ves este error al eliminar una cuenta:
```
FunctionException(status: 404, details: {code: NOT_FOUND, message: Requested function was not found})
```

Significa que la Edge Function **no está desplegada**.

## 📋 Requisitos Previos

1. **Supabase CLI instalado**:
   ```bash
   npm install -g supabase
   # O con Homebrew (macOS):
   brew install supabase/tap/supabase
   ```

2. **Autenticado en Supabase CLI**:
   ```bash
   supabase login
   ```

3. **Proyecto vinculado**:
   ```bash
   cd /home/perikopico/StudioProjects/fiestapp
   supabase link --project-ref tu-project-ref
   ```
   
   Puedes encontrar tu `project-ref` en:
   - Supabase Dashboard → Settings → General → Reference ID

## 🔧 Paso 1: Configurar Service Role Key

La Edge Function necesita la Service Role Key para usar Admin API.

1. Ve a [Supabase Dashboard](https://app.supabase.com)
2. Selecciona tu proyecto
3. Ve a **Settings** → **API**
4. Copia la **`service_role` key** (⚠️ NUNCA la expongas en el cliente)

5. Configura el secreto:
   ```bash
   supabase secrets set SUPABASE_SERVICE_ROLE_KEY=tu_service_role_key_aqui
   ```

## 🚀 Paso 2: Desplegar la Edge Function

```bash
cd /home/perikopico/StudioProjects/fiestapp
supabase functions deploy delete_user_account
```

## ✅ Paso 3: Verificar el Despliegue

1. Ve a [Supabase Dashboard](https://app.supabase.com)
2. Selecciona tu proyecto
3. Ve a **Edge Functions**
4. Deberías ver `delete_user_account` en la lista

## 🧪 Paso 4: Probar

1. Regístrate con un email de prueba
2. Inicia sesión
3. Ve a **Perfil** → **Eliminar cuenta**
4. Confirma la eliminación
5. Verifica en Supabase Dashboard → Authentication → Users que el usuario fue eliminado

## 🔍 Ver Logs

Para ver los logs de la función:

```bash
supabase functions logs delete_user_account
```

O desde el Dashboard:
- **Edge Functions** → **delete_user_account** → **Logs**

## 🐛 Solución de Problemas

### Error: "supabase: command not found"
- Instala Supabase CLI: `npm install -g supabase`

### Error: "Not authenticated"
- Ejecuta: `supabase login`

### Error: "Project not found"
- Vincula el proyecto: `supabase link --project-ref tu-project-ref`

### Error: "Service Role Key not configured"
- Configura el secreto: `supabase secrets set SUPABASE_SERVICE_ROLE_KEY=...`

### El usuario sigue en auth.users después de eliminar
- Verifica que la función esté desplegada
- Revisa los logs de la función
- Puedes eliminarlo manualmente desde Supabase Dashboard si es necesario

## 📝 Nota Importante

**Aunque la Edge Function no esté desplegada:**
- ✅ Los datos personales SÍ se eliminan (tablas relacionadas)
- ✅ La sesión SÍ se cierra
- ⚠️ El usuario NO se elimina de `auth.users` (requiere eliminación manual)

El código ahora maneja esto correctamente y siempre cierra sesión, incluso si falla la eliminación del usuario.

---

**Última actualización**: Diciembre 2024

