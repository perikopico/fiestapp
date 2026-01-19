
-- Migración 031: Crear tabla event_categories para soportar múltiples categorías por evento
-- Esta migración permite que un evento tenga 1-2 categorías asociadas
-- La categoría principal se mantiene en events.category_id para compatibilidad

-- Paso 1: Crear tabla de relación event_categories
CREATE TABLE IF NOT EXISTS public.event_categories (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  event_id uuid NOT NULL REFERENCES public.events(id) ON DELETE CASCADE,
  category_id int8 NOT NULL REFERENCES public.categories(id) ON DELETE CASCADE,
  is_primary boolean DEFAULT false, -- true si es la categoría principal
  created_at timestamptz DEFAULT now(),
  
  -- Un evento no puede tener la misma categoría dos veces
  UNIQUE(event_id, category_id)
);

-- Paso 2: Crear índices para mejorar rendimiento
CREATE INDEX IF NOT EXISTS idx_event_categories_event_id 
ON public.event_categories(event_id);

CREATE INDEX IF NOT EXISTS idx_event_categories_category_id 
ON public.event_categories(category_id);

-- Paso 3: Migrar datos existentes (opcional)
-- Esta parte puede ejecutarse después para migrar eventos existentes
-- Por ahora, solo creamos la tabla para soportar futuros eventos con múltiples categorías

-- NOTA: La categoría principal seguirá estando en events.category_id para compatibilidad
-- Las categorías adicionales se guardarán en event_categories

COMMENT ON TABLE public.event_categories IS 'Tabla de relación many-to-many entre eventos y categorías. Permite que un evento tenga 1-2 categorías asociadas.';
COMMENT ON COLUMN public.event_categories.is_primary IS 'Indica si esta es la categoría principal (debe coincidir con events.category_id)';
