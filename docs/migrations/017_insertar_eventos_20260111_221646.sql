-- ============================================
-- SQL generado automáticamente para insertar eventos desde JSON
-- Fecha de generación: 2026-01-11T22:16:46.427918
-- Total de eventos: 15
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
  -- Evento 1: Concierto: Syrah Morrison (Folk/Rock)...
  -- =========================================
  BEGIN
    -- Buscar ID de ciudad: Jerez de la Frontera
    SELECT id INTO v_city_id FROM public.cities WHERE LOWER(name) = LOWER('Jerez de la Frontera') LIMIT 1;
    IF v_city_id IS NULL THEN
      RAISE WARNING 'Ciudad no encontrada: %', 'Jerez de la Frontera';
    END IF;
    
    -- Buscar ID de categoría: Música (slug: musica)
    SELECT id INTO v_category_id FROM public.categories WHERE LOWER(slug) = LOWER('musica') OR LOWER(name) = LOWER('Música') LIMIT 1;
    IF v_category_id IS NULL THEN
      RAISE WARNING 'Categoría no encontrada: % (slug: %)', 'Música', 'musica';
    END IF;
    
    -- Generar imagen aleatoria para categoría 1 (Música)
    -- Rango de imágenes: 01.webp - 10.webp
    v_category_number := 1;
    v_max_images := 10;
    v_random_num := 1 + floor(random() * v_max_images)::INT;
    v_image_filename := LPAD(v_random_num::TEXT, 2, '0') || '.webp';
    v_image_url := v_supabase_url || '/sample-images/1/' || v_category_number::TEXT || '/' || v_image_filename;
    
    -- Insertar evento
    INSERT INTO public.events (
      id, title, place, maps_url, image_url, is_featured, is_free, 
      starts_at, city_id, category_id, status, description, image_alignment
    ) VALUES (
      '1eae091f-b3cc-42d6-b700-39b371e0cd89',
      'Concierto: Syrah Morrison (Folk/Rock)',
      'La Guarida del Ángel, Jerez',
      'https://www.google.com/maps/search/?api=1&query=La+Guarida+del+Angel+Jerez',
      v_image_url,
      FALSE,
      FALSE,
      '2026-01-16T22:30:00Z'::timestamptz,
      v_city_id,
      v_category_id,
      'published',
      'Música en directo en sala mítica de Jerez.',
      'center'
    );
  EXCEPTION
    WHEN OTHERS THEN
      RAISE WARNING 'Error al insertar evento 1 (%): %', 'Concierto: Syrah Morrison (Fol...', SQLERRM;
  END;

  -- =========================================
  -- Evento 2: Homenaje a Triana (Miguel Zaguán Trío)...
  -- =========================================
  BEGIN
    -- Buscar ID de ciudad: Jerez de la Frontera
    SELECT id INTO v_city_id FROM public.cities WHERE LOWER(name) = LOWER('Jerez de la Frontera') LIMIT 1;
    IF v_city_id IS NULL THEN
      RAISE WARNING 'Ciudad no encontrada: %', 'Jerez de la Frontera';
    END IF;
    
    -- Buscar ID de categoría: Música (slug: musica)
    SELECT id INTO v_category_id FROM public.categories WHERE LOWER(slug) = LOWER('musica') OR LOWER(name) = LOWER('Música') LIMIT 1;
    IF v_category_id IS NULL THEN
      RAISE WARNING 'Categoría no encontrada: % (slug: %)', 'Música', 'musica';
    END IF;
    
    -- Generar imagen aleatoria para categoría 1 (Música)
    -- Rango de imágenes: 01.webp - 10.webp
    v_category_number := 1;
    v_max_images := 10;
    v_random_num := 1 + floor(random() * v_max_images)::INT;
    v_image_filename := LPAD(v_random_num::TEXT, 2, '0') || '.webp';
    v_image_url := v_supabase_url || '/sample-images/1/' || v_category_number::TEXT || '/' || v_image_filename;
    
    -- Insertar evento
    INSERT INTO public.events (
      id, title, place, maps_url, image_url, is_featured, is_free, 
      starts_at, city_id, category_id, status, description, image_alignment
    ) VALUES (
      '2ed13cdc-98aa-4853-bdd8-4f095c8ef660',
      'Homenaje a Triana (Miguel Zaguán Trío)',
      'La Guarida del Ángel, Jerez',
      'https://www.google.com/maps/search/?api=1&query=La+Guarida+del+Angel+Jerez',
      v_image_url,
      FALSE,
      FALSE,
      '2026-01-17T23:00:00Z'::timestamptz,
      v_city_id,
      v_category_id,
      'published',
      'Tributo al rock andaluz.',
      'center'
    );
  EXCEPTION
    WHEN OTHERS THEN
      RAISE WARNING 'Error al insertar evento 2 (%): %', 'Homenaje a Triana (Miguel Zagu...', SQLERRM;
  END;

  -- =========================================
  -- Evento 3: Monólogo: Manolo Morera ''Manolo for President''...
  -- =========================================
  BEGIN
    -- Buscar ID de ciudad: Algeciras
    SELECT id INTO v_city_id FROM public.cities WHERE LOWER(name) = LOWER('Algeciras') LIMIT 1;
    IF v_city_id IS NULL THEN
      RAISE WARNING 'Ciudad no encontrada: %', 'Algeciras';
    END IF;
    
    -- Buscar ID de categoría: Arte y Cultura (slug: arte-y-cultura)
    SELECT id INTO v_category_id FROM public.categories WHERE LOWER(slug) = LOWER('arte-y-cultura') OR LOWER(name) = LOWER('Arte y Cultura') LIMIT 1;
    IF v_category_id IS NULL THEN
      RAISE WARNING 'Categoría no encontrada: % (slug: %)', 'Arte y Cultura', 'arte-y-cultura';
    END IF;
    
    -- Generar imagen aleatoria para categoría 4 (Arte y Cultura)
    -- Rango de imágenes: 01.webp - 09.webp
    v_category_number := 4;
    v_max_images := 9;
    v_random_num := 1 + floor(random() * v_max_images)::INT;
    v_image_filename := LPAD(v_random_num::TEXT, 2, '0') || '.webp';
    v_image_url := v_supabase_url || '/sample-images/1/' || v_category_number::TEXT || '/' || v_image_filename;
    
    -- Insertar evento
    INSERT INTO public.events (
      id, title, place, maps_url, image_url, is_featured, is_free, 
      starts_at, city_id, category_id, status, description, image_alignment
    ) VALUES (
      '737a277e-790c-4966-82ec-52fc7cd3d51e',
      'Monólogo: Manolo Morera ''Manolo for President''',
      'Sala La Gramola, Algeciras',
      'https://www.google.com/maps/search/?api=1&query=Sala+La+Gramola+Algeciras',
      v_image_url,
      FALSE,
      FALSE,
      '2026-01-18T18:00:00Z'::timestamptz,
      v_city_id,
      v_category_id,
      'published',
      'Humor gaditano en el Campo de Gibraltar.',
      'center'
    );
  EXCEPTION
    WHEN OTHERS THEN
      RAISE WARNING 'Error al insertar evento 3 (%): %', 'Monólogo: Manolo Morera ''Mano...', SQLERRM;
  END;

  -- =========================================
  -- Evento 4: Concierto Internacional: Sweet Giant (UK)...
  -- =========================================
  BEGIN
    -- Buscar ID de ciudad: Jerez de la Frontera
    SELECT id INTO v_city_id FROM public.cities WHERE LOWER(name) = LOWER('Jerez de la Frontera') LIMIT 1;
    IF v_city_id IS NULL THEN
      RAISE WARNING 'Ciudad no encontrada: %', 'Jerez de la Frontera';
    END IF;
    
    -- Buscar ID de categoría: Música (slug: musica)
    SELECT id INTO v_category_id FROM public.categories WHERE LOWER(slug) = LOWER('musica') OR LOWER(name) = LOWER('Música') LIMIT 1;
    IF v_category_id IS NULL THEN
      RAISE WARNING 'Categoría no encontrada: % (slug: %)', 'Música', 'musica';
    END IF;
    
    -- Generar imagen aleatoria para categoría 1 (Música)
    -- Rango de imágenes: 01.webp - 10.webp
    v_category_number := 1;
    v_max_images := 10;
    v_random_num := 1 + floor(random() * v_max_images)::INT;
    v_image_filename := LPAD(v_random_num::TEXT, 2, '0') || '.webp';
    v_image_url := v_supabase_url || '/sample-images/1/' || v_category_number::TEXT || '/' || v_image_filename;
    
    -- Insertar evento
    INSERT INTO public.events (
      id, title, place, maps_url, image_url, is_featured, is_free, 
      starts_at, city_id, category_id, status, description, image_alignment
    ) VALUES (
      '25ea82b0-e3d0-4047-9225-c851db513681',
      'Concierto Internacional: Sweet Giant (UK)',
      'La Guarida del Ángel, Jerez',
      'https://www.google.com/maps/search/?api=1&query=La+Guarida+del+Angel+Jerez',
      v_image_url,
      FALSE,
      FALSE,
      '2026-01-21T21:00:00Z'::timestamptz,
      v_city_id,
      v_category_id,
      'published',
      'Banda británica en gira.',
      'center'
    );
  EXCEPTION
    WHEN OTHERS THEN
      RAISE WARNING 'Error al insertar evento 4 (%): %', 'Concierto Internacional: Sweet...', SQLERRM;
  END;

  -- =========================================
  -- Evento 5: Gaditana de Improvisación...
  -- =========================================
  BEGIN
    -- Buscar ID de ciudad: Cádiz
    SELECT id INTO v_city_id FROM public.cities WHERE LOWER(name) = LOWER('Cádiz') LIMIT 1;
    IF v_city_id IS NULL THEN
      RAISE WARNING 'Ciudad no encontrada: %', 'Cádiz';
    END IF;
    
    -- Buscar ID de categoría: Arte y Cultura (slug: arte-y-cultura)
    SELECT id INTO v_category_id FROM public.categories WHERE LOWER(slug) = LOWER('arte-y-cultura') OR LOWER(name) = LOWER('Arte y Cultura') LIMIT 1;
    IF v_category_id IS NULL THEN
      RAISE WARNING 'Categoría no encontrada: % (slug: %)', 'Arte y Cultura', 'arte-y-cultura';
    END IF;
    
    -- Generar imagen aleatoria para categoría 4 (Arte y Cultura)
    -- Rango de imágenes: 01.webp - 09.webp
    v_category_number := 4;
    v_max_images := 9;
    v_random_num := 1 + floor(random() * v_max_images)::INT;
    v_image_filename := LPAD(v_random_num::TEXT, 2, '0') || '.webp';
    v_image_url := v_supabase_url || '/sample-images/1/' || v_category_number::TEXT || '/' || v_image_filename;
    
    -- Insertar evento
    INSERT INTO public.events (
      id, title, place, maps_url, image_url, is_featured, is_free, 
      starts_at, city_id, category_id, status, description, image_alignment
    ) VALUES (
      '388227e2-98e5-4c36-b80d-17f0cf875157',
      'Gaditana de Improvisación',
      'Café Teatro Pay-Pay, Cádiz',
      'https://www.google.com/maps/search/?api=1&query=Cafe+Teatro+Pay+Pay+Cadiz',
      v_image_url,
      FALSE,
      FALSE,
      '2026-01-23T21:00:00Z'::timestamptz,
      v_city_id,
      v_category_id,
      'published',
      'Match ''Des-Propósitos de Año Nuevo''. Humor improvisado.',
      'center'
    );
  EXCEPTION
    WHEN OTHERS THEN
      RAISE WARNING 'Error al insertar evento 5 (%): %', 'Gaditana de Improvisación...', SQLERRM;
  END;

  -- =========================================
  -- Evento 6: Concierto: King Sapo...
  -- =========================================
  BEGIN
    -- Buscar ID de ciudad: Jerez de la Frontera
    SELECT id INTO v_city_id FROM public.cities WHERE LOWER(name) = LOWER('Jerez de la Frontera') LIMIT 1;
    IF v_city_id IS NULL THEN
      RAISE WARNING 'Ciudad no encontrada: %', 'Jerez de la Frontera';
    END IF;
    
    -- Buscar ID de categoría: Música (slug: musica)
    SELECT id INTO v_category_id FROM public.categories WHERE LOWER(slug) = LOWER('musica') OR LOWER(name) = LOWER('Música') LIMIT 1;
    IF v_category_id IS NULL THEN
      RAISE WARNING 'Categoría no encontrada: % (slug: %)', 'Música', 'musica';
    END IF;
    
    -- Generar imagen aleatoria para categoría 1 (Música)
    -- Rango de imágenes: 01.webp - 10.webp
    v_category_number := 1;
    v_max_images := 10;
    v_random_num := 1 + floor(random() * v_max_images)::INT;
    v_image_filename := LPAD(v_random_num::TEXT, 2, '0') || '.webp';
    v_image_url := v_supabase_url || '/sample-images/1/' || v_category_number::TEXT || '/' || v_image_filename;
    
    -- Insertar evento
    INSERT INTO public.events (
      id, title, place, maps_url, image_url, is_featured, is_free, 
      starts_at, city_id, category_id, status, description, image_alignment
    ) VALUES (
      'c460ebd4-7a3a-48be-889b-56f06216dca9',
      'Concierto: King Sapo',
      'La Guarida del Ángel, Jerez',
      'https://www.google.com/maps/search/?api=1&query=La+Guarida+del+Angel+Jerez',
      v_image_url,
      FALSE,
      FALSE,
      '2026-01-23T22:00:00Z'::timestamptz,
      v_city_id,
      v_category_id,
      'published',
      'Rock puro en directo.',
      'center'
    );
  EXCEPTION
    WHEN OTHERS THEN
      RAISE WARNING 'Error al insertar evento 6 (%): %', 'Concierto: King Sapo...', SQLERRM;
  END;

  -- =========================================
  -- Evento 7: Concierto Acústico: Laura B...
  -- =========================================
  BEGIN
    -- Buscar ID de ciudad: Cádiz
    SELECT id INTO v_city_id FROM public.cities WHERE LOWER(name) = LOWER('Cádiz') LIMIT 1;
    IF v_city_id IS NULL THEN
      RAISE WARNING 'Ciudad no encontrada: %', 'Cádiz';
    END IF;
    
    -- Buscar ID de categoría: Música (slug: musica)
    SELECT id INTO v_category_id FROM public.categories WHERE LOWER(slug) = LOWER('musica') OR LOWER(name) = LOWER('Música') LIMIT 1;
    IF v_category_id IS NULL THEN
      RAISE WARNING 'Categoría no encontrada: % (slug: %)', 'Música', 'musica';
    END IF;
    
    -- Generar imagen aleatoria para categoría 1 (Música)
    -- Rango de imágenes: 01.webp - 10.webp
    v_category_number := 1;
    v_max_images := 10;
    v_random_num := 1 + floor(random() * v_max_images)::INT;
    v_image_filename := LPAD(v_random_num::TEXT, 2, '0') || '.webp';
    v_image_url := v_supabase_url || '/sample-images/1/' || v_category_number::TEXT || '/' || v_image_filename;
    
    -- Insertar evento
    INSERT INTO public.events (
      id, title, place, maps_url, image_url, is_featured, is_free, 
      starts_at, city_id, category_id, status, description, image_alignment
    ) VALUES (
      'fa515117-c75c-4853-bc17-873ca3a1bf55',
      'Concierto Acústico: Laura B',
      'Café Teatro Pay-Pay, Cádiz',
      'https://www.google.com/maps/search/?api=1&query=Cafe+Teatro+Pay+Pay+Cadiz',
      v_image_url,
      FALSE,
      FALSE,
      '2026-01-24T21:00:00Z'::timestamptz,
      v_city_id,
      v_category_id,
      'published',
      'Voz y sentimiento en el barrio del Pópulo.',
      'center'
    );
  EXCEPTION
    WHEN OTHERS THEN
      RAISE WARNING 'Error al insertar evento 7 (%): %', 'Concierto Acústico: Laura B...', SQLERRM;
  END;

  -- =========================================
  -- Evento 8: Noches de Perla: ''Con Alma de Camarón''...
  -- =========================================
  BEGIN
    -- Buscar ID de ciudad: Cádiz
    SELECT id INTO v_city_id FROM public.cities WHERE LOWER(name) = LOWER('Cádiz') LIMIT 1;
    IF v_city_id IS NULL THEN
      RAISE WARNING 'Ciudad no encontrada: %', 'Cádiz';
    END IF;
    
    -- Buscar ID de categoría: Música (slug: musica)
    SELECT id INTO v_category_id FROM public.categories WHERE LOWER(slug) = LOWER('musica') OR LOWER(name) = LOWER('Música') LIMIT 1;
    IF v_category_id IS NULL THEN
      RAISE WARNING 'Categoría no encontrada: % (slug: %)', 'Música', 'musica';
    END IF;
    
    -- Generar imagen aleatoria para categoría 1 (Música)
    -- Rango de imágenes: 01.webp - 10.webp
    v_category_number := 1;
    v_max_images := 10;
    v_random_num := 1 + floor(random() * v_max_images)::INT;
    v_image_filename := LPAD(v_random_num::TEXT, 2, '0') || '.webp';
    v_image_url := v_supabase_url || '/sample-images/1/' || v_category_number::TEXT || '/' || v_image_filename;
    
    -- Insertar evento
    INSERT INTO public.events (
      id, title, place, maps_url, image_url, is_featured, is_free, 
      starts_at, city_id, category_id, status, description, image_alignment
    ) VALUES (
      'e6d9704e-2090-4dad-88f9-390069705c64',
      'Noches de Perla: ''Con Alma de Camarón''',
      'Peña Flamenca La Perla, Cádiz',
      'https://www.google.com/maps/search/?api=1&query=Peña+La+Perla+de+Cadiz',
      v_image_url,
      FALSE,
      FALSE,
      '2026-01-24T22:00:00Z'::timestamptz,
      v_city_id,
      v_category_id,
      'published',
      'Con Pedro Granaíno y Antonio Reyes.',
      'center'
    );
  EXCEPTION
    WHEN OTHERS THEN
      RAISE WARNING 'Error al insertar evento 8 (%): %', 'Noches de Perla: ''Con Alma de...', SQLERRM;
  END;

  -- =========================================
  -- Evento 9: Tributo a Bon Jovi...
  -- =========================================
  BEGIN
    -- Buscar ID de ciudad: Jerez de la Frontera
    SELECT id INTO v_city_id FROM public.cities WHERE LOWER(name) = LOWER('Jerez de la Frontera') LIMIT 1;
    IF v_city_id IS NULL THEN
      RAISE WARNING 'Ciudad no encontrada: %', 'Jerez de la Frontera';
    END IF;
    
    -- Buscar ID de categoría: Música (slug: musica)
    SELECT id INTO v_category_id FROM public.categories WHERE LOWER(slug) = LOWER('musica') OR LOWER(name) = LOWER('Música') LIMIT 1;
    IF v_category_id IS NULL THEN
      RAISE WARNING 'Categoría no encontrada: % (slug: %)', 'Música', 'musica';
    END IF;
    
    -- Generar imagen aleatoria para categoría 1 (Música)
    -- Rango de imágenes: 01.webp - 10.webp
    v_category_number := 1;
    v_max_images := 10;
    v_random_num := 1 + floor(random() * v_max_images)::INT;
    v_image_filename := LPAD(v_random_num::TEXT, 2, '0') || '.webp';
    v_image_url := v_supabase_url || '/sample-images/1/' || v_category_number::TEXT || '/' || v_image_filename;
    
    -- Insertar evento
    INSERT INTO public.events (
      id, title, place, maps_url, image_url, is_featured, is_free, 
      starts_at, city_id, category_id, status, description, image_alignment
    ) VALUES (
      '09a970cd-6abe-483c-99b2-432fc472d50b',
      'Tributo a Bon Jovi',
      'La Guarida del Ángel, Jerez',
      'https://www.google.com/maps/search/?api=1&query=La+Guarida+del+Angel+Jerez',
      v_image_url,
      FALSE,
      FALSE,
      '2026-01-24T22:00:00Z'::timestamptz,
      v_city_id,
      v_category_id,
      'published',
      'Noche de rock clásico.',
      'center'
    );
  EXCEPTION
    WHEN OTHERS THEN
      RAISE WARNING 'Error al insertar evento 9 (%): %', 'Tributo a Bon Jovi...', SQLERRM;
  END;

  -- =========================================
  -- Evento 10: Teatro: ''Se Alquila''...
  -- =========================================
  BEGIN
    -- Buscar ID de ciudad: Algeciras
    SELECT id INTO v_city_id FROM public.cities WHERE LOWER(name) = LOWER('Algeciras') LIMIT 1;
    IF v_city_id IS NULL THEN
      RAISE WARNING 'Ciudad no encontrada: %', 'Algeciras';
    END IF;
    
    -- Buscar ID de categoría: Arte y Cultura (slug: arte-y-cultura)
    SELECT id INTO v_category_id FROM public.categories WHERE LOWER(slug) = LOWER('arte-y-cultura') OR LOWER(name) = LOWER('Arte y Cultura') LIMIT 1;
    IF v_category_id IS NULL THEN
      RAISE WARNING 'Categoría no encontrada: % (slug: %)', 'Arte y Cultura', 'arte-y-cultura';
    END IF;
    
    -- Generar imagen aleatoria para categoría 4 (Arte y Cultura)
    -- Rango de imágenes: 01.webp - 09.webp
    v_category_number := 4;
    v_max_images := 9;
    v_random_num := 1 + floor(random() * v_max_images)::INT;
    v_image_filename := LPAD(v_random_num::TEXT, 2, '0') || '.webp';
    v_image_url := v_supabase_url || '/sample-images/1/' || v_category_number::TEXT || '/' || v_image_filename;
    
    -- Insertar evento
    INSERT INTO public.events (
      id, title, place, maps_url, image_url, is_featured, is_free, 
      starts_at, city_id, category_id, status, description, image_alignment
    ) VALUES (
      'c6be1dfa-0de4-4221-ad59-510483ad3123',
      'Teatro: ''Se Alquila''',
      'Sala La Gramola, Algeciras',
      'https://www.google.com/maps/search/?api=1&query=Sala+La+Gramola+Algeciras',
      v_image_url,
      FALSE,
      FALSE,
      '2026-01-26T19:00:00Z'::timestamptz,
      v_city_id,
      v_category_id,
      'published',
      'Con Andoni Ferreño y Agustín Bravo.',
      'center'
    );
  EXCEPTION
    WHEN OTHERS THEN
      RAISE WARNING 'Error al insertar evento 10 (%): %', 'Teatro: ''Se Alquila''...', SQLERRM;
  END;

  -- =========================================
  -- Evento 11: Concierto: Inma Márquez y Alycristango...
  -- =========================================
  BEGIN
    -- Buscar ID de ciudad: Cádiz
    SELECT id INTO v_city_id FROM public.cities WHERE LOWER(name) = LOWER('Cádiz') LIMIT 1;
    IF v_city_id IS NULL THEN
      RAISE WARNING 'Ciudad no encontrada: %', 'Cádiz';
    END IF;
    
    -- Buscar ID de categoría: Música (slug: musica)
    SELECT id INTO v_category_id FROM public.categories WHERE LOWER(slug) = LOWER('musica') OR LOWER(name) = LOWER('Música') LIMIT 1;
    IF v_category_id IS NULL THEN
      RAISE WARNING 'Categoría no encontrada: % (slug: %)', 'Música', 'musica';
    END IF;
    
    -- Generar imagen aleatoria para categoría 1 (Música)
    -- Rango de imágenes: 01.webp - 10.webp
    v_category_number := 1;
    v_max_images := 10;
    v_random_num := 1 + floor(random() * v_max_images)::INT;
    v_image_filename := LPAD(v_random_num::TEXT, 2, '0') || '.webp';
    v_image_url := v_supabase_url || '/sample-images/1/' || v_category_number::TEXT || '/' || v_image_filename;
    
    -- Insertar evento
    INSERT INTO public.events (
      id, title, place, maps_url, image_url, is_featured, is_free, 
      starts_at, city_id, category_id, status, description, image_alignment
    ) VALUES (
      '65132188-fa01-4e37-aca4-d9fe1c7e987f',
      'Concierto: Inma Márquez y Alycristango',
      'Café Teatro Pay-Pay, Cádiz',
      'https://www.google.com/maps/search/?api=1&query=Cafe+Teatro+Pay+Pay+Cadiz',
      v_image_url,
      FALSE,
      FALSE,
      '2026-01-31T21:00:00Z'::timestamptz,
      v_city_id,
      v_category_id,
      'published',
      'Boleros y tangos de ida y vuelta.',
      'center'
    );
  EXCEPTION
    WHEN OTHERS THEN
      RAISE WARNING 'Error al insertar evento 11 (%): %', 'Concierto: Inma Márquez y Alyc...', SQLERRM;
  END;

  -- =========================================
  -- Evento 12: Concierto: Winter Blues Band...
  -- =========================================
  BEGIN
    -- Buscar ID de ciudad: El Puerto de Santa María
    SELECT id INTO v_city_id FROM public.cities WHERE LOWER(name) = LOWER('El Puerto de Santa María') LIMIT 1;
    IF v_city_id IS NULL THEN
      RAISE WARNING 'Ciudad no encontrada: %', 'El Puerto de Santa María';
    END IF;
    
    -- Buscar ID de categoría: Música (slug: musica)
    SELECT id INTO v_category_id FROM public.categories WHERE LOWER(slug) = LOWER('musica') OR LOWER(name) = LOWER('Música') LIMIT 1;
    IF v_category_id IS NULL THEN
      RAISE WARNING 'Categoría no encontrada: % (slug: %)', 'Música', 'musica';
    END IF;
    
    -- Generar imagen aleatoria para categoría 1 (Música)
    -- Rango de imágenes: 01.webp - 10.webp
    v_category_number := 1;
    v_max_images := 10;
    v_random_num := 1 + floor(random() * v_max_images)::INT;
    v_image_filename := LPAD(v_random_num::TEXT, 2, '0') || '.webp';
    v_image_url := v_supabase_url || '/sample-images/1/' || v_category_number::TEXT || '/' || v_image_filename;
    
    -- Insertar evento
    INSERT INTO public.events (
      id, title, place, maps_url, image_url, is_featured, is_free, 
      starts_at, city_id, category_id, status, description, image_alignment
    ) VALUES (
      'd641a787-18ce-41eb-82ab-ded6ba6dfa03',
      'Concierto: Winter Blues Band',
      'Sala Milwaukee, El Puerto de Santa María',
      'https://www.google.com/maps/search/?api=1&query=Sala+Milwaukee+El+Puerto',
      v_image_url,
      FALSE,
      FALSE,
      '2026-01-31T22:30:00Z'::timestamptz,
      v_city_id,
      v_category_id,
      'published',
      'Noche de Blues en la sala más emblemática de El Puerto.',
      'center'
    );
  EXCEPTION
    WHEN OTHERS THEN
      RAISE WARNING 'Error al insertar evento 12 (%): %', 'Concierto: Winter Blues Band...', SQLERRM;
  END;

  -- =========================================
  -- Evento 13: Tributo El Último de la Fila (Los Hombres Rana)...
  -- =========================================
  BEGIN
    -- Buscar ID de ciudad: Jerez de la Frontera
    SELECT id INTO v_city_id FROM public.cities WHERE LOWER(name) = LOWER('Jerez de la Frontera') LIMIT 1;
    IF v_city_id IS NULL THEN
      RAISE WARNING 'Ciudad no encontrada: %', 'Jerez de la Frontera';
    END IF;
    
    -- Buscar ID de categoría: Música (slug: musica)
    SELECT id INTO v_category_id FROM public.categories WHERE LOWER(slug) = LOWER('musica') OR LOWER(name) = LOWER('Música') LIMIT 1;
    IF v_category_id IS NULL THEN
      RAISE WARNING 'Categoría no encontrada: % (slug: %)', 'Música', 'musica';
    END IF;
    
    -- Generar imagen aleatoria para categoría 1 (Música)
    -- Rango de imágenes: 01.webp - 10.webp
    v_category_number := 1;
    v_max_images := 10;
    v_random_num := 1 + floor(random() * v_max_images)::INT;
    v_image_filename := LPAD(v_random_num::TEXT, 2, '0') || '.webp';
    v_image_url := v_supabase_url || '/sample-images/1/' || v_category_number::TEXT || '/' || v_image_filename;
    
    -- Insertar evento
    INSERT INTO public.events (
      id, title, place, maps_url, image_url, is_featured, is_free, 
      starts_at, city_id, category_id, status, description, image_alignment
    ) VALUES (
      'a0753f94-d277-4a8b-b738-492343eed26a',
      'Tributo El Último de la Fila (Los Hombres Rana)',
      'La Guarida del Ángel, Jerez',
      'https://www.google.com/maps/search/?api=1&query=La+Guarida+del+Angel+Jerez',
      v_image_url,
      FALSE,
      FALSE,
      '2026-02-07T22:00:00Z'::timestamptz,
      v_city_id,
      v_category_id,
      'published',
      'Pop Rock español.',
      'center'
    );
  EXCEPTION
    WHEN OTHERS THEN
      RAISE WARNING 'Error al insertar evento 13 (%): %', 'Tributo El Último de la Fila (...', SQLERRM;
  END;

  -- =========================================
  -- Evento 14: Jerez Off Festival: Agujetas Chico...
  -- =========================================
  BEGIN
    -- Buscar ID de ciudad: Jerez de la Frontera
    SELECT id INTO v_city_id FROM public.cities WHERE LOWER(name) = LOWER('Jerez de la Frontera') LIMIT 1;
    IF v_city_id IS NULL THEN
      RAISE WARNING 'Ciudad no encontrada: %', 'Jerez de la Frontera';
    END IF;
    
    -- Buscar ID de categoría: Música (slug: musica)
    SELECT id INTO v_category_id FROM public.categories WHERE LOWER(slug) = LOWER('musica') OR LOWER(name) = LOWER('Música') LIMIT 1;
    IF v_category_id IS NULL THEN
      RAISE WARNING 'Categoría no encontrada: % (slug: %)', 'Música', 'musica';
    END IF;
    
    -- Generar imagen aleatoria para categoría 1 (Música)
    -- Rango de imágenes: 01.webp - 10.webp
    v_category_number := 1;
    v_max_images := 10;
    v_random_num := 1 + floor(random() * v_max_images)::INT;
    v_image_filename := LPAD(v_random_num::TEXT, 2, '0') || '.webp';
    v_image_url := v_supabase_url || '/sample-images/1/' || v_category_number::TEXT || '/' || v_image_filename;
    
    -- Insertar evento
    INSERT INTO public.events (
      id, title, place, maps_url, image_url, is_featured, is_free, 
      starts_at, city_id, category_id, status, description, image_alignment
    ) VALUES (
      'dfc515c0-9fcc-455a-880b-0956a53f3382',
      'Jerez Off Festival: Agujetas Chico',
      'La Guarida del Ángel, Jerez',
      'https://www.google.com/maps/search/?api=1&query=La+Guarida+del+Angel+Jerez',
      v_image_url,
      FALSE,
      FALSE,
      '2026-02-20T23:00:00Z'::timestamptz,
      v_city_id,
      v_category_id,
      'published',
      'Ciclo flamenco alternativo al festival oficial.',
      'center'
    );
  EXCEPTION
    WHEN OTHERS THEN
      RAISE WARNING 'Error al insertar evento 14 (%): %', 'Jerez Off Festival: Agujetas C...', SQLERRM;
  END;

  -- =========================================
  -- Evento 15: Concierto: José de los Camarones...
  -- =========================================
  BEGIN
    -- Buscar ID de ciudad: Jerez de la Frontera
    SELECT id INTO v_city_id FROM public.cities WHERE LOWER(name) = LOWER('Jerez de la Frontera') LIMIT 1;
    IF v_city_id IS NULL THEN
      RAISE WARNING 'Ciudad no encontrada: %', 'Jerez de la Frontera';
    END IF;
    
    -- Buscar ID de categoría: Música (slug: musica)
    SELECT id INTO v_category_id FROM public.categories WHERE LOWER(slug) = LOWER('musica') OR LOWER(name) = LOWER('Música') LIMIT 1;
    IF v_category_id IS NULL THEN
      RAISE WARNING 'Categoría no encontrada: % (slug: %)', 'Música', 'musica';
    END IF;
    
    -- Generar imagen aleatoria para categoría 1 (Música)
    -- Rango de imágenes: 01.webp - 10.webp
    v_category_number := 1;
    v_max_images := 10;
    v_random_num := 1 + floor(random() * v_max_images)::INT;
    v_image_filename := LPAD(v_random_num::TEXT, 2, '0') || '.webp';
    v_image_url := v_supabase_url || '/sample-images/1/' || v_category_number::TEXT || '/' || v_image_filename;
    
    -- Insertar evento
    INSERT INTO public.events (
      id, title, place, maps_url, image_url, is_featured, is_free, 
      starts_at, city_id, category_id, status, description, image_alignment
    ) VALUES (
      'c34d82e7-f0e9-47d4-941f-1f85f7c70ece',
      'Concierto: José de los Camarones',
      'La Guarida del Ángel, Jerez',
      'https://www.google.com/maps/search/?api=1&query=La+Guarida+del+Angel+Jerez',
      v_image_url,
      FALSE,
      FALSE,
      '2026-02-21T00:00:00Z'::timestamptz,
      v_city_id,
      v_category_id,
      'published',
      'Flamenco puro en el ciclo Off Festival.',
      'center'
    );
  EXCEPTION
    WHEN OTHERS THEN
      RAISE WARNING 'Error al insertar evento 15 (%): %', 'Concierto: José de los Camaron...', SQLERRM;
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
