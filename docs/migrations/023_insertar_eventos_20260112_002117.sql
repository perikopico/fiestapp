-- ============================================
-- SQL generado automáticamente para insertar eventos desde JSON
-- Fecha de generación: 2026-01-12T00:21:17.323243
-- Total de eventos: 64
-- Formato: INSERTs directos con imágenes secuenciales por categoría
-- ============================================

INSERT INTO public.events (id, title, place, maps_url, image_url, is_featured, is_free, starts_at, city_id, category_id, status, description, image_alignment) VALUES (
      '7aa9e158-6e1f-4656-b276-4d21e0b135f6',
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
      '9e3ea876-a097-4155-acba-938c5af35244',
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
      '03dd667b-ec4f-4605-8f4d-bf882e5c10c2',
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
      '81c5a1c6-5a56-4779-b643-d38c5a565d27',
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
      'dac92158-e398-4f15-a51b-f1f240a07185',
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
      '7295b9ff-de5f-45df-a9c5-9729f25b90d9',
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
      '8143d10e-decd-4e6e-81a6-7994ea32ee2c',
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
      '35ba42f7-e206-40ff-a8b4-15c36482b1ff',
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
      'f15840b3-7708-40f0-924a-22c3eb2d0c44',
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
      'a4d3bbfc-eac6-4333-a622-e2373a9fbd9f',
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
      '5d01d47c-2ad6-43e4-ba72-181eac50c1d7',
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
      '653bd6cb-f082-4a86-958b-f07742cdfc37',
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
      '57c02aec-6e6c-4fb3-b0f6-965b25627922',
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
      '1c9e26bd-711a-40b2-b217-1028548c24a7',
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
      '5fe9bae5-aaaf-4af1-9245-2c40a5f33191',
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
      '4544cc33-3d73-4345-97ce-e6bd74652bbc',
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
      '112cbb9c-c867-45c2-910a-5effe6191e4e',
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
      'a868f5ef-183a-4956-87fc-6447f7ee446e',
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
      '100cfb4b-4bb6-4c21-9766-9113ce1df9ea',
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
      'e827fd94-0d2c-44a5-b244-4fb404ba4391',
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
      'cdc0faa3-b571-42d5-8822-65f853ee82b6',
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
      '0bb550cb-f37f-46ba-b9a2-d9938c8fa4ce',
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
      '27acb750-7604-46e9-a1e4-66257b1057f1',
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
      'a5725080-60af-4300-a2af-c7e650b21b9c',
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
      '0a2c4c0f-dc9a-4986-b6a9-973cbdfd765f',
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
      '394f2d1d-24d1-4cf9-93f1-e1318707056a',
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
      '4b6f9a73-5dac-4367-a799-711a23f8f85d',
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
      '41d2810e-4b5e-4c13-be4f-4872455510df',
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
      'f365b545-d540-4c94-af0f-43160a8cb6ba',
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
      '673d38ab-8d6a-4b18-afdd-c64d188ccd3f',
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
      '94c9772f-7fb4-4b4f-a853-3ff525a9b817',
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
      '337779db-d591-4b46-8621-67edcebed658',
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
      '37104e46-6dbb-4928-bfcc-e441b6f33049',
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
      'ee213ece-7dbc-453d-97bd-a6dca4ec5781',
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
      '5c745c74-69d0-4eec-b867-303dd7b71873',
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
      '82305c26-0916-4535-af38-b69c80e5f963',
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
      '9c982256-8fbc-4dc5-92cd-c885e2846a4a',
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
      '03f72940-07a8-4776-9a18-02db5793a8e9',
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
      'eae86d4a-f6fb-4411-8cd2-07196eab5db0',
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
      '90a3d207-e355-432a-b906-cd6d5d33aaa1',
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
      'b79e29fb-0a5f-4afb-b5f8-910aa7621bb3',
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
      '497150b8-a321-40b8-b812-b5fe3e1ea2c0',
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
      '0164fbbe-ac72-4ee9-b2f6-75d7bf90f351',
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
      '4340d364-3feb-451e-a820-830efaadb6f0',
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
      'e554a57b-3e9f-465d-b8bc-085beb647441',
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
      '3830b6a2-b169-4ea8-bc8d-a4672112cb1b',
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
      '35e741cc-0a3e-4de1-a400-d0b5789305a5',
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
      'a6b618e8-975b-4643-9fea-4056c57cbbb7',
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
      '868e51ba-3c51-404c-b8d7-93a6be18e03b',
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
      'a88a156e-482e-4a5c-9645-d9925d941824',
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
      '673d0857-e44b-4976-9db9-28354b60e54b',
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
      'd77aa57c-e327-4ac5-9d53-d12b40d60f1c',
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
      '0aec375d-33d0-4876-bbf6-52b3c58d5975',
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
      '08c2cc03-cb2d-4c26-b6e9-1c057982d168',
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
      '36c931c1-92d1-4c7d-8841-27fb5f2063b5',
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
      '194ba563-018b-44e2-9765-46a5c71f32c4',
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
      '33d97624-cbfc-4ca7-ac58-cfd5d3cbc0ab',
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
      'fb8096f8-9415-4505-884b-c9bbcb7a980f',
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
      '27960804-fbb5-462d-86ee-3e7f9ca14ca7',
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
      '88bb1087-f3c7-4756-981e-1ceaa9324e27',
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
      '1fbc27fa-18d9-40c1-a59f-0eb11bbc7c1d',
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
      '6c8be43f-8dbb-40e2-8d57-94408c0f1bf0',
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
      '2857cf22-0edb-418a-a042-54538d2a86f5',
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
      '9adead6f-60b9-492b-9ece-1a373121dbdc',
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
