-- Script de diagnóstico SIMPLIFICADO para verificar el estado de lat/lng en eventos
-- Ejecutar este script para ver qué datos tenemos

-- 1. Verificar si las columnas lat/lng existen
SELECT 
  CASE 
    WHEN EXISTS (
      SELECT 1 FROM information_schema.columns 
      WHERE table_schema = 'public' 
      AND table_name = 'events' 
      AND column_name = 'lat'
    ) THEN '✅ Columnas lat/lng EXISTEN'
    ELSE '❌ Columnas lat/lng NO existen'
  END as estado_columnas;

-- 2. Estadísticas básicas de eventos
SELECT 
  COUNT(*) as total_eventos,
  COUNT(maps_url) as eventos_con_maps_url,
  COUNT(venue_id) as eventos_con_venue_id,
  COUNT(CASE WHEN maps_url IS NOT NULL THEN 1 END) as eventos_con_maps_url_no_null
FROM public.events;

-- 3. Ver algunos ejemplos de maps_url
SELECT 
  id, 
  title, 
  place,
  maps_url,
  venue_id
FROM public.events 
WHERE maps_url IS NOT NULL 
LIMIT 10;

-- 4. Ver algunos ejemplos de eventos con venue_id
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
LIMIT 10;

-- 5. Ver formatos de maps_url (análisis simple)
SELECT 
  CASE 
    WHEN maps_url LIKE '%query=%' THEN 'Tiene query='
    WHEN maps_url LIKE '%@%' THEN 'Tiene @'
    WHEN maps_url LIKE '%?q=%' OR maps_url LIKE '%&q=%' THEN 'Tiene ?q= o &q='
    WHEN maps_url LIKE '%place/%' THEN 'Tiene place/ (nombre de lugar)'
    ELSE 'Formato desconocido'
  END as tipo_url,
  COUNT(*) as cantidad,
  STRING_AGG(SUBSTRING(maps_url, 1, 80), ', ' ORDER BY id LIMIT 3) as ejemplos
FROM public.events
WHERE maps_url IS NOT NULL
GROUP BY tipo_url
ORDER BY cantidad DESC;

-- 6. Si las columnas lat/lng existen, mostrar estadísticas
DO $$
BEGIN
  IF EXISTS (
    SELECT 1 FROM information_schema.columns 
    WHERE table_schema = 'public' 
    AND table_name = 'events' 
    AND column_name = 'lat'
  ) THEN
    RAISE NOTICE '=== Estadísticas con lat/lng ===';
  END IF;
END $$;

-- Esta consulta solo funcionará si las columnas existen
SELECT 
  COUNT(*) as total,
  COUNT(lat) as con_lat,
  COUNT(lng) as con_lng,
  COUNT(CASE WHEN lat IS NOT NULL AND lng IS NOT NULL THEN 1 END) as con_ambas_coords
FROM public.events
WHERE EXISTS (
  SELECT 1 FROM information_schema.columns 
  WHERE table_schema = 'public' 
  AND table_name = 'events' 
  AND column_name = 'lat'
);
