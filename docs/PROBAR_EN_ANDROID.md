# 📱 Probar Autenticación en Android

## ✅ Por qué Android es mejor para probar:

1. **Google OAuth funciona mejor** en Android que en Linux
2. **Deep links configurados** - Ya añadí el intent-filter necesario
3. **Experiencia real** - Más cercano al entorno de producción

## 🚀 Pasos para Probar:

### 1. Verificar que un dispositivo Android está conectado

```bash
flutter devices
```

Deberías ver algo como:
```
2 connected devices:
sdk gphone64 arm64 (mobile) • emulator-5554 • android-arm64  • Android 14 (API 34)
Linux (desktop)             • linux          • linux-x64      • ...
```

### 2. Ejecutar en Android

```bash
flutter run -d android
```

O selecciona el dispositivo desde el IDE.

### 3. Probar Login con Google

1. Abre la app en tu dispositivo Android
2. Toca el icono de login (esquina superior derecha)
3. Toca "Continuar con Google"
4. Deberías ver la pantalla de autorización de Google
5. Autoriza y deberías iniciar sesión

## ⚠️ Notas Importantes:

### Deep Links Configurados ✅

Ya he añadido el intent-filter en `AndroidManifest.xml`:
- Scheme: `io.supabase.fiestapp`
- Esto permite que Google OAuth redirija de vuelta a la app

### Si hay problemas:

1. **Verifica que el email está como test user** en Google Cloud Console
2. **Verifica las credenciales** en Supabase Dashboard
3. **Revisa los logs** en la consola:
   ```bash
   flutter run -d android -v
   ```

## 🔍 Verificar que funciona:

Después de iniciar sesión:
- ✅ Deberías ver el icono de perfil en lugar del de login
- ✅ Si tocas el perfil, deberías ver tu email
- ✅ Si eres admin, verás "Panel de administración"

