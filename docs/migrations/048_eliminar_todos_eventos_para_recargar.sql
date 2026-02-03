-- Migración 048: Eliminar TODOS los eventos para volver a cargar el JSON
-- ⚠️ Esto borra eventos y datos asociados. No toca venues.
-- Ejecutar en Supabase → SQL Editor. Luego carga el JSON desde la app.

-- ============================================
-- 1. VERIFICACIÓN (opcional): ver cuántos registros hay
-- ============================================
SELECT 'events' as tabla, COUNT(*)::text as cantidad FROM public.events
UNION ALL SELECT 'user_favorites', COUNT(*)::text FROM public.user_favorites
UNION ALL SELECT 'event_translations', COUNT(*)::text FROM public.event_translations
UNION ALL SELECT 'event_categories', COUNT(*)::text FROM public.event_categories;

-- ============================================
-- 2. LIMPIEZA – ejecutar cuando quieras borrar todo
-- ============================================
BEGIN;

-- Tablas que referencian events (evitar violación de FK)
DELETE FROM public.user_favorites;
DELETE FROM public.event_categories;
DELETE FROM public.event_translations;

-- Notificaciones que apuntan a eventos (opcional, limpia historial)
DO $$
BEGIN
  IF EXISTS (SELECT 1 FROM pg_tables WHERE schemaname = 'public' AND tablename = 'notifications_history') THEN
    DELETE FROM public.notifications_history;
  END IF;
  IF EXISTS (SELECT 1 FROM pg_tables WHERE schemaname = 'public' AND tablename = 'pending_notifications') THEN
    DELETE FROM public.pending_notifications;
  END IF;
END $$;

-- Estadísticas por evento (si existe la tabla)
DO $$
BEGIN
  IF EXISTS (SELECT 1 FROM pg_tables WHERE schemaname = 'public' AND tablename = 'event_stats') THEN
    DELETE FROM public.event_stats;
  END IF;
END $$;

-- Informes de contenido sobre eventos (si existe)
DO $$
BEGIN
  IF EXISTS (SELECT 1 FROM pg_tables WHERE schemaname = 'public' AND tablename = 'content_reports') THEN
    DELETE FROM public.content_reports WHERE content_type = 'event';
  END IF;
END $$;

-- Por último, todos los eventos
DELETE FROM public.events;

COMMIT;

-- Comprobar que quedó vacío
SELECT 'Eventos restantes' as mensaje, COUNT(*) as total FROM public.events;
