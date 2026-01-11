# Generar SQL de Eventos desde JSON

## Instrucciones

Este script procesará un JSON con eventos y generará sentencias SQL INSERT para crearlos en Supabase.

### Formato esperado del JSON

El JSON debe tener esta estructura (ejemplo):

```json
[
  {
    "title": "Concierto de Flamenco",
    "city": "Barbate",
    "category": "Música",
    "place": "Peña Flamenca",
    "starts_at": "2025-03-15T20:30:00Z",
    "is_free": true,
    "description": "Descripción del evento"
  },
  ...
]
```

### Campos requeridos:
- `title` (string, requerido): Título del evento
- `city` (string, requerido): Nombre de la ciudad (debe coincidir con el nombre en la BD)
- `category` (string, requerido): Nombre o slug de la categoría (ej: "Música", "musica", "Gastronomía", etc.)
- `place` (string, opcional): Lugar del evento
- `starts_at` (string, requerido): Fecha y hora en formato ISO 8601 (ej: "2025-03-15T20:30:00Z")
- `is_free` (boolean, opcional, default: true): Si el evento es gratuito
- `description` (string, opcional): Descripción del evento
- `maps_url` (string, opcional): URL de Google Maps
- `is_featured` (boolean, opcional, default: false): Si el evento es destacado

### Cómo funciona

1. **Mapeo de ciudades**: El script buscará el ID de la ciudad por nombre en la tabla `cities`
2. **Mapeo de categorías**: El script buscará el ID de la categoría por nombre/slug en la tabla `categories`
3. **Asignación de imágenes**: Para cada evento, seleccionará una imagen aleatoria de `sample-images/1/{category_number}/`
4. **Generación de IDs**: Se generarán UUIDs únicos para cada evento
5. **Status por defecto**: Los eventos se crearán con `status = 'published'` (puedes cambiarlo)

### Uso

1. Prepara tu archivo JSON con los eventos
2. Pega el JSON cuando se te solicite
3. El script generará un archivo SQL con todas las sentencias INSERT
