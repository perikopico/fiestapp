# ✅ Checklist Antes de Probar en Android

## 🔧 Configuración Requerida

### 1. API Key en `android/local.properties`

**Archivo:** `android/local.properties`

**Debe contener:**
```properties
GOOGLE_MAPS_API_KEY=TU_API_KEY_AQUI
```

**Verificar:**
```bash
cd android
cat local.properties | grep GOOGLE_MAPS_API_KEY
```

**Si no existe el archivo:**
```bash
cd android
cp local.properties.example local.properties
# Luego edita local.properties y añade tu API key
```

### 2. API Key en `.env` (raíz del proyecto)

**Archivo:** `.env` (en la raíz del proyecto, no en android/)

**Debe contener:**
```
GOOGLE_MAPS_API_KEY=TU_API_KEY_AQUI
```

**Verificar:**
```bash
cat .env | grep GOOGLE_MAPS_API_KEY
```

**Si no existe el archivo:**
```bash
# Crea el archivo .env en la raíz del proyecto
echo "GOOGLE_MAPS_API_KEY=TU_API_KEY_AQUI" > .env
```

### 3. Limpiar y Reconstruir

**Antes de probar, ejecuta:**
```bash
flutter clean
flutter pub get
cd android
./gradlew clean
cd ..
```

## 🚨 Problemas Comunes

### Error: "API key not found" o mapa en blanco

**Causa:** La API key no está configurada o está vacía

**Solución:**
1. Verifica que `android/local.properties` tiene `GOOGLE_MAPS_API_KEY=...`
2. Verifica que `.env` tiene `GOOGLE_MAPS_API_KEY=...`
3. Ejecuta `flutter clean` y vuelve a compilar

### Error: "Manifest merger failed"

**Causa:** Problema con manifestPlaceholders

**Solución:**
1. Verifica que `build.gradle.kts` está correcto
2. Verifica que `AndroidManifest.xml` usa `${GOOGLE_MAPS_API_KEY}`
3. Ejecuta `cd android && ./gradlew clean`

### Error: "GOOGLE_MAPS_API_KEY no encontrada en .env"

**Causa:** El archivo `.env` no existe o no tiene la key

**Solución:**
1. Crea/edita `.env` en la raíz del proyecto
2. Añade `GOOGLE_MAPS_API_KEY=TU_API_KEY_AQUI`
3. Reinicia la app

## ✅ Verificación Final

Antes de ejecutar `flutter run`, verifica:

- [ ] `android/local.properties` existe y tiene `GOOGLE_MAPS_API_KEY`
- [ ] `.env` existe (en la raíz) y tiene `GOOGLE_MAPS_API_KEY`
- [ ] Ejecutaste `flutter clean`
- [ ] Ejecutaste `flutter pub get`
- [ ] La API key es válida y tiene las APIs habilitadas en Google Cloud Console

## 🧪 Probar

```bash
flutter run
```

**Qué probar:**
1. ✅ La app inicia sin errores
2. ✅ Crear un evento → Seleccionar lugar → Abrir mapa
3. ✅ Ver detalle de evento con mapa
4. ✅ Buscar lugares en Google Places

---

**Nota:** Si usas una API key nueva (rotada), asegúrate de que tiene:
- Restricciones de aplicación (package name + SHA-1)
- APIs habilitadas (Maps SDK for Android, Places API, Geocoding API)

