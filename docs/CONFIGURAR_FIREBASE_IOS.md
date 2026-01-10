# 🔥 Configurar Firebase para iOS - QuePlan

**Fecha**: Enero 2025  
**Problema**: Token FCM falla en iPhone - "No Firebase App '[DEFAULT]' has been created"

---

## 🚨 Problema

Al ejecutar la app en iOS, aparecen estos errores:
```
❌ Error al inicializar FCMTokenService: [core/no-app] No Firebase App '[DEFAULT]' has been created - call Firebase.initializeApp()
❌ Error al obtener token FCM: [core/no-app] No Firebase App '[DEFAULT]' has been created - call Firebase.initializeApp()
```

**Causa**: Falta el archivo `GoogleService-Info.plist` en iOS, que es necesario para que Firebase funcione.

---

## ✅ Solución: Agregar GoogleService-Info.plist

### Paso 1: Obtener GoogleService-Info.plist desde Firebase Console

1. Ve a [Firebase Console](https://console.firebase.google.com/)
2. Selecciona tu proyecto (o créalo si no existe)
3. Haz clic en el icono de **⚙️ Settings** (Configuración del proyecto)
4. En la sección **"Your apps"**, busca la app de iOS
   - Si no existe, haz clic en **"Add app"** → **iOS**
   - Bundle ID: `com.perikopico.fiestapp`
   - App nickname: `QuePlan iOS`
5. Haz clic en **"Download GoogleService-Info.plist"**
6. **Guarda el archivo** en tu Mac

### Paso 2: Agregar el archivo al proyecto iOS

1. **Abre Xcode**:
   ```bash
   cd ios
   open Runner.xcworkspace
   ```

2. **En Xcode**:
   - En el navegador izquierdo, haz clic derecho en la carpeta **"Runner"**
   - Selecciona **"Add Files to Runner..."**
   - Navega hasta donde guardaste `GoogleService-Info.plist`
   - **IMPORTANTE**: Marca la casilla **"Copy items if needed"**
   - Asegúrate de que el **Target "Runner"** esté seleccionado
   - Haz clic en **"Add"**

3. **Verifica que el archivo esté en el proyecto**:
   - Deberías ver `GoogleService-Info.plist` en la carpeta `Runner`
   - El archivo debe aparecer en el navegador de Xcode

### Paso 3: Verificar que el archivo esté en .gitignore

**⚠️ IMPORTANTE**: Este archivo contiene credenciales sensibles y NO debe subirse a Git.

1. Verifica que `ios/Runner/GoogleService-Info.plist` esté en `.gitignore`:
   ```bash
   cat .gitignore | grep GoogleService-Info
   ```

2. Si no está, añádelo:
   ```bash
   echo "ios/Runner/GoogleService-Info.plist" >> .gitignore
   ```

### Paso 4: Recompilar la app

```bash
flutter clean
flutter pub get
cd ios
pod install
cd ..
flutter run
```

---

## 🔍 Verificación

Después de agregar el archivo, deberías ver en los logs:

```
✅ Firebase inicializado con éxito
✅ Permisos de notificación concedidos
🔑 FCM TOKEN obtenido: ...
```

**NO deberías ver:**
- ❌ "No Firebase App '[DEFAULT]' has been created"
- ❌ "Error al inicializar FCMTokenService"

---

## 📋 Estructura del Archivo GoogleService-Info.plist

El archivo debería verse así (con tus valores reales):

```xml
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
	<key>API_KEY</key>
	<string>AIza...</string>
	<key>GCM_SENDER_ID</key>
	<string>123456789</string>
	<key>PLIST_VERSION</key>
	<string>1</string>
	<key>BUNDLE_ID</key>
	<string>com.perikopico.fiestapp</string>
	<key>PROJECT_ID</key>
	<string>tu-proyecto-id</string>
	<key>STORAGE_BUCKET</key>
	<string>tu-proyecto-id.appspot.com</string>
	<key>IS_ADS_ENABLED</key>
	<false/>
	<key>IS_ANALYTICS_ENABLED</key>
	<false/>
	<key>IS_APPINVITE_ENABLED</key>
	<true/>
	<key>IS_GCM_ENABLED</key>
	<true/>
	<key>IS_SIGNIN_ENABLED</key>
	<true/>
	<key>GOOGLE_APP_ID</key>
	<string>1:123456789:ios:abcdef</string>
	<key>DATABASE_URL</key>
	<string>https://tu-proyecto-id.firebaseio.com</string>
</dict>
</plist>
```

---

## 🚨 Si No Tienes Proyecto Firebase

Si no tienes un proyecto Firebase configurado:

1. **Crea un proyecto en Firebase Console**:
   - Ve a: https://console.firebase.google.com/
   - Haz clic en **"Add project"**
   - Nombre: `QuePlan` o similar
   - Sigue los pasos para crear el proyecto

2. **Agrega la app iOS**:
   - En el proyecto, haz clic en **"Add app"** → **iOS**
   - Bundle ID: `com.perikopico.fiestapp`
   - Descarga `GoogleService-Info.plist`

3. **Habilita Cloud Messaging**:
   - En Firebase Console, ve a **Build** → **Cloud Messaging**
   - Asegúrate de que esté habilitado

---

## 📝 Checklist

- [ ] Proyecto Firebase creado
- [ ] App iOS agregada al proyecto Firebase
- [ ] `GoogleService-Info.plist` descargado
- [ ] Archivo agregado a Xcode en la carpeta `Runner`
- [ ] Archivo en `.gitignore`
- [ ] App recompilada
- [ ] Logs muestran "✅ Firebase inicializado con éxito"
- [ ] Token FCM se obtiene correctamente

---

## 🔗 Referencias

- [Firebase iOS Setup](https://firebase.google.com/docs/ios/setup)
- [FlutterFire Setup](https://firebase.flutter.dev/docs/overview)

