-- Migración 035: Agregar campos lat/lng a la función events_within_radius
-- Esta migración actualiza la función events_within_radius para incluir
-- las coordenadas lat/lng de los eventos en su resultado, permitiendo
-- que la aplicación Flutter calcule correctamente las distancias a eventos específicos.

-- Paso 1: Eliminar la función existente
DROP FUNCTION IF EXISTS public.events_within_radius(double precision, double precision, double precision) CASCADE;

-- Paso 2: Recrear la función con lat/lng incluidos
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
  distance_km double precision,
  -- Coordenadas del evento (lat/lng específicas del lugar, no de la ciudad)
  lat double precision,
  lng double precision,
  -- Campos para categorías múltiples
  category_ids bigint[],
  category_names text[],
  category_icons text[],
  category_colors text[]
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
      -- Coordenadas del evento (prioridad: evento > venue > ciudad)
      COALESCE(e.lat, v.lat, c.lat) as lat,
      COALESCE(e.lng, v.lng, c.lng) as lng,
      -- Calcular distancia usando la fórmula de Haversine
      -- Usar coordenadas del evento si están disponibles, sino usar coordenadas de la ciudad
      (
        earth_radius_km * acos(
          LEAST(1.0,
            cos(radians(p_lat)) *
            cos(radians(COALESCE(e.lat, v.lat, c.lat))) *
            cos(radians(COALESCE(e.lng, v.lng, c.lng)) - radians(p_lng)) +
            sin(radians(p_lat)) *
            sin(radians(COALESCE(e.lat, v.lat, c.lat)))
          )
        )
      ) as distance_km,
      -- Agregar categorías múltiples usando subconsultas para evitar el problema con DISTINCT y ORDER BY
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
    INNER JOIN public.categories cat ON e.category_id = cat.id
    LEFT JOIN public.venues v ON e.venue_id = v.id
    WHERE e.status = 'published'
      -- Requerir que haya coordenadas disponibles (evento, venue o ciudad)
      AND (e.lat IS NOT NULL OR v.lat IS NOT NULL OR c.lat IS NOT NULL)
      AND (e.lng IS NOT NULL OR v.lng IS NOT NULL OR c.lng IS NOT NULL)
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
    ewd.distance_km,
    -- Incluir coordenadas en el resultado
    ewd.lat,
    ewd.lng,
    ewd.category_ids,
    ewd.category_names,
    ewd.category_icons,
    ewd.category_colors
  FROM events_with_distance ewd
  WHERE ewd.distance_km <= p_radius_km
  ORDER BY ewd.distance_km ASC, ewd.starts_at ASC;
END;
$$;

-- Paso 3: Verificar que la migración se aplicó correctamente
DO $$
BEGIN
  IF EXISTS (
    SELECT 1 
    FROM information_schema.routines 
    WHERE routine_schema = 'public' 
    AND routine_name = 'events_within_radius'
    AND routine_type = 'FUNCTION'
  ) THEN
    -- Verificar que la función retorna lat y lng
    IF EXISTS (
      SELECT 1
      FROM information_schema.parameters
      WHERE specific_schema = 'public'
      AND specific_name = (
        SELECT specific_name
        FROM information_schema.routines
        WHERE routine_schema = 'public'
        AND routine_name = 'events_within_radius'
        AND routine_type = 'FUNCTION'
        LIMIT 1
      )
      AND parameter_name = 'lat'
    ) THEN
      RAISE NOTICE '✅ Función events_within_radius actualizada correctamente con campos lat/lng';
    ELSE
      RAISE EXCEPTION '❌ Error: La función events_within_radius no incluye el campo lat';
    END IF;
  ELSE
    RAISE EXCEPTION '❌ Error: La función events_within_radius no existe';
  END IF;
END $$;

COMMENT ON FUNCTION public.events_within_radius(double precision, double precision, double precision) IS 'Retorna eventos dentro de un radio especificado, incluyendo coordenadas lat/lng del evento (prioridad: evento > venue > ciudad) y distancia calculada usando esas coordenadas.';
