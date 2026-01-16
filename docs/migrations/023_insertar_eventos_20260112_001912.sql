-- ============================================
-- SQL generado automáticamente para insertar eventos desde JSON
-- Fecha de generación: 2026-01-12T00:19:12.275878
-- Total de eventos: 3
-- Formato: INSERTs directos con imágenes secuenciales por categoría
-- ============================================

INSERT INTO public.events (id, title, place, maps_url, image_url, is_featured, is_free, starts_at, city_id, category_id, status, description, image_alignment) VALUES (
      '13224a57-f89b-4a94-a834-af1df74255cd',
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
      '1367b9ea-449a-4683-8b25-3f5c0c249931',
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
      'f905f03c-f42b-4a1b-9fc6-fb8efae68b43',
      'Día de Andalucía',
      'Provincia de Cádiz',
      'https://www.google.com/maps/search/?api=1&query=Cadiz',
      'https://oudofaiekedtaovrdqeo.supabase.co/storage/v1/object/public/sample-images/1/6/02.webp',
      FALSE,
      TRUE,
      '2026-02-28T12:00:00Z'::timestamptz,
      (SELECT id FROM public.cities WHERE LOWER(name) = LOWER('Cádiz') LIMIT 1),
      (SELECT id FROM public.categories WHERE LOWER(slug) = 'tradiciones' LIMIT 1),
      'published',
      'Actos institucionales en todos los municipios.',
      'center');
