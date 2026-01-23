# 🔐 Obtener SHA-1 de Debug (Guía Completa)

**Fecha**: Enero 2025  
**Estado**: Android SDK configurado ✅

---

## 🎯 Pasos para Obtener SHA-1

### Paso 1: Crear el Keystore de Debug

**El keystore se crea automáticamente al compilar. Ejecuta:**

```bash
flutter build apk --debug
```

**Espera a que termine la compilación** (puede tardar 1-2 minutos la primera vez).

---

### Paso 2: Obtener SHA-1

**Ahora ejecuta una de estas opciones:**

#### ✅ Opción A: Script Automático (Recomendado)

```bash
./scripts/obtener_sha1_debug.sh
```

**Este script:**
- Usa automáticamente el JDK de Android Studio
- Verifica que el keystore existe
- Muestra toda la información del certificado
- Indica cómo copiar solo el SHA-1

---

#### ✅ Opción B: Comando Directo (Usando JDK de Android Studio)

```bash
/Applications/Android\ Studio.app/Contents/jbr/Contents/Home/bin/keytool \
  -list -v -keystore ~/.android/debug.keystore \
  -alias androiddebugkey \
  -storepass android \
  -keypass android | grep "SHA1:"
```

**Salida esperada:**
```
SHA1: 12:FE:47:5B:A4:14:D7:44:D0:C4:F8:C2:C3:68:F2:6A:63:8A:AD:7A
```

**📝 Copia TODO el SHA-1** (con los dos puntos `:`).

---

#### ✅ Opción C: Si Configuraste JAVA_HOME

**Si ya configuraste JAVA_HOME en `.zshrc`:**

```bash
keytool -list -v -keystore ~/.android/debug.keystore \
  -alias androiddebugkey \
  -storepass android \
  -keypass android | grep "SHA1:"
```

---

### Paso 3: Ver Información Completa (Opcional)

**Para ver toda la información del certificado:**

```bash
/Applications/Android\ Studio.app/Contents/jbr/Contents/Home/bin/keytool \
  -list -v -keystore ~/.android/debug.keystore \
  -alias androiddebugkey \
  -storepass android \
  -keypass android
```

**Busca la línea que dice:**
```
SHA1: 12:FE:47:5B:A4:14:D7:44:D0:C4:F8:C2:C3:68:F2:6A:63:8A:AD:7A
```

---

## 📋 Resumen de Comandos

### Todo en Uno:

```bash
# 1. Compilar (si no lo has hecho)
flutter build apk --debug

# 2. Obtener SHA-1
/Applications/Android\ Studio.app/Contents/jbr/Contents/Home/bin/keytool \
  -list -v -keystore ~/.android/debug.keystore \
  -alias androiddebugkey \
  -storepass android \
  -keypass android | grep "SHA1:"
```

---

## ⚙️ Configurar JAVA_HOME (Opcional pero Recomendado)

**Para no tener que escribir la ruta completa cada vez:**

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

**5. Ahora puedes usar `keytool` directamente:**
```bash
keytool -list -v -keystore ~/.android/debug.keystore \
  -alias androiddebugkey \
  -storepass android \
  -keypass android | grep "SHA1:"
```

---

## 🎯 Próximo Paso

**Una vez tengas el SHA-1:**

1. **Ir a Google Cloud Console:**
   - https://console.cloud.google.com/
   - APIs & Services → Credentials
   - Editar tu API Key de Android

2. **Añadir restricción:**
   - Application restrictions → Android apps
   - Package name: `com.perikopico.fiestapp`
   - SHA-1: [pega el SHA-1 que copiaste]

3. **Configurar APIs:**
   - API restrictions → Restrict key
   - Marcar: Maps SDK for Android, Places API (New), Geocoding API

4. **Guardar** y esperar 1-2 minutos

---

## 🆘 Troubleshooting

### "El archivo de almacén de claves no existe"
- **Solución:** Ejecuta `flutter build apk --debug` primero

### "Unable to locate a Java Runtime"
- **Solución:** Usa el JDK de Android Studio (ver comandos arriba)

### "No such file or directory" en keytool
- **Solución:** Verifica que Android Studio esté instalado en `/Applications/Android Studio.app`

---

**Última actualización**: Enero 2025
