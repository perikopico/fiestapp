# 🔍 Verificar Google Maps en iOS - QuePlan

## 📋 Problema: El mapa no se carga o se bloquea

Si al pulsar "Elegir ubicación en el mapa" la pantalla se queda cargando y nunca aparece el mapa, puede ser un problema con la configuración de Google Maps en iOS.

## ✅ Pasos para Verificar y Solucionar

### 1. Verificar que la API Key está configurada

**Archivo:** `ios/Runner/Info.plist`

Debe contener:
```xml
<key>GMSApiKey</key>
<string>TU_API_KEY_IOS_AQUI</string>
```

**Verificar:**
```bash
cd ios/Runner
grep -A 1 "GMSApiKey" Info.plist
```

### 2. Verificar que la API Key es válida en Google Cloud Console

1. Ve a [Google Cloud Console](https://console.cloud.google.com/)
2. Selecciona tu proyecto
3. Ve a **APIs & Services** → **Credentials**
4. Busca la API key que está en `Info.plist`: `AIzaSyB-LWdftqdYCjv3QgsUJNI2TeyA1ALCPsc`

**Verifica:**

#### A) Restricciones de API
- ✅ "Restrict key" debe estar seleccionado
- ✅ **"Maps SDK for iOS"** debe estar marcada (CRÍTICO)
- ✅ "Places API (New)" si usas búsqueda de lugares
- ✅ "Geocoding API" si usas geocodificación

#### B) Restricciones de Aplicación (iOS)
- ✅ "iOS apps" debe estar seleccionado
- ✅ Debe haber una entrada con:
  - **Bundle ID:** `com.perikopico.fiestapp` (o tu Bundle ID real)
  
**⚠️ IMPORTANTE:** El Bundle ID debe coincidir exactamente con el de tu app.

**Verificar Bundle ID:**
```bash
cd ios/Runner
grep -A 1 "PRODUCT_BUNDLE_IDENTIFIER" ../Runner.xcodeproj/project.pbxproj
```

### 3. Verificar que la API Key está inicializada en AppDelegate

**Archivo:** `ios/Runner/AppDelegate.swift`

Debe tener:
```swift
import GoogleMaps

// En didFinishLaunchingWithOptions:
GMSServices.provideAPIKey("TU_API_KEY_AQUI")
```

O leer desde Info.plist (lo que ya está implementado).

### 4. Reconstruir la app completamente

Después de verificar/actualizar la configuración:

```bash
# 1. Limpiar el proyecto
flutter clean

# 2. Obtener dependencias
flutter pub get

# 3. Limpiar pods de iOS
cd ios
pod deintegrate
pod install
cd ..

# 4. Reconstruir y ejecutar
flutter run -d [ID_DEL_DISPOSITIVO]
```

### 5. Verificar los logs

Al ejecutar la app, busca en los logs:

**✅ Logs exitosos:**
```
✅ Google Maps API Key configurada desde Info.plist
✅ GoogleMap onMapCreated llamado
✅ Mapa cargado en XXXms
```

**❌ Logs de error:**
```
❌ Error al inicializar el mapa: [mensaje de error]
⚠️ El mapa está tardando demasiado en cargar
```

## 🚨 Problemas Comunes y Soluciones

### Problema 1: "API key no válida" o "API_KEY_INVALID"

**Causa:** La API key no está configurada o es incorrecta.

**Solución:**
1. Verifica que `Info.plist` tiene `GMSApiKey` con un valor válido
2. Verifica que la API key existe en Google Cloud Console
3. Verifica que la API key no está restringida de forma incorrecta

### Problema 2: "Maps SDK for iOS no habilitada"

**Causa:** La API "Maps SDK for iOS" no está habilitada en Google Cloud Console.

**Solución:**
1. Ve a [Google Cloud Console](https://console.cloud.google.com/)
2. **APIs & Services** → **Library**
3. Busca "Maps SDK for iOS"
4. Haz clic en **Enable** (Habilitar)
5. Espera 2-5 minutos para que se propague
6. Reconstruye la app

### Problema 3: "Bundle ID no coincide"

**Causa:** El Bundle ID en Google Cloud Console no coincide con el de tu app.

**Solución:**
1. Verifica el Bundle ID real de tu app en Xcode o `project.pbxproj`
2. Actualiza la restricción en Google Cloud Console para que coincida exactamente
3. Reconstruye la app

### Problema 4: El mapa se carga pero está en blanco

**Causa:** La API key está configurada pero tiene restricciones muy estrictas o hay un problema de conexión.

**Solución:**
1. Verifica tu conexión a internet
2. Verifica que la API key tiene las APIs necesarias habilitadas
3. Prueba temporalmente sin restricciones (solo para debugging)
4. Si funciona sin restricciones, ajusta las restricciones gradualmente

## 🧪 Probar la API Key

Puedes probar si la API key funciona haciendo una petición directa:

```bash
curl "https://maps.googleapis.com/maps/api/geocode/json?address=Barbate,Spain&key=TU_API_KEY_AQUI"
```

Si devuelve un JSON con datos, la API key funciona. Si devuelve un error, hay un problema con la configuración.

## ✅ Checklist Final

Antes de ejecutar la app, verifica:

- [ ] `ios/Runner/Info.plist` tiene `GMSApiKey` con un valor válido
- [ ] La API key existe en Google Cloud Console
- [ ] **"Maps SDK for iOS" está habilitada** en Google Cloud Console
- [ ] Las restricciones de iOS incluyen el Bundle ID correcto
- [ ] `AppDelegate.swift` inicializa Google Maps correctamente
- [ ] Ejecutaste `flutter clean` después de cambiar la configuración
- [ ] Ejecutaste `pod install` después de cambios en iOS

## 📝 Notas Importantes

1. **La API key de iOS puede ser diferente a la de Android** - Esto es recomendado para mayor seguridad.

2. **Los cambios en Google Cloud Console pueden tardar 2-5 minutos en propagarse** - Si acabas de hacer cambios, espera unos minutos antes de probar.

3. **El Bundle ID debe coincidir exactamente** - Incluye mayúsculas/minúsculas y puntos.

4. **No subas la API key a Git** - Ya está en `.gitignore`, pero verifica que no esté expuesta en commits anteriores.
