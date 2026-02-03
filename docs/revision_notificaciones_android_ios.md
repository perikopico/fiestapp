# Revisión de Configuración de Notificaciones Push - Android e iOS

**Fecha:** 26 de Enero, 2026  
**Alcance:** Verificación completa de la configuración de notificaciones push para Android e iOS

---

## ✅ CONFIGURACIÓN COMPLETA Y CORRECTA

### 1. **Dependencias en `pubspec.yaml`** ✅
- ✅ `firebase_core: ^3.6.0` - Instalado
- ✅ `firebase_messaging: ^15.1.3` - Instalado
- ✅ Versiones actualizadas y compatibles

### 2. **Inicialización de Firebase en `main.dart`** ✅
- ✅ `Firebase.initializeApp()` - Llamado en `_initializeBackgroundServices()`
- ✅ `FCMTokenService.instance.initialize()` - Inicializado
- ✅ `NotificationHandler.instance.initialize()` - Inicializado
- ✅ Background handler configurado: `FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler)`

### 3. **Servicios de Notificaciones** ✅
- ✅ `FCMTokenService` - Implementado correctamente
  - Manejo de tokens FCM
  - Manejo especial para iOS (APNS token)
  - Guardado en Supabase
  - Sincronización con autenticación
- ✅ `NotificationHandler` - Implementado correctamente
  - Handlers para foreground, background y cerrado
  - Navegación desde notificaciones
- ✅ `firebase_messaging_background.dart` - Handler de background configurado

### 4. **Edge Function de Supabase** ✅
- ✅ `supabase/functions/send_fcm_notification/index.ts` - Implementado
  - Usa FCM API V1
  - Maneja Service Account
  - CORS configurado

### 5. **Android - Build Configuration** ✅
- ✅ `android/app/build.gradle.kts` - Plugin `com.google.gms.google-services` aplicado
- ✅ `google-services.json` - Debe estar en `android/app/` (verificado en .gitignore)

---

## ⚠️ CONFIGURACIONES FALTANTES O PENDIENTES

### 1. **Android - Permiso POST_NOTIFICATIONS (Android 13+)** ❌ FALTA

**Problema:** Android 13 (API 33+) requiere el permiso explícito `POST_NOTIFICATIONS`.

**Ubicación:** `android/app/src/main/AndroidManifest.xml`

**Solución:**
```xml
<manifest xmlns:android="http://schemas.android.com/apk/res/android">
    <!-- ... permisos existentes ... -->
    
    <!-- ⚠️ AÑADIR ESTE PERMISO para Android 13+ -->
    <uses-permission android:name="android.permission.POST_NOTIFICATIONS"/>
    
    <!-- ... resto del manifest ... -->
</manifest>
```

**Nota:** El permiso se solicita automáticamente con `FirebaseMessaging.requestPermission()`, pero debe estar declarado en el manifest.

---

### 2. **iOS - GoogleService-Info.plist** ⚠️ VERIFICAR

**Estado:** El archivo está en `.gitignore`, lo cual es correcto, pero **DEBE existir** en el proyecto.

**Ubicación requerida:** `ios/Runner/GoogleService-Info.plist`

**Acción requerida:**
1. Descargar `GoogleService-Info.plist` desde Firebase Console
2. Colocarlo en `ios/Runner/GoogleService-Info.plist`
3. Verificar que esté incluido en el proyecto Xcode

**Cómo obtenerlo:**
1. Ir a [Firebase Console](https://console.firebase.google.com/)
2. Seleccionar tu proyecto
3. Ir a "Configuración del proyecto" (⚙️)
4. En la pestaña "General", buscar "Tus aplicaciones"
5. Seleccionar la app iOS (o crear una si no existe)
6. Descargar `GoogleService-Info.plist`

---

### 3. **iOS - Configuración de Push Notifications en Info.plist** ⚠️ VERIFICAR

**Estado:** No se encontró configuración explícita de Push Notifications en `Info.plist`.

**Ubicación:** `ios/Runner/Info.plist`

**Solución:** Aunque no es estrictamente necesario (Firebase lo maneja automáticamente), puedes añadir:

```xml
<key>UIBackgroundModes</key>
<array>
    <string>remote-notification</string>
</array>
```

**Nota:** Esto permite que la app reciba notificaciones en background. Firebase Messaging lo maneja automáticamente, pero es buena práctica declararlo.

---

### 4. **iOS - Configuración de APNs en AppDelegate.swift** ⚠️ VERIFICAR

**Estado:** `AppDelegate.swift` no tiene configuración explícita de Firebase/APNs.

**Ubicación:** `ios/Runner/AppDelegate.swift`

**Solución recomendada:** Añadir import y configuración de Firebase:

```swift
import Flutter
import UIKit
import GoogleMaps
import FirebaseCore  // ⚠️ AÑADIR
import FirebaseMessaging  // ⚠️ AÑADIR

@main
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    // ⚠️ AÑADIR: Inicializar Firebase
    FirebaseApp.configure()
    
    // Inicializar Google Maps explícitamente
    // ... (código existente) ...
    
    // ⚠️ AÑADIR: Configurar APNs para Firebase Messaging
    if #available(iOS 10.0, *) {
      UNUserNotificationCenter.current().delegate = self
      let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
      UNUserNotificationCenter.current().requestAuthorization(
        options: authOptions,
        completionHandler: { _, _ in }
      )
    } else {
      let settings: UIUserNotificationSettings =
        UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
      application.registerUserNotificationSettings(settings)
    }
    
    application.registerForRemoteNotifications()
    
    GeneratedPluginRegistrant.register(with: self)
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
  
  // ⚠️ AÑADIR: Manejar registro de APNs
  override func application(_ application: UIApplication,
                           didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
    Messaging.messaging().apnsToken = deviceToken
  }
  
  // ... (resto del código existente) ...
}
```

**Nota:** También necesitarás añadir `import UserNotifications` si usas `UNUserNotificationCenter`.

---

### 5. **iOS - Capabilities en Xcode** ⚠️ VERIFICAR MANUALMENTE

**Acción requerida en Xcode:**
1. Abrir `ios/Runner.xcworkspace` en Xcode
2. Seleccionar el target "Runner"
3. Ir a la pestaña "Signing & Capabilities"
4. Verificar que esté habilitado:
   - ✅ **Push Notifications**
   - ✅ **Background Modes** → **Remote notifications**

**Si no están habilitados:**
- Click en "+ Capability"
- Añadir "Push Notifications"
- Añadir "Background Modes" y marcar "Remote notifications"

---

### 6. **Android - google-services.json** ⚠️ VERIFICAR

**Estado:** El archivo está en `.gitignore`, lo cual es correcto, pero **DEBE existir** en el proyecto.

**Ubicación requerida:** `android/app/google-services.json`

**Acción requerida:**
1. Descargar `google-services.json` desde Firebase Console
2. Colocarlo en `android/app/google-services.json`
3. Verificar que el plugin `com.google.gms.google-services` esté aplicado (✅ ya está)

**Cómo obtenerlo:**
1. Ir a [Firebase Console](https://console.firebase.google.com/)
2. Seleccionar tu proyecto
3. Ir a "Configuración del proyecto" (⚙️)
4. En la pestaña "General", buscar "Tus aplicaciones"
5. Seleccionar la app Android (o crear una si no existe)
6. Descargar `google-services.json`

---

### 7. **Supabase Edge Function - Variables de Entorno** ⚠️ VERIFICAR

**Estado:** La Edge Function requiere variables de entorno en Supabase.

**Variables requeridas:**
- `FIREBASE_PROJECT_ID` - ID del proyecto de Firebase
- `FIREBASE_SERVICE_ACCOUNT_KEY` - JSON completo de la Service Account de Firebase

**Acción requerida:**
1. Ir a Supabase Dashboard → Edge Functions → `send_fcm_notification`
2. Configurar secrets:
   ```bash
   supabase secrets set FIREBASE_PROJECT_ID=tu-project-id
   supabase secrets set FIREBASE_SERVICE_ACCOUNT_KEY='{"type":"service_account",...}'
   ```

**Cómo obtener Service Account:**
1. Firebase Console → Configuración del proyecto → Cuentas de servicio
2. Generar nueva clave privada
3. Descargar el JSON
4. Copiar el contenido completo como string (escapar comillas si es necesario)

---

## 📋 CHECKLIST DE VERIFICACIÓN

### Android
- [x] Dependencias instaladas (`firebase_core`, `firebase_messaging`)
- [x] Plugin `com.google.gms.google-services` aplicado
- [x] Firebase inicializado en código
- [x] FCM Token Service implementado
- [x] Notification Handler implementado
- [ ] **FALTA:** Permiso `POST_NOTIFICATIONS` en AndroidManifest.xml
- [ ] **VERIFICAR:** `google-services.json` existe en `android/app/`

### iOS
- [x] Dependencias instaladas (`firebase_core`, `firebase_messaging`)
- [x] Firebase inicializado en código
- [x] FCM Token Service implementado (con manejo de APNS)
- [x] Notification Handler implementado
- [ ] **VERIFICAR:** `GoogleService-Info.plist` existe en `ios/Runner/`
- [ ] **VERIFICAR:** Capabilities en Xcode (Push Notifications, Background Modes)
- [ ] **RECOMENDADO:** Configuración explícita de Firebase/APNs en AppDelegate.swift
- [ ] **RECOMENDADO:** `UIBackgroundModes` en Info.plist

### Backend (Supabase)
- [x] Edge Function `send_fcm_notification` implementada
- [ ] **VERIFICAR:** Variables de entorno configuradas en Supabase:
  - `FIREBASE_PROJECT_ID`
  - `FIREBASE_SERVICE_ACCOUNT_KEY`

---

## 🔧 CORRECCIONES NECESARIAS

### Corrección 1: Añadir permiso POST_NOTIFICATIONS en Android

**Archivo:** `android/app/src/main/AndroidManifest.xml`

```xml
<manifest xmlns:android="http://schemas.android.com/apk/res/android">
    <uses-permission android:name="android.permission.INTERNET" />
    <uses-permission android:name="android.permission.ACCESS_FINE_LOCATION" />
    <uses-permission android:name="android.permission.ACCESS_COARSE_LOCATION" />
    <uses-permission android:name="android.permission.ACCESS_BACKGROUND_LOCATION" />
    <uses-permission android:name="android.permission.READ_EXTERNAL_STORAGE"
        android:maxSdkVersion="32" />
    <uses-permission android:name="android.permission.READ_MEDIA_IMAGES" />
    <uses-permission
        android:name="android.permission.WRITE_EXTERNAL_STORAGE"
        android:maxSdkVersion="28" />
    <!-- ⚠️ AÑADIR ESTA LÍNEA -->
    <uses-permission android:name="android.permission.POST_NOTIFICATIONS"/>
    
    <application ...>
        <!-- ... resto del manifest ... -->
    </application>
</manifest>
```

### Corrección 2: Mejorar AppDelegate.swift para iOS

**Archivo:** `ios/Runner/AppDelegate.swift`

Añadir imports y configuración de Firebase/APNs (ver sección 4 arriba).

---

## 📝 NOTAS IMPORTANTES

1. **Android 13+ (API 33+):** El permiso `POST_NOTIFICATIONS` es **obligatorio**. Sin él, las notificaciones no funcionarán en Android 13+.

2. **iOS:** El token APNS puede tardar en estar disponible. El código actual ya maneja esto con reintentos, lo cual es correcto.

3. **Firebase Console:** Asegúrate de que:
   - Tienes una app Android registrada en Firebase
   - Tienes una app iOS registrada en Firebase
   - Ambas usan el mismo proyecto de Firebase

4. **Testing:**
   - **Android:** Probar en dispositivo físico (emuladores pueden tener problemas con FCM)
   - **iOS:** Probar en dispositivo físico (simulador no soporta notificaciones push)

5. **Certificados APNs (iOS):**
   - Para desarrollo: Usar certificado de desarrollo
   - Para producción: Usar certificado de producción
   - Configurar en Firebase Console → Configuración del proyecto → Cloud Messaging → Certificados APNs

---

## ✅ RESUMEN

**Estado general:** 🟡 **Casi completo, faltan configuraciones menores**

**Acciones críticas:**
1. ⚠️ **Añadir permiso POST_NOTIFICATIONS en AndroidManifest.xml** (Android 13+)
2. ⚠️ **Verificar que `google-services.json` existe** (Android)
3. ⚠️ **Verificar que `GoogleService-Info.plist` existe** (iOS)
4. ⚠️ **Verificar Capabilities en Xcode** (iOS)
5. ⚠️ **Configurar variables de entorno en Supabase Edge Function**

**Acciones recomendadas:**
- Mejorar `AppDelegate.swift` con configuración explícita de Firebase/APNs
- Añadir `UIBackgroundModes` en Info.plist (aunque no es estrictamente necesario)

**Una vez completadas estas acciones, las notificaciones deberían funcionar correctamente en ambas plataformas.**
