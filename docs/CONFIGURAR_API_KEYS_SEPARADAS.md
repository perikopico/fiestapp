# 🔑 Configurar API Keys Separadas para Android e iOS

**Fecha**: Enero 2025  
**Tiempo estimado**: 15 minutos

---

## 📋 Resumen

Esta guía te ayudará a configurar **API Keys separadas** para Android e iOS. Esto es útil si:
- Prefieres mayor seguridad (aislamiento entre plataformas)
- Tienes problemas configurando restricciones múltiples
- Quieres gestionar cuotas por separado

---

## 🔑 Paso 1: Crear Nueva API Key para iOS

### 1.1 Acceder a Google Cloud Console

1. Ve a: https://console.cloud.google.com/
2. Selecciona tu proyecto
3. Ve a **APIs & Services** → **Credentials**

### 1.2 Crear Nueva API Key

1. Haz clic en **"+ CREATE CREDENTIALS"** → **"API key"**
2. Se creará una nueva API Key
3. **Copia la API Key** (la necesitarás para iOS)
4. Haz clic en **"RESTRICT KEY"** para configurar restricciones

### 1.3 Configurar Restricciones para iOS

#### Restricciones de Aplicación:
1. Selecciona **"iOS apps"**
2. Haz clic en **"Add an item"**
3. Añade el **Bundle ID**: `com.perikopico.fiestapp`
4. Guarda

#### Restricciones de API:
1. Selecciona **"Restrict key"**
2. Marca las APIs necesarias:
   - ✅ **Maps SDK for iOS** (obligatorio)
   - ✅ **Places API** (si usas búsqueda de lugares)
   - ✅ **Geocoding API** (si usas geocodificación)
3. Guarda

### 1.4 Nombrar la API Key

1. En la parte superior, haz clic en **"Edit API key"**
2. Añade un nombre descriptivo: `QuePlan - iOS - Google Maps`
3. Guarda

---

## 📱 Paso 2: Configurar API Key en iOS

### Opción A: Configurar en Info.plist (Recomendado)

1. Abre `ios/Runner/Info.plist`
2. Añade la nueva API Key de iOS:

```xml
<key>GMSApiKey</key>
<string>TU_API_KEY_IOS_AQUI</string>
```

**⚠️ IMPORTANTE**: 
- Usa la **nueva API Key** que creaste para iOS
- NO uses la misma que Android
- NO subas `Info.plist` con la API Key a Git si está hardcodeada

### Opción B: Configurar en AppDelegate.swift

1. Abre `ios/Runner/AppDelegate.swift`
2. Añade:

```swift
import GoogleMaps

// En didFinishLaunchingWithOptions:
GMSServices.provideAPIKey("TU_API_KEY_IOS_AQUI")
```

### Opción C: Leer desde archivo de configuración (Más seguro)

1. Crea un archivo `ios/Runner/GoogleService-Info.plist` (añádelo a `.gitignore`)
2. Añade:

```xml
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
    <key>API_KEY</key>
    <string>TU_API_KEY_IOS_AQUI</string>
</dict>
</plist>
```

3. En `AppDelegate.swift`:

```swift
if let path = Bundle.main.path(forResource: "GoogleService-Info", ofType: "plist"),
   let plist = NSDictionary(contentsOfFile: path),
   let apiKey = plist["API_KEY"] as? String {
    GMSServices.provideAPIKey(apiKey)
}
```

---

## ✅ Paso 3: Verificar Configuración

### Android
- [ ] API Key de Android: `AIzaSyB3QZYmsSb1GmIewWnDS-KewupE3Ths_dY`
- [ ] Configurada en: `android/local.properties`
- [ ] Restricciones: Solo Android apps
- [ ] Package name: `com.perikopico.fiestapp`

### iOS
- [ ] API Key de iOS: (nueva, diferente a Android)
- [ ] Configurada en: `ios/Runner/Info.plist` o `AppDelegate.swift`
- [ ] Restricciones: Solo iOS apps
- [ ] Bundle ID: `com.perikopico.fiestapp`

---

## 📊 Resumen de Configuración

| Plataforma | API Key | Ubicación | Restricciones |
|------------|---------|-----------|---------------|
| **Android** | `AIzaSyB3QZYmsSb1GmIewWnDS-KewupE3Ths_dY` | `android/local.properties` | Android apps: `com.perikopico.fiestapp` |
| **iOS** | `TU_API_KEY_IOS_AQUI` | `ios/Runner/Info.plist` | iOS apps: `com.perikopico.fiestapp` |

---

## 🔐 Ventajas de API Keys Separadas

✅ **Seguridad**:
- Si una plataforma se compromete, la otra sigue segura
- Aislamiento completo entre plataformas

✅ **Gestión**:
- Cuotas separadas por plataforma
- Rotación independiente de keys
- Monitoreo separado

✅ **Flexibilidad**:
- Diferentes restricciones por plataforma
- APIs diferentes si es necesario

---

## 📝 Checklist Final

### Google Cloud Console
- [ ] API Key de Android creada y restringida
- [ ] API Key de iOS creada y restringida
- [ ] Maps SDK for Android habilitada (para Android)
- [ ] Maps SDK for iOS habilitada (para iOS)
- [ ] Restricciones de aplicación configuradas para cada key

### Configuración en el Código
- [ ] API Key de Android en `android/local.properties`
- [ ] API Key de iOS en `ios/Runner/Info.plist` o `AppDelegate.swift`
- [ ] `AppDelegate.swift` importa `GoogleMaps`
- [ ] Archivos sensibles en `.gitignore`

### Verificación
- [ ] App Android compila sin errores
- [ ] App iOS compila sin errores
- [ ] Mapas cargan en Android
- [ ] Mapas cargan en iOS

---

## 🐛 Solución de Problemas

### Problema: "API key not valid" en iOS

**Causas posibles**:
1. API Key incorrecta
2. Bundle ID no coincide
3. Maps SDK for iOS no habilitada

**Solución**:
1. Verificar que la API Key en `Info.plist` es la correcta (la de iOS, no la de Android)
2. Verificar que el Bundle ID en Google Cloud Console es `com.perikopico.fiestapp`
3. Verificar que "Maps SDK for iOS" está habilitada

### Problema: Confusión entre API Keys

**Solución**:
- Nombra las API Keys de forma descriptiva en Google Cloud Console:
  - `QuePlan - Android - Google Maps`
  - `QuePlan - iOS - Google Maps`
- Documenta qué API Key va en cada archivo

---

**Última actualización**: Enero 2025  
**Próxima acción**: Crear API Key para iOS y configurarla en `Info.plist`

