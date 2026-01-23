# 🔧 Obtener SHA-1 sin Android SDK Configurado

**Fecha**: Enero 2025  
**Problema**: No tienes Android SDK configurado pero necesitas el SHA-1

---

## ⚠️ Problema

**Error:**
```
[!] No Android SDK found. Try setting the ANDROID_HOME environment variable.
```

**Causa:** Flutter necesita Android SDK para compilar, pero el keystore de debug se crea cuando compilas la primera vez.

---

## ✅ Solución 1: Usar Flutter para crear el keystore

### Opción A: Instalar Android SDK (Recomendado para desarrollo)

**Si usas macOS con Homebrew:**

```bash
# Instalar Android Studio (incluye SDK)
brew install --cask android-studio

# O instalar solo Android SDK Command Line Tools
brew install --cask android-commandlinetools
```

**Configurar ANDROID_HOME:**

```bash
# Añadir a ~/.zshrc o ~/.bash_profile
export ANDROID_HOME=$HOME/Library/Android/sdk
export PATH=$PATH:$ANDROID_HOME/tools
export PATH=$PATH:$ANDROID_HOME/platform-tools

# Aplicar cambios
source ~/.zshrc
```

**Luego compilar una vez para crear el keystore:**

```bash
flutter build apk --debug
```

---

## ✅ Solución 2: Obtener SHA-1 directamente (si el keystore ya existe)

**Si ya tienes el keystore de debug** (de otra app o proyecto):

### Verificar si existe:

```bash
ls -la ~/.android/debug.keystore
```

**Si existe, obtener SHA-1 directamente:**

```bash
# Opción 1: Con keytool (necesitas Java)
keytool -list -v -keystore ~/.android/debug.keystore \
  -alias androiddebugkey \
  -storepass android \
  -keypass android | grep "SHA1:"

# Opción 2: Si tienes Java pero no Android SDK
# El keystore puede existir aunque no tengas SDK configurado
```

---

## ✅ Solución 3: Usar Android Studio (GUI)

**Si tienes Android Studio instalado:**

1. Abre Android Studio
2. Crea un nuevo proyecto Android (cualquier nombre)
3. Ve a: **Build** → **Generate Signed Bundle / APK**
4. Selecciona: **APK**
5. En el diálogo, verás las opciones de signing
6. Haz clic en **"Create new..."** (aunque no lo uses)
7. Android Studio mostrará información del keystore de debug
8. O ve a: **File** → **Project Structure** → **Signing Configs** → **debug**

---

## ✅ Solución 4: SHA-1 Estándar de Debug

**Importante:** El keystore de debug tiene un SHA-1 **estándar** que es el mismo para todos los desarrolladores (o muy similar).

### SHA-1 común de debug:

```
SHA1: 12:FE:47:5B:A4:14:D7:44:D0:C4:F8:C2:C3:68:F2:6A:63:8A:AD:7A
```

**⚠️ PERO:** Es mejor obtener el tuyo específico porque puede variar ligeramente.

---

## 🔍 Verificar si tienes Java instalado

```bash
java -version
```

**Si no tienes Java:**

```bash
# macOS
brew install openjdk@11

# O descargar desde:
# https://www.java.com/download/
```

---

## 🎯 Workaround Temporal

**Si necesitas configurar la API Key AHORA y no puedes obtener el SHA-1:**

1. **Usar SHA-1 estándar temporalmente:**
   - Añadir el SHA-1 común: `12:FE:47:5B:A4:14:D7:44:D0:C4:F8:C2:C3:68:F2:6A:63:8A:AD:7A`

2. **Probar la app:**
   - Si funciona → Perfecto
   - Si no funciona → Necesitas obtener tu SHA-1 específico

3. **Obtener el SHA-1 real después:**
   - Instalar Android SDK
   - Compilar la app una vez
   - Obtener SHA-1 real
   - Actualizar en Google Cloud Console

---

## 📋 Pasos Recomendados

### Para desarrollo (corto plazo):

1. **Añadir SHA-1 estándar a la API Key:**
   - SHA-1: `12:FE:47:5B:A4:14:D7:44:D0:C4:F8:C2:C3:68:F2:6A:63:8A:AD:7A`
   - Probablemente funcionará

2. **Probar la app:**
   ```bash
   flutter run
   ```

3. **Si no funciona, instalar Android SDK:**
   - Ver Solución 1

### Para producción (antes de publicar):

1. **Instalar Android SDK** (obligatorio)
2. **Configurar ANDROID_HOME**
3. **Compilar la app:**
   ```bash
   flutter build apk --debug
   ```
4. **Obtener SHA-1 real:**
   ```bash
   keytool -list -v -keystore ~/.android/debug.keystore \
     -alias androiddebugkey \
     -storepass android \
     -keypass android | grep "SHA1:"
   ```
5. **Actualizar en Google Cloud Console**

---

## 💡 Alternativa: Usar macOS Keychain (si está disponible)

**Si tienes el keystore pero no keytool disponible:**

```bash
# Verificar si keytool está disponible
which keytool

# Si no está, buscar en instalación de Java
/usr/libexec/java_home -V
# Buscar keytool en la instalación de Java
```

---

**Última actualización**: Enero 2025
