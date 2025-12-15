# Problemas con Lugares y Google Maps

## Problemas Identificados

### 1. **"Essencia" no aparece en la búsqueda**

**Causa:**
- El lugar está en el script SQL como "Pub Esencia Café y Copas"
- La búsqueda puede no encontrarlo si:
  - El script SQL no se ejecutó en Supabase
  - El lugar está pendiente de aprobación (`status='pending'`) y la búsqueda solo muestra lugares aprobados
  - La búsqueda no es lo suficientemente flexible

**Solución implementada:**
- ✅ Mejorada la búsqueda para normalizar texto (eliminar acentos, convertir a minúsculas)
- ✅ Añadidos logs de depuración para ver qué lugares se encuentran
- ✅ La búsqueda ahora es más flexible y encuentra "essencia" aunque el nombre completo sea "Pub Esencia Café y Copas"

**Verificación:**
1. Ejecutar el script SQL en Supabase: `scripts/populate_barbate_venues.sql`
2. Verificar que el lugar esté con `status='approved'`
3. Buscar "essencia" en la app - debería aparecer

---

### 2. **Coordenadas incorrectas en lugares existentes**

**Causa:**
- El script SQL tiene coordenadas aproximadas (36.193x, -5.922x) que no son reales de Google Maps
- Muchos lugares tienen la misma dirección ("Calle Trafalgar") pero coordenadas muy similares
- Las coordenadas del script son estimaciones, no coordenadas reales de Google Maps

**Problema identificado:**
- "Bar Habana" tiene coordenadas (36.1932, -5.9222) que pueden no ser correctas
- Otros lugares también tienen coordenadas aproximadas

**Solución:**
- ✅ Añadidos logs para ver qué coordenadas se están usando cuando se selecciona un lugar
- ✅ Cuando se crea un lugar nuevo desde Google Places, se obtienen coordenadas reales
- ⚠️ **Pendiente**: Actualizar coordenadas de lugares existentes desde Google Places

**Cómo verificar coordenadas:**
1. Seleccionar un lugar en la app
2. Revisar los logs en la consola:
   ```
   📍 Coordenadas del lugar "Bar Habana": Lat: 36.1932, Lng: -5.9222
      Dirección: Calle Trafalgar, 11160 Barbate, Cádiz
   ```
3. Comparar con Google Maps para verificar si son correctas

---

### 3. **Lugares pendientes de aprobación no aparecen**

**Causa:**
- La búsqueda solo muestra lugares con `status='approved'`
- Si un lugar está pendiente (`status='pending'`), no aparece en la búsqueda

**Solución:**
- ⚠️ **Pendiente**: Añadir opción para que admins vean lugares pendientes
- ⚠️ **Pendiente**: Permitir que usuarios vean sus propios lugares pendientes

**Verificación:**
1. Crear un lugar nuevo desde la app
2. El lugar se crea con `status='pending'`
3. No aparecerá en búsquedas hasta que un admin lo apruebe

---

## Mejoras Implementadas

### 1. Búsqueda mejorada
- ✅ Normalización de texto (sin acentos, minúsculas)
- ✅ Logs de depuración para ver qué se encuentra
- ✅ Búsqueda más flexible

### 2. Logs de coordenadas
- ✅ Logs cuando se selecciona un lugar con coordenadas
- ✅ Logs cuando un lugar no tiene coordenadas
- ✅ Muestra dirección y coordenadas en los logs

### 3. Feedback visual
- ✅ Mensaje cuando se selecciona un lugar con coordenadas
- ✅ Mensaje cuando se crea un lugar nuevo

---

## Próximos Pasos Recomendados

### 1. Actualizar coordenadas de lugares existentes
```sql
-- Ejemplo: Actualizar coordenadas de "Bar Habana" desde Google Maps
UPDATE venues 
SET lat = 36.XXXX, lng = -5.XXXX  -- Coordenadas reales de Google Maps
WHERE name = 'Bar Habana' AND city_id = 1;
```

### 2. Verificar lugares en Supabase
```sql
-- Ver todos los lugares de Barbate con sus coordenadas
SELECT id, name, address, lat, lng, status 
FROM venues 
WHERE city_id = 1 
ORDER BY name;
```

### 3. Aprobar lugares pendientes
```sql
-- Aprobar lugares pendientes (si son correctos)
UPDATE venues 
SET status = 'approved' 
WHERE city_id = 1 AND status = 'pending';
```

---

## Cómo Probar

1. **Buscar "essencia":**
   - Abrir la app
   - Ir a crear evento
   - Seleccionar ciudad "Barbate"
   - Buscar "essencia"
   - Debería aparecer "Pub Esencia Café y Copas"

2. **Verificar coordenadas:**
   - Seleccionar "Bar Habana"
   - Revisar logs en la consola
   - Verificar en el mapa si la ubicación es correcta
   - Comparar con Google Maps

3. **Crear lugar nuevo:**
   - Buscar un lugar que no exista
   - Crearlo desde Google Places
   - Verificar que las coordenadas sean correctas

---

## Notas Importantes

- **Coordenadas del script SQL**: Son aproximadas, no reales de Google Maps
- **Lugares pendientes**: No aparecen en búsquedas hasta ser aprobados
- **Búsqueda flexible**: Ahora encuentra lugares aunque el nombre no coincida exactamente
- **Logs**: Revisar la consola para ver qué coordenadas se están usando

