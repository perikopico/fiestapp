# 📋 Resumen de Acciones - Seguridad y Publicación

**Fecha**: Enero 2025  
**Estado**: ⚠️ **Acción requerida antes de publicar**

---

## 🚨 ACCIONES INMEDIATAS (Hacer AHORA)

### 1. Configurar API Key de Google Maps para iOS (Debug)

**Problema:** Eliminamos la API key hardcodeada, ahora necesitas configurarla manualmente.

**Pasos:**
1. Copiar el archivo de ejemplo:
   ```bash
   cp ios/Runner/GoogleService-Info.plist.example ios/Runner/GoogleService-Info.plist
   ```

2. Editar `ios/Runner/GoogleService-Info.plist` y añadir tu API Key real:
   ```xml
   <key>GMSApiKey</key>
   <string>TU_API_KEY_IOS_AQUI</string>
   ```
   
   **⚠️ IMPORTANTE:** Este archivo NO se subirá a Git (está en `.gitignore`)

3. **O alternativamente**, puedes añadir la key directamente en `Info.plist` temporalmente para desarrollo:
   ```xml
   <key>GMSApiKey</key>
   <string>TU_API_KEY_IOS_AQUI</string>
   ```
   (Pero recuerda eliminarla antes de publicar)

**Tiempo estimado:** 5 minutos

---

### 2. Verificar que la app funciona en Debug

**Pasos:**
1. Compilar y ejecutar en iOS:
   ```bash
   flutter clean
   flutter pub get
   flutter run
   ```

2. Verificar que Google Maps funciona correctamente

3. Si falla con `fatalError`, significa que la API Key no está configurada → volver al paso 1

**Tiempo estimado:** 10 minutos

---

## 🔧 CAMBIOS PARA SEGUIR EN DEBUG (Desarrollo)

### ✅ Lo que YA está configurado (no tocar)

- ✅ Android: API Key se lee desde `android/local.properties`
- ✅ Supabase: Credenciales se leen desde `.env`
- ✅ iOS: Ahora lee desde `GoogleService-Info.plist` o `Info.plist`

### 📝 Archivos que debes tener (no versionados)

**Para Android:**
- `android/local.properties` con:
  ```
  GOOGLE_MAPS_API_KEY=tu_api_key_android
  ```

**Para iOS:**
- `ios/Runner/GoogleService-Info.plist` con tu API Key de iOS
- **O** añadir `GMSApiKey` en `Info.plist` (solo para desarrollo)

**Para Supabase:**
- `.env` en la raíz con:
  ```
  SUPABASE_URL=tu_url
  SUPABASE_ANON_KEY=tu_anon_key
  GOOGLE_MAPS_API_KEY=tu_api_key_android
  ```

### ⚠️ IMPORTANTE para Debug

**Si quieres un fallback temporal en desarrollo** (NO para producción):

Puedes modificar `AppDelegate.swift` temporalmente para desarrollo:

```swift
} else {
  // SOLO PARA DESARROLLO - ELIMINAR ANTES DE PUBLICAR
  #if DEBUG
  let apiKey = "TU_API_KEY_TEMPORAL_AQUI"
  GMSServices.provideAPIKey(apiKey)
  print("⚠️ Usando API Key temporal para desarrollo")
  #else
  fatalError("❌ GOOGLE_MAPS_API_KEY no configurada")
  #endif
}
```

**⚠️ RECUERDA:** Eliminar este fallback antes de publicar.

---

## 🚀 PREPARACIÓN PARA PUBLICACIÓN (App Store / Play Store)

### Prioridad 1: CRÍTICO (Hacer ANTES de subir)

#### 1. Eliminar cualquier API Key hardcodeada

**Verificar:**
```bash
# Buscar API Keys hardcodeadas
grep -r "AIza" ios/ lib/ --exclude-dir=build --exclude="*.md"

# No debe encontrar nada (excepto en documentación)
```

**Si encuentras algo:**
- Eliminar inmediatamente
- Rotar la key en Google Cloud Console

#### 2. Verificar que GoogleService-Info.plist NO está en Git

```bash
git ls-files | grep GoogleService-Info.plist
# No debe mostrar nada
```

**Si aparece:**
```bash
git rm --cached ios/Runner/GoogleService-Info.plist
git commit -m "Remove GoogleService-Info.plist from repository"
```

#### 3. Eliminar fallback temporal de AppDelegate.swift (si lo añadiste)

**Verificar que `AppDelegate.swift` NO tiene:**
- API Keys hardcodeadas
- Fallbacks con keys en texto plano

**Debe tener:**
```swift
} else {
  fatalError("❌ GOOGLE_MAPS_API_KEY no configurada...")
}
```

#### 4. Rotar API Keys expuestas

**Keys que estuvieron expuestas:**
- `AIzaSyB-LWdftqdYCjv3QgsUJNI2TeyA1ALCPsc` (iOS)

**Pasos:**
1. Ir a [Google Cloud Console](https://console.cloud.google.com/)
2. APIs & Services → Credentials
3. Encontrar la key expuesta
4. **ELIMINAR** o **RESTRINGIR** temporalmente
5. Crear nueva API Key con restricciones:
   - **Android:** SHA-1 + Package name
   - **iOS:** Bundle ID
6. Actualizar en `local.properties` (Android) y `GoogleService-Info.plist` (iOS)

**Tiempo estimado:** 30 minutos

---

### Prioridad 2: IMPORTANTE (Hacer antes de publicar)

#### 5. Configurar Signing para Release (Android)

**Estado actual:** ⚠️ Usa debug keys (no válido para Play Store)

**Pasos:**
1. Crear keystore:
   ```bash
   keytool -genkey -v -keystore ~/upload-keystore.jks \
     -keyalg RSA -keysize 2048 -validity 10000 \
     -alias upload
   ```

2. Crear `android/key.properties`:
   ```properties
   storePassword=tu_password
   keyPassword=tu_password
   keyAlias=upload
   storeFile=/ruta/completa/a/upload-keystore.jks
   ```

3. Actualizar `android/app/build.gradle.kts`:
   ```kotlin
   // En la sección android { ... }
   signingConfigs {
       create("release") {
           val keystorePropertiesFile = rootProject.file("key.properties")
           val keystoreProperties = Properties()
           keystoreProperties.load(FileInputStream(keystorePropertiesFile))
           
           keyAlias = keystoreProperties["keyAlias"] as String
           keyPassword = keystoreProperties["keyPassword"] as String
           storeFile = file(keystoreProperties["storeFile"] as String)
           storePassword = keystoreProperties["storePassword"] as String
       }
   }
   
   buildTypes {
       getByName("release") {
           signingConfig = signingConfigs.getByName("release")
           // ... resto de configuración
       }
   }
   ```

4. Verificar que `key.properties` está en `.gitignore` ✅

**Tiempo estimado:** 1 hora

#### 6. Verificar restricciones de API Keys

**Para cada API Key (Android e iOS):**

1. **Restricciones de aplicación:**
   - ✅ Android: SHA-1 + Package name (`com.perikopico.fiestapp`)
   - ✅ iOS: Bundle ID (`com.perikopico.fiestapp`)

2. **Restricciones de API:**
   - ✅ Maps SDK for Android (solo Android)
   - ✅ Maps SDK for iOS (solo iOS)
   - ✅ Places API (New)
   - ✅ Geocoding API

3. **Límites de cuota:**
   - ✅ Configurar límites diarios
   - ✅ Configurar alertas de facturación

**Tiempo estimado:** 20 minutos

#### 7. Build de Release y pruebas

**Android:**
```bash
flutter build appbundle --release
# O
flutter build apk --release
```

**iOS:**
```bash
flutter build ios --release
# Luego abrir en Xcode y archivar
```

**Verificar:**
- ✅ La app funciona correctamente
- ✅ Google Maps carga
- ✅ No hay errores en logs
- ✅ No hay información sensible en logs

**Tiempo estimado:** 30 minutos

---

### Prioridad 3: RECOMENDADO (Mejores prácticas)

#### 8. Revisar permisos

**Android (`AndroidManifest.xml`):**
- ✅ Solo permisos necesarios
- ⚠️ Verificar si `ACCESS_BACKGROUND_LOCATION` es necesario

**iOS (`Info.plist`):**
- ✅ Todas las descripciones de permisos están en español
- ✅ Descripciones son claras y justificadas

#### 9. Limpiar historial de Git (si el repo es público)

**Si el repositorio es público y contiene credenciales en el historial:**

**Opción A: Usar BFG Repo-Cleaner**
```bash
# Instalar
brew install bfg  # macOS

# Crear archivo con keys a reemplazar
echo "AIzaSyB-LWdftqdYCjv3QgsUJNI2TeyA1ALCPsc==>***REMOVED***" > passwords.txt

# Limpiar
bfg --replace-text passwords.txt
git reflog expire --expire=now --all
git gc --prune=now --aggressive
```

**Opción B: Crear nuevo repositorio**
- Migrar código limpio
- No migrar historial completo

**Tiempo estimado:** 1-2 horas

---

## ✅ CHECKLIST FINAL ANTES DE PUBLICAR

### Seguridad
- [ ] ❌ No hay API Keys hardcodeadas en código
- [ ] ❌ GoogleService-Info.plist no está en Git
- [ ] ❌ NSAllowsArbitraryLoads eliminado (iOS)
- [ ] ✅ Todas las conexiones usan HTTPS
- [ ] ✅ Archivos sensibles en `.gitignore`
- [ ] ✅ API Keys rotadas si estuvieron expuestas

### Configuración
- [ ] ✅ API Keys tienen restricciones configuradas
- [ ] ✅ Límites de cuota configurados
- [ ] ✅ Alertas de facturación configuradas
- [ ] ✅ Signing configurado para release (Android)
- [ ] ✅ Permisos justificados y descritos

### Build
- [ ] ✅ Build de release funciona (Android)
- [ ] ✅ Build de release funciona (iOS)
- [ ] ✅ App funciona correctamente en release
- [ ] ✅ No hay errores en logs de release
- [ ] ✅ Google Maps funciona en release

### Código
- [ ] ✅ No hay `print()` sin depurar
- [ ] ✅ `debugPrint` solo para información no sensible
- [ ] ✅ ProGuard/R8 configurado (Android)
- [ ] ✅ Builds de release no exponen información

---

## 📝 RESUMEN RÁPIDO

### Para seguir desarrollando (AHORA):
1. ✅ Configurar `GoogleService-Info.plist` con tu API Key de iOS
2. ✅ Verificar que la app funciona en debug
3. ✅ Continuar desarrollando normalmente

### Para publicar (ANTES de subir a las tiendas):
1. 🔴 Rotar API Keys expuestas
2. 🔴 Verificar que no hay keys hardcodeadas
3. 🔴 Configurar signing para release (Android)
4. 🔴 Hacer build de release y probar
5. 🟡 Verificar restricciones de API Keys
6. 🟡 Revisar permisos

---

## 🆘 SI ALGO FALLA

### La app no inicia en iOS (fatalError)
**Causa:** API Key no configurada  
**Solución:** Añadir `GMSApiKey` en `GoogleService-Info.plist` o `Info.plist`

### Google Maps no carga
**Causa:** API Key incorrecta o sin restricciones  
**Solución:** Verificar key en Google Cloud Console y restricciones

### Build de release falla
**Causa:** Signing no configurado (Android)  
**Solución:** Seguir pasos de "Configurar Signing para Release"

---

**Última actualización**: Enero 2025  
**Próxima revisión**: Después de implementar correcciones
