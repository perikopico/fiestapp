# 🍎 Configurar Google Maps para iOS - QuePlan

**Fecha**: Enero 2025  
**Tiempo estimado**: 10 minutos

---

## 📋 Resumen

Esta guía te ayudará a configurar Google Maps para iOS usando la **misma API Key** que usas para Android.

**⚠️ IMPORTANTE**: Puedes usar la **misma API Key** para Android e iOS. Solo necesitas:
1. Configurar la API Key en iOS
2. Añadir restricciones de iOS en Google Cloud Console

---

## 🔑 Opciones: Misma API Key vs API Keys Separadas

### Opción A: Usar la Misma API Key

✅ **Ventajas**:
- Más simple de mantener
- Una sola API Key para gestionar
- Menos configuración

❌ **Desventajas**:
- Si una plataforma se compromete, ambas se ven afectadas
- Puede haber problemas configurando restricciones múltiples

### Opción B: API Keys Separadas (Recomendado si tienes problemas)

✅ **Ventajas**:
- Mayor seguridad (aislamiento entre plataformas)
- Cuotas separadas
- Rotación independiente
- Más fácil de gestionar restricciones

❌ **Desventajas**:
- Dos API Keys para gestionar
- Más configuración inicial

**Recomendación**: Si tienes problemas configurando restricciones múltiples, usa **API Keys separadas**. Ver `docs/CONFIGURAR_API_KEYS_SEPARADAS.md` para instrucciones completas.

---

## 📝 Paso 1: Configurar API Key en iOS

### Opción A: Configurar en Info.plist (Recomendado)

1. Abre `ios/Runner/Info.plist`
2. Añade la API Key:

```xml
<key>GMSApiKey</key>
<string>TU_API_KEY_AQUI</string>
```

**⚠️ IMPORTANTE**: 
- Usa la **misma API Key** que usas para Android
- NO subas `Info.plist` con la API Key a Git si está hardcodeada
- Considera usar un archivo de configuración externo para mayor seguridad

### Opción B: Configurar en AppDelegate.swift

1. Abre `ios/Runner/AppDelegate.swift`
2. Añade:

```swift
import GoogleMaps

// En didFinishLaunchingWithOptions:
GMSServices.provideAPIKey("TU_API_KEY_AQUI")
```

**⚠️ NOTA**: Esta opción requiere hardcodear la API Key en el código, lo cual no es ideal para seguridad.

### Opción C: Leer desde archivo de configuración (Más seguro)

1. Crea un archivo `ios/Runner/GoogleService-Info.plist` (añádelo a `.gitignore`)
2. Añade:

```xml
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
    <key>API_KEY</key>
    <string>TU_API_KEY_AQUI</string>
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

## 🔐 Paso 2: Añadir Restricciones de iOS en Google Cloud Console

### 2.1 Acceder a Google Cloud Console

1. Ve a: https://console.cloud.google.com/
2. Selecciona tu proyecto
3. Ve a **APIs & Services** → **Credentials**

### 2.2 Editar la API Key

1. Busca tu API Key de Google Maps (la misma que usas para Android)
2. Haz clic para editarla

### 2.3 Añadir Restricciones de iOS

1. En la sección **"Application restrictions"**, verifica que tienes:
   - ✅ Restricciones de Android configuradas
   - ✅ Restricciones de iOS (añadir si no están)

2. Para añadir restricciones de iOS:
   - Busca la sección **"iOS apps"**
   - Haz clic en **"Add an item"**
   - Añade el **Bundle ID**: `com.perikopico.fiestapp`
   - Guarda los cambios

### 2.4 Verificar APIs Habilitadas

1. En la sección **"API restrictions"**, verifica que tienes:
   - ✅ **Maps SDK for Android** (si usas Android)
   - ✅ **Maps SDK for iOS** (si usas iOS) ← **Añadir esta**
   - ✅ **Places API** (si usas búsqueda)
   - ✅ **Geocoding API** (si usas geocodificación)

2. Si falta "Maps SDK for iOS", habilítala:
   - Ve a **APIs & Services** → **Library**
   - Busca "Maps SDK for iOS"
   - Haz clic en **"Enable"**

### 2.5 Guardar Cambios

1. Haz clic en **"Save"**
2. ⚠️ Los cambios pueden tardar hasta 5 minutos en aplicarse

---

## ✅ Checklist de Configuración iOS

### Configuración en el Código
- [ ] API Key configurada en `Info.plist` o `AppDelegate.swift`
- [ ] `AppDelegate.swift` importa `GoogleMaps`
- [ ] API Key es la misma que usas para Android

### Configuración en Google Cloud Console
- [ ] API Key tiene restricciones de iOS configuradas
- [ ] Bundle ID de iOS es correcto: `com.perikopico.fiestapp`
- [ ] Maps SDK for iOS está habilitada en el proyecto
- [ ] Maps SDK for iOS está en las restricciones de API
- [ ] Cambios guardados

### Verificación
- [ ] App compila sin errores
- [ ] Mapas cargan correctamente en iOS
- [ ] No hay errores en consola

---

## 🐛 Solución de Problemas

### Problema: "API key not valid" en iOS

**Causas posibles**:
1. API Key incorrecta
2. Bundle ID no coincide
3. Maps SDK for iOS no habilitada

**Solución**:
1. Verificar que la API Key en `Info.plist` es correcta
2. Verificar que el Bundle ID en Google Cloud Console es `com.perikopico.fiestapp`
3. Verificar que "Maps SDK for iOS" está habilitada

### Problema: Mapas no cargan en iOS

**Causas posibles**:
1. API Key no configurada
2. `GoogleMaps` no importado en `AppDelegate.swift`
3. Restricciones bloquean la app

**Solución**:
1. Verificar que `GMSApiKey` está en `Info.plist`
2. Verificar que `import GoogleMaps` está en `AppDelegate.swift`
3. Verificar restricciones en Google Cloud Console

---

## 📊 Resumen

✅ **Usa la misma API Key para Android e iOS**
✅ **Añade restricciones para ambas plataformas en Google Cloud Console**
✅ **Habilita Maps SDK for Android Y Maps SDK for iOS**
✅ **Configura la API Key en `Info.plist` o `AppDelegate.swift`**

---

**Última actualización**: Enero 2025  
**Próxima acción**: Configurar API Key en iOS y añadir restricciones en Google Cloud Console

