# 📧 Desplegar Sistema de Emails de Eliminación

Esta guía explica cómo desplegar y configurar el sistema de emails de confirmación de eliminación de cuenta.

## 📋 Componentes

1. **Edge Function `send_deletion_email`**: Genera y envía el email de confirmación
2. **Edge Function `cleanup_deleted_users`**: Limpia usuarios eliminados periódicamente
3. **Edge Function `delete_user_account`**: Elimina usuarios de auth.users

## 🚀 Paso 1: Configurar Service Role Key

```bash
cd /home/perikopico/StudioProjects/fiestapp
supabase secrets set SUPABASE_SERVICE_ROLE_KEY=tu_service_role_key_aqui
```

## 📧 Paso 2: Configurar Servicio de Email (Opcional pero Recomendado)

### Opción A: Resend (Recomendado - Más Fácil)

1. **Crear cuenta en Resend:**
   - Ve a https://resend.com
   - Regístrate (plan gratuito disponible)
   - Verifica tu dominio o usa el dominio de prueba

2. **Obtener API Key:**
   - Ve a **API Keys**
   - Crea una nueva clave
   - Copia la clave

3. **Configurar en Supabase:**
   ```bash
   supabase secrets set RESEND_API_KEY=tu_resend_api_key_aqui
   ```

### Opción B: Usar SMTP de Supabase

1. Ve a Supabase Dashboard → **Settings** → **Auth** → **SMTP Settings**
2. Configura tu SMTP (Gmail, SendGrid, etc.)
3. La función usará el SMTP configurado automáticamente

## 🚀 Paso 3: Desplegar Edge Functions

```bash
cd /home/perikopico/StudioProjects/fiestapp

# Desplegar función de email de eliminación
supabase functions deploy send_deletion_email

# Desplegar función de limpieza
supabase functions deploy cleanup_deleted_users

# Desplegar función de eliminación de usuario
supabase functions deploy delete_user_account
```

## ✅ Paso 4: Verificar Despliegue

1. Ve a [Supabase Dashboard](https://app.supabase.com)
2. Selecciona tu proyecto
3. Ve a **Edge Functions**
4. Deberías ver las 3 funciones:
   - ✅ `send_deletion_email`
   - ✅ `cleanup_deleted_users`
   - ✅ `delete_user_account`

## 🧪 Paso 5: Probar

1. **Registra un usuario de prueba**
2. **Elimina la cuenta** desde la app
3. **Revisa el email** - deberías recibir el email de confirmación con toda la información legal

## 📝 Contenido del Email

El email incluye:
- ✅ Confirmación de eliminación
- ✅ Fecha y hora de eliminación
- ✅ Lista de datos eliminados
- ✅ Información sobre período de retención (7 días)
- ✅ Derechos RGPD
- ✅ Instrucciones para recuperación (si fue un error)
- ✅ Información de contacto
- ✅ Enlaces a Política de Privacidad y Términos

## 🔄 Flujo Completo

1. Usuario elimina cuenta → Se marca en `deleted_users`
2. Se envía email de confirmación → Con toda la información legal
3. Usuario intenta login → Rechazado con mensaje claro
4. Después de 7 días → `cleanup_deleted_users` elimina de `auth.users`
5. Limpieza → Entrada eliminada de `deleted_users`

## 🐛 Solución de Problemas

### El email no se envía
- Verifica que `RESEND_API_KEY` esté configurado o que SMTP esté configurado en Supabase
- Revisa los logs de la función: `supabase functions logs send_deletion_email`

### Error: "Resend API error"
- Verifica que la API key de Resend sea correcta
- Asegúrate de que el dominio esté verificado en Resend

### El email llega a spam
- Verifica tu dominio en Resend
- Configura SPF y DKIM records
- Usa un dominio verificado en lugar de dominio de prueba

---

**Última actualización**: Diciembre 2024

