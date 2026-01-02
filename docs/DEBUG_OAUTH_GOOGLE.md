# 🐛 Debugging: Problema con Google OAuth

## Síntoma
Después de seleccionar la cuenta de Google, se abre Gmail en lugar de volver a la app.

## Pasos de Debugging

### 1. Verificar Logs de Flutter

Ejecuta la app con logs detallados:
```bash
flutter run -d <device_id> --verbose
```

Busca estos mensajes cuando intentas iniciar sesión:
- `✅ Redirigiendo a Google OAuth`
- `📍 Deep link: io.supabase.fiestapp://login-callback`
- `✅ Usuario autenticado: ...`

### 2. Verificar que el Deep Link Funciona

Prueba abrir manualmente el deep link:
```bash
adb shell am start -a android.intent.action.VIEW -d "io.supabase.fiestapp://login-callback?code=test"
```

Esto debería abrir la app. Si no lo hace, hay un problema con el AndroidManifest.xml.

### 3. Verificar Configuración de Google OAuth en Supabase

1. Ve a Supabase Dashboard → **Authentication** → **Providers**
2. Verifica que Google esté **habilitado**
3. Verifica que tengas:
   - Client ID configurado
   - Client Secret configurado

### 4. Verificar URLs de Redirección

Las URLs deben estar exactamente así en Supabase Dashboard:
- `io.supabase.fiestapp://login-callback` ✅
- `io.supabase.fiestapp://auth/confirmed` ✅
- `io.supabase.fiestapp://reset-password` ✅

### 5. Verificar AndroidManifest.xml

El intent-filter debe estar así:
```xml
<intent-filter>
    <action android:name="android.intent.action.VIEW" />
    <category android:name="android.intent.category.DEFAULT" />
    <category android:name="android.intent.category.BROWSABLE" />
    <data android:scheme="io.supabase.fiestapp" />
</intent-filter>
```

### 6. Probar con Navegador Diferente

A veces el problema es que el navegador predeterminado no maneja bien los deep links. Prueba:
1. Cambiar el navegador predeterminado temporalmente
2. O usar Chrome específicamente para la autenticación

### 7. Verificar que Supabase Inicializa Correctamente

En los logs, busca:
```
✅ Supabase inicializado con éxito
```

Si no aparece, hay un problema con la inicialización.

## Soluciones Comunes

### Solución 1: Desinstalar y Reinstalar
A veces el problema es caché:
```bash
adb uninstall com.perikopico.fiestapp
flutter run -d <device_id>
```

### Solución 2: Verificar que el Deep Link Está en la Lista Blanca
En Supabase Dashboard, asegúrate de que `io.supabase.fiestapp://login-callback` esté en la lista de Redirect URLs.

### Solución 3: Usar URL Completa en lugar de Deep Link
Si el problema persiste, prueba cambiar temporalmente a una URL HTTP/HTTPS en lugar del deep link (solo para testing).

## Si Nada Funciona

1. Verifica los logs completos de Flutter
2. Verifica los logs de Android (logcat)
3. Prueba con otro dispositivo
4. Verifica la versión de `supabase_flutter` en `pubspec.yaml`

