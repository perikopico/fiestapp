# 🔍 Guía de Diagnóstico: Google Maps

## Verificaciones paso a paso

### 1. ✅ Verificar logs de error

**Ejecuta la app y busca en los logs:**

```bash
flutter run -d android
```

**Busca en los logs:**
- Errores que contengan "Google Maps"
- Errores de "API key"
- Errores de "authorization"
- Mensajes que digan "Maps SDK"

**¿Qué deberías ver?**
- Si ves `✅ Mapa creado correctamente` → El mapa se inicializa bien
- Si ves errores de "API key" o "authorization" → Problema con la API key

**Copia cualquier error que veas y guárdalo para la siguiente verificación.**

---

### 2. ✅ Verificar la API Key en Google Cloud Console

**Ve a:** [Google Cloud Console](https://console.cloud.google.com/)

**Pasos:**
1. Selecciona tu proyecto (o el proyecto donde creaste la API key)
2. Ve a **APIs & Services > Credentials**
3. Busca la API key: `AIzaSyBlGvnFjcZ2NMNBgIt4ylNIo5W8TeBtyuI`
4. Haz clic en ella para ver detalles

**Verifica:**

#### A) Estado de la API Key
- ✅ **¿Está habilitada?** → Debe estar en verde/activa
- ✅ **¿No está restringida?** → Si está restringida, verifica las restricciones

#### B) APIs habilitadas
1. Ve a **APIs & Services > Enabled APIs**
2. Verifica que esté habilitada:
   - ✅ **Maps SDK for Android** ← Esta es CRÍTICA
   - ✅ **Maps SDK for iOS** (si también quieres iOS)
   - ✅ **Places API** (opcional, si usas búsqueda de lugares)

**Si no está habilitada:**
- Haz clic en **+ ENABLE APIS AND SERVICES**
- Busca "Maps SDK for Android"
- Haz clic en **ENABLE**

#### C) Restricciones de la API Key
En la página de detalles de la API key, revisa:

**Restricciones de aplicación:**
- ¿Hay restricciones de Android?
- Si sí, verifica:
  - **Package name:** `com.perikopico.fiestapp` ← **ESTE ES EL CORRECTO**
  - **SHA-1:** (necesitamos obtener el SHA-1 correcto - ver paso 3)

**Restricciones de API:**
- ¿Está restringida a APIs específicas?
- Si sí, debe incluir **Maps SDK for Android**

---

### 3. ✅ Obtener el SHA-1 correcto de tu app

El SHA-1 es un "fingerprint" único de tu app que Google Maps necesita para validar la API key.

**Para obtener el SHA-1 en modo debug:**

```bash
cd android
./gradlew signingReport
```

O si usas Gradle directamente:

```bash
cd android
./gradlew app:signingReport
```

**Busca en la salida:**
```
Variant: debug
Config: debug
Store: ~/.android/debug.keystore
Alias: AndroidDebugKey
SHA1: XX:XX:XX:XX:XX:XX:XX:XX:XX:XX:XX:XX:XX:XX:XX:XX:XX:XX:XX:XX
```

**Copia el SHA-1 que aparece** (formato: `XX:XX:XX:...`)

**IMPORTANTE:**
- El SHA-1 del código menciona: `12:FE:47:5B:A4:14:D7:44:D0:C4:F8:C2:C3:68:F2:6A:63:8A:AD:7A`
- Verifica que el SHA-1 que obtengas coincida con el que está configurado en Google Cloud Console

---

### 4. ✅ Verificar SHA-1 en Google Cloud Console

**En la página de detalles de tu API key:**

1. Ve a la sección **"Application restrictions"**
2. Si está configurada para **Android apps**, verifica:
   - ✅ El package name es: `com.perikopico.fiestapp`
   - ✅ El SHA-1 coincide con el que obtuviste en el paso 3

**Si el SHA-1 NO coincide:**
1. Haz clic en **+ ADD AN ITEM**
2. Pega el SHA-1 correcto
3. Haz clic en **SAVE**

**Si no hay restricción de Android:**
- Puedes dejarlo sin restricciones para pruebas
- O añadir la restricción con el SHA-1 correcto

**Package Name a usar:**
- **Package name:** `com.perikopico.fiestapp` ← **COPIA EXACTAMENTE ESTE**

---

### 5. ✅ Verificar la API Key en AndroidManifest.xml

**Abre:** `android/app/src/main/AndroidManifest.xml`

**Verifica que esté configurada así:**

```xml
<meta-data
    android:name="com.google.android.geo.API_KEY"
    android:value="AIzaSyBlGvnFjcZ2NMNBgIt4ylNIo5W8TeBtyuI" />
```

**Debe estar:**
- ✅ Dentro de `<application>...</application>`
- ✅ Con el nombre exacto: `com.google.android.geo.API_KEY`
- ✅ Con tu API key real (no una placeholder)

---

### 6. ✅ Verificar permisos de ubicación

**En `AndroidManifest.xml`, verifica que tengas:**

```xml
<uses-permission android:name="android.permission.INTERNET" />
<uses-permission android:name="android.permission.ACCESS_FINE_LOCATION" />
<uses-permission android:name="android.permission.ACCESS_COARSE_LOCATION" />
```

**Estos permisos ya están configurados** ✅

---

### 7. ✅ Probar en un dispositivo/emulador real

**Después de hacer cambios:**

1. **Reconstruye la app completamente:**
   ```bash
   flutter clean
   flutter pub get
   flutter run -d android
   ```

2. **Ve a una pantalla que use el mapa:**
   - Detalles de un evento (si tiene maps_url)
   - Crear evento → seleccionar ubicación

3. **Observa:**
   - ¿Se muestra un mapa en blanco?
   - ¿Aparece un error en pantalla?
   - ¿Se muestra el mapa correctamente?

---

## 🔧 Soluciones comunes

### Problema 1: "API key not valid"
**Solución:**
- Verifica que la API key esté correctamente copiada en AndroidManifest.xml
- Verifica que la API key esté habilitada en Google Cloud Console
- Espera 5-10 minutos después de crear/modificar la API key

### Problema 2: "This API key is not authorized"
**Solución:**
- Verifica que "Maps SDK for Android" esté habilitada en el proyecto
- Verifica las restricciones de la API key
- Verifica que el SHA-1 coincida

### Problema 3: Mapa en blanco (sin errores)
**Solución:**
- Verifica que tienes conexión a internet
- Verifica los logs para errores silenciosos
- Prueba con una API key sin restricciones temporalmente

### Problema 4: "Google Play Services not available"
**Solución:**
- Verifica que el emulador tenga Google Play Services instalado
- Prueba en un dispositivo físico
- Actualiza Google Play Services en el dispositivo

---

## 📋 Checklist de diagnóstico

**Antes de pedir ayuda, verifica:**

- [ ] La API key está habilitada en Google Cloud Console
- [ ] "Maps SDK for Android" está habilitada
- [ ] El SHA-1 en Google Cloud Console coincide con el de tu app
- [ ] El package name en Google Cloud Console es `com.perikopico.fiestapp`
- [ ] La API key en AndroidManifest.xml es correcta
- [ ] He reconstruido la app después de hacer cambios (`flutter clean`)
- [ ] He esperado 5-10 minutos después de modificar la API key
- [ ] Los logs no muestran errores específicos (copia los errores si los hay)

---

## 🆘 ¿Qué comprobar primero?

**En este orden:**

1. **Ejecuta la app y copia los errores de los logs** ← PRIMERO
2. Verifica que "Maps SDK for Android" esté habilitada
3. Obtén el SHA-1 y verifica que coincida en Google Cloud Console
4. Reconstruye la app completamente

---

## 📝 Información que necesito para ayudarte

Si después de seguir estos pasos sigue sin funcionar, comparte:

1. **Errores de los logs** (copiar completo)
2. **SHA-1 que obtuviste** con `./gradlew signingReport`
3. **Estado de la API key** en Google Cloud Console:
   - ¿Está habilitada?
   - ¿Qué APIs tiene habilitadas?
   - ¿Qué restricciones tiene?
4. **Qué ves en la app:**
   - Mapa en blanco
   - Mensaje de error
   - Nada (pantalla vacía)

---

## 🎯 Próximos pasos

1. Ejecuta la app y copia los logs
2. Obtén el SHA-1 con el comando de gradle
3. Verifica la API key en Google Cloud Console
4. Comparte los resultados y te ayudo a resolver el problema específico

