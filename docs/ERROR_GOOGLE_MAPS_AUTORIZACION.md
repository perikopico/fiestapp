# ❌ Error de Autorización de Google Maps

## Error Encontrado

En los logs (líneas 607-612) aparece:

```
E/Google Android Maps SDK(18587): Authorization failure.
E/Google Android Maps SDK(18587): Ensure that the "Maps SDK for Android" is enabled.
E/Google Android Maps SDK(18587): Ensure that the following Android Key exists:
E/Google Android Maps SDK(18587):       API Key: AIzaSyBlGvnFjcZ2NMNBgIt4ylNIo5W8TeBtyuI
E/Google Android Maps SDK(18587):       Android Application (<cert_fingerprint>;<package_name>): 
E/Google Android Maps SDK(18587):       12:FE:47:5B:A4:14:D7:44:D0:C4:F8:C2:C3:68:F2:6A:63:8A:AD:7A;com.perikopico.fiestapp
```

## 🔍 Diagnóstico

El error indica que Google Maps SDK está rechazando la autorización. Esto significa que:

1. ✅ La API Key está siendo leída correctamente: `AIzaSyBlGvnFjcZ2NMNBgIt4ylNIo5W8TeBtyuI`
2. ✅ El SHA-1 y package name están siendo enviados correctamente
3. ❌ Pero Google Cloud Console está rechazando la autorización

## 🔧 Posibles Causas

### 1. Formato de las Restricciones

El formato que Google espera es:
```
SHA-1;package_name
```

Sin espacios, punto y coma (`;`) como separador.

**Verifica en Google Cloud Console:**
- El SHA-1 debe estar sin espacios
- El package name debe estar exactamente como se muestra
- El separador debe ser punto y coma (`;`), no dos puntos (`:`)

### 2. La API Key está Restringida Incorrectamente

En Google Cloud Console, verifica:

**Restricciones de API:**
- ✅ "Maps SDK for Android" está habilitada

**Restricciones de Aplicación:**
- ✅ "Android apps" está seleccionada
- ✅ El SHA-1 es exactamente: `12:FE:47:5B:A4:14:D7:44:D0:C4:F8:C2:C3:68:F2:6A:63:8A:AD:7A`
- ✅ El package name es exactamente: `com.perikopico.fiestapp`

### 3. Tiempo de Propagación

Si acabas de hacer cambios, espera 10-15 minutos.

### 4. Proyecto Incorrecto en Google Cloud Console

Verifica que la API key que estás editando sea la misma que está en AndroidManifest.xml.

## ✅ Solución Paso a Paso

### Paso 1: Verificar en Google Cloud Console

1. Ve a [Google Cloud Console](https://console.cloud.google.com/)
2. Selecciona el proyecto correcto
3. Ve a **APIs & Services > Credentials**
4. Haz clic en la API key: `AIzaSyBlGvnFjcZ2NMNBgIt4ylNIo5W8TeBtyuI`

### Paso 2: Verificar Restricciones de Aplicación

En la sección **"Application restrictions"**:

1. Debe estar seleccionado: **"Android apps"**
2. Debe haber una entrada con:
   - **Package name:** `com.perikopico.fiestapp`
   - **SHA-1 certificate fingerprint:** `12:FE:47:5B:A4:14:D7:44:D0:C4:F8:C2:C3:68:F2:6A:63:8A:AD:7A`

**Si NO hay ninguna entrada:**
- Haz clic en **"+ Add an item"**
- Añade el package name y SHA-1

**Si HAY una entrada pero es diferente:**
- Elimínala
- Añade una nueva con los valores correctos

### Paso 3: Verificar Restricciones de API

En la sección **"API restrictions"**:

1. Debe estar seleccionado: **"Restrict key"**
2. Debe estar marcada: **"Maps SDK for Android"**

**Si no está marcada:**
- Selecciónala
- Haz clic en **SAVE**

### Paso 4: Esperar Propagación

Después de hacer cambios:
1. Haz clic en **SAVE**
2. Espera 10-15 minutos
3. Reconstruye la app completamente:
   ```bash
   flutter clean
   flutter pub get
   flutter run -d android
   ```

### Paso 5: Alternativa: Sin Restricciones Temporalmente

Si después de todo sigue sin funcionar, prueba temporalmente:

1. En **"Application restrictions"**, selecciona **"None"**
2. Haz clic en **SAVE**
3. Espera 5 minutos
4. Reconstruye la app

**Si funciona sin restricciones**, el problema está en cómo están configuradas las restricciones de Android.

---

## 🎯 Acción Inmediata

**Verifica en Google Cloud Console:**

1. ¿Hay alguna entrada en "Android apps" con el package name y SHA-1?
2. ¿El formato del SHA-1 tiene dos puntos (`:`) o está todo junto?
3. ¿El separador entre SHA-1 y package name es punto y coma (`;`)?

**Comparte:**
- ¿Qué ves exactamente en la sección "Android apps"?
- ¿Hay alguna entrada configurada?
- ¿Cuál es el formato exacto que ves?

