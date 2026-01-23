# 🔐 Configurar API Key de Google Maps para Android (Producción)

**Fecha**: Enero 2025  
**Objetivo**: Configurar restricciones de API Key para builds de producción

---

## 📋 Diferencia entre Debug y Release

### Android Debug (Desarrollo)
- ✅ Usa keystore de debug por defecto
- ✅ SHA-1: Se obtiene con `./gradlew signingReport`
- ✅ Location: `~/.android/debug.keystore`

### Android Release (Producción)
- ⚠️ **NECESITA keystore propio** (debes crearlo)
- ⚠️ SHA-1: Diferente al de debug
- ⚠️ Location: Tu keystore personal (ej: `~/upload-keystore.jks`)

---

## 🚀 Pasos para Configurar API Key de Producción

### Paso 1: Crear Keystore de Release (si no lo tienes)

**Ubicación:** Guardar en un lugar seguro (no en el repositorio)

```bash
keytool -genkey -v -keystore ~/upload-keystore.jks \
  -keyalg RSA -keysize 2048 -validity 10000 \
  -alias upload
```

**Información solicitada:**
- Nombre y apellidos: Tu nombre o nombre de la empresa
- Unidad organizativa: Tu organización (opcional)
- Organización: Nombre de tu empresa/organización
- Ciudad: Tu ciudad
- Estado/Provincia: Tu provincia/estado
- Código de país: ES (para España)
- Contraseña: **GUÁRDALA BIEN** (la necesitarás para cada build)

**⚠️ IMPORTANTE:**
- Guarda el keystore en un lugar seguro (backup)
- **NO lo subas a Git** (ya está en `.gitignore`)
- Si lo pierdes, **NO podrás actualizar la app** en Play Store

---

### Paso 2: Obtener SHA-1 del Keystore de Release

**Comando:**
```bash
keytool -list -v -keystore ~/upload-keystore.jks -alias upload
```

**O usando gradle (si ya está configurado):**
```bash
cd android
./gradlew signingReport
```

**Salida esperada:**
```
Alias name: upload
...
Certificate fingerprints:
     SHA1: 12:FE:47:5B:A4:14:D7:44:D0:C4:F8:C2:C3:68:F2:6A:63:8A:AD:7A
     SHA256: ...
```

**📝 Copia el SHA-1** (formato: `XX:XX:XX:XX:...`)

---

### Paso 3: Configurar Signing en build.gradle.kts

**Archivo:** `android/app/build.gradle.kts`

**1. Crear archivo `android/key.properties`** (ya en `.gitignore`):

```properties
storePassword=tu_password_keystore
keyPassword=tu_password_keystore
keyAlias=upload
storeFile=/ruta/completa/a/upload-keystore.jks
```

**⚠️ IMPORTANTE:** 
- Reemplaza `tu_password_keystore` con la contraseña real
- Reemplaza `/ruta/completa/a/upload-keystore.jks` con la ruta completa a tu keystore
- Usa ruta absoluta o relativa desde `android/`

**2. Actualizar `android/app/build.gradle.kts`:**

```kotlin
plugins {
    id("com.android.application")
    id("kotlin-android")
    id("dev.flutter.flutter-gradle-plugin")
    id("com.google.gms.google-services")
}

// Leer propiedades de signing
val keystorePropertiesFile = rootProject.file("key.properties")
val keystoreProperties = java.util.Properties()
if (keystorePropertiesFile.exists()) {
    keystoreProperties.load(java.io.FileInputStream(keystorePropertiesFile))
}

// Leer API key desde local.properties
val googleMapsApiKey = run {
    val localPropertiesFile = rootProject.file("local.properties")
    if (localPropertiesFile.exists()) {
        val lines = localPropertiesFile.readLines()
        val apiKeyLine = lines.find { it.startsWith("GOOGLE_MAPS_API_KEY=") }
        apiKeyLine?.substringAfter("=")?.trim() ?: ""
    } else {
        ""
    }
}

android {
    namespace = "com.perikopico.fiestapp"
    compileSdk = flutter.compileSdkVersion
    ndkVersion = flutter.ndkVersion

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_11
        targetCompatibility = JavaVersion.VERSION_11
    }

    kotlinOptions {
        jvmTarget = JavaVersion.VERSION_11.toString()
    }

    // Configurar signing configs
    signingConfigs {
        create("release") {
            if (keystorePropertiesFile.exists()) {
                keyAlias = keystoreProperties["keyAlias"] as String
                keyPassword = keystoreProperties["keyPassword"] as String
                storeFile = file(keystoreProperties["storeFile"] as String)
                storePassword = keystoreProperties["storePassword"] as String
            }
        }
    }

    defaultConfig {
        applicationId = "com.perikopico.fiestapp"
        minSdk = flutter.minSdkVersion
        targetSdk = flutter.targetSdkVersion
        versionCode = flutter.versionCode
        versionName = flutter.versionName
        
        manifestPlaceholders["GOOGLE_MAPS_API_KEY"] = googleMapsApiKey
    }

    buildTypes {
        release {
            // Usar signing config de release
            signingConfig = signingConfigs.getByName("release")
            
            // Optimizaciones para release
            isMinifyEnabled = false
            proguardFiles(
                getDefaultProguardFile("proguard-android-optimize.txt"),
                "proguard-rules.pro"
            )
        }
    }
}

flutter {
    source = "../.."
}
```

---

### Paso 4: Configurar API Key en Google Cloud Console

**1. Ir a [Google Cloud Console](https://console.cloud.google.com/)**

**2. Seleccionar tu proyecto**

**3. Navegar a:** APIs & Services → Credentials

**4. Buscar tu API Key de Google Maps (Android)** o crear una nueva

**5. Hacer clic en la API Key para editarla**

**6. En "Application restrictions" → Seleccionar "Android apps"**

**7. Añadir restricciones:**

   **Para Debug (desarrollo):**
   - Package name: `com.perikopico.fiestapp`
   - SHA-1 certificate fingerprint: `TU_SHA1_DEBUG` 
     - Obtener con: `cd android && ./gradlew signingReport` (ver Debug variant)

   **Para Release (producción):**
   - Package name: `com.perikopico.fiestapp`
   - SHA-1 certificate fingerprint: `TU_SHA1_RELEASE`
     - Obtener con: `keytool -list -v -keystore ~/upload-keystore.jks -alias upload`
   
   **⚠️ IMPORTANTE:** Puedes añadir **múltiples SHA-1** (tanto debug como release)
   
   **✅ Mejor práctica:** Añade ambos (debug y release) para poder desarrollar y publicar

**8. En "API restrictions" → Seleccionar "Restrict key"**

   **APIs necesarias:**
   - ✅ Maps SDK for Android
   - ✅ Places API (New)
   - ✅ Geocoding API
   - ✅ Places API (Legacy) - solo si usas la API antigua

**9. Guardar cambios**

---

## 📋 Resumen: Restricciones para Android vs iOS

### iOS
- **Tipo de restricción:** iOS apps
- **Identificador:** Bundle ID (`com.perikopico.fiestapp`)
- **Ubicación:** Google Cloud Console → API Key → Application restrictions → iOS apps

### Android
- **Tipo de restricción:** Android apps
- **Identificadores:**
  - **Package name:** `com.perikopico.fiestapp` (obligatorio)
  - **SHA-1 certificate fingerprint:** (obligatorio)
    - Debug: Se obtiene con `./gradlew signingReport`
    - Release: Se obtiene con `keytool -list -v -keystore [keystore] -alias [alias]`
- **Ubicación:** Google Cloud Console → API Key → Application restrictions → Android apps

**⚠️ DIFERENCIA CLAVE:**
- **iOS:** Solo necesitas Bundle ID
- **Android:** Necesitas Package name **Y** SHA-1 fingerprint

---

## ✅ Checklist para Publicación

### Antes de crear el build de release:

- [ ] ✅ Keystore de release creado
- [ ] ✅ SHA-1 de release obtenido
- [ ] ✅ `key.properties` configurado (no versionado)
- [ ] ✅ `build.gradle.kts` configurado para signing
- [ ] ✅ API Key en Google Cloud Console tiene SHA-1 de release
- [ ] ✅ API Key tiene restricciones de API configuradas

### Para configurar la API Key:

- [ ] ✅ Package name: `com.perikopico.fiestapp`
- [ ] ✅ SHA-1 de debug añadido (para desarrollo)
- [ ] ✅ SHA-1 de release añadido (para producción)
- [ ] ✅ Restricciones de API configuradas
- [ ] ✅ Límites de cuota configurados
- [ ] ✅ Alertas de facturación configuradas

---

## 🔍 Verificar SHA-1 Después de Configurar

**Para verificar que todo está bien:**

```bash
# Build de release (no firmado todavía)
cd android
./gradlew signingReport

# Debe mostrar el SHA-1 de release (variant: release)
```

**O directamente:**
```bash
keytool -list -v -keystore ~/upload-keystore.jks -alias upload
```

**Verificar en Google Cloud Console:**
- El SHA-1 debe coincidir exactamente (incluyendo los dos puntos `:`)

---

## ⚠️ IMPORTANTE: Múltiples SHA-1

**Puedes añadir múltiples SHA-1 a la misma API Key:**

1. **SHA-1 de debug** (desarrollo local)
   - Obtener: `./gradlew signingReport` → variant: debug
   - Ejemplo: `12:FE:47:5B:A4:14:D7:44:D0:C4:F8:C2:C3:68:F2:6A:63:8A:AD:7A`

2. **SHA-1 de release** (producción)
   - Obtener: `keytool -list -v -keystore ~/upload-keystore.jks -alias upload`
   - Ejemplo: `AB:CD:EF:12:34:56:78:90:AB:CD:EF:12:34:56:78:90:AB:CD:EF:12`

**Ventaja:** Puedes usar la misma API Key para desarrollo y producción

---

## 🆘 Problemas Comunes

### "API key not authorized"
**Causa:** El SHA-1 no coincide o no está añadido  
**Solución:** Verificar que el SHA-1 del build coincide con el de Google Cloud Console

### "This API key is restricted to a different package"
**Causa:** Package name incorrecto  
**Solución:** Verificar que el package name es exactamente `com.perikopico.fiestapp`

### La app funciona en debug pero no en release
**Causa:** SHA-1 de release no añadido a la API Key  
**Solución:** Añadir SHA-1 de release a las restricciones de la API Key

---

## 📚 Referencias

- [Google Maps API Key Best Practices](https://developers.google.com/maps/api-security-best-practices)
- [Android App Signing](https://developer.android.com/studio/publish/app-signing)
- [Play App Signing](https://support.google.com/googleplay/android-developer/answer/9842756)

---

**Última actualización**: Enero 2025
