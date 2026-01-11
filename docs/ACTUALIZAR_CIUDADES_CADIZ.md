# Actualizar Ciudades de la Provincia de Cádiz

Este documento explica cómo actualizar la base de datos con todas las ciudades de la provincia de Cádiz, incluyendo sus límites geográficos.

## Resumen

Esta actualización:
1. Crea/verifica la tabla `provinces` si no existe
2. Inserta Cádiz como provincia
3. Actualiza la tabla `cities` con campos necesarios:
   - `province_id`: ID de la provincia (Cádiz)
   - `region`: Región a la que pertenece la ciudad (LA JANDA, BAHÍA DE CÁDIZ, etc.)
   - `lat`, `lng`: Coordenadas centrales de la ciudad
   - `lat_min`, `lat_max`, `lng_min`, `lng_max`: Límites geográficos para restringir el mapa
4. Inserta/actualiza todas las 56 ciudades/pedanías de Cádiz

## Ciudades incluidas

### LA JANDA (8 ciudades)
- Barbate
- Zahara de los Atunes
- Vejer de la Frontera
- Conil de la Frontera
- Medina Sidonia
- Benalup-Casas Viejas
- Alcalá de los Gazules
- Paterna de Rivera

### BAHÍA DE CÁDIZ (15 ciudades/pedanías)
- Cádiz
- Jerez de la Frontera
- La Barca de la Florida (Jerez)
- Estella del Marqués (Jerez)
- Guadalcacín (Jerez)
- El Torno (Jerez)
- Nueva Jarilla (Jerez)
- San Isidro del Guadalete (Jerez)
- Torrecera (Jerez)
- San Fernando
- El Puerto de Santa María
- Chiclana de la Frontera
- Puerto Real

### COSTA NOROESTE (4 ciudades)
- Sanlúcar de Barrameda
- Chipiona
- Rota
- Trebujena

### SIERRA DE CÁDIZ (19 ciudades)
- Arcos de la Frontera
- Ubrique
- Olvera
- Villamartín
- Bornos
- Prado del Rey
- Algodonales
- Puerto Serrano
- Alcalá del Valle
- San José del Valle
- Espera
- El Bosque
- Grazalema
- Setenil de las Bodegas
- Benaocaz
- Villaluenga del Rosario
- El Gastor
- Zahara de la Sierra
- Algar
- Torre Alháquime

### CAMPO DE GIBRALTAR (10 ciudades/pedanías)
- Algeciras
- La Línea de la Concepción
- San Roque
- Los Barrios
- Tarifa
- Facinas (Tarifa)
- Tahivilla (Tarifa)
- Jimena de la Frontera
- San Pablo de Buceite (Jimena)
- Castellar de la Frontera
- San Martín del Tesorillo

**Total: 56 ciudades/pedanías**

## Instrucciones de aplicación

### Paso 1: Ejecutar la migración SQL

1. Abre el **Supabase Dashboard**
2. Ve a **SQL Editor**
3. Abre el archivo `docs/migrations/015_update_cities_cadiz_complete.sql`
4. Copia todo el contenido del archivo
5. Pega el contenido en el SQL Editor de Supabase
6. Haz clic en **Run** para ejecutar la migración

### Paso 2: Verificar la migración

Después de ejecutar la migración, deberías ver:
- ✅ Todas las ciudades insertadas/actualizadas correctamente
- ✅ Resultados de la consulta de verificación mostrando las ciudades por región

Ejecuta esta consulta para verificar:

```sql
SELECT 
  region,
  COUNT(*) as cantidad_ciudades
FROM public.cities
WHERE province_id = (SELECT id FROM public.provinces WHERE slug = 'cadiz')
GROUP BY region
ORDER BY region;
```

Deberías ver:
- LA JANDA: 8 ciudades
- BAHÍA DE CÁDIZ: 13 ciudades
- COSTA NOROESTE: 4 ciudades
- SIERRA DE CÁDIZ: 19 ciudades
- CAMPO DE GIBRALTAR: 10 ciudades

### Paso 3: Ajustar coordenadas (opcional)

Las coordenadas y límites geográficos son **aproximados**. Si necesitas ajustarlos:

1. Busca la ciudad en el script SQL
2. Actualiza los valores de `lat`, `lng`, `lat_min`, `lat_max`, `lng_min`, `lng_max`
3. Vuelve a ejecutar solo el `INSERT`/`UPDATE` de esa ciudad específica

### Paso 4: Actualizar el código Flutter

El código Flutter ya está actualizado para:
- ✅ Filtrar solo ciudades de Cádiz por defecto
- ✅ Mostrar límites geográficos en el mapa
- ✅ Validar que la selección de ubicación esté dentro de los límites de la ciudad
- ✅ Mostrar advertencias si la ubicación está fuera de límites

**No es necesario hacer cambios adicionales en el código Flutter.**

## Cambios en el código

### Modelo `City` actualizado

El modelo `City` ahora incluye:
- `region`: Región de la ciudad
- `latMin`, `latMax`, `lngMin`, `lngMax`: Límites geográficos
- Método `isWithinBounds(lat, lng)`: Valida si una coordenada está dentro de los límites

### `CityService` actualizado

- `fetchCities()`: Por defecto filtra solo ciudades de Cádiz
- `searchCities()`: Filtra solo ciudades de Cádiz en las búsquedas
- Incluye campos de límites geográficos en todas las consultas

### Mapa actualizado

- La vista del mapa se ajusta automáticamente a los límites de la ciudad seleccionada
- Muestra advertencia visual si la ubicación está fuera de límites
- Permite confirmar aunque esté fuera de límites (con advertencia)

## Notas importantes

1. **Límites geográficos**: Los límites son aproximados y pueden necesitar ajustes según tus necesidades. Los límites actuales son un área de aproximadamente 15-20 km alrededor del centro de cada ciudad.

2. **Compatibilidad**: El código mantiene compatibilidad con ciudades que no tienen límites definidos. En ese caso, se permite cualquier ubicación.

3. **Validación**: La validación de límites se hace tanto en el mapa (visual) como al confirmar (diálogo de advertencia).

4. **Filtrado automático**: El código ahora filtra automáticamente solo ciudades de Cádiz. Si necesitas ciudades de otras provincias, debes pasar explícitamente el `provinceId` correspondiente.

## Solución de problemas

### Error: "column province_id does not exist"
- La migración debería crear esta columna automáticamente
- Si el error persiste, verifica que el script completo se ejecutó correctamente

### Error: "No se pudo encontrar la provincia de Cádiz"
- Verifica que la tabla `provinces` se creó correctamente
- Ejecuta manualmente: `INSERT INTO public.provinces (name, slug) VALUES ('Cádiz', 'cadiz') ON CONFLICT (slug) DO NOTHING;`

### Las ciudades no se filtran por Cádiz
- Verifica que todas las ciudades tienen `province_id` asignado
- Ejecuta: `SELECT * FROM public.cities WHERE province_id IS NULL;`
- Si hay ciudades sin `province_id`, actualízalas manualmente

## Consultas útiles

Ver todas las ciudades de Cádiz ordenadas por región:
```sql
SELECT 
  id,
  slug,
  name,
  region,
  lat,
  lng
FROM public.cities
WHERE province_id = (SELECT id FROM public.provinces WHERE slug = 'cadiz')
ORDER BY region, name;
```

Ver ciudades sin límites geográficos:
```sql
SELECT 
  id,
  name,
  region
FROM public.cities
WHERE province_id = (SELECT id FROM public.provinces WHERE slug = 'cadiz')
  AND (lat_min IS NULL OR lat_max IS NULL OR lng_min IS NULL OR lng_max IS NULL);
```

Verificar que todas las ciudades tienen provincia asignada:
```sql
SELECT 
  COUNT(*) as total_ciudades,
  COUNT(province_id) as ciudades_con_provincia,
  COUNT(*) - COUNT(province_id) as ciudades_sin_provincia
FROM public.cities;
```
