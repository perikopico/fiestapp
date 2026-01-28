# ☕ Configurar Java en macOS (Para keytool)

**Fecha**: Enero 2025  
**Problema**: `Unable to locate a Java Runtime`

---

## ✅ Solución Rápida: Usar JDK de Android Studio

Android Studio viene con su propio JDK instalado. Puedes usarlo directamente sin instalar nada más.

### Opción 1: Usar el Script Automático (Recomendado)

**Ejecuta:**
```bash
./scripts/obtener_sha1_debug.sh
```

Este script usa automáticamente el JDK de Android Studio.

---

### Opción 2: Ejecutar keytool Directamente

**Usando el JDK de Android Studio:**

```bash
/Applications/Android\ Studio.app/Contents/jbr/Contents/Home/bin/keytool \
  -list -v -keystore ~/.android/debug.keystore \
  -alias androiddebugkey \
  -storepass android \
  -keypass android | grep "SHA1:"
```

---

### Opción 3: Configurar JAVA_HOME Permanentemente

**1. Editar `.zshrc`:**
```bash
nano ~/.zshrc
```

**2. Añadir al final:**
```bash
# Java (JDK de Android Studio)
export JAVA_HOME="/Applications/Android Studio.app/Contents/jbr/Contents/Home"
export PATH="$JAVA_HOME/bin:$PATH"
```

**3. Aplicar cambios:**
```bash
source ~/.zshrc
```

**4. Verificar:**
```bash
java -version
# Debe mostrar la versión de Java
```

**5. Ahora puedes usar keytool normalmente:**
```bash
keytool -list -v -keystore ~/.android/debug.keystore \
  -alias androiddebugkey \
  -storepass android \
  -keypass android | grep "SHA1:"
```

---

## 🔄 Alternativa: Instalar Java con Homebrew

Si prefieres tener Java independiente de Android Studio:

**1. Instalar OpenJDK:**
```bash
brew install openjdk@17
```

**2. Configurar en `.zshrc`:**
```bash
nano ~/.zshrc
```

**3. Añadir:**
```bash
# Java (Homebrew)
export JAVA_HOME="/opt/homebrew/opt/openjdk@17"
export PATH="$JAVA_HOME/bin:$PATH"
```

**4. Aplicar:**
```bash
source ~/.zshrc
```

---

## 🎯 Recomendación

**Usa el JDK de Android Studio** (Opción 3) porque:
- ✅ Ya está instalado (no descargas adicionales)
- ✅ Es compatible con desarrollo Android
- ✅ Versión optimizada para Flutter/Android
- ✅ No ocupa espacio extra

---

**Última actualización**: Enero 2025
