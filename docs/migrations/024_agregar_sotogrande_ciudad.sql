-- ============================================
-- Migración 024: Agregar Sotogrande como ciudad
-- ============================================
-- Sotogrande es un lugar distintivo y reconocido, con muchos eventos
-- de alto nivel. Aunque técnicamente está en el municipio de San Roque,
-- tiene suficiente identidad propia para ser tratado como ciudad separada.
--
-- Coordenadas aproximadas: 36.29°N, 5.30°W
-- Región: Campo de Gibraltar / Costa del Sol
-- ============================================

DO $$
DECLARE
  cadiz_id INTEGER;
BEGIN
  -- Obtener el ID de la provincia de Cádiz
  SELECT id INTO cadiz_id FROM public.provinces WHERE slug = 'cadiz' LIMIT 1;
  
  IF cadiz_id IS NULL THEN
    RAISE EXCEPTION 'Error: No se pudo encontrar la provincia de Cádiz';
  END IF;
  
  -- Insertar Sotogrande
  INSERT INTO public.cities (slug, name, province_id, region, lat, lng, lat_min, lat_max, lng_min, lng_max)
  VALUES (
    'sotogrande',
    'Sotogrande',
    cadiz_id,
    'CAMPO DE GIBRALTAR',
    36.29,
    -5.30,
    36.25,
    36.33,
    -5.35,
    -5.25
  )
  ON CONFLICT (slug) DO UPDATE SET
    name = EXCLUDED.name,
    province_id = EXCLUDED.province_id,
    region = EXCLUDED.region,
    lat = EXCLUDED.lat,
    lng = EXCLUDED.lng,
    lat_min = EXCLUDED.lat_min,
    lat_max = EXCLUDED.lat_max,
    lng_min = EXCLUDED.lng_min,
    lng_max = EXCLUDED.lng_max;
  
  RAISE NOTICE 'Sotogrande agregada/actualizada como ciudad';
END $$;
