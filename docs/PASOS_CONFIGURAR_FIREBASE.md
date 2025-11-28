# 🚀 Pasos Rápidos para Configurar Firebase

## ⚡ Guía Rápida (5 minutos)

### 1️⃣ Agregar App Android en Firebase

1. Ve a: https://console.firebase.google.com/
2. Selecciona proyecto **QuePlan**
3. Clic en icono **Android** (o "Agregar app")
4. **Package name**: `com.perikopico.fiestapp`
5. Clic en **"Registrar app"**

### 2️⃣ Descargar google-services.json

1. Descarga el archivo `google-services.json`
2. Colócalo en: `android/app/google-services.json`

### 3️⃣ Archivos Gradle (Ya actualizados ✅)

Los archivos Gradle ya están configurados con:
- Plugin de Google Services en `android/build.gradle.kts`
- Plugin aplicado en `android/app/build.gradle.kts`

**Solo necesitas:**
- Descargar `google-services.json` y ponerlo en `android/app/`

### 4️⃣ Habilitar Cloud Messaging

1. Firebase Console → **Engage > Cloud Messaging**
2. Clic en **"Get started"** o **"Comenzar"**

### 5️⃣ Probar

1. Reinicia la app
2. Ve a Notificaciones
3. Deberías ver el token FCM 🎉

---

## 📝 Checklist

- [ ] App Android agregada en Firebase Console
- [ ] `google-services.json` descargado
- [ ] `google-services.json` en `android/app/`
- [ ] Cloud Messaging habilitado en Firebase
- [ ] App reiniciada
- [ ] Token FCM visible en pantalla de Notificaciones

---

## 🔗 Guía Completa

Para más detalles, revisa: `docs/CONFIGURAR_FIREBASE.md`

