-- Script para analizar en detalle los maps_url y entender por qué no se pueden extraer coordenadas

-- Primero, crear las funciones si no existen
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
  
  -- Formato 2: @LAT,LNG
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
  
  -- Formato 2: @LAT,LNG
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

-- Análisis detallado: ver ejemplos reales de maps_url
SELECT 
  '=== EJEMPLOS DE MAPS_URL SIN COORDENADAS ===' as seccion;

-- Mostrar ejemplos reales
SELECT 
  id,
  title,
  place,
  maps_url,
  LENGTH(maps_url) as longitud_url,
  CASE 
    WHEN maps_url LIKE '%place/%' THEN '✅ Tiene place/ (nombre de lugar, NO coordenadas)'
    WHEN maps_url LIKE '%search/%query=%' THEN 
      CASE 
        WHEN maps_url ~ 'query=(-?\d+\.?\d*),(-?\d+\.?\d*)' THEN '✅ Tiene query=LAT,LNG'
        ELSE '⚠️ Tiene query= pero con texto, no coordenadas'
      END
    WHEN maps_url LIKE '%@%' THEN 
      CASE 
        WHEN maps_url ~ '@(-?\d+\.?\d*),(-?\d+\.?\d*)' THEN '✅ Tiene @LAT,LNG'
        ELSE '⚠️ Tiene @ pero formato diferente'
      END
    ELSE '❓ Formato desconocido'
  END as analisis_formato,
  extract_lat_from_maps_url(maps_url) as lat_extraida,
  extract_lng_from_maps_url(maps_url) as lng_extraida
FROM public.events
WHERE maps_url IS NOT NULL
  AND extract_lat_from_maps_url(maps_url) IS NULL
ORDER BY id
LIMIT 20;

-- Estadísticas por tipo de URL
SELECT 
  '=== ESTADÍSTICAS POR TIPO DE URL ===' as seccion;

SELECT 
  CASE 
    WHEN maps_url ~ 'query=(-?\d+\.?\d*),(-?\d+\.?\d*)' THEN '✅ query=LAT,LNG (con coordenadas)'
    WHEN maps_url ~ '@(-?\d+\.?\d*),(-?\d+\.?\d*)' THEN '✅ @LAT,LNG (con coordenadas)'
    WHEN maps_url ~ '[?&]q=(-?\d+\.?\d*),(-?\d+\.?\d*)' THEN '✅ ?q=LAT,LNG (con coordenadas)'
    WHEN maps_url LIKE '%place/%' THEN '❌ place/NOMBRE (sin coordenadas, solo nombre)'
    WHEN maps_url LIKE '%search/%query=%' AND maps_url !~ 'query=(-?\d+\.?\d*),(-?\d+\.?\d*)' THEN '❌ search/?query=TEXTO (sin coordenadas, texto)'
    ELSE '❓ Otro formato'
  END as tipo_url,
  COUNT(*) as cantidad,
  ROUND(COUNT(*) * 100.0 / (SELECT COUNT(*) FROM public.events WHERE maps_url IS NOT NULL), 2) as porcentaje
FROM public.events
WHERE maps_url IS NOT NULL
GROUP BY tipo_url
ORDER BY cantidad DESC;
