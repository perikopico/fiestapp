# 🔐 Auditoría de Seguridad - Preparación para Publicación

**Fecha**: Enero 2025  
**Estado**: ⚠️ **CRÍTICO - Requiere acción antes de publicar**

---

## 🚨 PROBLEMAS CRÍTICOS ENCONTRADOS

### 🔴 CRÍTICO 1: API Key de Google Maps hardcodeada en iOS

**Ubicaciones:**
1. `ios/Runner/Info.plist` (línea 65)
   ```xml
   <key>GMSApiKey</key>
   <string>AIzaSyB-LWdftqdYCjv3QgsUJNI2TeyA1ALCPsc</string>
   ```

2. `ios/Runner/AppDelegate.swift` (línea 20) - Fallback hardcodeado
   ```swift
   let apiKey = "AIzaSyB-LWdftqdYCjv3QgsUJNI2TeyA1ALCPsc"
   ```

**Riesgo:**
- ⚠️ La API key está visible en el código fuente
- ⚠️ Si el repositorio es público, cualquiera puede verla
- ⚠️ Aunque tenga restricciones, expone información sensible

**Solución:**
1. Crear un `xcconfig` para variables de entorno (similar a Android)
2. Mover la API key a un archivo `.env` o `Config.xcconfig` (no versionado)
3. Eliminar el fallback hardcodeado en `AppDelegate.swift`

---

### 🔴 CRÍTICO 2: GoogleService-Info.plist en el repositorio

**Ubicación:** `ios/Runner/GoogleService-Info.plist`

**Contenido expuesto:**
- `API_KEY`: `AIzaSyD3u-DAiKh8kWJg5JexjwHswrReLd7hvc4` (Firebase API Key)
- `PROJECT_ID`: `queplan-5b9da`
- `GCM_SENDER_ID`: `223180332662`
- `GOOGLE_APP_ID`: `1:223180332662:ios:a6fdfe38a421ab56b20957`
- `STORAGE_BUCKET`: `queplan-5b9da.firebasestorage.app`

**Riesgo:**
- 🔴 **MUY ALTO**: Contiene credenciales de Firebase
- 🔴 Exponer PROJECT_ID y APP_ID facilita ataques
- ⚠️ Aunque `.gitignore` lo excluye, está actualmente en el repo

**Solución:**
1. ✅ Ya está en `.gitignore` (línea 35)
2. ⚠️ **Verificar que NO esté en Git**: `git check-ignore ios/Runner/GoogleService-Info.plist`
3. ⚠️ Si está rastreado, eliminarlo del historial: `git rm --cached ios/Runner/GoogleService-Info.plist`
4. Crear `GoogleService-Info.plist.example` como plantilla sin credenciales

---

### 🔴 CRÍTICO 3: NSAllowsArbitraryLoads activado en iOS

**Ubicación:** `ios/Runner/Info.plist` (líneas 55-59)

```xml
<key>NSAppTransportSecurity</key>
<dict>
    <key>NSAllowsArbitraryLoads</key>
    <true/>
</dict>
```

**Riesgo:**
- 🔴 **CRÍTICO para App Store**: Apple puede rechazar la app
- 🔴 Desactiva App Transport Security (ATS) completamente
- 🔴 Permite conexiones HTTP no seguras
- ⚠️ No pasa las guías de revisión de Apple

**Solución:**
1. **Eliminar completamente** `NSAllowsArbitraryLoads` si todas las conexiones son HTTPS
2. Si necesitas excepciones específicas, usar `NSExceptionDomains` con justificación
3. Verificar que todas las URLs usan HTTPS

---

### 🟡 IMPORTANTE 4: Debug prints con información sensible

**Ubicaciones múltiples:**
- `lib/services/fcm_token_service.dart`: Imprime tokens FCM (aunque se trunca)
- `lib/main.dart`: Imprime inicialización de servicios
- Varios archivos: Mensajes de debug con información del sistema

**Riesgo:**
- 🟡 Bajo: `debugPrint` se elimina en release, PERO
- ⚠️ Puede filtrar información en builds de desarrollo
- ⚠️ Si alguien instala una versión debug, podría ver información sensible

**Solución:**
1. ✅ Ya usan `debugPrint` (se elimina en release)
2. 🟡 Considerar eliminar o reducir logs en producción
3. Verificar que no haya `print()` sin depurar

---

### 🟢 CORRECTO: Android está bien configurado

**Estado:** ✅
- API Key se lee desde `local.properties` (no versionado)
- `AndroidManifest.xml` usa variable `${GOOGLE_MAPS_API_KEY}`
- `.gitignore` excluye `local.properties`

---

### 🟢 CORRECTO: Supabase está bien configurado

**Estado:** ✅
- URL y Anon Key se leen desde `.env` (no versionado)
- `.gitignore` excluye `.env`
- No hay credenciales hardcodeadas

---

## ✅ ACCIONES REQUERIDAS ANTES DE PUBLICAR

### Prioridad 1: CRÍTICO (Hacer ANTES de subir a las tiendas)

#### 1. Eliminar API Key hardcodeada de iOS

**Pasos:**
1. Crear `ios/Runner/Config.xcconfig`:
   ```xcconfig
   GOOGLE_MAPS_API_KEY = $(GOOGLE_MAPS_API_KEY_FROM_ENV)
   ```

2. Leer desde variable de entorno o archivo no versionado

3. Eliminar la key de `Info.plist` y `AppDelegate.swift`

4. **Rotar la API key expuesta** en Google Cloud Console

#### 2. Verificar y limpiar GoogleService-Info.plist

**Pasos:**
```bash
# Verificar si está rastreado por Git
git ls-files | grep GoogleService-Info.plist

# Si está rastreado, eliminarlo
git rm --cached ios/Runner/GoogleService-Info.plist
git commit -m "Remove GoogleService-Info.plist from repository"

# Verificar que está en .gitignore
grep -q "GoogleService-Info.plist" .gitignore && echo "✅ En .gitignore"
```

#### 3. Corregir NSAppTransportSecurity

**Pasos:**
1. Eliminar `NSAllowsArbitraryLoads` de `Info.plist`
2. Verificar que todas las conexiones usan HTTPS:
   - Supabase: ✅ HTTPS
   - Google Maps API: ✅ HTTPS
   - Firebase: ✅ HTTPS
3. Si necesitas excepciones, usar:
   ```xml
   <key>NSExceptionDomains</key>
   <dict>
       <key>ejemplo.com</key>
       <dict>
           <key>NSExceptionAllowsInsecureHTTPLoads</key>
           <true/>
           <key>NSIncludesSubdomains</key>
           <true/>
       </dict>
   </dict>
   ```

### Prioridad 2: IMPORTANTE (Hacer antes de publicar)

#### 4. Limpiar historial de Git (si el repo es público)

Si el repositorio es público y contiene credenciales en el historial:

**Opción A: Usar BFG Repo-Cleaner**
```bash
# Instalar BFG
brew install bfg  # macOS

# Limpiar historial
bfg --replace-text passwords.txt
git reflog expire --expire=now --all
git gc --prune=now --aggressive
```

**Opción B: Crear nuevo repositorio**
- Migrar código limpio
- No migrar historial completo

#### 5. Verificar restricciones de API Keys

**Para Google Maps API Key:**
1. ✅ Restricciones de aplicación (SHA-1 + Package name)
2. ✅ Restricciones de API (solo APIs necesarias)
3. ✅ Límites de cuota configurados
4. ✅ Alertas de facturación configuradas

### Prioridad 3: RECOMENDADO (Mejores prácticas)

#### 6. Revisar permisos de Android/iOS

**Android (`AndroidManifest.xml`):**
- ✅ Permisos necesarios solo
- ⚠️ Verificar si `ACCESS_BACKGROUND_LOCATION` es necesario

**iOS (`Info.plist`):**
- ✅ Permisos tienen descripciones claras
- ✅ Todas las descripciones en español

#### 7. Configurar ProGuard/R8 (Android)

Asegurar que el código ofuscado no exponga información:
- ✅ Ya configurado en `build.gradle.kts`
- ⚠️ Verificar reglas de ProGuard si hay problemas

#### 8. Configurar Signing para Release (Android)

**Estado:** ⚠️ TODO en `build.gradle.kts` línea 51

**Pasos:**
1. Crear keystore:
   ```bash
   keytool -genkey -v -keystore ~/upload-keystore.jks -keyalg RSA -keysize 2048 -validity 10000 -alias upload
   ```

2. Configurar `android/key.properties` (ya en .gitignore)

3. Actualizar `build.gradle.kts` para usar keystore en release

---

## 📋 CHECKLIST PRE-PUBLICACIÓN

### Seguridad
- [ ] ❌ API Key de iOS eliminada de código fuente
- [ ] ❌ GoogleService-Info.plist no está en Git
- [ ] ❌ NSAllowsArbitraryLoads eliminado o justificado
- [ ] ✅ Todas las conexiones usan HTTPS
- [ ] ✅ Archivos sensibles en `.gitignore`
- [ ] ✅ No hay credenciales hardcodeadas

### Configuración
- [ ] ✅ API Keys tienen restricciones configuradas
- [ ] ✅ Límites de cuota configurados
- [ ] ✅ Alertas de facturación configuradas
- [ ] ⚠️ Signing configurado para release (Android)
- [ ] ✅ Permisos justificados y descritos

### Código
- [ ] ✅ No hay `print()` sin depurar
- [ ] ✅ `debugPrint` solo para información no sensible
- [ ] ✅ ProGuard/R8 configurado (Android)
- [ ] ✅ Builds de release no exponen información

---

## 🎯 RESUMEN DE ACCIONES INMEDIATAS

### 🔴 HACER HOY (antes de cualquier build de release)

1. **Eliminar API Key hardcodeada de iOS**
   - Archivos: `Info.plist`, `AppDelegate.swift`
   - Tiempo: 30 minutos

2. **Corregir NSAppTransportSecurity**
   - Archivo: `Info.plist`
   - Tiempo: 5 minutos

3. **Verificar GoogleService-Info.plist**
   - Comando: `git check-ignore ios/Runner/GoogleService-Info.plist`
   - Tiempo: 5 minutos

### 🟡 HACER ESTA SEMANA

4. **Rotar API Keys expuestas**
   - Google Cloud Console
   - Tiempo: 30 minutos

5. **Configurar Signing para Release**
   - Android
   - Tiempo: 1 hora

---

## 📚 Referencias

- [Apple App Transport Security](https://developer.apple.com/documentation/security/preventing_insecure_network_connections)
- [Google API Key Best Practices](https://cloud.google.com/docs/authentication/api-keys)
- [Flutter Security Best Practices](https://docs.flutter.dev/security)

---

**Última actualización**: Enero 2025  
**Próxima revisión**: Después de implementar correcciones
