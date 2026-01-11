-- Migración 014: Limpiar eventos de prueba y sus relaciones
-- ⚠️ ADVERTENCIA: Este script eliminará TODOS los eventos de la base de datos
-- Ejecutar en Supabase SQL Editor
-- 
-- INSTRUCCIONES:
-- 1. Ejecuta primero la sección de VERIFICACIÓN para ver qué se va a eliminar
-- 2. Si estás seguro, ejecuta la sección de LIMPIEZA
-- 3. Después elimina las imágenes manualmente desde Storage (bucket: event-images)

-- ============================================
-- 1. VERIFICACIÓN - Ver qué se va a eliminar
-- ============================================
-- Ejecuta esta sección primero para ver qué eventos existen

-- Contar eventos totales
SELECT 
  'TOTAL DE EVENTOS' as tipo,
  COUNT(*) as cantidad
FROM public.events;

-- Ver todos los eventos con información básica
SELECT 
  id,
  title,
  place,
  city_id,
  category_id,
  starts_at,
  image_url,
  created_at,
  status
FROM public.events
ORDER BY created_at DESC;

-- Contar favoritos asociados
SELECT 
  'TOTAL DE FAVORITOS' as tipo,
  COUNT(*) as cantidad
FROM public.user_favorites;

-- Ver relaciones de favoritos
SELECT 
  uf.id as favorito_id,
  uf.user_id,
  e.id as event_id,
  e.title as event_title
FROM public.user_favorites uf
LEFT JOIN public.events e ON uf.event_id = e.id
ORDER BY uf.created_at DESC;

-- Listar URLs de imágenes (necesarias para limpiar Storage después)
SELECT 
  id,
  title,
  image_url,
  CASE 
    WHEN image_url IS NULL OR image_url = '' THEN 'Sin imagen'
    WHEN image_url LIKE '%event-images%' THEN 'Imagen en Storage'
    ELSE 'Imagen externa'
  END as tipo_imagen
FROM public.events
WHERE image_url IS NOT NULL 
  AND image_url != ''
ORDER BY created_at DESC;

-- ============================================
-- 2. LIMPIEZA - Eliminar eventos y relaciones
-- ============================================
-- ⚠️ SOLO EJECUTA ESTO DESPUÉS DE REVISAR LA SECCIÓN DE VERIFICACIÓN
-- ⚠️ ESTO ES IRREVERSIBLE (a menos que tengas backup)

BEGIN;

-- 2.1. Eliminar todos los favoritos asociados a eventos
-- Esto es necesario porque hay una relación de foreign key con CASCADE
DELETE FROM public.user_favorites;

-- Verificar que se eliminaron los favoritos
DO $$
DECLARE
  favoritos_restantes INTEGER;
BEGIN
  SELECT COUNT(*) INTO favoritos_restantes FROM public.user_favorites;
  IF favoritos_restantes > 0 THEN
    RAISE NOTICE '⚠️ Quedan % favoritos', favoritos_restantes;
  ELSE
    RAISE NOTICE '✅ Todos los favoritos eliminados correctamente';
  END IF;
END $$;

-- 2.2. Eliminar todos los eventos
-- Esto también eliminará automáticamente cualquier relación en cascada
DELETE FROM public.events;

-- Verificar que se eliminaron todos los eventos
DO $$
DECLARE
  eventos_restantes INTEGER;
BEGIN
  SELECT COUNT(*) INTO eventos_restantes FROM public.events;
  IF eventos_restantes > 0 THEN
    RAISE NOTICE '⚠️ Quedan % eventos', eventos_restantes;
  ELSE
    RAISE NOTICE '✅ Todos los eventos eliminados correctamente';
  END IF;
END $$;

-- 2.3. Verificar que categorías y ciudades siguen intactas
DO $$
DECLARE
  categorias_count INTEGER;
  ciudades_count INTEGER;
BEGIN
  SELECT COUNT(*) INTO categorias_count FROM public.categories;
  SELECT COUNT(*) INTO ciudades_count FROM public.cities;
  
  RAISE NOTICE '✅ Categorías restantes: %', categorias_count;
  RAISE NOTICE '✅ Ciudades restantes: %', ciudades_count;
  
  IF categorias_count = 0 THEN
    RAISE WARNING '⚠️ No hay categorías en la base de datos';
  END IF;
  
  IF ciudades_count = 0 THEN
    RAISE WARNING '⚠️ No hay ciudades en la base de datos';
  END IF;
END $$;

COMMIT;

-- ============================================
-- 3. VERIFICACIÓN FINAL
-- ============================================
-- Ejecuta esto después de la limpieza para verificar

SELECT 
  'Eventos restantes' as tipo,
  COUNT(*) as cantidad
FROM public.events
UNION ALL
SELECT 
  'Favoritos restantes' as tipo,
  COUNT(*) as cantidad
FROM public.user_favorites
UNION ALL
SELECT 
  'Categorías (no se eliminan)' as tipo,
  COUNT(*) as cantidad
FROM public.categories
UNION ALL
SELECT 
  'Ciudades (no se eliminan)' as tipo,
  COUNT(*) as cantidad
FROM public.cities;

-- ============================================
-- 4. NOTAS IMPORTANTES
-- ============================================
-- 
-- DESPUÉS DE EJECUTAR ESTE SCRIPT:
-- 
-- 1. Las imágenes NO se eliminan automáticamente
--    Debes eliminarlas manualmente desde Supabase Storage:
--    - Ve a Storage → bucket "event-images"
--    - Selecciona todas las imágenes
--    - Haz clic en Delete
-- 
-- 2. Las categorías y ciudades NO se eliminan
--    Estas son tablas de referencia que se mantienen
-- 
-- 3. Los usuarios NO se ven afectados
--    Solo se eliminan eventos y favoritos
-- 
-- 4. Si necesitas restaurar, solo es posible si:
--    - Hiciste un backup antes de ejecutar
--    - Tienes un dump de la base de datos
-- 
-- ============================================
-- 5. RESTAURAR DESDE BACKUP (Si es necesario)
-- ============================================
-- Si hiciste un backup y necesitas restaurar:
-- 
-- CREATE TABLE IF NOT EXISTS events_backup AS
-- SELECT * FROM public.events;
-- 
-- -- Para restaurar:
-- -- INSERT INTO public.events SELECT * FROM events_backup;
-- 
-- ============================================
