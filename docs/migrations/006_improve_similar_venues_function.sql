-- Migración: Mejorar función de búsqueda de lugares similares
-- Ejecutar en Supabase SQL Editor
-- Fecha: Diciembre 2024

-- ============================================
-- Mejorar función find_similar_venues
-- ============================================
-- Esta versión mejorada:
-- 1. Elimina palabras comunes antes de comparar (restaurante, pub, bar, etc.)
-- 2. Normaliza los textos (minúsculas, elimina acentos)
-- 3. Compara solo las partes significativas del nombre
-- 4. Detecta similitudes reales incluso con typos (ej: "essencia" vs "esencia")

CREATE OR REPLACE FUNCTION public.normalize_venue_name(p_name text)
RETURNS text AS $$
DECLARE
  result text;
  common_words text[] := ARRAY[
    'restaurante', 'restaurantes',
    'bar', 'bars',
    'pub', 'pubs',
    'café', 'cafe', 'cafetería', 'cafeteria',
    'taberna', 'tabernas',
    'mesón', 'mesones', 'meson',
    'bodega', 'bodegas',
    'el', 'la', 'los', 'las', 'de', 'del', 'y', 'e'
  ];
  word text;
BEGIN
  -- Convertir a minúsculas y normalizar
  result := lower(trim(p_name));
  
  -- Eliminar acentos y caracteres especiales comunes
  result := translate(result, 'áéíóúÁÉÍÓÚñÑ', 'aeiouAEIOUnN');
  
  -- Eliminar signos de puntuación comunes que no aportan significado
  result := regexp_replace(result, '[.,;:!?\-()\[\]{}"]', ' ', 'g');
  
  -- Normalizar espacios múltiples a uno solo
  result := regexp_replace(result, '\s+', ' ', 'g');
  
  -- Eliminar palabras comunes al inicio, medio y final
  FOREACH word IN ARRAY common_words
  LOOP
    -- Eliminar al inicio (con espacio después)
    result := regexp_replace(result, '^' || word || '\s+', '', 'gi');
    -- Eliminar en el medio (con espacios antes y después)
    result := regexp_replace(result, '\s+' || word || '\s+', ' ', 'gi');
    -- Eliminar al final (con espacio antes)
    result := regexp_replace(result, '\s+' || word || '$', '', 'gi');
  END LOOP;
  
  -- Eliminar espacios extra y trim final
  result := trim(regexp_replace(result, '\s+', ' ', 'g'));
  
  RETURN result;
END;
$$ LANGUAGE plpgsql IMMUTABLE;

-- Función mejorada para buscar lugares similares
CREATE OR REPLACE FUNCTION public.find_similar_venues(
  p_name text,
  p_city_id int8
)
RETURNS TABLE (
  id uuid,
  name text,
  city_id int8,
  similarity real
) AS $$
DECLARE
  normalized_input text;
  normalized_db text;
  original_similarity real;
  normalized_similarity real;
  final_similarity real;
BEGIN
  -- Normalizar el nombre de entrada
  normalized_input := public.normalize_venue_name(p_name);
  
  -- Si después de normalizar queda muy poco, usar el nombre original normalizado
  -- (para evitar perder información en nombres muy cortos)
  IF length(normalized_input) < 3 THEN
    normalized_input := lower(trim(p_name));
  END IF;
  
  RETURN QUERY
  SELECT 
    v.id,
    v.name,
    v.city_id,
    -- Calcular similitud combinada
    (
      SELECT GREATEST(
        -- 1. Comparación exacta normalizada (100% si es idéntico)
        CASE 
          WHEN public.normalize_venue_name(v.name) = normalized_input THEN 1.0
          ELSE 0.0
        END,
        -- 2. Comparación normalizada con similarity (ignora palabras comunes)
        CASE 
          WHEN length(normalized_input) >= 3 AND length(public.normalize_venue_name(v.name)) >= 3 THEN
            similarity(public.normalize_venue_name(v.name), normalized_input)
          ELSE 0.0
        END,
        -- 3. Comparación original con similarity (detecta typos como "essencia" vs "esencia")
        similarity(lower(trim(v.name)), lower(trim(p_name)))
      )
    ) as similarity
  FROM public.venues v
  WHERE v.city_id = p_city_id
    AND v.status IN ('approved', 'pending')
    AND (
      -- Comparación normalizada (ignorando palabras comunes)
      (length(normalized_input) >= 3 AND 
       length(public.normalize_venue_name(v.name)) >= 3 AND
       similarity(public.normalize_venue_name(v.name), normalized_input) > 0.4)
      OR
      -- Comparación original (para detectar typos cercanos)
      (similarity(lower(trim(v.name)), lower(trim(p_name))) > 0.5)
      OR
      -- Coincidencia exacta normalizada
      (public.normalize_venue_name(v.name) = normalized_input)
    )
  ORDER BY similarity DESC
  LIMIT 5;
END;
$$ LANGUAGE plpgsql;

-- Comentarios
COMMENT ON FUNCTION public.normalize_venue_name IS 'Normaliza nombres de lugares eliminando palabras comunes y normalizando el texto para comparación';
COMMENT ON FUNCTION public.find_similar_venues IS 'Busca lugares similares usando normalización inteligente que ignora palabras comunes como "restaurante", "pub", etc.';

