-- Script de diagnóstico para verificar el estado de lat/lng en eventos
-- Ejecutar este script ANTES de la migración 033 para ver qué datos tenemos

-- Primero, crear las funciones de extracción si no existen (necesarias para el diagnóstico)
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

-- 1. Verificar si las columnas lat/lng existen
SELECT 
  CASE 
    WHEN EXISTS (
      SELECT 1 FROM information_schema.columns 
      WHERE table_schema = 'public' 
      AND table_name = 'events' 
      AND column_name = 'lat'
    ) THEN '✅ Columnas lat/lng EXISTEN'
    ELSE '❌ Columnas lat/lng NO existen aún'
  END as estado_columnas;

-- 2. Estadísticas básicas (sin depender de lat/lng)
SELECT 
  COUNT(*) as total_eventos,
  COUNT(maps_url) as eventos_con_maps_url,
  COUNT(venue_id) as eventos_con_venue_id
FROM public.events;

-- 3. Ver ejemplos de maps_url y si se pueden extraer coordenadas
SELECT 
  id, 
  title, 
  place,
  maps_url,
  extract_lat_from_maps_url(maps_url) as lat_extraida,
  extract_lng_from_maps_url(maps_url) as lng_extraida,
  CASE 
    WHEN extract_lat_from_maps_url(maps_url) IS NOT NULL 
      AND extract_lng_from_maps_url(maps_url) IS NOT NULL 
    THEN '✅ Se pueden extraer'
    ELSE '❌ No se pueden extraer'
  END as estado
FROM public.events 
WHERE maps_url IS NOT NULL
LIMIT 20;

-- 4. Ver eventos con venue_id que podrían tener coordenadas del venue
SELECT 
  e.id,
  e.title,
  e.place,
  e.venue_id,
  v.name as venue_name,
  v.lat as venue_lat,
  v.lng as venue_lng
FROM public.events e
LEFT JOIN public.venues v ON e.venue_id = v.id
WHERE e.venue_id IS NOT NULL
LIMIT 20;

-- 5. Ver formatos de maps_url que tenemos
SELECT 
  CASE 
    WHEN maps_url ~ 'query=(-?\d+\.?\d*),(-?\d+\.?\d*)' THEN 'Formato: query=LAT,LNG'
    WHEN maps_url ~ '@(-?\d+\.?\d*),(-?\d+\.?\d*)' THEN 'Formato: @LAT,LNG'
    WHEN maps_url ~ '[?&]q=(-?\d+\.?\d*),(-?\d+\.?\d*)' THEN 'Formato: ?q=LAT,LNG'
    WHEN maps_url LIKE '%place/%' THEN 'Formato: place/ (nombre de lugar, sin coordenadas)'
    ELSE 'Formato desconocido o sin coordenadas'
  END as formato_url,
  COUNT(*) as cantidad
FROM public.events
WHERE maps_url IS NOT NULL
GROUP BY formato_url
ORDER BY cantidad DESC;
