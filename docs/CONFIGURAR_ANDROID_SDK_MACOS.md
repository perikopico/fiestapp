# 🔧 Configurar Android SDK en macOS

**Fecha**: Enero 2025  
**Problema**: `[!] No Android SDK found. Try setting the ANDROID_HOME environment variable.`

---

## 📋 Diagnóstico

**Tu situación:**
- ❌ No tienes Android SDK instalado
- ❌ ANDROID_HOME no está configurado
- ❌ `android/local.properties` no tiene `sdk.dir` configurado

---

## ✅ Solución: Instalar y Configurar Android SDK

### Opción 1: Instalar Android Studio (Recomendado)

**Android Studio incluye:**
- ✅ Android SDK completo
- ✅ Android Emulator
- ✅ Herramientas de desarrollo

#### Paso 1: Instalar Android Studio

**Con Homebrew (más fácil):**
```bash
brew install --cask android-studio
```

**O descargar manualmente:**
1. Ir a: https://developer.android.com/studio
2. Descargar para macOS
3. Instalar arrastrando a Applications

#### Paso 2: Abrir Android Studio y Configurar SDK

1. Abre Android Studio
2. En el primer inicio:
   - Selecciona "Standard" installation
   - Android Studio descargará el SDK automáticamente
   - **Ubicación típica:** `~/Library/Android/sdk`

3. Si ya está instalado:
   - Ve a: **Android Studio** → **Settings** → **Appearance & Behavior** → **System Settings** → **Android SDK**
   - Verás la ubicación del SDK (ej: `/Users/tu_usuario/Library/Android/sdk`)

#### Paso 3: Configurar Variables de Entorno

**Abrir `.zshrc`:**
```bash
nano ~/.zshrc
# O
code ~/.zshrc  # Si usas VS Code
```

**Añadir al final del archivo:**
```bash
# Android SDK
export ANDROID_HOME=$HOME/Library/Android/sdk
export PATH=$PATH:$ANDROID_HOME/emulator
export PATH=$PATH:$ANDROID_HOME/platform-tools
export PATH=$PATH:$ANDROID_HOME/tools
export PATH=$PATH:$ANDROID_HOME/tools/bin
```

**Aplicar cambios:**
```bash
source ~/.zshrc
```

**Verificar:**
```bash
echo $ANDROID_HOME
# Debe mostrar: /Users/tu_usuario/Library/Android/sdk
```

#### Paso 4: Configurar `android/local.properties`

**Editar `android/local.properties`** y añadir:

```properties
flutter.sdk=/opt/homebrew/share/flutter

# Android SDK (añadir esta línea)
sdk.dir=/Users/elenaps/Library/Android/sdk

# Google Maps API Key para Android (SDK nativo)
GOOGLE_MAPS_API_KEY=AIzaSyB3QZYmsSb1GmIewWnDS-KewupE3Ths_dY
```

**⚠️ IMPORTANTE:** Reemplaza `/Users/elenaps` con tu usuario real si es diferente.

**Para verificar tu usuario:**
```bash
echo $USER
```

---

### Opción 2: Solo SDK Command Line Tools (Ligero)

**Si NO quieres instalar Android Studio completo:**

#### Paso 1: Instalar Command Line Tools

```bash
brew install --cask android-commandlinetools
```

#### Paso 2: Configurar SDK

```bash
# Crear directorio para SDK
mkdir -p ~/Library/Android/sdk

# Instalar componentes necesarios
sdkmanager "platform-tools" "platforms;android-34" "build-tools;34.0.0"
```

#### Paso 3: Configurar Variables (igual que Opción 1)

Seguir el **Paso 3** de la Opción 1.

---

## ✅ Verificar Instalación

### 1. Verificar ANDROID_HOME:
```bash
echo $ANDROID_HOME
# Debe mostrar: /Users/tu_usuario/Library/Android/sdk
```

### 2. Verificar que Flutter detecta Android:
```bash
flutter doctor
```

**Salida esperada:**
```
[✓] Flutter (Channel stable, ...)
[✓] Android toolchain - develop for Android devices
    • Android SDK at /Users/tu_usuario/Library/Android/sdk
    • Platform android-34, build-tools 34.0.0
    • Java version OpenJDK Runtime Environment
[✓] Xcode - develop for iOS and macOS
...
```

### 3. Verificar `local.properties`:
```bash
cat android/local.properties | grep sdk.dir
# Debe mostrar: sdk.dir=/Users/tu_usuario/Library/Android/sdk
```

---

## 🔧 Si Sigue Sin Funcionar

### Verificar ruta real del SDK

**Si Android Studio está instalado:**
1. Abre Android Studio
2. Ve a: **File** → **Settings** (o **Preferences** en macOS)
3. **Appearance & Behavior** → **System Settings** → **Android SDK**
4. Copia la ruta que aparece en "Android SDK Location"

**O verificar si existe:**
```bash
ls -la ~/Library/Android/sdk
# O si está en otra ubicación:
find ~ -name "sdk" -type d 2>/dev/null | grep -i android
```

**Actualizar `.zshrc` con la ruta correcta:**
```bash
export ANDROID_HOME=/ruta/real/del/sdk
```

**Y actualizar `local.properties`:**
```properties
sdk.dir=/ruta/real/del/sdk
```

---

## 🚀 Después de Configurar

### 1. Obtener SHA-1 de Debug

Una vez que tengas Android SDK configurado:

```bash
# Compilar una vez para crear el keystore de debug
flutter build apk --debug

# Obtener SHA-1
keytool -list -v -keystore ~/.android/debug.keystore \
  -alias androiddebugkey \
  -storepass android \
  -keypass android | grep "SHA1:"
```

### 2. Configurar en Google Cloud Console

1. Ir a Google Cloud Console
2. APIs & Services → Credentials
3. Editar API Key de Android
4. Añadir:
   - Package name: `com.perikopico.fiestapp`
   - SHA-1: El que obtuviste arriba

---

## 📋 Checklist

### Antes de continuar:

- [ ] ✅ Android Studio instalado (o Command Line Tools)
- [ ] ✅ ANDROID_HOME configurado en `.zshrc`
- [ ] ✅ `source ~/.zshrc` ejecutado
- [ ] ✅ `android/local.properties` tiene `sdk.dir` configurado
- [ ] ✅ `flutter doctor` no muestra errores de Android
- [ ] ✅ `flutter build apk --debug` funciona

---

## ⚠️ Notas Importantes

1. **Reiniciar Terminal:**
   - Después de modificar `.zshrc`, cierra y abre una nueva terminal
   - O ejecuta: `source ~/.zshrc`

2. **Verificar Ruta:**
   - La ruta del SDK puede ser diferente según cómo instalaste Android Studio
   - Usa la ruta real que Android Studio muestra

3. **Permisos:**
   - Asegúrate de tener permisos de lectura en el directorio del SDK

---

**Última actualización**: Enero 2025
