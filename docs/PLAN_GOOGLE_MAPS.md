# 🗺️ Plan de Acción: Verificar y Reparar Google Maps

**Objetivo**: Diagnosticar y solucionar cualquier problema con Google Maps en la app.

---

## 🎯 Qué vamos a hacer

### **FASE 1: DIAGNÓSTICO** (Ahora)

1. ✅ Obtener SHA-1 actual de la app
2. ✅ Verificar API Key en AndroidManifest.xml
3. ✅ Verificar configuración en Google Cloud Console
4. ✅ Probar la app y ver qué ocurre

### **FASE 2: REPARACIÓN** (Después del diagnóstico)

5. 🔧 Solucionar problemas encontrados
6. ✅ Mejorar manejo de errores
7. ✅ Optimizar experiencia de usuario

---

## 📋 Información Actual

### **Configuración encontrada:**
- **Package Name**: `com.perikopico.fiestapp`
- **API Key en AndroidManifest**: `AIzaSyB3QZYmsSb1GmIewWnDS-KewupE3Ths_dY`
- **SHA-1 mencionado en docs**: `12:FE:47:5B:A4:14:D7:44:D0:C4:F8:C2:C3:68:F2:6A:63:8A:AD:7A`

### **Pantallas que usan Google Maps:**
1. **Crear Evento** (`event_submit_screen.dart`) - Seleccionar ubicación
2. **Editar Evento** (`admin_event_edit_screen.dart`) - Ajustar ubicación  
3. **Detalle de Evento** (`event_detail_screen.dart`) - Ver mapa estático

---

## 🚀 PASO 1: Obtener SHA-1

**Opción A: Usar el script (recomendado)**
```bash
cd /home/perikopico/StudioProjects/fiestapp
./scripts/obtener_sha1.sh
```

**Opción B: Manualmente**
```bash
cd android
./gradlew signingReport
```

**Busca en la salida:**
```
Variant: debug
Config: debug
Store: ~/.android/debug.keystore
Alias: AndroidDebugKey
SHA1: XX:XX:XX:XX:XX:XX:XX:XX:XX:XX:XX:XX:XX:XX:XX:XX:XX:XX:XX:XX
```

**📝 Anota el SHA-1 aquí:**
```
SHA-1 Debug: ____________________________
```

---

## 🔍 PASO 2: Verificar en Google Cloud Console

**Ve a:** https://console.cloud.google.com/

### A) Verificar API Key

1. Ve a **APIs & Services > Credentials**
2. Busca: `AIzaSyB3QZYmsSb1GmIewWnDS-KewupE3Ths_dY`
3. [ ] ¿Existe? ✅ / ❌
4. [ ] ¿Está habilitada? ✅ / ❌

### B) Verificar APIs habilitadas

1. Ve a **APIs & Services > Enabled APIs**
2. Busca y verifica:
   - [ ] **Maps SDK for Android** - ✅ / ❌
   - [ ] **Maps SDK for iOS** - ✅ / ❌ (opcional)

**Si "Maps SDK for Android" NO está habilitada:**
- Haz clic en **+ ENABLE APIS AND SERVICES**
- Busca "Maps SDK for Android"
- Haz clic en **ENABLE**

### C) Verificar restricciones

En la página de detalles de tu API key:

**Application restrictions:**
- [ ] ¿Tiene restricciones de Android? Sí / No
- Si SÍ, verifica:
  - [ ] Package: `com.perikopico.fiestapp` ✅ / ❌
  - [ ] SHA-1 del PASO 1 coincide ✅ / ❌

**API restrictions:**
- [ ] ¿Está restringida a APIs específicas? Sí / No
- Si SÍ, debe incluir "Maps SDK for Android"

---

## 🧪 PASO 3: Probar la app

```bash
flutter clean
flutter pub get
flutter run -d android
```

### Pruebas:

**A) Crear evento con mapa:**
1. Ir a crear evento
2. Llegar a la pantalla de seleccionar ubicación
3. [ ] ¿Se muestra el mapa? ✅ / ❌
4. [ ] ¿Aparece error? Sí / No
5. **Si hay error, copia el mensaje aquí:**

**B) Ver detalle de evento:**
1. Ver un evento que tenga ubicación
2. [ ] ¿Se muestra el mapa? ✅ / ❌
3. [ ] ¿Aparece error? Sí / No

**C) Revisar logs:**
- Busca: `✅ Mapa creado correctamente` ✅ / ❌
- Busca errores que contengan "Google Maps"
- **Copia cualquier error aquí:**

---

## 🛠️ Problemas Comunes y Soluciones

### ❌ Problema 1: Mapa en blanco

**Posibles causas:**
- API key no válida
- Maps SDK no habilitada
- SHA-1 no coincide

**Solución:**
1. Verifica PASO 2 completo
2. Espera 5-10 minutos después de cambiar configuraciones
3. Reconstruye la app: `flutter clean && flutter run`

### ❌ Problema 2: Error "API key not authorized"

**Solución:**
1. Habilita "Maps SDK for Android" en Google Cloud Console
2. Verifica package name: `com.perikopico.fiestapp`
3. Añade SHA-1 correcto en restricciones

### ❌ Problema 3: Error "Google Play Services not available"

**Solución:**
- Prueba en dispositivo físico (no emulador)
- Actualiza Google Play Services en el dispositivo

---

## 📝 Checklist Final

Antes de continuar, verifica:

- [ ] SHA-1 obtenido del PASO 1
- [ ] API Key existe en Google Cloud Console
- [ ] "Maps SDK for Android" está habilitada
- [ ] SHA-1 coincide en restricciones (si hay)
- [ ] App probada y resultados anotados
- [ ] Errores (si hay) documentados

---

## 🎯 Siguiente Paso

**Ejecuta el PASO 1 ahora:**
```bash
cd /home/perikopico/StudioProjects/fiestapp
./scripts/obtener_sha1.sh
```

O manualmente:
```bash
cd android && ./gradlew signingReport
```

**Comparte los resultados y continuamos con la reparación** 🚀

