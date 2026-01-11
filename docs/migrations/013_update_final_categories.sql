-- Migración 013: Actualizar categorías finales de la aplicación
-- Ejecutar en Supabase SQL Editor
-- 
-- Esta migración actualiza/inserta las 7 categorías finales que se usarán en la app:
-- 1. MÚSICA
-- 2. GASTRONOMÍA
-- 3. DEPORTES
-- 4. ARTE Y CULTURA
-- 5. AIRE LIBRE
-- 6. TRADICIONES
-- 7. MERCADILLOS

-- ============================================
-- 1. Limpiar categorías antiguas (opcional - comentado por seguridad)
-- ============================================
-- NOTA: Descomenta esto solo si quieres eliminar todas las categorías antiguas
-- y empezar desde cero. Si tienes eventos asociados, NO ejecutes esto.
-- DELETE FROM public.categories WHERE slug NOT IN (
--   'musica', 'gastronomia', 'deportes', 'arte-y-cultura', 
--   'aire-libre', 'tradiciones', 'mercadillos'
-- );

-- ============================================
-- 2. Insertar/Actualizar categorías finales usando UPSERT
-- ============================================
-- Usamos INSERT ... ON CONFLICT para actualizar si existe o insertar si no existe

-- 1. MÚSICA
INSERT INTO public.categories (slug, name, icon, color)
VALUES (
  'musica',
  'Música',
  'music_note',
  '#9C27B0'
)
ON CONFLICT (slug) DO UPDATE SET
  name = EXCLUDED.name,
  icon = EXCLUDED.icon,
  color = EXCLUDED.color;

-- 2. GASTRONOMÍA
INSERT INTO public.categories (slug, name, icon, color)
VALUES (
  'gastronomia',
  'Gastronomía',
  'restaurant',
  '#FF6F00'
)
ON CONFLICT (slug) DO UPDATE SET
  name = EXCLUDED.name,
  icon = EXCLUDED.icon,
  color = EXCLUDED.color;

-- 3. DEPORTES
INSERT INTO public.categories (slug, name, icon, color)
VALUES (
  'deportes',
  'Deportes',
  'sports_soccer',
  '#4CAF50'
)
ON CONFLICT (slug) DO UPDATE SET
  name = EXCLUDED.name,
  icon = EXCLUDED.icon,
  color = EXCLUDED.color;

-- 4. ARTE Y CULTURA
INSERT INTO public.categories (slug, name, icon, color)
VALUES (
  'arte-y-cultura',
  'Arte y Cultura',
  'palette',
  '#2196F3'
)
ON CONFLICT (slug) DO UPDATE SET
  name = EXCLUDED.name,
  icon = EXCLUDED.icon,
  color = EXCLUDED.color;

-- 5. AIRE LIBRE
INSERT INTO public.categories (slug, name, icon, color)
VALUES (
  'aire-libre',
  'Aire Libre',
  'hiking',
  '#00BCD4'
)
ON CONFLICT (slug) DO UPDATE SET
  name = EXCLUDED.name,
  icon = EXCLUDED.icon,
  color = EXCLUDED.color;

-- 6. TRADICIONES
INSERT INTO public.categories (slug, name, icon, color)
VALUES (
  'tradiciones',
  'Tradiciones',
  'festival',
  '#E91E63'
)
ON CONFLICT (slug) DO UPDATE SET
  name = EXCLUDED.name,
  icon = EXCLUDED.icon,
  color = EXCLUDED.color;

-- 7. MERCADILLOS
INSERT INTO public.categories (slug, name, icon, color)
VALUES (
  'mercadillos',
  'Mercadillos',
  'storefront',
  '#FF9800'
)
ON CONFLICT (slug) DO UPDATE SET
  name = EXCLUDED.name,
  icon = EXCLUDED.icon,
  color = EXCLUDED.color;

-- ============================================
-- 3. Verificación - Comprobar que todas las categorías se insertaron correctamente
-- ============================================
SELECT 
  id,
  slug,
  name,
  icon,
  color
FROM public.categories
WHERE slug IN (
  'musica', 'gastronomia', 'deportes', 'arte-y-cultura',
  'aire-libre', 'tradiciones', 'mercadillos'
)
ORDER BY 
  CASE slug
    WHEN 'musica' THEN 1
    WHEN 'gastronomia' THEN 2
    WHEN 'deportes' THEN 3
    WHEN 'arte-y-cultura' THEN 4
    WHEN 'aire-libre' THEN 5
    WHEN 'tradiciones' THEN 6
    WHEN 'mercadillos' THEN 7
  END;

-- ============================================
-- 4. Comentarios finales
-- ============================================
COMMENT ON TABLE public.categories IS 'Categorías de eventos de la aplicación - Versión final 7 categorías';
