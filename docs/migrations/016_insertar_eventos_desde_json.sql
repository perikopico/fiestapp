-- Migración 016: Insertar eventos desde JSON
-- Ejecutar en Supabase SQL Editor
-- 
-- Este script inserta eventos desde un JSON generado por Gemini.
-- Para cada evento, asigna automáticamente una imagen aleatoria de sample-images
-- según su categoría.
--
-- IMPORTANTE: Antes de ejecutar este script, debes:
-- 1. Reemplazar {SUPABASE_STORAGE_URL} con tu URL de Supabase Storage
--    Ejemplo: https://xxxxx.supabase.co/storage/v1/object/public
-- 2. Pasar los eventos JSON al script de generación

-- ============================================
-- 1. CONFIGURACIÓN: URL BASE DE SUPABASE STORAGE
-- ============================================
-- IMPORTANTE: Reemplaza esta variable con tu URL real
DO $$
DECLARE
  v_supabase_storage_url TEXT := '{SUPABASE_STORAGE_URL}';
  -- Ejemplo: 'https://xxxxx.supabase.co/storage/v1/object/public'
BEGIN
  -- Esta variable se usará en la función
  -- Si prefieres hardcodearla, cámbiala aquí
END $$;

-- ============================================
-- 2. FUNCIÓN PARA OBTENER IMAGEN ALEATORIA POR CATEGORÍA
-- ============================================
-- Esta función genera una URL aleatoria basándose en los nombres de archivo
-- Formato: 01.webp, 02.webp, 03.webp, etc.
--
-- Número de imágenes por categoría:
--   Categoría 1 (Música): 01-10 (10 imágenes)
--   Categoría 2 (Gastronomía): 01-14 (14 imágenes)
--   Categoría 3 (Deportes): 01-16 (16 imágenes)
--   Categoría 4 (Arte y Cultura): 01-09 (9 imágenes)
--   Categoría 5 (Aire Libre): 01-10 (10 imágenes)
--   Categoría 6 (Tradiciones): 01-09 (9 imágenes)
--   Categoría 7 (Mercadillos): 01-10 (10 imágenes)

CREATE OR REPLACE FUNCTION get_random_sample_image_url(
  category_slug TEXT,
  province_id INT DEFAULT 1,
  supabase_storage_url TEXT DEFAULT NULL
)
RETURNS TEXT AS $$
DECLARE
  category_num INT;
  max_image_num INT;
  random_num INT;
  image_filename TEXT;
  image_url TEXT;
BEGIN
  -- Mapear slug a número de carpeta y máximo de imágenes
  category_num := CASE category_slug
    WHEN 'musica' THEN 1
    WHEN 'gastronomia' THEN 2
    WHEN 'deportes' THEN 3
    WHEN 'arte-y-cultura' THEN 4
    WHEN 'aire-libre' THEN 5
    WHEN 'tradiciones' THEN 6
    WHEN 'mercadillos' THEN 7
    ELSE NULL
  END;
  
  IF category_num IS NULL THEN
    RETURN NULL;
  END IF;
  
  -- Determinar el máximo número de imagen según la categoría
  max_image_num := CASE category_num
    WHEN 1 THEN 10  -- Música: 01-10
    WHEN 2 THEN 14  -- Gastronomía: 01-14
    WHEN 3 THEN 16  -- Deportes: 01-16
    WHEN 4 THEN 9   -- Arte y Cultura: 01-09
    WHEN 5 THEN 10  -- Aire Libre: 01-10
    WHEN 6 THEN 9   -- Tradiciones: 01-09
    WHEN 7 THEN 10  -- Mercadillos: 01-10
    ELSE NULL
  END;
  
  -- Seleccionar un número aleatorio entre 1 y max_image_num
  random_num := 1 + floor(random() * max_image_num)::INT;
  
  -- Formatear el número con padding (01, 02, 03, etc.)
  image_filename := LPAD(random_num::TEXT, 2, '0') || '.webp';
  
  -- Construir la URL completa
  IF supabase_storage_url IS NOT NULL AND supabase_storage_url != '{SUPABASE_STORAGE_URL}' THEN
    image_url := supabase_storage_url || '/sample-images/' || province_id::TEXT || '/' || category_num::TEXT || '/' || image_filename;
  ELSE
    -- Si no se proporciona URL, retornar solo la ruta relativa
    -- (se construirá después con la URL real)
    image_url := 'sample-images/' || province_id::TEXT || '/' || category_num::TEXT || '/' || image_filename;
  END IF;
  
  RETURN image_url;
END;
$$ LANGUAGE plpgsql;

-- ============================================
-- 3. INSERTAR EVENTOS
-- ============================================
-- Los INSERTs se generarán aquí después de recibir el JSON
-- 
-- Estructura esperada del JSON:
-- [
--   {
--     "title": "Título del evento",
--     "city": "Barbate",  // Nombre de la ciudad (debe existir en BD)
--     "category": "Música",  // Nombre o slug de categoría
--     "place": "Lugar del evento",
--     "starts_at": "2025-03-15T20:30:00Z",  // ISO 8601
--     "is_free": true,
--     "is_featured": false,
--     "description": "Descripción opcional",
--     "maps_url": "https://maps.google.com/...",  // Opcional
--     "status": "published"  // Opcional, default: 'published'
--   },
--   ...
-- ]

-- ============================================
-- NOTA: Los INSERTs se generarán automáticamente cuando proporciones el JSON
-- ============================================

-- Ejemplo de uso de la función:
-- SELECT get_random_sample_image_url('musica', 1, 'https://xxxxx.supabase.co/storage/v1/object/public');
-- Devuelve: https://xxxxx.supabase.co/storage/v1/object/public/sample-images/1/1/05.webp (número aleatorio)

-- Para probar la función con diferentes categorías:
-- SELECT 
--   'musica' as categoria,
--   get_random_sample_image_url('musica', 1, 'https://xxxxx.supabase.co/storage/v1/object/public') as imagen_url
-- UNION ALL
-- SELECT 
--   'gastronomia' as categoria,
--   get_random_sample_image_url('gastronomia', 1, 'https://xxxxx.supabase.co/storage/v1/object/public') as imagen_url;
