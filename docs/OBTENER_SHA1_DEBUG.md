# 🔍 Cómo Obtener SHA-1 de Debug para Android

**Fecha**: Enero 2025  
**Objetivo**: Obtener el SHA-1 del keystore de debug para configurar la API Key de Google Maps

---

## 🚀 Método 1: Usando keytool (Más Directo)

### Comando:

```bash
keytool -list -v -keystore ~/.android/debug.keystore -alias androiddebugkey -storepass android -keypass android
```

### Salida esperada:

```
Alias name: androiddebugkey
Creation date: ...
Entry type: PrivateKeyEntry
Certificate chain length: 1
Certificate[1]:
Owner: CN=Android Debug, O=Android, C=US
Issuer: CN=Android Debug, O=Android, C=US
Serial number: ...
Valid from: ... until: ...
Certificate fingerprints:
     SHA1: 12:FE:47:5B:A4:14:D7:44:D0:C4:F8:C2:C3:68:F2:6A:63:8A:AD:7A
     SHA256: ...
Signature algorithm name: SHA256withRSA
```

### 📝 Copiar el SHA-1:

Busca la línea que dice `SHA1:` y copia el valor completo (con los dos puntos `:`).

**Ejemplo:**
```
SHA1: 12:FE:47:5B:A4:14:D7:44:D0:C4:F8:C2:C3:68:F2:6A:63:8A:AD:7A
```

---

## 🚀 Método 2: Usando Gradle (Si tienes gradlew)

### Comando:

```bash
cd android
./gradlew signingReport
```

### Buscar en la salida:

Busca la sección que dice:
```
Variant: debug
Config: debug
Store: ~/.android/debug.keystore
Alias: AndroidDebugKey
SHA1: 12:FE:47:5B:A4:14:D7:44:D0:C4:F8:C2:C3:68:F2:6A:63:8A:AD:7A
```

### Filtrar solo el SHA-1:

```bash
cd android
./gradlew signingReport | grep -A 10 "Variant: debug" | grep "SHA1:"
```

---

## 🚀 Método 3: Usando Flutter (Alternativa)

### Comando:

```bash
flutter build apk --debug
```

Luego verificar los logs, aunque este método es menos directo.

---

## ✅ Verificar que Funciona

### Si el keystore no existe:

Si obtienes un error como:
```
keytool error: java.io.FileNotFoundException: /Users/tu_usuario/.android/debug.keystore
```

**Solución:** El keystore se crea automáticamente la primera vez que compilas una app Android. Simplemente compila una vez:

```bash
flutter build apk --debug
```

Luego vuelve a ejecutar el comando `keytool`.

---

## 📋 Pasos Siguientes

Una vez que tengas el SHA-1 de debug:

1. **Copiar el SHA-1 completo** (con los dos puntos)
   - Ejemplo: `12:FE:47:5B:A4:14:D7:44:D0:C4:F8:C2:C3:68:F2:6A:63:8A:AD:7A`

2. **Ir a Google Cloud Console:**
   - https://console.cloud.google.com/
   - APIs & Services → Credentials
   - Editar tu API Key de Android

3. **Añadir restricción:**
   - Application restrictions → Android apps
   - Package name: `com.perikopico.fiestapp`
   - SHA-1 certificate fingerprint: Pega tu SHA-1

4. **Guardar cambios**

---

## 🔍 Script Automatizado

Puedes crear un script para obtenerlo fácilmente:

**Crear archivo:** `scripts/obtener_sha1_debug.sh`

```bash
#!/bin/bash
echo "🔍 Obteniendo SHA-1 de Debug..."
echo ""

keytool -list -v -keystore ~/.android/debug.keystore \
  -alias androiddebugkey \
  -storepass android \
  -keypass android 2>/dev/null | grep -A 2 "SHA1:" | head -3

echo ""
echo "✅ Copia el SHA-1 que aparece arriba"
```

**Hacer ejecutable:**
```bash
chmod +x scripts/obtener_sha1_debug.sh
```

**Ejecutar:**
```bash
./scripts/obtener_sha1_debug.sh
```

---

## ⚠️ Notas Importantes

1. **El SHA-1 de debug es estándar:**
   - Todos los desarrolladores tienen el mismo (o similar)
   - Es seguro compartirlo (no es secreto)
   - Solo funciona para desarrollo local

2. **Formato del SHA-1:**
   - Debe tener 20 pares de caracteres hexadecimales
   - Separados por dos puntos `:`
   - Ejemplo: `12:FE:47:5B:A4:14:D7:44:D0:C4:F8:C2:C3:68:F2:6A:63:8A:AD:7A`

3. **Si no tienes el keystore de debug:**
   - Compila una vez: `flutter build apk --debug`
   - Android SDK lo creará automáticamente

---

**Última actualización**: Enero 2025
