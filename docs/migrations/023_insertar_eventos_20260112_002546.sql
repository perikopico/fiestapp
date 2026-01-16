-- ============================================
-- SQL generado automáticamente para insertar eventos desde JSON
-- Fecha de generación: 2026-01-12T00:25:46.705871
-- Total de eventos: 64
-- Formato: INSERTs directos con imágenes secuenciales por categoría
-- ============================================

INSERT INTO public.events (id, title, place, maps_url, image_url, is_featured, is_free, starts_at, city_id, category_id, status, description, image_alignment) VALUES (
      '80803b43-abfe-4d44-aeed-7645d748f4c6',
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
      'Prueba exigente que combina el entramado urbano con senderos de la Sierra de Grazalema.',
      'center');

INSERT INTO public.events (id, title, place, maps_url, image_url, is_featured, is_free, starts_at, city_id, category_id, status, description, image_alignment) VALUES (
      'b4541430-6134-4caa-b63e-f3a8be58f143',
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
      'Cabeza de serie: Coro ''Al lío'' (Ceuta). Actúan: Comparsa ''La palabra de Cádiz'', Chirigota ''Los hombres de Paco'', Comparsa ''El Desguace''.',
      'center');

INSERT INTO public.events (id, title, place, maps_url, image_url, is_featured, is_free, starts_at, city_id, category_id, status, description, image_alignment) VALUES (
      'bd0bf459-4bdd-48a3-9002-807818ed4fad',
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
      'Cabeza de serie: Coro ''El sindicato''. Actúan: Chirigota ''Los ahumaos'', Comparsa ''Las lobas'', Cuarteto ''El despertar de la fuerza''.',
      'center');

INSERT INTO public.events (id, title, place, maps_url, image_url, is_featured, is_free, starts_at, city_id, category_id, status, description, image_alignment) VALUES (
      'cfb37de1-18a3-4b00-a9f0-fb4338dfc782',
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
      'Cabeza de serie: Coro ''Dame veneno''. Actúan: Comparsa ''Los del escondite'', Chirigota ''Nos hemos venío arriba'', Comparsa ''La moda de Cádiz''.',
      'center');

INSERT INTO public.events (id, title, place, maps_url, image_url, is_featured, is_free, starts_at, city_id, category_id, status, description, image_alignment) VALUES (
      'bff6db91-cb4f-497b-9a47-b8df80c63758',
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
      'Cabeza de serie: Comparsa ''La ciudad perfecta''. Actúan: Chirigota ''Cariño... vaya ambientazo'', Comparsa ''El manicomio''.',
      'center');

INSERT INTO public.events (id, title, place, maps_url, image_url, is_featured, is_free, starts_at, city_id, category_id, status, description, image_alignment) VALUES (
      '14ac9d1e-82a6-4aac-8bd6-ccdd9f5b83a2',
      'Andalucía Pre-Sunshine Tour (Semana 1)',
      'Dehesa Montenmedio, Vejer de la Frontera',
      'https://www.google.com/maps/search/?api=1&query=Dehesa+Montenmedio+Vejer',
      'https://oudofaiekedtaovrdqeo.supabase.co/storage/v1/object/public/sample-images/1/3/02.webp',
      FALSE,
      TRUE,
      '2026-01-15T09:00:00Z'::timestamptz,
      (SELECT id FROM public.cities WHERE LOWER(name) = LOWER('Vejer de la Frontera') LIMIT 1),
      (SELECT id FROM public.categories WHERE LOWER(slug) = 'deportes' LIMIT 1),
      'published',
      'Inicio de la temporada. Competición CSI2* y Caballos Jóvenes (5, 6 y 7 años).',
      'center');

INSERT INTO public.events (id, title, place, maps_url, image_url, is_featured, is_free, starts_at, city_id, category_id, status, description, image_alignment) VALUES (
      '95b0984c-887f-49a1-b4b8-b13f464ac958',
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
      'Cabeza de serie: Coro ''ADN''. Actúan: Chirigota ''Los Cadisapiens'', Comparsa ''La hipócrita'', Chirigota ''San taratachín''.',
      'center');

INSERT INTO public.events (id, title, place, maps_url, image_url, is_featured, is_free, starts_at, city_id, category_id, status, description, image_alignment) VALUES (
      'ee1e3c8f-fe10-4601-ad12-d1364a4fac0e',
      'Teatro: El Barbero de Picasso',
      'Teatro Villamarta, Jerez de la Frontera',
      'https://www.google.com/maps/search/?api=1&query=Teatro+Villamarta+Jerez',
      'https://oudofaiekedtaovrdqeo.supabase.co/storage/v1/object/public/sample-images/1/4/01.webp',
      FALSE,
      FALSE,
      '2026-01-16T20:00:00Z'::timestamptz,
      (SELECT id FROM public.cities WHERE LOWER(name) = LOWER('Jerez de la Frontera') LIMIT 1),
      (SELECT id FROM public.categories WHERE LOWER(slug) = 'arte-y-cultura' LIMIT 1),
      'published',
      'Con Antonio Molero y Pepe Viyuela. Drama y comedia histórica.',
      'center');

INSERT INTO public.events (id, title, place, maps_url, image_url, is_featured, is_free, starts_at, city_id, category_id, status, description, image_alignment) VALUES (
      'a20a79ce-2112-4180-bb9e-7c90c60c3f9b',
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
      'Cabeza de serie: Coro ''La Viña del mar''. Actúan: Comparsa ''El verdugo'', Cuarteto ''Crónica de una muerte'', Comparsa ''Cadirvana''.',
      'center');

INSERT INTO public.events (id, title, place, maps_url, image_url, is_featured, is_free, starts_at, city_id, category_id, status, description, image_alignment) VALUES (
      'e9c0f57a-53e6-4062-a3bd-c6aa7878167b',
      'Fiesta Universitaria: Welcome 2026',
      'Sala Momart Theatre, Cádiz (Punta de San Felipe)',
      'https://www.google.com/maps/search/?api=1&query=Sala+Momart+Cadiz',
      'https://oudofaiekedtaovrdqeo.supabase.co/storage/v1/object/public/sample-images/1/1/01.webp',
      FALSE,
      FALSE,
      '2026-01-16T23:59:00Z'::timestamptz,
      (SELECT id FROM public.cities WHERE LOWER(name) = LOWER('Cádiz') LIMIT 1),
      (SELECT id FROM public.categories WHERE LOWER(slug) = 'musica' LIMIT 1),
      'published',
      'Sesión DJ Hits & Reggaeton. Ambiente estudiantil.',
      'center');

INSERT INTO public.events (id, title, place, maps_url, image_url, is_featured, is_free, starts_at, city_id, category_id, status, description, image_alignment) VALUES (
      'bf91eddf-102c-434f-91a8-1d72132a0e92',
      'Sábados de Cuento: ''Historias de Invierno''',
      'Biblioteca Pública Provincial, Cádiz',
      'https://www.google.com/maps/search/?api=1&query=Biblioteca+Publica+Provincial+Cadiz',
      'https://oudofaiekedtaovrdqeo.supabase.co/storage/v1/object/public/sample-images/1/4/02.webp',
      FALSE,
      TRUE,
      '2026-01-17T12:00:00Z'::timestamptz,
      (SELECT id FROM public.cities WHERE LOWER(name) = LOWER('Cádiz') LIMIT 1),
      (SELECT id FROM public.categories WHERE LOWER(slug) = 'arte-y-cultura' LIMIT 1),
      'published',
      'Sesión de cuentacuentos infantil para fomentar la lectura.',
      'center');

INSERT INTO public.events (id, title, place, maps_url, image_url, is_featured, is_free, starts_at, city_id, category_id, status, description, image_alignment) VALUES (
      '369acfed-8c30-4e33-949f-ee1ccf8e3bda',
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
      'Cabeza de serie: Coro ''El reino de los cielos''. Actúan: Chirigota ''Los mohigangas'', Comparsa ''La camorra'', Cuarteto ''Los Latin King''.',
      'center');

INSERT INTO public.events (id, title, place, maps_url, image_url, is_featured, is_free, starts_at, city_id, category_id, status, description, image_alignment) VALUES (
      '508043d3-76dc-48a5-b497-d10f787510b5',
      'Homenaje a Triana (Miguel Zaguán Trío)',
      'La Guarida del Ángel, Jerez',
      'https://www.google.com/maps/search/?api=1&query=La+Guarida+del+Angel+Jerez',
      'https://oudofaiekedtaovrdqeo.supabase.co/storage/v1/object/public/sample-images/1/1/02.webp',
      FALSE,
      FALSE,
      '2026-01-17T23:00:00Z'::timestamptz,
      (SELECT id FROM public.cities WHERE LOWER(name) = LOWER('Jerez de la Frontera') LIMIT 1),
      (SELECT id FROM public.categories WHERE LOWER(slug) = 'musica' LIMIT 1),
      'published',
      'Tributo al rock andaluz.',
      'center');

INSERT INTO public.events (id, title, place, maps_url, image_url, is_featured, is_free, starts_at, city_id, category_id, status, description, image_alignment) VALUES (
      '34b94eeb-5956-4cf5-b9cd-638d0f1f820f',
      'El Rastro de Jerez',
      'Parque González Hontoria, Jerez',
      'https://www.google.com/maps/search/?api=1&query=Parque+Gonzalez+Hontoria+Jerez',
      'https://oudofaiekedtaovrdqeo.supabase.co/storage/v1/object/public/sample-images/1/7/01.webp',
      FALSE,
      TRUE,
      '2026-01-18T09:00:00Z'::timestamptz,
      (SELECT id FROM public.cities WHERE LOWER(name) = LOWER('Jerez de la Frontera') LIMIT 1),
      (SELECT id FROM public.categories WHERE LOWER(slug) = 'mercadillos' LIMIT 1),
      'published',
      'El gran mercado de antigüedades y segunda mano.',
      'center');

INSERT INTO public.events (id, title, place, maps_url, image_url, is_featured, is_free, starts_at, city_id, category_id, status, description, image_alignment) VALUES (
      '44f4fc0f-3637-4862-8dde-cfd5c97634cb',
      'Mercadillo de Sotogrande (Domingo)',
      'Ribera del Marlín, Sotogrande',
      'https://www.google.com/maps/search/?api=1&query=Mercadillo+Sotogrande',
      'https://oudofaiekedtaovrdqeo.supabase.co/storage/v1/object/public/sample-images/1/7/02.webp',
      FALSE,
      TRUE,
      '2026-01-18T10:00:00Z'::timestamptz,
      (SELECT id FROM public.cities WHERE LOWER(name) = LOWER('Sotogrande') LIMIT 1),
      (SELECT id FROM public.categories WHERE LOWER(slug) = 'mercadillos' LIMIT 1),
      'published',
      'Exclusivo mercado de artesanía y moda en la marina.',
      'center');

INSERT INTO public.events (id, title, place, maps_url, image_url, is_featured, is_free, starts_at, city_id, category_id, status, description, image_alignment) VALUES (
      'ad1a9599-300c-4b65-9853-743bed8632b9',
      'Fútbol: Xerez CD vs UCAM Murcia',
      'Estadio Chapín, Jerez de la Frontera',
      'https://www.google.com/maps/search/?api=1&query=Estadio+Chapin+Jerez',
      'https://oudofaiekedtaovrdqeo.supabase.co/storage/v1/object/public/sample-images/1/3/03.webp',
      FALSE,
      FALSE,
      '2026-01-18T17:00:00Z'::timestamptz,
      (SELECT id FROM public.cities WHERE LOWER(name) = LOWER('Jerez de la Frontera') LIMIT 1),
      (SELECT id FROM public.categories WHERE LOWER(slug) = 'deportes' LIMIT 1),
      'published',
      'Partidazo de Segunda Federación.',
      'center');

INSERT INTO public.events (id, title, place, maps_url, image_url, is_featured, is_free, starts_at, city_id, category_id, status, description, image_alignment) VALUES (
      '27c503fc-51db-420a-8e41-37ccfb4dfb09',
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
      'Cabeza de serie: Coro ''La carnicería''. Actúan: Comparsa ''Las muñecas'', Coro ''Los caletarios'', Chirigota ''Los niños con nombre''.',
      'center');

INSERT INTO public.events (id, title, place, maps_url, image_url, is_featured, is_free, starts_at, city_id, category_id, status, description, image_alignment) VALUES (
      '467954ab-8b7c-4f69-b251-d109816f4bf9',
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
      'Cabeza de serie: Comparsa ''La marinera''. Actúan: Chirigota ''Los que se lo llevan calentito'', Comparsa ''El patriota''.',
      'center');

INSERT INTO public.events (id, title, place, maps_url, image_url, is_featured, is_free, starts_at, city_id, category_id, status, description, image_alignment) VALUES (
      'bf7c1831-1eae-4bcf-b6ae-bc09eb91e3ec',
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
      'Cabeza de serie: Coro ''Café Puerto América''. Actúan: Chirigota ''Tu cara me suena'', Comparsa ''El vecindario'', Chirigota ''La viña de mis ojos''.',
      'center');

INSERT INTO public.events (id, title, place, maps_url, image_url, is_featured, is_free, starts_at, city_id, category_id, status, description, image_alignment) VALUES (
      '9ed49b9f-d006-425f-9d97-40a22fe27fc1',
      'Inauguración Pasarela Flamenca Tío Pepe 2026',
      'Bodegas González Byass, Jerez de la Frontera',
      'https://www.google.com/maps/search/?api=1&query=Bodegas+Gonzalez+Byass+Jerez',
      'https://oudofaiekedtaovrdqeo.supabase.co/storage/v1/object/public/sample-images/1/6/02.webp',
      FALSE,
      FALSE,
      '2026-01-21T18:00:00Z'::timestamptz,
      (SELECT id FROM public.cities WHERE LOWER(name) = LOWER('Jerez de la Frontera') LIMIT 1),
      (SELECT id FROM public.categories WHERE LOWER(slug) = 'tradiciones' LIMIT 1),
      'published',
      'Desfile inaugural Innova Flamenca en Bodegas González Byass.',
      'center');

INSERT INTO public.events (id, title, place, maps_url, image_url, is_featured, is_free, starts_at, city_id, category_id, status, description, image_alignment) VALUES (
      'ecac5789-08e3-4766-89f1-a612011b13b3',
      'Andalucía Pre-Sunshine Tour (Semana 2)',
      'Dehesa Montenmedio, Vejer de la Frontera',
      'https://www.google.com/maps/search/?api=1&query=Dehesa+Montenmedio+Vejer',
      'https://oudofaiekedtaovrdqeo.supabase.co/storage/v1/object/public/sample-images/1/3/04.webp',
      FALSE,
      TRUE,
      '2026-01-22T09:00:00Z'::timestamptz,
      (SELECT id FROM public.cities WHERE LOWER(name) = LOWER('Vejer de la Frontera') LIMIT 1),
      (SELECT id FROM public.categories WHERE LOWER(slug) = 'deportes' LIMIT 1),
      'published',
      'Salto de obstáculos. Competición CSI3* (Mayor nivel que la semana anterior).',
      'center');

INSERT INTO public.events (id, title, place, maps_url, image_url, is_featured, is_free, starts_at, city_id, category_id, status, description, image_alignment) VALUES (
      'f6bb1f75-4d48-4779-8a91-d4250d290370',
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
      'Cabeza de serie: Coro ''Las gladitanas''. Actúan: Comparsa ''OBDC me quedo contigo'', Cuarteto ''¡Que vengan!'', Comparsa ''Los hijos de Cádiz''.',
      'center');

INSERT INTO public.events (id, title, place, maps_url, image_url, is_featured, is_free, starts_at, city_id, category_id, status, description, image_alignment) VALUES (
      'a5ab54b4-417b-4f22-8c6e-3e8f4fab57b1',
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
      'Noche fuerte. Agrupaciones esperadas: Comparsa ''El joyero'' (David Carapapa) y Chirigota ''Los del verdadero cambio''.',
      'center');

INSERT INTO public.events (id, title, place, maps_url, image_url, is_featured, is_free, starts_at, city_id, category_id, status, description, image_alignment) VALUES (
      '0effef1f-a1c8-4124-84fc-02218172935a',
      'GT Winter Series (Día 1)',
      'Circuito de Jerez-Ángel Nieto, Jerez',
      'https://www.google.com/maps/search/?api=1&query=Circuito+de+Jerez',
      'https://oudofaiekedtaovrdqeo.supabase.co/storage/v1/object/public/sample-images/1/3/05.webp',
      FALSE,
      TRUE,
      '2026-01-24T09:00:00Z'::timestamptz,
      (SELECT id FROM public.cities WHERE LOWER(name) = LOWER('Jerez de la Frontera') LIMIT 1),
      (SELECT id FROM public.categories WHERE LOWER(slug) = 'deportes' LIMIT 1),
      'published',
      'Entrenamientos y clasificación. Automovilismo.',
      'center');

INSERT INTO public.events (id, title, place, maps_url, image_url, is_featured, is_free, starts_at, city_id, category_id, status, description, image_alignment) VALUES (
      '5b0b60d2-8ad4-410d-8874-e495412c0e18',
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
      'Cabeza de serie: Coro ''La esencia''. Actúan: Comparsa ''Lxs Invencibles'', Chirigota ''Las bodas de plata'', Cuarteto ''La pandilla inclusiva''.',
      'center');

INSERT INTO public.events (id, title, place, maps_url, image_url, is_featured, is_free, starts_at, city_id, category_id, status, description, image_alignment) VALUES (
      '3fdebc60-a444-4628-a2f9-afb2d636bd31',
      'Fútbol: Cádiz CF vs Granada CF',
      'Estadio Nuevo Mirandilla, Cádiz',
      'https://www.google.com/maps/search/?api=1&query=Estadio+Nuevo+Mirandilla+Cadiz',
      'https://oudofaiekedtaovrdqeo.supabase.co/storage/v1/object/public/sample-images/1/3/06.webp',
      FALSE,
      FALSE,
      '2026-01-24T21:00:00Z'::timestamptz,
      (SELECT id FROM public.cities WHERE LOWER(name) = LOWER('Cádiz') LIMIT 1),
      (SELECT id FROM public.categories WHERE LOWER(slug) = 'deportes' LIMIT 1),
      'published',
      'DERBI ANDALUZ. LaLiga Hypermotion (Jornada 23).',
      'center');

INSERT INTO public.events (id, title, place, maps_url, image_url, is_featured, is_free, starts_at, city_id, category_id, status, description, image_alignment) VALUES (
      '83801aa0-3de6-4b07-b037-bf43c7786d3f',
      'GT Winter Series (Día 2 - Carreras)',
      'Circuito de Jerez-Ángel Nieto, Jerez',
      'https://www.google.com/maps/search/?api=1&query=Circuito+de+Jerez',
      'https://oudofaiekedtaovrdqeo.supabase.co/storage/v1/object/public/sample-images/1/3/07.webp',
      FALSE,
      TRUE,
      '2026-01-25T09:00:00Z'::timestamptz,
      (SELECT id FROM public.cities WHERE LOWER(name) = LOWER('Jerez de la Frontera') LIMIT 1),
      (SELECT id FROM public.categories WHERE LOWER(slug) = 'deportes' LIMIT 1),
      'published',
      'Carreras finales de GTs y prototipos.',
      'center');

INSERT INTO public.events (id, title, place, maps_url, image_url, is_featured, is_free, starts_at, city_id, category_id, status, description, image_alignment) VALUES (
      'f1f6bef6-38e3-481c-a803-4111b128617e',
      'XXXIX Ostionada Popular',
      'Plaza de San Antonio, Cádiz',
      'https://www.google.com/maps/search/?api=1&query=Plaza+San+Antonio+Cadiz',
      'https://oudofaiekedtaovrdqeo.supabase.co/storage/v1/object/public/sample-images/1/2/01.webp',
      FALSE,
      TRUE,
      '2026-01-25T13:30:00Z'::timestamptz,
      (SELECT id FROM public.cities WHERE LOWER(name) = LOWER('Cádiz') LIMIT 1),
      (SELECT id FROM public.categories WHERE LOWER(slug) = 'gastronomia' LIMIT 1),
      'published',
      'Reparto gratuito de ostiones y pimientos con coros de carnaval.',
      'center');

INSERT INTO public.events (id, title, place, maps_url, image_url, is_featured, is_free, starts_at, city_id, category_id, status, description, image_alignment) VALUES (
      '56b6af7e-1893-4a8a-96c3-e9c80d6fba6a',
      'COAC 2026: Preliminares (Sesión 16)',
      'Gran Teatro Falla, Cádiz',
      'https://www.google.com/maps/search/?api=1&query=Gran+Teatro+Falla+Cadiz',
      'https://oudofaiekedtaovrdqeo.supabase.co/storage/v1/object/public/sample-images/1/6/06.webp',
      FALSE,
      FALSE,
      '2026-01-26T20:00:00Z'::timestamptz,
      (SELECT id FROM public.cities WHERE LOWER(name) = LOWER('Cádiz') LIMIT 1),
      (SELECT id FROM public.categories WHERE LOWER(slug) = 'tradiciones' LIMIT 1),
      'published',
      'Cabeza de serie: Coro ''Al garete''. Actúan: Comparsa ''La carne-vale'', Chirigota ''L@s quince en las algas'', Comparsa ''La biblioteca''.',
      'center');

INSERT INTO public.events (id, title, place, maps_url, image_url, is_featured, is_free, starts_at, city_id, category_id, status, description, image_alignment) VALUES (
      'b55463d7-c60b-4ac6-b768-0f9a310683c3',
      'COAC 2026: Preliminares (Última Sesión)',
      'Gran Teatro Falla, Cádiz',
      'https://www.google.com/maps/search/?api=1&query=Gran+Teatro+Falla+Cadiz',
      'https://oudofaiekedtaovrdqeo.supabase.co/storage/v1/object/public/sample-images/1/6/07.webp',
      FALSE,
      FALSE,
      '2026-01-27T20:00:00Z'::timestamptz,
      (SELECT id FROM public.cities WHERE LOWER(name) = LOWER('Cádiz') LIMIT 1),
      (SELECT id FROM public.categories WHERE LOWER(slug) = 'tradiciones' LIMIT 1),
      'published',
      'Cierre de preliminares. Actuación del Coro ''Los iluminados'' y fallo del jurado de madrugada.',
      'center');

INSERT INTO public.events (id, title, place, maps_url, image_url, is_featured, is_free, starts_at, city_id, category_id, status, description, image_alignment) VALUES (
      'b5c769f6-ea1b-4ebd-a821-78b10a9804c4',
      'COAC 2026: Cuartos de Final (Sesión 1)',
      'Gran Teatro Falla, Cádiz',
      'https://www.google.com/maps/search/?api=1&query=Gran+Teatro+Falla+Cadiz',
      'https://oudofaiekedtaovrdqeo.supabase.co/storage/v1/object/public/sample-images/1/6/08.webp',
      FALSE,
      FALSE,
      '2026-01-30T20:00:00Z'::timestamptz,
      (SELECT id FROM public.cities WHERE LOWER(name) = LOWER('Cádiz') LIMIT 1),
      (SELECT id FROM public.categories WHERE LOWER(slug) = 'tradiciones' LIMIT 1),
      'published',
      'Inicio de la fase de plata. Actúan las 7 primeras agrupaciones clasificadas.',
      'center');

INSERT INTO public.events (id, title, place, maps_url, image_url, is_featured, is_free, starts_at, city_id, category_id, status, description, image_alignment) VALUES (
      '7271558d-2a03-429b-8c07-9182aacb10f3',
      'Pregón Infantil del Carnaval 2026',
      'Plaza de San Antonio, Cádiz',
      'https://www.google.com/maps/search/?api=1&query=Plaza+San+Antonio+Cadiz',
      'https://oudofaiekedtaovrdqeo.supabase.co/storage/v1/object/public/sample-images/1/6/09.webp',
      FALSE,
      TRUE,
      '2026-01-31T12:00:00Z'::timestamptz,
      (SELECT id FROM public.cities WHERE LOWER(name) = LOWER('Cádiz') LIMIT 1),
      (SELECT id FROM public.categories WHERE LOWER(slug) = 'tradiciones' LIMIT 1),
      'published',
      'Acto oficial donde los niños inauguran su propia fiesta.',
      'center');

INSERT INTO public.events (id, title, place, maps_url, image_url, is_featured, is_free, starts_at, city_id, category_id, status, description, image_alignment) VALUES (
      '70a7f4e7-7cb0-4b1a-9936-9c840275f1f7',
      'COAC 2026: Cuartos de Final (Sesión 2)',
      'Gran Teatro Falla, Cádiz',
      'https://www.google.com/maps/search/?api=1&query=Gran+Teatro+Falla+Cadiz',
      'https://oudofaiekedtaovrdqeo.supabase.co/storage/v1/object/public/sample-images/1/6/01.webp',
      FALSE,
      FALSE,
      '2026-01-31T20:00:00Z'::timestamptz,
      (SELECT id FROM public.cities WHERE LOWER(name) = LOWER('Cádiz') LIMIT 1),
      (SELECT id FROM public.categories WHERE LOWER(slug) = 'tradiciones' LIMIT 1),
      'published',
      'Segunda sesión de cuartos. 8 agrupaciones en concurso.',
      'center');

INSERT INTO public.events (id, title, place, maps_url, image_url, is_featured, is_free, starts_at, city_id, category_id, status, description, image_alignment) VALUES (
      '796a8d12-051d-4984-88ac-1edd840c14b3',
      'Fútbol: At. Sanluqueño vs Betis Deportivo',
      'Estadio El Palmar, Sanlúcar de Barrameda',
      'https://www.google.com/maps/search/?api=1&query=Estadio+El+Palmar+Sanlucar',
      'https://oudofaiekedtaovrdqeo.supabase.co/storage/v1/object/public/sample-images/1/3/08.webp',
      FALSE,
      FALSE,
      '2026-02-01T12:00:00Z'::timestamptz,
      (SELECT id FROM public.cities WHERE LOWER(name) = LOWER('Sanlúcar de Barrameda') LIMIT 1),
      (SELECT id FROM public.categories WHERE LOWER(slug) = 'deportes' LIMIT 1),
      'published',
      'Primera Federación. Duelo de filiales y canteras.',
      'center');

INSERT INTO public.events (id, title, place, maps_url, image_url, is_featured, is_free, starts_at, city_id, category_id, status, description, image_alignment) VALUES (
      '645d75d6-34d5-46f7-af19-e6e6deba05e0',
      'XLIV Erizada Popular',
      'Calle de la Palma, Cádiz',
      'https://www.google.com/maps/search/?api=1&query=Calle+de+la+Palma+Cadiz',
      'https://oudofaiekedtaovrdqeo.supabase.co/storage/v1/object/public/sample-images/1/2/02.webp',
      FALSE,
      TRUE,
      '2026-02-01T13:30:00Z'::timestamptz,
      (SELECT id FROM public.cities WHERE LOWER(name) = LOWER('Cádiz') LIMIT 1),
      (SELECT id FROM public.categories WHERE LOWER(slug) = 'gastronomia' LIMIT 1),
      'published',
      'Degustación de erizos de mar en el Barrio de la Viña.',
      'center');

INSERT INTO public.events (id, title, place, maps_url, image_url, is_featured, is_free, starts_at, city_id, category_id, status, description, image_alignment) VALUES (
      '8c6b396d-d60f-4918-abf1-48d34fe2863b',
      'COAC 2026: Cuartos de Final (Sesión 3)',
      'Gran Teatro Falla, Cádiz',
      'https://www.google.com/maps/search/?api=1&query=Gran+Teatro+Falla+Cadiz',
      'https://oudofaiekedtaovrdqeo.supabase.co/storage/v1/object/public/sample-images/1/6/02.webp',
      FALSE,
      FALSE,
      '2026-02-01T20:00:00Z'::timestamptz,
      (SELECT id FROM public.cities WHERE LOWER(name) = LOWER('Cádiz') LIMIT 1),
      (SELECT id FROM public.categories WHERE LOWER(slug) = 'tradiciones' LIMIT 1),
      'published',
      'Tercera sesión de cuartos (Domingo).',
      'center');

INSERT INTO public.events (id, title, place, maps_url, image_url, is_featured, is_free, starts_at, city_id, category_id, status, description, image_alignment) VALUES (
      '8c22e89f-5600-4c88-9ad4-00cace376aa2',
      'COAC 2026: Cuartos de Final (Sesión 4)',
      'Gran Teatro Falla, Cádiz',
      'https://www.google.com/maps/search/?api=1&query=Gran+Teatro+Falla+Cadiz',
      'https://oudofaiekedtaovrdqeo.supabase.co/storage/v1/object/public/sample-images/1/6/03.webp',
      FALSE,
      FALSE,
      '2026-02-02T20:00:00Z'::timestamptz,
      (SELECT id FROM public.cities WHERE LOWER(name) = LOWER('Cádiz') LIMIT 1),
      (SELECT id FROM public.categories WHERE LOWER(slug) = 'tradiciones' LIMIT 1),
      'published',
      'Cuarta sesión de cuartos.',
      'center');

INSERT INTO public.events (id, title, place, maps_url, image_url, is_featured, is_free, starts_at, city_id, category_id, status, description, image_alignment) VALUES (
      '14e57af9-a84f-4f00-b26a-bd912321f1a8',
      'Andalucía Sunshine Tour (Semana 1 - CSI4*)',
      'Dehesa Montenmedio, Vejer de la Frontera',
      'https://www.google.com/maps/search/?api=1&query=Dehesa+Montenmedio+Vejer',
      'https://oudofaiekedtaovrdqeo.supabase.co/storage/v1/object/public/sample-images/1/3/09.webp',
      FALSE,
      TRUE,
      '2026-02-03T09:00:00Z'::timestamptz,
      (SELECT id FROM public.cities WHERE LOWER(name) = LOWER('Vejer de la Frontera') LIMIT 1),
      (SELECT id FROM public.categories WHERE LOWER(slug) = 'deportes' LIMIT 1),
      'published',
      'Inicio del circuito grande. CSI4*, CSI1* y Caballos Jóvenes.',
      'center');

INSERT INTO public.events (id, title, place, maps_url, image_url, is_featured, is_free, starts_at, city_id, category_id, status, description, image_alignment) VALUES (
      '0ce7cb3a-5d71-44ee-801c-f55dee181722',
      'COAC 2026: Cuartos de Final (Sesión 5)',
      'Gran Teatro Falla, Cádiz',
      'https://www.google.com/maps/search/?api=1&query=Gran+Teatro+Falla+Cadiz',
      'https://oudofaiekedtaovrdqeo.supabase.co/storage/v1/object/public/sample-images/1/6/04.webp',
      FALSE,
      FALSE,
      '2026-02-03T20:00:00Z'::timestamptz,
      (SELECT id FROM public.cities WHERE LOWER(name) = LOWER('Cádiz') LIMIT 1),
      (SELECT id FROM public.categories WHERE LOWER(slug) = 'tradiciones' LIMIT 1),
      'published',
      'Quinta sesión de cuartos.',
      'center');

INSERT INTO public.events (id, title, place, maps_url, image_url, is_featured, is_free, starts_at, city_id, category_id, status, description, image_alignment) VALUES (
      '14cf2f84-1c17-4ffe-a503-cf8e22e5573a',
      'COAC 2026: Cuartos de Final (Sesión 6)',
      'Gran Teatro Falla, Cádiz',
      'https://www.google.com/maps/search/?api=1&query=Gran+Teatro+Falla+Cadiz',
      'https://oudofaiekedtaovrdqeo.supabase.co/storage/v1/object/public/sample-images/1/6/05.webp',
      FALSE,
      FALSE,
      '2026-02-04T20:00:00Z'::timestamptz,
      (SELECT id FROM public.cities WHERE LOWER(name) = LOWER('Cádiz') LIMIT 1),
      (SELECT id FROM public.categories WHERE LOWER(slug) = 'tradiciones' LIMIT 1),
      'published',
      'Sexta sesión de cuartos.',
      'center');

INSERT INTO public.events (id, title, place, maps_url, image_url, is_featured, is_free, starts_at, city_id, category_id, status, description, image_alignment) VALUES (
      '48e2557d-277b-4927-971c-5a92285e7239',
      'COAC 2026: Cuartos de Final (Última Sesión)',
      'Gran Teatro Falla, Cádiz',
      'https://www.google.com/maps/search/?api=1&query=Gran+Teatro+Falla+Cadiz',
      'https://oudofaiekedtaovrdqeo.supabase.co/storage/v1/object/public/sample-images/1/6/06.webp',
      FALSE,
      FALSE,
      '2026-02-05T20:00:00Z'::timestamptz,
      (SELECT id FROM public.cities WHERE LOWER(name) = LOWER('Cádiz') LIMIT 1),
      (SELECT id FROM public.categories WHERE LOWER(slug) = 'tradiciones' LIMIT 1),
      'published',
      'Cierre de fase y fallo del jurado (Paso a Semifinales).',
      'center');

INSERT INTO public.events (id, title, place, maps_url, image_url, is_featured, is_free, starts_at, city_id, category_id, status, description, image_alignment) VALUES (
      '2cdce4c5-cc87-407c-90f0-1979b21c3a08',
      'Teatro: Los Lunes al Sol',
      'Teatro Villamarta, Jerez de la Frontera',
      'https://www.google.com/maps/search/?api=1&query=Teatro+Villamarta+Jerez',
      'https://oudofaiekedtaovrdqeo.supabase.co/storage/v1/object/public/sample-images/1/4/03.webp',
      FALSE,
      FALSE,
      '2026-02-06T20:00:00Z'::timestamptz,
      (SELECT id FROM public.cities WHERE LOWER(name) = LOWER('Jerez de la Frontera') LIMIT 1),
      (SELECT id FROM public.categories WHERE LOWER(slug) = 'arte-y-cultura' LIMIT 1),
      'published',
      'Adaptación teatral de la película.',
      'center');

INSERT INTO public.events (id, title, place, maps_url, image_url, is_featured, is_free, starts_at, city_id, category_id, status, description, image_alignment) VALUES (
      '32a74c40-d508-4516-8e2a-4d5a19018a20',
      'Tributo El Último de la Fila (Los Hombres Rana)',
      'La Guarida del Ángel, Jerez',
      'https://www.google.com/maps/search/?api=1&query=La+Guarida+del+Angel+Jerez',
      'https://oudofaiekedtaovrdqeo.supabase.co/storage/v1/object/public/sample-images/1/1/03.webp',
      FALSE,
      FALSE,
      '2026-02-07T22:00:00Z'::timestamptz,
      (SELECT id FROM public.cities WHERE LOWER(name) = LOWER('Jerez de la Frontera') LIMIT 1),
      (SELECT id FROM public.categories WHERE LOWER(slug) = 'musica' LIMIT 1),
      'published',
      'Pop Rock español.',
      'center');

INSERT INTO public.events (id, title, place, maps_url, image_url, is_featured, is_free, starts_at, city_id, category_id, status, description, image_alignment) VALUES (
      '7909e03a-6f03-4979-8b89-de44ac7c5949',
      'XXV Gambada Popular',
      'Peña La Perla de Cádiz',
      'https://www.google.com/maps/search/?api=1&query=Peña+La+Perla+de+Cadiz',
      'https://oudofaiekedtaovrdqeo.supabase.co/storage/v1/object/public/sample-images/1/2/03.webp',
      FALSE,
      TRUE,
      '2026-02-08T13:30:00Z'::timestamptz,
      (SELECT id FROM public.cities WHERE LOWER(name) = LOWER('Cádiz') LIMIT 1),
      (SELECT id FROM public.categories WHERE LOWER(slug) = 'gastronomia' LIMIT 1),
      'published',
      'Degustación de gambas.',
      'center');

INSERT INTO public.events (id, title, place, maps_url, image_url, is_featured, is_free, starts_at, city_id, category_id, status, description, image_alignment) VALUES (
      '70ee400b-9b19-46a0-a7c0-86ff2a3379fe',
      'Fútbol: Cádiz CF vs UD Almería',
      'Estadio Nuevo Mirandilla, Cádiz',
      'https://www.google.com/maps/search/?api=1&query=Estadio+Nuevo+Mirandilla+Cadiz',
      'https://oudofaiekedtaovrdqeo.supabase.co/storage/v1/object/public/sample-images/1/3/10.webp',
      FALSE,
      FALSE,
      '2026-02-08T16:15:00Z'::timestamptz,
      (SELECT id FROM public.cities WHERE LOWER(name) = LOWER('Cádiz') LIMIT 1),
      (SELECT id FROM public.categories WHERE LOWER(slug) = 'deportes' LIMIT 1),
      'published',
      'LaLiga Hypermotion (Jornada 25).',
      'center');

INSERT INTO public.events (id, title, place, maps_url, image_url, is_featured, is_free, starts_at, city_id, category_id, status, description, image_alignment) VALUES (
      '54f3a95e-aa6b-438a-8a88-d337b5537614',
      'Andalucía Sunshine Tour (Semana 2 - Inicio)',
      'Dehesa Montenmedio, Vejer de la Frontera',
      'https://www.google.com/maps/search/?api=1&query=Dehesa+Montenmedio+Vejer',
      'https://oudofaiekedtaovrdqeo.supabase.co/storage/v1/object/public/sample-images/1/3/11.webp',
      FALSE,
      TRUE,
      '2026-02-10T09:00:00Z'::timestamptz,
      (SELECT id FROM public.cities WHERE LOWER(name) = LOWER('Vejer de la Frontera') LIMIT 1),
      (SELECT id FROM public.categories WHERE LOWER(slug) = 'deportes' LIMIT 1),
      'published',
      'Inicio de la segunda semana grande. CSI4*, CSI1* y YH.',
      'center');

INSERT INTO public.events (id, title, place, maps_url, image_url, is_featured, is_free, starts_at, city_id, category_id, status, description, image_alignment) VALUES (
      '8e5699fc-815c-471d-92b1-03162676703d',
      'Encendido Alumbrado de Carnaval',
      'Plaza de San Antonio, Cádiz',
      'https://www.google.com/maps/search/?api=1&query=Plaza+San+Antonio+Cadiz',
      'https://oudofaiekedtaovrdqeo.supabase.co/storage/v1/object/public/sample-images/1/6/07.webp',
      FALSE,
      TRUE,
      '2026-02-12T20:00:00Z'::timestamptz,
      (SELECT id FROM public.cities WHERE LOWER(name) = LOWER('Cádiz') LIMIT 1),
      (SELECT id FROM public.categories WHERE LOWER(slug) = 'tradiciones' LIMIT 1),
      'published',
      'Inicio oficial de la fiesta en la calle.',
      'center');

INSERT INTO public.events (id, title, place, maps_url, image_url, is_featured, is_free, starts_at, city_id, category_id, status, description, image_alignment) VALUES (
      '53941bf3-c0ab-4db5-b506-dd4051ac709b',
      'Gran Final del COAC 2026',
      'Gran Teatro Falla, Cádiz',
      'https://www.google.com/maps/search/?api=1&query=Gran+Teatro+Falla+Cadiz',
      'https://oudofaiekedtaovrdqeo.supabase.co/storage/v1/object/public/sample-images/1/6/08.webp',
      FALSE,
      FALSE,
      '2026-02-13T20:00:00Z'::timestamptz,
      (SELECT id FROM public.cities WHERE LOWER(name) = LOWER('Cádiz') LIMIT 1),
      (SELECT id FROM public.categories WHERE LOWER(slug) = 'tradiciones' LIMIT 1),
      'published',
      'La noche más importante. Actúan los finalistas de Coros, Comparsas, Chirigotas y Cuartetos.',
      'center');

INSERT INTO public.events (id, title, place, maps_url, image_url, is_featured, is_free, starts_at, city_id, category_id, status, description, image_alignment) VALUES (
      '00e3b91d-9e86-446a-b39c-62ce5b19ef1b',
      'Pregón del Carnaval (Manu Sánchez)',
      'Plaza de San Antonio, Cádiz',
      'https://www.google.com/maps/search/?api=1&query=Plaza+San+Antonio+Cadiz',
      'https://oudofaiekedtaovrdqeo.supabase.co/storage/v1/object/public/sample-images/1/6/09.webp',
      FALSE,
      TRUE,
      '2026-02-14T22:00:00Z'::timestamptz,
      (SELECT id FROM public.cities WHERE LOWER(name) = LOWER('Cádiz') LIMIT 1),
      (SELECT id FROM public.categories WHERE LOWER(slug) = 'tradiciones' LIMIT 1),
      'published',
      'Acto oficial en la plaza principal.',
      'center');

INSERT INTO public.events (id, title, place, maps_url, image_url, is_featured, is_free, starts_at, city_id, category_id, status, description, image_alignment) VALUES (
      'baa4456d-b069-4b64-af6c-d56c575abd66',
      'Carrusel de Coros: Mercado Central',
      'Mercado Central de Abastos, Cádiz',
      'https://www.google.com/maps/search/?api=1&query=Mercado+Central+Cadiz',
      'https://oudofaiekedtaovrdqeo.supabase.co/storage/v1/object/public/sample-images/1/6/01.webp',
      FALSE,
      TRUE,
      '2026-02-15T13:00:00Z'::timestamptz,
      (SELECT id FROM public.cities WHERE LOWER(name) = LOWER('Cádiz') LIMIT 1),
      (SELECT id FROM public.categories WHERE LOWER(slug) = 'tradiciones' LIMIT 1),
      'published',
      'Domingo de Coros. Los coros cantan en bateas alrededor del mercado.',
      'center');

INSERT INTO public.events (id, title, place, maps_url, image_url, is_featured, is_free, starts_at, city_id, category_id, status, description, image_alignment) VALUES (
      '35a3c4ce-3d7c-47b8-b580-68e087612e20',
      'Gran Cabalgata Magna',
      'Avenida Andalucía, Cádiz',
      'https://www.google.com/maps/search/?api=1&query=Avenida+Andalucia+Cadiz',
      'https://oudofaiekedtaovrdqeo.supabase.co/storage/v1/object/public/sample-images/1/6/02.webp',
      FALSE,
      TRUE,
      '2026-02-15T17:00:00Z'::timestamptz,
      (SELECT id FROM public.cities WHERE LOWER(name) = LOWER('Cádiz') LIMIT 1),
      (SELECT id FROM public.categories WHERE LOWER(slug) = 'tradiciones' LIMIT 1),
      'published',
      'Desfile de carrozas y agrupaciones por la Avenida Principal.',
      'center');

INSERT INTO public.events (id, title, place, maps_url, image_url, is_featured, is_free, starts_at, city_id, category_id, status, description, image_alignment) VALUES (
      'b9fe4398-0119-46bc-9199-ea1abfddbf9f',
      'Carrusel de Coros: La Viña',
      'Calle de la Palma / Barrio de la Viña, Cádiz',
      'https://www.google.com/maps/search/?api=1&query=Barrio+de+la+Vina+Cadiz',
      'https://oudofaiekedtaovrdqeo.supabase.co/storage/v1/object/public/sample-images/1/6/03.webp',
      FALSE,
      TRUE,
      '2026-02-16T13:00:00Z'::timestamptz,
      (SELECT id FROM public.cities WHERE LOWER(name) = LOWER('Cádiz') LIMIT 1),
      (SELECT id FROM public.categories WHERE LOWER(slug) = 'tradiciones' LIMIT 1),
      'published',
      'Lunes de Coros. Carrusel más íntimo en el barrio de La Viña.',
      'center');

INSERT INTO public.events (id, title, place, maps_url, image_url, is_featured, is_free, starts_at, city_id, category_id, status, description, image_alignment) VALUES (
      'c4188df9-faf0-4a6b-acaf-4667ed19fd22',
      'Andalucía Sunshine Tour (Semana 3 - Inicio)',
      'Dehesa Montenmedio, Vejer de la Frontera',
      'https://www.google.com/maps/search/?api=1&query=Dehesa+Montenmedio+Vejer',
      'https://oudofaiekedtaovrdqeo.supabase.co/storage/v1/object/public/sample-images/1/3/12.webp',
      FALSE,
      TRUE,
      '2026-02-17T09:00:00Z'::timestamptz,
      (SELECT id FROM public.cities WHERE LOWER(name) = LOWER('Vejer de la Frontera') LIMIT 1),
      (SELECT id FROM public.categories WHERE LOWER(slug) = 'deportes' LIMIT 1),
      'published',
      'CSI4*, CSI1* y Caballos Jóvenes.',
      'center');

INSERT INTO public.events (id, title, place, maps_url, image_url, is_featured, is_free, starts_at, city_id, category_id, status, description, image_alignment) VALUES (
      '292baa8f-6e1a-49fb-97b2-0f48c3374aec',
      'Festival de Jerez: Manuela Carpio',
      'Teatro Villamarta, Jerez de la Frontera',
      'https://www.google.com/maps/search/?api=1&query=Teatro+Villamarta+Jerez',
      'https://oudofaiekedtaovrdqeo.supabase.co/storage/v1/object/public/sample-images/1/4/04.webp',
      FALSE,
      FALSE,
      '2026-02-20T20:30:00Z'::timestamptz,
      (SELECT id FROM public.cities WHERE LOWER(name) = LOWER('Jerez de la Frontera') LIMIT 1),
      (SELECT id FROM public.categories WHERE LOWER(slug) = 'arte-y-cultura' LIMIT 1),
      'published',
      'Inauguración oficial. Espectáculo de baile flamenco.',
      'center');

INSERT INTO public.events (id, title, place, maps_url, image_url, is_featured, is_free, starts_at, city_id, category_id, status, description, image_alignment) VALUES (
      '31a4af89-dd9d-499a-8654-ed052db3cc5d',
      'DERBI Futsal: CD Virgili Cádiz vs Xerez Toyota',
      'Complejo Deportivo Ciudad de Cádiz, Cádiz',
      'https://www.google.com/maps/search/?api=1&query=Complejo+Deportivo+Ciudad+de+Cadiz',
      'https://oudofaiekedtaovrdqeo.supabase.co/storage/v1/object/public/sample-images/1/3/13.webp',
      FALSE,
      FALSE,
      '2026-02-21T18:30:00Z'::timestamptz,
      (SELECT id FROM public.cities WHERE LOWER(name) = LOWER('Cádiz') LIMIT 1),
      (SELECT id FROM public.categories WHERE LOWER(slug) = 'deportes' LIMIT 1),
      'published',
      'El gran derbi provincial de fútbol sala.',
      'center');

INSERT INTO public.events (id, title, place, maps_url, image_url, is_featured, is_free, starts_at, city_id, category_id, status, description, image_alignment) VALUES (
      'ff7c4ced-1962-4e22-9850-4d347da7fe8c',
      'Festival de Jerez: Nino de los Reyes',
      'Teatro Villamarta, Jerez de la Frontera',
      'https://www.google.com/maps/search/?api=1&query=Teatro+Villamarta+Jerez',
      'https://oudofaiekedtaovrdqeo.supabase.co/storage/v1/object/public/sample-images/1/4/05.webp',
      FALSE,
      FALSE,
      '2026-02-21T20:30:00Z'::timestamptz,
      (SELECT id FROM public.cities WHERE LOWER(name) = LOWER('Jerez de la Frontera') LIMIT 1),
      (SELECT id FROM public.categories WHERE LOWER(slug) = 'arte-y-cultura' LIMIT 1),
      'published',
      'Espectáculo ''Vuelta al sol''. Baile.',
      'center');

INSERT INTO public.events (id, title, place, maps_url, image_url, is_featured, is_free, starts_at, city_id, category_id, status, description, image_alignment) VALUES (
      'a663091a-80b0-492d-b817-31f187f19573',
      'Festival de Jerez: Olga Pericet',
      'Teatro Villamarta, Jerez de la Frontera',
      'https://www.google.com/maps/search/?api=1&query=Teatro+Villamarta+Jerez',
      'https://oudofaiekedtaovrdqeo.supabase.co/storage/v1/object/public/sample-images/1/4/06.webp',
      FALSE,
      FALSE,
      '2026-02-22T20:30:00Z'::timestamptz,
      (SELECT id FROM public.cities WHERE LOWER(name) = LOWER('Jerez de la Frontera') LIMIT 1),
      (SELECT id FROM public.categories WHERE LOWER(slug) = 'arte-y-cultura' LIMIT 1),
      'published',
      'Espectáculo ''La materia''. Baile contemporáneo flamenco.',
      'center');

INSERT INTO public.events (id, title, place, maps_url, image_url, is_featured, is_free, starts_at, city_id, category_id, status, description, image_alignment) VALUES (
      '02b55285-cf59-46ac-bd74-195efa494a5d',
      'Quema de la Bruja Piti',
      'Castillo de San Sebastián / La Caleta, Cádiz',
      'https://www.google.com/maps/search/?api=1&query=Playa+La+Caleta+Cadiz',
      'https://oudofaiekedtaovrdqeo.supabase.co/storage/v1/object/public/sample-images/1/6/04.webp',
      FALSE,
      TRUE,
      '2026-02-22T22:00:00Z'::timestamptz,
      (SELECT id FROM public.cities WHERE LOWER(name) = LOWER('Cádiz') LIMIT 1),
      (SELECT id FROM public.categories WHERE LOWER(slug) = 'tradiciones' LIMIT 1),
      'published',
      'Fuegos artificiales y fin oficial del Carnaval.',
      'center');

INSERT INTO public.events (id, title, place, maps_url, image_url, is_featured, is_free, starts_at, city_id, category_id, status, description, image_alignment) VALUES (
      '0ce1e38f-c112-434e-8ca8-36fafc238f2e',
      'Vía Crucis Oficial de las Hermandades',
      'Catedral de Cádiz',
      'https://www.google.com/maps/search/?api=1&query=Catedral+de+Cadiz',
      'https://oudofaiekedtaovrdqeo.supabase.co/storage/v1/object/public/sample-images/1/6/05.webp',
      FALSE,
      TRUE,
      '2026-02-23T19:00:00Z'::timestamptz,
      (SELECT id FROM public.cities WHERE LOWER(name) = LOWER('Cádiz') LIMIT 1),
      (SELECT id FROM public.categories WHERE LOWER(slug) = 'tradiciones' LIMIT 1),
      'published',
      'Primer lunes de Cuaresma. Acto solemne en la Catedral.',
      'center');

INSERT INTO public.events (id, title, place, maps_url, image_url, is_featured, is_free, starts_at, city_id, category_id, status, description, image_alignment) VALUES (
      '064202f7-5f05-438e-a3a2-af06e4ee2dfe',
      'Festival de Jerez: Estévez / Paños',
      'Teatro Villamarta, Jerez de la Frontera',
      'https://www.google.com/maps/search/?api=1&query=Teatro+Villamarta+Jerez',
      'https://oudofaiekedtaovrdqeo.supabase.co/storage/v1/object/public/sample-images/1/4/07.webp',
      FALSE,
      FALSE,
      '2026-02-24T20:30:00Z'::timestamptz,
      (SELECT id FROM public.cities WHERE LOWER(name) = LOWER('Jerez de la Frontera') LIMIT 1),
      (SELECT id FROM public.categories WHERE LOWER(slug) = 'arte-y-cultura' LIMIT 1),
      'published',
      'Espectáculo ''Doncellas''.',
      'center');

INSERT INTO public.events (id, title, place, maps_url, image_url, is_featured, is_free, starts_at, city_id, category_id, status, description, image_alignment) VALUES (
      'af70f314-dd4c-4530-8135-7660c9fd9613',
      'Andalucía Sunshine Tour (Semana 4 - Inicio)',
      'Dehesa Montenmedio, Vejer de la Frontera',
      'https://www.google.com/maps/search/?api=1&query=Dehesa+Montenmedio+Vejer',
      'https://oudofaiekedtaovrdqeo.supabase.co/storage/v1/object/public/sample-images/1/3/14.webp',
      FALSE,
      TRUE,
      '2026-02-26T09:00:00Z'::timestamptz,
      (SELECT id FROM public.cities WHERE LOWER(name) = LOWER('Vejer de la Frontera') LIMIT 1),
      (SELECT id FROM public.categories WHERE LOWER(slug) = 'deportes' LIMIT 1),
      'published',
      'Semana especial Andalucía. CSI2*.',
      'center');

INSERT INTO public.events (id, title, place, maps_url, image_url, is_featured, is_free, starts_at, city_id, category_id, status, description, image_alignment) VALUES (
      '08ac3477-f57e-451d-9a15-2f92335d3e56',
      'Festival de Jerez: Carmen Herrera',
      'Teatro Villamarta, Jerez de la Frontera',
      'https://www.google.com/maps/search/?api=1&query=Teatro+Villamarta+Jerez',
      'https://oudofaiekedtaovrdqeo.supabase.co/storage/v1/object/public/sample-images/1/4/08.webp',
      FALSE,
      FALSE,
      '2026-02-26T20:30:00Z'::timestamptz,
      (SELECT id FROM public.cities WHERE LOWER(name) = LOWER('Jerez de la Frontera') LIMIT 1),
      (SELECT id FROM public.categories WHERE LOWER(slug) = 'arte-y-cultura' LIMIT 1),
      'published',
      'Espectáculo ''GhERRERA''.',
      'center');

INSERT INTO public.events (id, title, place, maps_url, image_url, is_featured, is_free, starts_at, city_id, category_id, status, description, image_alignment) VALUES (
      '76a5a011-7137-452f-842c-193bfbeb42ce',
      'Torneo Día de Andalucía de Golf',
      'Real Club de Golf Sotogrande',
      'https://www.google.com/maps/search/?api=1&query=Real+Club+de+Golf+Sotogrande',
      'https://oudofaiekedtaovrdqeo.supabase.co/storage/v1/object/public/sample-images/1/3/15.webp',
      FALSE,
      FALSE,
      '2026-02-28T11:00:00Z'::timestamptz,
      (SELECT id FROM public.cities WHERE LOWER(name) = LOWER('Sotogrande') LIMIT 1),
      (SELECT id FROM public.categories WHERE LOWER(slug) = 'deportes' LIMIT 1),
      'published',
      'Torneo amateur abierto.',
      'center');

INSERT INTO public.events (id, title, place, maps_url, image_url, is_featured, is_free, starts_at, city_id, category_id, status, description, image_alignment) VALUES (
      '258bc8f2-c0bb-42e3-b50f-73c7e925deaf',
      'Día de Andalucía',
      'Provincia de Cádiz',
      'https://www.google.com/maps/search/?api=1&query=Cadiz',
      'https://oudofaiekedtaovrdqeo.supabase.co/storage/v1/object/public/sample-images/1/6/06.webp',
      FALSE,
      TRUE,
      '2026-02-28T12:00:00Z'::timestamptz,
      (SELECT id FROM public.cities WHERE LOWER(name) = LOWER('Cádiz') LIMIT 1),
      (SELECT id FROM public.categories WHERE LOWER(slug) = 'tradiciones' LIMIT 1),
      'published',
      'Actos institucionales en todos los municipios.',
      'center');
