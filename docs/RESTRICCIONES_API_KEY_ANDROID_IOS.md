# 🔐 Restricciones de API Key: Android vs iOS

**Fecha**: Enero 2025  
**Objetivo**: Explicar las diferencias entre restricciones de API Key para Android e iOS

---

## 📋 Diferencia Principal

### iOS 🍎
- **Solo necesitas:** Bundle ID
- **Ejemplo:** `com.perikopico.fiestapp`
- **Ubicación:** Google Cloud Console → API Key → Application restrictions → iOS apps

### Android 🤖
- **Necesitas DOS cosas:**
  1. **Package name** (obligatorio)
  2. **SHA-1 certificate fingerprint** (obligatorio)
- **Ejemplo:**
  - Package name: `com.perikopico.fiestapp`
  - SHA-1: `12:FE:47:5B:A4:14:D7:44:D0:C4:F8:C2:C3:68:F2:6A:63:8A:AD:7A`
- **Ubicación:** Google Cloud Console → API Key → Application restrictions → Android apps

---

## 🔑 ¿Por qué Android necesita SHA-1?

El SHA-1 es una "huella digital" única del certificado que firma tu app. Google Maps la usa para verificar que:
- La app está firmada con TU certificado
- No ha sido modificada por terceros
- Pertenece realmente a tu cuenta de Google Cloud

**iOS no lo necesita** porque Apple ya verifica la identidad de la app a través del Bundle ID y su proceso de revisión.

---

## 📱 SHA-1 para Debug vs Release

### ⚠️ IMPORTANTE: Son DIFERENTES

**Debug (Desarrollo):**
- Keystore: `~/.android/debug.keystore` (generado automáticamente)
- SHA-1: Diferente al de release
- **Uso:** Desarrollo local, testing

**Release (Producción):**
- Keystore: Tu keystore personal (ej: `~/upload-keystore.jks`)
- SHA-1: Diferente al de debug
- **Uso:** Publicación en Play Store

### ✅ Solución: Añadir AMBOS SHA-1

**Puedes añadir múltiples SHA-1 a la misma API Key:**
1. SHA-1 de debug (para desarrollo)
2. SHA-1 de release (para producción)

**Ventaja:** Usas la misma API Key para ambos casos.

---

## 🚀 Cómo Obtener el SHA-1

### Para Debug (Desarrollo Local)

```bash
cd android
./gradlew signingReport
```

**Busca en la salida:**
```
Variant: debug
Config: debug
Store: ~/.android/debug.keystore
Alias: AndroidDebugKey
MD5: ...
SHA1: 12:FE:47:5B:A4:14:D7:44:D0:C4:F8:C2:C3:68:F2:6A:63:8A:AD:7A
SHA-256: ...
```

**📝 Copia el SHA1** (el que está después de "SHA1:")

---

### Para Release (Producción)

**Paso 1: Crear keystore de release** (si no lo tienes):

```bash
keytool -genkey -v -keystore ~/upload-keystore.jks \
  -keyalg RSA -keysize 2048 -validity 10000 \
  -alias upload
```

**⚠️ IMPORTANTE:** Guarda el keystore y la contraseña en un lugar seguro.

---

**Paso 2: Obtener SHA-1 del keystore de release:**

```bash
keytool -list -v -keystore ~/upload-keystore.jks -alias upload
```

**Salida esperada:**
```
Alias name: upload
Creation date: ...
Entry type: PrivateKeyEntry
Certificate chain length: 1
Certificate[1]:
Owner: ...
Issuer: ...
Serial number: ...
Valid from: ... until: ...
Certificate fingerprints:
     SHA1: AB:CD:EF:12:34:56:78:90:AB:CD:EF:12:34:56:78:90:AB:CD:EF:12
     SHA256: ...
Signature algorithm name: SHA256withRSA
```

**📝 Copia el SHA1** (el que está después de "SHA1:")

**O si ya configuraste signing en build.gradle.kts:**

```bash
cd android
./gradlew signingReport
```

**Busca en la salida:**
```
Variant: release
Config: release
Store: /ruta/a/tu/upload-keystore.jks
Alias: upload
SHA1: AB:CD:EF:12:34:56:78:90:AB:CD:EF:12:34:56:78:90:AB:CD:EF:12
```

---

## 📋 Configurar en Google Cloud Console

### Paso 1: Ir a Google Cloud Console

1. Ir a [Google Cloud Console](https://console.cloud.google.com/)
2. Seleccionar tu proyecto
3. Navegar a: **APIs & Services** → **Credentials**

### Paso 2: Editar tu API Key de Android

1. Hacer clic en tu API Key de Google Maps (Android)
2. En **"Application restrictions"** → Seleccionar **"Android apps"**

### Paso 3: Añadir Restricciones

**Para cada SHA-1 (puedes añadir múltiples):**

1. Hacer clic en **"+ Add an item"**
2. Rellenar:
   - **Package name:** `com.perikopico.fiestapp`
   - **SHA-1 certificate fingerprint:** Pega tu SHA-1
     - Ejemplo: `12:FE:47:5B:A4:14:D7:44:D0:C4:F8:C2:C3:68:F2:6A:63:8A:AD:7A`
3. Repetir para el segundo SHA-1 (si quieres usar debug y release)

**Ejemplo visual:**
```
┌─────────────────────────────────────────┐
│ Android apps                            │
├─────────────────────────────────────────┤
│ ✓ com.perikopico.fiestapp              │
│   SHA-1: 12:FE:47:5B:A4:14:D7:44...    │
│   (Debug)                               │
├─────────────────────────────────────────┤
│ ✓ com.perikopico.fiestapp              │
│   SHA-1: AB:CD:EF:12:34:56:78:90...    │
│   (Release)                             │
└─────────────────────────────────────────┘
```

### Paso 4: Configurar Restricciones de API

1. En **"API restrictions"** → Seleccionar **"Restrict key"**
2. Marcar solo las APIs necesarias:
   - ✅ Maps SDK for Android
   - ✅ Places API (New)
   - ✅ Geocoding API

### Paso 5: Guardar

Hacer clic en **"Save"** en la parte inferior.

---

## ✅ Workflow Completo para Publicación

### 1. Desarrollo (Debug)

**Configuración:**
- API Key tiene SHA-1 de debug añadido
- Build usa keystore de debug automáticamente
- ✅ Funciona en desarrollo local

**SHA-1 a añadir:**
```bash
cd android
./gradlew signingReport
# Copiar SHA1 del variant: debug
```

---

### 2. Preparación para Release

**Pasos:**
1. Crear keystore de release (si no existe)
2. Obtener SHA-1 de release:
   ```bash
   keytool -list -v -keystore ~/upload-keystore.jks -alias upload
   ```
3. Añadir SHA-1 de release a la API Key en Google Cloud Console
4. Configurar signing en `build.gradle.kts`
5. Probar build de release:
   ```bash
   flutter build appbundle --release
   ```

---

### 3. Publicación

**Build final:**
```bash
flutter build appbundle --release
```

**Verificar:**
- ✅ El bundle (.aab) se genera correctamente
- ✅ Google Maps funciona en la versión de release
- ✅ No hay errores relacionados con API Key

**Subir a Play Store:**
- El archivo `.aab` se firma con tu keystore de release
- Google Play verifica el SHA-1 automáticamente
- Tu API Key debe tener el SHA-1 de release configurado

---

## 🔍 Verificar que Todo Está Bien

### Verificar SHA-1 del Build

**Para Debug:**
```bash
cd android
./gradlew signingReport
# Ver variant: debug
```

**Para Release:**
```bash
cd android
./gradlew signingReport
# Ver variant: release
# O directamente:
keytool -list -v -keystore ~/upload-keystore.jks -alias upload
```

### Verificar en Google Cloud Console

1. Ir a tu API Key
2. Ver "Application restrictions"
3. Verificar que tienes:
   - ✅ Package name: `com.perikopico.fiestapp`
   - ✅ SHA-1 de debug (si desarrollas)
   - ✅ SHA-1 de release (para producción)

### Probar en la App

**Debug:**
```bash
flutter run
# Verificar que Google Maps carga correctamente
```

**Release:**
```bash
flutter build apk --release
# Instalar en dispositivo y verificar que Google Maps funciona
```

---

## ⚠️ Problemas Comunes

### "API key not authorized" en Release

**Causa:** SHA-1 de release no añadido a la API Key  
**Solución:** 
1. Obtener SHA-1 de release
2. Añadirlo a las restricciones de la API Key

### "This API key is restricted to a different package"

**Causa:** Package name incorrecto  
**Solución:** Verificar que el package name es exactamente `com.perikopico.fiestapp`

### La app funciona en Debug pero no en Release

**Causa:** SHA-1 de release no configurado  
**Solución:** Añadir SHA-1 de release a la API Key

### Play Store acepta el bundle pero Maps no funciona

**Causa:** Play App Signing usa un SHA-1 diferente  
**Solución:** 
1. Ir a Play Console → Setup → App Integrity
2. Ver el "App signing key certificate"
3. Obtener el SHA-1 desde ahí
4. Añadirlo también a la API Key

**Nota:** Google Play puede re-firmar tu app con su propio certificado. En ese caso, necesitas el SHA-1 que Play Store muestra.

---

## 📝 Resumen Visual

### iOS 🍎
```
Google Cloud Console
└── API Key (iOS)
    └── Application restrictions
        └── iOS apps
            └── Bundle ID: com.perikopico.fiestapp ✅
```

### Android 🤖
```
Google Cloud Console
└── API Key (Android)
    └── Application restrictions
        └── Android apps
            ├── Package: com.perikopico.fiestapp ✅
            │   SHA-1 (Debug): 12:FE:47:5B... ✅
            │
            └── Package: com.perikopico.fiestapp ✅
                SHA-1 (Release): AB:CD:EF:12... ✅
```

---

## 🎯 Checklist Final

### Para Desarrollo
- [ ] ✅ SHA-1 de debug obtenido
- [ ] ✅ SHA-1 de debug añadido a API Key
- [ ] ✅ API Key funciona en debug builds

### Para Publicación
- [ ] ✅ Keystore de release creado
- [ ] ✅ SHA-1 de release obtenido
- [ ] ✅ SHA-1 de release añadido a API Key
- [ ] ✅ Signing configurado en build.gradle.kts
- [ ] ✅ Build de release funciona
- [ ] ✅ Google Maps funciona en release build

---

**Última actualización**: Enero 2025
