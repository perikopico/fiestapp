# 📱 Diferencias: Android vs iOS para API Keys de Google Maps

**Fecha**: Enero 2025

---

## 🔑 Resumen Rápido

### Android
- ✅ **SHA-1** (certificado de firma)
- ✅ **Package name** (`com.perikopico.fiestapp`)
- ⚠️ Necesitas **2 SHA-1**: Debug y Release

### iOS
- ✅ **Bundle ID** (`com.perikopico.fiestapp`)
- ❌ **NO usa SHA-1**
- ✅ Usa el Bundle ID directamente

---

## 📋 Detalles

### Android: SHA-1 + Package Name

**¿Por qué SHA-1?**
- Android usa certificados digitales para firmar las apps
- Cada certificado tiene un SHA-1 único
- Google Maps verifica que la app esté firmada con el certificado correcto

**Necesitas 2 SHA-1:**
1. **Debug SHA-1**: Para desarrollo y testing
   - Keystore: `~/.android/debug.keystore` (automático)
   - SHA-1: `25:56:5F:76:47:A0:C7:E4:54:F1:54:ED:A9:F0:62:4A:41:FA:4C:E3`

2. **Release SHA-1**: Para producción (Play Store)
   - Keystore: `~/upload-keystore.jks` (lo creas tú)
   - SHA-1: (se obtiene después de crear el keystore)

**Configuración en Google Cloud Console:**
```
Application restrictions: Android apps
├─ Package name: com.perikopico.fiestapp
├─ SHA-1 (Debug): 25:56:5F:76:47:A0:C7:E4:54:F1:54:ED:A9:F0:62:4A:41:FA:4C:E3
└─ SHA-1 (Release): [TU_SHA1_DE_RELEASE]
```

---

### iOS: Bundle ID

**¿Por qué Bundle ID?**
- iOS usa el Bundle ID como identificador único de la app
- No necesita certificados SHA-1
- Google Maps verifica el Bundle ID directamente

**Bundle ID de tu app:**
- `com.perikopico.fiestapp`

**Configuración en Google Cloud Console:**
```
Application restrictions: iOS apps
└─ Bundle ID: com.perikopico.fiestapp
```

---

## 🎯 Configuración Completa en Google Cloud Console

### Para Android API Key:

1. **Application restrictions:**
   - Tipo: **Android apps**
   - Package name: `com.perikopico.fiestapp`
   - SHA-1 certificates:
     - `25:56:5F:76:47:A0:C7:E4:54:F1:54:ED:A9:F0:62:4A:41:FA:4C:E3` (Debug)
     - `[TU_SHA1_DE_RELEASE]` (Release - después de crearlo)

2. **API restrictions:**
   - ✅ Maps SDK for Android
   - ✅ Places API
   - ✅ Geocoding API

---

### Para iOS API Key:

1. **Application restrictions:**
   - Tipo: **iOS apps**
   - Bundle ID: `com.perikopico.fiestapp`

2. **API restrictions:**
   - ✅ Maps SDK for iOS
   - ✅ Places API
   - ✅ Geocoding API

---

## ✅ Checklist

### Android
- [x] SHA-1 Debug obtenido
- [ ] SHA-1 Release obtenido (vamos a crearlo ahora)
- [ ] Ambos SHA-1 añadidos a la API Key en Google Cloud Console
- [ ] Package name configurado: `com.perikopico.fiestapp`

### iOS
- [x] Bundle ID verificado: `com.perikopico.fiestapp`
- [ ] Bundle ID añadido a la API Key en Google Cloud Console

---

**Última actualización**: Enero 2025
