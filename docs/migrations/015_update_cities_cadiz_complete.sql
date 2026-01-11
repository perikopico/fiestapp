-- Migración 015: Actualizar ciudades con todas las ciudades de la provincia de Cádiz
-- Ejecutar en Supabase SQL Editor
-- 
-- Esta migración:
-- 1. Crea/verifica la tabla provinces si no existe
-- 2. Inserta Cádiz como provincia si no existe
-- 3. Actualiza la tabla cities con campos necesarios (region, límites geográficos)
-- 4. Inserta/actualiza todas las ciudades de Cádiz con sus límites geográficos
--
-- IMPORTANTE: Las coordenadas y límites son aproximados y deberán ajustarse según necesidades

-- ============================================
-- 1. CREAR TABLA PROVINCES SI NO EXISTE
-- ============================================
CREATE TABLE IF NOT EXISTS public.provinces (
  id SERIAL PRIMARY KEY,
  name TEXT NOT NULL,
  slug TEXT UNIQUE NOT NULL,
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

-- ============================================
-- 2. INSERTAR CÁDIZ COMO PROVINCIA
-- ============================================
INSERT INTO public.provinces (name, slug)
VALUES ('Cádiz', 'cadiz')
ON CONFLICT (slug) DO NOTHING;

-- Obtener el ID de Cádiz (lo necesitamos para las ciudades)
DO $$
DECLARE
  cadiz_province_id INTEGER;
BEGIN
  SELECT id INTO cadiz_province_id FROM public.provinces WHERE slug = 'cadiz';
  
  IF cadiz_province_id IS NULL THEN
    RAISE EXCEPTION 'Error: No se pudo encontrar la provincia de Cádiz';
  END IF;
  
  RAISE NOTICE 'Provincia de Cádiz tiene ID: %', cadiz_province_id;
END $$;

-- ============================================
-- 3. ACTUALIZAR TABLA CITIES CON CAMPOS NECESARIOS
-- ============================================
-- Agregar campos si no existen
DO $$
BEGIN
  -- Agregar province_id si no existe
  IF NOT EXISTS (SELECT 1 FROM information_schema.columns 
                 WHERE table_schema = 'public' 
                 AND table_name = 'cities' 
                 AND column_name = 'province_id') THEN
    ALTER TABLE public.cities 
    ADD COLUMN province_id INTEGER REFERENCES public.provinces(id);
  END IF;

  -- Agregar region si no existe
  IF NOT EXISTS (SELECT 1 FROM information_schema.columns 
                 WHERE table_schema = 'public' 
                 AND table_name = 'cities' 
                 AND column_name = 'region') THEN
    ALTER TABLE public.cities 
    ADD COLUMN region TEXT;
  END IF;

  -- Agregar lat (coordenada central de la ciudad)
  IF NOT EXISTS (SELECT 1 FROM information_schema.columns 
                 WHERE table_schema = 'public' 
                 AND table_name = 'cities' 
                 AND column_name = 'lat') THEN
    ALTER TABLE public.cities 
    ADD COLUMN lat DOUBLE PRECISION;
  END IF;

  -- Agregar lng (coordenada central de la ciudad)
  IF NOT EXISTS (SELECT 1 FROM information_schema.columns 
                 WHERE table_schema = 'public' 
                 AND table_name = 'cities' 
                 AND column_name = 'lng') THEN
    ALTER TABLE public.cities 
    ADD COLUMN lng DOUBLE PRECISION;
  END IF;

  -- Agregar límites geográficos para restringir el mapa
  IF NOT EXISTS (SELECT 1 FROM information_schema.columns 
                 WHERE table_schema = 'public' 
                 AND table_name = 'cities' 
                 AND column_name = 'lat_min') THEN
    ALTER TABLE public.cities 
    ADD COLUMN lat_min DOUBLE PRECISION;
  END IF;

  IF NOT EXISTS (SELECT 1 FROM information_schema.columns 
                 WHERE table_schema = 'public' 
                 AND table_name = 'cities' 
                 AND column_name = 'lat_max') THEN
    ALTER TABLE public.cities 
    ADD COLUMN lat_max DOUBLE PRECISION;
  END IF;

  IF NOT EXISTS (SELECT 1 FROM information_schema.columns 
                 WHERE table_schema = 'public' 
                 AND table_name = 'cities' 
                 AND column_name = 'lng_min') THEN
    ALTER TABLE public.cities 
    ADD COLUMN lng_min DOUBLE PRECISION;
  END IF;

  IF NOT EXISTS (SELECT 1 FROM information_schema.columns 
                 WHERE table_schema = 'public' 
                 AND table_name = 'cities' 
                 AND column_name = 'lng_max') THEN
    ALTER TABLE public.cities 
    ADD COLUMN lng_max DOUBLE PRECISION;
  END IF;
END $$;

-- ============================================
-- 4. INSERTAR/ACTUALIZAR CIUDADES DE CÁDIZ
-- ============================================
-- NOTA: Las coordenadas y límites son aproximados
-- Deberás ajustarlos según las necesidades reales
-- Los límites son un área aproximada de ~15-20 km alrededor del centro de la ciudad

-- Obtener ID de Cádiz para usar en todas las ciudades
DO $$
DECLARE
  cadiz_id INTEGER;
BEGIN
  SELECT id INTO cadiz_id FROM public.provinces WHERE slug = 'cadiz';
  
  -- ============================================
  -- LA JANDA (Núcleo inicial)
  -- ============================================
  
  -- Barbate
  INSERT INTO public.cities (slug, name, province_id, region, lat, lng, lat_min, lat_max, lng_min, lng_max)
  VALUES (
    'barbate',
    'Barbate',
    cadiz_id,
    'LA JANDA',
    36.1927, -5.9219,
    36.1427, 36.2427, -- límites lat
    -5.9719, -5.8719  -- límites lng
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

  -- Zahara de los Atunes
  INSERT INTO public.cities (slug, name, province_id, region, lat, lng, lat_min, lat_max, lng_min, lng_max)
  VALUES (
    'zahara-de-los-atunes',
    'Zahara de los Atunes',
    cadiz_id,
    'LA JANDA',
    36.1350, -5.8467,
    36.0850, 36.1850,
    -5.8967, -5.7967
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

  -- Vejer de la Frontera
  INSERT INTO public.cities (slug, name, province_id, region, lat, lng, lat_min, lat_max, lng_min, lng_max)
  VALUES (
    'vejer-de-la-frontera',
    'Vejer de la Frontera',
    cadiz_id,
    'LA JANDA',
    36.2511, -5.9631,
    36.2011, 36.3011,
    -6.0131, -5.9131
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

  -- Conil de la Frontera
  INSERT INTO public.cities (slug, name, province_id, region, lat, lng, lat_min, lat_max, lng_min, lng_max)
  VALUES (
    'conil-de-la-frontera',
    'Conil de la Frontera',
    cadiz_id,
    'LA JANDA',
    36.2767, -6.0883,
    36.2267, 36.3267,
    -6.1383, -6.0383
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

  -- Medina Sidonia
  INSERT INTO public.cities (slug, name, province_id, region, lat, lng, lat_min, lat_max, lng_min, lng_max)
  VALUES (
    'medina-sidonia',
    'Medina Sidonia',
    cadiz_id,
    'LA JANDA',
    36.4581, -5.9278,
    36.4081, 36.5081,
    -5.9778, -5.8778
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

  -- Benalup-Casas Viejas
  INSERT INTO public.cities (slug, name, province_id, region, lat, lng, lat_min, lat_max, lng_min, lng_max)
  VALUES (
    'benalup-casas-viejas',
    'Benalup-Casas Viejas',
    cadiz_id,
    'LA JANDA',
    36.3436, -5.8086,
    36.2936, 36.3936,
    -5.8586, -5.7586
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

  -- Alcalá de los Gazules
  INSERT INTO public.cities (slug, name, province_id, region, lat, lng, lat_min, lat_max, lng_min, lng_max)
  VALUES (
    'alcala-de-los-gazules',
    'Alcalá de los Gazules',
    cadiz_id,
    'LA JANDA',
    36.4614, -5.7222,
    36.4114, 36.5114,
    -5.7722, -5.6722
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

  -- Paterna de Rivera
  INSERT INTO public.cities (slug, name, province_id, region, lat, lng, lat_min, lat_max, lng_min, lng_max)
  VALUES (
    'paterna-de-rivera',
    'Paterna de Rivera',
    cadiz_id,
    'LA JANDA',
    36.5222, -5.8667,
    36.4722, 36.5722,
    -5.9167, -5.8167
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

  RAISE NOTICE '✅ Ciudades de LA JANDA insertadas/actualizadas';
  
  -- ============================================
  -- BAHÍA DE CÁDIZ
  -- ============================================
  
  -- Cádiz
  INSERT INTO public.cities (slug, name, province_id, region, lat, lng, lat_min, lat_max, lng_min, lng_max)
  VALUES (
    'cadiz',
    'Cádiz',
    cadiz_id,
    'BAHÍA DE CÁDIZ',
    36.5270, -6.2886,
    36.4770, 36.5770,
    -6.3386, -6.2386
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

  -- Jerez de la Frontera
  INSERT INTO public.cities (slug, name, province_id, region, lat, lng, lat_min, lat_max, lng_min, lng_max)
  VALUES (
    'jerez-de-la-frontera',
    'Jerez de la Frontera',
    cadiz_id,
    'BAHÍA DE CÁDIZ',
    36.6865, -6.1370,
    36.6365, 36.7365,
    -6.1870, -6.0870
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

  -- La Barca de la Florida (Jerez) - Pedanía
  INSERT INTO public.cities (slug, name, province_id, region, lat, lng, lat_min, lat_max, lng_min, lng_max)
  VALUES (
    'la-barca-de-la-florida',
    'La Barca de la Florida',
    cadiz_id,
    'BAHÍA DE CÁDIZ',
    36.7100, -6.1200,
    36.6600, 36.7600,
    -6.1700, -6.0700
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

  -- Estella del Marqués (Jerez) - Pedanía
  INSERT INTO public.cities (slug, name, province_id, region, lat, lng, lat_min, lat_max, lng_min, lng_max)
  VALUES (
    'estella-del-marques',
    'Estella del Marqués',
    cadiz_id,
    'BAHÍA DE CÁDIZ',
    36.6950, -6.0850,
    36.6450, 36.7450,
    -6.1350, -6.0350
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

  -- Guadalcacín (Jerez) - Pedanía
  INSERT INTO public.cities (slug, name, province_id, region, lat, lng, lat_min, lat_max, lng_min, lng_max)
  VALUES (
    'guadalcacin',
    'Guadalcacín',
    cadiz_id,
    'BAHÍA DE CÁDIZ',
    36.7000, -6.1400,
    36.6500, 36.7500,
    -6.1900, -6.0900
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

  -- El Torno (Jerez) - Pedanía
  INSERT INTO public.cities (slug, name, province_id, region, lat, lng, lat_min, lat_max, lng_min, lng_max)
  VALUES (
    'el-torno',
    'El Torno',
    cadiz_id,
    'BAHÍA DE CÁDIZ',
    36.6800, -6.1550,
    36.6300, 36.7300,
    -6.2050, -6.1050
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

  -- Nueva Jarilla (Jerez) - Pedanía
  INSERT INTO public.cities (slug, name, province_id, region, lat, lng, lat_min, lat_max, lng_min, lng_max)
  VALUES (
    'nueva-jarilla',
    'Nueva Jarilla',
    cadiz_id,
    'BAHÍA DE CÁDIZ',
    36.7050, -6.1300,
    36.6550, 36.7550,
    -6.1800, -6.0800
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

  -- San Isidro del Guadalete (Jerez) - Pedanía
  INSERT INTO public.cities (slug, name, province_id, region, lat, lng, lat_min, lat_max, lng_min, lng_max)
  VALUES (
    'san-isidro-del-guadalete',
    'San Isidro del Guadalete',
    cadiz_id,
    'BAHÍA DE CÁDIZ',
    36.6900, -6.1100,
    36.6400, 36.7400,
    -6.1600, -6.0600
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

  -- Torrecera (Jerez) - Pedanía
  INSERT INTO public.cities (slug, name, province_id, region, lat, lng, lat_min, lat_max, lng_min, lng_max)
  VALUES (
    'torrecera',
    'Torrecera',
    cadiz_id,
    'BAHÍA DE CÁDIZ',
    36.6750, -6.1450,
    36.6250, 36.7250,
    -6.1950, -6.0950
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

  -- San Fernando
  INSERT INTO public.cities (slug, name, province_id, region, lat, lng, lat_min, lat_max, lng_min, lng_max)
  VALUES (
    'san-fernando',
    'San Fernando',
    cadiz_id,
    'BAHÍA DE CÁDIZ',
    36.4667, -6.2011,
    36.4167, 36.5167,
    -6.2511, -6.1511
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

  -- El Puerto de Santa María
  INSERT INTO public.cities (slug, name, province_id, region, lat, lng, lat_min, lat_max, lng_min, lng_max)
  VALUES (
    'el-puerto-de-santa-maria',
    'El Puerto de Santa María',
    cadiz_id,
    'BAHÍA DE CÁDIZ',
    36.6000, -6.2333,
    36.5500, 36.6500,
    -6.2833, -6.1833
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

  -- Chiclana de la Frontera
  INSERT INTO public.cities (slug, name, province_id, region, lat, lng, lat_min, lat_max, lng_min, lng_max)
  VALUES (
    'chiclana-de-la-frontera',
    'Chiclana de la Frontera',
    cadiz_id,
    'BAHÍA DE CÁDIZ',
    36.4192, -6.1474,
    36.3692, 36.4692,
    -6.1974, -6.0974
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

  -- Puerto Real
  INSERT INTO public.cities (slug, name, province_id, region, lat, lng, lat_min, lat_max, lng_min, lng_max)
  VALUES (
    'puerto-real',
    'Puerto Real',
    cadiz_id,
    'BAHÍA DE CÁDIZ',
    36.5283, -6.1900,
    36.4783, 36.5783,
    -6.2400, -6.1400
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

  RAISE NOTICE '✅ Ciudades de BAHÍA DE CÁDIZ insertadas/actualizadas';
  
  -- ============================================
  -- COSTA NOROESTE
  -- ============================================
  
  -- Sanlúcar de Barrameda
  INSERT INTO public.cities (slug, name, province_id, region, lat, lng, lat_min, lat_max, lng_min, lng_max)
  VALUES (
    'sanlucar-de-barrameda',
    'Sanlúcar de Barrameda',
    cadiz_id,
    'COSTA NOROESTE',
    36.7781, -6.3517,
    36.7281, 36.8281,
    -6.4017, -6.3017
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

  -- Chipiona
  INSERT INTO public.cities (slug, name, province_id, region, lat, lng, lat_min, lat_max, lng_min, lng_max)
  VALUES (
    'chipiona',
    'Chipiona',
    cadiz_id,
    'COSTA NOROESTE',
    36.7367, -6.4367,
    36.6867, 36.7867,
    -6.4867, -6.3867
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

  -- Rota
  INSERT INTO public.cities (slug, name, province_id, region, lat, lng, lat_min, lat_max, lng_min, lng_max)
  VALUES (
    'rota',
    'Rota',
    cadiz_id,
    'COSTA NOROESTE',
    36.6178, -6.3622,
    36.5678, 36.6678,
    -6.4122, -6.3122
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

  -- Trebujena
  INSERT INTO public.cities (slug, name, province_id, region, lat, lng, lat_min, lat_max, lng_min, lng_max)
  VALUES (
    'trebujena',
    'Trebujena',
    cadiz_id,
    'COSTA NOROESTE',
    36.8694, -6.1769,
    36.8194, 36.9194,
    -6.2269, -6.1269
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

  RAISE NOTICE '✅ Ciudades de COSTA NOROESTE insertadas/actualizadas';
  
  -- ============================================
  -- SIERRA DE CÁDIZ
  -- ============================================
  
  -- Arcos de la Frontera
  INSERT INTO public.cities (slug, name, province_id, region, lat, lng, lat_min, lat_max, lng_min, lng_max)
  VALUES (
    'arcos-de-la-frontera',
    'Arcos de la Frontera',
    cadiz_id,
    'SIERRA DE CÁDIZ',
    36.7511, -5.8111,
    36.7011, 36.8011,
    -5.8611, -5.7611
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

  -- Ubrique
  INSERT INTO public.cities (slug, name, province_id, region, lat, lng, lat_min, lat_max, lng_min, lng_max)
  VALUES (
    'ubrique',
    'Ubrique',
    cadiz_id,
    'SIERRA DE CÁDIZ',
    36.6781, -5.4464,
    36.6281, 36.7281,
    -5.4964, -5.3964
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

  -- Olvera
  INSERT INTO public.cities (slug, name, province_id, region, lat, lng, lat_min, lat_max, lng_min, lng_max)
  VALUES (
    'olvera',
    'Olvera',
    cadiz_id,
    'SIERRA DE CÁDIZ',
    36.9342, -5.2669,
    36.8842, 36.9842,
    -5.3169, -5.2169
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

  -- Villamartín
  INSERT INTO public.cities (slug, name, province_id, region, lat, lng, lat_min, lat_max, lng_min, lng_max)
  VALUES (
    'villamartin',
    'Villamartín',
    cadiz_id,
    'SIERRA DE CÁDIZ',
    36.8581, -5.6444,
    36.8081, 36.9081,
    -5.6944, -5.5944
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

  -- Bornos
  INSERT INTO public.cities (slug, name, province_id, region, lat, lng, lat_min, lat_max, lng_min, lng_max)
  VALUES (
    'bornos',
    'Bornos',
    cadiz_id,
    'SIERRA DE CÁDIZ',
    36.8133, -5.7394,
    36.7633, 36.8633,
    -5.7894, -5.6894
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

  -- Prado del Rey
  INSERT INTO public.cities (slug, name, province_id, region, lat, lng, lat_min, lat_max, lng_min, lng_max)
  VALUES (
    'prado-del-rey',
    'Prado del Rey',
    cadiz_id,
    'SIERRA DE CÁDIZ',
    36.7878, -5.5567,
    36.7378, 36.8378,
    -5.6067, -5.5067
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

  -- Algodonales
  INSERT INTO public.cities (slug, name, province_id, region, lat, lng, lat_min, lat_max, lng_min, lng_max)
  VALUES (
    'algodonales',
    'Algodonales',
    cadiz_id,
    'SIERRA DE CÁDIZ',
    36.8806, -5.4056,
    36.8306, 36.9306,
    -5.4556, -5.3556
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

  -- Puerto Serrano
  INSERT INTO public.cities (slug, name, province_id, region, lat, lng, lat_min, lat_max, lng_min, lng_max)
  VALUES (
    'puerto-serrano',
    'Puerto Serrano',
    cadiz_id,
    'SIERRA DE CÁDIZ',
    36.9231, -5.5428,
    36.8731, 36.9731,
    -5.5928, -5.4928
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

  -- Alcalá del Valle
  INSERT INTO public.cities (slug, name, province_id, region, lat, lng, lat_min, lat_max, lng_min, lng_max)
  VALUES (
    'alcala-del-valle',
    'Alcalá del Valle',
    cadiz_id,
    'SIERRA DE CÁDIZ',
    36.9042, -5.1714,
    36.8542, 36.9542,
    -5.2214, -5.1214
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

  -- San José del Valle
  INSERT INTO public.cities (slug, name, province_id, region, lat, lng, lat_min, lat_max, lng_min, lng_max)
  VALUES (
    'san-jose-del-valle',
    'San José del Valle',
    cadiz_id,
    'SIERRA DE CÁDIZ',
    36.6069, -5.7981,
    36.5569, 36.6569,
    -5.8481, -5.7481
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

  -- Espera
  INSERT INTO public.cities (slug, name, province_id, region, lat, lng, lat_min, lat_max, lng_min, lng_max)
  VALUES (
    'espera',
    'Espera',
    cadiz_id,
    'SIERRA DE CÁDIZ',
    36.8683, -5.8044,
    36.8183, 36.9183,
    -5.8544, -5.7544
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

  -- El Bosque
  INSERT INTO public.cities (slug, name, province_id, region, lat, lng, lat_min, lat_max, lng_min, lng_max)
  VALUES (
    'el-bosque',
    'El Bosque',
    cadiz_id,
    'SIERRA DE CÁDIZ',
    36.7581, -5.5072,
    36.7081, 36.8081,
    -5.5572, -5.4572
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

  -- Grazalema
  INSERT INTO public.cities (slug, name, province_id, region, lat, lng, lat_min, lat_max, lng_min, lng_max)
  VALUES (
    'grazalema',
    'Grazalema',
    cadiz_id,
    'SIERRA DE CÁDIZ',
    36.7581, -5.3656,
    36.7081, 36.8081,
    -5.4156, -5.3156
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

  -- Setenil de las Bodegas
  INSERT INTO public.cities (slug, name, province_id, region, lat, lng, lat_min, lat_max, lng_min, lng_max)
  VALUES (
    'setenil-de-las-bodegas',
    'Setenil de las Bodegas',
    cadiz_id,
    'SIERRA DE CÁDIZ',
    36.8633, -5.1811,
    36.8133, 36.9133,
    -5.2311, -5.1311
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

  -- Benaocaz
  INSERT INTO public.cities (slug, name, province_id, region, lat, lng, lat_min, lat_max, lng_min, lng_max)
  VALUES (
    'benaocaz',
    'Benaocaz',
    cadiz_id,
    'SIERRA DE CÁDIZ',
    36.6992, -5.4219,
    36.6492, 36.7492,
    -5.4719, -5.3719
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

  -- Villaluenga del Rosario
  INSERT INTO public.cities (slug, name, province_id, region, lat, lng, lat_min, lat_max, lng_min, lng_max)
  VALUES (
    'villaluenga-del-rosario',
    'Villaluenga del Rosario',
    cadiz_id,
    'SIERRA DE CÁDIZ',
    36.6961, -5.3856,
    36.6461, 36.7461,
    -5.4356, -5.3356
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

  -- El Gastor
  INSERT INTO public.cities (slug, name, province_id, region, lat, lng, lat_min, lat_max, lng_min, lng_max)
  VALUES (
    'el-gastor',
    'El Gastor',
    cadiz_id,
    'SIERRA DE CÁDIZ',
    36.8569, -5.3236,
    36.8069, 36.9069,
    -5.3736, -5.2736
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

  -- Zahara de la Sierra
  INSERT INTO public.cities (slug, name, province_id, region, lat, lng, lat_min, lat_max, lng_min, lng_max)
  VALUES (
    'zahara-de-la-sierra',
    'Zahara de la Sierra',
    cadiz_id,
    'SIERRA DE CÁDIZ',
    36.8406, -5.3914,
    36.7906, 36.8906,
    -5.4414, -5.3414
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

  -- Algar
  INSERT INTO public.cities (slug, name, province_id, region, lat, lng, lat_min, lat_max, lng_min, lng_max)
  VALUES (
    'algar',
    'Algar',
    cadiz_id,
    'SIERRA DE CÁDIZ',
    36.6581, -5.6567,
    36.6081, 36.7081,
    -5.7067, -5.6067
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

  -- Torre Alháquime
  INSERT INTO public.cities (slug, name, province_id, region, lat, lng, lat_min, lat_max, lng_min, lng_max)
  VALUES (
    'torre-alhaquime',
    'Torre Alháquime',
    cadiz_id,
    'SIERRA DE CÁDIZ',
    36.9156, -5.2344,
    36.8656, 36.9656,
    -5.2844, -5.1844
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

  RAISE NOTICE '✅ Ciudades de SIERRA DE CÁDIZ insertadas/actualizadas';
  
  -- ============================================
  -- CAMPO DE GIBRALTAR
  -- ============================================
  
  -- Algeciras
  INSERT INTO public.cities (slug, name, province_id, region, lat, lng, lat_min, lat_max, lng_min, lng_max)
  VALUES (
    'algeciras',
    'Algeciras',
    cadiz_id,
    'CAMPO DE GIBRALTAR',
    36.1264, -5.4503,
    36.0764, 36.1764,
    -5.5003, -5.4003
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

  -- La Línea de la Concepción
  INSERT INTO public.cities (slug, name, province_id, region, lat, lng, lat_min, lat_max, lng_min, lng_max)
  VALUES (
    'la-linea-de-la-concepcion',
    'La Línea de la Concepción',
    cadiz_id,
    'CAMPO DE GIBRALTAR',
    36.1681, -5.3478,
    36.1181, 36.2181,
    -5.3978, -5.2978
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

  -- San Roque
  INSERT INTO public.cities (slug, name, province_id, region, lat, lng, lat_min, lat_max, lng_min, lng_max)
  VALUES (
    'san-roque',
    'San Roque',
    cadiz_id,
    'CAMPO DE GIBRALTAR',
    36.2103, -5.3842,
    36.1603, 36.2603,
    -5.4342, -5.3342
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

  -- Los Barrios
  INSERT INTO public.cities (slug, name, province_id, region, lat, lng, lat_min, lat_max, lng_min, lng_max)
  VALUES (
    'los-barrios',
    'Los Barrios',
    cadiz_id,
    'CAMPO DE GIBRALTAR',
    36.1847, -5.4925,
    36.1347, 36.2347,
    -5.5425, -5.4425
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

  -- Tarifa
  INSERT INTO public.cities (slug, name, province_id, region, lat, lng, lat_min, lat_max, lng_min, lng_max)
  VALUES (
    'tarifa',
    'Tarifa',
    cadiz_id,
    'CAMPO DE GIBRALTAR',
    36.0139, -5.6044,
    35.9639, 36.0639,
    -5.6544, -5.5544
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

  -- Facinas (Tarifa) - Pedanía
  INSERT INTO public.cities (slug, name, province_id, region, lat, lng, lat_min, lat_max, lng_min, lng_max)
  VALUES (
    'facinas',
    'Facinas',
    cadiz_id,
    'CAMPO DE GIBRALTAR',
    36.1281, -5.6817,
    36.0781, 36.1781,
    -5.7317, -5.6317
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

  -- Tahivilla (Tarifa) - Pedanía
  INSERT INTO public.cities (slug, name, province_id, region, lat, lng, lat_min, lat_max, lng_min, lng_max)
  VALUES (
    'tahivilla',
    'Tahivilla',
    cadiz_id,
    'CAMPO DE GIBRALTAR',
    36.0950, -5.6400,
    36.0450, 36.1450,
    -5.6900, -5.5900
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

  -- Jimena de la Frontera
  INSERT INTO public.cities (slug, name, province_id, region, lat, lng, lat_min, lat_max, lng_min, lng_max)
  VALUES (
    'jimena-de-la-frontera',
    'Jimena de la Frontera',
    cadiz_id,
    'CAMPO DE GIBRALTAR',
    36.4333, -5.4528,
    36.3833, 36.4833,
    -5.5028, -5.4028
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

  -- San Pablo de Buceite (Jimena) - Pedanía
  INSERT INTO public.cities (slug, name, province_id, region, lat, lng, lat_min, lat_max, lng_min, lng_max)
  VALUES (
    'san-pablo-de-buceite',
    'San Pablo de Buceite',
    cadiz_id,
    'CAMPO DE GIBRALTAR',
    36.4200, -5.4300,
    36.3700, 36.4700,
    -5.4800, -5.3800
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

  -- Castellar de la Frontera
  INSERT INTO public.cities (slug, name, province_id, region, lat, lng, lat_min, lat_max, lng_min, lng_max)
  VALUES (
    'castellar-de-la-frontera',
    'Castellar de la Frontera',
    cadiz_id,
    'CAMPO DE GIBRALTAR',
    36.3153, -5.4219,
    36.2653, 36.3653,
    -5.4719, -5.3719
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

  -- San Martín del Tesorillo
  INSERT INTO public.cities (slug, name, province_id, region, lat, lng, lat_min, lat_max, lng_min, lng_max)
  VALUES (
    'san-martin-del-tesorillo',
    'San Martín del Tesorillo',
    cadiz_id,
    'CAMPO DE GIBRALTAR',
    36.3433, -5.3067,
    36.2933, 36.3933,
    -5.3567, -5.2567
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

  RAISE NOTICE '✅ Ciudades de CAMPO DE GIBRALTAR insertadas/actualizadas';
  
  RAISE NOTICE '✅ TOTAL: Todas las ciudades de Cádiz insertadas/actualizadas correctamente';
  
END $$;

-- ============================================
-- 5. VERIFICACIÓN
-- ============================================
SELECT 
  region,
  COUNT(*) as cantidad_ciudades
FROM public.cities
WHERE province_id = (SELECT id FROM public.provinces WHERE slug = 'cadiz')
GROUP BY region
ORDER BY region;

-- Ver todas las ciudades de Cádiz
SELECT 
  id,
  slug,
  name,
  region,
  lat,
  lng
FROM public.cities
WHERE province_id = (SELECT id FROM public.provinces WHERE slug = 'cadiz')
ORDER BY region, name;
