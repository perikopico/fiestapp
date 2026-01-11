-- ============================================
-- SQL generado automáticamente para insertar eventos desde JSON
-- Fecha de generación: 2026-01-11T00:41:32.739436
-- Total de eventos: 51
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
  -- Evento 1: Inicio del COAC 2026 (Preliminares)...
  -- =========================================
  BEGIN
    -- Buscar ID de ciudad: Cádiz
    SELECT id INTO v_city_id FROM public.cities WHERE LOWER(name) = LOWER('Cádiz') LIMIT 1;
    IF v_city_id IS NULL THEN
      RAISE WARNING 'Ciudad no encontrada: %', 'Cádiz';
    END IF;
    
    -- Buscar ID de categoría: Tradiciones (slug: tradiciones)
    SELECT id INTO v_category_id FROM public.categories WHERE LOWER(slug) = LOWER('tradiciones') OR LOWER(name) = LOWER('Tradiciones') LIMIT 1;
    IF v_category_id IS NULL THEN
      RAISE WARNING 'Categoría no encontrada: % (slug: %)', 'Tradiciones', 'tradiciones';
    END IF;
    
    -- Generar imagen aleatoria para categoría 6 (Tradiciones)
    -- Rango de imágenes: 01.webp - 09.webp
    v_category_number := 6;
    v_max_images := 9;
    v_random_num := 1 + floor(random() * v_max_images)::INT;
    v_image_filename := LPAD(v_random_num::TEXT, 2, '0') || '.webp';
    v_image_url := v_supabase_url || '/sample-images/1/' || v_category_number::TEXT || '/' || v_image_filename;
    
    -- Insertar evento
    INSERT INTO public.events (
      id, title, place, maps_url, image_url, is_featured, is_free, 
      starts_at, city_id, category_id, status, description, image_alignment
    ) VALUES (
      '1d763e93-0a21-4d9a-8bd7-4641d69062c4',
      'Inicio del COAC 2026 (Preliminares)',
      'Gran Teatro Falla',
      'https://www.google.com/maps/search/?api=1&query=Gran+Teatro+Falla+Cadiz',
      v_image_url,
      FALSE,
      FALSE,
      '2026-01-11T20:00:00Z'::timestamptz,
      v_city_id,
      v_category_id,
      'published',
      'El coro de Ceuta ''Al lío'' abre el concurso. Evento retransmitido por radio y TV.',
      'center'
    );
  EXCEPTION
    WHEN OTHERS THEN
      RAISE WARNING 'Error al insertar evento 1 (%): %', 'Inicio del COAC 2026 (Prelimin...', SQLERRM;
  END;

  -- =========================================
  -- Evento 2: XIV Trail Urbano Villaluenga...
  -- =========================================
  BEGIN
    -- Buscar ID de ciudad: Villaluenga del Rosario
    SELECT id INTO v_city_id FROM public.cities WHERE LOWER(name) = LOWER('Villaluenga del Rosario') LIMIT 1;
    IF v_city_id IS NULL THEN
      RAISE WARNING 'Ciudad no encontrada: %', 'Villaluenga del Rosario';
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
      '28023318-2355-44a2-bd12-348a3ed5680d',
      'XIV Trail Urbano Villaluenga',
      'Piscina Municipal',
      'https://www.google.com/maps/search/?api=1&query=Piscina+Municipal+Villaluenga+del+Rosario',
      v_image_url,
      FALSE,
      FALSE,
      '2026-01-11T10:00:00Z'::timestamptz,
      v_city_id,
      v_category_id,
      'published',
      'Prueba exigente que combina el entramado urbano con senderos de la Sierra de Grazalema. Salida desde la Piscina Municipal.',
      'center'
    );
  EXCEPTION
    WHEN OTHERS THEN
      RAISE WARNING 'Error al insertar evento 2 (%): %', 'XIV Trail Urbano Villaluenga...', SQLERRM;
  END;

  -- =========================================
  -- Evento 3: Juan Dávila: La Capital del Pecado 2.0...
  -- =========================================
  BEGIN
    -- Buscar ID de ciudad: Jerez de la Frontera
    SELECT id INTO v_city_id FROM public.cities WHERE LOWER(name) = LOWER('Jerez de la Frontera') LIMIT 1;
    IF v_city_id IS NULL THEN
      RAISE WARNING 'Ciudad no encontrada: %', 'Jerez de la Frontera';
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
      'b2d1b73a-66d4-4a83-b849-b55c415f5b7b',
      'Juan Dávila: La Capital del Pecado 2.0',
      'Teatro Villamarta',
      'https://www.google.com/maps/search/?api=1&query=Teatro+Villamarta+Jerez',
      v_image_url,
      FALSE,
      FALSE,
      '2026-01-11T18:00:00Z'::timestamptz,
      v_city_id,
      v_category_id,
      'published',
      'Última función del show de humor en el Teatro Villamarta.',
      'center'
    );
  EXCEPTION
    WHEN OTHERS THEN
      RAISE WARNING 'Error al insertar evento 3 (%): %', 'Juan Dávila: La Capital del Pe...', SQLERRM;
  END;

  -- =========================================
  -- Evento 4: Clausura XX Encuentro Anual de Belenistas...
  -- =========================================
  BEGIN
    -- Buscar ID de ciudad: Jerez de la Frontera
    SELECT id INTO v_city_id FROM public.cities WHERE LOWER(name) = LOWER('Jerez de la Frontera') LIMIT 1;
    IF v_city_id IS NULL THEN
      RAISE WARNING 'Ciudad no encontrada: %', 'Jerez de la Frontera';
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
      '5b19df69-3d14-4ca7-a5f1-94ef2300667f',
      'Clausura XX Encuentro Anual de Belenistas',
      'Claustros de Santo Domingo',
      'https://www.google.com/maps/search/?api=1&query=Claustros+de+Santo+Domingo+Jerez',
      v_image_url,
      FALSE,
      TRUE,
      '2026-01-11T12:00:00Z'::timestamptz,
      v_city_id,
      v_category_id,
      'published',
      'Cierre del encuentro en los históricos Claustros.',
      'center'
    );
  EXCEPTION
    WHEN OTHERS THEN
      RAISE WARNING 'Error al insertar evento 4 (%): %', 'Clausura XX Encuentro Anual de...', SQLERRM;
  END;

  -- =========================================
  -- Evento 5: 93º Aniversario Sucesos de Casas Viejas...
  -- =========================================
  BEGIN
    -- Buscar ID de ciudad: Benalup-Casas Viejas
    SELECT id INTO v_city_id FROM public.cities WHERE LOWER(name) = LOWER('Benalup-Casas Viejas') LIMIT 1;
    IF v_city_id IS NULL THEN
      RAISE WARNING 'Ciudad no encontrada: %', 'Benalup-Casas Viejas';
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
      'eb29ede0-f441-45f1-be2b-3def31ba36cd',
      '93º Aniversario Sucesos de Casas Viejas',
      NULL,
      'https://www.google.com/maps/search/?api=1&query=Benalup+Casas+Viejas',
      v_image_url,
      FALSE,
      TRUE,
      '2026-01-11T12:00:00Z'::timestamptz,
      v_city_id,
      v_category_id,
      'published',
      'Clausura de los actos conmemorativos históricos.',
      'center'
    );
  EXCEPTION
    WHEN OTHERS THEN
      RAISE WARNING 'Error al insertar evento 5 (%): %', '93º Aniversario Sucesos de Cas...', SQLERRM;
  END;

  -- =========================================
  -- Evento 6: Fútbol: CD Guadiaro vs Barbate CF...
  -- =========================================
  BEGIN
    -- Buscar ID de ciudad: San Roque
    SELECT id INTO v_city_id FROM public.cities WHERE LOWER(name) = LOWER('San Roque') LIMIT 1;
    IF v_city_id IS NULL THEN
      RAISE WARNING 'Ciudad no encontrada: %', 'San Roque';
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
      '11808511-4ef1-45ed-9f6e-affd199982bb',
      'Fútbol: CD Guadiaro vs Barbate CF',
      'Campo de Fútbol La Unión',
      'https://www.google.com/maps/search/?api=1&query=Campo+Futbol+Guadiaro+San+Roque',
      v_image_url,
      FALSE,
      FALSE,
      '2026-01-11T17:00:00Z'::timestamptz,
      v_city_id,
      v_category_id,
      'published',
      'Partido correspondiente a la liga regional.',
      'center'
    );
  EXCEPTION
    WHEN OTHERS THEN
      RAISE WARNING 'Error al insertar evento 6 (%): %', 'Fútbol: CD Guadiaro vs Barbate...', SQLERRM;
  END;

  -- =========================================
  -- Evento 7: COAC 2026: Preliminares (Sesión Diaria)...
  -- =========================================
  BEGIN
    -- Buscar ID de ciudad: Cádiz
    SELECT id INTO v_city_id FROM public.cities WHERE LOWER(name) = LOWER('Cádiz') LIMIT 1;
    IF v_city_id IS NULL THEN
      RAISE WARNING 'Ciudad no encontrada: %', 'Cádiz';
    END IF;
    
    -- Buscar ID de categoría: Tradiciones (slug: tradiciones)
    SELECT id INTO v_category_id FROM public.categories WHERE LOWER(slug) = LOWER('tradiciones') OR LOWER(name) = LOWER('Tradiciones') LIMIT 1;
    IF v_category_id IS NULL THEN
      RAISE WARNING 'Categoría no encontrada: % (slug: %)', 'Tradiciones', 'tradiciones';
    END IF;
    
    -- Generar imagen aleatoria para categoría 6 (Tradiciones)
    -- Rango de imágenes: 01.webp - 09.webp
    v_category_number := 6;
    v_max_images := 9;
    v_random_num := 1 + floor(random() * v_max_images)::INT;
    v_image_filename := LPAD(v_random_num::TEXT, 2, '0') || '.webp';
    v_image_url := v_supabase_url || '/sample-images/1/' || v_category_number::TEXT || '/' || v_image_filename;
    
    -- Insertar evento
    INSERT INTO public.events (
      id, title, place, maps_url, image_url, is_featured, is_free, 
      starts_at, city_id, category_id, status, description, image_alignment
    ) VALUES (
      'ce3b255e-a6b6-46dd-8a1a-e7bf860d1233',
      'COAC 2026: Preliminares (Sesión Diaria)',
      'Gran Teatro Falla',
      'https://www.google.com/maps/search/?api=1&query=Gran+Teatro+Falla+Cadiz',
      v_image_url,
      FALSE,
      FALSE,
      '2026-01-12T20:00:00Z'::timestamptz,
      v_city_id,
      v_category_id,
      'published',
      'Sesión de concurso de agrupaciones.',
      'center'
    );
  EXCEPTION
    WHEN OTHERS THEN
      RAISE WARNING 'Error al insertar evento 7 (%): %', 'COAC 2026: Preliminares (Sesió...', SQLERRM;
  END;

  -- =========================================
  -- Evento 8: Lectura: ''Incendios'' de Wajdi Mouawad...
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
      '7188bdee-7ea8-4e0d-8901-827ade481eae',
      'Lectura: ''Incendios'' de Wajdi Mouawad',
      'Biblioteca Pública Provincial',
      'https://www.google.com/maps/search/?api=1&query=Biblioteca+Publica+Provincial+Cadiz',
      v_image_url,
      FALSE,
      TRUE,
      '2026-01-12T18:30:00Z'::timestamptz,
      v_city_id,
      v_category_id,
      'published',
      'Representación/lectura dramática.',
      'center'
    );
  EXCEPTION
    WHEN OTHERS THEN
      RAISE WARNING 'Error al insertar evento 8 (%): %', 'Lectura: ''Incendios'' de Wajd...', SQLERRM;
  END;

  -- =========================================
  -- Evento 9: Inicio IV Edición Magic Fest 2026...
  -- =========================================
  BEGIN
    -- Buscar ID de ciudad: San Roque
    SELECT id INTO v_city_id FROM public.cities WHERE LOWER(name) = LOWER('San Roque') LIMIT 1;
    IF v_city_id IS NULL THEN
      RAISE WARNING 'Ciudad no encontrada: %', 'San Roque';
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
      '9a01cf7c-0a6b-4e7d-be25-c167ecf6fe46',
      'Inicio IV Edición Magic Fest 2026',
      'Teatro Juan Luis Galiardo',
      'https://www.google.com/maps/search/?api=1&query=Teatro+Juan+Luis+Galiardo+San+Roque',
      v_image_url,
      FALSE,
      TRUE,
      '2026-01-12T20:00:00Z'::timestamptz,
      v_city_id,
      v_category_id,
      'published',
      'Festival de magia con espectáculos en teatro y barriadas (Hasta el 25 Ene).',
      'center'
    );
  EXCEPTION
    WHEN OTHERS THEN
      RAISE WARNING 'Error al insertar evento 9 (%): %', 'Inicio IV Edición Magic Fest 2...', SQLERRM;
  END;

  -- =========================================
  -- Evento 10: Encuentro Amigos de la Biblioteca...
  -- =========================================
  BEGIN
    -- Buscar ID de ciudad: San Roque
    SELECT id INTO v_city_id FROM public.cities WHERE LOWER(name) = LOWER('San Roque') LIMIT 1;
    IF v_city_id IS NULL THEN
      RAISE WARNING 'Ciudad no encontrada: %', 'San Roque';
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
      'acfa4b7a-cb0e-4a2b-8883-de4c11038cc1',
      'Encuentro Amigos de la Biblioteca',
      'Biblioteca Municipal',
      'https://www.google.com/maps/search/?api=1&query=Biblioteca+Municipal+San+Roque',
      v_image_url,
      FALSE,
      TRUE,
      '2026-01-13T18:30:00Z'::timestamptz,
      v_city_id,
      v_category_id,
      'published',
      'Reunión cultural literaria.',
      'center'
    );
  EXCEPTION
    WHEN OTHERS THEN
      RAISE WARNING 'Error al insertar evento 10 (%): %', 'Encuentro Amigos de la Bibliot...', SQLERRM;
  END;

  -- =========================================
  -- Evento 11: Cercle Littéraire Francophone...
  -- =========================================
  BEGIN
    -- Buscar ID de ciudad: Sanlúcar de Barrameda
    SELECT id INTO v_city_id FROM public.cities WHERE LOWER(name) = LOWER('Sanlúcar de Barrameda') LIMIT 1;
    IF v_city_id IS NULL THEN
      RAISE WARNING 'Ciudad no encontrada: %', 'Sanlúcar de Barrameda';
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
      '31d23271-b0f5-428a-885f-e503a077a387',
      'Cercle Littéraire Francophone',
      'Biblioteca Municipal',
      'https://www.google.com/maps/search/?api=1&query=Biblioteca+Municipal+Sanlucar+de+Barrameda',
      v_image_url,
      FALSE,
      TRUE,
      '2026-01-14T19:00:00Z'::timestamptz,
      v_city_id,
      v_category_id,
      'published',
      'Análisis del libro ''Soleil amer'' de Lilia Hassaine.',
      'center'
    );
  EXCEPTION
    WHEN OTHERS THEN
      RAISE WARNING 'Error al insertar evento 11 (%): %', 'Cercle Littéraire Francophone...', SQLERRM;
  END;

  -- =========================================
  -- Evento 12: Teatro: El Barbero de Picasso...
  -- =========================================
  BEGIN
    -- Buscar ID de ciudad: Jerez de la Frontera
    SELECT id INTO v_city_id FROM public.cities WHERE LOWER(name) = LOWER('Jerez de la Frontera') LIMIT 1;
    IF v_city_id IS NULL THEN
      RAISE WARNING 'Ciudad no encontrada: %', 'Jerez de la Frontera';
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
      '4627b486-3036-4eff-bf4d-bf3e75bd92b1',
      'Teatro: El Barbero de Picasso',
      'Teatro Villamarta',
      'https://www.google.com/maps/search/?api=1&query=Teatro+Villamarta+Jerez',
      v_image_url,
      FALSE,
      FALSE,
      '2026-01-16T20:00:00Z'::timestamptz,
      v_city_id,
      v_category_id,
      'published',
      'Con Antonio Molero y Pepe Viyuela. Drama y comedia histórica.',
      'center'
    );
  EXCEPTION
    WHEN OTHERS THEN
      RAISE WARNING 'Error al insertar evento 12 (%): %', 'Teatro: El Barbero de Picasso...', SQLERRM;
  END;

  -- =========================================
  -- Evento 13: Musical: Las Guerreras K-Pop...
  -- =========================================
  BEGIN
    -- Buscar ID de ciudad: Puerto Real
    SELECT id INTO v_city_id FROM public.cities WHERE LOWER(name) = LOWER('Puerto Real') LIMIT 1;
    IF v_city_id IS NULL THEN
      RAISE WARNING 'Ciudad no encontrada: %', 'Puerto Real';
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
      '42fae02d-5c99-4257-82d9-de54ed90abfb',
      'Musical: Las Guerreras K-Pop',
      'Teatro Principal',
      'https://www.google.com/maps/search/?api=1&query=Teatro+Principal+Puerto+Real',
      v_image_url,
      FALSE,
      FALSE,
      '2026-01-16T16:30:00Z'::timestamptz,
      v_city_id,
      v_category_id,
      'published',
      'Tributo musical formato familiar. Doble sesión (también a las 19:00h).',
      'center'
    );
  EXCEPTION
    WHEN OTHERS THEN
      RAISE WARNING 'Error al insertar evento 13 (%): %', 'Musical: Las Guerreras K-Pop...', SQLERRM;
  END;

  -- =========================================
  -- Evento 14: Teatro: Galdós Enamorado...
  -- =========================================
  BEGIN
    -- Buscar ID de ciudad: Chiclana de la Frontera
    SELECT id INTO v_city_id FROM public.cities WHERE LOWER(name) = LOWER('Chiclana de la Frontera') LIMIT 1;
    IF v_city_id IS NULL THEN
      RAISE WARNING 'Ciudad no encontrada: %', 'Chiclana de la Frontera';
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
      '80433600-d829-4bd2-8ee9-c622a7c61302',
      'Teatro: Galdós Enamorado',
      'Teatro Moderno',
      'https://www.google.com/maps/search/?api=1&query=Teatro+Moderno+Chiclana',
      v_image_url,
      FALSE,
      FALSE,
      '2026-01-16T20:00:00Z'::timestamptz,
      v_city_id,
      v_category_id,
      'published',
      'Neolectura teatral con María José Goyanes y Emilio Gutiérrez Caba.',
      'center'
    );
  EXCEPTION
    WHEN OTHERS THEN
      RAISE WARNING 'Error al insertar evento 14 (%): %', 'Teatro: Galdós Enamorado...', SQLERRM;
  END;

  -- =========================================
  -- Evento 15: Concierto: Pasión Vega – Pasión Almodóvar...
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
      '3757b50e-1408-454b-be42-4c1762905293',
      'Concierto: Pasión Vega – Pasión Almodóvar',
      'Teatro Villamarta',
      'https://www.google.com/maps/search/?api=1&query=Teatro+Villamarta+Jerez',
      v_image_url,
      FALSE,
      FALSE,
      '2026-01-17T20:00:00Z'::timestamptz,
      v_city_id,
      v_category_id,
      'published',
      'Fusión de copla, jazz y canción de autor homenajeando al cineasta.',
      'center'
    );
  EXCEPTION
    WHEN OTHERS THEN
      RAISE WARNING 'Error al insertar evento 15 (%): %', 'Concierto: Pasión Vega – Pasió...', SQLERRM;
  END;

  -- =========================================
  -- Evento 16: Monólogo: José Luis Calero...
  -- =========================================
  BEGIN
    -- Buscar ID de ciudad: Rota
    SELECT id INTO v_city_id FROM public.cities WHERE LOWER(name) = LOWER('Rota') LIMIT 1;
    IF v_city_id IS NULL THEN
      RAISE WARNING 'Ciudad no encontrada: %', 'Rota';
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
      '8b4c8ce1-a550-42c6-8242-3a53665c92a9',
      'Monólogo: José Luis Calero',
      'Auditorio Municipal',
      'https://www.google.com/maps/search/?api=1&query=Auditorio+Municipal+Rota',
      v_image_url,
      FALSE,
      FALSE,
      '2026-01-17T20:00:00Z'::timestamptz,
      v_city_id,
      v_category_id,
      'published',
      'Show ''Humorista de Guardia''.',
      'center'
    );
  EXCEPTION
    WHEN OTHERS THEN
      RAISE WARNING 'Error al insertar evento 16 (%): %', 'Monólogo: José Luis Calero...', SQLERRM;
  END;

  -- =========================================
  -- Evento 17: Ruta Senderismo Los Alcornocales...
  -- =========================================
  BEGIN
    -- Buscar ID de ciudad: Rota
    SELECT id INTO v_city_id FROM public.cities WHERE LOWER(name) = LOWER('Rota') LIMIT 1;
    IF v_city_id IS NULL THEN
      RAISE WARNING 'Ciudad no encontrada: %', 'Rota';
    END IF;
    
    -- Buscar ID de categoría: Aire Libre (slug: aire-libre)
    SELECT id INTO v_category_id FROM public.categories WHERE LOWER(slug) = LOWER('aire-libre') OR LOWER(name) = LOWER('Aire Libre') LIMIT 1;
    IF v_category_id IS NULL THEN
      RAISE WARNING 'Categoría no encontrada: % (slug: %)', 'Aire Libre', 'aire-libre';
    END IF;
    
    -- Generar imagen aleatoria para categoría 5 (Aire Libre)
    -- Rango de imágenes: 01.webp - 10.webp
    v_category_number := 5;
    v_max_images := 10;
    v_random_num := 1 + floor(random() * v_max_images)::INT;
    v_image_filename := LPAD(v_random_num::TEXT, 2, '0') || '.webp';
    v_image_url := v_supabase_url || '/sample-images/1/' || v_category_number::TEXT || '/' || v_image_filename;
    
    -- Insertar evento
    INSERT INTO public.events (
      id, title, place, maps_url, image_url, is_featured, is_free, 
      starts_at, city_id, category_id, status, description, image_alignment
    ) VALUES (
      '2730f078-a86a-4cdf-8131-26921ef1abfd',
      'Ruta Senderismo Los Alcornocales',
      'Parque Natural Los Alcornocales (Salida Rota)',
      'https://www.google.com/maps/search/?api=1&query=Parque+Los+Alcornocales',
      v_image_url,
      FALSE,
      FALSE,
      '2026-01-17T09:00:00Z'::timestamptz,
      v_city_id,
      v_category_id,
      'published',
      'Organizada por club local Ruta Circular.',
      'center'
    );
  EXCEPTION
    WHEN OTHERS THEN
      RAISE WARNING 'Error al insertar evento 17 (%): %', 'Ruta Senderismo Los Alcornocal...', SQLERRM;
  END;

  -- =========================================
  -- Evento 18: Limpieza Playa Yerbabuena (Voluntariado)...
  -- =========================================
  BEGIN
    -- Buscar ID de ciudad: Barbate
    SELECT id INTO v_city_id FROM public.cities WHERE LOWER(name) = LOWER('Barbate') LIMIT 1;
    IF v_city_id IS NULL THEN
      RAISE WARNING 'Ciudad no encontrada: %', 'Barbate';
    END IF;
    
    -- Buscar ID de categoría: Aire Libre (slug: aire-libre)
    SELECT id INTO v_category_id FROM public.categories WHERE LOWER(slug) = LOWER('aire-libre') OR LOWER(name) = LOWER('Aire Libre') LIMIT 1;
    IF v_category_id IS NULL THEN
      RAISE WARNING 'Categoría no encontrada: % (slug: %)', 'Aire Libre', 'aire-libre';
    END IF;
    
    -- Generar imagen aleatoria para categoría 5 (Aire Libre)
    -- Rango de imágenes: 01.webp - 10.webp
    v_category_number := 5;
    v_max_images := 10;
    v_random_num := 1 + floor(random() * v_max_images)::INT;
    v_image_filename := LPAD(v_random_num::TEXT, 2, '0') || '.webp';
    v_image_url := v_supabase_url || '/sample-images/1/' || v_category_number::TEXT || '/' || v_image_filename;
    
    -- Insertar evento
    INSERT INTO public.events (
      id, title, place, maps_url, image_url, is_featured, is_free, 
      starts_at, city_id, category_id, status, description, image_alignment
    ) VALUES (
      '69fc07ab-3619-4e1c-8e93-4d5b3b1bd14b',
      'Limpieza Playa Yerbabuena (Voluntariado)',
      'Playa de la Yerbabuena',
      'https://www.google.com/maps/search/?api=1&query=Playa+Yerbabuena+Barbate',
      v_image_url,
      FALSE,
      TRUE,
      '2026-01-17T10:00:00Z'::timestamptz,
      v_city_id,
      v_category_id,
      'published',
      'Vinculada al XII Open Surf Yerbabuena.',
      'center'
    );
  EXCEPTION
    WHEN OTHERS THEN
      RAISE WARNING 'Error al insertar evento 18 (%): %', 'Limpieza Playa Yerbabuena (Vol...', SQLERRM;
  END;

  -- =========================================
  -- Evento 19: David Navarro: No tengo remedio...
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
      '6728fc62-b41c-4c92-8f9d-5d040c130765',
      'David Navarro: No tengo remedio',
      'Teatro Florida',
      'https://www.google.com/maps/search/?api=1&query=Teatro+Florida+Algeciras',
      v_image_url,
      FALSE,
      FALSE,
      '2026-01-17T21:00:00Z'::timestamptz,
      v_city_id,
      v_category_id,
      'published',
      'Monólogo de humor.',
      'center'
    );
  EXCEPTION
    WHEN OTHERS THEN
      RAISE WARNING 'Error al insertar evento 19 (%): %', 'David Navarro: No tengo remedi...', SQLERRM;
  END;

  -- =========================================
  -- Evento 20: Piano: Ramón Grau...
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
      '51e9c928-ac89-48bc-a2a7-b63483602daf',
      'Piano: Ramón Grau',
      'Teatro Villamarta',
      'https://www.google.com/maps/search/?api=1&query=Teatro+Villamarta+Jerez',
      v_image_url,
      FALSE,
      FALSE,
      '2026-01-18T19:00:00Z'::timestamptz,
      v_city_id,
      v_category_id,
      'published',
      'Recital ''La Historia del Piano en España''.',
      'center'
    );
  EXCEPTION
    WHEN OTHERS THEN
      RAISE WARNING 'Error al insertar evento 20 (%): %', 'Piano: Ramón Grau...', SQLERRM;
  END;

  -- =========================================
  -- Evento 21: VIII Carrera El Pilar-Marianistas...
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
      'c3efbf75-9a0a-476a-9fb6-230687d82fd8',
      'VIII Carrera El Pilar-Marianistas',
      'Colegio El Pilar',
      'https://www.google.com/maps/search/?api=1&query=Colegio+El+Pilar+Jerez',
      v_image_url,
      FALSE,
      FALSE,
      '2026-01-18T10:00:00Z'::timestamptz,
      v_city_id,
      v_category_id,
      'published',
      'Carrera popular con gran arraigo local.',
      'center'
    );
  EXCEPTION
    WHEN OTHERS THEN
      RAISE WARNING 'Error al insertar evento 21 (%): %', 'VIII Carrera El Pilar-Marianis...', SQLERRM;
  END;

  -- =========================================
  -- Evento 22: II Trail Villa de El Bosque...
  -- =========================================
  BEGIN
    -- Buscar ID de ciudad: El Bosque
    SELECT id INTO v_city_id FROM public.cities WHERE LOWER(name) = LOWER('El Bosque') LIMIT 1;
    IF v_city_id IS NULL THEN
      RAISE WARNING 'Ciudad no encontrada: %', 'El Bosque';
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
      '35057039-bef4-4720-a8ce-4b9b7c0333f3',
      'II Trail Villa de El Bosque',
      NULL,
      'https://www.google.com/maps/search/?api=1&query=El+Bosque+Cadiz',
      v_image_url,
      FALSE,
      FALSE,
      '2026-01-18T11:30:00Z'::timestamptz,
      v_city_id,
      v_category_id,
      'published',
      '12 km por senderos del Parque Natural Sierra de Grazalema y río Majaceite.',
      'center'
    );
  EXCEPTION
    WHEN OTHERS THEN
      RAISE WARNING 'Error al insertar evento 22 (%): %', 'II Trail Villa de El Bosque...', SQLERRM;
  END;

  -- =========================================
  -- Evento 23: Gala Internacional de Magia Infantil...
  -- =========================================
  BEGIN
    -- Buscar ID de ciudad: San Roque
    SELECT id INTO v_city_id FROM public.cities WHERE LOWER(name) = LOWER('San Roque') LIMIT 1;
    IF v_city_id IS NULL THEN
      RAISE WARNING 'Ciudad no encontrada: %', 'San Roque';
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
      'b072167b-6f9a-420f-9a17-14dec8aa2439',
      'Gala Internacional de Magia Infantil',
      'Teatro Juan Luis Galiardo',
      'https://www.google.com/maps/search/?api=1&query=Teatro+Juan+Luis+Galiardo+San+Roque',
      v_image_url,
      FALSE,
      FALSE,
      '2026-01-18T12:00:00Z'::timestamptz,
      v_city_id,
      v_category_id,
      'published',
      'Evento familiar parte del Magic Fest.',
      'center'
    );
  EXCEPTION
    WHEN OTHERS THEN
      RAISE WARNING 'Error al insertar evento 23 (%): %', 'Gala Internacional de Magia In...', SQLERRM;
  END;

  -- =========================================
  -- Evento 24: Romería de San Sebastián...
  -- =========================================
  BEGIN
    -- Buscar ID de ciudad: Conil de la Frontera
    SELECT id INTO v_city_id FROM public.cities WHERE LOWER(name) = LOWER('Conil de la Frontera') LIMIT 1;
    IF v_city_id IS NULL THEN
      RAISE WARNING 'Ciudad no encontrada: %', 'Conil de la Frontera';
    END IF;
    
    -- Buscar ID de categoría: Tradiciones (slug: tradiciones)
    SELECT id INTO v_category_id FROM public.categories WHERE LOWER(slug) = LOWER('tradiciones') OR LOWER(name) = LOWER('Tradiciones') LIMIT 1;
    IF v_category_id IS NULL THEN
      RAISE WARNING 'Categoría no encontrada: % (slug: %)', 'Tradiciones', 'tradiciones';
    END IF;
    
    -- Generar imagen aleatoria para categoría 6 (Tradiciones)
    -- Rango de imágenes: 01.webp - 09.webp
    v_category_number := 6;
    v_max_images := 9;
    v_random_num := 1 + floor(random() * v_max_images)::INT;
    v_image_filename := LPAD(v_random_num::TEXT, 2, '0') || '.webp';
    v_image_url := v_supabase_url || '/sample-images/1/' || v_category_number::TEXT || '/' || v_image_filename;
    
    -- Insertar evento
    INSERT INTO public.events (
      id, title, place, maps_url, image_url, is_featured, is_free, 
      starts_at, city_id, category_id, status, description, image_alignment
    ) VALUES (
      '7e384e48-4762-4cb3-891c-4b441f54e939',
      'Romería de San Sebastián',
      'Pinares de El Colorado',
      'https://www.google.com/maps/search/?api=1&query=Pinares+de+El+Colorado+Conil',
      v_image_url,
      FALSE,
      TRUE,
      '2026-01-18T10:00:00Z'::timestamptz,
      v_city_id,
      v_category_id,
      'published',
      'Jornada de convivencia campestre en los pinares de El Colorado.',
      'center'
    );
  EXCEPTION
    WHEN OTHERS THEN
      RAISE WARNING 'Error al insertar evento 24 (%): %', 'Romería de San Sebastián...', SQLERRM;
  END;

  -- =========================================
  -- Evento 25: Inauguración Pasarela Flamenca Tío Pepe 2026...
  -- =========================================
  BEGIN
    -- Buscar ID de ciudad: Jerez de la Frontera
    SELECT id INTO v_city_id FROM public.cities WHERE LOWER(name) = LOWER('Jerez de la Frontera') LIMIT 1;
    IF v_city_id IS NULL THEN
      RAISE WARNING 'Ciudad no encontrada: %', 'Jerez de la Frontera';
    END IF;
    
    -- Buscar ID de categoría: Tradiciones (slug: tradiciones)
    SELECT id INTO v_category_id FROM public.categories WHERE LOWER(slug) = LOWER('tradiciones') OR LOWER(name) = LOWER('Tradiciones') LIMIT 1;
    IF v_category_id IS NULL THEN
      RAISE WARNING 'Categoría no encontrada: % (slug: %)', 'Tradiciones', 'tradiciones';
    END IF;
    
    -- Generar imagen aleatoria para categoría 6 (Tradiciones)
    -- Rango de imágenes: 01.webp - 09.webp
    v_category_number := 6;
    v_max_images := 9;
    v_random_num := 1 + floor(random() * v_max_images)::INT;
    v_image_filename := LPAD(v_random_num::TEXT, 2, '0') || '.webp';
    v_image_url := v_supabase_url || '/sample-images/1/' || v_category_number::TEXT || '/' || v_image_filename;
    
    -- Insertar evento
    INSERT INTO public.events (
      id, title, place, maps_url, image_url, is_featured, is_free, 
      starts_at, city_id, category_id, status, description, image_alignment
    ) VALUES (
      '49b76577-01bd-47d3-9feb-a3cd2b3ea8e0',
      'Inauguración Pasarela Flamenca Tío Pepe 2026',
      'Bodegas González Byass',
      'https://www.google.com/maps/search/?api=1&query=Bodegas+Gonzalez+Byass+Jerez',
      v_image_url,
      FALSE,
      TRUE,
      '2026-01-21T18:00:00Z'::timestamptz,
      v_city_id,
      v_category_id,
      'published',
      'Desfile inaugural Innova Flamenca en Bodegas González Byass.',
      'center'
    );
  EXCEPTION
    WHEN OTHERS THEN
      RAISE WARNING 'Error al insertar evento 25 (%): %', 'Inauguración Pasarela Flamenca...', SQLERRM;
  END;

  -- =========================================
  -- Evento 26: Teatro Familiar: Lúa...
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
      'f2de0988-1c91-4342-90c5-9069a95799f8',
      'Teatro Familiar: Lúa',
      'Teatro del Títere La Tía Norica',
      'https://www.google.com/maps/search/?api=1&query=Teatro+Titere+Tia+Norica+Cadiz',
      v_image_url,
      FALSE,
      FALSE,
      '2026-01-23T18:00:00Z'::timestamptz,
      v_city_id,
      v_category_id,
      'published',
      'Teatro de objetos y sombras por Voilá Producciones.',
      'center'
    );
  EXCEPTION
    WHEN OTHERS THEN
      RAISE WARNING 'Error al insertar evento 26 (%): %', 'Teatro Familiar: Lúa...', SQLERRM;
  END;

  -- =========================================
  -- Evento 27: Concierto Homenaje a Robe Iniesta...
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
      '37b299fc-d585-42aa-b388-07b9ac0b1377',
      'Concierto Homenaje a Robe Iniesta',
      'Sala La Báskula',
      'https://www.google.com/maps/search/?api=1&query=Sala+La+Baskula+Cadiz',
      v_image_url,
      FALSE,
      TRUE,
      '2026-01-23T20:00:00Z'::timestamptz,
      v_city_id,
      v_category_id,
      'published',
      'Entrada gratuita hasta completar aforo.',
      'center'
    );
  EXCEPTION
    WHEN OTHERS THEN
      RAISE WARNING 'Error al insertar evento 27 (%): %', 'Concierto Homenaje a Robe Inie...', SQLERRM;
  END;

  -- =========================================
  -- Evento 28: Concierto: María Parrado...
  -- =========================================
  BEGIN
    -- Buscar ID de ciudad: Chiclana de la Frontera
    SELECT id INTO v_city_id FROM public.cities WHERE LOWER(name) = LOWER('Chiclana de la Frontera') LIMIT 1;
    IF v_city_id IS NULL THEN
      RAISE WARNING 'Ciudad no encontrada: %', 'Chiclana de la Frontera';
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
      '3ef03a8b-a2b9-4d19-8f0e-409335185c8c',
      'Concierto: María Parrado',
      'Teatro Moderno',
      'https://www.google.com/maps/search/?api=1&query=Teatro+Moderno+Chiclana',
      v_image_url,
      FALSE,
      FALSE,
      '2026-01-23T20:00:00Z'::timestamptz,
      v_city_id,
      v_category_id,
      'published',
      'Presenta ''La niña que fui''.',
      'center'
    );
  EXCEPTION
    WHEN OTHERS THEN
      RAISE WARNING 'Error al insertar evento 28 (%): %', 'Concierto: María Parrado...', SQLERRM;
  END;

  -- =========================================
  -- Evento 29: Ópera: I Tre Gobbi...
  -- =========================================
  BEGIN
    -- Buscar ID de ciudad: Jerez de la Frontera
    SELECT id INTO v_city_id FROM public.cities WHERE LOWER(name) = LOWER('Jerez de la Frontera') LIMIT 1;
    IF v_city_id IS NULL THEN
      RAISE WARNING 'Ciudad no encontrada: %', 'Jerez de la Frontera';
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
      '87722cf4-be94-4a1f-9dc8-bf2bdb36297c',
      'Ópera: I Tre Gobbi',
      'Teatro Villamarta',
      'https://www.google.com/maps/search/?api=1&query=Teatro+Villamarta+Jerez',
      v_image_url,
      FALSE,
      FALSE,
      '2026-01-24T20:00:00Z'::timestamptz,
      v_city_id,
      v_category_id,
      'published',
      'Recuperación de patrimonio lírico andaluz.',
      'center'
    );
  EXCEPTION
    WHEN OTHERS THEN
      RAISE WARNING 'Error al insertar evento 29 (%): %', 'Ópera: I Tre Gobbi...', SQLERRM;
  END;

  -- =========================================
  -- Evento 30: I Certamen Nacional de Coplas...
  -- =========================================
  BEGIN
    -- Buscar ID de ciudad: San Roque
    SELECT id INTO v_city_id FROM public.cities WHERE LOWER(name) = LOWER('San Roque') LIMIT 1;
    IF v_city_id IS NULL THEN
      RAISE WARNING 'Ciudad no encontrada: %', 'San Roque';
    END IF;
    
    -- Buscar ID de categoría: Tradiciones (slug: tradiciones)
    SELECT id INTO v_category_id FROM public.categories WHERE LOWER(slug) = LOWER('tradiciones') OR LOWER(name) = LOWER('Tradiciones') LIMIT 1;
    IF v_category_id IS NULL THEN
      RAISE WARNING 'Categoría no encontrada: % (slug: %)', 'Tradiciones', 'tradiciones';
    END IF;
    
    -- Generar imagen aleatoria para categoría 6 (Tradiciones)
    -- Rango de imágenes: 01.webp - 09.webp
    v_category_number := 6;
    v_max_images := 9;
    v_random_num := 1 + floor(random() * v_max_images)::INT;
    v_image_filename := LPAD(v_random_num::TEXT, 2, '0') || '.webp';
    v_image_url := v_supabase_url || '/sample-images/1/' || v_category_number::TEXT || '/' || v_image_filename;
    
    -- Insertar evento
    INSERT INTO public.events (
      id, title, place, maps_url, image_url, is_featured, is_free, 
      starts_at, city_id, category_id, status, description, image_alignment
    ) VALUES (
      '17be4d17-97e5-4273-9b08-81df27765a32',
      'I Certamen Nacional de Coplas',
      'Teatro Juan Luis Galiardo',
      'https://www.google.com/maps/search/?api=1&query=Teatro+Juan+Luis+Galiardo+San+Roque',
      v_image_url,
      FALSE,
      TRUE,
      '2026-01-24T20:30:00Z'::timestamptz,
      v_city_id,
      v_category_id,
      'published',
      'Ciudad de San Roque.',
      'center'
    );
  EXCEPTION
    WHEN OTHERS THEN
      RAISE WARNING 'Error al insertar evento 30 (%): %', 'I Certamen Nacional de Coplas...', SQLERRM;
  END;

  -- =========================================
  -- Evento 31: Tributo Dire Straits: Alchemy Project...
  -- =========================================
  BEGIN
    -- Buscar ID de ciudad: Algeciras
    SELECT id INTO v_city_id FROM public.cities WHERE LOWER(name) = LOWER('Algeciras') LIMIT 1;
    IF v_city_id IS NULL THEN
      RAISE WARNING 'Ciudad no encontrada: %', 'Algeciras';
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
      '37cfacb6-a922-44a1-a0b0-75af8b291f92',
      'Tributo Dire Straits: Alchemy Project',
      NULL,
      'https://www.google.com/maps/search/?api=1&query=Algeciras',
      v_image_url,
      FALSE,
      FALSE,
      '2026-01-24T21:00:00Z'::timestamptz,
      v_city_id,
      v_category_id,
      'published',
      'Homenaje musical.',
      'center'
    );
  EXCEPTION
    WHEN OTHERS THEN
      RAISE WARNING 'Error al insertar evento 31 (%): %', 'Tributo Dire Straits: Alchemy ...', SQLERRM;
  END;

  -- =========================================
  -- Evento 32: XXXIX Ostionada Popular...
  -- =========================================
  BEGIN
    -- Buscar ID de ciudad: Cádiz
    SELECT id INTO v_city_id FROM public.cities WHERE LOWER(name) = LOWER('Cádiz') LIMIT 1;
    IF v_city_id IS NULL THEN
      RAISE WARNING 'Ciudad no encontrada: %', 'Cádiz';
    END IF;
    
    -- Buscar ID de categoría: Gastronomía (slug: gastronomia)
    SELECT id INTO v_category_id FROM public.categories WHERE LOWER(slug) = LOWER('gastronomia') OR LOWER(name) = LOWER('Gastronomía') LIMIT 1;
    IF v_category_id IS NULL THEN
      RAISE WARNING 'Categoría no encontrada: % (slug: %)', 'Gastronomía', 'gastronomia';
    END IF;
    
    -- Generar imagen aleatoria para categoría 2 (Gastronomía)
    -- Rango de imágenes: 01.webp - 14.webp
    v_category_number := 2;
    v_max_images := 14;
    v_random_num := 1 + floor(random() * v_max_images)::INT;
    v_image_filename := LPAD(v_random_num::TEXT, 2, '0') || '.webp';
    v_image_url := v_supabase_url || '/sample-images/1/' || v_category_number::TEXT || '/' || v_image_filename;
    
    -- Insertar evento
    INSERT INTO public.events (
      id, title, place, maps_url, image_url, is_featured, is_free, 
      starts_at, city_id, category_id, status, description, image_alignment
    ) VALUES (
      '3d756238-750b-45bb-a19d-bc3bd63d9f9b',
      'XXXIX Ostionada Popular',
      'Plaza de San Antonio',
      'https://www.google.com/maps/search/?api=1&query=Plaza+San+Antonio+Cadiz',
      v_image_url,
      FALSE,
      TRUE,
      '2026-01-25T13:30:00Z'::timestamptz,
      v_city_id,
      v_category_id,
      'published',
      'Reparto gratuito de ostiones, pimientos y cerveza con coros de carnaval.',
      'center'
    );
  EXCEPTION
    WHEN OTHERS THEN
      RAISE WARNING 'Error al insertar evento 32 (%): %', 'XXXIX Ostionada Popular...', SQLERRM;
  END;

  -- =========================================
  -- Evento 33: VI Ruta MTB Barbate...
  -- =========================================
  BEGIN
    -- Buscar ID de ciudad: Barbate
    SELECT id INTO v_city_id FROM public.cities WHERE LOWER(name) = LOWER('Barbate') LIMIT 1;
    IF v_city_id IS NULL THEN
      RAISE WARNING 'Ciudad no encontrada: %', 'Barbate';
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
      '5a09352e-6cc1-46da-ae0e-75a8088b602b',
      'VI Ruta MTB Barbate',
      NULL,
      'https://www.google.com/maps/search/?api=1&query=Barbate',
      v_image_url,
      FALSE,
      FALSE,
      '2026-01-25T09:00:00Z'::timestamptz,
      v_city_id,
      v_category_id,
      'published',
      '47 km por el Parque Natural de la Breña.',
      'center'
    );
  EXCEPTION
    WHEN OTHERS THEN
      RAISE WARNING 'Error al insertar evento 33 (%): %', 'VI Ruta MTB Barbate...', SQLERRM;
  END;

  -- =========================================
  -- Evento 34: Inicio Cuartos de Final COAC 2026...
  -- =========================================
  BEGIN
    -- Buscar ID de ciudad: Cádiz
    SELECT id INTO v_city_id FROM public.cities WHERE LOWER(name) = LOWER('Cádiz') LIMIT 1;
    IF v_city_id IS NULL THEN
      RAISE WARNING 'Ciudad no encontrada: %', 'Cádiz';
    END IF;
    
    -- Buscar ID de categoría: Tradiciones (slug: tradiciones)
    SELECT id INTO v_category_id FROM public.categories WHERE LOWER(slug) = LOWER('tradiciones') OR LOWER(name) = LOWER('Tradiciones') LIMIT 1;
    IF v_category_id IS NULL THEN
      RAISE WARNING 'Categoría no encontrada: % (slug: %)', 'Tradiciones', 'tradiciones';
    END IF;
    
    -- Generar imagen aleatoria para categoría 6 (Tradiciones)
    -- Rango de imágenes: 01.webp - 09.webp
    v_category_number := 6;
    v_max_images := 9;
    v_random_num := 1 + floor(random() * v_max_images)::INT;
    v_image_filename := LPAD(v_random_num::TEXT, 2, '0') || '.webp';
    v_image_url := v_supabase_url || '/sample-images/1/' || v_category_number::TEXT || '/' || v_image_filename;
    
    -- Insertar evento
    INSERT INTO public.events (
      id, title, place, maps_url, image_url, is_featured, is_free, 
      starts_at, city_id, category_id, status, description, image_alignment
    ) VALUES (
      'f7edf9da-3f09-44f3-947d-c462479f137a',
      'Inicio Cuartos de Final COAC 2026',
      'Gran Teatro Falla',
      'https://www.google.com/maps/search/?api=1&query=Gran+Teatro+Falla+Cadiz',
      v_image_url,
      FALSE,
      FALSE,
      '2026-01-30T20:00:00Z'::timestamptz,
      v_city_id,
      v_category_id,
      'published',
      'Fase eliminatoria del concurso oficial.',
      'center'
    );
  EXCEPTION
    WHEN OTHERS THEN
      RAISE WARNING 'Error al insertar evento 34 (%): %', 'Inicio Cuartos de Final COAC 2...', SQLERRM;
  END;

  -- =========================================
  -- Evento 35: IV Media Maratón Ciudad de Arcos...
  -- =========================================
  BEGIN
    -- Buscar ID de ciudad: Arcos de la Frontera
    SELECT id INTO v_city_id FROM public.cities WHERE LOWER(name) = LOWER('Arcos de la Frontera') LIMIT 1;
    IF v_city_id IS NULL THEN
      RAISE WARNING 'Ciudad no encontrada: %', 'Arcos de la Frontera';
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
      'd4da08fa-4129-4b50-b1f6-258bef422a52',
      'IV Media Maratón Ciudad de Arcos',
      NULL,
      'https://www.google.com/maps/search/?api=1&query=Arcos+de+la+Frontera',
      v_image_url,
      FALSE,
      FALSE,
      '2026-01-31T10:00:00Z'::timestamptz,
      v_city_id,
      v_category_id,
      'published',
      'Prueba atlética con desnivel por el municipio serrano.',
      'center'
    );
  EXCEPTION
    WHEN OTHERS THEN
      RAISE WARNING 'Error al insertar evento 35 (%): %', 'IV Media Maratón Ciudad de Arc...', SQLERRM;
  END;

  -- =========================================
  -- Evento 36: Presentación Oficial Carnaval Chipiona 2026...
  -- =========================================
  BEGIN
    -- Buscar ID de ciudad: Chipiona
    SELECT id INTO v_city_id FROM public.cities WHERE LOWER(name) = LOWER('Chipiona') LIMIT 1;
    IF v_city_id IS NULL THEN
      RAISE WARNING 'Ciudad no encontrada: %', 'Chipiona';
    END IF;
    
    -- Buscar ID de categoría: Tradiciones (slug: tradiciones)
    SELECT id INTO v_category_id FROM public.categories WHERE LOWER(slug) = LOWER('tradiciones') OR LOWER(name) = LOWER('Tradiciones') LIMIT 1;
    IF v_category_id IS NULL THEN
      RAISE WARNING 'Categoría no encontrada: % (slug: %)', 'Tradiciones', 'tradiciones';
    END IF;
    
    -- Generar imagen aleatoria para categoría 6 (Tradiciones)
    -- Rango de imágenes: 01.webp - 09.webp
    v_category_number := 6;
    v_max_images := 9;
    v_random_num := 1 + floor(random() * v_max_images)::INT;
    v_image_filename := LPAD(v_random_num::TEXT, 2, '0') || '.webp';
    v_image_url := v_supabase_url || '/sample-images/1/' || v_category_number::TEXT || '/' || v_image_filename;
    
    -- Insertar evento
    INSERT INTO public.events (
      id, title, place, maps_url, image_url, is_featured, is_free, 
      starts_at, city_id, category_id, status, description, image_alignment
    ) VALUES (
      '043101b2-afd0-4f73-a698-d07cf4924ed5',
      'Presentación Oficial Carnaval Chipiona 2026',
      'Palacio de Ferias',
      'https://www.google.com/maps/search/?api=1&query=Palacio+Ferias+Chipiona',
      v_image_url,
      FALSE,
      TRUE,
      '2026-01-31T21:00:00Z'::timestamptz,
      v_city_id,
      v_category_id,
      'published',
      'Inicio de los actos del carnaval.',
      'center'
    );
  EXCEPTION
    WHEN OTHERS THEN
      RAISE WARNING 'Error al insertar evento 36 (%): %', 'Presentación Oficial Carnaval ...', SQLERRM;
  END;

  -- =========================================
  -- Evento 37: XLIV Erizada Popular...
  -- =========================================
  BEGIN
    -- Buscar ID de ciudad: Cádiz
    SELECT id INTO v_city_id FROM public.cities WHERE LOWER(name) = LOWER('Cádiz') LIMIT 1;
    IF v_city_id IS NULL THEN
      RAISE WARNING 'Ciudad no encontrada: %', 'Cádiz';
    END IF;
    
    -- Buscar ID de categoría: Gastronomía (slug: gastronomia)
    SELECT id INTO v_category_id FROM public.categories WHERE LOWER(slug) = LOWER('gastronomia') OR LOWER(name) = LOWER('Gastronomía') LIMIT 1;
    IF v_category_id IS NULL THEN
      RAISE WARNING 'Categoría no encontrada: % (slug: %)', 'Gastronomía', 'gastronomia';
    END IF;
    
    -- Generar imagen aleatoria para categoría 2 (Gastronomía)
    -- Rango de imágenes: 01.webp - 14.webp
    v_category_number := 2;
    v_max_images := 14;
    v_random_num := 1 + floor(random() * v_max_images)::INT;
    v_image_filename := LPAD(v_random_num::TEXT, 2, '0') || '.webp';
    v_image_url := v_supabase_url || '/sample-images/1/' || v_category_number::TEXT || '/' || v_image_filename;
    
    -- Insertar evento
    INSERT INTO public.events (
      id, title, place, maps_url, image_url, is_featured, is_free, 
      starts_at, city_id, category_id, status, description, image_alignment
    ) VALUES (
      '212256dc-76b0-4097-8dec-789fd73ed667',
      'XLIV Erizada Popular',
      'Calle de la Palma',
      'https://www.google.com/maps/search/?api=1&query=Calle+de+la+Palma+Cadiz',
      v_image_url,
      FALSE,
      TRUE,
      '2026-02-01T13:30:00Z'::timestamptz,
      v_city_id,
      v_category_id,
      'published',
      'Degustación de erizos de mar en el Barrio de la Viña.',
      'center'
    );
  EXCEPTION
    WHEN OTHERS THEN
      RAISE WARNING 'Error al insertar evento 37 (%): %', 'XLIV Erizada Popular...', SQLERRM;
  END;

  -- =========================================
  -- Evento 38: Mejillonada Popular...
  -- =========================================
  BEGIN
    -- Buscar ID de ciudad: Cádiz
    SELECT id INTO v_city_id FROM public.cities WHERE LOWER(name) = LOWER('Cádiz') LIMIT 1;
    IF v_city_id IS NULL THEN
      RAISE WARNING 'Ciudad no encontrada: %', 'Cádiz';
    END IF;
    
    -- Buscar ID de categoría: Gastronomía (slug: gastronomia)
    SELECT id INTO v_category_id FROM public.categories WHERE LOWER(slug) = LOWER('gastronomia') OR LOWER(name) = LOWER('Gastronomía') LIMIT 1;
    IF v_category_id IS NULL THEN
      RAISE WARNING 'Categoría no encontrada: % (slug: %)', 'Gastronomía', 'gastronomia';
    END IF;
    
    -- Generar imagen aleatoria para categoría 2 (Gastronomía)
    -- Rango de imágenes: 01.webp - 14.webp
    v_category_number := 2;
    v_max_images := 14;
    v_random_num := 1 + floor(random() * v_max_images)::INT;
    v_image_filename := LPAD(v_random_num::TEXT, 2, '0') || '.webp';
    v_image_url := v_supabase_url || '/sample-images/1/' || v_category_number::TEXT || '/' || v_image_filename;
    
    -- Insertar evento
    INSERT INTO public.events (
      id, title, place, maps_url, image_url, is_featured, is_free, 
      starts_at, city_id, category_id, status, description, image_alignment
    ) VALUES (
      'dcac9147-056a-4aee-8ba6-9d39d59f25bc',
      'Mejillonada Popular',
      'Peña La Perla de',
      'https://www.google.com/maps/search/?api=1&query=Peña+La+Perla+de+Cadiz',
      v_image_url,
      FALSE,
      TRUE,
      '2026-02-01T13:30:00Z'::timestamptz,
      v_city_id,
      v_category_id,
      'published',
      'Degustación de mejillones y flamenco.',
      'center'
    );
  EXCEPTION
    WHEN OTHERS THEN
      RAISE WARNING 'Error al insertar evento 38 (%): %', 'Mejillonada Popular...', SQLERRM;
  END;

  -- =========================================
  -- Evento 39: Teatro: Los Lunes al Sol...
  -- =========================================
  BEGIN
    -- Buscar ID de ciudad: Jerez de la Frontera
    SELECT id INTO v_city_id FROM public.cities WHERE LOWER(name) = LOWER('Jerez de la Frontera') LIMIT 1;
    IF v_city_id IS NULL THEN
      RAISE WARNING 'Ciudad no encontrada: %', 'Jerez de la Frontera';
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
      '53aec284-e271-486b-92d7-f63089f0971a',
      'Teatro: Los Lunes al Sol',
      'Teatro Villamarta',
      'https://www.google.com/maps/search/?api=1&query=Teatro+Villamarta+Jerez',
      v_image_url,
      FALSE,
      FALSE,
      '2026-02-06T20:00:00Z'::timestamptz,
      v_city_id,
      v_category_id,
      'published',
      'Adaptación teatral de la película.',
      'center'
    );
  EXCEPTION
    WHEN OTHERS THEN
      RAISE WARNING 'Error al insertar evento 39 (%): %', 'Teatro: Los Lunes al Sol...', SQLERRM;
  END;

  -- =========================================
  -- Evento 40: Inicio Carnaval de Arcos 2026...
  -- =========================================
  BEGIN
    -- Buscar ID de ciudad: Arcos de la Frontera
    SELECT id INTO v_city_id FROM public.cities WHERE LOWER(name) = LOWER('Arcos de la Frontera') LIMIT 1;
    IF v_city_id IS NULL THEN
      RAISE WARNING 'Ciudad no encontrada: %', 'Arcos de la Frontera';
    END IF;
    
    -- Buscar ID de categoría: Tradiciones (slug: tradiciones)
    SELECT id INTO v_category_id FROM public.categories WHERE LOWER(slug) = LOWER('tradiciones') OR LOWER(name) = LOWER('Tradiciones') LIMIT 1;
    IF v_category_id IS NULL THEN
      RAISE WARNING 'Categoría no encontrada: % (slug: %)', 'Tradiciones', 'tradiciones';
    END IF;
    
    -- Generar imagen aleatoria para categoría 6 (Tradiciones)
    -- Rango de imágenes: 01.webp - 09.webp
    v_category_number := 6;
    v_max_images := 9;
    v_random_num := 1 + floor(random() * v_max_images)::INT;
    v_image_filename := LPAD(v_random_num::TEXT, 2, '0') || '.webp';
    v_image_url := v_supabase_url || '/sample-images/1/' || v_category_number::TEXT || '/' || v_image_filename;
    
    -- Insertar evento
    INSERT INTO public.events (
      id, title, place, maps_url, image_url, is_featured, is_free, 
      starts_at, city_id, category_id, status, description, image_alignment
    ) VALUES (
      'f0df3a4b-deca-48ab-adc6-7274110b5382',
      'Inicio Carnaval de Arcos 2026',
      'Teatro Olivares Veas',
      'https://www.google.com/maps/search/?api=1&query=Teatro+Olivares+Veas+Arcos',
      v_image_url,
      FALSE,
      TRUE,
      '2026-02-07T20:00:00Z'::timestamptz,
      v_city_id,
      v_category_id,
      'published',
      'Pregón a cargo de Raúl Lozano Soto.',
      'center'
    );
  EXCEPTION
    WHEN OTHERS THEN
      RAISE WARNING 'Error al insertar evento 40 (%): %', 'Inicio Carnaval de Arcos 2026...', SQLERRM;
  END;

  -- =========================================
  -- Evento 41: XII Víboras Trail...
  -- =========================================
  BEGIN
    -- Buscar ID de ciudad: Algodonales
    SELECT id INTO v_city_id FROM public.cities WHERE LOWER(name) = LOWER('Algodonales') LIMIT 1;
    IF v_city_id IS NULL THEN
      RAISE WARNING 'Ciudad no encontrada: %', 'Algodonales';
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
      'f9425949-012a-4ae1-bd8e-b7732db25c27',
      'XII Víboras Trail',
      NULL,
      'https://www.google.com/maps/search/?api=1&query=Algodonales',
      v_image_url,
      FALSE,
      FALSE,
      '2026-02-07T09:00:00Z'::timestamptz,
      v_city_id,
      v_category_id,
      'published',
      'Modalidad maratón (42km) por la Sierra de Líjar.',
      'center'
    );
  EXCEPTION
    WHEN OTHERS THEN
      RAISE WARNING 'Error al insertar evento 41 (%): %', 'XII Víboras Trail...', SQLERRM;
  END;

  -- =========================================
  -- Evento 42: XXV Gambada Popular...
  -- =========================================
  BEGIN
    -- Buscar ID de ciudad: Cádiz
    SELECT id INTO v_city_id FROM public.cities WHERE LOWER(name) = LOWER('Cádiz') LIMIT 1;
    IF v_city_id IS NULL THEN
      RAISE WARNING 'Ciudad no encontrada: %', 'Cádiz';
    END IF;
    
    -- Buscar ID de categoría: Gastronomía (slug: gastronomia)
    SELECT id INTO v_category_id FROM public.categories WHERE LOWER(slug) = LOWER('gastronomia') OR LOWER(name) = LOWER('Gastronomía') LIMIT 1;
    IF v_category_id IS NULL THEN
      RAISE WARNING 'Categoría no encontrada: % (slug: %)', 'Gastronomía', 'gastronomia';
    END IF;
    
    -- Generar imagen aleatoria para categoría 2 (Gastronomía)
    -- Rango de imágenes: 01.webp - 14.webp
    v_category_number := 2;
    v_max_images := 14;
    v_random_num := 1 + floor(random() * v_max_images)::INT;
    v_image_filename := LPAD(v_random_num::TEXT, 2, '0') || '.webp';
    v_image_url := v_supabase_url || '/sample-images/1/' || v_category_number::TEXT || '/' || v_image_filename;
    
    -- Insertar evento
    INSERT INTO public.events (
      id, title, place, maps_url, image_url, is_featured, is_free, 
      starts_at, city_id, category_id, status, description, image_alignment
    ) VALUES (
      '474e2127-2b0d-42af-8992-9ac91b4b4ee1',
      'XXV Gambada Popular',
      'Peña La Perla de',
      'https://www.google.com/maps/search/?api=1&query=Peña+La+Perla+de+Cadiz',
      v_image_url,
      FALSE,
      TRUE,
      '2026-02-08T13:30:00Z'::timestamptz,
      v_city_id,
      v_category_id,
      'published',
      'Degustación de gambas.',
      'center'
    );
  EXCEPTION
    WHEN OTHERS THEN
      RAISE WARNING 'Error al insertar evento 42 (%): %', 'XXV Gambada Popular...', SQLERRM;
  END;

  -- =========================================
  -- Evento 43: I Chicharronada Popular...
  -- =========================================
  BEGIN
    -- Buscar ID de ciudad: Cádiz
    SELECT id INTO v_city_id FROM public.cities WHERE LOWER(name) = LOWER('Cádiz') LIMIT 1;
    IF v_city_id IS NULL THEN
      RAISE WARNING 'Ciudad no encontrada: %', 'Cádiz';
    END IF;
    
    -- Buscar ID de categoría: Gastronomía (slug: gastronomia)
    SELECT id INTO v_category_id FROM public.categories WHERE LOWER(slug) = LOWER('gastronomia') OR LOWER(name) = LOWER('Gastronomía') LIMIT 1;
    IF v_category_id IS NULL THEN
      RAISE WARNING 'Categoría no encontrada: % (slug: %)', 'Gastronomía', 'gastronomia';
    END IF;
    
    -- Generar imagen aleatoria para categoría 2 (Gastronomía)
    -- Rango de imágenes: 01.webp - 14.webp
    v_category_number := 2;
    v_max_images := 14;
    v_random_num := 1 + floor(random() * v_max_images)::INT;
    v_image_filename := LPAD(v_random_num::TEXT, 2, '0') || '.webp';
    v_image_url := v_supabase_url || '/sample-images/1/' || v_category_number::TEXT || '/' || v_image_filename;
    
    -- Insertar evento
    INSERT INTO public.events (
      id, title, place, maps_url, image_url, is_featured, is_free, 
      starts_at, city_id, category_id, status, description, image_alignment
    ) VALUES (
      '9cc735f4-5d27-4899-86a5-e5f1ae756e1d',
      'I Chicharronada Popular',
      'Plaza de la Catedral',
      'https://www.google.com/maps/search/?api=1&query=Plaza+Catedral+Cadiz',
      v_image_url,
      FALSE,
      TRUE,
      '2026-02-08T13:30:00Z'::timestamptz,
      v_city_id,
      v_category_id,
      'published',
      'Nuevo evento gastronómico.',
      'center'
    );
  EXCEPTION
    WHEN OTHERS THEN
      RAISE WARNING 'Error al insertar evento 43 (%): %', 'I Chicharronada Popular...', SQLERRM;
  END;

  -- =========================================
  -- Evento 44: Cádiz Fight Night: Europa vs Tailandia...
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
      'fdf27175-2f77-4d95-91ec-d8566bd65434',
      'Cádiz Fight Night: Europa vs Tailandia',
      'Sala Momart Theatre',
      'https://www.google.com/maps/search/?api=1&query=Sala+Momart+Cadiz',
      v_image_url,
      FALSE,
      FALSE,
      '2026-02-08T18:00:00Z'::timestamptz,
      v_city_id,
      v_category_id,
      'published',
      'Evento internacional de Muay Thai. Despedida de Carlos Coello.',
      'center'
    );
  EXCEPTION
    WHEN OTHERS THEN
      RAISE WARNING 'Error al insertar evento 44 (%): %', 'Cádiz Fight Night: Europa vs T...', SQLERRM;
  END;

  -- =========================================
  -- Evento 45: Encendido Alumbrado de Carnaval...
  -- =========================================
  BEGIN
    -- Buscar ID de ciudad: Cádiz
    SELECT id INTO v_city_id FROM public.cities WHERE LOWER(name) = LOWER('Cádiz') LIMIT 1;
    IF v_city_id IS NULL THEN
      RAISE WARNING 'Ciudad no encontrada: %', 'Cádiz';
    END IF;
    
    -- Buscar ID de categoría: Tradiciones (slug: tradiciones)
    SELECT id INTO v_category_id FROM public.categories WHERE LOWER(slug) = LOWER('tradiciones') OR LOWER(name) = LOWER('Tradiciones') LIMIT 1;
    IF v_category_id IS NULL THEN
      RAISE WARNING 'Categoría no encontrada: % (slug: %)', 'Tradiciones', 'tradiciones';
    END IF;
    
    -- Generar imagen aleatoria para categoría 6 (Tradiciones)
    -- Rango de imágenes: 01.webp - 09.webp
    v_category_number := 6;
    v_max_images := 9;
    v_random_num := 1 + floor(random() * v_max_images)::INT;
    v_image_filename := LPAD(v_random_num::TEXT, 2, '0') || '.webp';
    v_image_url := v_supabase_url || '/sample-images/1/' || v_category_number::TEXT || '/' || v_image_filename;
    
    -- Insertar evento
    INSERT INTO public.events (
      id, title, place, maps_url, image_url, is_featured, is_free, 
      starts_at, city_id, category_id, status, description, image_alignment
    ) VALUES (
      '373da933-2f5e-4c19-b84e-8884b61a5a43',
      'Encendido Alumbrado de Carnaval',
      'Plaza de San Antonio',
      'https://www.google.com/maps/search/?api=1&query=Plaza+San+Antonio+Cadiz',
      v_image_url,
      FALSE,
      TRUE,
      '2026-02-12T20:00:00Z'::timestamptz,
      v_city_id,
      v_category_id,
      'published',
      'Inicio oficial de la fiesta en la calle.',
      'center'
    );
  EXCEPTION
    WHEN OTHERS THEN
      RAISE WARNING 'Error al insertar evento 45 (%): %', 'Encendido Alumbrado de Carnava...', SQLERRM;
  END;

  -- =========================================
  -- Evento 46: Gran Final del COAC 2026...
  -- =========================================
  BEGIN
    -- Buscar ID de ciudad: Cádiz
    SELECT id INTO v_city_id FROM public.cities WHERE LOWER(name) = LOWER('Cádiz') LIMIT 1;
    IF v_city_id IS NULL THEN
      RAISE WARNING 'Ciudad no encontrada: %', 'Cádiz';
    END IF;
    
    -- Buscar ID de categoría: Tradiciones (slug: tradiciones)
    SELECT id INTO v_category_id FROM public.categories WHERE LOWER(slug) = LOWER('tradiciones') OR LOWER(name) = LOWER('Tradiciones') LIMIT 1;
    IF v_category_id IS NULL THEN
      RAISE WARNING 'Categoría no encontrada: % (slug: %)', 'Tradiciones', 'tradiciones';
    END IF;
    
    -- Generar imagen aleatoria para categoría 6 (Tradiciones)
    -- Rango de imágenes: 01.webp - 09.webp
    v_category_number := 6;
    v_max_images := 9;
    v_random_num := 1 + floor(random() * v_max_images)::INT;
    v_image_filename := LPAD(v_random_num::TEXT, 2, '0') || '.webp';
    v_image_url := v_supabase_url || '/sample-images/1/' || v_category_number::TEXT || '/' || v_image_filename;
    
    -- Insertar evento
    INSERT INTO public.events (
      id, title, place, maps_url, image_url, is_featured, is_free, 
      starts_at, city_id, category_id, status, description, image_alignment
    ) VALUES (
      '3c970bd9-c2b4-4024-a188-6648e53ac5ff',
      'Gran Final del COAC 2026',
      'Gran Teatro Falla',
      'https://www.google.com/maps/search/?api=1&query=Gran+Teatro+Falla+Cadiz',
      v_image_url,
      FALSE,
      FALSE,
      '2026-02-13T20:00:00Z'::timestamptz,
      v_city_id,
      v_category_id,
      'published',
      'La noche más importante del año cultural gaditano.',
      'center'
    );
  EXCEPTION
    WHEN OTHERS THEN
      RAISE WARNING 'Error al insertar evento 46 (%): %', 'Gran Final del COAC 2026...', SQLERRM;
  END;

  -- =========================================
  -- Evento 47: Pregón del Carnaval (Manu Sánchez)...
  -- =========================================
  BEGIN
    -- Buscar ID de ciudad: Cádiz
    SELECT id INTO v_city_id FROM public.cities WHERE LOWER(name) = LOWER('Cádiz') LIMIT 1;
    IF v_city_id IS NULL THEN
      RAISE WARNING 'Ciudad no encontrada: %', 'Cádiz';
    END IF;
    
    -- Buscar ID de categoría: Tradiciones (slug: tradiciones)
    SELECT id INTO v_category_id FROM public.categories WHERE LOWER(slug) = LOWER('tradiciones') OR LOWER(name) = LOWER('Tradiciones') LIMIT 1;
    IF v_category_id IS NULL THEN
      RAISE WARNING 'Categoría no encontrada: % (slug: %)', 'Tradiciones', 'tradiciones';
    END IF;
    
    -- Generar imagen aleatoria para categoría 6 (Tradiciones)
    -- Rango de imágenes: 01.webp - 09.webp
    v_category_number := 6;
    v_max_images := 9;
    v_random_num := 1 + floor(random() * v_max_images)::INT;
    v_image_filename := LPAD(v_random_num::TEXT, 2, '0') || '.webp';
    v_image_url := v_supabase_url || '/sample-images/1/' || v_category_number::TEXT || '/' || v_image_filename;
    
    -- Insertar evento
    INSERT INTO public.events (
      id, title, place, maps_url, image_url, is_featured, is_free, 
      starts_at, city_id, category_id, status, description, image_alignment
    ) VALUES (
      '3ef9cf08-8874-419a-b201-9519f1b94f68',
      'Pregón del Carnaval (Manu Sánchez)',
      'Plaza de San Antonio',
      'https://www.google.com/maps/search/?api=1&query=Plaza+San+Antonio+Cadiz',
      v_image_url,
      FALSE,
      TRUE,
      '2026-02-14T22:00:00Z'::timestamptz,
      v_city_id,
      v_category_id,
      'published',
      'Acto oficial en la plaza principal.',
      'center'
    );
  EXCEPTION
    WHEN OTHERS THEN
      RAISE WARNING 'Error al insertar evento 47 (%): %', 'Pregón del Carnaval (Manu Sánc...', SQLERRM;
  END;

  -- =========================================
  -- Evento 48: Gran Cabalgata Magna...
  -- =========================================
  BEGIN
    -- Buscar ID de ciudad: Cádiz
    SELECT id INTO v_city_id FROM public.cities WHERE LOWER(name) = LOWER('Cádiz') LIMIT 1;
    IF v_city_id IS NULL THEN
      RAISE WARNING 'Ciudad no encontrada: %', 'Cádiz';
    END IF;
    
    -- Buscar ID de categoría: Tradiciones (slug: tradiciones)
    SELECT id INTO v_category_id FROM public.categories WHERE LOWER(slug) = LOWER('tradiciones') OR LOWER(name) = LOWER('Tradiciones') LIMIT 1;
    IF v_category_id IS NULL THEN
      RAISE WARNING 'Categoría no encontrada: % (slug: %)', 'Tradiciones', 'tradiciones';
    END IF;
    
    -- Generar imagen aleatoria para categoría 6 (Tradiciones)
    -- Rango de imágenes: 01.webp - 09.webp
    v_category_number := 6;
    v_max_images := 9;
    v_random_num := 1 + floor(random() * v_max_images)::INT;
    v_image_filename := LPAD(v_random_num::TEXT, 2, '0') || '.webp';
    v_image_url := v_supabase_url || '/sample-images/1/' || v_category_number::TEXT || '/' || v_image_filename;
    
    -- Insertar evento
    INSERT INTO public.events (
      id, title, place, maps_url, image_url, is_featured, is_free, 
      starts_at, city_id, category_id, status, description, image_alignment
    ) VALUES (
      'e483c8be-b7e1-46ce-9ab1-7491b8b8e979',
      'Gran Cabalgata Magna',
      'Avenida Andalucía',
      'https://www.google.com/maps/search/?api=1&query=Avenida+Andalucia+Cadiz',
      v_image_url,
      FALSE,
      TRUE,
      '2026-02-15T17:00:00Z'::timestamptz,
      v_city_id,
      v_category_id,
      'published',
      'Desfile dedicado al mar por la Avenida Principal.',
      'center'
    );
  EXCEPTION
    WHEN OTHERS THEN
      RAISE WARNING 'Error al insertar evento 48 (%): %', 'Gran Cabalgata Magna...', SQLERRM;
  END;

  -- =========================================
  -- Evento 49: Inauguración XXX Festival de Jerez...
  -- =========================================
  BEGIN
    -- Buscar ID de ciudad: Jerez de la Frontera
    SELECT id INTO v_city_id FROM public.cities WHERE LOWER(name) = LOWER('Jerez de la Frontera') LIMIT 1;
    IF v_city_id IS NULL THEN
      RAISE WARNING 'Ciudad no encontrada: %', 'Jerez de la Frontera';
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
      'fba60b3a-fd12-4775-8a7f-272870cad03c',
      'Inauguración XXX Festival de Jerez',
      'Teatro Villamarta',
      'https://www.google.com/maps/search/?api=1&query=Teatro+Villamarta+Jerez',
      v_image_url,
      FALSE,
      FALSE,
      '2026-02-20T20:30:00Z'::timestamptz,
      v_city_id,
      v_category_id,
      'published',
      'Espectáculo ''Raíces del Alma'' de Manuela Carpio.',
      'center'
    );
  EXCEPTION
    WHEN OTHERS THEN
      RAISE WARNING 'Error al insertar evento 49 (%): %', 'Inauguración XXX Festival de J...', SQLERRM;
  END;

  -- =========================================
  -- Evento 50: Quema de la Bruja Piti...
  -- =========================================
  BEGIN
    -- Buscar ID de ciudad: Cádiz
    SELECT id INTO v_city_id FROM public.cities WHERE LOWER(name) = LOWER('Cádiz') LIMIT 1;
    IF v_city_id IS NULL THEN
      RAISE WARNING 'Ciudad no encontrada: %', 'Cádiz';
    END IF;
    
    -- Buscar ID de categoría: Tradiciones (slug: tradiciones)
    SELECT id INTO v_category_id FROM public.categories WHERE LOWER(slug) = LOWER('tradiciones') OR LOWER(name) = LOWER('Tradiciones') LIMIT 1;
    IF v_category_id IS NULL THEN
      RAISE WARNING 'Categoría no encontrada: % (slug: %)', 'Tradiciones', 'tradiciones';
    END IF;
    
    -- Generar imagen aleatoria para categoría 6 (Tradiciones)
    -- Rango de imágenes: 01.webp - 09.webp
    v_category_number := 6;
    v_max_images := 9;
    v_random_num := 1 + floor(random() * v_max_images)::INT;
    v_image_filename := LPAD(v_random_num::TEXT, 2, '0') || '.webp';
    v_image_url := v_supabase_url || '/sample-images/1/' || v_category_number::TEXT || '/' || v_image_filename;
    
    -- Insertar evento
    INSERT INTO public.events (
      id, title, place, maps_url, image_url, is_featured, is_free, 
      starts_at, city_id, category_id, status, description, image_alignment
    ) VALUES (
      'e15c9380-55fe-40a2-be2c-cd9b79dea710',
      'Quema de la Bruja Piti',
      'Castillo de San Sebastián / La Caleta',
      'https://www.google.com/maps/search/?api=1&query=Playa+La+Caleta+Cadiz',
      v_image_url,
      FALSE,
      TRUE,
      '2026-02-22T22:00:00Z'::timestamptz,
      v_city_id,
      v_category_id,
      'published',
      'Fuegos artificiales y fin del Carnaval.',
      'center'
    );
  EXCEPTION
    WHEN OTHERS THEN
      RAISE WARNING 'Error al insertar evento 50 (%): %', 'Quema de la Bruja Piti...', SQLERRM;
  END;

  -- =========================================
  -- Evento 51: Día de Andalucía...
  -- =========================================
  BEGIN
    -- Buscar ID de ciudad: Cádiz
    SELECT id INTO v_city_id FROM public.cities WHERE LOWER(name) = LOWER('Cádiz') LIMIT 1;
    IF v_city_id IS NULL THEN
      RAISE WARNING 'Ciudad no encontrada: %', 'Cádiz';
    END IF;
    
    -- Buscar ID de categoría: Tradiciones (slug: tradiciones)
    SELECT id INTO v_category_id FROM public.categories WHERE LOWER(slug) = LOWER('tradiciones') OR LOWER(name) = LOWER('Tradiciones') LIMIT 1;
    IF v_category_id IS NULL THEN
      RAISE WARNING 'Categoría no encontrada: % (slug: %)', 'Tradiciones', 'tradiciones';
    END IF;
    
    -- Generar imagen aleatoria para categoría 6 (Tradiciones)
    -- Rango de imágenes: 01.webp - 09.webp
    v_category_number := 6;
    v_max_images := 9;
    v_random_num := 1 + floor(random() * v_max_images)::INT;
    v_image_filename := LPAD(v_random_num::TEXT, 2, '0') || '.webp';
    v_image_url := v_supabase_url || '/sample-images/1/' || v_category_number::TEXT || '/' || v_image_filename;
    
    -- Insertar evento
    INSERT INTO public.events (
      id, title, place, maps_url, image_url, is_featured, is_free, 
      starts_at, city_id, category_id, status, description, image_alignment
    ) VALUES (
      '273cd907-f39e-4335-b20c-9b842dc7f1cb',
      'Día de Andalucía',
      'Provincia de Cádiz',
      'https://www.google.com/maps/search/?api=1&query=Cadiz',
      v_image_url,
      FALSE,
      TRUE,
      '2026-02-28T12:00:00Z'::timestamptz,
      v_city_id,
      v_category_id,
      'published',
      'Actos institucionales en todos los municipios.',
      'center'
    );
  EXCEPTION
    WHEN OTHERS THEN
      RAISE WARNING 'Error al insertar evento 51 (%): %', 'Día de Andalucía...', SQLERRM;
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
