# 🚀 Desplegar Sistema Completo de Eliminación de Cuentas

Guía completa para desplegar todas las Edge Functions necesarias para la eliminación de cuentas con emails legales.

## 📋 Resumen de Funciones

1. **`send_deletion_email`** - Envía email de confirmación con información legal
2. **`cleanup_deleted_users`** - Limpia usuarios eliminados periódicamente
3. **`delete_user_account`** - Elimina usuarios de auth.users

## 🚀 Método 1: Desde Supabase Dashboard (Recomendado si no tienes CLI)

### Paso 1: Crear Función `send_deletion_email`

1. Ve a [Supabase Dashboard](https://app.supabase.com)
2. Selecciona tu proyecto
3. Ve a **Edge Functions**
4. Haz clic en **Create a new function**
5. **Nombre**: `send_deletion_email`
6. **Código**: Copia TODO el contenido de `supabase/functions/send_deletion_email/index.ts`
7. Haz clic en **Deploy**

### Paso 2: Crear Función `cleanup_deleted_users`

1. En **Edge Functions**, haz clic en **Create a new function**
2. **Nombre**: `cleanup_deleted_users`
3. **Código**: Copia TODO el contenido de `supabase/functions/cleanup_deleted_users/index.ts`
4. Haz clic en **Deploy**

### Paso 3: Crear Función `delete_user_account`

1. En **Edge Functions**, haz clic en **Create a new function**
2. **Nombre**: `delete_user_account`
3. **Código**: Copia TODO el contenido de `supabase/functions/delete_user_account/index.ts`
4. Haz clic en **Deploy**

### Paso 4: Configurar Secrets

Para cada función desplegada:

1. Haz clic en la función
2. Ve a **Settings** → **Secrets**
3. Añade estos secrets:

**Obligatorio:**
- `SUPABASE_SERVICE_ROLE_KEY` = tu_service_role_key
  - Obtén desde: Dashboard → Settings → API → service_role key

**Opcional (para emails):**
- `RESEND_API_KEY` = tu_resend_api_key
  - Solo si quieres usar Resend para emails
  - Obtén desde: https://resend.com → API Keys

## 🚀 Método 2: Con Supabase CLI

### Instalar CLI:

```bash
# Opción A: Con curl (requiere sudo)
curl -fsSL https://github.com/supabase/cli/releases/latest/download/supabase_linux_amd64.tar.gz | sudo tar -xz -C /usr/local/bin

# Opción B: Sin sudo (instalar en ~/.local/bin)
mkdir -p ~/.local/bin
curl -fsSL https://github.com/supabase/cli/releases/latest/download/supabase_linux_amd64.tar.gz | tar -xz -C ~/.local/bin
export PATH="$HOME/.local/bin:$PATH"
```

### Autenticarse y Desplegar:

```bash
# Autenticarse
supabase login

# Vincular proyecto (reemplaza tu-project-ref)
cd /home/perikopico/StudioProjects/fiestapp
supabase link --project-ref tu-project-ref

# Configurar secrets
supabase secrets set SUPABASE_SERVICE_ROLE_KEY=tu_service_role_key
supabase secrets set RESEND_API_KEY=tu_resend_api_key  # Opcional

# Desplegar funciones
supabase functions deploy send_deletion_email
supabase functions deploy cleanup_deleted_users
supabase functions deploy delete_user_account
```

## 📧 Configurar Resend (Opcional pero Recomendado)

### Por qué Resend:
- ✅ Más confiable que SMTP
- ✅ Mejor deliverability
- ✅ API simple
- ✅ Plan gratuito disponible

### Pasos:

1. **Crear cuenta**: https://resend.com
2. **Verificar dominio** (opcional pero recomendado)
3. **Crear API Key**: Settings → API Keys → Create
4. **Añadir secret**: En Supabase Dashboard → Edge Functions → Settings → Secrets
   - Nombre: `RESEND_API_KEY`
   - Valor: tu API key de Resend

## ✅ Verificar que Todo Funciona

1. **Ver funciones desplegadas:**
   - Dashboard → Edge Functions → Deberías ver las 3 funciones

2. **Probar eliminación:**
   - Registra un usuario de prueba
   - Elimina la cuenta desde la app
   - Revisa el email → Deberías recibir el email de confirmación

3. **Verificar logs:**
   - Dashboard → Edge Functions → Selecciona función → Logs

## 🔄 Flujo Completo

1. **Usuario elimina cuenta:**
   - Se eliminan datos personales
   - Se marca en `deleted_users`
   - Se envía email de confirmación (con info legal)
   - Se cierra sesión

2. **Usuario intenta login:**
   - Verificación en código → Rechazado
   - Mensaje: "Esta cuenta ha sido eliminada"

3. **Después de 7 días:**
   - `cleanup_deleted_users` elimina de `auth.users`
   - Limpia entrada de `deleted_users`

## 📝 Contenido del Email

El email incluye:
- ✅ Confirmación de eliminación
- ✅ Fecha y hora
- ✅ Lista de datos eliminados
- ✅ Período de retención (7 días)
- ✅ Derechos RGPD
- ✅ Instrucciones de recuperación
- ✅ Información de contacto
- ✅ Enlaces legales

## 🐛 Solución de Problemas

### Las funciones no aparecen
- Verifica que se hayan desplegado correctamente
- Revisa que el código esté completo

### Error: "Service Role Key not configured"
- Añade `SUPABASE_SERVICE_ROLE_KEY` en los secrets de cada función

### El email no se envía
- Verifica `RESEND_API_KEY` o configura SMTP en Supabase
- Revisa los logs de `send_deletion_email`

### Error 404 al llamar funciones
- Verifica que las funciones estén desplegadas
- Verifica que los nombres coincidan exactamente

---

**Última actualización**: Diciembre 2024

