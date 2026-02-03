# Formato JSON para Ingesta de Eventos desde Gemini

Este documento describe el formato JSON que debe usar Gemini para enviar eventos a la aplicación.

## Formato Básico

El JSON debe ser un **array de objetos**, donde cada objeto representa un evento.

## Campos Requeridos

Todos los eventos deben incluir estos campos:

| Campo | Tipo | Descripción | Ejemplo |
|-------|------|-------------|---------|
| `id` | `number` | ID único del evento (entero) | `123` |
| `status` | `string` | Estado del evento: `"new"`, `"modified"`, `"cancelled"`, o `"confirmed"` | `"new"` |
| `date` | `string` | Fecha en formato ISO 8601 o YYYY-MM-DD | `"2026-01-27"` |
| `time` | `string` | Hora en formato HH:MM o HH:MM:SS | `"20:00"` |
| `category` | `string` | Nombre de la categoría | `"Música"` |
| `title` | `string` | Título del evento | `"Concierto de Flamenco"` |
| `description` | `string` | Descripción del evento | `"Espectáculo de flamenco..."` |
| `location_name` | `string` | Nombre del lugar/venue | `"Teatro Villamarta"` |
| `gmaps_link` | `string` | URL de Google Maps del lugar | `"https://www.google.com/maps/..."` |
| `price` | `string` | Precio del evento | `"Gratis"`, `"18€"`, `"Desde 10€"` |
| `info_url` | `string` | URL de información adicional (puede ser vacío) | `"https://..."` o `""` |

## Campos Opcionales (Nuevos)

Estos campos son **opcionales** pero **altamente recomendados** para mejorar la precisión de las coordenadas:

| Campo | Tipo | Descripción | Ejemplo |
|-------|------|-------------|---------|
| `lat` | `number` | Latitud del evento (entre -90 y 90) | `36.6828855` |
| `lng` | `number` | Longitud del evento (entre -180 y 180) | `-6.1352393` |

### Ventajas de incluir `lat` y `lng`

1. **Precisión**: Las coordenadas proporcionadas directamente son más precisas que extraerlas desde `gmaps_link`
2. **Rendimiento**: Evita tener que hacer geocoding posteriormente
3. **Confiabilidad**: No depende de que el `gmaps_link` tenga coordenadas en formato extraíble

## Ejemplo Completo

### Ejemplo 1: Evento con coordenadas (Recomendado)

```json
[
  {
    "id": 123,
    "status": "new",
    "date": "2026-01-27",
    "time": "20:00",
    "category": "Música",
    "title": "Concierto de Flamenco",
    "description": "Espectáculo de flamenco con artistas locales en el Teatro Villamarta",
    "location_name": "Teatro Villamarta",
    "gmaps_link": "https://www.google.com/maps/place/Teatro+Villamarta",
    "price": "18€",
    "info_url": "https://teatrovillamarta.es",
    "lat": 36.6828855,
    "lng": -6.1352393
  }
]
```

### Ejemplo 2: Evento sin coordenadas (Funciona, pero menos óptimo)

```json
[
  {
    "id": 124,
    "status": "new",
    "date": "2026-01-28",
    "time": "19:30",
    "category": "Arte y Cultura",
    "title": "Exposición de Pintura",
    "description": "Exposición de artistas locales",
    "location_name": "Centro Cultural",
    "gmaps_link": "https://www.google.com/maps/search/?api=1&query=36.5337319,-6.3023766",
    "price": "Gratis",
    "info_url": ""
  }
]
```

En este caso, si el `gmaps_link` contiene coordenadas en formato extraíble (como `query=LAT,LNG` o `@LAT,LNG`), el sistema las extraerá automáticamente mediante un trigger en la base de datos.

### Ejemplo 3: Evento modificado

```json
[
  {
    "id": 123,
    "status": "modified",
    "date": "2026-01-27",
    "time": "21:00",
    "category": "Música",
    "title": "Concierto de Flamenco (Hora actualizada)",
    "description": "Espectáculo de flamenco - Hora cambiada a las 21:00",
    "location_name": "Teatro Villamarta",
    "gmaps_link": "https://www.google.com/maps/place/Teatro+Villamarta",
    "price": "20€",
    "info_url": "https://teatrovillamarta.es",
    "lat": 36.6828855,
    "lng": -6.1352393
  }
]
```

### Ejemplo 4: Evento cancelado

```json
[
  {
    "id": 123,
    "status": "cancelled",
    "date": "2026-01-27",
    "time": "20:00",
    "category": "Música",
    "title": "Concierto de Flamenco",
    "description": "Evento cancelado",
    "location_name": "Teatro Villamarta",
    "gmaps_link": "https://www.google.com/maps/place/Teatro+Villamarta",
    "price": "18€",
    "info_url": "",
    "lat": 36.6828855,
    "lng": -6.1352393
  }
]
```

## Estados (`status`)

- **`"new"`**: Crear un nuevo evento. Si ya existe un evento con el mismo `external_id`, se actualizará.
- **`"modified"`**: Actualizar un evento existente (buscado por `external_id`). Si no existe, se creará uno nuevo.
- **`"cancelled"`**: Marcar un evento existente como rechazado (soft delete).
- **`"confirmed"`**: Ignorar este evento (no se procesa).

## Categorías Válidas

Las categorías deben coincidir con las categorías existentes en la base de datos. Ejemplos:

- `"Música"`
- `"Gastronomía"`
- `"Deportes"`
- `"Arte y Cultura"`
- `"Aire Libre"`
- `"Tradiciones"`
- `"Mercadillos"`

## Validación de Coordenadas

Si se proporcionan `lat` y `lng`:

- **Latitud (`lat`)**: Debe estar entre `-90` y `90`
- **Longitud (`lng`)**: Debe estar entre `-180` y `180`
- Si las coordenadas están fuera de rango, se ignorarán y el sistema intentará extraerlas desde `gmaps_link`

## Comportamiento del Sistema

1. **Si se proporcionan `lat` y `lng`**: Se usan directamente (más preciso y rápido)
2. **Si NO se proporcionan `lat` y `lng`**: 
   - El sistema intenta extraerlas automáticamente desde `gmaps_link` si contiene coordenadas en formato extraíble
   - Si el `gmaps_link` es descriptivo (ej: `query=Teatro+Villamarta`), las coordenadas quedarán como `NULL` y se puede usar el script de geocodificación posteriormente

## Recomendaciones para Gemini

1. **Siempre incluir `lat` y `lng`** cuando sea posible obtenerlas desde Google Maps o fuentes confiables
2. **Validar coordenadas** antes de enviarlas (asegurarse de que estén en los rangos válidos)
3. **Usar formato numérico** para `lat` y `lng` (no strings)
4. **Mantener `gmaps_link`** incluso si se proporcionan coordenadas (útil para referencia y para usuarios)

## Notas Técnicas

- El campo `external_id` en la base de datos almacena el `id` del JSON para poder hacer updates posteriores
- Los eventos se publican directamente con `status: 'published'` (excepto los cancelados)
- Si un evento con `status: "new"` ya existe (mismo `external_id`), se actualizará en lugar de crear un duplicado
