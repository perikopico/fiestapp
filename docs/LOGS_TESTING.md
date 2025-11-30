# 📋 Qué Buscar en los Logs Durante el Testing

Cuando ejecutes la app, estos son los logs importantes a observar:

## 🔍 Logs de Google Places API

### ✅ Si funciona correctamente:
```
🔍 Buscando lugares: "embarcadero" en Barbate
📊 Resultados en BD: 0
🌐 Buscando en Google Places...
🌐 Llamando a Places API (New): https://places.googleapis.com/...
📡 Respuesta Places API: 200
✅ Google Places: 3 resultados encontrados
📊 Resultados en Google Places: 3
✅ Búsqueda completada. Sugerencias: 3
```

### ❌ Si hay problemas:
```
❌ Error HTTP en Places API (New): 403
   Respuesta: { "error": { "message": "API key not valid" } }
```
**Solución**: Verificar API key en Google Cloud Console

```
❌ Error HTTP en Places API (New): 400
   Respuesta: { "error": { "message": "This API project is not authorized to use this API" } }
```
**Solución**: Habilitar "Places API (New)" en Google Cloud Console

---

## 🔍 Logs de Creación de Eventos

### ✅ Si funciona correctamente:
```
✅ Lugar creado: El Campero (status: pending)
✅ Evento creado con status: pending
```

### ❌ Si hay problemas:
```
❌ Error al crear lugar: ...
❌ Error al crear evento: ...
```

---

## 🔍 Logs de Validación de Duplicados

### ✅ Si encuentra duplicados:
```
🔍 Verificando lugares similares para: El Campero
🔍 Verificando eventos similares para: Feria de Barbate
```

---

## 🔍 Logs de Google Maps

### ✅ Si funciona correctamente:
```
✅ Mapa creado correctamente
```

### ❌ Si hay problemas:
```
❌ Error al cargar mapa: ...
E/Google Android Maps SDK: API key not valid
```

---

## 📱 Qué Probar en el Móvil

### 1. Crear Evento
- Abre la app
- Ve a "Crear evento"
- Completa el formulario
- **Observa los logs** cuando:
  - Escribes en el campo "Lugar"
  - Haces clic en "Crear evento"

### 2. Búsqueda de Lugares
- En "Crear evento", escribe en "Lugar": "embarcadero"
- **Observa los logs** para ver:
  - Si busca en la BD
  - Si busca en Google Places
  - Si encuentra resultados

### 3. Mapa
- Abre el selector de mapa
- **Observa los logs** para ver:
  - Si carga correctamente
  - Si hay errores de API key

---

## 🐛 Errores Comunes y Soluciones

### Error: "API key not valid"
- **Causa**: API key incorrecta o no configurada
- **Solución**: Verificar `.env` y `android/local.properties`

### Error: "This API project is not authorized"
- **Causa**: Places API no habilitada
- **Solución**: Habilitar "Places API (New)" en Google Cloud Console

### Error: "No se encontraron lugares"
- **Causa**: API funcionando pero no hay resultados
- **Solución**: Normal, simplemente no hay lugares que coincidan

### Error: "Mapa no interactivo"
- **Causa**: API key de Maps SDK no válida
- **Solución**: Verificar API key en `AndroidManifest.xml`

---

## 📝 Notas Durante el Testing

Anota aquí cualquier problema que encuentres:

### Problema 1:
- **Descripción**: 
- **Logs relacionados**: 
- **Pasos para reproducir**: 

### Problema 2:
- **Descripción**: 
- **Logs relacionados**: 
- **Pasos para reproducir**: 

---

**Fecha de testing**: [Completar]  
**Dispositivo**: [Completar]  
**Versión de app**: [Completar]

