# 🔥 Configurar Firebase para Notificaciones Push

## ✅ Qué necesitas

1. Proyecto creado en Firebase Console (ya lo tienes ✅)
2. Descargar el archivo de configuración `google-services.json`
3. Configurar el proyecto Android
4. Habilitar Cloud Messaging en Firebase Console

---

## 📱 PASO 1: Agregar App Android en Firebase Console

1. Ve a: https://console.firebase.google.com/
2. Selecciona tu proyecto **QuePlan**
3. En la pantalla de inicio, haz clic en el icono de **Android** (o "Agregar app")
4. Completa el formulario:
   - **Nombre del paquete Android**: `com.perikopico.fiestapp`
   - **Apodo de la app** (opcional): `QuePlan`
   - **Certificado de firma del depuración SHA-1** (opcional por ahora): Déjalo vacío o más adelante lo añadimos
5. Haz clic en **"Registrar app"**

---

## 📥 PASO 2: Descargar google-services.json

1. Después de registrar la app, Firebase te mostrará un botón para **"Descargar google-services.json"**
2. **Descarga el archivo**
3. **Importante**: El archivo debe ir en:
   ```
   android/app/google-services.json
   ```

**Ubicación exacta:**
```
fiestapp/
└── android/
    └── app/
        └── google-services.json  ← AQUÍ
```

---

## 🔧 PASO 3: Configurar build.gradle

Necesitamos agregar el plugin de Google Services a los archivos Gradle.

### 3.1. Editar `android/build.gradle.kts` (nivel proyecto)

Agrega el plugin al bloque `plugins` o al final del archivo:

```kotlin
plugins {
    // ... plugins existentes ...
    id("com.google.gms.google-services") version "4.4.2" apply false
}
```

O si ya hay un bloque `buildscript`, agrega:

```kotlin
buildscript {
    dependencies {
        classpath("com.google.gms:google-services:4.4.2")
    }
}
```

### 3.2. Editar `android/app/build.gradle.kts` (nivel app)

Al **final del archivo**, agrega:

```kotlin
plugins {
    // ... plugins existentes ...
    id("com.google.gms.google-services")
}
```

---

## ✅ PASO 4: Verificar configuración

Después de estos pasos, tu estructura debería ser:

```
android/
├── build.gradle.kts  (con plugin de google-services)
└── app/
    ├── build.gradle.kts  (con plugin de google-services al final)
    └── google-services.json  (descargado de Firebase)
```

---

## 🔔 PASO 5: Habilitar Cloud Messaging en Firebase

1. Ve a Firebase Console → Tu proyecto
2. Ve a **Engage > Cloud Messaging**
3. Si es la primera vez, haz clic en **"Get started"** o **"Comenzar"**
4. Acepta los términos si te los pide

**¡Listo!** Ya tienes Cloud Messaging habilitado.

---

## 🧪 PASO 6: Probar que funciona

1. **Reinicia la app** (ciérrala completamente y vuelve a abrirla)
2. Ve a la pantalla de **Notificaciones**
3. Deberías ver el token FCM en la sección de Debug

Si ves el token, **¡Firebase está configurado correctamente!** 🎉

---

## 🚨 Solución de Problemas

### Problema: "google-services.json no encontrado"

**Solución:**
- Verifica que el archivo esté en `android/app/google-services.json`
- Verifica que el nombre del archivo sea exactamente `google-services.json` (con guión)

### Problema: "Plugin with id 'com.google.gms.google-services' not found"

**Solución:**
- Verifica que agregaste el plugin en `android/build.gradle.kts`
- Verifica que la versión del plugin es correcta (4.4.2 o más reciente)
- Ejecuta: `flutter clean && flutter pub get`

### Problema: "Package name mismatch"

**Solución:**
- Verifica que el package name en Firebase Console sea: `com.perikopico.fiestapp`
- Verifica que en `android/app/build.gradle.kts` el `applicationId` sea: `com.perikopico.fiestapp`

### Problema: Token FCM no se obtiene

**Solución:**
- Verifica que los permisos de notificación estén concedidos
- Revisa los logs de Flutter para ver errores específicos
- Verifica que Firebase esté inicializado (busca en logs: `✅ Firebase inicializado`)

---

## 📝 Resumen Rápido

1. ✅ Agregar app Android en Firebase Console
2. ✅ Descargar `google-services.json` → ponerlo en `android/app/`
3. ✅ Agregar plugin en `android/build.gradle.kts`
4. ✅ Agregar plugin en `android/app/build.gradle.kts`
5. ✅ Habilitar Cloud Messaging en Firebase Console
6. ✅ Probar la app

---

## 🔗 Enlaces Útiles

- Firebase Console: https://console.firebase.google.com/
- Documentación FlutterFire: https://firebase.flutter.dev/docs/overview
- Documentación FCM: https://firebase.flutter.dev/docs/messaging/overview

---

**¿Necesitas ayuda?** Revisa los logs de Flutter para ver qué error específico aparece.

