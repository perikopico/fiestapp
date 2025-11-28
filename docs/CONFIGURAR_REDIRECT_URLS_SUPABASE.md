# Configurar Redirect URLs en Supabase para OAuth

## Problema

Cuando intentas iniciar sesión con Google en Android, aparece un error que dice "null es inaccesible" o "no se puede acceder a este sitio" y muestra una URL como `http://localhost:3000/?code=...`.

Esto sucede porque Supabase no sabe a qué URL redirigir después de la autenticación de Google.

## Solución Completa

Necesitas configurar los redirect URLs en el dashboard de Supabase **Y** asegurarte de que Google Cloud Console tenga configurado el redirect URI correcto.

### Paso 1: Configurar Redirect URLs en Supabase

1. Ve a tu proyecto en [Supabase Dashboard](https://supabase.com/dashboard)
2. Navega a **Authentication > URL Configuration** (o **Settings > Authentication > URL Configuration**)

3. En la sección **Redirect URLs**, añade las siguientes URLs (una por línea):
   ```
   io.supabase.fiestapp://
   io.supabase.fiestapp://login-callback
   io.supabase.fiestapp://reset-password
   ```

4. En **Site URL**, asegúrate de tener:
   ```
   io.supabase.fiestapp://
   ```
   (O déjalo como está si ya tienes otra URL configurada)

5. Haz clic en **Save** para guardar los cambios

### Paso 2: Verificar/Configurar en Google Cloud Console

1. Ve a [Google Cloud Console](https://console.cloud.google.com/)
2. Selecciona tu proyecto
3. Ve a **APIs & Services > Credentials**
4. Haz clic en el **OAuth 2.0 Client ID** que usas para Supabase
5. En **Authorized redirect URIs**, asegúrate de tener:
   ```
   https://[TU-PROYECTO-SUPABASE].supabase.co/auth/v1/callback
   ```
   
   Donde `[TU-PROYECTO-SUPABASE]` es el ID de tu proyecto de Supabase.
   
   Por ejemplo, si tu URL de Supabase es `https://xyzabc123.supabase.co`, entonces el redirect URI sería:
   ```
   https://xyzabc123.supabase.co/auth/v1/callback
   ```

6. Haz clic en **Save**

### Paso 3: Verificar el Deep Link en AndroidManifest.xml

Asegúrate de que en `android/app/src/main/AndroidManifest.xml` tienes configurado el deep link:

```xml
<intent-filter>
    <action android:name="android.intent.action.VIEW" />
    <category android:name="android.intent.category.DEFAULT" />
    <category android:name="android.intent.category.BROWSABLE" />
    <data android:scheme="io.supabase.fiestapp" />
</intent-filter>
```

Si no está, añádelo dentro de la actividad principal.

### Paso 4: Reiniciar la App

Después de hacer estos cambios:
1. Cierra completamente la app
2. Vuelve a ejecutar `flutter run -d android`
3. Intenta iniciar sesión con Google de nuevo

## Notas Importantes

- El deep link `io.supabase.fiestapp://` debe coincidir exactamente en:
  - Supabase Dashboard (Redirect URLs)
  - AndroidManifest.xml (android:scheme)
  - Código de la app (lib/services/auth_service.dart)
- Después de cambiar los redirect URLs en Supabase, puede tomar unos minutos en aplicarse
- Si sigues teniendo problemas, verifica los logs de la app con `flutter run -d android` y busca mensajes de error relacionados con OAuth

