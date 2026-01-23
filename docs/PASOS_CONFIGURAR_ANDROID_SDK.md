# 🔧 Pasos para Configurar Android SDK (macOS)

**Fecha**: Enero 2025  
**Problema**: `[!] No Android SDK found. Try setting the ANDROID_HOME environment variable.`

---

## ✅ Solución Paso a Paso

### Paso 1: Verificar Android Studio

**Ya lo tienes instalado ✅** en `/Applications/Android Studio.app`

**Ahora necesitas:**

1. **Abrir Android Studio** (primera vez si no lo has abierto)
2. **Completar el asistente de configuración inicial:**
   - Selecciona "Standard" installation
   - Android Studio descargará el SDK automáticamente
   - **Ubicación típica:** `~/Library/Android/sdk`

### Paso 2: Obtener la Ruta Real del SDK

**Opción A: Desde Android Studio (GUI)**

1. Abre Android Studio
2. Ve a: **Android Studio** → **Settings** (o **Preferences** en macOS)
3. **Appearance & Behavior** → **System Settings** → **Android SDK**
4. En "Android SDK Location" verás la ruta completa
   - Ejemplo: `/Users/elenaps/Library/Android/sdk`
5. **Copia esta ruta**

**Opción B: Verificar si existe en ubicación por defecto**

```bash
ls -la ~/Library/Android/sdk
```

Si existe, esa es tu ruta.

**Si no existe:**
- Abre Android Studio y completa el asistente inicial
- El SDK se descargará automáticamente

---

### Paso 3: Configurar Variables de Entorno

**1. Abrir `.zshrc`:**
```bash
nano ~/.zshrc
# O si usas VS Code:
code ~/.zshrc
```

**2. Añadir al final del archivo:**
```bash
# Android SDK
export ANDROID_HOME=$HOME/Library/Android/sdk
export PATH=$PATH:$ANDROID_HOME/emulator
export PATH=$PATH:$ANDROID_HOME/platform-tools
export PATH=$PATH:$ANDROID_HOME/tools
export PATH=$PATH:$ANDROID_HOME/tools/bin
```

**3. Guardar y salir:**
- En nano: `Ctrl+O` (guardar), `Enter` (confirmar), `Ctrl+X` (salir)
- En VS Code: `Cmd+S` (guardar)

**4. Aplicar cambios:**
```bash
source ~/.zshrc
```

**5. Verificar:**
```bash
echo $ANDROID_HOME
# Debe mostrar: /Users/elenaps/Library/Android/sdk
```

---

### Paso 4: Configurar `android/local.properties`

**1. Editar `android/local.properties`**

Añade o actualiza la línea `sdk.dir` con la ruta real:

```properties
flutter.sdk=/opt/homebrew/share/flutter

# Android SDK (actualiza con tu ruta real)
sdk.dir=/Users/elenaps/Library/Android/sdk

# Google Maps API Key para Android (SDK nativo)
GOOGLE_MAPS_API_KEY=AIzaSyB3QZYmsSb1GmIewWnDS-KewupE3Ths_dY
```

**⚠️ IMPORTANTE:** Reemplaza `/Users/elenaps` con tu usuario real si es diferente.

**Para saber tu usuario:**
```bash
echo $USER
```

---

### Paso 5: Verificar que Funciona

**1. Cerrar y abrir una nueva terminal** (o ejecutar `source ~/.zshrc`)

**2. Verificar Flutter:**
```bash
flutter doctor
```

**Salida esperada:**
```
[✓] Flutter (Channel stable, ...)
[✓] Android toolchain - develop for Android devices
    • Android SDK at /Users/elenaps/Library/Android/sdk
    • Platform android-34, build-tools 34.0.0
    • Java version OpenJDK Runtime Environment
[✓] Xcode - develop for iOS and macOS
...
```

**3. Verificar `local.properties`:**
```bash
cat android/local.properties | grep sdk.dir
# Debe mostrar: sdk.dir=/Users/elenaps/Library/Android/sdk
```

---

## 🎯 Si el SDK No Está en la Ubicación Por Defecto

**Si Android Studio tiene el SDK en otra ubicación:**

1. **Obtener la ruta desde Android Studio:**
   - Settings → Android SDK → Android SDK Location

2. **Actualizar `.zshrc`:**
   ```bash
   export ANDROID_HOME=/ruta/real/del/sdk
   ```

3. **Actualizar `local.properties`:**
   ```properties
   sdk.dir=/ruta/real/del/sdk
   ```

4. **Aplicar cambios:**
   ```bash
   source ~/.zshrc
   ```

---

## 📋 Checklist Rápido

- [ ] ✅ Android Studio abierto al menos una vez (para descargar SDK)
- [ ] ✅ Ruta del SDK obtenida (desde Android Studio)
- [ ] ✅ `.zshrc` actualizado con ANDROID_HOME
- [ ] ✅ `source ~/.zshrc` ejecutado
- [ ] ✅ `android/local.properties` tiene `sdk.dir` configurado
- [ ] ✅ `flutter doctor` no muestra errores de Android

---

## 🆘 Si Sigue Sin Funcionar

### Verificar ruta del SDK manualmente:

```bash
# Buscar en ubicaciones comunes
ls -la ~/Library/Android/sdk 2>&1
ls -la /Users/$USER/Library/Android/sdk 2>&1

# O buscar en todo el sistema (puede tardar)
find ~ -name "sdk" -type d 2>/dev/null | grep -i android
```

### Si encuentras el SDK en otra ubicación:

1. **Actualizar `.zshrc`:**
   ```bash
   export ANDROID_HOME=/ruta/encontrada/sdk
   ```

2. **Actualizar `local.properties`:**
   ```properties
   sdk.dir=/ruta/encontrada/sdk
   ```

3. **Reiniciar terminal**

---

## 🚀 Después de Configurar

Una vez configurado, puedes:

1. **Obtener SHA-1 de debug:**
   ```bash
   flutter build apk --debug
   keytool -list -v -keystore ~/.android/debug.keystore \
     -alias androiddebugkey \
     -storepass android \
     -keypass android | grep "SHA1:"
   ```

2. **Configurar API Key en Google Cloud Console:**
   - Package name: `com.perikopico.fiestapp`
   - SHA-1: El que obtuviste arriba

---

**Última actualización**: Enero 2025
