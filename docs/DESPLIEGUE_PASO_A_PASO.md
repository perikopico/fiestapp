# 🚀 Desplegar Edge Functions - Guía Paso a Paso

## ⚠️ IMPORTANTE: Diferencia entre SQL y Edge Functions

- **SQL** → Se ejecuta en el **SQL Editor** de Supabase
- **Edge Functions** (TypeScript) → Se despliegan desde **Edge Functions** en el Dashboard

## 📋 Paso 1: Acceder a Edge Functions

1. Ve a [Supabase Dashboard](https://app.supabase.com)
2. Selecciona tu proyecto
3. En el menú lateral, busca **Edge Functions** (no SQL Editor)
4. Haz clic en **Edge Functions**

## 📝 Paso 2: Crear Función `send_deletion_email`

1. Haz clic en **Create a new function**
2. **Nombre de la función**: `send_deletion_email`
3. **Código**: Copia TODO el contenido del archivo:
   ```
   supabase/functions/send_deletion_email/index.ts
   ```
4. Pega el código en el editor
5. Haz clic en **Deploy**

## 📝 Paso 3: Crear Función `cleanup_deleted_users`

1. Haz clic en **Create a new function** (nuevamente)
2. **Nombre**: `cleanup_deleted_users`
3. **Código**: Copia TODO el contenido de:
   ```
   supabase/functions/cleanup_deleted_users/index.ts
   ```
4. Pega y haz clic en **Deploy**

## 📝 Paso 4: Crear Función `delete_user_account`

1. Haz clic en **Create a new function**
2. **Nombre**: `delete_user_account`
3. **Código**: Copia TODO el contenido de:
   ```
   supabase/functions/delete_user_account/index.ts
   ```
4. Pega y haz clic en **Deploy**

## ⚙️ Paso 5: Configurar Secrets

Para cada función desplegada:

1. Haz clic en la función (ej: `send_deletion_email`)
2. Ve a la pestaña **Settings**
3. Busca la sección **Secrets**
4. Haz clic en **Add secret**
5. Añade estos secrets:

### Secret 1: SUPABASE_SERVICE_ROLE_KEY (OBLIGATORIO)
- **Name**: `SUPABASE_SERVICE_ROLE_KEY`
- **Value**: Tu Service Role Key
  - Obtén desde: Dashboard → Settings → API → service_role key
  - ⚠️ **NUNCA** compartas esta clave públicamente

### Secret 2: RESEND_API_KEY (OPCIONAL - Solo para emails)
- **Name**: `RESEND_API_KEY`
- **Value**: Tu API Key de Resend
  - Solo si quieres usar Resend para enviar emails
  - Obtén desde: https://resend.com → API Keys

**Repite este paso para las 3 funciones**

## ✅ Paso 6: Verificar

1. En **Edge Functions**, deberías ver las 3 funciones:
   - ✅ `send_deletion_email`
   - ✅ `cleanup_deleted_users`
   - ✅ `delete_user_account`

2. Haz clic en cada una para verificar que tienen los secrets configurados

## 🧪 Paso 7: Probar

1. Abre tu app Flutter
2. Registra un usuario de prueba
3. Elimina la cuenta desde la app
4. Revisa el email → Deberías recibir el email de confirmación

## 🐛 Solución de Problemas

### Error: "Function not found"
- Verifica que la función esté desplegada
- Verifica que el nombre coincida exactamente

### Error: "Service Role Key not configured"
- Añade `SUPABASE_SERVICE_ROLE_KEY` en los secrets de la función

### El email no se envía
- Verifica `RESEND_API_KEY` o configura SMTP en Supabase
- Revisa los logs: Edge Functions → Función → Logs

---

**Recuerda**: Las Edge Functions son código TypeScript que se ejecuta en el servidor, NO son SQL.

