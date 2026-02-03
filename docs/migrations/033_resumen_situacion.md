# Resumen de la situación de coordenadas en eventos

## Diagnóstico actual

- **Total de eventos con maps_url**: 171
- **Eventos con coordenadas extraíbles de maps_url**: 6 (formato `query=LAT,LNG`)
- **Eventos sin coordenadas en maps_url**: 165
- **Eventos con venue_id**: 0 (ninguno puede usar coordenadas del venue)

## Problema

La mayoría de los eventos (165 de 171) tienen `maps_url` pero:
1. No tienen coordenadas en el formato esperado
2. No tienen `venue_id` asociado
3. Por lo tanto, no pueden obtener coordenadas automáticamente

## Soluciones posibles

### Opción 1: Geocoding del campo `place` (Recomendado)
Usar una API de geocoding (Google Maps Geocoding API) para obtener coordenadas basándose en:
- `place` (nombre del lugar)
- `city_name` (nombre de la ciudad)

**Ventajas:**
- Obtiene coordenadas precisas del lugar específico
- Funciona para todos los eventos que tienen `place`

**Desventajas:**
- Requiere llamadas a API externa (coste)
- Puede tardar si hay muchos eventos

### Opción 2: Usar coordenadas de la ciudad como fallback temporal
**NO RECOMENDADO** porque:
- Todos los eventos de la misma ciudad tendrían las mismas coordenadas
- No refleja la ubicación real del evento
- Ya eliminamos este fallback en el código

### Opción 3: Actualizar manualmente
Los administradores pueden:
- Editar eventos individualmente
- Seleccionar ubicación en el mapa
- Asociar un venue con coordenadas

## Recomendación

1. **Corto plazo**: La migración actual funcionará para los 6 eventos con coordenadas en maps_url
2. **Medio plazo**: Crear un script de geocoding para los 165 eventos restantes usando el campo `place`
3. **Largo plazo**: Asegurar que todos los nuevos eventos tengan coordenadas al crearse (ya implementado)

## Próximos pasos

1. Ejecutar la migración `033_add_lat_lng_to_events.sql` para:
   - Agregar columnas lat/lng
   - Extraer coordenadas de los 6 eventos que las tienen
   - Actualizar la vista events_view

2. Crear script de geocoding para los 165 eventos restantes (si se decide hacerlo)
