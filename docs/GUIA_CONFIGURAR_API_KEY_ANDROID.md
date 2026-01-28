# 🔐 Guía: Configurar API Key de Google Maps para Android

**Fecha**: Enero 2025  
**Objetivo**: Configurar correctamente la API Key de Google Maps para Android con restricciones de SHA-1

---

## 📋 Paso 1: Obtener SHA-1 de Debug

### Opción A: Usando el script (Recomendado)

```bash
./scripts/obtener_sha1_debug.sh
```

### Opción B: Comando directo

```bash
keytool -list -v -keystore ~/.android/debug.keystore \
  -alias androiddebugkey \
  -storepass android \
  -keypass android | grep "SHA1:"
```

### Opción C: Si no tienes el keystore aún

El keystore de debug se crea automáticamente la primera vez que compilas:

```bash
flutter build apk --debug
```

Luego ejecuta el comando de la Opción B.

---

## 📝 Paso 2: Copiar el SHA-1

**Salida esperada:**
```
SHA1: 12:FE:47:5B:A4:14:D7:44:D0:C4:F8:C2:C3:68:F2:6A:63:8A:AD:7A
```

**📋 Copia TODO el SHA-1** (incluyendo los dos puntos `:`)

---

## 🌐 Paso 3: Configurar en Google Cloud Console

### 3.1 Ir a Google Cloud Console

1. Abre: https://console.cloud.google.com/
2. Selecciona tu proyecto
3. Ve a: **APIs & Services** → **Credentials**

### 3.2 Editar tu API Key de Android

1. Busca tu API Key de Google Maps (Android)
2. Haz clic en el nombre de la API Key para editarla

### 3.3 Configurar Restricciones de Aplicación

1. En la sección **"Application restrictions"**
2. Selecciona **"Android apps"**
3. Haz clic en **"+ Add an item"**

### 3.4 Añadir Restricciones

**Rellenar:**
- **Package name:** `com.perikopico.fiestapp`
- **SHA-1 certificate fingerprint:** Pega el SHA-1 que copiaste
  - Ejemplo: `12:FE:47:5B:A4:14:D7:44:D0:C4:F8:C2:C3:68:F2:6A:63:8A:AD:7A`

**⚠️ IMPORTANTE:**
- El SHA-1 debe tener exactamente 20 pares de caracteres
- Separados por dos puntos `:`
- Sin espacios

### 3.5 Configurar Restricciones de API

1. En la sección **"API restrictions"**
2. Selecciona **"Restrict key"**
3. Marca solo las APIs necesarias:
   - ✅ **Maps SDK for Android**
   - ✅ **Places API (New)**
   - ✅ **Geocoding API**

### 3.6 Guardar

1. Haz clic en **"Save"** en la parte inferior
2. Espera unos segundos para que se apliquen los cambios

---

## ✅ Paso 4: Verificar

### 4.1 Probar en la App

```bash
flutter run
```

### 4.2 Verificar que Google Maps funciona

- Abre la app
- Navega a una pantalla con Google Maps
- Verifica que el mapa carga correctamente

### 4.3 Si hay errores

**Error: "API key not authorized"**
- Verifica que el SHA-1 está correctamente copiado
- Verifica que el package name es exactamente `com.perikopico.fiestapp`
- Espera 1-2 minutos después de guardar (puede tardar en aplicarse)

**Error: "This API key is restricted to a different package"**
- Verifica que el package name es exactamente `com.perikopico.fiestapp`
- Sin espacios ni caracteres extra

---

## 📋 Resumen de Configuración

### En Google Cloud Console:

```
API Key: [Tu API Key de Android]

Application restrictions:
  └─ Android apps
      └─ Package name: com.perikopico.fiestapp
      └─ SHA-1: 12:FE:47:5B:A4:14:D7:44:D0:C4:F8:C2:C3:68:F2:6A:63:8A:AD:7A

API restrictions:
  └─ Restrict key
      ├─ Maps SDK for Android ✅
      ├─ Places API (New) ✅
      └─ Geocoding API ✅
```

---

## 🔄 Para Release (Más adelante)

Cuando estés listo para publicar, necesitarás:

1. **Crear keystore de release:**
   ```bash
   keytool -genkey -v -keystore ~/upload-keystore.jks \
     -keyalg RSA -keysize 2048 -validity 10000 \
     -alias upload
   ```

2. **Obtener SHA-1 de release:**
   ```bash
   keytool -list -v -keystore ~/upload-keystore.jks -alias upload
   ```

3. **Añadir SHA-1 de release a la misma API Key** (puedes tener múltiples SHA-1)

---

## 📚 Referencias

- [Google Maps API Key Best Practices](https://developers.google.com/maps/api-security-best-practices)
- [Android App Signing](https://developer.android.com/studio/publish/app-signing)

---

**Última actualización**: Enero 2025
