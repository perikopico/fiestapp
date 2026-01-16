-- Migración 028: Agregar campo info_url a la tabla events
-- Este campo almacenará URLs de interés relacionadas con el evento
-- (ej: enlaces a páginas web, redes sociales, etc.)

-- Paso 1: Agregar el campo info_url como text nullable
ALTER TABLE public.events 
ADD COLUMN IF NOT EXISTS info_url text;

-- Paso 2: Actualizar la vista events_view para incluir info_url
-- Primero eliminamos las funciones que dependen de la vista
DROP FUNCTION IF EXISTS public.get_popular_events_this_week(integer) CASCADE;
DROP FUNCTION IF EXISTS public.get_popular_events(bigint, integer) CASCADE;

DROP VIEW IF EXISTS public.events_view CASCADE;

CREATE OR REPLACE VIEW public.events_view AS
SELECT 
  e.*,
  c.name as city_name,
  cat.name as category_name,
  cat.icon as category_icon,
  cat.color as category_color
FROM public.events e
INNER JOIN public.cities c ON e.city_id = c.id
INNER JOIN public.categories cat ON e.category_id = cat.id;

-- Recrear las funciones que dependían de la vista
-- Función get_popular_events_this_week: devuelve eventos populares de esta semana
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

-- Función get_popular_events: devuelve eventos populares (opcionalmente filtrados por provincia)
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

-- Paso 3: Actualizar la función events_within_radius para incluir info_url
-- Primero eliminar la función existente para poder cambiar su tipo de retorno
DROP FUNCTION IF EXISTS public.events_within_radius(double precision, double precision, double precision) CASCADE;

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
BEGIN
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
      (
        earth_radius_km * acos(
          LEAST(1.0,
            cos(radians(p_lat)) *
            cos(radians(c.lat)) *
            cos(radians(c.lng) - radians(p_lng)) +
            sin(radians(p_lat)) *
            sin(radians(c.lat))
          )
        )
      ) as distance_km
    FROM public.events e
    INNER JOIN public.cities c ON e.city_id = c.id
    INNER JOIN public.categories cat ON e.category_id = cat.id
    WHERE e.status = 'published'
      AND c.lat IS NOT NULL
      AND c.lng IS NOT NULL
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
  ORDER BY ewd.distance_km ASC, ewd.starts_at ASC;
END;
$$;

-- Verificar que la migración se aplicó correctamente
DO $$
BEGIN
  IF EXISTS (
    SELECT 1 
    FROM information_schema.columns 
    WHERE table_schema = 'public' 
    AND table_name = 'events' 
    AND column_name = 'info_url'
  ) THEN
    RAISE NOTICE '✅ Campo info_url agregado correctamente a la tabla events';
  ELSE
    RAISE EXCEPTION '❌ Error: El campo info_url no se agregó correctamente';
  END IF;
END $$;
