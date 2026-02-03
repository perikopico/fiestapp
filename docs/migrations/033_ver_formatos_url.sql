-- Script para ver ejemplos de los formatos de URL que NO tienen coordenadas
-- Esto nos ayudará a entender qué hacer con esos 165 eventos

-- 1. Ver ejemplos de URLs con formato desconocido (MUESTRA COMPLETA)
SELECT 
  id, 
  title, 
  place,
  maps_url,
  venue_id,
  city_id,
  -- Intentar extraer coordenadas con las funciones
  extract_lat_from_maps_url(maps_url) as lat_intentada,
  extract_lng_from_maps_url(maps_url) as lng_intentada
FROM public.events
WHERE maps_url IS NOT NULL
  AND maps_url !~ 'query=(-?\d+\.?\d*),(-?\d+\.?\d*)'
  AND maps_url !~ '@(-?\d+\.?\d*),(-?\d+\.?\d*)'
  AND maps_url !~ '[?&]q=(-?\d+\.?\d*),(-?\d+\.?\d*)'
ORDER BY id
LIMIT 30;

-- 1b. Ver TODOS los formatos de maps_url para entender mejor
SELECT 
  CASE 
    WHEN maps_url LIKE '%place/%' THEN 'Formato: place/NOMBRE (sin coordenadas)'
    WHEN maps_url LIKE '%search/%' THEN 'Formato: search/ (puede tener o no coordenadas)'
    WHEN maps_url LIKE '%@%' THEN 'Formato: @LAT,LNG (con coordenadas)'
    WHEN maps_url LIKE '%?q=%' OR maps_url LIKE '%&q=%' THEN 'Formato: ?q= (puede tener o no coordenadas)'
    WHEN maps_url LIKE '%query=%' THEN 'Formato: query= (puede tener o no coordenadas)'
    ELSE 'Otro formato'
  END as tipo_url_detectado,
  COUNT(*) as cantidad,
  STRING_AGG(SUBSTRING(maps_url, 1, 100), E'\n' ORDER BY id LIMIT 5) as ejemplos
FROM public.events
WHERE maps_url IS NOT NULL
GROUP BY tipo_url_detectado
ORDER BY cantidad DESC;

-- 2. Ver cuántos de esos eventos tienen venue_id (podrían usar coordenadas del venue)
SELECT 
  COUNT(*) as total_sin_coords_en_url,
  COUNT(venue_id) as con_venue_id,
  COUNT(CASE WHEN venue_id IS NOT NULL THEN 1 END) as pueden_usar_coords_venue
FROM public.events
WHERE maps_url IS NOT NULL
  AND maps_url !~ 'query=(-?\d+\.?\d*),(-?\d+\.?\d*)'
  AND maps_url !~ '@(-?\d+\.?\d*),(-?\d+\.?\d*)'
  AND maps_url !~ '[?&]q=(-?\d+\.?\d*),(-?\d+\.?\d*)';

-- 3. Ver eventos que tienen venue_id y podrían usar sus coordenadas
SELECT 
  e.id,
  e.title,
  e.place,
  e.venue_id,
  v.name as venue_name,
  v.lat as venue_lat,
  v.lng as venue_lng,
  CASE 
    WHEN v.lat IS NOT NULL AND v.lng IS NOT NULL THEN '✅ Tiene coordenadas en venue'
    ELSE '❌ Venue sin coordenadas'
  END as estado
FROM public.events e
LEFT JOIN public.venues v ON e.venue_id = v.id
WHERE e.maps_url IS NOT NULL
  AND e.maps_url !~ 'query=(-?\d+\.?\d*),(-?\d+\.?\d*)'
  AND e.maps_url !~ '@(-?\d+\.?\d*),(-?\d+\.?\d*)'
  AND e.maps_url !~ '[?&]q=(-?\d+\.?\d*),(-?\d+\.?\d*)'
  AND e.venue_id IS NOT NULL
LIMIT 20;
