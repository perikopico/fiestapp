-- ============================================
-- SQL generado automáticamente para insertar eventos desde JSON
-- Fecha de generación: 2026-01-11T22:24:14.116278
-- Total de eventos: 13
-- ============================================

-- IMPORTANTE: Reemplaza {SUPABASE_STORAGE_URL} con tu URL real
-- Ejemplo: https://xxxxx.supabase.co/storage/v1/object/public

DO $$
DECLARE
  v_city_id INT;
  v_category_id INT;
  v_category_slug TEXT;
  v_category_number INT;
  v_max_images INT;
  v_random_num INT;
  v_image_filename TEXT;
  v_image_url TEXT;
  v_supabase_url TEXT := 'https://oudofaiekedtaovrdqeo.supabase.co/storage/v1/object/public';  -- URL ya configurada
BEGIN

  -- =========================================
  -- Evento 1: Fútbol: Xerez DFC vs La Unión Atlético...
  -- =========================================
  BEGIN
    -- Buscar ID de ciudad: Jerez de la Frontera
    SELECT id INTO v_city_id FROM public.cities WHERE LOWER(name) = LOWER('Jerez de la Frontera') LIMIT 1;
    IF v_city_id IS NULL THEN
      RAISE WARNING 'Ciudad no encontrada: %', 'Jerez de la Frontera';
    END IF;
    
    -- Buscar ID de categoría: Deportes (slug: deportes)
    SELECT id INTO v_category_id FROM public.categories WHERE LOWER(slug) = LOWER('deportes') OR LOWER(name) = LOWER('Deportes') LIMIT 1;
    IF v_category_id IS NULL THEN
      RAISE WARNING 'Categoría no encontrada: % (slug: %)', 'Deportes', 'deportes';
    END IF;
    
    -- Generar imagen aleatoria para categoría 3 (Deportes)
    -- Rango de imágenes: 01.webp - 16.webp
    v_category_number := 3;
    v_max_images := 16;
    v_random_num := 1 + floor(random() * v_max_images)::INT;
    v_image_filename := LPAD(v_random_num::TEXT, 2, '0') || '.webp';
    v_image_url := v_supabase_url || '/sample-images/1/' || v_category_number::TEXT || '/' || v_image_filename;
    
    -- Insertar evento
    INSERT INTO public.events (
      id, title, place, maps_url, image_url, is_featured, is_free, 
      starts_at, city_id, category_id, status, description, image_alignment
    ) VALUES (
      '84c96e06-f6be-4da9-b088-d7c149a7b822',
      'Fútbol: Xerez DFC vs La Unión Atlético',
      'Estadio Chapín, Jerez de la Frontera',
      'https://www.google.com/maps/search/?api=1&query=Estadio+Chapin+Jerez',
      v_image_url,
      FALSE,
      FALSE,
      '2026-01-11T17:00:00Z'::timestamptz,
      v_city_id,
      v_category_id,
      'published',
      'Jornada 18. Segunda Federación (Grupo 4). Estadio Municipal de Chapín.',
      'center'
    );
  EXCEPTION
    WHEN OTHERS THEN
      RAISE WARNING 'Error al insertar evento 1 (%): %', 'Fútbol: Xerez DFC vs La Unión ...', SQLERRM;
  END;

  -- =========================================
  -- Evento 2: Fútbol: Xerez CD vs UCAM Murcia...
  -- =========================================
  BEGIN
    -- Buscar ID de ciudad: Jerez de la Frontera
    SELECT id INTO v_city_id FROM public.cities WHERE LOWER(name) = LOWER('Jerez de la Frontera') LIMIT 1;
    IF v_city_id IS NULL THEN
      RAISE WARNING 'Ciudad no encontrada: %', 'Jerez de la Frontera';
    END IF;
    
    -- Buscar ID de categoría: Deportes (slug: deportes)
    SELECT id INTO v_category_id FROM public.categories WHERE LOWER(slug) = LOWER('deportes') OR LOWER(name) = LOWER('Deportes') LIMIT 1;
    IF v_category_id IS NULL THEN
      RAISE WARNING 'Categoría no encontrada: % (slug: %)', 'Deportes', 'deportes';
    END IF;
    
    -- Generar imagen aleatoria para categoría 3 (Deportes)
    -- Rango de imágenes: 01.webp - 16.webp
    v_category_number := 3;
    v_max_images := 16;
    v_random_num := 1 + floor(random() * v_max_images)::INT;
    v_image_filename := LPAD(v_random_num::TEXT, 2, '0') || '.webp';
    v_image_url := v_supabase_url || '/sample-images/1/' || v_category_number::TEXT || '/' || v_image_filename;
    
    -- Insertar evento
    INSERT INTO public.events (
      id, title, place, maps_url, image_url, is_featured, is_free, 
      starts_at, city_id, category_id, status, description, image_alignment
    ) VALUES (
      '64a2d1d4-ef6a-4ece-b88a-22a169409f7c',
      'Fútbol: Xerez CD vs UCAM Murcia',
      'Estadio Chapín, Jerez de la Frontera',
      'https://www.google.com/maps/search/?api=1&query=Estadio+Chapin+Jerez',
      v_image_url,
      FALSE,
      FALSE,
      '2026-01-18T17:00:00Z'::timestamptz,
      v_city_id,
      v_category_id,
      'published',
      'Partidazo de Segunda Federación. Dos candidatos al ascenso.',
      'center'
    );
  EXCEPTION
    WHEN OTHERS THEN
      RAISE WARNING 'Error al insertar evento 2 (%): %', 'Fútbol: Xerez CD vs UCAM Murci...', SQLERRM;
  END;

  -- =========================================
  -- Evento 3: Fútbol: At. Sanluqueño vs Nàstic de Tarragona...
  -- =========================================
  BEGIN
    -- Buscar ID de ciudad: Sanlúcar de Barrameda
    SELECT id INTO v_city_id FROM public.cities WHERE LOWER(name) = LOWER('Sanlúcar de Barrameda') LIMIT 1;
    IF v_city_id IS NULL THEN
      RAISE WARNING 'Ciudad no encontrada: %', 'Sanlúcar de Barrameda';
    END IF;
    
    -- Buscar ID de categoría: Deportes (slug: deportes)
    SELECT id INTO v_category_id FROM public.categories WHERE LOWER(slug) = LOWER('deportes') OR LOWER(name) = LOWER('Deportes') LIMIT 1;
    IF v_category_id IS NULL THEN
      RAISE WARNING 'Categoría no encontrada: % (slug: %)', 'Deportes', 'deportes';
    END IF;
    
    -- Generar imagen aleatoria para categoría 3 (Deportes)
    -- Rango de imágenes: 01.webp - 16.webp
    v_category_number := 3;
    v_max_images := 16;
    v_random_num := 1 + floor(random() * v_max_images)::INT;
    v_image_filename := LPAD(v_random_num::TEXT, 2, '0') || '.webp';
    v_image_url := v_supabase_url || '/sample-images/1/' || v_category_number::TEXT || '/' || v_image_filename;
    
    -- Insertar evento
    INSERT INTO public.events (
      id, title, place, maps_url, image_url, is_featured, is_free, 
      starts_at, city_id, category_id, status, description, image_alignment
    ) VALUES (
      'dceac5dc-09c7-4c6a-942f-12ba1f62db1a',
      'Fútbol: At. Sanluqueño vs Nàstic de Tarragona',
      'Estadio El Palmar, Sanlúcar de Barrameda',
      'https://www.google.com/maps/search/?api=1&query=Estadio+El+Palmar+Sanlucar',
      v_image_url,
      FALSE,
      FALSE,
      '2026-01-18T19:30:00Z'::timestamptz,
      v_city_id,
      v_category_id,
      'published',
      'Primera Federación (Jornada 20). Ambiente espectacular en El Palmar.',
      'center'
    );
  EXCEPTION
    WHEN OTHERS THEN
      RAISE WARNING 'Error al insertar evento 3 (%): %', 'Fútbol: At. Sanluqueño vs Nàst...', SQLERRM;
  END;

  -- =========================================
  -- Evento 4: Fútbol: San Fernando CD vs CD Estepona...
  -- =========================================
  BEGIN
    -- Buscar ID de ciudad: San Fernando
    SELECT id INTO v_city_id FROM public.cities WHERE LOWER(name) = LOWER('San Fernando') LIMIT 1;
    IF v_city_id IS NULL THEN
      RAISE WARNING 'Ciudad no encontrada: %', 'San Fernando';
    END IF;
    
    -- Buscar ID de categoría: Deportes (slug: deportes)
    SELECT id INTO v_category_id FROM public.categories WHERE LOWER(slug) = LOWER('deportes') OR LOWER(name) = LOWER('Deportes') LIMIT 1;
    IF v_category_id IS NULL THEN
      RAISE WARNING 'Categoría no encontrada: % (slug: %)', 'Deportes', 'deportes';
    END IF;
    
    -- Generar imagen aleatoria para categoría 3 (Deportes)
    -- Rango de imágenes: 01.webp - 16.webp
    v_category_number := 3;
    v_max_images := 16;
    v_random_num := 1 + floor(random() * v_max_images)::INT;
    v_image_filename := LPAD(v_random_num::TEXT, 2, '0') || '.webp';
    v_image_url := v_supabase_url || '/sample-images/1/' || v_category_number::TEXT || '/' || v_image_filename;
    
    -- Insertar evento
    INSERT INTO public.events (
      id, title, place, maps_url, image_url, is_featured, is_free, 
      starts_at, city_id, category_id, status, description, image_alignment
    ) VALUES (
      '3f8e86ed-56b1-4f29-bd70-7fdc5d4df8d0',
      'Fútbol: San Fernando CD vs CD Estepona',
      'Estadio Iberoamericano 2010, San Fernando',
      'https://www.google.com/maps/search/?api=1&query=Estadio+Bahia+Sur+San+Fernando',
      v_image_url,
      FALSE,
      FALSE,
      '2026-01-18T12:00:00Z'::timestamptz,
      v_city_id,
      v_category_id,
      'published',
      'Segunda Federación (Grupo 4).',
      'center'
    );
  EXCEPTION
    WHEN OTHERS THEN
      RAISE WARNING 'Error al insertar evento 4 (%): %', 'Fútbol: San Fernando CD vs CD ...', SQLERRM;
  END;

  -- =========================================
  -- Evento 5: Fútbol: Cádiz CF vs Granada CF...
  -- =========================================
  BEGIN
    -- Buscar ID de ciudad: Cádiz
    SELECT id INTO v_city_id FROM public.cities WHERE LOWER(name) = LOWER('Cádiz') LIMIT 1;
    IF v_city_id IS NULL THEN
      RAISE WARNING 'Ciudad no encontrada: %', 'Cádiz';
    END IF;
    
    -- Buscar ID de categoría: Deportes (slug: deportes)
    SELECT id INTO v_category_id FROM public.categories WHERE LOWER(slug) = LOWER('deportes') OR LOWER(name) = LOWER('Deportes') LIMIT 1;
    IF v_category_id IS NULL THEN
      RAISE WARNING 'Categoría no encontrada: % (slug: %)', 'Deportes', 'deportes';
    END IF;
    
    -- Generar imagen aleatoria para categoría 3 (Deportes)
    -- Rango de imágenes: 01.webp - 16.webp
    v_category_number := 3;
    v_max_images := 16;
    v_random_num := 1 + floor(random() * v_max_images)::INT;
    v_image_filename := LPAD(v_random_num::TEXT, 2, '0') || '.webp';
    v_image_url := v_supabase_url || '/sample-images/1/' || v_category_number::TEXT || '/' || v_image_filename;
    
    -- Insertar evento
    INSERT INTO public.events (
      id, title, place, maps_url, image_url, is_featured, is_free, 
      starts_at, city_id, category_id, status, description, image_alignment
    ) VALUES (
      '99089732-17b2-4c33-af7e-ddf8600653bc',
      'Fútbol: Cádiz CF vs Granada CF',
      'Estadio Nuevo Mirandilla, Cádiz',
      'https://www.google.com/maps/search/?api=1&query=Estadio+Nuevo+Mirandilla+Cadiz',
      v_image_url,
      FALSE,
      FALSE,
      '2026-01-24T21:00:00Z'::timestamptz,
      v_city_id,
      v_category_id,
      'published',
      'DERBI ANDALUZ. LaLiga Hypermotion (Jornada 23). Partido de alta tensión.',
      'center'
    );
  EXCEPTION
    WHEN OTHERS THEN
      RAISE WARNING 'Error al insertar evento 5 (%): %', 'Fútbol: Cádiz CF vs Granada CF...', SQLERRM;
  END;

  -- =========================================
  -- Evento 6: Fútbol: Balompédica Linense vs CD Minera...
  -- =========================================
  BEGIN
    -- Buscar ID de ciudad: La Línea de la Concepción
    SELECT id INTO v_city_id FROM public.cities WHERE LOWER(name) = LOWER('La Línea de la Concepción') LIMIT 1;
    IF v_city_id IS NULL THEN
      RAISE WARNING 'Ciudad no encontrada: %', 'La Línea de la Concepción';
    END IF;
    
    -- Buscar ID de categoría: Deportes (slug: deportes)
    SELECT id INTO v_category_id FROM public.categories WHERE LOWER(slug) = LOWER('deportes') OR LOWER(name) = LOWER('Deportes') LIMIT 1;
    IF v_category_id IS NULL THEN
      RAISE WARNING 'Categoría no encontrada: % (slug: %)', 'Deportes', 'deportes';
    END IF;
    
    -- Generar imagen aleatoria para categoría 3 (Deportes)
    -- Rango de imágenes: 01.webp - 16.webp
    v_category_number := 3;
    v_max_images := 16;
    v_random_num := 1 + floor(random() * v_max_images)::INT;
    v_image_filename := LPAD(v_random_num::TEXT, 2, '0') || '.webp';
    v_image_url := v_supabase_url || '/sample-images/1/' || v_category_number::TEXT || '/' || v_image_filename;
    
    -- Insertar evento
    INSERT INTO public.events (
      id, title, place, maps_url, image_url, is_featured, is_free, 
      starts_at, city_id, category_id, status, description, image_alignment
    ) VALUES (
      '47cda32e-98f7-489a-8949-d5bfa2c9dce4',
      'Fútbol: Balompédica Linense vs CD Minera',
      'Estadio Municipal, La Línea de la Concepción',
      'https://www.google.com/maps/search/?api=1&query=Estadio+Municipal+La+Linea',
      v_image_url,
      FALSE,
      FALSE,
      '2026-01-25T17:00:00Z'::timestamptz,
      v_city_id,
      v_category_id,
      'published',
      'Segunda Federación (Grupo 4).',
      'center'
    );
  EXCEPTION
    WHEN OTHERS THEN
      RAISE WARNING 'Error al insertar evento 6 (%): %', 'Fútbol: Balompédica Linense vs...', SQLERRM;
  END;

  -- =========================================
  -- Evento 7: Fútbol: At. Sanluqueño vs Betis Deportivo...
  -- =========================================
  BEGIN
    -- Buscar ID de ciudad: Sanlúcar de Barrameda
    SELECT id INTO v_city_id FROM public.cities WHERE LOWER(name) = LOWER('Sanlúcar de Barrameda') LIMIT 1;
    IF v_city_id IS NULL THEN
      RAISE WARNING 'Ciudad no encontrada: %', 'Sanlúcar de Barrameda';
    END IF;
    
    -- Buscar ID de categoría: Deportes (slug: deportes)
    SELECT id INTO v_category_id FROM public.categories WHERE LOWER(slug) = LOWER('deportes') OR LOWER(name) = LOWER('Deportes') LIMIT 1;
    IF v_category_id IS NULL THEN
      RAISE WARNING 'Categoría no encontrada: % (slug: %)', 'Deportes', 'deportes';
    END IF;
    
    -- Generar imagen aleatoria para categoría 3 (Deportes)
    -- Rango de imágenes: 01.webp - 16.webp
    v_category_number := 3;
    v_max_images := 16;
    v_random_num := 1 + floor(random() * v_max_images)::INT;
    v_image_filename := LPAD(v_random_num::TEXT, 2, '0') || '.webp';
    v_image_url := v_supabase_url || '/sample-images/1/' || v_category_number::TEXT || '/' || v_image_filename;
    
    -- Insertar evento
    INSERT INTO public.events (
      id, title, place, maps_url, image_url, is_featured, is_free, 
      starts_at, city_id, category_id, status, description, image_alignment
    ) VALUES (
      'bc008308-d6a5-434e-aab0-bb704a628017',
      'Fútbol: At. Sanluqueño vs Betis Deportivo',
      'Estadio El Palmar, Sanlúcar de Barrameda',
      'https://www.google.com/maps/search/?api=1&query=Estadio+El+Palmar+Sanlucar',
      v_image_url,
      FALSE,
      FALSE,
      '2026-02-01T12:00:00Z'::timestamptz,
      v_city_id,
      v_category_id,
      'published',
      'Primera Federación. Duelo de filiales y canteras.',
      'center'
    );
  EXCEPTION
    WHEN OTHERS THEN
      RAISE WARNING 'Error al insertar evento 7 (%): %', 'Fútbol: At. Sanluqueño vs Beti...', SQLERRM;
  END;

  -- =========================================
  -- Evento 8: Fútbol: Xerez DFC vs Almería B...
  -- =========================================
  BEGIN
    -- Buscar ID de ciudad: Jerez de la Frontera
    SELECT id INTO v_city_id FROM public.cities WHERE LOWER(name) = LOWER('Jerez de la Frontera') LIMIT 1;
    IF v_city_id IS NULL THEN
      RAISE WARNING 'Ciudad no encontrada: %', 'Jerez de la Frontera';
    END IF;
    
    -- Buscar ID de categoría: Deportes (slug: deportes)
    SELECT id INTO v_category_id FROM public.categories WHERE LOWER(slug) = LOWER('deportes') OR LOWER(name) = LOWER('Deportes') LIMIT 1;
    IF v_category_id IS NULL THEN
      RAISE WARNING 'Categoría no encontrada: % (slug: %)', 'Deportes', 'deportes';
    END IF;
    
    -- Generar imagen aleatoria para categoría 3 (Deportes)
    -- Rango de imágenes: 01.webp - 16.webp
    v_category_number := 3;
    v_max_images := 16;
    v_random_num := 1 + floor(random() * v_max_images)::INT;
    v_image_filename := LPAD(v_random_num::TEXT, 2, '0') || '.webp';
    v_image_url := v_supabase_url || '/sample-images/1/' || v_category_number::TEXT || '/' || v_image_filename;
    
    -- Insertar evento
    INSERT INTO public.events (
      id, title, place, maps_url, image_url, is_featured, is_free, 
      starts_at, city_id, category_id, status, description, image_alignment
    ) VALUES (
      '9c9b0d57-d3f7-48b0-892d-8aaf96080d49',
      'Fútbol: Xerez DFC vs Almería B',
      'Estadio Chapín, Jerez de la Frontera',
      'https://www.google.com/maps/search/?api=1&query=Estadio+Chapin+Jerez',
      v_image_url,
      FALSE,
      FALSE,
      '2026-02-01T17:00:00Z'::timestamptz,
      v_city_id,
      v_category_id,
      'published',
      'Segunda Federación (Grupo 4).',
      'center'
    );
  EXCEPTION
    WHEN OTHERS THEN
      RAISE WARNING 'Error al insertar evento 8 (%): %', 'Fútbol: Xerez DFC vs Almería B...', SQLERRM;
  END;

  -- =========================================
  -- Evento 9: Fútbol: Cádiz CF vs UD Almería...
  -- =========================================
  BEGIN
    -- Buscar ID de ciudad: Cádiz
    SELECT id INTO v_city_id FROM public.cities WHERE LOWER(name) = LOWER('Cádiz') LIMIT 1;
    IF v_city_id IS NULL THEN
      RAISE WARNING 'Ciudad no encontrada: %', 'Cádiz';
    END IF;
    
    -- Buscar ID de categoría: Deportes (slug: deportes)
    SELECT id INTO v_category_id FROM public.categories WHERE LOWER(slug) = LOWER('deportes') OR LOWER(name) = LOWER('Deportes') LIMIT 1;
    IF v_category_id IS NULL THEN
      RAISE WARNING 'Categoría no encontrada: % (slug: %)', 'Deportes', 'deportes';
    END IF;
    
    -- Generar imagen aleatoria para categoría 3 (Deportes)
    -- Rango de imágenes: 01.webp - 16.webp
    v_category_number := 3;
    v_max_images := 16;
    v_random_num := 1 + floor(random() * v_max_images)::INT;
    v_image_filename := LPAD(v_random_num::TEXT, 2, '0') || '.webp';
    v_image_url := v_supabase_url || '/sample-images/1/' || v_category_number::TEXT || '/' || v_image_filename;
    
    -- Insertar evento
    INSERT INTO public.events (
      id, title, place, maps_url, image_url, is_featured, is_free, 
      starts_at, city_id, category_id, status, description, image_alignment
    ) VALUES (
      '7f039028-e6f4-40bb-83f7-deee886d784e',
      'Fútbol: Cádiz CF vs UD Almería',
      'Estadio Nuevo Mirandilla, Cádiz',
      'https://www.google.com/maps/search/?api=1&query=Estadio+Nuevo+Mirandilla+Cadiz',
      v_image_url,
      FALSE,
      FALSE,
      '2026-02-08T16:15:00Z'::timestamptz,
      v_city_id,
      v_category_id,
      'published',
      'LaLiga Hypermotion (Jornada 25). Otro derbi andaluz clave para el ascenso.',
      'center'
    );
  EXCEPTION
    WHEN OTHERS THEN
      RAISE WARNING 'Error al insertar evento 9 (%): %', 'Fútbol: Cádiz CF vs UD Almería...', SQLERRM;
  END;

  -- =========================================
  -- Evento 10: Fútbol: San Fernando CD vs Juventud Torremolinos...
  -- =========================================
  BEGIN
    -- Buscar ID de ciudad: San Fernando
    SELECT id INTO v_city_id FROM public.cities WHERE LOWER(name) = LOWER('San Fernando') LIMIT 1;
    IF v_city_id IS NULL THEN
      RAISE WARNING 'Ciudad no encontrada: %', 'San Fernando';
    END IF;
    
    -- Buscar ID de categoría: Deportes (slug: deportes)
    SELECT id INTO v_category_id FROM public.categories WHERE LOWER(slug) = LOWER('deportes') OR LOWER(name) = LOWER('Deportes') LIMIT 1;
    IF v_category_id IS NULL THEN
      RAISE WARNING 'Categoría no encontrada: % (slug: %)', 'Deportes', 'deportes';
    END IF;
    
    -- Generar imagen aleatoria para categoría 3 (Deportes)
    -- Rango de imágenes: 01.webp - 16.webp
    v_category_number := 3;
    v_max_images := 16;
    v_random_num := 1 + floor(random() * v_max_images)::INT;
    v_image_filename := LPAD(v_random_num::TEXT, 2, '0') || '.webp';
    v_image_url := v_supabase_url || '/sample-images/1/' || v_category_number::TEXT || '/' || v_image_filename;
    
    -- Insertar evento
    INSERT INTO public.events (
      id, title, place, maps_url, image_url, is_featured, is_free, 
      starts_at, city_id, category_id, status, description, image_alignment
    ) VALUES (
      'cd634d11-43a2-4864-917d-fd35d3b852bf',
      'Fútbol: San Fernando CD vs Juventud Torremolinos',
      'Estadio Iberoamericano 2010, San Fernando',
      'https://www.google.com/maps/search/?api=1&query=Estadio+Bahia+Sur+San+Fernando',
      v_image_url,
      FALSE,
      FALSE,
      '2026-02-08T12:00:00Z'::timestamptz,
      v_city_id,
      v_category_id,
      'published',
      'Segunda Federación (Grupo 4).',
      'center'
    );
  EXCEPTION
    WHEN OTHERS THEN
      RAISE WARNING 'Error al insertar evento 10 (%): %', 'Fútbol: San Fernando CD vs Juv...', SQLERRM;
  END;

  -- =========================================
  -- Evento 11: Fútbol: At. Sanluqueño vs Atlético de Madrid B...
  -- =========================================
  BEGIN
    -- Buscar ID de ciudad: Sanlúcar de Barrameda
    SELECT id INTO v_city_id FROM public.cities WHERE LOWER(name) = LOWER('Sanlúcar de Barrameda') LIMIT 1;
    IF v_city_id IS NULL THEN
      RAISE WARNING 'Ciudad no encontrada: %', 'Sanlúcar de Barrameda';
    END IF;
    
    -- Buscar ID de categoría: Deportes (slug: deportes)
    SELECT id INTO v_category_id FROM public.categories WHERE LOWER(slug) = LOWER('deportes') OR LOWER(name) = LOWER('Deportes') LIMIT 1;
    IF v_category_id IS NULL THEN
      RAISE WARNING 'Categoría no encontrada: % (slug: %)', 'Deportes', 'deportes';
    END IF;
    
    -- Generar imagen aleatoria para categoría 3 (Deportes)
    -- Rango de imágenes: 01.webp - 16.webp
    v_category_number := 3;
    v_max_images := 16;
    v_random_num := 1 + floor(random() * v_max_images)::INT;
    v_image_filename := LPAD(v_random_num::TEXT, 2, '0') || '.webp';
    v_image_url := v_supabase_url || '/sample-images/1/' || v_category_number::TEXT || '/' || v_image_filename;
    
    -- Insertar evento
    INSERT INTO public.events (
      id, title, place, maps_url, image_url, is_featured, is_free, 
      starts_at, city_id, category_id, status, description, image_alignment
    ) VALUES (
      '52602983-06f4-407b-8a29-02ff8e68faeb',
      'Fútbol: At. Sanluqueño vs Atlético de Madrid B',
      'Estadio El Palmar, Sanlúcar de Barrameda',
      'https://www.google.com/maps/search/?api=1&query=Estadio+El+Palmar+Sanlucar',
      v_image_url,
      FALSE,
      FALSE,
      '2026-02-15T17:00:00Z'::timestamptz,
      v_city_id,
      v_category_id,
      'published',
      'Primera Federación. Visita del filial colchonero.',
      'center'
    );
  EXCEPTION
    WHEN OTHERS THEN
      RAISE WARNING 'Error al insertar evento 11 (%): %', 'Fútbol: At. Sanluqueño vs Atlé...', SQLERRM;
  END;

  -- =========================================
  -- Evento 12: Fútbol: Xerez CD vs Linares Deportivo...
  -- =========================================
  BEGIN
    -- Buscar ID de ciudad: Jerez de la Frontera
    SELECT id INTO v_city_id FROM public.cities WHERE LOWER(name) = LOWER('Jerez de la Frontera') LIMIT 1;
    IF v_city_id IS NULL THEN
      RAISE WARNING 'Ciudad no encontrada: %', 'Jerez de la Frontera';
    END IF;
    
    -- Buscar ID de categoría: Deportes (slug: deportes)
    SELECT id INTO v_category_id FROM public.categories WHERE LOWER(slug) = LOWER('deportes') OR LOWER(name) = LOWER('Deportes') LIMIT 1;
    IF v_category_id IS NULL THEN
      RAISE WARNING 'Categoría no encontrada: % (slug: %)', 'Deportes', 'deportes';
    END IF;
    
    -- Generar imagen aleatoria para categoría 3 (Deportes)
    -- Rango de imágenes: 01.webp - 16.webp
    v_category_number := 3;
    v_max_images := 16;
    v_random_num := 1 + floor(random() * v_max_images)::INT;
    v_image_filename := LPAD(v_random_num::TEXT, 2, '0') || '.webp';
    v_image_url := v_supabase_url || '/sample-images/1/' || v_category_number::TEXT || '/' || v_image_filename;
    
    -- Insertar evento
    INSERT INTO public.events (
      id, title, place, maps_url, image_url, is_featured, is_free, 
      starts_at, city_id, category_id, status, description, image_alignment
    ) VALUES (
      '0e6caca8-4694-41cc-bfd7-b014978f204b',
      'Fútbol: Xerez CD vs Linares Deportivo',
      'Estadio Chapín, Jerez de la Frontera',
      'https://www.google.com/maps/search/?api=1&query=Estadio+Chapin+Jerez',
      v_image_url,
      FALSE,
      FALSE,
      '2026-02-15T17:00:00Z'::timestamptz,
      v_city_id,
      v_category_id,
      'published',
      'Segunda Federación. Partido clásico del fútbol andaluz.',
      'center'
    );
  EXCEPTION
    WHEN OTHERS THEN
      RAISE WARNING 'Error al insertar evento 12 (%): %', 'Fútbol: Xerez CD vs Linares De...', SQLERRM;
  END;

  -- =========================================
  -- Evento 13: Fútbol: Cádiz CF vs Real Sociedad B...
  -- =========================================
  BEGIN
    -- Buscar ID de ciudad: Cádiz
    SELECT id INTO v_city_id FROM public.cities WHERE LOWER(name) = LOWER('Cádiz') LIMIT 1;
    IF v_city_id IS NULL THEN
      RAISE WARNING 'Ciudad no encontrada: %', 'Cádiz';
    END IF;
    
    -- Buscar ID de categoría: Deportes (slug: deportes)
    SELECT id INTO v_category_id FROM public.categories WHERE LOWER(slug) = LOWER('deportes') OR LOWER(name) = LOWER('Deportes') LIMIT 1;
    IF v_category_id IS NULL THEN
      RAISE WARNING 'Categoría no encontrada: % (slug: %)', 'Deportes', 'deportes';
    END IF;
    
    -- Generar imagen aleatoria para categoría 3 (Deportes)
    -- Rango de imágenes: 01.webp - 16.webp
    v_category_number := 3;
    v_max_images := 16;
    v_random_num := 1 + floor(random() * v_max_images)::INT;
    v_image_filename := LPAD(v_random_num::TEXT, 2, '0') || '.webp';
    v_image_url := v_supabase_url || '/sample-images/1/' || v_category_number::TEXT || '/' || v_image_filename;
    
    -- Insertar evento
    INSERT INTO public.events (
      id, title, place, maps_url, image_url, is_featured, is_free, 
      starts_at, city_id, category_id, status, description, image_alignment
    ) VALUES (
      '12f0cdf8-be30-4537-a66d-1d61161bcd69',
      'Fútbol: Cádiz CF vs Real Sociedad B',
      'Estadio Nuevo Mirandilla, Cádiz',
      'https://www.google.com/maps/search/?api=1&query=Estadio+Nuevo+Mirandilla+Cadiz',
      v_image_url,
      FALSE,
      FALSE,
      '2026-02-22T18:30:00Z'::timestamptz,
      v_city_id,
      v_category_id,
      'published',
      'LaLiga Hypermotion (Jornada 27).',
      'center'
    );
  EXCEPTION
    WHEN OTHERS THEN
      RAISE WARNING 'Error al insertar evento 13 (%): %', 'Fútbol: Cádiz CF vs Real Socie...', SQLERRM;
  END;

END $$;

-- ============================================
-- Verificación
-- ============================================
SELECT COUNT(*) as total_eventos_insertados FROM public.events;

-- Ver algunos eventos insertados
SELECT 
  e.id,
  e.title,
  c.name as ciudad,
  cat.name as categoria,
  e.starts_at,
  e.image_url
FROM public.events e
LEFT JOIN public.cities c ON e.city_id = c.id
LEFT JOIN public.categories cat ON e.category_id = cat.id
ORDER BY e.starts_at DESC
LIMIT 10;
