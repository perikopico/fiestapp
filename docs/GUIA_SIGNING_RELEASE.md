# 🔐 Guía: Configurar Signing para Release - QuePlan

**Fecha**: Enero 2025  
**Prioridad**: 🔴 CRÍTICO - Antes de publicar en Play Store  
**Tiempo estimado**: 30-45 minutos

---

## ¿Qué es el Signing?

El **signing** (firma digital) es el proceso de firmar tu aplicación Android con un certificado digital antes de publicarla en Google Play Store. Es como una "firma" que identifica que la app es realmente tuya y no ha sido modificada.

### ¿Por qué es necesario?

1. **Seguridad**: Google Play Store requiere que todas las apps estén firmadas
2. **Identificación**: Identifica que la app es tuya
3. **Actualizaciones**: Permite actualizar la app en el futuro (debe usar la misma firma)
4. **Protección**: Evita que otros modifiquen tu app y la publiquen como suya

### ⚠️ IMPORTANTE

- **NO pierdas el keystore**: Si lo pierdes, NO podrás actualizar tu app en Play Store
- **Guarda una copia segura**: Haz backup del keystore y de las contraseñas
- **No lo subas a Git**: El keystore debe estar en `.gitignore`

---

## 📋 Pasos para Configurar Signing

### Paso 1: Crear el Keystore

El keystore es un archivo que contiene tu certificado de firma. Se crea una sola vez y se usa para todas las versiones de tu app.

**Comando para crear el keystore**:

```bash
keytool -genkey -v -keystore ~/upload-keystore.jks -keyalg RSA -keysize 2048 -validity 10000 -alias upload
```

**Parámetros explicados**:
- `-keystore ~/upload-keystore.jks`: Ruta y nombre del archivo keystore (guárdalo en un lugar seguro)
- `-keyalg RSA`: Algoritmo de encriptación
- `-keysize 2048`: Tamaño de la clave (2048 es seguro)
- `-validity 10000`: Válido por 10,000 días (~27 años)
- `-alias upload`: Nombre del alias (puede ser cualquier nombre)

**Durante la creación te pedirá**:
1. Contraseña del keystore (guárdala bien)
2. Información personal (nombre, organización, etc.)
3. Contraseña del alias (puede ser la misma que la del keystore)

**Ejemplo de información**:
```
Nombre y apellidos: Tu Nombre
Nombre de la unidad organizativa: Tu Empresa
Nombre de la organización: Tu Empresa
Nombre de la ciudad: Tu Ciudad
Nombre del estado o provincia: Tu Provincia
Código de país de dos letras: ES (para España)
```

---

### Paso 2: Crear archivo key.properties

Crea un archivo `android/key.properties` con la siguiente estructura:

```properties
storePassword=TU_CONTRASEÑA_DEL_KEYSTORE
keyPassword=TU_CONTRASEÑA_DEL_ALIAS
keyAlias=upload
storeFile=/ruta/completa/a/upload-keystore.jks
```

**Ejemplo**:
```properties
storePassword=MiContraseñaSegura123
keyPassword=MiContraseñaSegura123
keyAlias=upload
storeFile=/home/perikopico/upload-keystore.jks
```

**⚠️ IMPORTANTE**:
- Usa la ruta **absoluta** (completa) para `storeFile`
- **NO** subas este archivo a Git (debe estar en `.gitignore`)

---

### Paso 3: Actualizar .gitignore

Asegúrate de que `android/key.properties` está en `.gitignore`:

```bash
# En android/.gitignore o en el .gitignore raíz
android/key.properties
*.jks
*.keystore
```

---

### Paso 4: Actualizar build.gradle.kts

Modifica `android/app/build.gradle.kts` para usar el signing:

**Antes** (líneas 49-55):
```kotlin
buildTypes {
    release {
        signingConfig = signingConfigs.getByName("debug")
    }
}
```

**Después**:
```kotlin
// Leer key.properties
val keystorePropertiesFile = rootProject.file("key.properties")
val keystoreProperties = java.util.Properties()
if (keystorePropertiesFile.exists()) {
    keystoreProperties.load(java.io.FileInputStream(keystorePropertiesFile))
}

android {
    // ... código existente ...

    signingConfigs {
        create("release") {
            keyAlias = keystoreProperties["keyAlias"] as String
            keyPassword = keystoreProperties["keyPassword"] as String
            storeFile = file(keystoreProperties["storeFile"] as String)
            storePassword = keystoreProperties["storePassword"] as String
        }
    }

    buildTypes {
        release {
            signingConfig = signingConfigs.getByName("release")
        }
    }
}
```

---

### Paso 5: Verificar que funciona

**Generar APK firmado**:
```bash
flutter build apk --release
```

**Generar AAB firmado** (para Play Store):
```bash
flutter build appbundle --release
```

Si todo está correcto, el build se completará sin errores.

---

## 🔒 Seguridad del Keystore

### ⚠️ CRÍTICO: Guarda el Keystore de forma segura

1. **Haz backup del keystore**:
   ```bash
   cp ~/upload-keystore.jks ~/backup-upload-keystore.jks
   ```

2. **Guarda las contraseñas**:
   - Usa un gestor de contraseñas
   - O guárdalas en un lugar seguro (no en el código)

3. **Haz backup en la nube** (encriptado):
   - Sube el keystore a Google Drive/Dropbox (encriptado)
   - O usa un servicio de backup seguro

4. **Documenta la información**:
   - Guarda el alias usado
   - Guarda las contraseñas
   - Guarda la ruta del keystore

### ❌ NO hagas esto:

- ❌ NO subas el keystore a Git
- ❌ NO subas `key.properties` a Git
- ❌ NO compartas el keystore públicamente
- ❌ NO uses el mismo keystore para múltiples apps

---

## 🐛 Solución de Problemas

### Error: "Keystore file not found"
**Solución**: Verifica que la ruta en `key.properties` es correcta y absoluta

### Error: "Wrong password"
**Solución**: Verifica que las contraseñas en `key.properties` son correctas

### Error: "Alias does not exist"
**Solución**: Verifica que el `keyAlias` en `key.properties` coincide con el usado al crear el keystore

### Error: "Keystore was tampered with"
**Solución**: El keystore está corrupto, necesitas crear uno nuevo (pero no podrás actualizar la app existente)

---

## 📝 Checklist Final

Antes de publicar en Play Store, verifica:

- [ ] Keystore creado y guardado de forma segura
- [ ] `key.properties` creado con información correcta
- [ ] `key.properties` está en `.gitignore`
- [ ] `build.gradle.kts` actualizado con signing config
- [ ] Build de release funciona correctamente
- [ ] Backup del keystore hecho
- [ ] Contraseñas guardadas de forma segura

---

## 🎯 Resumen

1. **Crear keystore**: `keytool -genkey ...`
2. **Crear key.properties**: Con las credenciales
3. **Actualizar build.gradle.kts**: Añadir signing config
4. **Verificar**: Hacer build de release
5. **Backup**: Guardar keystore y contraseñas de forma segura

---

## 📚 Referencias

- [Flutter: Signing the app](https://docs.flutter.dev/deployment/android#signing-the-app)
- [Android: App Signing](https://developer.android.com/studio/publish/app-signing)
- [Google Play: App Signing](https://support.google.com/googleplay/android-developer/answer/9842756)

---

**Última actualización**: Enero 2025  
**Próxima acción**: Configurar signing antes de publicar en Play Store

