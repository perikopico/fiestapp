# Pasos Finales: Configurar Google OAuth en Supabase

## ✅ Ya has completado:
1. ✅ Configurada la pantalla de consentimiento OAuth
2. ✅ Creado el OAuth 2.0 Client ID
3. ✅ Añadido tu email como test user (recomendado)

## 📋 Lo que falta:

### Paso 1: Copiar Client ID y Client Secret

1. Ve a **Google Cloud Console** > **APIs & Services** > **Credentials**
2. Haz clic en tu **OAuth 2.0 Client ID** (el que se llama "QuePlan - Supabase" o similar)
3. Verás:
   - **Client ID**: Un string largo (cópialo completo)
   - **Client secret**: Si no lo ves, haz clic en "Show" o busca un botón para revelarlo
   - Si dice "Secret not shown", haz clic en **"Reset secret"** para generar uno nuevo

### Paso 2: Configurar en Supabase

1. Ve a **Supabase Dashboard**: https://app.supabase.com/
2. Selecciona tu proyecto
3. Ve a **Authentication** (en el menú izquierdo)
4. Haz clic en **Providers**
5. Busca **Google** en la lista
6. Activa el toggle de Google
7. Pega:
   - **Client ID (for OAuth)**: El Client ID que copiaste
   - **Client Secret (for OAuth)**: El Client Secret que copiaste
8. Haz clic en **Save**

### Paso 3: Probar

1. Abre tu app
2. Ve a la pantalla de login
3. Haz clic en "Continuar con Google"
4. Deberías ver la pantalla de Google para autorizar
5. Después de autorizar, deberías iniciar sesión correctamente

## ⚠️ Si tienes problemas:

- **Error "Access blocked"**: Asegúrate de haber añadido tu email como test user
- **Error "redirect_uri_mismatch"**: Verifica que la URL en Google Console sea exactamente:
  ```
  https://oudofaiekedtaovrdqeo.supabase.co/auth/v1/callback
  ```
- **No veo el Client Secret**: Haz clic en "Reset secret" o "Show" para revelarlo

## ✅ No necesitas:
- ❌ Crear ningún "cliente email"
- ❌ Configurar nada más en Google Cloud
- ❌ Hacer nada adicional

¡Ya está todo listo! Solo copia las credenciales a Supabase y prueba.

