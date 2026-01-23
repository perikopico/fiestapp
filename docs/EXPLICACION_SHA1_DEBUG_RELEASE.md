# 🔐 Explicación: SHA-1 Debug vs Release

**Fecha**: Enero 2025  
**Objetivo**: Entender por qué debug y release tienen SHA-1 diferentes

---

## 🔑 ¿Qué es el SHA-1?

El **SHA-1** es una "huella digital" única del **certificado** que firma tu aplicación Android.

**Piensa en él como:**
- Una identificación única del certificado
- Como un "DNI" del certificado de firma
- Cada certificado tiene un SHA-1 diferente

---

## 📦 ¿De dónde sale cada SHA-1?

### 🔵 SHA-1 de Debug (Desarrollo)

**Origen:** Keystore automático generado por Android SDK

**Ubicación:** `~/.android/debug.keystore`

**¿Quién lo crea?**
- ✅ Android SDK lo crea **automáticamente** la primera vez que compilas una app
- ✅ Está en tu máquina local
- ✅ **Todos los desarrolladores tienen el mismo** (estándar de Android)

**Contraseña por defecto:**
- Username: `android`
- Password: `android`
- Alias: `androiddebugkey`

**Características:**
- ⚠️ **NO es seguro** para producción
- ⚠️ Es conocido públicamente
- ✅ Válido por 365 días (se renueva automáticamente)
- ✅ Útil solo para desarrollo y testing local

**Ejemplo de SHA-1 debug:**
```
12:FE:47:5B:A4:14:D7:44:D0:C4:F8:C2:C3:68:F2:6A:63:8A:AD:7A
```

---

### 🔴 SHA-1 de Release (Producción)

**Origen:** Keystore personal que **TÚ creas**

**Ubicación:** Donde tú lo guardes (ej: `~/upload-keystore.jks`)

**¿Quién lo crea?**
- ❌ NO es automático
- ✅ **TÚ lo creas** manualmente con el comando `keytool`
- ✅ Es **único para tu app/proyecto**
- ✅ Solo tú tienes acceso a él

**Contraseña:**
- ✅ La que **TÚ elijas** al crearlo
- ⚠️ **DEBES guardarla** de forma segura
- ⚠️ Si la pierdes, NO podrás actualizar tu app

**Características:**
- ✅ **Seguro** para producción
- ✅ Único para tu app
- ✅ Válido por el tiempo que elijas (ej: 10,000 días)
- ✅ Necesario para publicar en Play Store

**Ejemplo de SHA-1 release:**
```
AB:CD:EF:12:34:56:78:90:AB:CD:EF:12:34:56:78:90:AB:CD:EF:12
```
(Nota: Este es un ejemplo, el tuyo será diferente)

---

## 🎯 ¿Por qué son diferentes?

### Explicación Simple

**SHA-1 = Huella digital del certificado**

**Debug:**
- Usa el keystore `debug.keystore` (automático)
- Certificado: Generado automáticamente por Android SDK
- SHA-1: `12:FE:47:5B:A4:14:D7:44:D0:C4:F8:C2:C3:68:F2:6A:63:8A:AD:7A`

**Release:**
- Usa TU keystore personal (ej: `upload-keystore.jks`)
- Certificado: Generado por TÍ con `keytool`
- SHA-1: `AB:CD:EF:12:34:56:78:90:AB:CD:EF:12:34:56:78:90:AB:CD:EF:12`

**Conclusión:** Son **keystores diferentes** → **certificados diferentes** → **SHA-1 diferentes**

---

## 📊 Comparación Visual

### Debug (Automático)

```
Android SDK
    ↓
Genera automáticamente: ~/.android/debug.keystore
    ↓
Contiene certificado con SHA-1: 12:FE:47:5B:A4:14:D7:44:D0:C4:F8:C2:C3:68:F2:6A:63:8A:AD:7A
    ↓
Tu app se firma con este certificado (modo debug)
    ↓
Google Maps verifica: "¿Esta app tiene el SHA-1 12:FE:47...?"
```

### Release (Manual)

```
TÚ ejecutas: keytool -genkey -keystore ~/upload-keystore.jks
    ↓
Creas manualmente: ~/upload-keystore.jks
    ↓
Contiene certificado con SHA-1: AB:CD:EF:12:34:56:78:90:AB:CD:EF:12:34:56:78:90:AB:CD:EF:12
    ↓
Tu app se firma con este certificado (modo release)
    ↓
Google Maps verifica: "¿Esta app tiene el SHA-1 AB:CD:EF...?"
```

---

## 🔍 Cómo Ver los Keystores

### Ver Keystore de Debug

**Ubicación:**
```bash
ls ~/.android/debug.keystore
```

**Ver información (SHA-1):**
```bash
keytool -list -v -keystore ~/.android/debug.keystore -alias androiddebugkey -storepass android -keypass android
```

**O usando Gradle:**
```bash
cd android
./gradlew signingReport
# Buscar "Variant: debug"
```

**Salida esperada:**
```
Variant: debug
Config: debug
Store: ~/.android/debug.keystore
Alias: AndroidDebugKey
SHA1: 12:FE:47:5B:A4:14:D7:44:D0:C4:F8:C2:C3:68:F2:6A:63:8A:AD:7A
```

---

### Ver Keystore de Release

**Ubicación:**
```bash
# Donde tú lo guardaste (ejemplo)
ls ~/upload-keystore.jks
```

**Ver información (SHA-1):**
```bash
keytool -list -v -keystore ~/upload-keystore.jks -alias upload
# Te pedirá la contraseña que configuraste
```

**Salida esperada:**
```
Alias name: upload
Creation date: ...
Entry type: PrivateKeyEntry
Certificate fingerprints:
     SHA1: AB:CD:EF:12:34:56:78:90:AB:CD:EF:12:34:56:78:90:AB:CD:EF:12
```

**O usando Gradle (si está configurado):**
```bash
cd android
./gradlew signingReport
# Buscar "Variant: release"
```

---

## 🎓 Conceptos Clave

### 1. ¿Qué es un Keystore?

Un **keystore** es un archivo que contiene:
- Tu certificado de firma
- Tu clave privada
- Información sobre el certificado (SHA-1, SHA-256, etc.)

**Es como una caja fuerte** que guarda tu identidad digital.

---

### 2. ¿Qué es un Certificado?

Un **certificado** es como tu "DNI digital":
- Identifica tu app como tuya
- Prueba que eres tú quien la firmó
- Tiene una huella digital única (SHA-1)

**Cada certificado tiene un SHA-1 único.**

---

### 3. ¿Qué es el SHA-1?

**SHA-1** = Secure Hash Algorithm 1
- Es una función matemática que genera una "huella" única
- Cada certificado tiene un SHA-1 diferente
- Es como un "hash" del certificado

**Ejemplo:**
```
Certificado A → SHA-1: 12:FE:47:5B...
Certificado B → SHA-1: AB:CD:EF:12...
```

---

## 🔄 Flujo Completo

### Cuando Compilas en Debug:

```
1. Gradle detecta: buildType = "debug"
2. Busca: ~/.android/debug.keystore
3. Usa el certificado de debug para firmar
4. SHA-1 usado: El del certificado de debug (12:FE:47...)
5. Google Maps verifica: "¿API Key tiene este SHA-1?"
```

### Cuando Compilas en Release:

```
1. Gradle detecta: buildType = "release"
2. Busca: Tu keystore personal (ej: ~/upload-keystore.jks)
3. Usa TU certificado para firmar
4. SHA-1 usado: El de TU certificado (AB:CD:EF...)
5. Google Maps verifica: "¿API Key tiene este SHA-1?"
```

---

## ⚠️ Importante para Google Maps API

### ¿Por qué Google necesita el SHA-1?

Google Maps verifica el SHA-1 para asegurar que:
1. ✅ Solo TU app puede usar la API Key
2. ✅ No otros desarrolladores pueden copiar tu API Key
3. ✅ La app está firmada con TU certificado

**Flujo:**
```
Tu app intenta usar Google Maps
    ↓
Google Maps pregunta: "¿Qué SHA-1 tiene esta app?"
    ↓
Tu app responde: "12:FE:47:5B..." (debug) o "AB:CD:EF:12..." (release)
    ↓
Google Maps verifica: "¿La API Key tiene este SHA-1 configurado?"
    ↓
✅ Si SÍ → Permite acceso
❌ Si NO → Deniega acceso (error: "API key not authorized")
```

---

## 💡 Resumen Visual

```
┌─────────────────────────────────────────────────────────┐
│ DEBUG                                                   │
├─────────────────────────────────────────────────────────┤
│ Keystore: ~/.android/debug.keystore                    │
│ Creado por: Android SDK (automático)                   │
│ Contraseña: android/android (conocida)                 │
│ SHA-1: 12:FE:47:5B:A4:14:D7:44:D0:C4:F8:C2:C3:68:...  │
│                                                         │
│ └─ Usado para: Desarrollo local, testing               │
└─────────────────────────────────────────────────────────┘

┌─────────────────────────────────────────────────────────┐
│ RELEASE                                                 │
├─────────────────────────────────────────────────────────┤
│ Keystore: ~/upload-keystore.jks (TU keystore)          │
│ Creado por: TÚ (comando keytool)                       │
│ Contraseña: La que TÚ elijas (secreta)                 │
│ SHA-1: AB:CD:EF:12:34:56:78:90:AB:CD:EF:12:34:56:...  │
│                                                         │
│ └─ Usado para: Producción, Play Store                  │
└─────────────────────────────────────────────────────────┘

Son DIFERENTES porque:
  ✅ Son keystores diferentes
  ✅ Son certificados diferentes  
  ✅ Por tanto, SHA-1 diferentes
```

---

## ✅ Solución: Añadir AMBOS SHA-1 a la API Key

**Puedes añadir múltiples SHA-1 a la misma API Key:**

```
Google Cloud Console → API Key → Android apps

Package name: com.perikopico.fiestapp
  ├─ SHA-1 (Debug):  12:FE:47:5B:A4:14:D7:44:D0:C4:F8:C2:C3:68:F2:6A:63:8A:AD:7A
  └─ SHA-1 (Release): AB:CD:EF:12:34:56:78:90:AB:CD:EF:12:34:56:78:90:AB:CD:EF:12
```

**Ventaja:**
- ✅ Funciona en debug (desarrollo)
- ✅ Funciona en release (producción)
- ✅ Una sola API Key para ambos casos

---

## 🔍 Comandos Útiles

### Ver SHA-1 de Debug:
```bash
cd android
./gradlew signingReport | grep -A 10 "Variant: debug"
```

### Ver SHA-1 de Release:
```bash
# Si tienes el keystore:
keytool -list -v -keystore ~/upload-keystore.jks -alias upload

# O si está configurado en Gradle:
cd android
./gradlew signingReport | grep -A 10 "Variant: release"
```

### Ver todos los SHA-1 (debug y release):
```bash
cd android
./gradlew signingReport
```

---

## 📚 Resumen

### ¿Por qué son diferentes?

**Porque son certificados diferentes:**

1. **Debug** → Certificado del keystore automático (`debug.keystore`)
2. **Release** → Certificado de TU keystore personal (`upload-keystore.jks`)

**Cada certificado tiene su propio SHA-1 único.**

### ¿De dónde sale cada uno?

1. **SHA-1 Debug:**
   - Del keystore `~/.android/debug.keystore`
   - Generado automáticamente por Android SDK
   - Mismo para todos los desarrolladores (estándar)

2. **SHA-1 Release:**
   - De TU keystore personal (`upload-keystore.jks`)
   - Creado por TÍ con `keytool`
   - Único para tu app/proyecto

---

**Última actualización**: Enero 2025
