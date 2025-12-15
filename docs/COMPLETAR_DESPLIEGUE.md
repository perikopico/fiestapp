# ✅ Completar Despliegue de Edge Functions

## 🎯 Estado Actual

Ya tienes configurado:
- ✅ `SUPABASE_SERVICE_ROLE_KEY` (obligatorio)

## 📧 Paso 1: Añadir RESEND_API_KEY (Opcional)

Si quieres usar Resend para enviar emails (recomendado):

1. **Crear cuenta en Resend** (si no la tienes):
   - Ve a https://resend.com
   - Regístrate (plan gratuito disponible)

2. **Obtener API Key**:
   - Ve a Settings → API Keys
   - Crea una nueva clave
   - Copia la clave

3. **Añadir en Supabase**:
   - En la pantalla que tienes abierta (Secrets)
   - Haz clic en "Add another"
   - **Name**: `RESEND_API_KEY`
   - **Value**: Pega tu API key de Resend
   - Haz clic en "Save"

**Alternativa**: Si no quieres usar Resend, puedes configurar SMTP en:
- Supabase Dashboard → Settings → Auth → SMTP Settings

## 🚀 Paso 2: Desplegar las Edge Functions

### Función 1: `send_deletion_email`

1. Ve a **Edge Functions** → **Functions** (en el menú lateral)
2. Haz clic en **Create a new function**
3. **Nombre**: `send_deletion_email`
4. **Código**: Copia TODO el contenido de:
   ```
   supabase/functions/send_deletion_email/index.ts
   ```
5. Pega el código y haz clic en **Deploy**

### Función 2: `cleanup_deleted_users`

1. Haz clic en **Create a new function**
2. **Nombre**: `cleanup_deleted_users`
3. **Código**: Copia TODO el contenido de:
   ```
   supabase/functions/cleanup_deleted_users/index.ts
   ```
4. Pega y haz clic en **Deploy**

### Función 3: `delete_user_account`

1. Haz clic en **Create a new function**
2. **Nombre**: `delete_user_account`
3. **Código**: Copia TODO el contenido de:
   ```
   supabase/functions/delete_user_account/index.ts
   ```
4. Pega y haz clic en **Deploy**

## ✅ Paso 3: Verificar

1. En **Edge Functions** → **Functions**, deberías ver las 3 funciones
2. Haz clic en cada una para verificar que están desplegadas
3. Los secrets que configuraste se aplican automáticamente a todas las funciones

## 🧪 Paso 4: Probar

1. Abre tu app Flutter
2. Registra un usuario de prueba
3. Elimina la cuenta desde la app
4. Revisa el email → Deberías recibir el email de confirmación

---

**Nota**: Los secrets que configuraste en la sección "Secrets" se aplican a TODAS las Edge Functions automáticamente. No necesitas configurarlos por función.

