# 🔧 Solución: API Key Bloqueada para Android

## ❌ Error Actual

```
API_KEY_ANDROID_APP_BLOCKED
"androidPackage": "<empty>"
"Requests from this Android client application <empty> are blocked."
```

## 🔍 Causa

La API key de Google Maps no tiene configurado el **package name** y **SHA-1** de tu aplicación Android. Google está bloqueando las peticiones porque no puede verificar que la app es legítima.

## ✅ Solución

### Paso 1: Obtener SHA-1 de tu aplicación

```bash
cd android
./gradlew signingReport
```

Busca la línea que dice:
```
Variant: debug
Config: debug
Store: ~/.android/debug.keystore
Alias: AndroidDebugKey
SHA1: 12:FE:47:5B:A4:14:D7:44:D0:C4:F8:C2:C3:68:F2:6A:63:8A:AD:7A
```

### Paso 2: Configurar API Key en Google Cloud Console

1. Ve a [Google Cloud Console](https://console.cloud.google.com/)
2. Selecciona tu proyecto
3. Ve a **APIs & Services** > **Credentials**
4. Haz clic en tu API key: `AIzaSyDCE_o8jBruKq0__AJRL7SA8ztMCJrsK04`
5. En **Application restrictions**, selecciona **Android apps**
6. Haz clic en **Add an item** y añade:
   - **Package name**: `com.perikopico.fiestapp`
   - **SHA-1 certificate fingerprint**: `12:FE:47:5B:A4:14:D7:44:D0:C4:F8:C2:C3:68:F2:6A:63:8A:AD:7A`
7. En **API restrictions**, asegúrate de tener habilitadas:
   - ✅ Maps SDK for Android
   - ✅ Places API (New) o Places API
   - ✅ Geocoding API
8. Guarda los cambios

### Paso 3: Esperar y Probar

- Espera 5-10 minutos para que los cambios se propaguen
- Reinicia la app
- Prueba buscar un lugar de nuevo

## ⚠️ Nota Importante

Mientras tanto, **puedes crear lugares manualmente**:
- Escribe el nombre del lugar
- Si no aparecen sugerencias, debería aparecer la opción "Crear nuevo lugar: [nombre]"
- Haz clic en esa opción para crear el lugar
- El lugar se creará con `status='pending'` y podrás marcar la ubicación en el mapa

## 🔍 Verificar que Funciona

Después de configurar, deberías ver en los logs:
```
✅ Google Places: X resultados encontrados
```

En lugar de:
```
❌ Error HTTP en Places API (New): 403
```

---

**Última actualización**: Diciembre 2024

