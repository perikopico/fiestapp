-- Script de reparación: Recrear funciones get_popular_events que fueron eliminadas
-- Ejecutar este script si las funciones no existen después de la migración 028

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
