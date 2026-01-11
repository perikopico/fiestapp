# Insertar Eventos desde JSON

Este documento explica cómo generar y ejecutar SQL para insertar eventos desde un JSON generado por Gemini.

## Formato de Imágenes de Muestra

Las imágenes están en Supabase Storage con el siguiente formato:
- **Estructura**: `sample-images/1/{category_number}/{number}.webp`
- **Nomenclatura**: `01.webp`, `02.webp`, `03.webp`, etc.
- **Rangos por categoría**:
  - **Categoría 1 (Música)**: `01.webp` - `10.webp` (10 imágenes)
  - **Categoría 2 (Gastronomía)**: `01.webp` - `14.webp` (14 imágenes)
  - **Categoría 3 (Deportes)**: `01.webp` - `16.webp` (16 imágenes)
  - **Categoría 4 (Arte y Cultura)**: `01.webp` - `09.webp` (9 imágenes)
  - **Categoría 5 (Aire Libre)**: `01.webp` - `10.webp` (10 imágenes)
  - **Categoría 6 (Tradiciones)**: `01.webp` - `09.webp` (9 imágenes)
  - **Categoría 7 (Mercadillos)**: `01.webp` - `10.webp` (10 imágenes)

## Uso del Script Python

### Paso 1: Ejecutar el script

```bash
cd scripts
python3 generar_sql_eventos.py
```

### Paso 2: Pegar el JSON

El script te pedirá que pegues el JSON con los eventos. Presiona Enter dos veces después de pegar todo el JSON.

### Paso 3: Proporcionar URL de Supabase Storage

El script te pedirá la URL base de Supabase Storage:
- Ejemplo: `https://xxxxx.supabase.co/storage/v1/object/public`
- O presiona Enter para usar un placeholder que deberás reemplazar después

### Paso 4: Revisar el SQL generado

El script generará un archivo SQL en `docs/migrations/016_insertar_eventos_{timestamp}.sql`

### Paso 5: Ejecutar en Supabase

1. Abre el archivo SQL generado
2. Reemplaza `{SUPABASE_STORAGE_URL}` con tu URL real si no la proporcionaste
3. Copia todo el contenido al SQL Editor de Supabase
4. Ejecuta la migración

## Formato del JSON de Entrada

El JSON debe ser un array de objetos con esta estructura:

```json
[
  {
    "title": "Título del evento",
    "city": "Barbate",
    "category": "Música",
    "place": "Lugar del evento",
    "starts_at": "2025-03-15T20:30:00Z",
    "is_free": true,
    "is_featured": false,
    "description": "Descripción opcional del evento",
    "maps_url": "https://maps.google.com/...",
    "status": "published"
  },
  ...
]
```

### Campos Requeridos:
- `title` (string): Título del evento
- `city` (string): Nombre de la ciudad (debe existir en la BD)
- `category` (string): Nombre o slug de la categoría
- `starts_at` (string): Fecha y hora en formato ISO 8601

### Campos Opcionales:
- `place` (string): Lugar del evento
- `is_free` (boolean, default: true): Si el evento es gratuito
- `is_featured` (boolean, default: false): Si el evento es destacado
- `description` (string): Descripción del evento
- `maps_url` (string): URL de Google Maps
- `status` (string, default: "published"): Estado del evento ('pending', 'published', 'rejected')
- `image_alignment` (string, default: "center"): Alineación de la imagen ('top', 'center', 'bottom')

## Cómo Funciona la Asignación de Imágenes

1. Para cada evento, el script determina su categoría
2. Mapea la categoría a su número (1-7)
3. Selecciona un número aleatorio dentro del rango de imágenes disponibles:
   - Categoría 1: 1-10 → `01.webp` a `10.webp`
   - Categoría 2: 1-14 → `01.webp` a `14.webp`
   - Categoría 3: 1-16 → `01.webp` a `16.webp`
   - Categoría 4: 1-9 → `01.webp` a `09.webp`
   - Categoría 5: 1-10 → `01.webp` a `10.webp`
   - Categoría 6: 1-9 → `01.webp` a `09.webp`
   - Categoría 7: 1-10 → `01.webp` a `10.webp`
4. Construye la URL completa: `{SUPABASE_STORAGE_URL}/sample-images/1/{category_number}/{number}.webp`
5. Inserta el evento con esa URL de imagen

## Ejemplo de SQL Generado

```sql
DO $$
DECLARE
  v_city_id INT;
  v_category_id INT;
  v_category_slug TEXT;
  v_category_number INT;
  v_max_images INT;
  v_random_num INT;
  v_image_filename TEXT;
  v_image_url TEXT;
  v_supabase_url TEXT := 'https://xxxxx.supabase.co/storage/v1/object/public';
BEGIN
  -- Evento 1: Concierto de Flamenco
  BEGIN
    SELECT id INTO v_city_id FROM public.cities WHERE LOWER(name) = LOWER('Barbate') LIMIT 1;
    SELECT id INTO v_category_id FROM public.categories WHERE LOWER(slug) = LOWER('musica') LIMIT 1;
    
    -- Generar imagen aleatoria para categoría 1 (Música)
    -- Rango: 01.webp - 10.webp
    v_category_number := 1;
    v_max_images := 10;
    v_random_num := 1 + floor(random() * v_max_images)::INT;
    v_image_filename := LPAD(v_random_num::TEXT, 2, '0') || '.webp';
    v_image_url := v_supabase_url || '/sample-images/1/' || v_category_number::TEXT || '/' || v_image_filename;
    
    INSERT INTO public.events (
      id, title, place, maps_url, image_url, is_featured, is_free, 
      starts_at, city_id, category_id, status, description, image_alignment
    ) VALUES (
      '550e8400-e29b-41d4-a716-446655440000',
      'Concierto de Flamenco',
      'Peña Flamenca',
      NULL,
      v_image_url,  -- Ejemplo: https://xxxxx.supabase.co/storage/v1/object/public/sample-images/1/1/07.webp
      FALSE,
      TRUE,
      '2025-03-15 20:30:00+00'::timestamptz,
      v_city_id,
      v_category_id,
      'published',
      NULL,
      'center'
    );
  EXCEPTION
    WHEN OTHERS THEN
      RAISE WARNING 'Error al insertar evento 1: %', SQLERRM;
  END;
END $$;
```

## Verificación

Después de ejecutar el SQL, puedes verificar los eventos insertados:

```sql
-- Contar eventos insertados
SELECT COUNT(*) as total_eventos FROM public.events;

-- Ver algunos eventos con sus imágenes
SELECT 
  e.id,
  e.title,
  c.name as ciudad,
  cat.name as categoria,
  e.starts_at,
  e.image_url
FROM public.events e
LEFT JOIN public.cities c ON e.city_id = c.id
LEFT JOIN public.categories cat ON e.category_id = cat.id
ORDER BY e.starts_at DESC
LIMIT 20;

-- Verificar que todos los eventos tienen imágenes
SELECT 
  COUNT(*) as eventos_con_imagen,
  COUNT(*) FILTER (WHERE image_url IS NULL) as eventos_sin_imagen
FROM public.events;
```

## Solución de Problemas

### Error: "Ciudad no encontrada"
- Verifica que el nombre de la ciudad en el JSON coincida exactamente con el nombre en la BD
- Ejecuta: `SELECT name FROM public.cities ORDER BY name;` para ver las ciudades disponibles

### Error: "Categoría no encontrada"
- Verifica que el nombre de la categoría en el JSON sea reconocido
- Categorías válidas: "Música", "Gastronomía", "Deportes", "Arte y Cultura", "Aire Libre", "Tradiciones", "Mercadillos"
- También acepta slugs: "musica", "gastronomia", "deportes", etc.

### Las imágenes no se cargan
- Verifica que las imágenes existan en Supabase Storage en la ruta correcta
- Verifica que la URL de Supabase Storage sea correcta
- Verifica los permisos del bucket `sample-images` (debe ser público para lectura)

### Imagen fuera de rango
- Si aparece un error de imagen fuera de rango, verifica que los números de archivo estén dentro del rango especificado
- Los rangos están hardcodeados en la función SQL según lo especificado
