# 🗺️ Verificar Google Maps

**Fecha**: Enero 2025  
**Tiempo estimado**: 15 minutos

---

## 📋 Checklist de Verificación

### 1. Verificar API Key Configurada

#### Android
**Archivo**: `android/app/src/main/AndroidManifest.xml`

**Verificar**:
- [ ] Existe la etiqueta `<meta-data>` con `com.google.android.geo.API_KEY`
- [ ] El valor de la API Key está configurado
- [ ] No está vacío o con placeholder

**Ejemplo esperado**:
```xml
<meta-data
    android:name="com.google.android.geo.API_KEY"
    android:value="TU_API_KEY_AQUI"/>
```

#### iOS
**Archivo**: `ios/Runner/AppDelegate.swift`

**Verificar**:
- [ ] Existe `GMSServices.provideAPIKey("TU_API_KEY")`
- [ ] El valor de la API Key está configurado
- [ ] No está vacío o con placeholder

**Tiempo**: 5 minutos

---

### 2. Verificar Restricciones de API Key

**Pasos**:
1. Ir a Google Cloud Console: https://console.cloud.google.com/
2. Seleccionar el proyecto
3. Ir a **APIs & Services** > **Credentials**
4. Buscar la API Key de Google Maps
5. Verificar restricciones:
   - [ ] Restricciones de aplicación (Android/iOS) configuradas
   - [ ] Restricciones de API (Maps SDK) configuradas
   - [ ] No está sin restricciones (riesgo de seguridad)

**Resultado esperado**: ✅ API Key con restricciones apropiadas

**Tiempo**: 5 minutos

---

### 3. Probar Funcionalidad de Mapas

#### Test 3.1: Crear Evento con Mapa
**Pasos**:
1. [ ] Abrir la app
2. [ ] Ir a crear evento
3. [ ] Completar información básica
4. [ ] En el paso de ubicación, tocar "Seleccionar en mapa"
5. [ ] Verificar que se abre el mapa
6. [ ] Verificar que el mapa carga correctamente
7. [ ] Tocar en el mapa para seleccionar ubicación
8. [ ] Verificar que aparece un marcador
9. [ ] Arrastrar el marcador (si es posible)
10. [ ] Confirmar la ubicación
11. [ ] Verificar que las coordenadas se guardan

**Resultado esperado**: ✅ Mapa funciona correctamente al crear evento

#### Test 3.2: Ver Mapa en Detalle de Evento
**Pasos**:
1. [ ] Abrir un evento que tenga ubicación
2. [ ] Verificar que hay un botón o sección de mapa
3. [ ] Tocar para ver el mapa
4. [ ] Verificar que el mapa carga
5. [ ] Verificar que muestra el marcador en la ubicación correcta
6. [ ] Verificar que se puede interactuar con el mapa (zoom, pan)

**Resultado esperado**: ✅ Mapa funciona correctamente en detalle

#### Test 3.3: Verificar en Android
**Pasos**:
1. [ ] Compilar y ejecutar en dispositivo Android
2. [ ] Probar crear evento con mapa
3. [ ] Probar ver mapa en detalle
4. [ ] Verificar que no hay errores en consola

**Resultado esperado**: ✅ Funciona en Android

#### Test 3.4: Verificar en iOS
**Pasos**:
1. [ ] Compilar y ejecutar en dispositivo iOS
2. [ ] Probar crear evento con mapa
3. [ ] Probar ver mapa en detalle
4. [ ] Verificar que no hay errores en consola

**Resultado esperado**: ✅ Funciona en iOS

**Tiempo**: 15 minutos

---

## 🐛 Problemas Comunes y Soluciones

### Problema: Mapa no carga / Pantalla en blanco
**Posibles causas**:
1. API Key no configurada
2. API Key incorrecta
3. Restricciones de API Key muy estrictas
4. Permisos de ubicación no concedidos

**Soluciones**:
- Verificar que la API Key está en los archivos de configuración
- Verificar que la API Key es válida en Google Cloud Console
- Verificar restricciones de API Key
- Verificar permisos de ubicación en la app

### Problema: Error "API key not valid"
**Solución**:
- Verificar que la API Key es correcta
- Verificar que está habilitada la API de Maps SDK
- Verificar restricciones de aplicación (package name, SHA-1)

### Problema: Mapa carga pero no muestra nada
**Solución**:
- Verificar que las coordenadas son válidas
- Verificar que el zoom es apropiado
- Verificar que la región del mapa es correcta

### Problema: Mapa funciona en Android pero no en iOS (o viceversa)
**Solución**:
- Verificar configuración específica de cada plataforma
- Verificar que la API Key tiene restricciones para ambas plataformas
- Verificar permisos específicos de cada plataforma

---

## ✅ Resultado Esperado

- ✅ API Key configurada en Android e iOS
- ✅ Restricciones de API Key apropiadas
- ✅ Mapa funciona al crear eventos
- ✅ Mapa funciona en detalle de eventos
- ✅ Funciona en Android
- ✅ Funciona en iOS

---

## 📝 Notas

- Si no tienes acceso a iOS, puedes probar solo Android por ahora
- Los errores de Google Maps suelen aparecer en la consola de Flutter
- Si hay problemas, revisa los logs de la app

---

**Tiempo total**: 15 minutos (más tiempo si hay que corregir problemas)
