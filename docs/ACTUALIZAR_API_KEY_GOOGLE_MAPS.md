# ✅ API Key de Google Maps Actualizada

## Cambio Realizado

He actualizado la API key en `android/app/src/main/AndroidManifest.xml`:

**Antigua:** `AIzaSyBlGvnFjcZ2NMNBgIt4ylNIo5W8TeBtyuI`  
**Nueva:** `AIzaSyB3QZYmsSb1GmIewWnDS-KewupE3Ths_dY` ✅

## ⚠️ IMPORTANTE: Verificar en Google Cloud Console

Ahora necesitas verificar que esta nueva API key tenga las restricciones correctas:

### 1. Ve a Google Cloud Console

1. Ve a [Google Cloud Console](https://console.cloud.google.com/)
2. Selecciona tu proyecto
3. Ve a **APIs & Services > Credentials**
4. Busca la API key: `AIzaSyB3QZYmsSb1GmIewWnDS-KewupE3Ths_dY`
5. Haz clic en ella para editarla

### 2. Verificar Restricciones de API

En **"API restrictions"**:
- ✅ Debe estar seleccionado: **"Restrict key"**
- ✅ Debe estar marcada: **"Maps SDK for Android"**

### 3. Verificar Restricciones de Aplicación

En **"Application restrictions"**:
- ✅ Debe estar seleccionado: **"Android apps"**
- ✅ Debe haber una entrada con:
  - **Package name:** `com.perikopico.fiestapp`
  - **SHA-1:** `12:FE:47:5B:A4:14:D7:44:D0:C4:F8:C2:C3:68:F2:6A:63:8A:AD:7A`

**Si NO hay entrada:**
1. Haz clic en **"+ Add an item"** o **"+ ADD AN ITEM"**
2. Añade:
   - Package name: `com.perikopico.fiestapp`
   - SHA-1: `12:FE:47:5B:A4:14:D7:44:D0:C4:F8:C2:C3:68:F2:6A:63:8A:AD:7A`
3. Haz clic en **SAVE**

### 4. Guardar y Esperar

1. Haz clic en **SAVE**
2. Espera 5-10 minutos para que se propague
3. Reconstruye la app:
   ```bash
   flutter clean
   flutter pub get
   flutter run -d android
   ```

## 🧪 Probar

Después de verificar las restricciones y esperar:

1. Reconstruye la app completamente
2. Ve a una pantalla con mapa (crear evento o ver detalles)
3. El mapa debería cargarse correctamente

## ❓ Si aún no funciona

Si después de verificar todo sigue sin funcionar:

1. **Revisa los logs** - busca errores de "Authorization failure"
2. **Verifica que la API key esté activa** en Google Cloud Console
3. **Prueba temporalmente sin restricciones** (solo para diagnóstico):
   - En "Application restrictions", selecciona "None"
   - Guarda y espera 5 minutos
   - Prueba la app
   - Si funciona, el problema está en las restricciones

