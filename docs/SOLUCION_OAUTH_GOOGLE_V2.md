# 🔧 Solución: Problema con Login de Google OAuth (Versión 2)

## Problema
Al intentar iniciar sesión con Google, después de seleccionar la cuenta, se abre Gmail en lugar de volver a la app.

## Posibles Causas

1. **El navegador está interceptando el deep link**: Chrome/Gmail puede estar capturando el deep link antes de que llegue a la app
2. **El deep link no se está capturando correctamente**: La app no está recibiendo el intent con el deep link
3. **Configuración de Supabase**: Las URLs de redirección no están correctamente configuradas

## Soluciones

### Solución 1: Verificar URLs en Supabase Dashboard (CRÍTICO)

1. Ve a Supabase Dashboard → **Authentication** → **URL Configuration**
2. Verifica que estas URLs estén en **Redirect URLs**:
   ```
   io.supabase.fiestapp://login-callback
   io.supabase.fiestapp://auth/confirmed
   io.supabase.fiestapp://reset-password
   ```
3. **IMPORTANTE**: Asegúrate de que NO haya espacios extra o caracteres especiales

### Solución 2: Limpiar Caché y Reinstalar

1. **Desinstala completamente la app**:
   ```bash
   adb uninstall com.perikopico.fiestapp
   ```

2. **Limpia el build de Flutter**:
   ```bash
   flutter clean
   flutter pub get
   ```

3. **Reinstala la app**:
   ```bash
   flutter run -d <device_id>
   ```

### Solución 3: Verificar que el Deep Link Funciona

Prueba abrir manualmente el deep link:
```bash
adb shell am start -a android.intent.action.VIEW -d "io.supabase.fiestapp://login-callback?code=test"
```

Si esto NO abre la app, hay un problema con el AndroidManifest.xml.

### Solución 4: Usar Chrome en lugar del navegador predeterminado

A veces el problema es el navegador predeterminado. Prueba:
1. Cambiar temporalmente el navegador predeterminado a Chrome
2. Intentar iniciar sesión con Google
3. Ver si funciona

### Solución 5: Verificar Logs

Ejecuta la app con logs detallados:
```bash
flutter run -d <device_id> --verbose
```

Busca estos mensajes:
- `✅ Redirigiendo a Google OAuth`
- `📍 Deep link: io.supabase.fiestapp://login-callback`
- `🔗 Deep link inicial capturado: ...`
- `✅ Usuario autenticado: ...`

Si NO ves `🔗 Deep link inicial capturado`, significa que el deep link no está llegando a la app.

## Cambios Realizados

1. **MainActivity mejorado**: Ahora maneja mejor los deep links en `onCreate` y `onNewIntent`
2. **Captura de deep link inicial**: Añadido `getInitialLink()` en `main.dart` para capturar deep links cuando la app se abre desde OAuth

## Debugging Avanzado

Si el problema persiste, verifica:

1. **Logs de Android (logcat)**:
   ```bash
   adb logcat | grep -i "supabase\|oauth\|deep"
   ```

2. **Verificar que el intent-filter está correcto** en `AndroidManifest.xml`:
   ```xml
   <intent-filter>
       <action android:name="android.intent.action.VIEW" />
       <category android:name="android.intent.category.DEFAULT" />
       <category android:name="android.intent.category.BROWSABLE" />
       <data android:scheme="io.supabase.fiestapp" />
   </intent-filter>
   ```

3. **Verificar versión de supabase_flutter** en `pubspec.yaml`:
   - Debe ser `^2.10.3` o superior

## Si Nada Funciona

1. Verifica que las credenciales de Google OAuth estén correctamente configuradas en Supabase Dashboard
2. Prueba con otro dispositivo
3. Verifica que no haya políticas de seguridad del dispositivo bloqueando deep links
4. Considera usar un método alternativo de autenticación temporalmente

