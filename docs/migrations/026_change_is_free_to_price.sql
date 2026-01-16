-- ============================================
-- Migración 026: Cambiar is_free a price
-- ============================================
-- Esta migración cambia el campo is_free (boolean) por price (text)
-- para poder almacenar valores como "Gratis", "18€", "Desde 10€", etc.
-- ============================================

-- Paso 1: Agregar el nuevo campo price como text nullable
ALTER TABLE public.events 
ADD COLUMN IF NOT EXISTS price text;

-- Paso 2: Migrar los datos existentes: convertir true -> 'Gratis', false -> null
-- (null indicará que no está definido o que hay que consultar el precio)
UPDATE public.events 
SET price = CASE 
  WHEN is_free = true THEN 'Gratis'
  WHEN is_free = false THEN NULL
  ELSE NULL
END;

-- Paso 3: Eliminar dependencias que usan is_free antes de eliminar la columna
-- Primero eliminamos las funciones que dependen de la vista
DROP FUNCTION IF EXISTS public.get_popular_events_this_week(integer) CASCADE;
DROP FUNCTION IF EXISTS public.get_popular_events(bigint, integer) CASCADE;

-- Luego eliminamos la vista events_view (se recreará después con el nuevo esquema)
DROP VIEW IF EXISTS public.events_view CASCADE;

-- Paso 4: Eliminar la columna antigua is_free
ALTER TABLE public.events 
DROP COLUMN IF EXISTS is_free;

-- Paso 5: Recrear la vista events_view con el nuevo esquema (usa price en lugar de is_free)
-- La vista usa events.*, así que automáticamente incluirá price
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

-- Paso 6: Recrear las funciones que dependían de la vista
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

-- Verificar que la migración se aplicó correctamente
DO $$
BEGIN
  IF EXISTS (
    SELECT 1 
    FROM information_schema.columns 
    WHERE table_schema = 'public' 
    AND table_name = 'events' 
    AND column_name = 'price'
  ) THEN
    RAISE NOTICE '✅ Campo price agregado correctamente a la tabla events';
  ELSE
    RAISE EXCEPTION '❌ Error: El campo price no se agregó correctamente';
  END IF;
  
  IF NOT EXISTS (
    SELECT 1 
    FROM information_schema.columns 
    WHERE table_schema = 'public' 
    AND table_name = 'events' 
    AND column_name = 'is_free'
  ) THEN
    RAISE NOTICE '✅ Campo is_free eliminado correctamente';
  ELSE
    RAISE WARNING '⚠️ El campo is_free todavía existe';
  END IF;
END $$;
