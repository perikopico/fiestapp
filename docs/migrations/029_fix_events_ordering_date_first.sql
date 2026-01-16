-- ============================================
-- Migración 029: Corregir ordenación de eventos
-- ============================================
-- Esta migración corrige la función events_within_radius para priorizar
-- la fecha sobre la distancia en la ordenación.
--
-- Cambio: 
-- ANTES: ORDER BY distance_km ASC, starts_at ASC (distancia primero)
-- AHORA:  ORDER BY starts_at ASC, distance_km ASC (fecha primero)
--
-- Resultado esperado: Un evento "Mañana a 10km" aparece ANTES que 
-- "La semana que viene a 1km" porque la fecha es más importante.
-- ============================================

-- Actualizar la función events_within_radius para cambiar el orden
CREATE OR REPLACE FUNCTION public.events_within_radius(
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
  info_url text,
  distance_km double precision
)
LANGUAGE plpgsql
STABLE
AS $$
DECLARE
  earth_radius_km constant double precision := 6371.0;
  lat_radius double precision;
  lng_radius double precision;
BEGIN
  -- Convertir radio de km a grados aproximadamente (para bounding box)
  lat_radius := p_radius_km / 111.0;
  lng_radius := p_radius_km / (111.0 * COS(RADIANS(p_lat)));

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
      e.info_url,
      -- Calcular distancia usando la fórmula de Haversine
      -- Siempre usar las coordenadas de la ciudad, no las del evento
      CASE 
        WHEN c.lat IS NOT NULL AND c.lng IS NOT NULL THEN
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
    WHERE e.status = 'published'
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
    ewd.info_url,
    ewd.distance_km
  FROM events_with_distance ewd
  WHERE ewd.distance_km <= p_radius_km
  -- ✅ CAMBIO: Ordenar PRIMERO por fecha (más pronto primero), LUEGO por distancia (más cercano primero)
  -- Esto asegura que un evento "Mañana a 10km" aparezca ANTES que "La semana que viene a 1km"
  ORDER BY ewd.starts_at ASC, ewd.distance_km ASC;
END;
$$;

-- Actualizar el comentario de la función
COMMENT ON FUNCTION public.events_within_radius IS 
'Retorna eventos dentro de un radio especificado (en kilómetros) desde un punto dado.
Usa la fórmula de Haversine para calcular la distancia geodésica precisa.
SIEMPRE usa las coordenadas de la ciudad (c.lat, c.lng), nunca las del evento.
Los resultados están ordenados PRIMERO por fecha (más pronto primero) y LUEGO por distancia (más cercano primero).
Incluye el campo distance_km con la distancia calculada en kilómetros.';
