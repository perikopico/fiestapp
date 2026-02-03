-- Migración 032: Agregar soporte para múltiples categorías en vistas y funciones
-- Esta migración actualiza events_view y funciones relacionadas para incluir
-- arrays con las categorías secundarias (además de la principal)

-- Paso 1: Eliminar funciones que dependen de events_view
DROP FUNCTION IF EXISTS public.get_popular_events_this_week(integer) CASCADE;
DROP FUNCTION IF EXISTS public.get_popular_events(bigint, integer) CASCADE;

-- Paso 2: Eliminar y recrear events_view con soporte para categorías múltiples
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
  -- Usamos subconsulta para ordenar antes de agregar, ya que DISTINCT con ORDER BY requiere que las expresiones estén en la lista
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

-- Paso 3: Recrear función get_popular_events_this_week
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

-- Paso 4: Recrear función get_popular_events
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

-- Paso 5: Actualizar función events_within_radius para incluir categorías múltiples
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
  distance_km double precision,
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
      -- Calcular distancia usando la fórmula de Haversine
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
    ewd.distance_km,
    ewd.category_ids,
    ewd.category_names,
    ewd.category_icons,
    ewd.category_colors
  FROM events_with_distance ewd
  WHERE ewd.distance_km <= p_radius_km
  ORDER BY ewd.distance_km ASC, ewd.starts_at ASC;
END;
$$;

-- Paso 6: Migrar datos existentes: sincronizar event_categories con events.category_id
-- Esto asegura que todos los eventos existentes tengan su categoría principal en event_categories
INSERT INTO public.event_categories (event_id, category_id, is_primary)
SELECT 
  e.id as event_id,
  e.category_id,
  true as is_primary
FROM public.events e
WHERE e.category_id IS NOT NULL
  AND NOT EXISTS (
    SELECT 1 
    FROM public.event_categories ec 
    WHERE ec.event_id = e.id 
      AND ec.category_id = e.category_id
  )
ON CONFLICT (event_id, category_id) DO NOTHING;

-- Verificar que la migración se aplicó correctamente
DO $$
BEGIN
  IF EXISTS (
    SELECT 1 
    FROM information_schema.columns 
    WHERE table_schema = 'public' 
    AND table_name = 'events_view' 
    AND column_name = 'category_ids'
  ) THEN
    RAISE NOTICE '✅ Vista events_view actualizada correctamente con soporte para categorías múltiples';
  ELSE
    RAISE EXCEPTION '❌ Error: La vista events_view no se actualizó correctamente';
  END IF;
END $$;

COMMENT ON VIEW public.events_view IS 'Vista de eventos con soporte para categorías múltiples (1-2 categorías por evento). Incluye arrays category_ids, category_names, category_icons y category_colors.';
