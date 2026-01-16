-- ============================================
-- Migración 025: Corregir función events_within_radius
-- ============================================
-- Esta migración corrige la función events_within_radius para calcular
-- correctamente la distancia en kilómetros usando la fórmula de Haversine.
-- El problema reportado: con un radio de 5km aparecían eventos en Vejer
-- (23km) y Puerto Real (50-60km), lo que indica un cálculo incorrecto.
--
-- La función ahora:
-- 1. Usa la fórmula de Haversine correctamente
-- 2. Calcula la distancia en kilómetros (radio de la Tierra = 6371 km)
-- 3. SIEMPRE usa las coordenadas de la ciudad (c.lat, c.lng), nunca las del evento
-- 4. Ordena primero por distancia (más cercanos primero) y luego por fecha
-- 5. Incluye la distancia calculada en el resultado (distance_km)
-- ============================================

-- Eliminar la función existente si existe (porque puede tener un tipo de retorno diferente)
DROP FUNCTION IF EXISTS public.events_within_radius(double precision, double precision, double precision) CASCADE;

-- Crear la función corregida
CREATE FUNCTION public.events_within_radius(
  p_lat double precision,
  p_lng double precision,
  p_radius_km double precision
)
RETURNS TABLE (
  id uuid,
  title text,
  city_id bigint,
  city_name text,
  category_id bigint,
  category_name text,
  starts_at timestamptz,
  image_url text,
  maps_url text,
  place text,
  is_featured boolean,
  price text,
  category_icon text,
  category_color text,
  image_alignment text,
  distance_km double precision
)
LANGUAGE plpgsql
STABLE
AS $$
DECLARE
  -- Radio de la Tierra en kilómetros
  earth_radius_km constant double precision := 6371.0;
  -- Radio en radianes para el cálculo de bounding box
  -- Pre-calcular el radio en grados para optimizar la consulta
  lat_radius double precision;
  lng_radius double precision;
BEGIN
  -- Convertir radio de km a grados aproximadamente (para bounding box)
  -- Esto nos permite filtrar rápidamente eventos que están obviamente fuera del radio
  -- 1 grado de latitud ≈ 111 km
  -- 1 grado de longitud ≈ 111 km * cos(latitud)
  lat_radius := p_radius_km / 111.0;
  lng_radius := p_radius_km / (111.0 * COS(RADIANS(p_lat)));

  -- Retornar eventos dentro del radio
  -- SIEMPRE usamos las coordenadas de la ciudad, nunca las del evento
  -- Usamos un bounding box inicial para filtrar rápidamente, y luego
  -- aplicamos la fórmula de Haversine para el cálculo preciso
  RETURN QUERY
  WITH events_with_distance AS (
    SELECT 
      e.id,
      e.title,
      e.city_id,
      c.name as city_name,
      e.category_id,
      cat.name as category_name,
      e.starts_at,
      e.image_url,
      e.maps_url,
      e.place,
      e.is_featured,
      e.price,
      cat.icon as category_icon,
      cat.color as category_color,
      e.image_alignment,
      -- Calcular distancia usando SIEMPRE las coordenadas de la ciudad
      CASE 
        WHEN c.lat IS NOT NULL AND c.lng IS NOT NULL THEN
          -- Fórmula de Haversine: d = 2 * R * ASIN(SQRT(a))
          -- donde a = SIN²(Δlat/2) + COS(lat1) * COS(lat2) * SIN²(Δlon/2)
          earth_radius_km * 2 * ASIN(
            SQRT(
              POWER(SIN(RADIANS((c.lat - p_lat) / 2)), 2) +
              COS(RADIANS(p_lat)) * COS(RADIANS(c.lat)) *
              POWER(SIN(RADIANS((c.lng - p_lng) / 2)), 2)
            )
          )
        ELSE NULL
      END as distance_km
    FROM public.events e
    INNER JOIN public.cities c ON e.city_id = c.id
    INNER JOIN public.categories cat ON e.category_id = cat.id
    WHERE 
      e.status = 'published'
      -- Solo eventos donde la ciudad tiene coordenadas
      AND c.lat IS NOT NULL 
      AND c.lng IS NOT NULL
      -- Bounding box inicial para filtrar rápidamente eventos obviamente fuera del radio
      AND c.lat BETWEEN (p_lat - lat_radius) AND (p_lat + lat_radius)
      AND c.lng BETWEEN (p_lng - lng_radius) AND (p_lng + lng_radius)
  )
  SELECT 
    ewd.id,
    ewd.title,
    ewd.city_id,
    ewd.city_name,
    ewd.category_id,
    ewd.category_name,
    ewd.starts_at,
    ewd.image_url,
    ewd.maps_url,
    ewd.place,
    ewd.is_featured,
    ewd.price,
    ewd.category_icon,
    ewd.category_color,
    ewd.image_alignment,
    ewd.distance_km
  FROM events_with_distance ewd
  WHERE ewd.distance_km <= p_radius_km
  -- Ordenar primero por distancia (más cercanos primero), luego por fecha
  ORDER BY ewd.distance_km ASC, ewd.starts_at ASC;
END;
$$;

-- Comentario sobre la función
COMMENT ON FUNCTION public.events_within_radius IS 
'Retorna eventos dentro de un radio especificado (en kilómetros) desde un punto dado.
Usa la fórmula de Haversine para calcular la distancia geodésica precisa.
SIEMPRE usa las coordenadas de la ciudad (c.lat, c.lng), nunca las del evento.
Los resultados están ordenados primero por distancia (más cercanos primero) y luego por fecha.
Incluye el campo distance_km con la distancia calculada en kilómetros.';
