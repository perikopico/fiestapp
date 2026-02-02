-- Migración 045: Limpiar TODOS los eventos y venues para entrada limpia
-- ⚠️ ADVERTENCIA: Este script eliminará TODOS los eventos y venues de la base de datos
-- Ejecutar en Supabase SQL Editor
--
-- INSTRUCCIONES:
-- 1. Ejecuta la sección de VERIFICACIÓN para ver qué se va a eliminar
-- 2. Si estás seguro, ejecuta la sección de LIMPIEZA
-- 3. Después elimina las imágenes del Storage (bucket: event-images)
-- 4. Luego podrás importar eventos de cero con el script generar_sql_eventos_simple.py

-- ============================================
-- 1. VERIFICACIÓN - Ver qué se va a eliminar
-- ============================================
-- Ejecuta esta sección primero para revisar

SELECT 'Eventos' as tabla, COUNT(*)::text as cantidad FROM public.events
UNION ALL
SELECT 'Venues', COUNT(*)::text FROM public.venues
UNION ALL
SELECT 'Favoritos', COUNT(*)::text FROM public.user_favorites
UNION ALL
SELECT 'Event translations', COUNT(*)::text FROM public.event_translations
UNION ALL
SELECT 'Event categories', COUNT(*)::text FROM public.event_categories
UNION ALL
SELECT 'Venue managers', COUNT(*)::text FROM public.venue_managers
UNION ALL
SELECT 'Venue ownership requests', COUNT(*)::text FROM public.venue_ownership_requests;

-- ============================================
-- 2. LIMPIEZA - Eliminar todo (eventos + venues)
-- ============================================
-- ⚠️ SOLO EJECUTA ESTO DESPUÉS DE REVISAR
-- ⚠️ ESTO ES IRREVERSIBLE (haz backup si necesitas)

BEGIN;

-- 2.1. Tablas que referencian eventos
DELETE FROM public.user_favorites;
DELETE FROM public.event_categories;

DO $$
BEGIN
  IF EXISTS (SELECT 1 FROM pg_tables WHERE schemaname = 'public' AND tablename = 'event_translations') THEN
    DELETE FROM public.event_translations;
    RAISE NOTICE '✅ event_translations limpiado';
  END IF;
END $$;

-- 2.2. Notificaciones (si existen las tablas)
DO $$
BEGIN
  IF EXISTS (SELECT 1 FROM pg_tables WHERE schemaname = 'public' AND tablename = 'notifications_history') THEN
    DELETE FROM public.notifications_history;
    RAISE NOTICE '✅ notifications_history limpiado';
  END IF;
  IF EXISTS (SELECT 1 FROM pg_tables WHERE schemaname = 'public' AND tablename = 'pending_notifications') THEN
    DELETE FROM public.pending_notifications;
    RAISE NOTICE '✅ pending_notifications limpiado';
  END IF;
END $$;

-- 2.3. event_stats (si existe)
DO $$
BEGIN
  IF EXISTS (SELECT 1 FROM pg_tables WHERE schemaname = 'public' AND tablename = 'event_stats') THEN
    DELETE FROM public.event_stats;
    RAISE NOTICE '✅ event_stats limpiado';
  END IF;
END $$;

-- 2.4. content_reports de eventos (si existe la tabla)
DO $$
BEGIN
  IF EXISTS (SELECT 1 FROM pg_tables WHERE schemaname = 'public' AND tablename = 'content_reports') THEN
    DELETE FROM public.content_reports WHERE content_type = 'event';
    RAISE NOTICE '✅ content_reports (eventos) limpiados';
  END IF;
END $$;

-- 2.5. admin_notifications relacionadas con venues/eventos
DELETE FROM public.admin_notifications 
WHERE type IN ('venue_ownership_request', 'event_pending_approval', 'event_approved', 'event_rejected');

-- 2.6. Eventos (las FKs con CASCADE ya limpiaron user_favorites, event_categories, event_translations)
DELETE FROM public.events;

-- 2.7. Tablas que referencian venues
DELETE FROM public.venue_managers;
DELETE FROM public.venue_ownership_requests;

-- 2.8. Venues
DELETE FROM public.venues;

-- Verificación
DO $$
DECLARE
  ev integer;
  vn integer;
BEGIN
  SELECT COUNT(*) INTO ev FROM public.events;
  SELECT COUNT(*) INTO vn FROM public.venues;
  
  IF ev = 0 AND vn = 0 THEN
    RAISE NOTICE '✅ Limpieza completada: 0 eventos, 0 venues';
  ELSE
    RAISE WARNING '⚠️ Quedan % eventos y % venues', ev, vn;
  END IF;
END $$;

COMMIT;

-- ============================================
-- 3. VERIFICACIÓN FINAL
-- ============================================
SELECT 'Eventos' as tabla, COUNT(*)::text as cantidad FROM public.events
UNION ALL
SELECT 'Venues', COUNT(*)::text FROM public.venues
UNION ALL
SELECT 'Categorías (se mantienen)', COUNT(*)::text FROM public.categories
UNION ALL
SELECT 'Ciudades (se mantienen)', COUNT(*)::text FROM public.cities;

-- ============================================
-- 4. NOTAS
-- ============================================
--
-- DESPUÉS DE EJECUTAR:
-- 1. Elimina las imágenes del bucket "event-images" en Supabase Storage (manual)
-- 2. Importa eventos con: python scripts/generar_sql_eventos_simple.py < tu_json.json
-- 3. Ejecuta el SQL generado en Supabase SQL Editor
--
-- NO SE ELIMINAN: categories, cities, users, admins
