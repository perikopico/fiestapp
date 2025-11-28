# Pegar Credenciales en Supabase

## 📋 Pasos Finales

### Paso 1: Ir a Supabase Dashboard

1. Ve a: https://app.supabase.com/
2. Selecciona tu proyecto (el que tiene URL: `oudofaiekedtaovrdqeo`)

### Paso 2: Ir a Authentication > Providers

1. En el menú izquierdo, haz clic en **"Authentication"**
2. Luego haz clic en **"Providers"**
3. O ve directamente a: https://app.supabase.com/project/oudofaiekedtaovrdqeo/auth/providers

### Paso 3: Activar y Configurar Google

1. Busca **"Google"** en la lista de proveedores
2. Haz clic en el **toggle** para activar Google (debe ponerse verde/azul)
3. Verás dos campos:
   - **Client ID (for OAuth)**: Pega aquí tu Client ID
   - **Client Secret (for OAuth)**: Pega aquí tu Client Secret
4. Haz clic en **"Save"** o **"Save changes"**

### Paso 4: Verificar

Deberías ver:
- ✅ Google toggle activado
- ✅ Client ID y Secret guardados
- ✅ Mensaje de éxito

## ✅ ¡Listo!

Ahora puedes probar el login con Google en tu app.

## 🧪 Probar

1. Abre tu app Flutter
2. Ve a la pantalla de login
3. Haz clic en "Continuar con Google"
4. Deberías ver la pantalla de autorización de Google
5. Después de autorizar, deberías iniciar sesión correctamente

## ⚠️ Si tienes problemas:

- **Error "Access blocked"**: Asegúrate de haber añadido tu email como test user en Google Auth Platform
- **Error "redirect_uri_mismatch"**: Verifica que la URL en Google Console sea exactamente:
  ```
  https://oudofaiekedtaovrdqeo.supabase.co/auth/v1/callback
  ```

