-- ============================================
-- SQL generado automáticamente para insertar eventos desde JSON
-- Fecha de generación: 2026-01-12T00:38:43.662934
-- Total de eventos: 170
-- Formato: INSERTs directos con imágenes secuenciales por categoría
-- ============================================

INSERT INTO public.events (id, title, place, maps_url, image_url, is_featured, is_free, starts_at, city_id, category_id, status, description, image_alignment) VALUES (
      '64b0f83e-460f-4c91-bf2b-f42f68a92ab8',
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
      '94d2a4fe-ccca-4faf-884d-648cd66db9b6',
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
      '046b723e-29ef-4d6f-94de-558f4cdd7301',
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
      'aeca78c6-1096-4a11-a709-c9ca1d2e5e63',
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
      'd65850f5-c44e-4d4e-b75c-950d41ad189f',
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
      '33cd8157-81f4-483e-a039-3f7c57151206',
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
      'a5990c92-106f-4f71-aab7-55e56ae76a75',
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
      'a984e26c-fec6-4e2e-a9d8-f7b26d8bca6c',
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
      '6abe2d32-70eb-401f-aed4-13f2ff2cf47c',
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
      '959d6334-5a01-4e22-9a83-55d4c97bf38a',
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
      '1375aacb-a47d-4e81-a740-272a66cc9a8c',
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
      '6fbb47a6-babd-40f0-a3ee-1d0727f95124',
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
      '16fc92fb-f428-427a-b1e4-877445453b91',
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
      'af34d484-b5af-41f7-9aeb-136f8dcd8a58',
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
      '53cd83f9-a73a-45b2-8a7f-1ca2db316693',
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
      'd5509582-a35d-499f-8c72-b4fdcaa5c005',
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
      '52a3de50-f6f7-42a3-829d-4bca78929645',
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
      'cf8932ca-07eb-4f0e-a686-8a31e9a046c5',
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
      '6109359c-0e70-4647-9f9d-c49cd7e03439',
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
      '6d24b4fb-808e-4a73-aa1a-4d5b181a1efb',
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
      '88d23c7b-a5e0-43ae-aa44-1cb3f795b8e7',
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
      '35c883d8-2721-4620-9be5-5ac8fd09e514',
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
      'f42682a8-b21b-42b5-b8a8-30cddcfa8396',
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
      '721c0d0a-cc08-40cd-be99-687c97e9cfc3',
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
      'ce1f7992-dd2c-43b9-878f-ac98e7de790d',
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
      'e5913589-8c68-4c70-b6d3-3da5d13e4786',
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
      'b373bc64-4543-4ddc-ba8e-0e232f29611a',
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
      '3f5b34dd-c82e-4d6a-8f3d-7eb1c7285d21',
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
      '15f11a05-5667-48b1-a19f-c15124eed841',
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
      'a944ee25-2f8a-4f6b-bc18-6edaf30339d5',
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
      '1d7e2689-8a14-4455-a0cf-4ebc1f6dc564',
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
      '8c7bff97-33ba-4956-9ac2-49ce1d363b84',
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
      'bf6973eb-547b-42f4-b0bd-bf7784d18148',
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
      '09e71b4f-1312-42b2-a7f0-a6c0cbe8483a',
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
      '3077a023-2edb-4e6c-9352-ebbbb50ad781',
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
      'bb756f98-1635-42cc-a34d-1332e20ad13c',
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
      '03def5ca-6ebc-46fb-a6ba-382757b5d7a4',
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
      '7e2f3624-fe35-4d9a-a159-805e85a8f15c',
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
      '51a5db86-ddde-43cc-9e78-59a94faf9c19',
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
      '0d8d1ec5-783e-4cc7-a43b-0b4cb7d78c09',
      'IV Media Maratón Ciudad de Arcos',
      'Centro de Arcos',
      'https://www.google.com/maps/search/?api=1&query=Arcos+de+la+Frontera',
      'https://oudofaiekedtaovrdqeo.supabase.co/storage/v1/object/public/sample-images/1/3/15.webp',
      FALSE,
      FALSE,
      '2026-01-31T10:00:00Z'::timestamptz,
      (SELECT id FROM public.cities WHERE LOWER(name) = LOWER('Arcos de la Frontera') LIMIT 1),
      (SELECT id FROM public.categories WHERE LOWER(slug) = 'deportes' LIMIT 1),
      'published',
      'Carrera oficial con recorrido por el casco monumental de Arcos.',
      'center');

INSERT INTO public.events (id, title, place, maps_url, image_url, is_featured, is_free, starts_at, city_id, category_id, status, description, image_alignment) VALUES (
      '351c2e43-607d-41e5-9f3b-9f81c4ac2a6f',
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
      '9450b47c-5c92-4c34-81e2-96744ebc291d',
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
      '4229cd9f-6052-4045-95ed-aa152a6b7357',
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
      '4e9e6a61-0898-4207-b670-0d4f4c547151',
      'At. Sanluqueño vs Betis Deportivo',
      'Estadio El Palmar',
      'https://www.google.com/maps/search/?api=1&query=Estadio+El+Palmar+Sanlucar',
      'https://oudofaiekedtaovrdqeo.supabase.co/storage/v1/object/public/sample-images/1/3/01.webp',
      FALSE,
      FALSE,
      '2026-02-01T12:00:00Z'::timestamptz,
      (SELECT id FROM public.cities WHERE LOWER(name) = LOWER('Sanlúcar de Barrameda') LIMIT 1),
      (SELECT id FROM public.categories WHERE LOWER(slug) = 'deportes' LIMIT 1),
      'published',
      'Primera Federación. Cantera bética en Sanlúcar.',
      'center');

INSERT INTO public.events (id, title, place, maps_url, image_url, is_featured, is_free, starts_at, city_id, category_id, status, description, image_alignment) VALUES (
      'a1fbb503-a890-4388-9ae6-7737e5015e58',
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
      'd3c42203-ea98-469b-b6d3-add41bfd6a5c',
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
      '0d3bc2b2-fa42-4050-972b-96a5bfd6fd7a',
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
      'd956d794-c820-4799-9b82-3e415459f2ba',
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
      'e148dfef-76ee-4a35-9dfa-7abddefbc2cc',
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
      '2507ae3c-124e-4827-9b54-17b8a422f6b8',
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
      'aa7cb915-bdba-4ef4-80c2-9f387611c6a7',
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
      '0e026114-c17e-474b-b4c1-2d7b5a292366',
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
      '8af95ce1-8188-48a0-b645-7c441443c1c4',
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
      '8cd1e683-c2b3-414a-a64b-294eb206cf33',
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
      'ec0d1869-58c2-48c2-adcc-b7e86f40e241',
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
      '46683f72-9899-4a27-9a05-ada55c90f085',
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
      'e9a30ae8-9095-4789-bdd2-cf434a4008fb',
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
      'f5a32b78-0fbf-4a30-add9-5e8085901cac',
      'XII Víboras Trail',
      'Algodonales',
      'https://www.google.com/maps/search/?api=1&query=Algodonales',
      'https://oudofaiekedtaovrdqeo.supabase.co/storage/v1/object/public/sample-images/1/3/07.webp',
      FALSE,
      FALSE,
      '2026-02-07T09:00:00Z'::timestamptz,
      (SELECT id FROM public.cities WHERE LOWER(name) = LOWER('Algodonales') LIMIT 1),
      (SELECT id FROM public.categories WHERE LOWER(slug) = 'deportes' LIMIT 1),
      'published',
      'Trail de montaña exigente de 42km.',
      'center');

INSERT INTO public.events (id, title, place, maps_url, image_url, is_featured, is_free, starts_at, city_id, category_id, status, description, image_alignment) VALUES (
      '56dad1e0-e5e3-4d6a-9702-a9bdfa39392e',
      'Pregón Carnaval de Arcos',
      'Teatro Olivares Veas',
      'https://www.google.com/maps/search/?api=1&query=Teatro+Olivares+Veas+Arcos',
      'https://oudofaiekedtaovrdqeo.supabase.co/storage/v1/object/public/sample-images/1/6/08.webp',
      FALSE,
      TRUE,
      '2026-02-07T20:00:00Z'::timestamptz,
      (SELECT id FROM public.cities WHERE LOWER(name) = LOWER('Arcos de la Frontera') LIMIT 1),
      (SELECT id FROM public.categories WHERE LOWER(slug) = 'tradiciones' LIMIT 1),
      'published',
      'Inicio del carnaval serrano en el Olivares Veas.',
      'center');

INSERT INTO public.events (id, title, place, maps_url, image_url, is_featured, is_free, starts_at, city_id, category_id, status, description, image_alignment) VALUES (
      '61ef23b6-9210-4fd5-b8ab-10b96930443b',
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
      'ff610a78-572c-4ebb-95f7-68b38dc9475e',
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
      '437c6da0-ef80-4aa2-b0dc-307fd955f4f6',
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
      '223240cc-1a58-4659-a019-2dcb38f4de58',
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
      '973dc126-1af9-49cb-9210-2330e64e6fe7',
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
      '11c201f1-109d-4345-a62e-cb19024edf63',
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
      '6ee3cc91-6a89-4a65-9d93-1c2a369b0f1b',
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
      'd0c9071e-0879-453b-936c-600531634b64',
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
      'de434519-a291-4fd8-97a5-713b53cb166b',
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
      '6fdcf7cd-e54b-4b14-bf95-c15055607e5c',
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
      'e781612a-3f4c-4401-8a0c-b20e452c8994',
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
      'f2b49a71-fe17-4153-9cc2-59ab3a1eb635',
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
      '39592106-f305-4932-9047-ad178311f5e0',
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
      '60f00579-9568-4920-a819-8a628754c3d9',
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
      '549ffc92-a810-4da9-a482-be1c372857be',
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
      '33f7f711-ee13-4584-89a2-0991f8a8b906',
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
      '18be3c57-d4fa-4de4-a23c-66928264be0e',
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
      'fe4b4853-8fc0-42bf-9481-f21921375ec9',
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
      '2ae7be03-3202-4ad0-9e19-8e885acdee59',
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
      'c6d1512a-3b22-4ea0-a00c-14e978ed3577',
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
      '189e4215-286c-4334-817e-6ddb7c752ef1',
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
      '8a31f575-ef3f-41cb-92e7-3ee4730321ba',
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
      '9fadb1d9-8d23-4ed9-8145-c2a6d41af714',
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
      'f2199216-dee2-4dfb-ad33-755e59021b01',
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
      '8dd9bbf4-8eaa-4350-8a92-dc44e994685b',
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
      '514d4223-7328-449e-91c0-2db0a16f094c',
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
      '35c409d2-e5b6-4056-87ef-65b2999b0b3e',
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
      '927d605e-746d-4fd0-a92e-7f3562d9655b',
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
      'f558b8dd-ebf3-42d8-9f0e-f3eec779c1aa',
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
      'db79fad8-9315-4119-9238-6c3589528e74',
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
      '19bcb3aa-183f-4d4b-b57e-c47ec0e6e385',
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
      '7b95787d-8c92-4250-be75-594c8938da8f',
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
      '35065965-2dc6-44a7-a52e-aff08fe2c4cc',
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
      'f4123452-9756-4001-b68d-9276c7f85988',
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
      '223b1a2c-101a-48da-a4f6-940eeb86d335',
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
      'ecac8f19-dfe5-4fcf-b65a-6e08859bfb56',
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
      'f892918b-d657-4ed7-b528-295524199962',
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
      'f324f309-3011-460d-a3be-5ef05a7a4e94',
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
      'ccd028e9-3c90-4bbe-93ef-8cd882862e39',
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
      'cf9cf6bb-e482-4ab1-b7f7-605eb29e469e',
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
      'c2f54492-0b92-4483-bca8-4bbb138a094b',
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
      '1081d404-b6b0-4aa5-9dd9-68f6d2f95410',
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
      'dde5acd4-49bc-4823-b5d6-381c32233f12',
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
      '25bc64a8-8592-4a50-be04-0c336d525fbe',
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
      'd87adbff-3097-4032-b58a-1e6cc413a8e6',
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
      '27f383e9-3ae5-4649-b4a7-50c26ebee6a8',
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
      '6ce19672-4db8-455a-abbe-8da7f0db81a3',
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
      'e58472f7-9a73-41dd-970c-91f07b40ae15',
      'Teatro: 'Se Alquila' con Andoni Ferreño',
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
      '387a4b8d-184e-4084-ad65-54c72748995b',
      'Fútbol Infantil: Cádiz CF 'A' vs Real Betis',
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
      '9cde2c4c-e1eb-44a6-bb9e-511a4f70a19a',
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
      '43f62727-6918-441f-9519-168a3dc54665',
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
      '80fec5c3-9b03-4a7e-a5cc-a67956a4c7d2',
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
      'a537c7e9-af20-44a0-bd27-c12fbd4e129c',
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
      '06990e72-9ef5-43ec-88fc-52aa0600398a',
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
      '46e79ea6-4987-42f6-9c35-5de1153fa22b',
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
      '33935e0e-5c96-44a8-a1d1-18a210438e93',
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
      'e5918062-e503-4eae-8fee-d5fadbb71e24',
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
      'c8b0938b-559d-4329-a8bd-0098ec7d25e4',
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
      '5171fe1c-fd09-44f4-b858-c6b162400180',
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
      'ba229450-1808-419f-a029-ca490fb13511',
      'Senderismo: Subida al Picacho',
      'Inicio Área Recreativa El Picacho',
      'https://www.google.com/maps/search/?api=1&query=Area+Recreativa+El+Picacho',
      'https://oudofaiekedtaovrdqeo.supabase.co/storage/v1/object/public/sample-images/1/5/02.webp',
      FALSE,
      TRUE,
      '2026-02-07T10:00:00Z'::timestamptz,
      (SELECT id FROM public.cities WHERE LOWER(name) = LOWER('Alcalá de los Gazules') LIMIT 1),
      (SELECT id FROM public.categories WHERE LOWER(slug) = 'aire-libre' LIMIT 1),
      'published',
      'Ruta de nivel medio por el Parque Natural de los Alcornocales.',
      'center');

INSERT INTO public.events (id, title, place, maps_url, image_url, is_featured, is_free, starts_at, city_id, category_id, status, description, image_alignment) VALUES (
      'c3300e94-44cd-4b97-abe1-7cad8d475b1a',
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
      'dd60afee-5bd8-4706-b549-a4d655fe6dfe',
      'Pringá Popular (Chiclana)',
      'Peña Carnavalesca Perico Alcántara',
      'https://www.google.com/maps/search/?api=1&query=Peña+Perico+Alcantara+Chiclana',
      'https://oudofaiekedtaovrdqeo.supabase.co/storage/v1/object/public/sample-images/1/2/05.webp',
      FALSE,
      TRUE,
      '2026-02-15T13:00:00Z'::timestamptz,
      (SELECT id FROM public.cities WHERE LOWER(name) = LOWER('Chiclana de la Frontera') LIMIT 1),
      (SELECT id FROM public.categories WHERE LOWER(slug) = 'gastronomia' LIMIT 1),
      'published',
      'Degustación de montaditos de pringá con ambiente de carnaval.',
      'center');

INSERT INTO public.events (id, title, place, maps_url, image_url, is_featured, is_free, starts_at, city_id, category_id, status, description, image_alignment) VALUES (
      '7e095c4b-7297-4ca4-8b75-d5053a35c89e',
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
      'bbc0f572-0661-4fa6-b1bb-ad70c8eeb605',
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
      '01576187-4b38-4bf8-8c7f-8e9c803d111a',
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
      'b000609d-4bd9-4f7c-a021-7f0cc2778c55',
      'Fútbol Femenino: Cádiz CF vs Málaga CF',
      'Ciudad Deportiva El Rosal',
      'https://www.google.com/maps/search/?api=1&query=Ciudad+Deportiva+Bahia+de+Cadiz',
      'https://oudofaiekedtaovrdqeo.supabase.co/storage/v1/object/public/sample-images/1/3/16.webp',
      FALSE,
      TRUE,
      '2026-02-27T18:00:00Z'::timestamptz,
      (SELECT id FROM public.cities WHERE LOWER(name) = LOWER('Puerto Real') LIMIT 1),
      (SELECT id FROM public.categories WHERE LOWER(slug) = 'deportes' LIMIT 1),
      'published',
      'Partido de liga de la cantera femenina.',
      'center');

INSERT INTO public.events (id, title, place, maps_url, image_url, is_featured, is_free, starts_at, city_id, category_id, status, description, image_alignment) VALUES (
      '424566df-b2f9-4e3d-857e-9a8094a47d0f',
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
      '30dd04a9-60ed-40c0-b73e-a412245869bb',
      'Monólogo: José Luis Calero',
      'Auditorio Municipal Rota',
      'https://www.google.com/maps/search/?api=1&query=Auditorio+Municipal+Rota',
      'https://oudofaiekedtaovrdqeo.supabase.co/storage/v1/object/public/sample-images/1/4/06.webp',
      FALSE,
      FALSE,
      '2026-01-17T20:00:00Z'::timestamptz,
      (SELECT id FROM public.cities WHERE LOWER(name) = LOWER('Rota') LIMIT 1),
      (SELECT id FROM public.categories WHERE LOWER(slug) = 'arte-y-cultura' LIMIT 1),
      'published',
      'Show ''Humorista de Guardia'' en el auditorio.',
      'center');

INSERT INTO public.events (id, title, place, maps_url, image_url, is_featured, is_free, starts_at, city_id, category_id, status, description, image_alignment) VALUES (
      '07844019-ce8f-462b-88c1-b02ad2d55b6c',
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
      '2d80b70e-91d8-47b8-98d0-a77a633bb43b',
      'Arroz de Convivencia: Día de Andalucía',
      'Plaza del Ayuntamiento, Benalup',
      'https://www.google.com/maps/search/?api=1&query=Ayuntamiento+Benalup+Casas+Viejas',
      'https://oudofaiekedtaovrdqeo.supabase.co/storage/v1/object/public/sample-images/1/2/07.webp',
      FALSE,
      TRUE,
      '2026-02-28T14:00:00Z'::timestamptz,
      (SELECT id FROM public.cities WHERE LOWER(name) = LOWER('Benalup-Casas Viejas') LIMIT 1),
      (SELECT id FROM public.categories WHERE LOWER(slug) = 'gastronomia' LIMIT 1),
      'published',
      'Jornada gastronómica gratuita para los vecinos.',
      'center');

INSERT INTO public.events (id, title, place, maps_url, image_url, is_featured, is_free, starts_at, city_id, category_id, status, description, image_alignment) VALUES (
      '06899016-99db-454f-9c97-e00df65712f8',
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
      'ed4c493c-475e-46c9-a166-efd58589b5df',
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
      '6731cd9a-b87c-4316-b658-41f7897615a1',
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
      'ca68eea4-94d6-4b8b-bbc5-91442b90cd49',
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
      'd68e7c58-4821-45a9-bfe9-de08913a7049',
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
      'e8ed134c-2d3b-40e5-afe8-04c886f7404d',
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
      '74d49f2f-6de3-4f40-bb3a-e55b108e15ae',
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
      'c8dd6e7e-4a9a-4fa4-ac5f-d965acda0579',
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
      '2afb6c79-cfc0-4945-94c8-d70265f9685d',
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
      'a20fb785-557f-481c-a341-c2b948389654',
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
      'ec9fdda4-47be-40f6-873b-a158317f30ed',
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
      'be4fb219-173b-48ca-bff3-54ed6ccf835b',
      'Lectura Dramatizada: 'Incendios'',
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
      '8803226a-184f-4fc7-9660-3bd47b577798',
      'Magic Fest: Gala Inaugural',
      'Teatro Juan Luis Galiardo',
      'https://www.google.com/maps/search/?api=1&query=Teatro+Juan+Luis+Galiardo+San+Roque',
      'https://oudofaiekedtaovrdqeo.supabase.co/storage/v1/object/public/sample-images/1/4/09.webp',
      FALSE,
      FALSE,
      '2026-01-12T20:00:00Z'::timestamptz,
      (SELECT id FROM public.cities WHERE LOWER(name) = LOWER('San Roque') LIMIT 1),
      (SELECT id FROM public.categories WHERE LOWER(slug) = 'arte-y-cultura' LIMIT 1),
      'published',
      'Apertura del festival de magia de San Roque.',
      'center');

INSERT INTO public.events (id, title, place, maps_url, image_url, is_featured, is_free, starts_at, city_id, category_id, status, description, image_alignment) VALUES (
      'a4bb0a42-b5aa-4043-a78e-fc1df6e96f55',
      'Encuentro Amigos de la Biblioteca',
      'Biblioteca Municipal San Roque',
      'https://www.google.com/maps/search/?api=1&query=Biblioteca+Municipal+San+Roque',
      'https://oudofaiekedtaovrdqeo.supabase.co/storage/v1/object/public/sample-images/1/4/01.webp',
      FALSE,
      TRUE,
      '2026-01-13T18:30:00Z'::timestamptz,
      (SELECT id FROM public.cities WHERE LOWER(name) = LOWER('San Roque') LIMIT 1),
      (SELECT id FROM public.categories WHERE LOWER(slug) = 'arte-y-cultura' LIMIT 1),
      'published',
      'Reunión literaria abierta al público.',
      'center');

INSERT INTO public.events (id, title, place, maps_url, image_url, is_featured, is_free, starts_at, city_id, category_id, status, description, image_alignment) VALUES (
      '611e2d8f-123a-4c38-a138-fa80f24de933',
      'Magic Fest: Magia Infantil',
      'Teatro Juan Luis Galiardo',
      'https://www.google.com/maps/search/?api=1&query=Teatro+Juan+Luis+Galiardo+San+Roque',
      'https://oudofaiekedtaovrdqeo.supabase.co/storage/v1/object/public/sample-images/1/4/02.webp',
      FALSE,
      FALSE,
      '2026-01-18T12:00:00Z'::timestamptz,
      (SELECT id FROM public.cities WHERE LOWER(name) = LOWER('San Roque') LIMIT 1),
      (SELECT id FROM public.categories WHERE LOWER(slug) = 'arte-y-cultura' LIMIT 1),
      'published',
      'Espectáculo diseñado para niños y familias.',
      'center');

INSERT INTO public.events (id, title, place, maps_url, image_url, is_featured, is_free, starts_at, city_id, category_id, status, description, image_alignment) VALUES (
      '814d8ead-f4e0-41b8-bf36-fde17fbe26fc',
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
      '2a5217bc-fd06-4881-b211-eb0bf47fc4c5',
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
      '6d482a1a-82cf-43eb-8c45-f60632f69027',
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
      '10a07cad-b757-4a07-8bcf-89ea5ad09569',
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
      '7df031ae-80b7-4daa-b886-1ab084411e8d',
      'I Certamen Nacional de Coplas',
      'Teatro Galiardo, San Roque',
      'https://www.google.com/maps/search/?api=1&query=Teatro+Juan+Luis+Galiardo+San+Roque',
      'https://oudofaiekedtaovrdqeo.supabase.co/storage/v1/object/public/sample-images/1/6/09.webp',
      FALSE,
      FALSE,
      '2026-01-24T20:30:00Z'::timestamptz,
      (SELECT id FROM public.cities WHERE LOWER(name) = LOWER('San Roque') LIMIT 1),
      (SELECT id FROM public.categories WHERE LOWER(slug) = 'tradiciones' LIMIT 1),
      'published',
      'Concurso de agrupaciones de carnaval foráneas.',
      'center');

INSERT INTO public.events (id, title, place, maps_url, image_url, is_featured, is_free, starts_at, city_id, category_id, status, description, image_alignment) VALUES (
      '6612a574-8690-461d-bc1f-de176f8cf7ce',
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
      '79afd823-c92d-45ab-bd44-40b53cab68f3',
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
      '8460a5b9-bd04-4e09-b479-40d061a9f000',
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
      '6e17d1c8-b5c4-4358-90a2-2485dc256b03',
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
      '0c630b9a-1684-42d0-9a86-04aa04ad19ee',
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
      '259bc1f9-dc4c-4924-a04c-4f6c47f2d674',
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
      '96f6d238-4ef0-4e13-bd01-26aa4cd734f5',
      'Festival de Jerez: Gala de Baile',
      'Teatro Villamarta',
      'https://www.google.com/maps/search/?api=1&query=Teatro+Villamarta+Jerez',
      'https://oudofaiekedtaovrdqeo.supabase.co/storage/v1/object/public/sample-images/1/4/04.webp',
      FALSE,
      FALSE,
      '2026-02-23T20:30:00Z'::timestamptz,
      (SELECT id FROM public.cities WHERE LOWER(name) = LOWER('Jerez de la Frontera') LIMIT 1),
      (SELECT id FROM public.categories WHERE LOWER(slug) = 'arte-y-cultura' LIMIT 1),
      'published',
      'Espectáculo central en el Teatro Villamarta.',
      'center');

INSERT INTO public.events (id, title, place, maps_url, image_url, is_featured, is_free, starts_at, city_id, category_id, status, description, image_alignment) VALUES (
      '69e59672-0732-44ad-aa25-b64eac299430',
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
      '61235457-30b9-480f-86c9-fe1a5944f65c',
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
      '4d3aeef1-4268-495f-b771-afaaa6235b28',
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
      'b61f2ce3-dc2d-40de-b724-26677ce0c3e2',
      'Ruta Flora y Fauna: Parque de los Toruños',
      'Parque Los Toruños',
      'https://www.google.com/maps/search/?api=1&query=Casa+de+los+Torunos',
      'https://oudofaiekedtaovrdqeo.supabase.co/storage/v1/object/public/sample-images/1/5/03.webp',
      FALSE,
      TRUE,
      '2026-02-27T12:00:00Z'::timestamptz,
      (SELECT id FROM public.cities WHERE LOWER(name) = LOWER('El Puerto de Santa María') LIMIT 1),
      (SELECT id FROM public.categories WHERE LOWER(slug) = 'aire-libre' LIMIT 1),
      'published',
      'Paseo interpretativo gratuito por las dunas.',
      'center');

INSERT INTO public.events (id, title, place, maps_url, image_url, is_featured, is_free, starts_at, city_id, category_id, status, description, image_alignment) VALUES (
      'acd5bf62-c741-4291-8712-503166564a6b',
      'Festival de Jerez: Cante Jondo',
      'Bodegas Los Apóstoles',
      'https://www.google.com/maps/search/?api=1&query=Bodegas+Gonzalez+Byass+Jerez',
      'https://oudofaiekedtaovrdqeo.supabase.co/storage/v1/object/public/sample-images/1/4/08.webp',
      FALSE,
      FALSE,
      '2026-02-27T20:30:00Z'::timestamptz,
      (SELECT id FROM public.cities WHERE LOWER(name) = LOWER('Jerez de la Frontera') LIMIT 1),
      (SELECT id FROM public.categories WHERE LOWER(slug) = 'arte-y-cultura' LIMIT 1),
      'published',
      'Recital clásico de cante.',
      'center');

INSERT INTO public.events (id, title, place, maps_url, image_url, is_featured, is_free, starts_at, city_id, category_id, status, description, image_alignment) VALUES (
      '91b14543-fa0c-44d9-9232-a1337165596c',
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
      '3ea8de92-c61f-4ffb-afd3-c93ff2f9d62e',
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
      '033475a6-9183-4ed5-b56b-97f22aa7f236',
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
      'f893ad7d-26ba-404e-aead-b943133b3a6f',
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
      '79e35f2b-ff58-4234-9110-dfc61a11e4af',
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
      '605af2c4-b37e-4e3a-a537-fbdf2acf2389',
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
      '59d3a590-e12f-41a9-bb44-fe97944bba8d',
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
      'd402e18a-dcbe-405c-8ad7-1b743237438e',
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
      '69831ce1-b9ac-4f5b-8768-62d092fd32d7',
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
