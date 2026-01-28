# ✅ Resumen: Configurar API Key de Android

**Fecha**: Enero 2025  
**Estado**: Android SDK configurado ✅

---

## 🎯 Pasos Finales

### 1. Obtener SHA-1 de Debug

**Ejecuta en tu terminal:**

```bash
keytool -list -v -keystore ~/.android/debug.keystore \
  -alias androiddebugkey \
  -storepass android \
  -keypass android | grep "SHA1:"
```

**Si el keystore no existe aún, compila una vez:**

```bash
flutter build apk --debug
```

**Luego vuelve a ejecutar el comando `keytool`.**

**Salida esperada:**
```
SHA1: 12:FE:47:5B:A4:14:D7:44:D0:C4:F8:C2:C3:68:F2:6A:63:8A:AD:7A
```

**📝 Copia TODO el SHA-1** (con los dos puntos `:`)

---

### 2. Configurar en Google Cloud Console

**1. Ir a Google Cloud Console:**
- https://console.cloud.google.com/
- Selecciona tu proyecto
- **APIs & Services** → **Credentials**

**2. Editar tu API Key de Android:**
- Haz clic en el nombre de la API Key

**3. En "Application restrictions":**
- Selecciona **"Android apps"**
- Haz clic en **"+ Add an item"**

**4. Añadir:**
- **Package name:** `com.perikopico.fiestapp`
- **SHA-1 certificate fingerprint:** Pega el SHA-1 que copiaste
  - Ejemplo: `12:FE:47:5B:A4:14:D7:44:D0:C4:F8:C2:C3:68:F2:6A:63:8A:AD:7A`

**5. En "API restrictions":**
- Selecciona **"Restrict key"**
- Marca solo:
  - ✅ **Maps SDK for Android**
  - ✅ **Places API (New)**
  - ✅ **Geocoding API**

**6. Guardar cambios:**
- Haz clic en **"Save"** en la parte inferior
- Espera 1-2 minutos para que se apliquen los cambios

---

### 3. Verificar que Funciona

**Probar en la app:**
```bash
flutter run
```

**Verificar:**
- ✅ La app inicia correctamente
- ✅ Google Maps carga sin errores
- ✅ No aparece "API key not authorized"

---

## 📋 Resumen de Configuración

### En Google Cloud Console:

```
API Key: [Tu API Key de Android]

Application restrictions:
  └─ Android apps
      └─ Package name: com.perikopico.fiestapp
      └─ SHA-1: [El SHA-1 que obtuviste]

API restrictions:
  └─ Restrict key
      ├─ Maps SDK for Android ✅
      ├─ Places API (New) ✅
      └─ Geocoding API ✅
```

---

## ⚠️ Si Obtienes Errores

### "API key not authorized"
- Verifica que el SHA-1 está correctamente copiado (con los dos puntos)
- Verifica que el package name es exactamente `com.perikopico.fiestapp`
- Espera 1-2 minutos después de guardar (puede tardar en aplicarse)

### "This API key is restricted to a different package"
- Verifica que el package name es exactamente `com.perikopico.fiestapp`
- Sin espacios ni caracteres extra

---

## 🔄 Para Release (Más Adelante)

Cuando estés listo para publicar:

1. **Crear keystore de release:**
   ```bash
   keytool -genkey -v -keystore ~/upload-keystore.jks \
     -keyalg RSA -keysize 2048 -validity 10000 \
     -alias upload
   ```

2. **Obtener SHA-1 de release:**
   ```bash
   keytool -list -v -keystore ~/upload-keystore.jks -alias upload | grep "SHA1:"
   ```

3. **Añadir SHA-1 de release a la misma API Key** (puedes tener múltiples SHA-1)

---

**Última actualización**: Enero 2025
