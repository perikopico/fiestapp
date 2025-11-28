# 🔧 Solución: Error al Cargar el Mapa

## Problema Actual

La app muestra el error "Error al cargar el mapa" porque:
1. La app necesita ser reconstruida con la nueva API key
2. La nueva API key necesita tener las restricciones correctas en Google Cloud Console

## ✅ Pasos para Solucionarlo

### Paso 1: Verificar que la API Key está actualizada

Ya está actualizada en `AndroidManifest.xml`:
- ✅ Nueva API key: `AIzaSyB3QZYmsSb1GmIewWnDS-KewupE3Ths_dY`

### Paso 2: Verificar en Google Cloud Console

**IMPORTANTE:** La nueva API key debe tener las mismas restricciones que la anterior.

1. Ve a [Google Cloud Console](https://console.cloud.google.com/)
2. Selecciona tu proyecto
3. Ve a **APIs & Services > Credentials**
4. Busca la API key: `AIzaSyB3QZYmsSb1GmIewWnDS-KewupE3Ths_dY`
5. Haz clic en ella para editarla

**Verifica:**

#### A) Restricciones de API
- ✅ "Restrict key" debe estar seleccionado
- ✅ "Maps SDK for Android" debe estar marcada

#### B) Restricciones de Aplicación
- ✅ "Android apps" debe estar seleccionado
- ✅ Debe haber una entrada con:
  - **Package name:** `com.perikopico.fiestapp`
  - **SHA-1:** `12:FE:47:5B:A4:14:D7:44:D0:C4:F8:C2:C3:68:F2:6A:63:8A:AD:7A`

**Si NO hay entrada en "Android apps":**
1. Haz clic en **"+ Add an item"** o **"+ ADD AN ITEM"**
2. Añade:
   - Package name: `com.perikopico.fiestapp`
   - SHA-1: `12:FE:47:5B:A4:14:D7:44:D0:C4:F8:C2:C3:68:F2:6A:63:8A:AD:7A`
3. Haz clic en **SAVE**

### Paso 3: Reconstruir la App Completamente

Después de verificar/actualizar las restricciones en Google Cloud Console:

```bash
# Detén la app si está corriendo (Ctrl+C)

# Limpia el proyecto
flutter clean

# Obtén las dependencias
flutter pub get

# Reconstruye y ejecuta
flutter run -d android
```

**IMPORTANTE:** Usa `flutter clean` para asegurarte de que se reconstruya todo con la nueva API key.

### Paso 4: Esperar Propagación

Si acabas de hacer cambios en Google Cloud Console:
- Espera 5-10 minutos después de guardar
- Luego reconstruye la app

## 🔍 Verificación Rápida

**En Google Cloud Console, verifica que la API key `AIzaSyB3QZYmsSb1GmIewWnDS-KewupE3Ths_dY` tenga:**

1. ✅ "Maps SDK for Android" habilitada
2. ✅ Restricción de Android con:
   - Package: `com.perikopico.fiestapp`
   - SHA-1: `12:FE:47:5B:A4:14:D7:44:D0:C4:F8:C2:C3:68:F2:6A:63:8A:AD:7A`

## ❓ Si sigue sin funcionar

1. **Verifica que la API key esté activa** (no deshabilitada)
2. **Revisa los logs** después de reconstruir:
   ```bash
   flutter run -d android
   ```
   Busca errores de "Authorization failure" o "API key"

3. **Prueba temporalmente sin restricciones** (solo para diagnóstico):
   - En Google Cloud Console, en "Application restrictions", selecciona "None"
   - Guarda y espera 5 minutos
   - Reconstruye la app
   - Si funciona, el problema está en las restricciones de Android

## 📝 Resumen

1. ✅ API key actualizada en AndroidManifest.xml
2. ⏳ Verificar restricciones en Google Cloud Console
3. ⏳ Reconstruir la app con `flutter clean`
4. ⏳ Esperar propagación (5-10 min si hiciste cambios)

