# 🔧 Solución: Problema con Login de Google OAuth

## Problema
Al intentar iniciar sesión con Google, después de seleccionar la cuenta, se abre Gmail en lugar de volver a la app.

## Causa
El deep link no está siendo capturado correctamente después de la autenticación de Google. Esto puede deberse a:
1. **La URL de redirección no está configurada en Supabase Dashboard** (más común)
2. El formato del deep link necesita ajustes
3. Falta configuración adicional

## Solución

### ⚠️ PASO CRÍTICO: Configurar URL de Redirección en Supabase Dashboard

**Este es el paso más importante y suele ser la causa del problema:**

1. Ve a tu proyecto en Supabase Dashboard: https://supabase.com/dashboard
2. Selecciona tu proyecto
3. Navega a **Authentication** → **URL Configuration**
4. En la sección **Redirect URLs**, añade estas URLs (una por línea):
   ```
   io.supabase.fiestapp://login-callback
   io.supabase.fiestapp://auth/confirmed
   io.supabase.fiestapp://reset-password
   ```
5. Haz clic en **Save**

**⚠️ IMPORTANTE**: Sin estas URLs configuradas, Supabase no sabrá a dónde redirigir después de la autenticación, por lo que el navegador intentará abrir Gmail u otra app.

### Paso 2: Verificar AndroidManifest.xml

El `AndroidManifest.xml` ya está configurado correctamente con el intent-filter para deep links:
```xml
<intent-filter>
    <action android:name="android.intent.action.VIEW" />
    <category android:name="android.intent.category.DEFAULT" />
    <category android:name="android.intent.category.BROWSABLE" />
    <data android:scheme="io.supabase.fiestapp" />
</intent-filter>
```

### Paso 3: MainActivity Mejorado

He actualizado el `MainActivity.kt` para manejar mejor los deep links. Esto ayuda a asegurar que los deep links se capturen correctamente.

## Verificación

Después de aplicar los cambios:

1. **Desinstala completamente la app** (importante para limpiar caché)
2. **Reinstala la app**
3. Intenta iniciar sesión con Google
4. Después de seleccionar la cuenta, debería volver a la app automáticamente

## Debugging

Si el problema persiste:

1. Verifica los logs de Flutter:
   ```bash
   flutter run -d <device_id>
   ```
   Busca mensajes como:
   - `✅ Redirigiendo a Google OAuth`
   - `📍 Deep link: io.supabase.fiestapp://login-callback`
   - `✅ Usuario autenticado: ...`

2. Verifica que las URLs estén guardadas en Supabase Dashboard

3. Prueba abrir manualmente el deep link:
   ```bash
   adb shell am start -a android.intent.action.VIEW -d "io.supabase.fiestapp://login-callback"
   ```
   Esto debería abrir la app.

## Verificación Adicional: Configuración de Google OAuth en Supabase

Además de las URLs de redirección, verifica:

1. Ve a **Authentication** → **Providers** en Supabase Dashboard
2. Asegúrate de que **Google** esté habilitado
3. Verifica que tengas configurados:
   - **Client ID (for OAuth)**: Tu Client ID de Google Cloud Console
   - **Client Secret (for OAuth)**: Tu Client Secret de Google Cloud Console

### Si no tienes las credenciales de Google OAuth:

1. Ve a Google Cloud Console: https://console.cloud.google.com/
2. Selecciona tu proyecto
3. Ve a **APIs & Services** → **Credentials**
4. Crea un **OAuth 2.0 Client ID** (tipo: Android o Web)
5. Copia el Client ID y Client Secret a Supabase

## Notas

- Supabase Flutter maneja automáticamente los deep links cuando están configurados correctamente
- El MainActivity simplificado solo pasa los intents a Flutter, dejando que Supabase maneje el resto
- La configuración en Supabase Dashboard es **obligatoria** para que funcione
- Si después de autenticarse se abre Gmail, puede ser que el navegador no esté redirigiendo correctamente al deep link

