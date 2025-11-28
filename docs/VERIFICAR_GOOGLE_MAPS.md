# 🗺️ Verificar y Reparar Google Maps - Plan de Acción

**Fecha**: Diciembre 2024

---

## 📋 Situación Actual

### ✅ Lo que sabemos:

1. **Dónde se usa Google Maps:**
   - `lib/ui/events/event_submit_screen.dart` - Crear eventos (seleccionar ubicación)
   - `lib/ui/admin/admin_event_edit_screen.dart` - Editar eventos (ajustar ubicación)
   - `lib/ui/event/event_detail_screen.dart` - Ver detalles de evento (mapa estático)

2. **Configuración actual:**
   - Package: `com.perikopico.fiestapp`
   - API Key en AndroidManifest.xml: `AIzaSyB3QZYmsSb1GmIewWnDS-KewupE3Ths_dY`
   - SHA-1 mencionado en docs: `12:FE:47:5B:A4:14:D7:44:D0:C4:F8:C2:C3:68:F2:6A:63:8A:AD:7A`

3. **Plugin instalado:**
   - `google_maps_flutter: ^2.9.0` ✅

---

## 🔍 Plan de Diagnóstico (Paso a Paso)

### **PASO 1: Obtener el SHA-1 actual de la app**

**Ejecuta:**
```bash
cd android
./gradlew signingReport
```

**O si usas Windows:**
```bash
cd android
gradlew.bat signingReport
```

**Busca en la salida:**
```
Variant: debug
SHA1: XX:XX:XX:XX:XX:XX:...
```

**📝 Anota el SHA-1 que obtengas aquí:**
```
SHA-1 Debug: ____________________________
```

---

### **PASO 2: Verificar API Key en AndroidManifest.xml**

**Archivo:** `android/app/src/main/AndroidManifest.xml`

**API Key actual:**
- `AIzaSyB3QZYmsSb1GmIewWnDS-KewupE3Ths_dY`

**Verifica:**
- [ ] La API key está dentro de `<application>...</application>`
- [ ] El nombre es exacto: `com.google.android.geo.API_KEY`
- [ ] No tiene espacios extra

---

### **PASO 3: Verificar en Google Cloud Console**

**Ve a:** https://console.cloud.google.com/

#### A) Verificar que la API Key existe

1. Ve a **APIs & Services > Credentials**
2. Busca la API key: `AIzaSyB3QZYmsSb1GmIewWnDS-KewupE3Ths_dY`
3. [ ] ¿Existe? ✅ / ❌
4. [ ] ¿Está habilitada? ✅ / ❌

#### B) Verificar APIs habilitadas

1. Ve a **APIs & Services > Enabled APIs**
2. Busca y verifica:
   - [ ] **Maps SDK for Android** - ✅ Habilitada / ❌ No habilitada
   - [ ] **Maps SDK for iOS** - ✅ Habilitada / ❌ No habilitada (opcional)
   - [ ] **Places API** - ✅ Habilitada / ❌ No habilitada (opcional)

**Si no está habilitada "Maps SDK for Android":**
- Haz clic en **+ ENABLE APIS AND SERVICES**
- Busca "Maps SDK for Android"
- Haz clic en **ENABLE**

#### C) Verificar restricciones de la API Key

En la página de detalles de tu API key:

**Application restrictions:**
- [ ] ¿Hay restricciones? Sí / No
- Si sí, verifica:
  - [ ] Package name: `com.perikopico.fiestapp` ✅ / ❌
  - [ ] SHA-1 coincide con el del PASO 1 ✅ / ❌

**API restrictions:**
- [ ] ¿Está restringida? Sí / No
- Si sí, verifica:
  - [ ] Incluye "Maps SDK for Android" ✅ / ❌

---

### **PASO 4: Probar la app**

**Ejecuta:**
```bash
flutter clean
flutter pub get
flutter run -d android
```

**Acciones a probar:**
1. Crear un evento → Ir a seleccionar ubicación en mapa
   - [ ] ¿Se muestra el mapa? ✅ / ❌
   - [ ] ¿Aparece error? Sí / No
   - [ ] ¿Qué error ves? _______________________

2. Ver detalle de evento que tenga ubicación
   - [ ] ¿Se muestra el mapa? ✅ / ❌
   - [ ] ¿Aparece error? Sí / No

3. Editar evento (como admin) → Ir a ubicación en mapa
   - [ ] ¿Se muestra el mapa? ✅ / ❌
   - [ ] ¿Aparece error? Sí / No

**Logs a revisar:**
- Busca en los logs: `flutter logs` o en la consola
- [ ] ¿Aparece "✅ Mapa creado correctamente"? ✅ / ❌
- [ ] ¿Aparecen errores de Google Maps? Sí / No
- [ ] Copia cualquier error aquí: _______________________

---

### **PASO 5: Diagnosticar problemas comunes**

#### Problema A: Mapa en blanco / no se renderiza

**Causas posibles:**
- API key no válida
- API no habilitada
- SHA-1 no coincide
- Restricciones muy estrictas

**Solución:**
1. Verifica PASO 3 completo
2. Prueba con API key sin restricciones temporalmente
3. Espera 5-10 minutos después de cambiar configuraciones

#### Problema B: Error "API key not authorized"

**Causas posibles:**
- Maps SDK for Android no habilitada
- Restricciones incorrectas
- Package name incorrecto

**Solución:**
1. Habilita "Maps SDK for Android" en Google Cloud Console
2. Verifica package name: `com.perikopico.fiestapp`
3. Verifica SHA-1

#### Problema C: Error "Google Play Services not available"

**Causas posibles:**
- Emulador sin Google Play Services
- Dispositivo sin Google Play Services actualizado

**Solución:**
- Prueba en dispositivo físico
- Actualiza Google Play Services
- Usa emulador con Google Play Services

---

## 🛠️ Herramientas de Verificación

### Script para obtener SHA-1 automáticamente

Crearemos un script que obtenga el SHA-1 fácilmente.

### Verificar configuración completa

Podemos crear una función en la app que verifique la configuración al iniciar.

---

## 📝 Resultados del Diagnóstico

**Rellena según lo que encuentres:**

- **SHA-1 obtenido:** _______________________
- **API Key en manifest:** `AIzaSyB3QZYmsSb1GmIewWnDS-KewupE3Ths_dY`
- **API Key existe en Google Cloud:** ✅ / ❌
- **Maps SDK for Android habilitada:** ✅ / ❌
- **Restricciones configuradas:** Sí / No
- **Mapa funciona:** ✅ / ❌
- **Errores encontrados:** _______________________

---

## 🎯 Próximos Pasos

1. **Ejecutar PASO 1** - Obtener SHA-1
2. **Ejecutar PASO 2 y 3** - Verificar configuración
3. **Ejecutar PASO 4** - Probar en la app
4. **Compartir resultados** - Para ayudar a diagnosticar

---

**¿Listo para empezar?** 🚀

Ejecuta el PASO 1 primero y comparte los resultados.
