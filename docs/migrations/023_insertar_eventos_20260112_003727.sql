-- ============================================
-- SQL generado automáticamente para insertar eventos desde JSON
-- Fecha de generación: 2026-01-12T00:37:27.960779
-- Total de eventos: 170
-- Formato: INSERTs directos con imágenes secuenciales por categoría
-- ============================================

INSERT INTO public.events (id, title, place, maps_url, image_url, is_featured, is_free, starts_at, city_id, category_id, status, description, image_alignment) VALUES (
      'dbf5a752-7cc6-48b1-81e6-4c20b83456da',
      'XIV Trail Urbano Villaluenga',
      'Piscina Municipal, Villaluenga del Rosario',
      'https://www.google.com/maps/search/?api=1&query=Piscina+Municipal+Villaluenga+del+Rosario',
      'https://oudofaiekedtaovrdqeo.supabase.co/storage/v1/object/public/sample-images/1/3/01.webp',
      FALSE,
      FALSE,
      '2026-01-11T10:00:00Z'::timestamptz,
      (SELECT id FROM public.cities WHERE LOWER(name) = LOWER('Villaluenga del Rosario') LIMIT 1),
      (SELECT id FROM public.categories WHERE LOWER(slug) = 'deportes' LIMIT 1),
      'published',
      'Prueba que combina el casco antiguo de Villaluenga con senderos técnicos de la Sierra de Grazalema.',
      'center');

INSERT INTO public.events (id, title, place, maps_url, image_url, is_featured, is_free, starts_at, city_id, category_id, status, description, image_alignment) VALUES (
      'ea958fe4-b82e-4d5c-a844-3c4b13a6bdf9',
      'Fútbol: Xerez DFC vs La Unión Atlético',
      'Estadio Chapín, Jerez de la Frontera',
      'https://www.google.com/maps/search/?api=1&query=Estadio+Chapin+Jerez',
      'https://oudofaiekedtaovrdqeo.supabase.co/storage/v1/object/public/sample-images/1/3/02.webp',
      FALSE,
      FALSE,
      '2026-01-11T17:00:00Z'::timestamptz,
      (SELECT id FROM public.cities WHERE LOWER(name) = LOWER('Jerez de la Frontera') LIMIT 1),
      (SELECT id FROM public.categories WHERE LOWER(slug) = 'deportes' LIMIT 1),
      'published',
      'Segunda Federación (Grupo 4). Partido en el Estadio Chapín.',
      'center');

INSERT INTO public.events (id, title, place, maps_url, image_url, is_featured, is_free, starts_at, city_id, category_id, status, description, image_alignment) VALUES (
      'ee571ea8-aa33-40fe-b236-7f9bc0e7696b',
      'Juan Dávila: La Capital del Pecado 2.0',
      'Teatro Villamarta, Jerez',
      'https://www.google.com/maps/search/?api=1&query=Teatro+Villamarta+Jerez',
      'https://oudofaiekedtaovrdqeo.supabase.co/storage/v1/object/public/sample-images/1/4/01.webp',
      FALSE,
      FALSE,
      '2026-01-11T18:00:00Z'::timestamptz,
      (SELECT id FROM public.cities WHERE LOWER(name) = LOWER('Jerez de la Frontera') LIMIT 1),
      (SELECT id FROM public.categories WHERE LOWER(slug) = 'arte-y-cultura' LIMIT 1),
      'published',
      'Show de humor improvisado en el Teatro Villamarta.',
      'center');

INSERT INTO public.events (id, title, place, maps_url, image_url, is_featured, is_free, starts_at, city_id, category_id, status, description, image_alignment) VALUES (
      'f41bf6d5-2679-4e1d-86b6-098b0b1d1768',
      'COAC 2026: Preliminares (Sesión 1)',
      'Gran Teatro Falla, Cádiz',
      'https://www.google.com/maps/search/?api=1&query=Gran+Teatro+Falla+Cadiz',
      'https://oudofaiekedtaovrdqeo.supabase.co/storage/v1/object/public/sample-images/1/6/01.webp',
      FALSE,
      FALSE,
      '2026-01-11T20:00:00Z'::timestamptz,
      (SELECT id FROM public.cities WHERE LOWER(name) = LOWER('Cádiz') LIMIT 1),
      (SELECT id FROM public.categories WHERE LOWER(slug) = 'tradiciones' LIMIT 1),
      'published',
      'Inauguración del concurso. Actúan: Coro ''Al lío'', Comparsa ''La palabra de Cádiz'', Chirigota ''Los hombres de Paco''.',
      'center');

INSERT INTO public.events (id, title, place, maps_url, image_url, is_featured, is_free, starts_at, city_id, category_id, status, description, image_alignment) VALUES (
      'c69b0fcc-2e86-4a8e-b89c-8ade66fd8811',
      'COAC 2026: Preliminares (Sesión 2)',
      'Gran Teatro Falla, Cádiz',
      'https://www.google.com/maps/search/?api=1&query=Gran+Teatro+Falla+Cadiz',
      'https://oudofaiekedtaovrdqeo.supabase.co/storage/v1/object/public/sample-images/1/6/02.webp',
      FALSE,
      FALSE,
      '2026-01-12T20:00:00Z'::timestamptz,
      (SELECT id FROM public.cities WHERE LOWER(name) = LOWER('Cádiz') LIMIT 1),
      (SELECT id FROM public.categories WHERE LOWER(slug) = 'tradiciones' LIMIT 1),
      'published',
      'Preliminares Falla. Actúan: Coro ''El sindicato'', Chirigota ''Los ahumaos'', Comparsa ''Las lobas''.',
      'center');

INSERT INTO public.events (id, title, place, maps_url, image_url, is_featured, is_free, starts_at, city_id, category_id, status, description, image_alignment) VALUES (
      '3d2e89d3-fdc0-4882-a0be-b7bf7a98e4d2',
      'COAC 2026: Preliminares (Sesión 3)',
      'Gran Teatro Falla, Cádiz',
      'https://www.google.com/maps/search/?api=1&query=Gran+Teatro+Falla+Cadiz',
      'https://oudofaiekedtaovrdqeo.supabase.co/storage/v1/object/public/sample-images/1/6/03.webp',
      FALSE,
      FALSE,
      '2026-01-13T20:00:00Z'::timestamptz,
      (SELECT id FROM public.cities WHERE LOWER(name) = LOWER('Cádiz') LIMIT 1),
      (SELECT id FROM public.categories WHERE LOWER(slug) = 'tradiciones' LIMIT 1),
      'published',
      'Preliminares Falla. Actúan: Coro ''Dame veneno'', Comparsa ''Los del escondite'', Chirigota ''Nos hemos venío arriba''.',
      'center');

INSERT INTO public.events (id, title, place, maps_url, image_url, is_featured, is_free, starts_at, city_id, category_id, status, description, image_alignment) VALUES (
      'c8798209-5d29-4b11-845d-accbc3df1e31',
      'COAC 2026: Preliminares (Sesión 4)',
      'Gran Teatro Falla, Cádiz',
      'https://www.google.com/maps/search/?api=1&query=Gran+Teatro+Falla+Cadiz',
      'https://oudofaiekedtaovrdqeo.supabase.co/storage/v1/object/public/sample-images/1/6/04.webp',
      FALSE,
      FALSE,
      '2026-01-14T20:00:00Z'::timestamptz,
      (SELECT id FROM public.cities WHERE LOWER(name) = LOWER('Cádiz') LIMIT 1),
      (SELECT id FROM public.categories WHERE LOWER(slug) = 'tradiciones' LIMIT 1),
      'published',
      'Preliminares Falla. Actúan: Comparsa ''La ciudad perfecta'', Chirigota ''Cariño... vaya ambientazo''.',
      'center');

INSERT INTO public.events (id, title, place, maps_url, image_url, is_featured, is_free, starts_at, city_id, category_id, status, description, image_alignment) VALUES (
      '9d93cb09-3260-44f5-b7f7-afca1bd189b9',
      'Andalucía Pre-Sunshine Tour (Día 1)',
      'Montenmedio, Vejer',
      'https://www.google.com/maps/search/?api=1&query=Dehesa+Montenmedio+Vejer',
      'https://oudofaiekedtaovrdqeo.supabase.co/storage/v1/object/public/sample-images/1/3/03.webp',
      FALSE,
      TRUE,
      '2026-01-15T09:00:00Z'::timestamptz,
      (SELECT id FROM public.cities WHERE LOWER(name) = LOWER('Vejer de la Frontera') LIMIT 1),
      (SELECT id FROM public.categories WHERE LOWER(slug) = 'deportes' LIMIT 1),
      'published',
      'Semana de apertura. Pruebas de caballos jóvenes (5, 6 y 7 años).',
      'center');

INSERT INTO public.events (id, title, place, maps_url, image_url, is_featured, is_free, starts_at, city_id, category_id, status, description, image_alignment) VALUES (
      '16f54ca0-3738-4f86-b0f1-f128b1553bd7',
      'COAC 2026: Preliminares (Sesión 5)',
      'Gran Teatro Falla, Cádiz',
      'https://www.google.com/maps/search/?api=1&query=Gran+Teatro+Falla+Cadiz',
      'https://oudofaiekedtaovrdqeo.supabase.co/storage/v1/object/public/sample-images/1/6/05.webp',
      FALSE,
      FALSE,
      '2026-01-15T20:00:00Z'::timestamptz,
      (SELECT id FROM public.cities WHERE LOWER(name) = LOWER('Cádiz') LIMIT 1),
      (SELECT id FROM public.categories WHERE LOWER(slug) = 'tradiciones' LIMIT 1),
      'published',
      'Preliminares Falla. Actúan: Coro ''ADN'', Chirigota ''Los Cadisapiens'', Comparsa ''La hipócrita''.',
      'center');

INSERT INTO public.events (id, title, place, maps_url, image_url, is_featured, is_free, starts_at, city_id, category_id, status, description, image_alignment) VALUES (
      '62bda5b9-10e0-477d-9f51-520a45b804bb',
      'Andalucía Pre-Sunshine Tour (Día 2)',
      'Montenmedio, Vejer',
      'https://www.google.com/maps/search/?api=1&query=Dehesa+Montenmedio+Vejer',
      'https://oudofaiekedtaovrdqeo.supabase.co/storage/v1/object/public/sample-images/1/3/04.webp',
      FALSE,
      TRUE,
      '2026-01-16T09:00:00Z'::timestamptz,
      (SELECT id FROM public.cities WHERE LOWER(name) = LOWER('Vejer de la Frontera') LIMIT 1),
      (SELECT id FROM public.categories WHERE LOWER(slug) = 'deportes' LIMIT 1),
      'published',
      'Competición CSI2* de saltos de obstáculos.',
      'center');

INSERT INTO public.events (id, title, place, maps_url, image_url, is_featured, is_free, starts_at, city_id, category_id, status, description, image_alignment) VALUES (
      '16759e78-f8c9-4eda-abc6-d94adcbabf7a',
      'COAC 2026: Preliminares (Sesión 6)',
      'Gran Teatro Falla, Cádiz',
      'https://www.google.com/maps/search/?api=1&query=Gran+Teatro+Falla+Cadiz',
      'https://oudofaiekedtaovrdqeo.supabase.co/storage/v1/object/public/sample-images/1/6/06.webp',
      FALSE,
      FALSE,
      '2026-01-16T20:00:00Z'::timestamptz,
      (SELECT id FROM public.cities WHERE LOWER(name) = LOWER('Cádiz') LIMIT 1),
      (SELECT id FROM public.categories WHERE LOWER(slug) = 'tradiciones' LIMIT 1),
      'published',
      'Preliminares Falla. Actúan: Coro ''La Viña del mar'', Comparsa ''El verdugo''.',
      'center');

INSERT INTO public.events (id, title, place, maps_url, image_url, is_featured, is_free, starts_at, city_id, category_id, status, description, image_alignment) VALUES (
      '60793e75-c792-453d-bfe5-9066ff3c63f7',
      'Concierto: Syrah Morrison',
      'La Guarida del Ángel, Jerez',
      'https://www.google.com/maps/search/?api=1&query=La+Guarida+del+Angel+Jerez',
      'https://oudofaiekedtaovrdqeo.supabase.co/storage/v1/object/public/sample-images/1/1/01.webp',
      FALSE,
      FALSE,
      '2026-01-16T22:30:00Z'::timestamptz,
      (SELECT id FROM public.cities WHERE LOWER(name) = LOWER('Jerez de la Frontera') LIMIT 1),
      (SELECT id FROM public.categories WHERE LOWER(slug) = 'musica' LIMIT 1),
      'published',
      'Folk y Rock en directo en sala local.',
      'center');

INSERT INTO public.events (id, title, place, maps_url, image_url, is_featured, is_free, starts_at, city_id, category_id, status, description, image_alignment) VALUES (
      'df364f1d-49d9-43fb-9cde-e86b8dba151f',
      'Fiesta Universitaria Welcome 2026',
      'Sala Momart, Cádiz',
      'https://www.google.com/maps/search/?api=1&query=Sala+Momart+Cadiz',
      'https://oudofaiekedtaovrdqeo.supabase.co/storage/v1/object/public/sample-images/1/1/02.webp',
      FALSE,
      FALSE,
      '2026-01-16T23:59:00Z'::timestamptz,
      (SELECT id FROM public.cities WHERE LOWER(name) = LOWER('Cádiz') LIMIT 1),
      (SELECT id FROM public.categories WHERE LOWER(slug) = 'musica' LIMIT 1),
      'published',
      'Sesión DJ Hits y Reggaeton.',
      'center');

INSERT INTO public.events (id, title, place, maps_url, image_url, is_featured, is_free, starts_at, city_id, category_id, status, description, image_alignment) VALUES (
      '90a64e41-57cf-4b49-b5fe-64f0434e0c2a',
      'Andalucía Pre-Sunshine Tour (Día 3)',
      'Montenmedio, Vejer',
      'https://www.google.com/maps/search/?api=1&query=Dehesa+Montenmedio+Vejer',
      'https://oudofaiekedtaovrdqeo.supabase.co/storage/v1/object/public/sample-images/1/3/05.webp',
      FALSE,
      TRUE,
      '2026-01-17T09:00:00Z'::timestamptz,
      (SELECT id FROM public.cities WHERE LOWER(name) = LOWER('Vejer de la Frontera') LIMIT 1),
      (SELECT id FROM public.categories WHERE LOWER(slug) = 'deportes' LIMIT 1),
      'published',
      'Pruebas medianas de competición internacional.',
      'center');

INSERT INTO public.events (id, title, place, maps_url, image_url, is_featured, is_free, starts_at, city_id, category_id, status, description, image_alignment) VALUES (
      '55598a1a-9495-4f52-b6a7-07333df67ad8',
      'Sábados de Cuento',
      'Biblioteca Cádiz, Plaza de Mina',
      'https://www.google.com/maps/search/?api=1&query=Biblioteca+Provincial+Cadiz',
      'https://oudofaiekedtaovrdqeo.supabase.co/storage/v1/object/public/sample-images/1/4/02.webp',
      FALSE,
      TRUE,
      '2026-01-17T12:00:00Z'::timestamptz,
      (SELECT id FROM public.cities WHERE LOWER(name) = LOWER('Cádiz') LIMIT 1),
      (SELECT id FROM public.categories WHERE LOWER(slug) = 'arte-y-cultura' LIMIT 1),
      'published',
      'Sesión infantil de cuentacuentos en la biblioteca provincial.',
      'center');

INSERT INTO public.events (id, title, place, maps_url, image_url, is_featured, is_free, starts_at, city_id, category_id, status, description, image_alignment) VALUES (
      '7e8406e9-b452-463d-a443-6ea422486b45',
      'Futsal: CD Virgili Cádiz vs CD Alcalá',
      'Pabellón Ciudad de Cádiz',
      'https://www.google.com/maps/search/?api=1&query=Complejo+Deportivo+Ciudad+de+Cadiz',
      'https://oudofaiekedtaovrdqeo.supabase.co/storage/v1/object/public/sample-images/1/3/06.webp',
      FALSE,
      FALSE,
      '2026-01-17T18:00:00Z'::timestamptz,
      (SELECT id FROM public.cities WHERE LOWER(name) = LOWER('Cádiz') LIMIT 1),
      (SELECT id FROM public.categories WHERE LOWER(slug) = 'deportes' LIMIT 1),
      'published',
      'Segunda B de Fútbol Sala en el Ciudad de Cádiz.',
      'center');

INSERT INTO public.events (id, title, place, maps_url, image_url, is_featured, is_free, starts_at, city_id, category_id, status, description, image_alignment) VALUES (
      'b29eea37-e0ef-4823-9d4d-86af3bb13a7d',
      'COAC 2026: Preliminares (Sesión 7)',
      'Gran Teatro Falla, Cádiz',
      'https://www.google.com/maps/search/?api=1&query=Gran+Teatro+Falla+Cadiz',
      'https://oudofaiekedtaovrdqeo.supabase.co/storage/v1/object/public/sample-images/1/6/07.webp',
      FALSE,
      FALSE,
      '2026-01-17T20:00:00Z'::timestamptz,
      (SELECT id FROM public.cities WHERE LOWER(name) = LOWER('Cádiz') LIMIT 1),
      (SELECT id FROM public.categories WHERE LOWER(slug) = 'tradiciones' LIMIT 1),
      'published',
      'Preliminares Falla. Actúan: Coro ''El reino de los cielos'', Chirigota ''Los mohigangas''.',
      'center');

INSERT INTO public.events (id, title, place, maps_url, image_url, is_featured, is_free, starts_at, city_id, category_id, status, description, image_alignment) VALUES (
      'de7cf30f-e0db-4753-b197-d91b78ba60a0',
      'Andalucía Pre-Sunshine Tour (Día 4 - GP)',
      'Montenmedio, Vejer',
      'https://www.google.com/maps/search/?api=1&query=Dehesa+Montenmedio+Vejer',
      'https://oudofaiekedtaovrdqeo.supabase.co/storage/v1/object/public/sample-images/1/3/07.webp',
      FALSE,
      TRUE,
      '2026-01-18T09:00:00Z'::timestamptz,
      (SELECT id FROM public.cities WHERE LOWER(name) = LOWER('Vejer de la Frontera') LIMIT 1),
      (SELECT id FROM public.categories WHERE LOWER(slug) = 'deportes' LIMIT 1),
      'published',
      'Gran Premio de la primera semana de saltos.',
      'center');

INSERT INTO public.events (id, title, place, maps_url, image_url, is_featured, is_free, starts_at, city_id, category_id, status, description, image_alignment) VALUES (
      '0cb604e4-edba-4390-bd40-d8c1297f35e2',
      'Mercadillo de Sotogrande',
      'Ribera del Marlín, Sotogrande',
      'https://www.google.com/maps/search/?api=1&query=Mercadillo+Sotogrande',
      'https://oudofaiekedtaovrdqeo.supabase.co/storage/v1/object/public/sample-images/1/7/01.webp',
      FALSE,
      TRUE,
      '2026-01-18T10:00:00Z'::timestamptz,
      (SELECT id FROM public.cities WHERE LOWER(name) = LOWER('Sotogrande') LIMIT 1),
      (SELECT id FROM public.categories WHERE LOWER(slug) = 'mercadillos' LIMIT 1),
      'published',
      'Mercado dominical con artesanía, ropa y complementos en la marina.',
      'center');

INSERT INTO public.events (id, title, place, maps_url, image_url, is_featured, is_free, starts_at, city_id, category_id, status, description, image_alignment) VALUES (
      'f1a36e38-8d01-49be-9b61-d77bc1f4cab9',
      'COAC 2026: Preliminares (Sesión 8)',
      'Gran Teatro Falla, Cádiz',
      'https://www.google.com/maps/search/?api=1&query=Gran+Teatro+Falla+Cadiz',
      'https://oudofaiekedtaovrdqeo.supabase.co/storage/v1/object/public/sample-images/1/6/08.webp',
      FALSE,
      FALSE,
      '2026-01-18T20:00:00Z'::timestamptz,
      (SELECT id FROM public.cities WHERE LOWER(name) = LOWER('Cádiz') LIMIT 1),
      (SELECT id FROM public.categories WHERE LOWER(slug) = 'tradiciones' LIMIT 1),
      'published',
      'Preliminares Falla. Actúan: Coro ''La carnicería'', Comparsa ''Las muñecas''.',
      'center');

INSERT INTO public.events (id, title, place, maps_url, image_url, is_featured, is_free, starts_at, city_id, category_id, status, description, image_alignment) VALUES (
      '51c268f1-5c63-43a4-bbe0-31276d6ae77f',
      'COAC 2026: Preliminares (Sesión 9)',
      'Gran Teatro Falla, Cádiz',
      'https://www.google.com/maps/search/?api=1&query=Gran+Teatro+Falla+Cadiz',
      'https://oudofaiekedtaovrdqeo.supabase.co/storage/v1/object/public/sample-images/1/6/09.webp',
      FALSE,
      FALSE,
      '2026-01-19T20:00:00Z'::timestamptz,
      (SELECT id FROM public.cities WHERE LOWER(name) = LOWER('Cádiz') LIMIT 1),
      (SELECT id FROM public.categories WHERE LOWER(slug) = 'tradiciones' LIMIT 1),
      'published',
      'Agrupaciones: Comparsa ''La marinera'', Chirigota ''Los que se lo llevan calentito''.',
      'center');

INSERT INTO public.events (id, title, place, maps_url, image_url, is_featured, is_free, starts_at, city_id, category_id, status, description, image_alignment) VALUES (
      '05c757c1-a874-489a-b92b-6e110ce3f1c7',
      'COAC 2026: Preliminares (Sesión 10)',
      'Gran Teatro Falla, Cádiz',
      'https://www.google.com/maps/search/?api=1&query=Gran+Teatro+Falla+Cadiz',
      'https://oudofaiekedtaovrdqeo.supabase.co/storage/v1/object/public/sample-images/1/6/01.webp',
      FALSE,
      FALSE,
      '2026-01-20T20:00:00Z'::timestamptz,
      (SELECT id FROM public.cities WHERE LOWER(name) = LOWER('Cádiz') LIMIT 1),
      (SELECT id FROM public.categories WHERE LOWER(slug) = 'tradiciones' LIMIT 1),
      'published',
      'Agrupaciones: Coro ''Café Puerto América'', Chirigota ''Tu cara me suena''.',
      'center');

INSERT INTO public.events (id, title, place, maps_url, image_url, is_featured, is_free, starts_at, city_id, category_id, status, description, image_alignment) VALUES (
      '28964dd5-35b0-4bcb-ba65-f9779c3e0ed0',
      'COAC 2026: Preliminares (Sesión 11)',
      'Gran Teatro Falla, Cádiz',
      'https://www.google.com/maps/search/?api=1&query=Gran+Teatro+Falla+Cadiz',
      'https://oudofaiekedtaovrdqeo.supabase.co/storage/v1/object/public/sample-images/1/6/02.webp',
      FALSE,
      FALSE,
      '2026-01-21T20:00:00Z'::timestamptz,
      (SELECT id FROM public.cities WHERE LOWER(name) = LOWER('Cádiz') LIMIT 1),
      (SELECT id FROM public.categories WHERE LOWER(slug) = 'tradiciones' LIMIT 1),
      'published',
      'Preliminares Falla. Día 11 de concurso.',
      'center');

INSERT INTO public.events (id, title, place, maps_url, image_url, is_featured, is_free, starts_at, city_id, category_id, status, description, image_alignment) VALUES (
      'd58b55fa-0941-4477-b3a0-e5a8725dda31',
      'Andalucía Pre-Sunshine Tour (Día 5)',
      'Montenmedio, Vejer',
      'https://www.google.com/maps/search/?api=1&query=Dehesa+Montenmedio+Vejer',
      'https://oudofaiekedtaovrdqeo.supabase.co/storage/v1/object/public/sample-images/1/3/08.webp',
      FALSE,
      TRUE,
      '2026-01-22T09:00:00Z'::timestamptz,
      (SELECT id FROM public.cities WHERE LOWER(name) = LOWER('Vejer de la Frontera') LIMIT 1),
      (SELECT id FROM public.categories WHERE LOWER(slug) = 'deportes' LIMIT 1),
      'published',
      'Competición CSI3*. Mayor nivel técnico y altura de obstáculos.',
      'center');

INSERT INTO public.events (id, title, place, maps_url, image_url, is_featured, is_free, starts_at, city_id, category_id, status, description, image_alignment) VALUES (
      '249277c1-4ecb-4054-9921-4528c12860a5',
      'COAC 2026: Preliminares (Sesión 12)',
      'Gran Teatro Falla, Cádiz',
      'https://www.google.com/maps/search/?api=1&query=Gran+Teatro+Falla+Cadiz',
      'https://oudofaiekedtaovrdqeo.supabase.co/storage/v1/object/public/sample-images/1/6/03.webp',
      FALSE,
      FALSE,
      '2026-01-22T20:00:00Z'::timestamptz,
      (SELECT id FROM public.cities WHERE LOWER(name) = LOWER('Cádiz') LIMIT 1),
      (SELECT id FROM public.categories WHERE LOWER(slug) = 'tradiciones' LIMIT 1),
      'published',
      'Agrupaciones: Coro ''Las gladitanas'', Cuarteto ''¡Que vengan!''.',
      'center');

INSERT INTO public.events (id, title, place, maps_url, image_url, is_featured, is_free, starts_at, city_id, category_id, status, description, image_alignment) VALUES (
      'f60d3b9b-2e8d-4d32-aba9-1c4ce5216ffc',
      'Andalucía Pre-Sunshine Tour (Día 6)',
      'Montenmedio, Vejer',
      'https://www.google.com/maps/search/?api=1&query=Dehesa+Montenmedio+Vejer',
      'https://oudofaiekedtaovrdqeo.supabase.co/storage/v1/object/public/sample-images/1/3/09.webp',
      FALSE,
      TRUE,
      '2026-01-23T09:00:00Z'::timestamptz,
      (SELECT id FROM public.cities WHERE LOWER(name) = LOWER('Vejer de la Frontera') LIMIT 1),
      (SELECT id FROM public.categories WHERE LOWER(slug) = 'deportes' LIMIT 1),
      'published',
      'Pruebas clasificatorias para el Gran Premio de la semana 2.',
      'center');

INSERT INTO public.events (id, title, place, maps_url, image_url, is_featured, is_free, starts_at, city_id, category_id, status, description, image_alignment) VALUES (
      'c6140d97-17a0-411a-be46-74c1170cebce',
      'COAC 2026: Preliminares (Sesión 13)',
      'Gran Teatro Falla, Cádiz',
      'https://www.google.com/maps/search/?api=1&query=Gran+Teatro+Falla+Cadiz',
      'https://oudofaiekedtaovrdqeo.supabase.co/storage/v1/object/public/sample-images/1/6/04.webp',
      FALSE,
      FALSE,
      '2026-01-23T20:00:00Z'::timestamptz,
      (SELECT id FROM public.cities WHERE LOWER(name) = LOWER('Cádiz') LIMIT 1),
      (SELECT id FROM public.categories WHERE LOWER(slug) = 'tradiciones' LIMIT 1),
      'published',
      'Noche destacada: Comparsa ''El joyero'' y Chirigota ''Los del verdadero cambio''.',
      'center');

INSERT INTO public.events (id, title, place, maps_url, image_url, is_featured, is_free, starts_at, city_id, category_id, status, description, image_alignment) VALUES (
      '2b5ec9c0-1c4b-4847-b0d8-ac6b22051510',
      'GT Winter Series (Sábado)',
      'Circuito de Jerez',
      'https://www.google.com/maps/search/?api=1&query=Circuito+de+Jerez',
      'https://oudofaiekedtaovrdqeo.supabase.co/storage/v1/object/public/sample-images/1/3/10.webp',
      FALSE,
      TRUE,
      '2026-01-24T09:00:00Z'::timestamptz,
      (SELECT id FROM public.cities WHERE LOWER(name) = LOWER('Jerez de la Frontera') LIMIT 1),
      (SELECT id FROM public.categories WHERE LOWER(slug) = 'deportes' LIMIT 1),
      'published',
      'Automovilismo. Entrenamientos y sesiones de clasificación.',
      'center');

INSERT INTO public.events (id, title, place, maps_url, image_url, is_featured, is_free, starts_at, city_id, category_id, status, description, image_alignment) VALUES (
      '40e6444b-b9d4-49e6-80f1-1181cf2dd0ba',
      'Andalucía Pre-Sunshine Tour (Día 7)',
      'Montenmedio, Vejer',
      'https://www.google.com/maps/search/?api=1&query=Dehesa+Montenmedio+Vejer',
      'https://oudofaiekedtaovrdqeo.supabase.co/storage/v1/object/public/sample-images/1/3/11.webp',
      FALSE,
      TRUE,
      '2026-01-24T09:00:00Z'::timestamptz,
      (SELECT id FROM public.cities WHERE LOWER(name) = LOWER('Vejer de la Frontera') LIMIT 1),
      (SELECT id FROM public.categories WHERE LOWER(slug) = 'deportes' LIMIT 1),
      'published',
      'Penúltima jornada de la fase de enero.',
      'center');

INSERT INTO public.events (id, title, place, maps_url, image_url, is_featured, is_free, starts_at, city_id, category_id, status, description, image_alignment) VALUES (
      '50b2e5b4-9ce2-43d0-ba18-0f74e98cd23c',
      'COAC 2026: Preliminares (Sesión 14)',
      'Gran Teatro Falla, Cádiz',
      'https://www.google.com/maps/search/?api=1&query=Gran+Teatro+Falla+Cadiz',
      'https://oudofaiekedtaovrdqeo.supabase.co/storage/v1/object/public/sample-images/1/6/05.webp',
      FALSE,
      FALSE,
      '2026-01-24T20:00:00Z'::timestamptz,
      (SELECT id FROM public.cities WHERE LOWER(name) = LOWER('Cádiz') LIMIT 1),
      (SELECT id FROM public.categories WHERE LOWER(slug) = 'tradiciones' LIMIT 1),
      'published',
      'Sábado de Falla. Agrupaciones de gran tirón mediático.',
      'center');

INSERT INTO public.events (id, title, place, maps_url, image_url, is_featured, is_free, starts_at, city_id, category_id, status, description, image_alignment) VALUES (
      'c462aec6-af54-4a55-8163-8b354aa56bde',
      'Fútbol: Cádiz CF vs Granada CF',
      'Nuevo Mirandilla, Cádiz',
      'https://www.google.com/maps/search/?api=1&query=Estadio+Nuevo+Mirandilla+Cadiz',
      'https://oudofaiekedtaovrdqeo.supabase.co/storage/v1/object/public/sample-images/1/3/12.webp',
      FALSE,
      FALSE,
      '2026-01-24T21:00:00Z'::timestamptz,
      (SELECT id FROM public.cities WHERE LOWER(name) = LOWER('Cádiz') LIMIT 1),
      (SELECT id FROM public.categories WHERE LOWER(slug) = 'deportes' LIMIT 1),
      'published',
      'LaLiga Hypermotion. Derbi andaluz de máxima rivalidad.',
      'center');

INSERT INTO public.events (id, title, place, maps_url, image_url, is_featured, is_free, starts_at, city_id, category_id, status, description, image_alignment) VALUES (
      'b2cc375e-75f0-48d1-b408-b0e647e64296',
      'GT Winter Series (Carreras)',
      'Circuito de Jerez',
      'https://www.google.com/maps/search/?api=1&query=Circuito+de+Jerez',
      'https://oudofaiekedtaovrdqeo.supabase.co/storage/v1/object/public/sample-images/1/3/13.webp',
      FALSE,
      TRUE,
      '2026-01-25T09:00:00Z'::timestamptz,
      (SELECT id FROM public.cities WHERE LOWER(name) = LOWER('Jerez de la Frontera') LIMIT 1),
      (SELECT id FROM public.categories WHERE LOWER(slug) = 'deportes' LIMIT 1),
      'published',
      'Final de las series de invierno. Carreras de GTs y Prototipos.',
      'center');

INSERT INTO public.events (id, title, place, maps_url, image_url, is_featured, is_free, starts_at, city_id, category_id, status, description, image_alignment) VALUES (
      '82fe3a25-ec97-4310-92c3-091f2f7b4bc0',
      'Andalucía Pre-Sunshine Tour (Día 8 - GP)',
      'Montenmedio, Vejer',
      'https://www.google.com/maps/search/?api=1&query=Dehesa+Montenmedio+Vejer',
      'https://oudofaiekedtaovrdqeo.supabase.co/storage/v1/object/public/sample-images/1/3/14.webp',
      FALSE,
      TRUE,
      '2026-01-25T09:00:00Z'::timestamptz,
      (SELECT id FROM public.cities WHERE LOWER(name) = LOWER('Vejer de la Frontera') LIMIT 1),
      (SELECT id FROM public.categories WHERE LOWER(slug) = 'deportes' LIMIT 1),
      'published',
      'Gran Premio final del Pre-Sunshine Tour.',
      'center');

INSERT INTO public.events (id, title, place, maps_url, image_url, is_featured, is_free, starts_at, city_id, category_id, status, description, image_alignment) VALUES (
      '9086b462-d3ca-481b-917b-c221e389eca7',
      'XXXIX Ostionada Popular',
      'Plaza San Antonio, Cádiz',
      'https://www.google.com/maps/search/?api=1&query=Plaza+San+Antonio+Cadiz',
      'https://oudofaiekedtaovrdqeo.supabase.co/storage/v1/object/public/sample-images/1/2/01.webp',
      FALSE,
      TRUE,
      '2026-01-25T13:30:00Z'::timestamptz,
      (SELECT id FROM public.cities WHERE LOWER(name) = LOWER('Cádiz') LIMIT 1),
      (SELECT id FROM public.categories WHERE LOWER(slug) = 'gastronomia' LIMIT 1),
      'published',
      'Degustación de ostiones y pimientos en la plaza. Evento oficial carnavalero.',
      'center');

INSERT INTO public.events (id, title, place, maps_url, image_url, is_featured, is_free, starts_at, city_id, category_id, status, description, image_alignment) VALUES (
      '668521c1-78a7-44fb-bcc6-6890c8b4fc19',
      'COAC 2026: Preliminares (Sesión 15)',
      'Gran Teatro Falla, Cádiz',
      'https://www.google.com/maps/search/?api=1&query=Gran+Teatro+Falla+Cadiz',
      'https://oudofaiekedtaovrdqeo.supabase.co/storage/v1/object/public/sample-images/1/6/06.webp',
      FALSE,
      FALSE,
      '2026-01-25T20:00:00Z'::timestamptz,
      (SELECT id FROM public.cities WHERE LOWER(name) = LOWER('Cádiz') LIMIT 1),
      (SELECT id FROM public.categories WHERE LOWER(slug) = 'tradiciones' LIMIT 1),
      'published',
      'Fase final de preliminares. Últimas oportunidades para clasificar.',
      'center');

INSERT INTO public.events (id, title, place, maps_url, image_url, is_featured, is_free, starts_at, city_id, category_id, status, description, image_alignment) VALUES (
      'e0503fa0-136a-4e2e-94d0-a4974d160a26',
      'COAC 2026: Preliminares (Sesión 16)',
      'Gran Teatro Falla, Cádiz',
      'https://www.google.com/maps/search/?api=1&query=Gran+Teatro+Falla+Cadiz',
      'https://oudofaiekedtaovrdqeo.supabase.co/storage/v1/object/public/sample-images/1/6/07.webp',
      FALSE,
      FALSE,
      '2026-01-26T20:00:00Z'::timestamptz,
      (SELECT id FROM public.cities WHERE LOWER(name) = LOWER('Cádiz') LIMIT 1),
      (SELECT id FROM public.categories WHERE LOWER(slug) = 'tradiciones' LIMIT 1),
      'published',
      'Agrupaciones: Coro ''Al garete'', Comparsa ''La carne-vale''.',
      'center');

INSERT INTO public.events (id, title, place, maps_url, image_url, is_featured, is_free, starts_at, city_id, category_id, status, description, image_alignment) VALUES (
      '08a54fa3-a98d-4318-9429-bd97ef205c80',
      'COAC 2026: Preliminares (Día Final)',
      'Gran Teatro Falla, Cádiz',
      'https://www.google.com/maps/search/?api=1&query=Gran+Teatro+Falla+Cadiz',
      'https://oudofaiekedtaovrdqeo.supabase.co/storage/v1/object/public/sample-images/1/6/08.webp',
      FALSE,
      FALSE,
      '2026-01-27T20:00:00Z'::timestamptz,
      (SELECT id FROM public.cities WHERE LOWER(name) = LOWER('Cádiz') LIMIT 1),
      (SELECT id FROM public.categories WHERE LOWER(slug) = 'tradiciones' LIMIT 1),
      'published',
      'Última noche. Coro ''Los iluminados''. Fallo del jurado de madrugada.',
      'center');

INSERT INTO public.events (id, title, place, maps_url, image_url, is_featured, is_free, starts_at, city_id, category_id, status, description, image_alignment) VALUES (
      '2ad6ed0f-1d11-402b-a373-7e6dc093d279',
      'COAC 2026: Cuartos de Final (Día 1)',
      'Gran Teatro Falla, Cádiz',
      'https://www.google.com/maps/search/?api=1&query=Gran+Teatro+Falla+Cadiz',
      'https://oudofaiekedtaovrdqeo.supabase.co/storage/v1/object/public/sample-images/1/6/09.webp',
      FALSE,
      FALSE,
      '2026-01-30T20:00:00Z'::timestamptz,
      (SELECT id FROM public.cities WHERE LOWER(name) = LOWER('Cádiz') LIMIT 1),
      (SELECT id FROM public.categories WHERE LOWER(slug) = 'tradiciones' LIMIT 1),
      'published',
      'Comienzan los cuartos. Actúan las agrupaciones con mejor puntuación.',
      'center');

INSERT INTO public.events (id, title, place, maps_url, image_url, is_featured, is_free, starts_at, city_id, category_id, status, description, image_alignment) VALUES (
      'a554f922-fcbf-47e7-9fb7-233c44452eaf',
      'Flamenco: Peña Buena Gente',
      'Peña Buena Gente, Jerez',
      'https://www.google.com/maps/search/?api=1&query=Pena+Flamenca+Buena+Gente+Jerez',
      'https://oudofaiekedtaovrdqeo.supabase.co/storage/v1/object/public/sample-images/1/1/03.webp',
      FALSE,
      TRUE,
      '2026-01-30T22:00:00Z'::timestamptz,
      (SELECT id FROM public.cities WHERE LOWER(name) = LOWER('Jerez de la Frontera') LIMIT 1),
      (SELECT id FROM public.categories WHERE LOWER(slug) = 'musica' LIMIT 1),
      'published',
      'Recital de cante jondo. Patrimonio inmaterial vivo.',
      'center');

INSERT INTO public.events (id, title, place, maps_url, image_url, is_featured, is_free, starts_at, city_id, category_id, status, description, image_alignment) VALUES (
      '572fad98-2b11-4cfe-b0dc-27207ea1099f',
      'IV Media Maratón Ciudad de Arcos',
      'Centro de Arcos',
      'https://www.google.com/maps/search/?api=1&query=Arcos+de+la+Frontera',
      'https://oudofaiekedtaovrdqeo.supabase.co/storage/v1/object/public/sample-images/1/3/15.webp',
      FALSE,
      FALSE,
      '2026-01-31T10:00:00Z'::timestamptz,
      (SELECT id FROM public.cities WHERE LOWER(name) = LOWER('') LIMIT 1),
      (SELECT id FROM public.categories WHERE LOWER(slug) = 'deportes' LIMIT 1),
      'published',
      'Carrera oficial con recorrido por el casco monumental de Arcos.',
      'center');

INSERT INTO public.events (id, title, place, maps_url, image_url, is_featured, is_free, starts_at, city_id, category_id, status, description, image_alignment) VALUES (
      '459bf49f-346b-4c5c-8f30-d18479a169fa',
      'Pregón Infantil Carnaval 2026',
      'Plaza San Antonio, Cádiz',
      'https://www.google.com/maps/search/?api=1&query=Plaza+San+Antonio+Cadiz',
      'https://oudofaiekedtaovrdqeo.supabase.co/storage/v1/object/public/sample-images/1/6/01.webp',
      FALSE,
      TRUE,
      '2026-01-31T12:00:00Z'::timestamptz,
      (SELECT id FROM public.cities WHERE LOWER(name) = LOWER('Cádiz') LIMIT 1),
      (SELECT id FROM public.categories WHERE LOWER(slug) = 'tradiciones' LIMIT 1),
      'published',
      'Inauguración oficial para los más pequeños en la plaza.',
      'center');

INSERT INTO public.events (id, title, place, maps_url, image_url, is_featured, is_free, starts_at, city_id, category_id, status, description, image_alignment) VALUES (
      '15d56927-060d-4316-84a7-6623354db870',
      'Futsal: Virgili Cádiz vs UD Alchoyano',
      'Pabellón Ciudad de Cádiz',
      'https://www.google.com/maps/search/?api=1&query=Complejo+Deportivo+Ciudad+de+Cadiz',
      'https://oudofaiekedtaovrdqeo.supabase.co/storage/v1/object/public/sample-images/1/3/16.webp',
      FALSE,
      FALSE,
      '2026-01-31T18:00:00Z'::timestamptz,
      (SELECT id FROM public.cities WHERE LOWER(name) = LOWER('Cádiz') LIMIT 1),
      (SELECT id FROM public.categories WHERE LOWER(slug) = 'deportes' LIMIT 1),
      'published',
      'Liga Segunda B Futsal.',
      'center');

INSERT INTO public.events (id, title, place, maps_url, image_url, is_featured, is_free, starts_at, city_id, category_id, status, description, image_alignment) VALUES (
      'de3ef8d2-fcd2-440b-83b8-5e73ce62c411',
      'COAC 2026: Cuartos de Final (Día 2)',
      'Gran Teatro Falla, Cádiz',
      'https://www.google.com/maps/search/?api=1&query=Gran+Teatro+Falla+Cadiz',
      'https://oudofaiekedtaovrdqeo.supabase.co/storage/v1/object/public/sample-images/1/6/02.webp',
      FALSE,
      FALSE,
      '2026-01-31T20:00:00Z'::timestamptz,
      (SELECT id FROM public.cities WHERE LOWER(name) = LOWER('Cádiz') LIMIT 1),
      (SELECT id FROM public.categories WHERE LOWER(slug) = 'tradiciones' LIMIT 1),
      'published',
      'Sábado de cuartos. Ambiente de gala en el Falla.',
      'center');

INSERT INTO public.events (id, title, place, maps_url, image_url, is_featured, is_free, starts_at, city_id, category_id, status, description, image_alignment) VALUES (
      'eeadce05-0689-48e5-b4d2-f55e70f916c1',
      'At. Sanluqueño vs Betis Deportivo',
      'Estadio El Palmar',
      'https://www.google.com/maps/search/?api=1&query=Estadio+El+Palmar+Sanlucar',
      'https://oudofaiekedtaovrdqeo.supabase.co/storage/v1/object/public/sample-images/1/3/01.webp',
      FALSE,
      FALSE,
      '2026-02-01T12:00:00Z'::timestamptz,
      (SELECT id FROM public.cities WHERE LOWER(name) = LOWER('') LIMIT 1),
      (SELECT id FROM public.categories WHERE LOWER(slug) = 'deportes' LIMIT 1),
      'published',
      'Primera Federación. Cantera bética en Sanlúcar.',
      'center');

INSERT INTO public.events (id, title, place, maps_url, image_url, is_featured, is_free, starts_at, city_id, category_id, status, description, image_alignment) VALUES (
      '552efc82-4598-4b95-9f3a-734d397086e1',
      'XLIV Erizada Popular',
      'Barrio de la Viña, Cádiz',
      'https://www.google.com/maps/search/?api=1&query=Calle+de+la+Palma+Cadiz',
      'https://oudofaiekedtaovrdqeo.supabase.co/storage/v1/object/public/sample-images/1/2/02.webp',
      FALSE,
      TRUE,
      '2026-02-01T13:30:00Z'::timestamptz,
      (SELECT id FROM public.cities WHERE LOWER(name) = LOWER('Cádiz') LIMIT 1),
      (SELECT id FROM public.categories WHERE LOWER(slug) = 'gastronomia' LIMIT 1),
      'published',
      'Degustación masiva de erizos. Evento central del pre-carnaval.',
      'center');

INSERT INTO public.events (id, title, place, maps_url, image_url, is_featured, is_free, starts_at, city_id, category_id, status, description, image_alignment) VALUES (
      'a1c5110f-2e38-4ae6-9519-e5798bbf8bd6',
      'COAC 2026: Cuartos de Final (Día 3)',
      'Gran Teatro Falla, Cádiz',
      'https://www.google.com/maps/search/?api=1&query=Gran+Teatro+Falla+Cadiz',
      'https://oudofaiekedtaovrdqeo.supabase.co/storage/v1/object/public/sample-images/1/6/03.webp',
      FALSE,
      FALSE,
      '2026-02-01T20:00:00Z'::timestamptz,
      (SELECT id FROM public.cities WHERE LOWER(name) = LOWER('Cádiz') LIMIT 1),
      (SELECT id FROM public.categories WHERE LOWER(slug) = 'tradiciones' LIMIT 1),
      'published',
      'Domingo de cuartos en el Gran Teatro Falla.',
      'center');

INSERT INTO public.events (id, title, place, maps_url, image_url, is_featured, is_free, starts_at, city_id, category_id, status, description, image_alignment) VALUES (
      'd149cb7f-0a84-4009-b1ff-4783cb7eb1cb',
      'COAC 2026: Cuartos de Final (Día 4)',
      'Gran Teatro Falla, Cádiz',
      'https://www.google.com/maps/search/?api=1&query=Gran+Teatro+Falla+Cadiz',
      'https://oudofaiekedtaovrdqeo.supabase.co/storage/v1/object/public/sample-images/1/6/04.webp',
      FALSE,
      FALSE,
      '2026-02-02T20:00:00Z'::timestamptz,
      (SELECT id FROM public.cities WHERE LOWER(name) = LOWER('Cádiz') LIMIT 1),
      (SELECT id FROM public.categories WHERE LOWER(slug) = 'tradiciones' LIMIT 1),
      'published',
      'Fase eliminatoria. Día 4 de cuartos.',
      'center');

INSERT INTO public.events (id, title, place, maps_url, image_url, is_featured, is_free, starts_at, city_id, category_id, status, description, image_alignment) VALUES (
      'f3e7df17-c7f9-403a-8137-05a7cdde8f6a',
      'Andalucía Sunshine Tour (Día 1)',
      'Montenmedio, Vejer',
      'https://www.google.com/maps/search/?api=1&query=Dehesa+Montenmedio+Vejer',
      'https://oudofaiekedtaovrdqeo.supabase.co/storage/v1/object/public/sample-images/1/3/02.webp',
      FALSE,
      TRUE,
      '2026-02-03T09:00:00Z'::timestamptz,
      (SELECT id FROM public.cities WHERE LOWER(name) = LOWER('Vejer de la Frontera') LIMIT 1),
      (SELECT id FROM public.categories WHERE LOWER(slug) = 'deportes' LIMIT 1),
      'published',
      'Inicio de la competición oficial CSI4*. Salto de obstáculos.',
      'center');

INSERT INTO public.events (id, title, place, maps_url, image_url, is_featured, is_free, starts_at, city_id, category_id, status, description, image_alignment) VALUES (
      'd8d86e53-2a41-4bde-aa74-5e9c455e5145',
      'COAC 2026: Cuartos de Final (Día 5)',
      'Gran Teatro Falla, Cádiz',
      'https://www.google.com/maps/search/?api=1&query=Gran+Teatro+Falla+Cadiz',
      'https://oudofaiekedtaovrdqeo.supabase.co/storage/v1/object/public/sample-images/1/6/05.webp',
      FALSE,
      FALSE,
      '2026-02-03T20:00:00Z'::timestamptz,
      (SELECT id FROM public.cities WHERE LOWER(name) = LOWER('Cádiz') LIMIT 1),
      (SELECT id FROM public.categories WHERE LOWER(slug) = 'tradiciones' LIMIT 1),
      'published',
      'Fase eliminatoria. Día 5 de cuartos.',
      'center');

INSERT INTO public.events (id, title, place, maps_url, image_url, is_featured, is_free, starts_at, city_id, category_id, status, description, image_alignment) VALUES (
      '60e64e51-cd28-4d6f-9984-2e3be4498d5e',
      'Andalucía Sunshine Tour (Día 2)',
      'Montenmedio, Vejer',
      'https://www.google.com/maps/search/?api=1&query=Dehesa+Montenmedio+Vejer',
      'https://oudofaiekedtaovrdqeo.supabase.co/storage/v1/object/public/sample-images/1/3/03.webp',
      FALSE,
      TRUE,
      '2026-02-04T09:00:00Z'::timestamptz,
      (SELECT id FROM public.cities WHERE LOWER(name) = LOWER('Vejer de la Frontera') LIMIT 1),
      (SELECT id FROM public.categories WHERE LOWER(slug) = 'deportes' LIMIT 1),
      'published',
      'Pruebas de caballos jóvenes (YH).',
      'center');

INSERT INTO public.events (id, title, place, maps_url, image_url, is_featured, is_free, starts_at, city_id, category_id, status, description, image_alignment) VALUES (
      'cb487eed-5a38-4697-93f9-52e7dfa2f3de',
      'COAC 2026: Cuartos de Final (Día 6)',
      'Gran Teatro Falla, Cádiz',
      'https://www.google.com/maps/search/?api=1&query=Gran+Teatro+Falla+Cadiz',
      'https://oudofaiekedtaovrdqeo.supabase.co/storage/v1/object/public/sample-images/1/6/06.webp',
      FALSE,
      FALSE,
      '2026-02-04T20:00:00Z'::timestamptz,
      (SELECT id FROM public.cities WHERE LOWER(name) = LOWER('Cádiz') LIMIT 1),
      (SELECT id FROM public.categories WHERE LOWER(slug) = 'tradiciones' LIMIT 1),
      'published',
      'Fase eliminatoria. Día 6 de cuartos.',
      'center');

INSERT INTO public.events (id, title, place, maps_url, image_url, is_featured, is_free, starts_at, city_id, category_id, status, description, image_alignment) VALUES (
      '85e9ec86-f20a-42ec-a6ca-ea222a78406c',
      'Andalucía Sunshine Tour (Día 3)',
      'Montenmedio, Vejer',
      'https://www.google.com/maps/search/?api=1&query=Dehesa+Montenmedio+Vejer',
      'https://oudofaiekedtaovrdqeo.supabase.co/storage/v1/object/public/sample-images/1/3/04.webp',
      FALSE,
      TRUE,
      '2026-02-05T09:00:00Z'::timestamptz,
      (SELECT id FROM public.cities WHERE LOWER(name) = LOWER('Vejer de la Frontera') LIMIT 1),
      (SELECT id FROM public.categories WHERE LOWER(slug) = 'deportes' LIMIT 1),
      'published',
      'Competición CSI4*. Pruebas grandes.',
      'center');

INSERT INTO public.events (id, title, place, maps_url, image_url, is_featured, is_free, starts_at, city_id, category_id, status, description, image_alignment) VALUES (
      '4bd8e7ec-c897-4708-9f79-59f0186e7ece',
      'COAC 2026: Cuartos de Final (Día Final)',
      'Gran Teatro Falla, Cádiz',
      'https://www.google.com/maps/search/?api=1&query=Gran+Teatro+Falla+Cadiz',
      'https://oudofaiekedtaovrdqeo.supabase.co/storage/v1/object/public/sample-images/1/6/07.webp',
      FALSE,
      FALSE,
      '2026-02-05T20:00:00Z'::timestamptz,
      (SELECT id FROM public.cities WHERE LOWER(name) = LOWER('Cádiz') LIMIT 1),
      (SELECT id FROM public.categories WHERE LOWER(slug) = 'tradiciones' LIMIT 1),
      'published',
      'Cierre de fase de cuartos y fallo para semifinales.',
      'center');

INSERT INTO public.events (id, title, place, maps_url, image_url, is_featured, is_free, starts_at, city_id, category_id, status, description, image_alignment) VALUES (
      'bd281b94-a971-4609-b217-a897bc3ea576',
      'Andalucía Sunshine Tour (Día 4)',
      'Montenmedio, Vejer',
      'https://www.google.com/maps/search/?api=1&query=Dehesa+Montenmedio+Vejer',
      'https://oudofaiekedtaovrdqeo.supabase.co/storage/v1/object/public/sample-images/1/3/05.webp',
      FALSE,
      TRUE,
      '2026-02-06T09:00:00Z'::timestamptz,
      (SELECT id FROM public.cities WHERE LOWER(name) = LOWER('Vejer de la Frontera') LIMIT 1),
      (SELECT id FROM public.categories WHERE LOWER(slug) = 'deportes' LIMIT 1),
      'published',
      'Competición CSI4* y CSI1*.',
      'center');

INSERT INTO public.events (id, title, place, maps_url, image_url, is_featured, is_free, starts_at, city_id, category_id, status, description, image_alignment) VALUES (
      'ad04665e-4743-4761-9264-c44432546e0a',
      'Teatro: Los Lunes al Sol',
      'Teatro Villamarta, Jerez',
      'https://www.google.com/maps/search/?api=1&query=Teatro+Villamarta+Jerez',
      'https://oudofaiekedtaovrdqeo.supabase.co/storage/v1/object/public/sample-images/1/4/03.webp',
      FALSE,
      FALSE,
      '2026-02-06T20:00:00Z'::timestamptz,
      (SELECT id FROM public.cities WHERE LOWER(name) = LOWER('Jerez de la Frontera') LIMIT 1),
      (SELECT id FROM public.categories WHERE LOWER(slug) = 'arte-y-cultura' LIMIT 1),
      'published',
      'Drama social en el Teatro Villamarta.',
      'center');

INSERT INTO public.events (id, title, place, maps_url, image_url, is_featured, is_free, starts_at, city_id, category_id, status, description, image_alignment) VALUES (
      '01b85d88-d61e-4168-b8c2-2d1b7be707c5',
      'Recital Peña Juanito Villar',
      'Peña Juanito Villar, Cádiz',
      'https://www.google.com/maps/search/?api=1&query=Pena+Juanito+Villar+Cadiz',
      'https://oudofaiekedtaovrdqeo.supabase.co/storage/v1/object/public/sample-images/1/1/04.webp',
      FALSE,
      TRUE,
      '2026-02-06T21:30:00Z'::timestamptz,
      (SELECT id FROM public.cities WHERE LOWER(name) = LOWER('Cádiz') LIMIT 1),
      (SELECT id FROM public.categories WHERE LOWER(slug) = 'musica' LIMIT 1),
      'published',
      'Flamenco puro frente a la playa de la Caleta.',
      'center');

INSERT INTO public.events (id, title, place, maps_url, image_url, is_featured, is_free, starts_at, city_id, category_id, status, description, image_alignment) VALUES (
      '0e96e708-8c12-4937-9c3a-95c6a35a2f5e',
      'Andalucía Sunshine Tour (Día 5)',
      'Montenmedio, Vejer',
      'https://www.google.com/maps/search/?api=1&query=Dehesa+Montenmedio+Vejer',
      'https://oudofaiekedtaovrdqeo.supabase.co/storage/v1/object/public/sample-images/1/3/06.webp',
      FALSE,
      TRUE,
      '2026-02-07T09:00:00Z'::timestamptz,
      (SELECT id FROM public.cities WHERE LOWER(name) = LOWER('Vejer de la Frontera') LIMIT 1),
      (SELECT id FROM public.categories WHERE LOWER(slug) = 'deportes' LIMIT 1),
      'published',
      'Jornada de sábado. Pruebas de ranking.',
      'center');

INSERT INTO public.events (id, title, place, maps_url, image_url, is_featured, is_free, starts_at, city_id, category_id, status, description, image_alignment) VALUES (
      '9277d5e2-8a0f-41df-a40b-8cfe8cc080b2',
      'XII Víboras Trail',
      'Algodonales',
      'https://www.google.com/maps/search/?api=1&query=Algodonales',
      'https://oudofaiekedtaovrdqeo.supabase.co/storage/v1/object/public/sample-images/1/3/07.webp',
      FALSE,
      FALSE,
      '2026-02-07T09:00:00Z'::timestamptz,
      (SELECT id FROM public.cities WHERE LOWER(name) = LOWER('') LIMIT 1),
      (SELECT id FROM public.categories WHERE LOWER(slug) = 'deportes' LIMIT 1),
      'published',
      'Trail de montaña exigente de 42km.',
      'center');

INSERT INTO public.events (id, title, place, maps_url, image_url, is_featured, is_free, starts_at, city_id, category_id, status, description, image_alignment) VALUES (
      '1c683daf-15b9-46f6-a9e7-53f0528e83ce',
      'Pregón Carnaval de Arcos',
      'Teatro Olivares Veas',
      'https://www.google.com/maps/search/?api=1&query=Teatro+Olivares+Veas+Arcos',
      'https://oudofaiekedtaovrdqeo.supabase.co/storage/v1/object/public/sample-images/1/6/08.webp',
      FALSE,
      TRUE,
      '2026-02-07T20:00:00Z'::timestamptz,
      (SELECT id FROM public.cities WHERE LOWER(name) = LOWER('') LIMIT 1),
      (SELECT id FROM public.categories WHERE LOWER(slug) = 'tradiciones' LIMIT 1),
      'published',
      'Inicio del carnaval serrano en el Olivares Veas.',
      'center');

INSERT INTO public.events (id, title, place, maps_url, image_url, is_featured, is_free, starts_at, city_id, category_id, status, description, image_alignment) VALUES (
      '8bb29492-719c-41de-9328-f7534803a2a1',
      'Andalucía Sunshine Tour (Día 6 - GP)',
      'Montenmedio, Vejer',
      'https://www.google.com/maps/search/?api=1&query=Dehesa+Montenmedio+Vejer',
      'https://oudofaiekedtaovrdqeo.supabase.co/storage/v1/object/public/sample-images/1/3/08.webp',
      FALSE,
      TRUE,
      '2026-02-08T09:00:00Z'::timestamptz,
      (SELECT id FROM public.cities WHERE LOWER(name) = LOWER('Vejer de la Frontera') LIMIT 1),
      (SELECT id FROM public.categories WHERE LOWER(slug) = 'deportes' LIMIT 1),
      'published',
      'Gran Premio de la primera semana grande.',
      'center');

INSERT INTO public.events (id, title, place, maps_url, image_url, is_featured, is_free, starts_at, city_id, category_id, status, description, image_alignment) VALUES (
      'b8f786bd-ef86-4dd3-bffe-b86a75e6d7ce',
      'Teatro Títeres La Tía Norica',
      'Teatro Títere Cádiz',
      'https://www.google.com/maps/search/?api=1&query=Teatro+Titere+Tia+Norica+Cadiz',
      'https://oudofaiekedtaovrdqeo.supabase.co/storage/v1/object/public/sample-images/1/4/04.webp',
      FALSE,
      FALSE,
      '2026-02-08T12:30:00Z'::timestamptz,
      (SELECT id FROM public.cities WHERE LOWER(name) = LOWER('Cádiz') LIMIT 1),
      (SELECT id FROM public.categories WHERE LOWER(slug) = 'arte-y-cultura' LIMIT 1),
      'published',
      'Compañía histórica gaditana. Espectáculo familiar.',
      'center');

INSERT INTO public.events (id, title, place, maps_url, image_url, is_featured, is_free, starts_at, city_id, category_id, status, description, image_alignment) VALUES (
      'c73ab87f-0db3-46a0-a4b9-0f14344bafee',
      'I Chicharronada Popular',
      'Plaza Catedral, Cádiz',
      'https://www.google.com/maps/search/?api=1&query=Plaza+Catedral+Cadiz',
      'https://oudofaiekedtaovrdqeo.supabase.co/storage/v1/object/public/sample-images/1/2/03.webp',
      FALSE,
      TRUE,
      '2026-02-08T13:30:00Z'::timestamptz,
      (SELECT id FROM public.cities WHERE LOWER(name) = LOWER('Cádiz') LIMIT 1),
      (SELECT id FROM public.categories WHERE LOWER(slug) = 'gastronomia' LIMIT 1),
      'published',
      'Degustación de chicharrones en la plaza de la catedral.',
      'center');

INSERT INTO public.events (id, title, place, maps_url, image_url, is_featured, is_free, starts_at, city_id, category_id, status, description, image_alignment) VALUES (
      '82c5f59e-9bf9-414f-871d-9fc2efafe633',
      'Cádiz CF vs UD Almería',
      'Nuevo Mirandilla, Cádiz',
      'https://www.google.com/maps/search/?api=1&query=Estadio+Nuevo+Mirandilla+Cadiz',
      'https://oudofaiekedtaovrdqeo.supabase.co/storage/v1/object/public/sample-images/1/3/09.webp',
      FALSE,
      FALSE,
      '2026-02-08T16:15:00Z'::timestamptz,
      (SELECT id FROM public.cities WHERE LOWER(name) = LOWER('Cádiz') LIMIT 1),
      (SELECT id FROM public.categories WHERE LOWER(slug) = 'deportes' LIMIT 1),
      'published',
      'LaLiga Hypermotion. Encuentro de alta intensidad.',
      'center');

INSERT INTO public.events (id, title, place, maps_url, image_url, is_featured, is_free, starts_at, city_id, category_id, status, description, image_alignment) VALUES (
      '63df9e47-a46a-43a6-b67a-83aa463c9000',
      'Andalucía Sunshine Tour (Semana 2 - Día 1)',
      'Montenmedio, Vejer',
      'https://www.google.com/maps/search/?api=1&query=Dehesa+Montenmedio+Vejer',
      'https://oudofaiekedtaovrdqeo.supabase.co/storage/v1/object/public/sample-images/1/3/10.webp',
      FALSE,
      TRUE,
      '2026-02-10T09:00:00Z'::timestamptz,
      (SELECT id FROM public.cities WHERE LOWER(name) = LOWER('Vejer de la Frontera') LIMIT 1),
      (SELECT id FROM public.categories WHERE LOWER(slug) = 'deportes' LIMIT 1),
      'published',
      'Segunda semana oficial. Pruebas CSI4*.',
      'center');

INSERT INTO public.events (id, title, place, maps_url, image_url, is_featured, is_free, starts_at, city_id, category_id, status, description, image_alignment) VALUES (
      'e30e6855-4b1b-4cdd-a357-cd119f8140c8',
      'Andalucía Sunshine Tour (Semana 2 - Día 2)',
      'Montenmedio, Vejer',
      'https://www.google.com/maps/search/?api=1&query=Dehesa+Montenmedio+Vejer',
      'https://oudofaiekedtaovrdqeo.supabase.co/storage/v1/object/public/sample-images/1/3/11.webp',
      FALSE,
      TRUE,
      '2026-02-11T09:00:00Z'::timestamptz,
      (SELECT id FROM public.cities WHERE LOWER(name) = LOWER('Vejer de la Frontera') LIMIT 1),
      (SELECT id FROM public.categories WHERE LOWER(slug) = 'deportes' LIMIT 1),
      'published',
      'Competición de saltos.',
      'center');

INSERT INTO public.events (id, title, place, maps_url, image_url, is_featured, is_free, starts_at, city_id, category_id, status, description, image_alignment) VALUES (
      '497eb661-e3ac-4e19-b9ff-4e0fd3788298',
      'Andalucía Sunshine Tour (Semana 2 - Día 3)',
      'Montenmedio, Vejer',
      'https://www.google.com/maps/search/?api=1&query=Dehesa+Montenmedio+Vejer',
      'https://oudofaiekedtaovrdqeo.supabase.co/storage/v1/object/public/sample-images/1/3/12.webp',
      FALSE,
      TRUE,
      '2026-02-12T09:00:00Z'::timestamptz,
      (SELECT id FROM public.cities WHERE LOWER(name) = LOWER('Vejer de la Frontera') LIMIT 1),
      (SELECT id FROM public.categories WHERE LOWER(slug) = 'deportes' LIMIT 1),
      'published',
      'Saltos de obstáculos internacionales.',
      'center');

INSERT INTO public.events (id, title, place, maps_url, image_url, is_featured, is_free, starts_at, city_id, category_id, status, description, image_alignment) VALUES (
      '3ac97d6c-83c4-4793-b2bc-5d0c45bcd0b4',
      'Encendido Alumbrado Carnaval',
      'Plaza San Antonio, Cádiz',
      'https://www.google.com/maps/search/?api=1&query=Plaza+San+Antonio+Cadiz',
      'https://oudofaiekedtaovrdqeo.supabase.co/storage/v1/object/public/sample-images/1/6/09.webp',
      FALSE,
      TRUE,
      '2026-02-12T20:00:00Z'::timestamptz,
      (SELECT id FROM public.cities WHERE LOWER(name) = LOWER('Cádiz') LIMIT 1),
      (SELECT id FROM public.categories WHERE LOWER(slug) = 'tradiciones' LIMIT 1),
      'published',
      'Evento simbólico que da inicio a la fiesta en la calle.',
      'center');

INSERT INTO public.events (id, title, place, maps_url, image_url, is_featured, is_free, starts_at, city_id, category_id, status, description, image_alignment) VALUES (
      '7c567a37-4f1e-481f-b383-f5a78cf74be6',
      'Andalucía Sunshine Tour (Semana 2 - Día 4)',
      'Montenmedio, Vejer',
      'https://www.google.com/maps/search/?api=1&query=Dehesa+Montenmedio+Vejer',
      'https://oudofaiekedtaovrdqeo.supabase.co/storage/v1/object/public/sample-images/1/3/13.webp',
      FALSE,
      TRUE,
      '2026-02-13T09:00:00Z'::timestamptz,
      (SELECT id FROM public.cities WHERE LOWER(name) = LOWER('Vejer de la Frontera') LIMIT 1),
      (SELECT id FROM public.categories WHERE LOWER(slug) = 'deportes' LIMIT 1),
      'published',
      'Viernes de competición hípica.',
      'center');

INSERT INTO public.events (id, title, place, maps_url, image_url, is_featured, is_free, starts_at, city_id, category_id, status, description, image_alignment) VALUES (
      '13933a3a-3c67-40c2-ba3c-18cacb71a5f2',
      'Gran Final COAC 2026',
      'Gran Teatro Falla, Cádiz',
      'https://www.google.com/maps/search/?api=1&query=Gran+Teatro+Falla+Cadiz',
      'https://oudofaiekedtaovrdqeo.supabase.co/storage/v1/object/public/sample-images/1/6/01.webp',
      FALSE,
      FALSE,
      '2026-02-13T20:00:00Z'::timestamptz,
      (SELECT id FROM public.cities WHERE LOWER(name) = LOWER('Cádiz') LIMIT 1),
      (SELECT id FROM public.categories WHERE LOWER(slug) = 'tradiciones' LIMIT 1),
      'published',
      'La noche mágica del Carnaval. Coronación de los ganadores.',
      'center');

INSERT INTO public.events (id, title, place, maps_url, image_url, is_featured, is_free, starts_at, city_id, category_id, status, description, image_alignment) VALUES (
      '9730402c-f157-4e87-81b1-e1a1a54f5d7d',
      'Andalucía Sunshine Tour (Semana 2 - Día 5)',
      'Montenmedio, Vejer',
      'https://www.google.com/maps/search/?api=1&query=Dehesa+Montenmedio+Vejer',
      'https://oudofaiekedtaovrdqeo.supabase.co/storage/v1/object/public/sample-images/1/3/14.webp',
      FALSE,
      TRUE,
      '2026-02-14T09:00:00Z'::timestamptz,
      (SELECT id FROM public.cities WHERE LOWER(name) = LOWER('Vejer de la Frontera') LIMIT 1),
      (SELECT id FROM public.categories WHERE LOWER(slug) = 'deportes' LIMIT 1),
      'published',
      'Sábado de hípica en Dehesa Montenmedio.',
      'center');

INSERT INTO public.events (id, title, place, maps_url, image_url, is_featured, is_free, starts_at, city_id, category_id, status, description, image_alignment) VALUES (
      '5f2bb8a9-ca7b-423a-9374-1cad34687914',
      'Mercado Agroecológico Toruños',
      'Parque Los Toruños, El Puerto',
      'https://www.google.com/maps/search/?api=1&query=Casa+de+los+Torunos',
      'https://oudofaiekedtaovrdqeo.supabase.co/storage/v1/object/public/sample-images/1/7/02.webp',
      FALSE,
      TRUE,
      '2026-02-14T11:00:00Z'::timestamptz,
      (SELECT id FROM public.cities WHERE LOWER(name) = LOWER('El Puerto de Santa María') LIMIT 1),
      (SELECT id FROM public.categories WHERE LOWER(slug) = 'mercadillos' LIMIT 1),
      'published',
      'Productos locales y ecológicos en el parque natural.',
      'center');

INSERT INTO public.events (id, title, place, maps_url, image_url, is_featured, is_free, starts_at, city_id, category_id, status, description, image_alignment) VALUES (
      '8209ed3f-f1a5-4b5c-8f68-029a1cceecb2',
      'Pregón Manu Sánchez',
      'Plaza San Antonio, Cádiz',
      'https://www.google.com/maps/search/?api=1&query=Plaza+San+Antonio+Cadiz',
      'https://oudofaiekedtaovrdqeo.supabase.co/storage/v1/object/public/sample-images/1/6/02.webp',
      FALSE,
      TRUE,
      '2026-02-14T22:00:00Z'::timestamptz,
      (SELECT id FROM public.cities WHERE LOWER(name) = LOWER('Cádiz') LIMIT 1),
      (SELECT id FROM public.categories WHERE LOWER(slug) = 'tradiciones' LIMIT 1),
      'published',
      'Pregón oficial del Carnaval de Cádiz en la plaza.',
      'center');

INSERT INTO public.events (id, title, place, maps_url, image_url, is_featured, is_free, starts_at, city_id, category_id, status, description, image_alignment) VALUES (
      '45d25400-1b77-4864-aca1-8016d8fdc36d',
      'Andalucía Sunshine Tour (Semana 2 - GP)',
      'Montenmedio, Vejer',
      'https://www.google.com/maps/search/?api=1&query=Dehesa+Montenmedio+Vejer',
      'https://oudofaiekedtaovrdqeo.supabase.co/storage/v1/object/public/sample-images/1/3/15.webp',
      FALSE,
      TRUE,
      '2026-02-15T09:00:00Z'::timestamptz,
      (SELECT id FROM public.cities WHERE LOWER(name) = LOWER('Vejer de la Frontera') LIMIT 1),
      (SELECT id FROM public.categories WHERE LOWER(slug) = 'deportes' LIMIT 1),
      'published',
      'Gran Premio final de la segunda semana.',
      'center');

INSERT INTO public.events (id, title, place, maps_url, image_url, is_featured, is_free, starts_at, city_id, category_id, status, description, image_alignment) VALUES (
      '3fb704fa-a160-4d14-9526-474b53b01a49',
      'Carrusel de Coros (Mercado)',
      'Mercado Central Cádiz',
      'https://www.google.com/maps/search/?api=1&query=Mercado+Central+Cadiz',
      'https://oudofaiekedtaovrdqeo.supabase.co/storage/v1/object/public/sample-images/1/6/03.webp',
      FALSE,
      TRUE,
      '2026-02-15T13:00:00Z'::timestamptz,
      (SELECT id FROM public.cities WHERE LOWER(name) = LOWER('Cádiz') LIMIT 1),
      (SELECT id FROM public.categories WHERE LOWER(slug) = 'tradiciones' LIMIT 1),
      'published',
      'Domingo de coros. Bateas cantando alrededor del mercado central.',
      'center');

INSERT INTO public.events (id, title, place, maps_url, image_url, is_featured, is_free, starts_at, city_id, category_id, status, description, image_alignment) VALUES (
      '84f2ff12-790e-4470-980a-ec4fb2f62b1d',
      'Gran Cabalgata Magna',
      'Avenida Andalucía, Cádiz',
      'https://www.google.com/maps/search/?api=1&query=Avenida+Andalucia+Cadiz',
      'https://oudofaiekedtaovrdqeo.supabase.co/storage/v1/object/public/sample-images/1/6/04.webp',
      FALSE,
      TRUE,
      '2026-02-15T17:00:00Z'::timestamptz,
      (SELECT id FROM public.cities WHERE LOWER(name) = LOWER('Cádiz') LIMIT 1),
      (SELECT id FROM public.categories WHERE LOWER(slug) = 'tradiciones' LIMIT 1),
      'published',
      'Desfile de carrozas por la avenida principal.',
      'center');

INSERT INTO public.events (id, title, place, maps_url, image_url, is_featured, is_free, starts_at, city_id, category_id, status, description, image_alignment) VALUES (
      'c1ca7627-09d2-42da-9308-550419c528f0',
      'Carrusel de Coros (La Viña)',
      'Barrio de La Viña, Cádiz',
      'https://www.google.com/maps/search/?api=1&query=Barrio+de+la+Vina+Cadiz',
      'https://oudofaiekedtaovrdqeo.supabase.co/storage/v1/object/public/sample-images/1/6/05.webp',
      FALSE,
      TRUE,
      '2026-02-16T13:00:00Z'::timestamptz,
      (SELECT id FROM public.cities WHERE LOWER(name) = LOWER('Cádiz') LIMIT 1),
      (SELECT id FROM public.categories WHERE LOWER(slug) = 'tradiciones' LIMIT 1),
      'published',
      'Lunes de coros en las calles de La Viña.',
      'center');

INSERT INTO public.events (id, title, place, maps_url, image_url, is_featured, is_free, starts_at, city_id, category_id, status, description, image_alignment) VALUES (
      'db630d5d-0ffb-4d5e-8fc6-c0d0302cedb6',
      'Andalucía Sunshine Tour (Semana 3 - Día 1)',
      'Montenmedio, Vejer',
      'https://www.google.com/maps/search/?api=1&query=Dehesa+Montenmedio+Vejer',
      'https://oudofaiekedtaovrdqeo.supabase.co/storage/v1/object/public/sample-images/1/3/16.webp',
      FALSE,
      TRUE,
      '2026-02-17T09:00:00Z'::timestamptz,
      (SELECT id FROM public.cities WHERE LOWER(name) = LOWER('Vejer de la Frontera') LIMIT 1),
      (SELECT id FROM public.categories WHERE LOWER(slug) = 'deportes' LIMIT 1),
      'published',
      'Competición hípica internacional.',
      'center');

INSERT INTO public.events (id, title, place, maps_url, image_url, is_featured, is_free, starts_at, city_id, category_id, status, description, image_alignment) VALUES (
      '68b5d287-322c-44a2-83eb-d10199915001',
      'Andalucía Sunshine Tour (Semana 3 - Día 2)',
      'Montenmedio, Vejer',
      'https://www.google.com/maps/search/?api=1&query=Dehesa+Montenmedio+Vejer',
      'https://oudofaiekedtaovrdqeo.supabase.co/storage/v1/object/public/sample-images/1/3/01.webp',
      FALSE,
      TRUE,
      '2026-02-18T09:00:00Z'::timestamptz,
      (SELECT id FROM public.cities WHERE LOWER(name) = LOWER('Vejer de la Frontera') LIMIT 1),
      (SELECT id FROM public.categories WHERE LOWER(slug) = 'deportes' LIMIT 1),
      'published',
      'Salto de obstáculos.',
      'center');

INSERT INTO public.events (id, title, place, maps_url, image_url, is_featured, is_free, starts_at, city_id, category_id, status, description, image_alignment) VALUES (
      '82b2878c-98ae-4bbb-b87b-0257448c28ec',
      'Andalucía Sunshine Tour (Semana 3 - Día 3)',
      'Montenmedio, Vejer',
      'https://www.google.com/maps/search/?api=1&query=Dehesa+Montenmedio+Vejer',
      'https://oudofaiekedtaovrdqeo.supabase.co/storage/v1/object/public/sample-images/1/3/02.webp',
      FALSE,
      TRUE,
      '2026-02-19T09:00:00Z'::timestamptz,
      (SELECT id FROM public.cities WHERE LOWER(name) = LOWER('Vejer de la Frontera') LIMIT 1),
      (SELECT id FROM public.categories WHERE LOWER(slug) = 'deportes' LIMIT 1),
      'published',
      'CSI4* en Vejer.',
      'center');

INSERT INTO public.events (id, title, place, maps_url, image_url, is_featured, is_free, starts_at, city_id, category_id, status, description, image_alignment) VALUES (
      '73e24616-eb49-4a75-8d40-e7e105bdcaa7',
      'Conferencia Historia de Cádiz',
      'Ateneo de Cádiz',
      'https://www.google.com/maps/search/?api=1&query=Ateneo+de+Cadiz',
      'https://oudofaiekedtaovrdqeo.supabase.co/storage/v1/object/public/sample-images/1/4/05.webp',
      FALSE,
      TRUE,
      '2026-02-19T20:00:00Z'::timestamptz,
      (SELECT id FROM public.cities WHERE LOWER(name) = LOWER('Cádiz') LIMIT 1),
      (SELECT id FROM public.categories WHERE LOWER(slug) = 'arte-y-cultura' LIMIT 1),
      'published',
      'Ciclo sobre el comercio con Indias en el Ateneo.',
      'center');

INSERT INTO public.events (id, title, place, maps_url, image_url, is_featured, is_free, starts_at, city_id, category_id, status, description, image_alignment) VALUES (
      'b24d77c3-d290-4503-b6c3-f2000c74ca2e',
      'Andalucía Sunshine Tour (Semana 3 - Día 4)',
      'Montenmedio, Vejer',
      'https://www.google.com/maps/search/?api=1&query=Dehesa+Montenmedio+Vejer',
      'https://oudofaiekedtaovrdqeo.supabase.co/storage/v1/object/public/sample-images/1/3/03.webp',
      FALSE,
      TRUE,
      '2026-02-20T09:00:00Z'::timestamptz,
      (SELECT id FROM public.cities WHERE LOWER(name) = LOWER('Vejer de la Frontera') LIMIT 1),
      (SELECT id FROM public.categories WHERE LOWER(slug) = 'deportes' LIMIT 1),
      'published',
      'Viernes de hípica.',
      'center');

INSERT INTO public.events (id, title, place, maps_url, image_url, is_featured, is_free, starts_at, city_id, category_id, status, description, image_alignment) VALUES (
      '5eadd12b-88fa-468f-a2cf-7ab1cb1f88da',
      'Inauguración Festival Jerez',
      'Teatro Villamarta, Jerez',
      'https://www.google.com/maps/search/?api=1&query=Teatro+Villamarta+Jerez',
      'https://oudofaiekedtaovrdqeo.supabase.co/storage/v1/object/public/sample-images/1/4/06.webp',
      FALSE,
      FALSE,
      '2026-02-20T20:30:00Z'::timestamptz,
      (SELECT id FROM public.cities WHERE LOWER(name) = LOWER('Jerez de la Frontera') LIMIT 1),
      (SELECT id FROM public.categories WHERE LOWER(slug) = 'arte-y-cultura' LIMIT 1),
      'published',
      'Bailaora: Manuela Carpio en el Villamarta.',
      'center');

INSERT INTO public.events (id, title, place, maps_url, image_url, is_featured, is_free, starts_at, city_id, category_id, status, description, image_alignment) VALUES (
      '82d7688e-4b1b-42eb-ba8a-f5a743e2c7b0',
      'Jerez Off Festival: Agujetas Chico',
      'La Guarida del Ángel, Jerez',
      'https://www.google.com/maps/search/?api=1&query=La+Guarida+del+Angel+Jerez',
      'https://oudofaiekedtaovrdqeo.supabase.co/storage/v1/object/public/sample-images/1/1/05.webp',
      FALSE,
      FALSE,
      '2026-02-20T23:00:00Z'::timestamptz,
      (SELECT id FROM public.cities WHERE LOWER(name) = LOWER('Jerez de la Frontera') LIMIT 1),
      (SELECT id FROM public.categories WHERE LOWER(slug) = 'musica' LIMIT 1),
      'published',
      'Ciclo flamenco nocturno.',
      'center');

INSERT INTO public.events (id, title, place, maps_url, image_url, is_featured, is_free, starts_at, city_id, category_id, status, description, image_alignment) VALUES (
      '8d850528-4b36-4c8a-81e2-de7b3b76042e',
      'Concierto: José de los Camarones',
      'La Guarida del Ángel, Jerez',
      'https://www.google.com/maps/search/?api=1&query=La+Guarida+del+Angel+Jerez',
      'https://oudofaiekedtaovrdqeo.supabase.co/storage/v1/object/public/sample-images/1/1/06.webp',
      FALSE,
      FALSE,
      '2026-02-21T00:00:00Z'::timestamptz,
      (SELECT id FROM public.cities WHERE LOWER(name) = LOWER('Jerez de la Frontera') LIMIT 1),
      (SELECT id FROM public.categories WHERE LOWER(slug) = 'musica' LIMIT 1),
      'published',
      'Flamenco puro de madrugada.',
      'center');

INSERT INTO public.events (id, title, place, maps_url, image_url, is_featured, is_free, starts_at, city_id, category_id, status, description, image_alignment) VALUES (
      'ac43387b-9b0b-4bb3-baa4-94e76c1097a9',
      'Andalucía Sunshine Tour (Semana 3 - Día 5)',
      'Montenmedio, Vejer',
      'https://www.google.com/maps/search/?api=1&query=Dehesa+Montenmedio+Vejer',
      'https://oudofaiekedtaovrdqeo.supabase.co/storage/v1/object/public/sample-images/1/3/04.webp',
      FALSE,
      TRUE,
      '2026-02-21T09:00:00Z'::timestamptz,
      (SELECT id FROM public.cities WHERE LOWER(name) = LOWER('Vejer de la Frontera') LIMIT 1),
      (SELECT id FROM public.categories WHERE LOWER(slug) = 'deportes' LIMIT 1),
      'published',
      'Sábado de ranking hípico.',
      'center');

INSERT INTO public.events (id, title, place, maps_url, image_url, is_featured, is_free, starts_at, city_id, category_id, status, description, image_alignment) VALUES (
      '6f79eae2-caf1-4d77-948a-5ff6403d12c5',
      'Festival Jerez (Día 2)',
      'Jerez Sedes Varias',
      'https://www.google.com/maps/search/?api=1&query=Teatro+Villamarta+Jerez',
      'https://oudofaiekedtaovrdqeo.supabase.co/storage/v1/object/public/sample-images/1/4/07.webp',
      FALSE,
      FALSE,
      '2026-02-21T18:00:00Z'::timestamptz,
      (SELECT id FROM public.cities WHERE LOWER(name) = LOWER('Jerez de la Frontera') LIMIT 1),
      (SELECT id FROM public.categories WHERE LOWER(slug) = 'arte-y-cultura' LIMIT 1),
      'published',
      'Espectáculos de baile en salas alternativas.',
      'center');

INSERT INTO public.events (id, title, place, maps_url, image_url, is_featured, is_free, starts_at, city_id, category_id, status, description, image_alignment) VALUES (
      '1cbaa947-2338-4840-ad40-2aa54c98dda9',
      'Cabalgata del Humor',
      'Cádiz Centro',
      'https://www.google.com/maps/search/?api=1&query=Plaza+San+Juan+de+Dios+Cadiz',
      'https://oudofaiekedtaovrdqeo.supabase.co/storage/v1/object/public/sample-images/1/6/06.webp',
      FALSE,
      TRUE,
      '2026-02-21T19:00:00Z'::timestamptz,
      (SELECT id FROM public.cities WHERE LOWER(name) = LOWER('Cádiz') LIMIT 1),
      (SELECT id FROM public.categories WHERE LOWER(slug) = 'tradiciones' LIMIT 1),
      'published',
      'Desfile callejero en el centro histórico.',
      'center');

INSERT INTO public.events (id, title, place, maps_url, image_url, is_featured, is_free, starts_at, city_id, category_id, status, description, image_alignment) VALUES (
      '008f17af-25e7-4a90-880b-27c90e2b09ae',
      'Andalucía Sunshine Tour (Semana 3 - GP)',
      'Montenmedio, Vejer',
      'https://www.google.com/maps/search/?api=1&query=Dehesa+Montenmedio+Vejer',
      'https://oudofaiekedtaovrdqeo.supabase.co/storage/v1/object/public/sample-images/1/3/05.webp',
      FALSE,
      TRUE,
      '2026-02-22T09:00:00Z'::timestamptz,
      (SELECT id FROM public.cities WHERE LOWER(name) = LOWER('Vejer de la Frontera') LIMIT 1),
      (SELECT id FROM public.categories WHERE LOWER(slug) = 'deportes' LIMIT 1),
      'published',
      'Gran Premio de saltos.',
      'center');

INSERT INTO public.events (id, title, place, maps_url, image_url, is_featured, is_free, starts_at, city_id, category_id, status, description, image_alignment) VALUES (
      '5686bc9b-6eb4-42af-9f9c-df726918b519',
      'Cádiz CF vs Real Sociedad B',
      'Nuevo Mirandilla, Cádiz',
      'https://www.google.com/maps/search/?api=1&query=Estadio+Nuevo+Mirandilla+Cadiz',
      'https://oudofaiekedtaovrdqeo.supabase.co/storage/v1/object/public/sample-images/1/3/06.webp',
      FALSE,
      FALSE,
      '2026-02-22T18:30:00Z'::timestamptz,
      (SELECT id FROM public.cities WHERE LOWER(name) = LOWER('Cádiz') LIMIT 1),
      (SELECT id FROM public.categories WHERE LOWER(slug) = 'deportes' LIMIT 1),
      'published',
      'Jornada 27 de Liga Hypermotion.',
      'center');

INSERT INTO public.events (id, title, place, maps_url, image_url, is_featured, is_free, starts_at, city_id, category_id, status, description, image_alignment) VALUES (
      '1e4ea29d-833d-4787-af2f-559fd24e5a1f',
      'Quema de la Bruja Piti',
      'Playa La Caleta, Cádiz',
      'https://www.google.com/maps/search/?api=1&query=Playa+La+Caleta+Cadiz',
      'https://oudofaiekedtaovrdqeo.supabase.co/storage/v1/object/public/sample-images/1/6/07.webp',
      FALSE,
      TRUE,
      '2026-02-22T22:00:00Z'::timestamptz,
      (SELECT id FROM public.cities WHERE LOWER(name) = LOWER('Cádiz') LIMIT 1),
      (SELECT id FROM public.categories WHERE LOWER(slug) = 'tradiciones' LIMIT 1),
      'published',
      'Cierre del Carnaval con fuegos artificiales.',
      'center');

INSERT INTO public.events (id, title, place, maps_url, image_url, is_featured, is_free, starts_at, city_id, category_id, status, description, image_alignment) VALUES (
      '105bc1d3-b997-44e2-bc42-9de16f3fa533',
      'Vía Crucis Hermandades',
      'Catedral de Cádiz',
      'https://www.google.com/maps/search/?api=1&query=Catedral+de+Cadiz',
      'https://oudofaiekedtaovrdqeo.supabase.co/storage/v1/object/public/sample-images/1/6/08.webp',
      FALSE,
      TRUE,
      '2026-02-23T19:00:00Z'::timestamptz,
      (SELECT id FROM public.cities WHERE LOWER(name) = LOWER('Cádiz') LIMIT 1),
      (SELECT id FROM public.categories WHERE LOWER(slug) = 'tradiciones' LIMIT 1),
      'published',
      'Traslado solemne a la Catedral.',
      'center');

INSERT INTO public.events (id, title, place, maps_url, image_url, is_featured, is_free, starts_at, city_id, category_id, status, description, image_alignment) VALUES (
      '04f86b94-992c-47f6-9f87-e31bec2bb5bc',
      'Andalucía Sunshine Tour (Semana 4 - Día 1)',
      'Montenmedio, Vejer',
      'https://www.google.com/maps/search/?api=1&query=Dehesa+Montenmedio+Vejer',
      'https://oudofaiekedtaovrdqeo.supabase.co/storage/v1/object/public/sample-images/1/3/07.webp',
      FALSE,
      TRUE,
      '2026-02-24T09:00:00Z'::timestamptz,
      (SELECT id FROM public.cities WHERE LOWER(name) = LOWER('Vejer de la Frontera') LIMIT 1),
      (SELECT id FROM public.categories WHERE LOWER(slug) = 'deportes' LIMIT 1),
      'published',
      'Semana del Día de Andalucía.',
      'center');

INSERT INTO public.events (id, title, place, maps_url, image_url, is_featured, is_free, starts_at, city_id, category_id, status, description, image_alignment) VALUES (
      'c7fe559c-9772-4089-bbfe-1748dff94818',
      'Festival Jerez (Día 5)',
      'Jerez Sedes Varias',
      'https://www.google.com/maps/search/?api=1&query=Teatro+Villamarta+Jerez',
      'https://oudofaiekedtaovrdqeo.supabase.co/storage/v1/object/public/sample-images/1/4/08.webp',
      FALSE,
      FALSE,
      '2026-02-24T18:00:00Z'::timestamptz,
      (SELECT id FROM public.cities WHERE LOWER(name) = LOWER('Jerez de la Frontera') LIMIT 1),
      (SELECT id FROM public.categories WHERE LOWER(slug) = 'arte-y-cultura' LIMIT 1),
      'published',
      'Programación de baile y cante.',
      'center');

INSERT INTO public.events (id, title, place, maps_url, image_url, is_featured, is_free, starts_at, city_id, category_id, status, description, image_alignment) VALUES (
      '1a028d5b-98a0-4d18-b79c-6a275ce8eb4c',
      'Andalucía Sunshine Tour (Semana 4 - Día 2)',
      'Montenmedio, Vejer',
      'https://www.google.com/maps/search/?api=1&query=Dehesa+Montenmedio+Vejer',
      'https://oudofaiekedtaovrdqeo.supabase.co/storage/v1/object/public/sample-images/1/3/08.webp',
      FALSE,
      TRUE,
      '2026-02-25T09:00:00Z'::timestamptz,
      (SELECT id FROM public.cities WHERE LOWER(name) = LOWER('Vejer de la Frontera') LIMIT 1),
      (SELECT id FROM public.categories WHERE LOWER(slug) = 'deportes' LIMIT 1),
      'published',
      'Salto de obstáculos.',
      'center');

INSERT INTO public.events (id, title, place, maps_url, image_url, is_featured, is_free, starts_at, city_id, category_id, status, description, image_alignment) VALUES (
      '3849d8ce-dfeb-46fd-8243-663fc15adb88',
      'Andalucía Sunshine Tour (Semana 4 - Día 3)',
      'Montenmedio, Vejer',
      'https://www.google.com/maps/search/?api=1&query=Dehesa+Montenmedio+Vejer',
      'https://oudofaiekedtaovrdqeo.supabase.co/storage/v1/object/public/sample-images/1/3/09.webp',
      FALSE,
      TRUE,
      '2026-02-26T09:00:00Z'::timestamptz,
      (SELECT id FROM public.cities WHERE LOWER(name) = LOWER('Vejer de la Frontera') LIMIT 1),
      (SELECT id FROM public.categories WHERE LOWER(slug) = 'deportes' LIMIT 1),
      'published',
      'CSI2* en Vejer.',
      'center');

INSERT INTO public.events (id, title, place, maps_url, image_url, is_featured, is_free, starts_at, city_id, category_id, status, description, image_alignment) VALUES (
      'ca4a6905-e784-48f8-bbfb-e37ca5fed632',
      'Andalucía Sunshine Tour (Semana 4 - Día 4)',
      'Montenmedio, Vejer',
      'https://www.google.com/maps/search/?api=1&query=Dehesa+Montenmedio+Vejer',
      'https://oudofaiekedtaovrdqeo.supabase.co/storage/v1/object/public/sample-images/1/3/10.webp',
      FALSE,
      TRUE,
      '2026-02-27T09:00:00Z'::timestamptz,
      (SELECT id FROM public.cities WHERE LOWER(name) = LOWER('Vejer de la Frontera') LIMIT 1),
      (SELECT id FROM public.categories WHERE LOWER(slug) = 'deportes' LIMIT 1),
      'published',
      'Víspera de festivo.',
      'center');

INSERT INTO public.events (id, title, place, maps_url, image_url, is_featured, is_free, starts_at, city_id, category_id, status, description, image_alignment) VALUES (
      '12251358-f213-4ae3-805f-838fa2da93e6',
      'Concierto Orquesta Algeciras',
      'Teatro Florida, Algeciras',
      'https://www.google.com/maps/search/?api=1&query=Teatro+Florida+Algeciras',
      'https://oudofaiekedtaovrdqeo.supabase.co/storage/v1/object/public/sample-images/1/1/07.webp',
      FALSE,
      FALSE,
      '2026-02-27T20:00:00Z'::timestamptz,
      (SELECT id FROM public.cities WHERE LOWER(name) = LOWER('Algeciras') LIMIT 1),
      (SELECT id FROM public.categories WHERE LOWER(slug) = 'musica' LIMIT 1),
      'published',
      'Música clásica andaluza en el Teatro Florida.',
      'center');

INSERT INTO public.events (id, title, place, maps_url, image_url, is_featured, is_free, starts_at, city_id, category_id, status, description, image_alignment) VALUES (
      '8b357da0-883c-430b-92bb-3a0f1dbcafc0',
      'Andalucía Sunshine Tour (Semana 4 - GP Andalucía)',
      'Montenmedio, Vejer',
      'https://www.google.com/maps/search/?api=1&query=Dehesa+Montenmedio+Vejer',
      'https://oudofaiekedtaovrdqeo.supabase.co/storage/v1/object/public/sample-images/1/3/11.webp',
      FALSE,
      TRUE,
      '2026-02-28T09:00:00Z'::timestamptz,
      (SELECT id FROM public.cities WHERE LOWER(name) = LOWER('Vejer de la Frontera') LIMIT 1),
      (SELECT id FROM public.categories WHERE LOWER(slug) = 'deportes' LIMIT 1),
      'published',
      'Evento hípico central del Día de Andalucía.',
      'center');

INSERT INTO public.events (id, title, place, maps_url, image_url, is_featured, is_free, starts_at, city_id, category_id, status, description, image_alignment) VALUES (
      '8fab372f-f369-4349-a45f-43ff30d26d5c',
      'Día de Andalucía Provincial',
      'Provincia de Cádiz',
      'https://www.google.com/maps/search/?api=1&query=Cadiz',
      'https://oudofaiekedtaovrdqeo.supabase.co/storage/v1/object/public/sample-images/1/6/09.webp',
      FALSE,
      TRUE,
      '2026-02-28T12:00:00Z'::timestamptz,
      (SELECT id FROM public.cities WHERE LOWER(name) = LOWER('Cádiz') LIMIT 1),
      (SELECT id FROM public.categories WHERE LOWER(slug) = 'tradiciones' LIMIT 1),
      'published',
      'Actos institucionales e izado de banderas en todos los ayuntamientos.',
      'center');

INSERT INTO public.events (id, title, place, maps_url, image_url, is_featured, is_free, starts_at, city_id, category_id, status, description, image_alignment) VALUES (
      '87e5dbbc-fc4b-4921-a7d8-7512e96b4c15',
      'Festival Jerez (Día 9)',
      'Teatro Villamarta, Jerez',
      'https://www.google.com/maps/search/?api=1&query=Teatro+Villamarta+Jerez',
      'https://oudofaiekedtaovrdqeo.supabase.co/storage/v1/object/public/sample-images/1/4/09.webp',
      FALSE,
      FALSE,
      '2026-02-28T18:00:00Z'::timestamptz,
      (SELECT id FROM public.cities WHERE LOWER(name) = LOWER('Jerez de la Frontera') LIMIT 1),
      (SELECT id FROM public.categories WHERE LOWER(slug) = 'arte-y-cultura' LIMIT 1),
      'published',
      'Gran espectáculo final de mes en el Villamarta.',
      'center');

INSERT INTO public.events (id, title, place, maps_url, image_url, is_featured, is_free, starts_at, city_id, category_id, status, description, image_alignment) VALUES (
      'ee1b22e6-a0d2-4c09-a37c-f08e7d6e9ec6',
      'Fútbol Juvenil: Cádiz CF vs Arenas de Armilla',
      'Ciudad Deportiva El Rosal, Puerto Real',
      'https://www.google.com/maps/search/?api=1&query=Ciudad+Deportiva+Bahia+de+Cadiz',
      'https://oudofaiekedtaovrdqeo.supabase.co/storage/v1/object/public/sample-images/1/3/12.webp',
      FALSE,
      TRUE,
      '2026-02-08T12:00:00Z'::timestamptz,
      (SELECT id FROM public.cities WHERE LOWER(name) = LOWER('Puerto Real') LIMIT 1),
      (SELECT id FROM public.categories WHERE LOWER(slug) = 'deportes' LIMIT 1),
      'published',
      'División de Honor Juvenil. Ver a las promesas del equipo amarillo.',
      'center');

INSERT INTO public.events (id, title, place, maps_url, image_url, is_featured, is_free, starts_at, city_id, category_id, status, description, image_alignment) VALUES (
      'e99a91ad-9060-402e-ad9a-263b2f8fac75',
      'COAC 2026: Semifinales (Sesión 1)',
      'Gran Teatro Falla, Cádiz',
      'https://www.google.com/maps/search/?api=1&query=Gran+Teatro+Falla+Cadiz',
      'https://oudofaiekedtaovrdqeo.supabase.co/storage/v1/object/public/sample-images/1/6/01.webp',
      FALSE,
      FALSE,
      '2026-02-08T20:00:00Z'::timestamptz,
      (SELECT id FROM public.cities WHERE LOWER(name) = LOWER('Cádiz') LIMIT 1),
      (SELECT id FROM public.categories WHERE LOWER(slug) = 'tradiciones' LIMIT 1),
      'published',
      'Inicio de la fase decisiva. Actúan los grandes favoritos del concurso.',
      'center');

INSERT INTO public.events (id, title, place, maps_url, image_url, is_featured, is_free, starts_at, city_id, category_id, status, description, image_alignment) VALUES (
      'd96e92b1-99f8-494e-b341-f3c4d4faf4ab',
      'COAC 2026: Semifinales (Sesión 2)',
      'Gran Teatro Falla, Cádiz',
      'https://www.google.com/maps/search/?api=1&query=Gran+Teatro+Falla+Cadiz',
      'https://oudofaiekedtaovrdqeo.supabase.co/storage/v1/object/public/sample-images/1/6/02.webp',
      FALSE,
      FALSE,
      '2026-02-09T20:00:00Z'::timestamptz,
      (SELECT id FROM public.cities WHERE LOWER(name) = LOWER('Cádiz') LIMIT 1),
      (SELECT id FROM public.categories WHERE LOWER(slug) = 'tradiciones' LIMIT 1),
      'published',
      'Fase de semifinales. Máximo nivel de comparsas y chirigotas.',
      'center');

INSERT INTO public.events (id, title, place, maps_url, image_url, is_featured, is_free, starts_at, city_id, category_id, status, description, image_alignment) VALUES (
      '0eab07de-a1d9-4037-a2a6-9c973f529d14',
      'COAC 2026: Semifinales (Sesión 3)',
      'Gran Teatro Falla, Cádiz',
      'https://www.google.com/maps/search/?api=1&query=Gran+Teatro+Falla+Cadiz',
      'https://oudofaiekedtaovrdqeo.supabase.co/storage/v1/object/public/sample-images/1/6/03.webp',
      FALSE,
      FALSE,
      '2026-02-10T20:00:00Z'::timestamptz,
      (SELECT id FROM public.cities WHERE LOWER(name) = LOWER('Cádiz') LIMIT 1),
      (SELECT id FROM public.categories WHERE LOWER(slug) = 'tradiciones' LIMIT 1),
      'published',
      'Penúltima sesión de semifinales.',
      'center');

INSERT INTO public.events (id, title, place, maps_url, image_url, is_featured, is_free, starts_at, city_id, category_id, status, description, image_alignment) VALUES (
      '8d26c141-7a97-463a-a733-d9688593733a',
      'COAC 2026: Semifinales (Día Final)',
      'Gran Teatro Falla, Cádiz',
      'https://www.google.com/maps/search/?api=1&query=Gran+Teatro+Falla+Cadiz',
      'https://oudofaiekedtaovrdqeo.supabase.co/storage/v1/object/public/sample-images/1/6/04.webp',
      FALSE,
      FALSE,
      '2026-02-11T20:00:00Z'::timestamptz,
      (SELECT id FROM public.cities WHERE LOWER(name) = LOWER('Cádiz') LIMIT 1),
      (SELECT id FROM public.categories WHERE LOWER(slug) = 'tradiciones' LIMIT 1),
      'published',
      'Cierre de semifinales y fallo del jurado para la Gran Final.',
      'center');

INSERT INTO public.events (id, title, place, maps_url, image_url, is_featured, is_free, starts_at, city_id, category_id, status, description, image_alignment) VALUES (
      '1e3eabbf-487c-4c91-955c-b545aa61200d',
      'Ruta en Kayak: San Valentín en el Mar',
      'Puerto Deportivo Sancti Petri, Chiclana',
      'https://www.google.com/maps/search/?api=1&query=Puerto+Sancti+Petri',
      'https://oudofaiekedtaovrdqeo.supabase.co/storage/v1/object/public/sample-images/1/5/01.webp',
      FALSE,
      FALSE,
      '2026-02-14T11:00:00Z'::timestamptz,
      (SELECT id FROM public.cities WHERE LOWER(name) = LOWER('Chiclana de la Frontera') LIMIT 1),
      (SELECT id FROM public.categories WHERE LOWER(slug) = 'aire-libre' LIMIT 1),
      'published',
      'Ruta guiada por las Marismas de Sancti Petri para parejas y grupos.',
      'center');

INSERT INTO public.events (id, title, place, maps_url, image_url, is_featured, is_free, starts_at, city_id, category_id, status, description, image_alignment) VALUES (
      'c85f16f0-8dd9-4fed-80d9-dc099d510791',
      'Teatro: ''Se Alquila'' con Andoni Ferreño',
      'Sala La Gramola, Algeciras',
      'https://www.google.com/maps/search/?api=1&query=Sala+La+Gramola+Algeciras',
      'https://oudofaiekedtaovrdqeo.supabase.co/storage/v1/object/public/sample-images/1/4/01.webp',
      FALSE,
      FALSE,
      '2026-01-26T19:00:00Z'::timestamptz,
      (SELECT id FROM public.cities WHERE LOWER(name) = LOWER('Algeciras') LIMIT 1),
      (SELECT id FROM public.categories WHERE LOWER(slug) = 'arte-y-cultura' LIMIT 1),
      'published',
      'Comedia teatral de éxito nacional en gira por la provincia.',
      'center');

INSERT INTO public.events (id, title, place, maps_url, image_url, is_featured, is_free, starts_at, city_id, category_id, status, description, image_alignment) VALUES (
      '48dc8d16-6a10-4efb-b748-a352a331acb3',
      'Fútbol Infantil: Cádiz CF ''A'' vs Real Betis',
      'Ciudad Deportiva El Rosal, Puerto Real',
      'https://www.google.com/maps/search/?api=1&query=Ciudad+Deportiva+Bahia+de+Cadiz',
      'https://oudofaiekedtaovrdqeo.supabase.co/storage/v1/object/public/sample-images/1/3/13.webp',
      FALSE,
      TRUE,
      '2026-02-15T11:00:00Z'::timestamptz,
      (SELECT id FROM public.cities WHERE LOWER(name) = LOWER('Puerto Real') LIMIT 1),
      (SELECT id FROM public.categories WHERE LOWER(slug) = 'deportes' LIMIT 1),
      'published',
      'Duelo de canteras andaluzas de primer nivel.',
      'center');

INSERT INTO public.events (id, title, place, maps_url, image_url, is_featured, is_free, starts_at, city_id, category_id, status, description, image_alignment) VALUES (
      '2a70fce2-b6f1-4d9b-bad3-7f00a6230618',
      'Sunshine Tour: Young Horses Week 2',
      'Dehesa Montenmedio, Vejer',
      'https://www.google.com/maps/search/?api=1&query=Dehesa+Montenmedio+Vejer',
      'https://oudofaiekedtaovrdqeo.supabase.co/storage/v1/object/public/sample-images/1/3/14.webp',
      FALSE,
      TRUE,
      '2026-02-18T09:00:00Z'::timestamptz,
      (SELECT id FROM public.cities WHERE LOWER(name) = LOWER('Vejer de la Frontera') LIMIT 1),
      (SELECT id FROM public.categories WHERE LOWER(slug) = 'deportes' LIMIT 1),
      'published',
      'Competición de saltos para potros de formación.',
      'center');

INSERT INTO public.events (id, title, place, maps_url, image_url, is_featured, is_free, starts_at, city_id, category_id, status, description, image_alignment) VALUES (
      '9f115bd6-7629-4119-bdd2-d52651dd6d41',
      'Sunshine Tour: CSI4* Week 2 (Día 1)',
      'Dehesa Montenmedio, Vejer',
      'https://www.google.com/maps/search/?api=1&query=Dehesa+Montenmedio+Vejer',
      'https://oudofaiekedtaovrdqeo.supabase.co/storage/v1/object/public/sample-images/1/3/15.webp',
      FALSE,
      TRUE,
      '2026-02-19T09:00:00Z'::timestamptz,
      (SELECT id FROM public.cities WHERE LOWER(name) = LOWER('Vejer de la Frontera') LIMIT 1),
      (SELECT id FROM public.categories WHERE LOWER(slug) = 'deportes' LIMIT 1),
      'published',
      'Pruebas de calificación internacional de alta montaña.',
      'center');

INSERT INTO public.events (id, title, place, maps_url, image_url, is_featured, is_free, starts_at, city_id, category_id, status, description, image_alignment) VALUES (
      '75b3aa37-4713-408b-a2fc-6970d55c5f8d',
      'Concierto: King Sapo (Rock)',
      'La Guarida del Ángel, Jerez',
      'https://www.google.com/maps/search/?api=1&query=La+Guarida+del+Angel+Jerez',
      'https://oudofaiekedtaovrdqeo.supabase.co/storage/v1/object/public/sample-images/1/1/08.webp',
      FALSE,
      FALSE,
      '2026-01-23T22:00:00Z'::timestamptz,
      (SELECT id FROM public.cities WHERE LOWER(name) = LOWER('Jerez de la Frontera') LIMIT 1),
      (SELECT id FROM public.categories WHERE LOWER(slug) = 'musica' LIMIT 1),
      'published',
      'Banda de Rock nacional en directo.',
      'center');

INSERT INTO public.events (id, title, place, maps_url, image_url, is_featured, is_free, starts_at, city_id, category_id, status, description, image_alignment) VALUES (
      '90b34f44-48ff-4a0f-9ec4-36368a3524a5',
      'Carrusel de Coros: Puerta Tierra',
      'Avenida de la Constitución, Cádiz',
      'https://www.google.com/maps/search/?api=1&query=Avenida+Constitucion+Cadiz',
      'https://oudofaiekedtaovrdqeo.supabase.co/storage/v1/object/public/sample-images/1/6/05.webp',
      FALSE,
      TRUE,
      '2026-02-21T12:00:00Z'::timestamptz,
      (SELECT id FROM public.cities WHERE LOWER(name) = LOWER('Cádiz') LIMIT 1),
      (SELECT id FROM public.categories WHERE LOWER(slug) = 'tradiciones' LIMIT 1),
      'published',
      'Circuito de coros fuera del casco antiguo para los barrios de extramuros.',
      'center');

INSERT INTO public.events (id, title, place, maps_url, image_url, is_featured, is_free, starts_at, city_id, category_id, status, description, image_alignment) VALUES (
      '5645ee48-18d9-45e4-84a4-c6386bf2ee2e',
      'Degustación Popular: Paniza y Estofado',
      'Plaza del Mentidero, Cádiz',
      'https://www.google.com/maps/search/?api=1&query=Plaza+del+Mentidero+Cadiz',
      'https://oudofaiekedtaovrdqeo.supabase.co/storage/v1/object/public/sample-images/1/2/04.webp',
      FALSE,
      TRUE,
      '2026-02-21T14:00:00Z'::timestamptz,
      (SELECT id FROM public.cities WHERE LOWER(name) = LOWER('Cádiz') LIMIT 1),
      (SELECT id FROM public.categories WHERE LOWER(slug) = 'gastronomia' LIMIT 1),
      'published',
      'Comida popular organizada por peñas en el centro.',
      'center');

INSERT INTO public.events (id, title, place, maps_url, image_url, is_featured, is_free, starts_at, city_id, category_id, status, description, image_alignment) VALUES (
      '9b3d14ae-743e-4ebc-b61e-3690490f5a70',
      'Círculo Literario Francófono',
      'Biblioteca Municipal Sanlúcar',
      'https://www.google.com/maps/search/?api=1&query=Biblioteca+Municipal+Sanlucar+de+Barrameda',
      'https://oudofaiekedtaovrdqeo.supabase.co/storage/v1/object/public/sample-images/1/4/02.webp',
      FALSE,
      TRUE,
      '2026-01-14T19:00:00Z'::timestamptz,
      (SELECT id FROM public.cities WHERE LOWER(name) = LOWER('Sanlúcar de Barrameda') LIMIT 1),
      (SELECT id FROM public.categories WHERE LOWER(slug) = 'arte-y-cultura' LIMIT 1),
      'published',
      'Análisis del libro ''Soleil amer'' de Lilia Hassaine en la biblioteca.',
      'center');

INSERT INTO public.events (id, title, place, maps_url, image_url, is_featured, is_free, starts_at, city_id, category_id, status, description, image_alignment) VALUES (
      'b18674af-acab-4baa-9e7e-d83b0fc7c1c3',
      'Festival de Jerez: Joaquín Grilo',
      'Teatro Villamarta, Jerez',
      'https://www.google.com/maps/search/?api=1&query=Teatro+Villamarta+Jerez',
      'https://oudofaiekedtaovrdqeo.supabase.co/storage/v1/object/public/sample-images/1/4/03.webp',
      FALSE,
      FALSE,
      '2026-02-24T20:30:00Z'::timestamptz,
      (SELECT id FROM public.cities WHERE LOWER(name) = LOWER('Jerez de la Frontera') LIMIT 1),
      (SELECT id FROM public.categories WHERE LOWER(slug) = 'arte-y-cultura' LIMIT 1),
      'published',
      'Espectáculo de baile flamenco ''Cucharita y Paso atrás''.',
      'center');

INSERT INTO public.events (id, title, place, maps_url, image_url, is_featured, is_free, starts_at, city_id, category_id, status, description, image_alignment) VALUES (
      '60cb31d9-3d78-45d7-9ce0-f8c8a994495c',
      'Festival de Jerez: David Coria',
      'Teatro Villamarta, Jerez',
      'https://www.google.com/maps/search/?api=1&query=Teatro+Villamarta+Jerez',
      'https://oudofaiekedtaovrdqeo.supabase.co/storage/v1/object/public/sample-images/1/4/04.webp',
      FALSE,
      FALSE,
      '2026-02-25T20:30:00Z'::timestamptz,
      (SELECT id FROM public.cities WHERE LOWER(name) = LOWER('Jerez de la Frontera') LIMIT 1),
      (SELECT id FROM public.categories WHERE LOWER(slug) = 'arte-y-cultura' LIMIT 1),
      'published',
      'Bailaor vanguardista presenta su nueva creación.',
      'center');

INSERT INTO public.events (id, title, place, maps_url, image_url, is_featured, is_free, starts_at, city_id, category_id, status, description, image_alignment) VALUES (
      'c77244dc-2276-4288-8e99-627e59d7f77e',
      'Festival de Jerez: Sara Baras',
      'Teatro Villamarta, Jerez',
      'https://www.google.com/maps/search/?api=1&query=Teatro+Villamarta+Jerez',
      'https://oudofaiekedtaovrdqeo.supabase.co/storage/v1/object/public/sample-images/1/4/05.webp',
      FALSE,
      FALSE,
      '2026-02-26T20:30:00Z'::timestamptz,
      (SELECT id FROM public.cities WHERE LOWER(name) = LOWER('Jerez de la Frontera') LIMIT 1),
      (SELECT id FROM public.categories WHERE LOWER(slug) = 'arte-y-cultura' LIMIT 1),
      'published',
      'Gala especial de la bailaora gaditana más internacional.',
      'center');

INSERT INTO public.events (id, title, place, maps_url, image_url, is_featured, is_free, starts_at, city_id, category_id, status, description, image_alignment) VALUES (
      '0acc80e6-574d-4403-888f-cbf4d186bbec',
      'Mercadillo de Antigüedades (Algeciras)',
      'Plaza de Toros, Algeciras',
      'https://www.google.com/maps/search/?api=1&query=Plaza+de+Toros+Algeciras',
      'https://oudofaiekedtaovrdqeo.supabase.co/storage/v1/object/public/sample-images/1/7/03.webp',
      FALSE,
      TRUE,
      '2026-01-31T09:00:00Z'::timestamptz,
      (SELECT id FROM public.cities WHERE LOWER(name) = LOWER('Algeciras') LIMIT 1),
      (SELECT id FROM public.categories WHERE LOWER(slug) = 'mercadillos' LIMIT 1),
      'published',
      'Rastro de objetos curiosos y coleccionismo.',
      'center');

INSERT INTO public.events (id, title, place, maps_url, image_url, is_featured, is_free, starts_at, city_id, category_id, status, description, image_alignment) VALUES (
      '2e9901f7-1a27-484a-b319-8c8071791a58',
      'Senderismo: Subida al Picacho',
      'Inicio Área Recreativa El Picacho',
      'https://www.google.com/maps/search/?api=1&query=Area+Recreativa+El+Picacho',
      'https://oudofaiekedtaovrdqeo.supabase.co/storage/v1/object/public/sample-images/1/5/02.webp',
      FALSE,
      TRUE,
      '2026-02-07T10:00:00Z'::timestamptz,
      (SELECT id FROM public.cities WHERE LOWER(name) = LOWER('') LIMIT 1),
      (SELECT id FROM public.categories WHERE LOWER(slug) = 'aire-libre' LIMIT 1),
      'published',
      'Ruta de nivel medio por el Parque Natural de los Alcornocales.',
      'center');

INSERT INTO public.events (id, title, place, maps_url, image_url, is_featured, is_free, starts_at, city_id, category_id, status, description, image_alignment) VALUES (
      'e7ddae77-b930-4b81-b1a9-089994366b50',
      'Carnaval Chiclana: Cabalgata',
      'Centro de Chiclana',
      'https://www.google.com/maps/search/?api=1&query=Ayuntamiento+Chiclana',
      'https://oudofaiekedtaovrdqeo.supabase.co/storage/v1/object/public/sample-images/1/6/06.webp',
      FALSE,
      TRUE,
      '2026-02-15T12:00:00Z'::timestamptz,
      (SELECT id FROM public.cities WHERE LOWER(name) = LOWER('Chiclana de la Frontera') LIMIT 1),
      (SELECT id FROM public.categories WHERE LOWER(slug) = 'tradiciones' LIMIT 1),
      'published',
      'Desfile de carrozas y agrupaciones por el centro de la ciudad.',
      'center');

INSERT INTO public.events (id, title, place, maps_url, image_url, is_featured, is_free, starts_at, city_id, category_id, status, description, image_alignment) VALUES (
      'dd4da6b5-561b-4a1c-b39f-8fe89232929b',
      'Pringá Popular (Chiclana)',
      'Peña Carnavalesca Perico Alcántara',
      'https://www.google.com/maps/search/?api=1&query=Peña+Perico+Alcantara+Chiclana',
      'https://oudofaiekedtaovrdqeo.supabase.co/storage/v1/object/public/sample-images/1/2/05.webp',
      FALSE,
      TRUE,
      '2026-02-15T13:00:00Z'::timestamptz,
      (SELECT id FROM public.cities WHERE LOWER(name) = LOWER('') LIMIT 1),
      (SELECT id FROM public.categories WHERE LOWER(slug) = 'gastronomia' LIMIT 1),
      'published',
      'Degustación de montaditos de pringá con ambiente de carnaval.',
      'center');

INSERT INTO public.events (id, title, place, maps_url, image_url, is_featured, is_free, starts_at, city_id, category_id, status, description, image_alignment) VALUES (
      'f178dfa6-20f5-4bf1-a9e3-3723116c36ee',
      'Romanceros en la calle',
      'Barrio del Pópulo, Cádiz',
      'https://www.google.com/maps/search/?api=1&query=Barrio+del+Populo+Cadiz',
      'https://oudofaiekedtaovrdqeo.supabase.co/storage/v1/object/public/sample-images/1/6/07.webp',
      FALSE,
      TRUE,
      '2026-02-21T12:00:00Z'::timestamptz,
      (SELECT id FROM public.cities WHERE LOWER(name) = LOWER('Cádiz') LIMIT 1),
      (SELECT id FROM public.categories WHERE LOWER(slug) = 'tradiciones' LIMIT 1),
      'published',
      'Certamen callejero de romanceros por los rincones del Pópulo.',
      'center');

INSERT INTO public.events (id, title, place, maps_url, image_url, is_featured, is_free, starts_at, city_id, category_id, status, description, image_alignment) VALUES (
      '156ab13e-a171-4925-b6de-480e6716a3a6',
      'Noche de DJs: Carnaval Techno',
      'Sala Soho, Cádiz',
      'https://www.google.com/maps/search/?api=1&query=Sala+Soho+Cadiz',
      'https://oudofaiekedtaovrdqeo.supabase.co/storage/v1/object/public/sample-images/1/1/09.webp',
      FALSE,
      FALSE,
      '2026-02-21T23:00:00Z'::timestamptz,
      (SELECT id FROM public.cities WHERE LOWER(name) = LOWER('Cádiz') LIMIT 1),
      (SELECT id FROM public.categories WHERE LOWER(slug) = 'musica' LIMIT 1),
      'published',
      'Sesión especial de música electrónica con disfraces.',
      'center');

INSERT INTO public.events (id, title, place, maps_url, image_url, is_featured, is_free, starts_at, city_id, category_id, status, description, image_alignment) VALUES (
      'a313e62f-af00-4316-8353-45283c1162cd',
      'Tortillada Popular de Camarones',
      'Plaza de la Catedral, Cádiz',
      'https://www.google.com/maps/search/?api=1&query=Plaza+Catedral+Cadiz',
      'https://oudofaiekedtaovrdqeo.supabase.co/storage/v1/object/public/sample-images/1/2/06.webp',
      FALSE,
      TRUE,
      '2026-02-22T13:00:00Z'::timestamptz,
      (SELECT id FROM public.cities WHERE LOWER(name) = LOWER('Cádiz') LIMIT 1),
      (SELECT id FROM public.categories WHERE LOWER(slug) = 'gastronomia' LIMIT 1),
      'published',
      'Degustación del plato típico en el domingo de piñata.',
      'center');

INSERT INTO public.events (id, title, place, maps_url, image_url, is_featured, is_free, starts_at, city_id, category_id, status, description, image_alignment) VALUES (
      '9ca75590-1f10-4e4e-afed-21c7cb66155a',
      'Fútbol Femenino: Cádiz CF vs Málaga CF',
      'Ciudad Deportiva El Rosal',
      'https://www.google.com/maps/search/?api=1&query=Ciudad+Deportiva+Bahia+de+Cadiz',
      'https://oudofaiekedtaovrdqeo.supabase.co/storage/v1/object/public/sample-images/1/3/16.webp',
      FALSE,
      TRUE,
      '2026-02-27T18:00:00Z'::timestamptz,
      (SELECT id FROM public.cities WHERE LOWER(name) = LOWER('') LIMIT 1),
      (SELECT id FROM public.categories WHERE LOWER(slug) = 'deportes' LIMIT 1),
      'published',
      'Partido de liga de la cantera femenina.',
      'center');

INSERT INTO public.events (id, title, place, maps_url, image_url, is_featured, is_free, starts_at, city_id, category_id, status, description, image_alignment) VALUES (
      '156fe74b-6181-4751-9eb2-1a30a40fab9b',
      'Musical: Las Guerreras K-Pop',
      'Teatro Principal, Puerto Real',
      'https://www.google.com/maps/search/?api=1&query=Teatro+Principal+Puerto+Real',
      'https://oudofaiekedtaovrdqeo.supabase.co/storage/v1/object/public/sample-images/1/1/10.webp',
      FALSE,
      FALSE,
      '2026-01-16T16:30:00Z'::timestamptz,
      (SELECT id FROM public.cities WHERE LOWER(name) = LOWER('Puerto Real') LIMIT 1),
      (SELECT id FROM public.categories WHERE LOWER(slug) = 'musica' LIMIT 1),
      'published',
      'Tributo musical familiar en el Teatro Principal.',
      'center');

INSERT INTO public.events (id, title, place, maps_url, image_url, is_featured, is_free, starts_at, city_id, category_id, status, description, image_alignment) VALUES (
      '5cd4ca54-d2c5-4c7a-b7b5-d7c6e78f388f',
      'Monólogo: José Luis Calero',
      'Auditorio Municipal Rota',
      'https://www.google.com/maps/search/?api=1&query=Auditorio+Municipal+Rota',
      'https://oudofaiekedtaovrdqeo.supabase.co/storage/v1/object/public/sample-images/1/4/06.webp',
      FALSE,
      FALSE,
      '2026-01-17T20:00:00Z'::timestamptz,
      (SELECT id FROM public.cities WHERE LOWER(name) = LOWER('') LIMIT 1),
      (SELECT id FROM public.categories WHERE LOWER(slug) = 'arte-y-cultura' LIMIT 1),
      'published',
      'Show ''Humorista de Guardia'' en el auditorio.',
      'center');

INSERT INTO public.events (id, title, place, maps_url, image_url, is_featured, is_free, starts_at, city_id, category_id, status, description, image_alignment) VALUES (
      '28240b9a-776d-454a-a870-c237c659d175',
      'David Navarro: Humor en Algeciras',
      'Teatro Florida, Algeciras',
      'https://www.google.com/maps/search/?api=1&query=Teatro+Florida+Algeciras',
      'https://oudofaiekedtaovrdqeo.supabase.co/storage/v1/object/public/sample-images/1/4/07.webp',
      FALSE,
      FALSE,
      '2026-01-17T21:00:00Z'::timestamptz,
      (SELECT id FROM public.cities WHERE LOWER(name) = LOWER('Algeciras') LIMIT 1),
      (SELECT id FROM public.categories WHERE LOWER(slug) = 'arte-y-cultura' LIMIT 1),
      'published',
      'Monólogo cómico del actor de ''La que se avecina''.',
      'center');

INSERT INTO public.events (id, title, place, maps_url, image_url, is_featured, is_free, starts_at, city_id, category_id, status, description, image_alignment) VALUES (
      '2c8aedf2-2fe6-4a49-af8d-e82ab8d00dab',
      'Arroz de Convivencia: Día de Andalucía',
      'Plaza del Ayuntamiento, Benalup',
      'https://www.google.com/maps/search/?api=1&query=Ayuntamiento+Benalup+Casas+Viejas',
      'https://oudofaiekedtaovrdqeo.supabase.co/storage/v1/object/public/sample-images/1/2/07.webp',
      FALSE,
      TRUE,
      '2026-02-28T14:00:00Z'::timestamptz,
      (SELECT id FROM public.cities WHERE LOWER(name) = LOWER('') LIMIT 1),
      (SELECT id FROM public.categories WHERE LOWER(slug) = 'gastronomia' LIMIT 1),
      'published',
      'Jornada gastronómica gratuita para los vecinos.',
      'center');

INSERT INTO public.events (id, title, place, maps_url, image_url, is_featured, is_free, starts_at, city_id, category_id, status, description, image_alignment) VALUES (
      '07d64e67-2e9d-4004-ae56-b0a69f21a9c4',
      'Mercado de Artesanía de Carnaval',
      'Plaza de las Flores, Cádiz',
      'https://www.google.com/maps/search/?api=1&query=Plaza+de+las+Flores+Cadiz',
      'https://oudofaiekedtaovrdqeo.supabase.co/storage/v1/object/public/sample-images/1/7/04.webp',
      FALSE,
      TRUE,
      '2026-02-14T12:00:00Z'::timestamptz,
      (SELECT id FROM public.cities WHERE LOWER(name) = LOWER('Cádiz') LIMIT 1),
      (SELECT id FROM public.categories WHERE LOWER(slug) = 'mercadillos' LIMIT 1),
      'published',
      'Puestos de artesanos locales con temática de disfraces y cuero.',
      'center');

INSERT INTO public.events (id, title, place, maps_url, image_url, is_featured, is_free, starts_at, city_id, category_id, status, description, image_alignment) VALUES (
      '976bb53a-867f-4f4d-890e-86cf4542c95c',
      'CSI4* Sunshine Tour - Qualifying',
      'Montenmedio, Vejer',
      'https://www.google.com/maps/search/?api=1&query=Dehesa+Montenmedio+Vejer',
      'https://oudofaiekedtaovrdqeo.supabase.co/storage/v1/object/public/sample-images/1/3/01.webp',
      FALSE,
      TRUE,
      '2026-02-10T11:00:00Z'::timestamptz,
      (SELECT id FROM public.cities WHERE LOWER(name) = LOWER('Vejer de la Frontera') LIMIT 1),
      (SELECT id FROM public.categories WHERE LOWER(slug) = 'deportes' LIMIT 1),
      'published',
      'Pruebas de velocidad y manejo en pista de hierba.',
      'center');

INSERT INTO public.events (id, title, place, maps_url, image_url, is_featured, is_free, starts_at, city_id, category_id, status, description, image_alignment) VALUES (
      '1eff1eb5-e661-479b-b88d-e53c48f206d9',
      'CSI4* Sunshine Tour - Young Horses',
      'Montenmedio, Vejer',
      'https://www.google.com/maps/search/?api=1&query=Dehesa+Montenmedio+Vejer',
      'https://oudofaiekedtaovrdqeo.supabase.co/storage/v1/object/public/sample-images/1/3/02.webp',
      FALSE,
      TRUE,
      '2026-02-11T11:00:00Z'::timestamptz,
      (SELECT id FROM public.cities WHERE LOWER(name) = LOWER('Vejer de la Frontera') LIMIT 1),
      (SELECT id FROM public.categories WHERE LOWER(slug) = 'deportes' LIMIT 1),
      'published',
      'Competición de caballos de 6 años.',
      'center');

INSERT INTO public.events (id, title, place, maps_url, image_url, is_featured, is_free, starts_at, city_id, category_id, status, description, image_alignment) VALUES (
      '40355a09-500b-4507-9daa-7913acf1c6df',
      'CSI4* Sunshine Tour - Medium Tour',
      'Montenmedio, Vejer',
      'https://www.google.com/maps/search/?api=1&query=Dehesa+Montenmedio+Vejer',
      'https://oudofaiekedtaovrdqeo.supabase.co/storage/v1/object/public/sample-images/1/3/03.webp',
      FALSE,
      TRUE,
      '2026-02-12T11:00:00Z'::timestamptz,
      (SELECT id FROM public.cities WHERE LOWER(name) = LOWER('Vejer de la Frontera') LIMIT 1),
      (SELECT id FROM public.categories WHERE LOWER(slug) = 'deportes' LIMIT 1),
      'published',
      'Pruebas de 1.40m de altura.',
      'center');

INSERT INTO public.events (id, title, place, maps_url, image_url, is_featured, is_free, starts_at, city_id, category_id, status, description, image_alignment) VALUES (
      '3bcdbac9-ca14-4828-ad15-66f8b9acde87',
      'Sunshine Tour - Grand Prix CSI4*',
      'Montenmedio, Vejer',
      'https://www.google.com/maps/search/?api=1&query=Dehesa+Montenmedio+Vejer',
      'https://oudofaiekedtaovrdqeo.supabase.co/storage/v1/object/public/sample-images/1/3/04.webp',
      FALSE,
      TRUE,
      '2026-02-22T11:00:00Z'::timestamptz,
      (SELECT id FROM public.cities WHERE LOWER(name) = LOWER('Vejer de la Frontera') LIMIT 1),
      (SELECT id FROM public.categories WHERE LOWER(slug) = 'deportes' LIMIT 1),
      'published',
      'La prueba reina de la semana 3. Saltos de 1.55m.',
      'center');

INSERT INTO public.events (id, title, place, maps_url, image_url, is_featured, is_free, starts_at, city_id, category_id, status, description, image_alignment) VALUES (
      '1fb24bae-3afe-4ba8-8009-5881314ca495',
      'Sunshine Tour - Descanso y Revisión Veterinaria',
      'Montenmedio, Vejer',
      'https://www.google.com/maps/search/?api=1&query=Dehesa+Montenmedio+Vejer',
      'https://oudofaiekedtaovrdqeo.supabase.co/storage/v1/object/public/sample-images/1/3/05.webp',
      FALSE,
      TRUE,
      '2026-02-23T11:00:00Z'::timestamptz,
      (SELECT id FROM public.cities WHERE LOWER(name) = LOWER('Vejer de la Frontera') LIMIT 1),
      (SELECT id FROM public.categories WHERE LOWER(slug) = 'deportes' LIMIT 1),
      'published',
      'Día de puertas abiertas para ver los establos y zona comercial.',
      'center');

INSERT INTO public.events (id, title, place, maps_url, image_url, is_featured, is_free, starts_at, city_id, category_id, status, description, image_alignment) VALUES (
      'f747322a-8755-452d-85ea-3940cafd47f3',
      'Sunshine Tour - Semana Andalucía (Inicio)',
      'Montenmedio, Vejer',
      'https://www.google.com/maps/search/?api=1&query=Dehesa+Montenmedio+Vejer',
      'https://oudofaiekedtaovrdqeo.supabase.co/storage/v1/object/public/sample-images/1/3/06.webp',
      FALSE,
      TRUE,
      '2026-02-24T11:00:00Z'::timestamptz,
      (SELECT id FROM public.cities WHERE LOWER(name) = LOWER('Vejer de la Frontera') LIMIT 1),
      (SELECT id FROM public.categories WHERE LOWER(slug) = 'deportes' LIMIT 1),
      'published',
      'Pruebas para caballos jóvenes en la semana festiva.',
      'center');

INSERT INTO public.events (id, title, place, maps_url, image_url, is_featured, is_free, starts_at, city_id, category_id, status, description, image_alignment) VALUES (
      '1d67a99f-5382-48b6-b8d2-4b139d2600fb',
      'Sunshine Tour - Semana Andalucía (CSI2*)',
      'Montenmedio, Vejer',
      'https://www.google.com/maps/search/?api=1&query=Dehesa+Montenmedio+Vejer',
      'https://oudofaiekedtaovrdqeo.supabase.co/storage/v1/object/public/sample-images/1/3/07.webp',
      FALSE,
      TRUE,
      '2026-02-25T11:00:00Z'::timestamptz,
      (SELECT id FROM public.cities WHERE LOWER(name) = LOWER('Vejer de la Frontera') LIMIT 1),
      (SELECT id FROM public.categories WHERE LOWER(slug) = 'deportes' LIMIT 1),
      'published',
      'Competición internacional de saltos.',
      'center');

INSERT INTO public.events (id, title, place, maps_url, image_url, is_featured, is_free, starts_at, city_id, category_id, status, description, image_alignment) VALUES (
      '5af8b250-fcfc-4314-82f8-0d1645bf1ca6',
      'Sunshine Tour - Semana Andalucía (YH)',
      'Montenmedio, Vejer',
      'https://www.google.com/maps/search/?api=1&query=Dehesa+Montenmedio+Vejer',
      'https://oudofaiekedtaovrdqeo.supabase.co/storage/v1/object/public/sample-images/1/3/08.webp',
      FALSE,
      TRUE,
      '2026-02-26T11:00:00Z'::timestamptz,
      (SELECT id FROM public.cities WHERE LOWER(name) = LOWER('Vejer de la Frontera') LIMIT 1),
      (SELECT id FROM public.categories WHERE LOWER(slug) = 'deportes' LIMIT 1),
      'published',
      'Finales semanales para caballos de 5 años.',
      'center');

INSERT INTO public.events (id, title, place, maps_url, image_url, is_featured, is_free, starts_at, city_id, category_id, status, description, image_alignment) VALUES (
      '3da3a2c1-d734-43fa-aa13-8e145fe7fbb3',
      'Sunshine Tour - Semana Andalucía (Clasificación GP)',
      'Montenmedio, Vejer',
      'https://www.google.com/maps/search/?api=1&query=Dehesa+Montenmedio+Vejer',
      'https://oudofaiekedtaovrdqeo.supabase.co/storage/v1/object/public/sample-images/1/3/09.webp',
      FALSE,
      TRUE,
      '2026-02-27T11:00:00Z'::timestamptz,
      (SELECT id FROM public.cities WHERE LOWER(name) = LOWER('Vejer de la Frontera') LIMIT 1),
      (SELECT id FROM public.categories WHERE LOWER(slug) = 'deportes' LIMIT 1),
      'published',
      'Víspera del día grande con las mejores montas mundiales.',
      'center');

INSERT INTO public.events (id, title, place, maps_url, image_url, is_featured, is_free, starts_at, city_id, category_id, status, description, image_alignment) VALUES (
      '07d9fcf7-c2bd-4147-80cc-0f95dc0b661c',
      'Fútbol Alevín: Cádiz CF vs Divina Pastora',
      'Ciudad Deportiva Puerto Real',
      'https://www.google.com/maps/search/?api=1&query=Ciudad+Deportiva+Bahia+de+Cadiz',
      'https://oudofaiekedtaovrdqeo.supabase.co/storage/v1/object/public/sample-images/1/3/10.webp',
      FALSE,
      TRUE,
      '2026-01-24T10:30:00Z'::timestamptz,
      (SELECT id FROM public.cities WHERE LOWER(name) = LOWER('Puerto Real') LIMIT 1),
      (SELECT id FROM public.categories WHERE LOWER(slug) = 'deportes' LIMIT 1),
      'published',
      'Liga provincial alevín en las instalaciones del Rosal.',
      'center');

INSERT INTO public.events (id, title, place, maps_url, image_url, is_featured, is_free, starts_at, city_id, category_id, status, description, image_alignment) VALUES (
      '8a577b69-ea1e-46ae-8817-db5fe7f77a2e',
      'Lectura Dramatizada: ''Incendios''',
      'Biblioteca Provincial Cádiz',
      'https://www.google.com/maps/search/?api=1&query=Biblioteca+Publica+Provincial+Cadiz',
      'https://oudofaiekedtaovrdqeo.supabase.co/storage/v1/object/public/sample-images/1/4/08.webp',
      FALSE,
      TRUE,
      '2026-01-12T18:30:00Z'::timestamptz,
      (SELECT id FROM public.cities WHERE LOWER(name) = LOWER('Cádiz') LIMIT 1),
      (SELECT id FROM public.categories WHERE LOWER(slug) = 'arte-y-cultura' LIMIT 1),
      'published',
      'Actividad cultural en la biblioteca pública.',
      'center');

INSERT INTO public.events (id, title, place, maps_url, image_url, is_featured, is_free, starts_at, city_id, category_id, status, description, image_alignment) VALUES (
      'b124e67a-0866-4e0d-8b30-9800cea26c79',
      'Magic Fest: Gala Inaugural',
      'Teatro Juan Luis Galiardo',
      'https://www.google.com/maps/search/?api=1&query=Teatro+Juan+Luis+Galiardo+San+Roque',
      'https://oudofaiekedtaovrdqeo.supabase.co/storage/v1/object/public/sample-images/1/4/09.webp',
      FALSE,
      FALSE,
      '2026-01-12T20:00:00Z'::timestamptz,
      (SELECT id FROM public.cities WHERE LOWER(name) = LOWER('') LIMIT 1),
      (SELECT id FROM public.categories WHERE LOWER(slug) = 'arte-y-cultura' LIMIT 1),
      'published',
      'Apertura del festival de magia de San Roque.',
      'center');

INSERT INTO public.events (id, title, place, maps_url, image_url, is_featured, is_free, starts_at, city_id, category_id, status, description, image_alignment) VALUES (
      'b10f1b93-cfff-42a0-ae09-8b31118bfc01',
      'Encuentro Amigos de la Biblioteca',
      'Biblioteca Municipal San Roque',
      'https://www.google.com/maps/search/?api=1&query=Biblioteca+Municipal+San+Roque',
      'https://oudofaiekedtaovrdqeo.supabase.co/storage/v1/object/public/sample-images/1/4/01.webp',
      FALSE,
      TRUE,
      '2026-01-13T18:30:00Z'::timestamptz,
      (SELECT id FROM public.cities WHERE LOWER(name) = LOWER('') LIMIT 1),
      (SELECT id FROM public.categories WHERE LOWER(slug) = 'arte-y-cultura' LIMIT 1),
      'published',
      'Reunión literaria abierta al público.',
      'center');

INSERT INTO public.events (id, title, place, maps_url, image_url, is_featured, is_free, starts_at, city_id, category_id, status, description, image_alignment) VALUES (
      '96fa3500-c536-4c45-8c9b-91c49794d81b',
      'Magic Fest: Magia Infantil',
      'Teatro Juan Luis Galiardo',
      'https://www.google.com/maps/search/?api=1&query=Teatro+Juan+Luis+Galiardo+San+Roque',
      'https://oudofaiekedtaovrdqeo.supabase.co/storage/v1/object/public/sample-images/1/4/02.webp',
      FALSE,
      FALSE,
      '2026-01-18T12:00:00Z'::timestamptz,
      (SELECT id FROM public.cities WHERE LOWER(name) = LOWER('') LIMIT 1),
      (SELECT id FROM public.categories WHERE LOWER(slug) = 'arte-y-cultura' LIMIT 1),
      'published',
      'Espectáculo diseñado para niños y familias.',
      'center');

INSERT INTO public.events (id, title, place, maps_url, image_url, is_featured, is_free, starts_at, city_id, category_id, status, description, image_alignment) VALUES (
      '0ec35852-7e32-4b5c-a507-3142cdf6b7fc',
      'Romería de San Sebastián',
      'Pinares de El Colorado, Conil',
      'https://www.google.com/maps/search/?api=1&query=Pinares+de+El+Colorado+Conil',
      'https://oudofaiekedtaovrdqeo.supabase.co/storage/v1/object/public/sample-images/1/6/08.webp',
      FALSE,
      TRUE,
      '2026-01-18T10:00:00Z'::timestamptz,
      (SELECT id FROM public.cities WHERE LOWER(name) = LOWER('Conil de la Frontera') LIMIT 1),
      (SELECT id FROM public.categories WHERE LOWER(slug) = 'tradiciones' LIMIT 1),
      'published',
      'Tradicional jornada campestre en los pinares.',
      'center');

INSERT INTO public.events (id, title, place, maps_url, image_url, is_featured, is_free, starts_at, city_id, category_id, status, description, image_alignment) VALUES (
      '8b7bc5c6-7011-423e-9937-1c1192acebe0',
      'Homenaje a Robe Iniesta',
      'Sala La Báskula, Cádiz',
      'https://www.google.com/maps/search/?api=1&query=Sala+La+Baskula+Cadiz',
      'https://oudofaiekedtaovrdqeo.supabase.co/storage/v1/object/public/sample-images/1/1/01.webp',
      FALSE,
      TRUE,
      '2026-01-23T20:00:00Z'::timestamptz,
      (SELECT id FROM public.cities WHERE LOWER(name) = LOWER('Cádiz') LIMIT 1),
      (SELECT id FROM public.categories WHERE LOWER(slug) = 'musica' LIMIT 1),
      'published',
      'Concierto tributo a Extremoduro.',
      'center');

INSERT INTO public.events (id, title, place, maps_url, image_url, is_featured, is_free, starts_at, city_id, category_id, status, description, image_alignment) VALUES (
      '59f4e91d-02c3-44d2-936e-70848d1666b4',
      'Concierto: María Parrado',
      'Teatro Moderno Chiclana',
      'https://www.google.com/maps/search/?api=1&query=Teatro+Moderno+Chiclana',
      'https://oudofaiekedtaovrdqeo.supabase.co/storage/v1/object/public/sample-images/1/1/02.webp',
      FALSE,
      FALSE,
      '2026-01-23T20:00:00Z'::timestamptz,
      (SELECT id FROM public.cities WHERE LOWER(name) = LOWER('Chiclana de la Frontera') LIMIT 1),
      (SELECT id FROM public.categories WHERE LOWER(slug) = 'musica' LIMIT 1),
      'published',
      'Presentación del álbum ''La niña que fui''.',
      'center');

INSERT INTO public.events (id, title, place, maps_url, image_url, is_featured, is_free, starts_at, city_id, category_id, status, description, image_alignment) VALUES (
      'fc4cee31-76ad-4ad8-a1bf-933ea802c89a',
      'Ópera: I Tre Gobbi',
      'Teatro Villamarta, Jerez',
      'https://www.google.com/maps/search/?api=1&query=Teatro+Villamarta+Jerez',
      'https://oudofaiekedtaovrdqeo.supabase.co/storage/v1/object/public/sample-images/1/4/03.webp',
      FALSE,
      FALSE,
      '2026-01-24T20:00:00Z'::timestamptz,
      (SELECT id FROM public.cities WHERE LOWER(name) = LOWER('Jerez de la Frontera') LIMIT 1),
      (SELECT id FROM public.categories WHERE LOWER(slug) = 'arte-y-cultura' LIMIT 1),
      'published',
      'Recuperación de ópera histórica andaluza.',
      'center');

INSERT INTO public.events (id, title, place, maps_url, image_url, is_featured, is_free, starts_at, city_id, category_id, status, description, image_alignment) VALUES (
      'ff78d6a1-9749-422e-a1a2-6934549ed421',
      'I Certamen Nacional de Coplas',
      'Teatro Galiardo, San Roque',
      'https://www.google.com/maps/search/?api=1&query=Teatro+Juan+Luis+Galiardo+San+Roque',
      'https://oudofaiekedtaovrdqeo.supabase.co/storage/v1/object/public/sample-images/1/6/09.webp',
      FALSE,
      FALSE,
      '2026-01-24T20:30:00Z'::timestamptz,
      (SELECT id FROM public.cities WHERE LOWER(name) = LOWER('') LIMIT 1),
      (SELECT id FROM public.categories WHERE LOWER(slug) = 'tradiciones' LIMIT 1),
      'published',
      'Concurso de agrupaciones de carnaval foráneas.',
      'center');

INSERT INTO public.events (id, title, place, maps_url, image_url, is_featured, is_free, starts_at, city_id, category_id, status, description, image_alignment) VALUES (
      '11fbc48d-2673-4767-b226-79656fb5d637',
      'Tributo Dire Straits: Alchemy Project',
      'Palacio de Congresos Algeciras',
      'https://www.google.com/maps/search/?api=1&query=Algeciras',
      'https://oudofaiekedtaovrdqeo.supabase.co/storage/v1/object/public/sample-images/1/1/03.webp',
      FALSE,
      FALSE,
      '2026-01-24T21:00:00Z'::timestamptz,
      (SELECT id FROM public.cities WHERE LOWER(name) = LOWER('Algeciras') LIMIT 1),
      (SELECT id FROM public.categories WHERE LOWER(slug) = 'musica' LIMIT 1),
      'published',
      'Homenaje musical a la mítica banda británica.',
      'center');

INSERT INTO public.events (id, title, place, maps_url, image_url, is_featured, is_free, starts_at, city_id, category_id, status, description, image_alignment) VALUES (
      '0ee6495f-e745-4e9f-9d0f-4464f44740ae',
      'VI Ruta MTB Barbate',
      'Barbate Centro',
      'https://www.google.com/maps/search/?api=1&query=Barbate',
      'https://oudofaiekedtaovrdqeo.supabase.co/storage/v1/object/public/sample-images/1/3/11.webp',
      FALSE,
      FALSE,
      '2026-01-25T09:00:00Z'::timestamptz,
      (SELECT id FROM public.cities WHERE LOWER(name) = LOWER('Barbate') LIMIT 1),
      (SELECT id FROM public.categories WHERE LOWER(slug) = 'deportes' LIMIT 1),
      'published',
      'Ruta cicloturista por el parque natural de La Breña.',
      'center');

INSERT INTO public.events (id, title, place, maps_url, image_url, is_featured, is_free, starts_at, city_id, category_id, status, description, image_alignment) VALUES (
      '1b338f4b-0440-44fa-ab8a-00ab19180996',
      'Noche de Jazz: The Chameleons',
      'El Musicario, Cádiz',
      'https://www.google.com/maps/search/?api=1&query=El+Musicario+Cadiz',
      'https://oudofaiekedtaovrdqeo.supabase.co/storage/v1/object/public/sample-images/1/1/04.webp',
      FALSE,
      TRUE,
      '2026-02-14T21:00:00Z'::timestamptz,
      (SELECT id FROM public.cities WHERE LOWER(name) = LOWER('Cádiz') LIMIT 1),
      (SELECT id FROM public.categories WHERE LOWER(slug) = 'musica' LIMIT 1),
      'published',
      'Jazz fusión en directo en el barrio del Pópulo.',
      'center');

INSERT INTO public.events (id, title, place, maps_url, image_url, is_featured, is_free, starts_at, city_id, category_id, status, description, image_alignment) VALUES (
      '37b115a5-e75b-4621-9de1-d104a85613b2',
      'Fiesta Enamorados Anti-San Valentín',
      'Sala Bereber, Jerez',
      'https://www.google.com/maps/search/?api=1&query=Sala+Bereber+Jerez',
      'https://oudofaiekedtaovrdqeo.supabase.co/storage/v1/object/public/sample-images/1/1/05.webp',
      FALSE,
      FALSE,
      '2026-02-14T23:00:00Z'::timestamptz,
      (SELECT id FROM public.cities WHERE LOWER(name) = LOWER('Jerez de la Frontera') LIMIT 1),
      (SELECT id FROM public.categories WHERE LOWER(slug) = 'musica' LIMIT 1),
      'published',
      'Sesión especial con disfraces y música comercial.',
      'center');

INSERT INTO public.events (id, title, place, maps_url, image_url, is_featured, is_free, starts_at, city_id, category_id, status, description, image_alignment) VALUES (
      '132ab26c-9cbe-4219-a6a5-e2fcf0865842',
      'Cádiz CF Juvenil vs Tomares',
      'El Rosal, Puerto Real',
      'https://www.google.com/maps/search/?api=1&query=Ciudad+Deportiva+Bahia+de+Cadiz',
      'https://oudofaiekedtaovrdqeo.supabase.co/storage/v1/object/public/sample-images/1/3/12.webp',
      FALSE,
      TRUE,
      '2026-02-15T12:00:00Z'::timestamptz,
      (SELECT id FROM public.cities WHERE LOWER(name) = LOWER('Puerto Real') LIMIT 1),
      (SELECT id FROM public.categories WHERE LOWER(slug) = 'deportes' LIMIT 1),
      'published',
      'División de Honor Juvenil.',
      'center');

INSERT INTO public.events (id, title, place, maps_url, image_url, is_featured, is_free, starts_at, city_id, category_id, status, description, image_alignment) VALUES (
      '6e0c6263-abff-40f2-b1fb-e678d1f05108',
      'Flamenco Off Festival: Agujetas Chico',
      'La Guarida del Ángel, Jerez',
      'https://www.google.com/maps/search/?api=1&query=La+Guarida+del+Angel+Jerez',
      'https://oudofaiekedtaovrdqeo.supabase.co/storage/v1/object/public/sample-images/1/1/06.webp',
      FALSE,
      FALSE,
      '2026-02-20T22:00:00Z'::timestamptz,
      (SELECT id FROM public.cities WHERE LOWER(name) = LOWER('Jerez de la Frontera') LIMIT 1),
      (SELECT id FROM public.categories WHERE LOWER(slug) = 'musica' LIMIT 1),
      'published',
      'Cante gitano en estado puro.',
      'center');

INSERT INTO public.events (id, title, place, maps_url, image_url, is_featured, is_free, starts_at, city_id, category_id, status, description, image_alignment) VALUES (
      '6648f29a-23cc-44c7-8f4f-b4ddb2686eca',
      'Festival de Jerez: Gala de Baile',
      'Teatro Villamarta',
      'https://www.google.com/maps/search/?api=1&query=Teatro+Villamarta+Jerez',
      'https://oudofaiekedtaovrdqeo.supabase.co/storage/v1/object/public/sample-images/1/4/04.webp',
      FALSE,
      FALSE,
      '2026-02-23T20:30:00Z'::timestamptz,
      (SELECT id FROM public.cities WHERE LOWER(name) = LOWER('') LIMIT 1),
      (SELECT id FROM public.categories WHERE LOWER(slug) = 'arte-y-cultura' LIMIT 1),
      'published',
      'Espectáculo central en el Teatro Villamarta.',
      'center');

INSERT INTO public.events (id, title, place, maps_url, image_url, is_featured, is_free, starts_at, city_id, category_id, status, description, image_alignment) VALUES (
      '7d41ad53-64d8-4b8b-a073-10b0734d9b58',
      'Festival de Jerez: Cante de Mujer',
      'Palacio Villavicencio, Jerez',
      'https://www.google.com/maps/search/?api=1&query=Alcazar+Jerez',
      'https://oudofaiekedtaovrdqeo.supabase.co/storage/v1/object/public/sample-images/1/4/05.webp',
      FALSE,
      FALSE,
      '2026-02-24T20:30:00Z'::timestamptz,
      (SELECT id FROM public.cities WHERE LOWER(name) = LOWER('Jerez de la Frontera') LIMIT 1),
      (SELECT id FROM public.categories WHERE LOWER(slug) = 'arte-y-cultura' LIMIT 1),
      'published',
      'Recital lírico flamenco.',
      'center');

INSERT INTO public.events (id, title, place, maps_url, image_url, is_featured, is_free, starts_at, city_id, category_id, status, description, image_alignment) VALUES (
      '8d5f5036-a9ee-4d51-924a-82e8570af254',
      'Festival de Jerez: Jóvenes Talentos',
      'Sala Compañía, Jerez',
      'https://www.google.com/maps/search/?api=1&query=Sala+Compania+Jerez',
      'https://oudofaiekedtaovrdqeo.supabase.co/storage/v1/object/public/sample-images/1/4/06.webp',
      FALSE,
      FALSE,
      '2026-02-25T21:00:00Z'::timestamptz,
      (SELECT id FROM public.cities WHERE LOWER(name) = LOWER('Jerez de la Frontera') LIMIT 1),
      (SELECT id FROM public.categories WHERE LOWER(slug) = 'arte-y-cultura' LIMIT 1),
      'published',
      'Muestra de baile de nuevos valores.',
      'center');

INSERT INTO public.events (id, title, place, maps_url, image_url, is_featured, is_free, starts_at, city_id, category_id, status, description, image_alignment) VALUES (
      '519aff98-84b3-43c2-a4a2-784eae2cd6e4',
      'Festival de Jerez: Estreno Absoluto',
      'Teatro Villamarta, Jerez',
      'https://www.google.com/maps/search/?api=1&query=Teatro+Villamarta+Jerez',
      'https://oudofaiekedtaovrdqeo.supabase.co/storage/v1/object/public/sample-images/1/4/07.webp',
      FALSE,
      FALSE,
      '2026-02-26T20:30:00Z'::timestamptz,
      (SELECT id FROM public.cities WHERE LOWER(name) = LOWER('Jerez de la Frontera') LIMIT 1),
      (SELECT id FROM public.categories WHERE LOWER(slug) = 'arte-y-cultura' LIMIT 1),
      'published',
      'Gran producción de baile flamenco.',
      'center');

INSERT INTO public.events (id, title, place, maps_url, image_url, is_featured, is_free, starts_at, city_id, category_id, status, description, image_alignment) VALUES (
      'e6d1b1fe-2234-4f82-ab61-d3a225205df4',
      'Ruta Flora y Fauna: Parque de los Toruños',
      'Parque Los Toruños',
      'https://www.google.com/maps/search/?api=1&query=Casa+de+los+Torunos',
      'https://oudofaiekedtaovrdqeo.supabase.co/storage/v1/object/public/sample-images/1/5/03.webp',
      FALSE,
      TRUE,
      '2026-02-27T12:00:00Z'::timestamptz,
      (SELECT id FROM public.cities WHERE LOWER(name) = LOWER('') LIMIT 1),
      (SELECT id FROM public.categories WHERE LOWER(slug) = 'aire-libre' LIMIT 1),
      'published',
      'Paseo interpretativo gratuito por las dunas.',
      'center');

INSERT INTO public.events (id, title, place, maps_url, image_url, is_featured, is_free, starts_at, city_id, category_id, status, description, image_alignment) VALUES (
      'ab7914cb-774e-457e-9db6-c6bf0a52b00a',
      'Festival de Jerez: Cante Jondo',
      'Bodegas Los Apóstoles',
      'https://www.google.com/maps/search/?api=1&query=Bodegas+Gonzalez+Byass+Jerez',
      'https://oudofaiekedtaovrdqeo.supabase.co/storage/v1/object/public/sample-images/1/4/08.webp',
      FALSE,
      FALSE,
      '2026-02-27T20:30:00Z'::timestamptz,
      (SELECT id FROM public.cities WHERE LOWER(name) = LOWER('') LIMIT 1),
      (SELECT id FROM public.categories WHERE LOWER(slug) = 'arte-y-cultura' LIMIT 1),
      'published',
      'Recital clásico de cante.',
      'center');

INSERT INTO public.events (id, title, place, maps_url, image_url, is_featured, is_free, starts_at, city_id, category_id, status, description, image_alignment) VALUES (
      '00424ae9-98b7-4a7f-a8a4-90f103f5571b',
      'Homenaje a Blas Infante',
      'Plaza de San Antonio, Cádiz',
      'https://www.google.com/maps/search/?api=1&query=Plaza+San+Antonio+Cadiz',
      'https://oudofaiekedtaovrdqeo.supabase.co/storage/v1/object/public/sample-images/1/6/01.webp',
      FALSE,
      TRUE,
      '2026-02-28T11:00:00Z'::timestamptz,
      (SELECT id FROM public.cities WHERE LOWER(name) = LOWER('Cádiz') LIMIT 1),
      (SELECT id FROM public.categories WHERE LOWER(slug) = 'tradiciones' LIMIT 1),
      'published',
      'Acto institucional con ofrenda floral por el día de Andalucía.',
      'center');

INSERT INTO public.events (id, title, place, maps_url, image_url, is_featured, is_free, starts_at, city_id, category_id, status, description, image_alignment) VALUES (
      'aaafa4c0-7b5a-42d6-85e3-6850e49372e6',
      'Tagarninada Popular',
      'Barrio de San José, Cádiz',
      'https://www.google.com/maps/search/?api=1&query=Plaza+San+Jose+Cadiz',
      'https://oudofaiekedtaovrdqeo.supabase.co/storage/v1/object/public/sample-images/1/2/08.webp',
      FALSE,
      TRUE,
      '2026-02-28T14:00:00Z'::timestamptz,
      (SELECT id FROM public.cities WHERE LOWER(name) = LOWER('Cádiz') LIMIT 1),
      (SELECT id FROM public.categories WHERE LOWER(slug) = 'gastronomia' LIMIT 1),
      'published',
      'Degustación gratuita de tagarninas esparragás por el día festivo.',
      'center');

INSERT INTO public.events (id, title, place, maps_url, image_url, is_featured, is_free, starts_at, city_id, category_id, status, description, image_alignment) VALUES (
      'c8a7fe76-ee3c-4043-92e3-75388ac6c80a',
      'Festival de Jerez: Gala de Clausura Enero',
      'Teatro Villamarta, Jerez',
      'https://www.google.com/maps/search/?api=1&query=Teatro+Villamarta+Jerez',
      'https://oudofaiekedtaovrdqeo.supabase.co/storage/v1/object/public/sample-images/1/4/09.webp',
      FALSE,
      FALSE,
      '2026-02-28T20:30:00Z'::timestamptz,
      (SELECT id FROM public.cities WHERE LOWER(name) = LOWER('Jerez de la Frontera') LIMIT 1),
      (SELECT id FROM public.categories WHERE LOWER(slug) = 'arte-y-cultura' LIMIT 1),
      'published',
      'Cierre de la programación del mes con gran espectáculo.',
      'center');

INSERT INTO public.events (id, title, place, maps_url, image_url, is_featured, is_free, starts_at, city_id, category_id, status, description, image_alignment) VALUES (
      '4dd1de8f-8ed9-4880-af8e-ea0c25f03049',
      'Fútbol: San Fernando CD vs Estepona',
      'Estadio Iberoamericano, San Fernando',
      'https://www.google.com/maps/search/?api=1&query=Estadio+Bahia+Sur+San+Fernando',
      'https://oudofaiekedtaovrdqeo.supabase.co/storage/v1/object/public/sample-images/1/3/13.webp',
      FALSE,
      FALSE,
      '2026-01-18T12:00:00Z'::timestamptz,
      (SELECT id FROM public.cities WHERE LOWER(name) = LOWER('San Fernando') LIMIT 1),
      (SELECT id FROM public.categories WHERE LOWER(slug) = 'deportes' LIMIT 1),
      'published',
      'Liga Segunda Federación.',
      'center');

INSERT INTO public.events (id, title, place, maps_url, image_url, is_featured, is_free, starts_at, city_id, category_id, status, description, image_alignment) VALUES (
      '0fc031bc-04a0-4669-8e36-ab3b492ccbb7',
      'Fútbol: Balompédica Linense vs Minera',
      'Estadio La Línea',
      'https://www.google.com/maps/search/?api=1&query=Estadio+Municipal+La+Linea',
      'https://oudofaiekedtaovrdqeo.supabase.co/storage/v1/object/public/sample-images/1/3/14.webp',
      FALSE,
      FALSE,
      '2026-01-25T17:00:00Z'::timestamptz,
      (SELECT id FROM public.cities WHERE LOWER(name) = LOWER('La Línea de la Concepción') LIMIT 1),
      (SELECT id FROM public.categories WHERE LOWER(slug) = 'deportes' LIMIT 1),
      'published',
      'Liga Segunda Federación. Estadio Municipal de la Línea.',
      'center');

INSERT INTO public.events (id, title, place, maps_url, image_url, is_featured, is_free, starts_at, city_id, category_id, status, description, image_alignment) VALUES (
      'e11778f4-e61c-4bfe-b178-5f22924a1020',
      'Viernes Flamenco: Peña El Pescaero',
      'Peña El Pescaero, Jerez',
      'https://www.google.com/maps/search/?api=1&query=Pena+Flamenca+Pescaero+Jerez',
      'https://oudofaiekedtaovrdqeo.supabase.co/storage/v1/object/public/sample-images/1/1/07.webp',
      FALSE,
      TRUE,
      '2026-01-30T21:30:00Z'::timestamptz,
      (SELECT id FROM public.cities WHERE LOWER(name) = LOWER('Jerez de la Frontera') LIMIT 1),
      (SELECT id FROM public.categories WHERE LOWER(slug) = 'musica' LIMIT 1),
      'published',
      'Recital íntimo de guitarra y cante.',
      'center');

INSERT INTO public.events (id, title, place, maps_url, image_url, is_featured, is_free, starts_at, city_id, category_id, status, description, image_alignment) VALUES (
      '9ce0eabe-7de3-484f-b1ba-ac607680aef1',
      'Fiesta Post-Final Falla',
      'Discoteca La Punta, Cádiz',
      'https://www.google.com/maps/search/?api=1&query=La+Punta+San+Felipe+Cadiz',
      'https://oudofaiekedtaovrdqeo.supabase.co/storage/v1/object/public/sample-images/1/1/08.webp',
      FALSE,
      FALSE,
      '2026-02-13T23:00:00Z'::timestamptz,
      (SELECT id FROM public.cities WHERE LOWER(name) = LOWER('Cádiz') LIMIT 1),
      (SELECT id FROM public.categories WHERE LOWER(slug) = 'musica' LIMIT 1),
      'published',
      'Noche de coplas y DJ para celebrar el final del concurso.',
      'center');

INSERT INTO public.events (id, title, place, maps_url, image_url, is_featured, is_free, starts_at, city_id, category_id, status, description, image_alignment) VALUES (
      '5a05561a-321a-4dab-b9f8-2de3fd136676',
      'XXX Fritada Popular de Pescado',
      'Plaza de España, Cádiz',
      'https://www.google.com/maps/search/?api=1&query=Plaza+España+Cadiz',
      'https://oudofaiekedtaovrdqeo.supabase.co/storage/v1/object/public/sample-images/1/2/09.webp',
      FALSE,
      TRUE,
      '2026-02-21T13:30:00Z'::timestamptz,
      (SELECT id FROM public.cities WHERE LOWER(name) = LOWER('Cádiz') LIMIT 1),
      (SELECT id FROM public.categories WHERE LOWER(slug) = 'gastronomia' LIMIT 1),
      'published',
      'Degustación de pescado frito en pleno carnaval.',
      'center');

INSERT INTO public.events (id, title, place, maps_url, image_url, is_featured, is_free, starts_at, city_id, category_id, status, description, image_alignment) VALUES (
      '77dd0ad6-af04-456c-921e-052205344e40',
      'Mercado del Coleccionismo (Jerez)',
      'Alameda del Banco, Jerez',
      'https://www.google.com/maps/search/?api=1&query=Alameda+del+Banco+Jerez',
      'https://oudofaiekedtaovrdqeo.supabase.co/storage/v1/object/public/sample-images/1/7/05.webp',
      FALSE,
      TRUE,
      '2026-02-28T10:00:00Z'::timestamptz,
      (SELECT id FROM public.cities WHERE LOWER(name) = LOWER('Jerez de la Frontera') LIMIT 1),
      (SELECT id FROM public.categories WHERE LOWER(slug) = 'mercadillos' LIMIT 1),
      'published',
      'Intercambio de sellos, monedas y objetos antiguos.',
      'center');
