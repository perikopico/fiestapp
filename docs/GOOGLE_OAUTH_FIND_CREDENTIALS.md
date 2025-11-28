# Dónde encontrar Client ID y Client Secret en Google Cloud Console

## 📍 Ubicación después de crear las credenciales

Después de crear tu **OAuth 2.0 Client ID** en Google Cloud Console, verás una ventana emergente con:

### ✅ Información que verás:
- **Client ID**: Un string largo que empieza con números y termina con `.apps.googleusercontent.com`
  - Ejemplo: `123456789-abcdefghijklmnop.apps.googleusercontent.com`
  
- **Client secret**: Un string aleatorio de letras y números
  - Ejemplo: `GOCSPX-abc123def456ghi789`

### ⚠️ IMPORTANTE:
**Copia ambos valores AHORA**, porque el Client Secret solo se muestra una vez. Si lo pierdes, tendrás que crear nuevas credenciales.

## 📋 Si ya creaste las credenciales y no los copiaste:

1. Ve a **APIs & Services > Credentials** en Google Cloud Console
2. Busca tu cliente OAuth 2.0 (el que se llama "QuePlan - Supabase" o similar)
3. Haz clic en el **ícono del lápiz (✏️)** o en el nombre del cliente para editarlo
4. Verás el **Client ID** en la parte superior
5. Para el **Client Secret**: Si no lo copiaste, tendrás que:
   - Hacer clic en **"Reset secret"** o crear nuevas credenciales
   - Esto generará un nuevo Client Secret

## 🔐 Pasos para copiar:

### Client ID:
- Está visible siempre en la lista de credenciales
- Haz clic en el cliente OAuth 2.0
- Copia el valor que aparece en "Client ID"

### Client Secret:
- Si lo tienes visible, cópialo directamente
- Si no lo ves, ve a la vista de edición del cliente
- Si dice "Secret not shown for security reasons", necesitarás hacer "Reset secret"

## ✅ Después de copiar:

Pega ambos valores en:
- **Supabase Dashboard** > **Authentication** > **Providers** > **Google**
- Activa el toggle de Google
- Pega el **Client ID** en el campo correspondiente
- Pega el **Client Secret** en el campo correspondiente
- Guarda los cambios

