-- Añadir columna image_alignment a la tabla events
-- Ejecutar en Supabase SQL Editor
--
-- Este script añade una columna para controlar el alineamiento de la imagen
-- en las tarjetas de eventos (top, center, bottom).

ALTER TABLE public.events
ADD COLUMN IF NOT EXISTS image_alignment text NOT NULL DEFAULT 'center';

-- Nota: Si usas una vista events_view, también necesitarás actualizarla
-- para incluir esta columna:
--
-- CREATE OR REPLACE VIEW events_view AS
-- SELECT 
--   e.*,
--   c.name as city_name,
--   cat.name as category_name,
--   cat.icon as category_icon,
--   cat.color as category_color
-- FROM events e
-- LEFT JOIN cities c ON e.city_id = c.id
-- LEFT JOIN categories cat ON e.category_id = cat.id;

