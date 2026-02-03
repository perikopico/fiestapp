-- Migración 033: Agregar campos lat/lng a la tabla events y extraer coordenadas de maps_url
-- Esta migración:
-- 1. Agrega las columnas lat y lng a la tabla events si no existen
-- 2. Extrae coordenadas de maps_url cuando están disponibles
-- 3. Actualiza la vista events_view para incluir lat/lng

-- Paso 1: Agregar columnas lat y lng si no existen
DO $$
BEGIN
  -- Verificar si la columna lat existe
  IF NOT EXISTS (
    SELECT 1 FROM information_schema.columns 
    WHERE table_schema = 'public' 
    AND table_name = 'events' 
    AND column_name = 'lat'
  ) THEN
    ALTER TABLE public.events ADD COLUMN lat double precision;
    RAISE NOTICE 'Columna lat agregada a events';
  ELSE
    RAISE NOTICE 'Columna lat ya existe en events';
  END IF;

  -- Verificar si la columna lng existe
  IF NOT EXISTS (
    SELECT 1 FROM information_schema.columns 
    WHERE table_schema = 'public' 
    AND table_name = 'events' 
    AND column_name = 'lng'
  ) THEN
    ALTER TABLE public.events ADD COLUMN lng double precision;
    RAISE NOTICE 'Columna lng agregada a events';
  ELSE
    RAISE NOTICE 'Columna lng ya existe en events';
  END IF;
END $$;

-- Paso 2: Funciones para extraer coordenadas de maps_url
-- Soporta múltiples formatos de Google Maps:
-- 1. https://www.google.com/maps/search/?api=1&query=LAT,LNG
-- 2. https://www.google.com/maps/@LAT,LNG,ZOOM
-- 3. https://maps.google.com/?q=LAT,LNG
CREATE OR REPLACE FUNCTION extract_lat_from_maps_url(url text)
RETURNS double precision AS $$
DECLARE
  match_result text[];
BEGIN
  IF url IS NULL THEN
    RETURN NULL;
  END IF;
  
  -- Formato 1: query=LAT,LNG
  IF url ~ 'query=(-?\d+\.?\d*),(-?\d+\.?\d*)' THEN
    match_result := regexp_match(url, 'query=(-?\d+\.?\d*),(-?\d+\.?\d*)');
    IF match_result IS NOT NULL AND array_length(match_result, 1) >= 2 THEN
      RETURN match_result[1]::double precision;
    END IF;
  END IF;
  
  -- Formato 2: @LAT,LNG (más común en URLs de Google Maps)
  IF url ~ '@(-?\d+\.?\d*),(-?\d+\.?\d*)' THEN
    match_result := regexp_match(url, '@(-?\d+\.?\d*),(-?\d+\.?\d*)');
    IF match_result IS NOT NULL AND array_length(match_result, 1) >= 2 THEN
      RETURN match_result[1]::double precision;
    END IF;
  END IF;
  
  -- Formato 3: ?q=LAT,LNG
  IF url ~ '[?&]q=(-?\d+\.?\d*),(-?\d+\.?\d*)' THEN
    match_result := regexp_match(url, '[?&]q=(-?\d+\.?\d*),(-?\d+\.?\d*)');
    IF match_result IS NOT NULL AND array_length(match_result, 1) >= 2 THEN
      RETURN match_result[1]::double precision;
    END IF;
  END IF;
  
  RETURN NULL;
END;
$$ LANGUAGE plpgsql IMMUTABLE;

CREATE OR REPLACE FUNCTION extract_lng_from_maps_url(url text)
RETURNS double precision AS $$
DECLARE
  match_result text[];
BEGIN
  IF url IS NULL THEN
    RETURN NULL;
  END IF;
  
  -- Formato 1: query=LAT,LNG
  IF url ~ 'query=(-?\d+\.?\d*),(-?\d+\.?\d*)' THEN
    match_result := regexp_match(url, 'query=(-?\d+\.?\d*),(-?\d+\.?\d*)');
    IF match_result IS NOT NULL AND array_length(match_result, 1) >= 2 THEN
      RETURN match_result[2]::double precision;
    END IF;
  END IF;
  
  -- Formato 2: @LAT,LNG (más común en URLs de Google Maps)
  IF url ~ '@(-?\d+\.?\d*),(-?\d+\.?\d*)' THEN
    match_result := regexp_match(url, '@(-?\d+\.?\d*),(-?\d+\.?\d*)');
    IF match_result IS NOT NULL AND array_length(match_result, 1) >= 2 THEN
      RETURN match_result[2]::double precision;
    END IF;
  END IF;
  
  -- Formato 3: ?q=LAT,LNG
  IF url ~ '[?&]q=(-?\d+\.?\d*),(-?\d+\.?\d*)' THEN
    match_result := regexp_match(url, '[?&]q=(-?\d+\.?\d*),(-?\d+\.?\d*)');
    IF match_result IS NOT NULL AND array_length(match_result, 1) >= 2 THEN
      RETURN match_result[2]::double precision;
    END IF;
  END IF;
  
  RETURN NULL;
END;
$$ LANGUAGE plpgsql IMMUTABLE;

-- Paso 3: Consultas de diagnóstico (ejecutar primero para ver qué hay)
-- Descomentar estas líneas para diagnosticar:
/*
-- Ver cuántos eventos tienen maps_url
SELECT 
  COUNT(*) as total_eventos,
  COUNT(maps_url) as eventos_con_maps_url,
  COUNT(lat) as eventos_con_lat,
  COUNT(lng) as eventos_con_lng
FROM public.events;

-- Ver ejemplos de maps_url
SELECT id, title, maps_url, 
  extract_lat_from_maps_url(maps_url) as lat_extraida,
  extract_lng_from_maps_url(maps_url) as lng_extraida
FROM public.events 
WHERE maps_url IS NOT NULL 
LIMIT 10;
*/

-- Paso 3: Extraer coordenadas de maps_url para eventos que no tienen lat/lng
UPDATE public.events
SET 
  lat = extract_lat_from_maps_url(maps_url),
  lng = extract_lng_from_maps_url(maps_url)
WHERE maps_url IS NOT NULL
  AND lat IS NULL
  AND lng IS NULL
  AND extract_lat_from_maps_url(maps_url) IS NOT NULL
  AND extract_lng_from_maps_url(maps_url) IS NOT NULL
  -- Validar que las coordenadas sean razonables (entre -90 y 90 para lat, -180 y 180 para lng)
  AND extract_lat_from_maps_url(maps_url) BETWEEN -90 AND 90
  AND extract_lng_from_maps_url(maps_url) BETWEEN -180 AND 180;

-- Paso 4: Si el evento tiene venue_id, usar las coordenadas del venue si el evento no las tiene
UPDATE public.events e
SET 
  lat = v.lat,
  lng = v.lng
FROM public.venues v
WHERE e.venue_id IS NOT NULL
  AND e.venue_id = v.id
  AND (e.lat IS NULL OR e.lng IS NULL)
  AND v.lat IS NOT NULL
  AND v.lng IS NOT NULL;

-- Paso 5: Actualizar la vista events_view para incluir lat/lng
DROP VIEW IF EXISTS public.events_view CASCADE;

CREATE OR REPLACE VIEW public.events_view AS
SELECT 
  e.*,
  c.name as city_name,
  -- Categoría principal (para compatibilidad)
  cat.name as category_name,
  cat.icon as category_icon,
  cat.color as category_color,
  -- Categorías múltiples (arrays con todas las categorías del evento)
  COALESCE(
    (
      SELECT ARRAY_AGG(cat_id ORDER BY is_primary DESC, cat_id)
      FROM (
        SELECT DISTINCT ec.category_id as cat_id, ec.is_primary
        FROM public.event_categories ec
        WHERE ec.event_id = e.id
      ) sub
    ),
    ARRAY[e.category_id]::bigint[]
  ) as category_ids,
  COALESCE(
    (
      SELECT ARRAY_AGG(cat_name ORDER BY is_primary DESC, cat_name)
      FROM (
        SELECT DISTINCT cat2.name as cat_name, ec.is_primary
        FROM public.event_categories ec
        INNER JOIN public.categories cat2 ON ec.category_id = cat2.id
        WHERE ec.event_id = e.id
      ) sub
    ),
    ARRAY[cat.name]::text[]
  ) as category_names,
  COALESCE(
    (
      SELECT ARRAY_AGG(cat_icon ORDER BY is_primary DESC, cat_icon)
      FROM (
        SELECT DISTINCT cat2.icon as cat_icon, ec.is_primary
        FROM public.event_categories ec
        INNER JOIN public.categories cat2 ON ec.category_id = cat2.id
        WHERE ec.event_id = e.id
      ) sub
    ),
    ARRAY[cat.icon]::text[]
  ) as category_icons,
  COALESCE(
    (
      SELECT ARRAY_AGG(cat_color ORDER BY is_primary DESC, cat_color)
      FROM (
        SELECT DISTINCT cat2.color as cat_color, ec.is_primary
        FROM public.event_categories ec
        INNER JOIN public.categories cat2 ON ec.category_id = cat2.id
        WHERE ec.event_id = e.id
      ) sub
    ),
    ARRAY[cat.color]::text[]
  ) as category_colors
FROM public.events e
INNER JOIN public.cities c ON e.city_id = c.id
INNER JOIN public.categories cat ON e.category_id = cat.id;

-- Paso 6: Recrear funciones que dependen de events_view
CREATE OR REPLACE FUNCTION public.get_popular_events_this_week(p_limit integer)
RETURNS SETOF events_view
LANGUAGE sql
STABLE
AS $$
  SELECT *
  FROM events_view
  WHERE status = 'published'
    AND starts_at >= date_trunc('week', CURRENT_DATE)
    AND starts_at < date_trunc('week', CURRENT_DATE) + interval '1 week'
  ORDER BY is_featured DESC, starts_at ASC
  LIMIT p_limit;
$$;

CREATE OR REPLACE FUNCTION public.get_popular_events(
  p_province_id bigint DEFAULT NULL,
  p_limit integer DEFAULT 10
)
RETURNS SETOF events_view
LANGUAGE sql
STABLE
AS $$
  SELECT *
  FROM events_view
  WHERE status = 'published'
    AND starts_at >= CURRENT_TIMESTAMP
    AND (p_province_id IS NULL OR city_id IN (
      SELECT id FROM cities WHERE province_id = p_province_id
    ))
  ORDER BY is_featured DESC, starts_at ASC
  LIMIT p_limit;
$$;

-- Comentarios
COMMENT ON COLUMN public.events.lat IS 'Latitud del evento (coordenada específica del lugar, no de la ciudad)';
COMMENT ON COLUMN public.events.lng IS 'Longitud del evento (coordenada específica del lugar, no de la ciudad)';
COMMENT ON FUNCTION extract_lat_from_maps_url(text) IS 'Extrae latitud de una URL de Google Maps con formato query=LAT,LNG';
COMMENT ON FUNCTION extract_lng_from_maps_url(text) IS 'Extrae longitud de una URL de Google Maps con formato query=LAT,LNG';
