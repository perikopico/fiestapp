-- ============================================
-- SQL generado automáticamente para insertar eventos desde JSON
-- Fecha de generación: 2026-01-12T00:41:24.141258
-- Total de eventos: 170
-- Formato: INSERTs directos con imágenes secuenciales por categoría
-- ============================================

INSERT INTO public.events (id, title, place, maps_url, image_url, is_featured, is_free, starts_at, city_id, category_id, status, description, image_alignment) VALUES (
      'b01cbff4-3733-4d2d-a052-95e3eb077c34',
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
      '6a120f61-7c45-4941-a00f-1e9990abbfe7',
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
      '43aefaf3-ff8c-4e61-97ed-9f8ee379cca1',
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
      'e226f7d3-1954-426a-84c4-1f94a3cb15c8',
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
      'eecd31dd-ce00-42fb-a5dc-675fd9a28090',
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
      '3681109f-560e-4bb6-be9c-a441bc435a84',
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
      'e5abc066-6a82-456f-afd5-a3e9fe13d701',
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
      'de98f018-963c-4ea7-b0e1-635d4fbeca5c',
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
      '726535f1-42fa-4904-b607-ced96cee9ad7',
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
      '6e6df177-3cc5-44e2-87b6-0765605f45a3',
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
      'ba1ea508-30ba-45ee-a505-7e7a598bdae9',
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
      'ee24ac49-62cc-4a57-a95c-58830904ade6',
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
      '5e7d71da-9b2c-40c9-9745-a7c7d8031257',
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
      'ed95e12b-3b57-4ea5-b3a2-b20afef7ab4b',
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
      '718ed99e-f6b6-4ed4-ab80-1218810afe13',
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
      'ff86e55c-561e-4a1f-92e5-288fc76642eb',
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
      '890a9ea8-8149-4082-914a-b87af05568ed',
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
      'efc0749f-ae8b-4023-ac5b-8a1cca090c0b',
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
      '0101280e-fc2f-4fd5-9051-4005400a08cd',
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
      'd5b6e5c2-9523-4173-98d5-e6f15bb343f1',
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
      '42027135-b33c-4ca8-b8bd-14bf9761a0c0',
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
      '00438a27-8c48-48d6-954b-d47edf0d4889',
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
      'aafb578b-ecff-47ad-a6bb-eb4850c51acf',
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
      'b661430e-63cb-4516-b88b-422e80cd3024',
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
      '8071074e-70d8-45df-8dab-71f0e76a18b4',
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
      'b0e8f104-2ab6-45bd-9fcb-20609b54f2dc',
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
      'eb8dbae5-dbcf-4f32-a8d8-3b1ad7d20134',
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
      '77e1f39f-ae64-41ec-8b5b-7d6c1adec4bc',
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
      '6d996888-10eb-4725-81c9-51e501d07dba',
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
      '09a836fa-2ecc-4e0b-a359-02959bafdb2a',
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
      '39c6ad34-9d9e-4a86-834a-a082add10e57',
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
      'c787fd72-eafa-415b-b5df-bfd7ab85af5e',
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
      'a05ea246-bdca-40c2-a7e4-a561adf70d05',
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
      'f41a658d-f1b0-4a89-9c1c-7c540682e806',
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
      '9290db08-1cab-4171-a028-75c5db9eb169',
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
      'a332cd6c-844f-4872-9e81-ba709720c952',
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
      'ac0d88f7-0fb3-41e7-a25a-e8328defa20d',
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
      '5c3d0817-7403-4177-9f65-64a37fe22792',
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
      '0a2c3ebb-3ccb-4c67-8f50-d5c36b90a098',
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
      'c06dd284-8b10-4570-9ccd-30c62224d5c1',
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
      '1bd58817-c484-4bf7-8bcd-b6842b0b4e8b',
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
      '7b669c65-d69c-4d20-bd25-905b25f0bd41',
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
      '5765bae6-b853-4589-bbf8-d694330f6891',
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
      '26be82d8-4e7e-4073-a277-9cd5e1283930',
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
      'b5a669b4-c8fb-4267-93e7-bba393ad541b',
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
      '581933ee-ffa8-4b69-9b60-e026d9046979',
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
      '7e7706a9-344a-40ba-ad66-7abc07afcb7d',
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
      '6b906edd-e7bc-4922-a31a-6192aade519b',
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
      '969df882-7e05-45c2-b05d-01e35bbc150f',
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
      '7096edd0-c3af-4610-b6b7-d14dfd3f0b6d',
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
      '10f0603b-b94d-40dc-add7-a2bdb8b17449',
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
      'd6f83e1b-1c0c-4bfc-98d1-433085ddc30c',
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
      'feff2d06-20fc-4c37-af28-8e46311b3616',
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
      'afda750f-3ae4-45a3-99e1-cf40023e3455',
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
      '1d32f8b3-e2e0-4778-a8c0-ae56db5b1458',
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
      '998ca42c-eea0-4901-99fb-d5358b85ea9b',
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
      'd2ec746f-8d17-4d10-9be5-e924aafff2f8',
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
      '24953782-57c7-4121-9817-512dc5fce963',
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
      'e075ff0d-d12f-4dcc-81b3-b7b1ad951030',
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
      '9819d628-dd4f-41eb-8bef-ce79b4c17eb2',
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
      '602a2aee-bba7-43dc-8bac-0cab23e98435',
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
      'eb42b009-ab3b-43b8-a409-ee5ea7ca966f',
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
      '3ce73de1-c482-4056-97d9-928fd05457d0',
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
      'c6ab6154-9d67-4207-9032-5f1c1caca3a9',
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
      '29499cd0-cf37-4f0b-9b72-6fc23b3c92d4',
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
      '220492e8-41b4-425f-8fa5-173f2c63811d',
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
      '59defdef-3544-4372-960f-ee219d19578a',
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
      '957f3b3e-c1b5-443b-a2e6-915f81521474',
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
      'a23ac2ce-3976-4571-900a-78d126a54bc5',
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
      'fdc7f6fe-4157-4ef7-a667-610b6ff0093e',
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
      'e2805c5d-c281-4395-9015-24c2608ef8a4',
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
      'e1b3cdfa-c36d-4bc5-b7d0-a52b2c18aac5',
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
      'dc90fa62-cdf8-47bb-9040-fa3a1a45c93a',
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
      '2466633e-526a-497f-97bf-9bba5f67eaca',
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
      'bd88ae7f-5e65-4b38-b81d-f3a062748388',
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
      '466b0827-7e81-4e2c-a26a-45de7626afa1',
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
      'ed59d0f1-f2c1-4d7a-b5fb-78bcafc977c3',
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
      'c8ad8566-a309-4eda-95ea-3907a106b489',
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
      '421f47b1-6aef-4aaf-b87d-7b84cf2429da',
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
      '1306b8e0-3bfd-45a9-932a-41eccbedc718',
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
      '85b824a9-6c7e-4171-b935-5d5b9f082ba8',
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
      'f3f33946-ea72-4f12-b92c-5dbc1723412f',
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
      '6dc4d033-a9c2-4d9d-bd3e-517a9d3afe61',
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
      'f9835d45-6074-44fa-a3f1-3d7bfc060079',
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
      '78544423-26de-424f-86df-8529d866d276',
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
      '1522d916-604d-4c50-af62-c634c50fb6d1',
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
      '17e26b94-ad94-4c20-840e-121da9d7212d',
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
      '1f7b32a1-4fed-4f3e-acd8-5613b103cc17',
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
      '834ff95b-b6ac-4934-a305-01e363ee7472',
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
      '84f15a76-a755-49d2-878b-92c7a184f349',
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
      'fb871884-8603-4120-95f2-ea707d6dd0f5',
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
      '3009b37a-a410-4b7b-aa54-7556ff238dbd',
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
      '0e61c276-df0d-4089-8da5-8b5ee79ab84c',
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
      'df9f927f-6ee6-4ee4-95f9-bd38df7e3edf',
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
      'ade14b46-2e85-4605-b872-77062afe591f',
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
      'd255be92-2386-43c2-8dab-9b814240af7c',
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
      '80807a45-bf07-495c-a18b-9e10f074b13d',
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
      '313a8cf5-5b9f-4688-8fa1-750e3a3cd5ed',
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
      'aa8608ed-93ef-4e54-8e13-bf0142a913e1',
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
      '4a4c4eb6-fc3a-40da-b081-e36d9235ecbd',
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
      '26196cec-34ef-4356-bdbe-51eb3495f206',
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
      '90ef576e-86b2-4d02-99c2-a197206d7e04',
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
      '8a453644-d203-439c-ad95-9ea83e938012',
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
      '96876b26-0484-4a7d-80a0-0a7f46afc734',
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
      '623d02e7-dbdc-4055-866b-3c0b0e469594',
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
      '6ad964cb-c6d2-4aea-8c81-a8f038e76a12',
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
      'a161b1d5-d350-4c66-ba0f-ed6bd3b56c51',
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
      '4c60b356-2adb-4cd3-8f3b-04e6c745d8b5',
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
      '014b870e-00cf-4dbc-8f23-b64f842883fc',
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
      'df4141a1-9396-4917-a194-8226234b9002',
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
      'b6f6a54c-8d64-4529-af68-c799b2e4cb7e',
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
      '9c43346a-bf42-419f-ba68-64f25f08728f',
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
      '3653c9b0-e328-4f38-a7db-a01c124b48dc',
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
      '13e2090e-e43a-42cc-875b-c6dd05808bfe',
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
      'f062c8d8-653e-4762-a991-c43707dcd007',
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
      '4a8a5a23-73c6-466d-8ac2-32ba0b2765bf',
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
      '3636019c-cb6c-494b-8296-ee0b07fc1c4f',
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
      '4076da14-7a89-4482-8251-fcbf30abd5d0',
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
      '2194ac60-f94e-4054-8f1f-c47f7fe2f475',
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
      '84ab1880-aa13-420e-a893-158a5203cad1',
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
      'be0c11ae-8340-4ee8-8b21-d01586ea0c9d',
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
      'dfcaaeed-f636-48a1-8c6f-3b1aa467ddfd',
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
      '8202f377-9b83-485b-9d18-f964bb375d40',
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
      '54e332d8-dd1a-4e7e-b3a5-7eb44fa819b9',
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
      '959a76bd-039f-4f7c-a183-c885619b05f3',
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
      '8852cc46-ee4e-4e8a-acb1-fc527b1609f1',
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
      'b090029a-2289-4f29-867c-e18c05d2251a',
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
      '401561da-ec11-455c-a32b-fa5c09e0a816',
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
      '573471a7-be3f-4621-a27d-a28de115a027',
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
      'e399680c-d8a2-46f0-86e5-dfa9b36ef65e',
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
      '74318a0d-48bb-4bde-88c6-b6507403bb12',
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
      '0ec520d5-ea0a-4aa3-8f93-db393fd737fd',
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
      'bd3ca7b2-9430-429c-b283-cd69e17012f2',
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
      'a4cfcb9b-6bf0-4c81-9d5c-0d568400874b',
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
      'f21c76a0-8290-4778-ba19-04ad871cbf7c',
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
      '102d93bc-54f3-4b56-909c-6621d90194ce',
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
      '757b80ac-e3bb-4f5a-ab02-9efc66ae2e7d',
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
      '0278bdc3-b09c-497a-abde-07a2e4a61c72',
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
      'bc701130-8b90-450b-900d-180a1914da9f',
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
      '6c8f4024-1aba-482b-b25e-b5deeb30d544',
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
      '808b2129-728f-4606-89ad-b9f3ba87a8ce',
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
      '9da49e0f-ea74-42a6-b098-8a171fbe6aa4',
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
      '23f5ad39-c49c-45f5-95ef-5a7c7252c5dc',
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
      '99093a7e-e2bd-4ace-9566-fad445f12649',
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
      '759cc532-3454-488b-99ed-a8fdec3f41d8',
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
      '6802d341-da01-44e1-bf6c-c47353796d64',
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
      '0f29e201-60ff-469a-89ed-e11ab0981658',
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
      '65ecfc09-6640-44eb-ad18-6d8a0ac24a79',
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
      '254e7788-ce6f-40f0-a461-d075644cdcb8',
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
      'be6b1374-5d6c-4d4b-b702-9051b5355612',
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
      'e3bd08b1-617c-448f-8d80-835eac22b94b',
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
      'a5a7dbe4-8f61-4862-82ba-ff219c3d2641',
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
      '3dffbefd-dafb-4046-b4ce-4181aecc7c07',
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
      '5c1f2f8a-6181-4510-99ea-7d5941071af3',
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
      '865eb3e2-f44e-49cf-ba3d-25035e854d6f',
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
      'ca919039-7c77-4d66-b9ca-9b445ae3e86d',
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
      '4f402c73-08b5-46dd-9541-fc908bfeb6cc',
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
      'aa206492-382b-44dc-97b5-e4c8bfd3f404',
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
      '4ab426a9-4685-4313-891e-8f6c53a9414e',
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
      'b1e6e577-c530-43a1-bf15-7d7ccb6a5938',
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
      '9c3a37e2-4137-4825-ab9d-81f4255cdd0f',
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
      '8313b7c7-5024-4221-b4a0-a9f0a2b2fd52',
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
      '6505d7a4-a4c3-457f-b066-cb815b28121f',
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
      'd67eba77-3323-4a8c-be5d-f31e913ca6e7',
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
      '5201c7da-c809-486a-adc0-63768918b872',
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
      '24106da7-407c-479a-89e5-6645802af59b',
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
      'd01352e3-a471-46d2-ab4d-a42e86fe638f',
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
      'ed3f1e9a-c6f4-4088-920f-c4bdf0119d36',
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
      'd2180110-458d-4a5e-8226-e7214debc349',
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
      '12e4dacb-55dd-482f-bfeb-49ec5c490d1d',
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
