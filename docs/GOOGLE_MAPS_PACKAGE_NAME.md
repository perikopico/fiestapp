# 📦 Nombre del Paquete para Google Maps

## Package Name de tu App

Cuando configures las restricciones de la API key de Google Maps en Google Cloud Console, usa este package name:

```
com.perikopico.fiestapp
```

## Dónde configurarlo

1. Ve a [Google Cloud Console](https://console.cloud.google.com/)
2. Selecciona tu proyecto
3. Ve a **APIs & Services > Credentials**
4. Haz clic en tu API key de Google Maps
5. En **Application restrictions**, selecciona **Android apps**
6. Haz clic en **+ ADD AN ITEM**
7. En **Package name**, escribe: `com.perikopico.fiestapp`
8. En **SHA-1 certificate fingerprint**, pega tu SHA-1 (obtenido con `./gradlew signingReport`)
9. Haz clic en **SAVE**

## Verificación

El package name debe coincidir exactamente con:
- `android/app/build.gradle.kts` → `applicationId = "com.perikopico.fiestapp"`
- `android/app/src/main/kotlin/com/perikopico/fiestapp/MainActivity.kt` → `package com.perikopico.fiestapp`

## ⚠️ Importante

- El package name debe ser **exactamente** `com.perikopico.fiestapp` (sin espacios, sin cambios)
- Si lo escribes mal, Google Maps no funcionará

