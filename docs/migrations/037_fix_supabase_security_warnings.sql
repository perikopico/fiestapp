-- Migración 037: Corregir warnings del Security Linter de Supabase
--
-- Resuelve:
-- 1. function_search_path_mutable: SET search_path = public en funciones afectadas
-- 2. extension_in_public: mover pg_trgm al schema extensions
-- 3. rls_policy_always_true: políticas más restrictivas en event_stats y events
--
-- NOTA (auth_leaked_password_protection): no se corrige por SQL. Habilitar en Supabase:
--       Dashboard → Authentication → Settings → Password Protection →
--       activar "Leaked password protection" (HaveIBeenPwned).
--
-- Referencias: https://supabase.com/docs/guides/database/database-linter

-- ============================================
-- 1. Function search_path: SET search_path = public
-- ============================================
DO $$
DECLARE
  r RECORD;
  fn_list text[] := ARRAY[
    'is_admin', 'generate_verification_code', 'get_popular_events_this_week',
    'get_popular_events', 'normalize_venue_name', 'find_similar_venues',
    'create_venue_ownership_request', 'update_updated_at_column',
    'verify_venue_ownership', 'reject_venue_ownership', 'approve_event_by_owner',
    'set_owner_approval_on_event_insert', 'verify_venue_ownership_by_user',
    'export_user_data', 'update_user_consents_updated_at', 'events_within_radius',
    'increment_event_view', 'extract_lng_from_maps_url', 'extract_lat_from_maps_url',
    'delete_user_data', 'fill_town_from_city', 'cities_within_radius'
  ];
  fn text;
BEGIN
  FOREACH fn IN ARRAY fn_list
  LOOP
    FOR r IN
      SELECT n.nspname, p.proname, pg_get_function_identity_arguments(p.oid) AS args
      FROM pg_proc p
      JOIN pg_namespace n ON p.pronamespace = n.oid
      WHERE n.nspname = 'public' AND p.proname = fn
    LOOP
      BEGIN
        EXECUTE format(
          'ALTER FUNCTION %I.%I(%s) SET search_path = public',
          r.nspname, r.proname, r.args
        );
        RAISE NOTICE '037: search_path set for %.%(%)', r.nspname, r.proname, r.args;
      EXCEPTION WHEN OTHERS THEN
        RAISE WARNING '037: no se pudo alterar %.%(%): %', r.nspname, r.proname, r.args, SQLERRM;
      END;
    END LOOP;
  END LOOP;
END $$;

-- ============================================
-- 2. pg_trgm: mover a schema extensions
-- ============================================
-- find_similar_venues y normalize_venue_name usan similarity() (pg_trgm).
-- Tras mover la extensión, deben buscar en extensions; fijamos search_path = public, extensions.
DO $$
BEGIN
  CREATE SCHEMA IF NOT EXISTS extensions;
  ALTER EXTENSION pg_trgm SET SCHEMA extensions;
  RAISE NOTICE '037: pg_trgm movido a extensions';
  BEGIN
    ALTER FUNCTION public.normalize_venue_name(text) SET search_path = public, extensions;
    ALTER FUNCTION public.find_similar_venues(text, bigint) SET search_path = public, extensions;
    RAISE NOTICE '037: search_path public,extensions en normalize_venue_name y find_similar_venues';
  EXCEPTION WHEN OTHERS THEN
    RAISE WARNING '037: no se pudo ajustar search_path en funciones pg_trgm: %', SQLERRM;
  END;
EXCEPTION
  WHEN OTHERS THEN
    RAISE WARNING '037: no se pudo mover pg_trgm a extensions (p. ej. permisos): %. Ejecutar como supabase_admin si aplica.', SQLERRM;
END $$;

-- ============================================
-- 3. RLS event_stats: políticas menos permisivas
-- ============================================
-- event_stats_insert_all / event_stats_update_all usan USING(true)/WITH CHECK(true).
-- Reemplazamos por: INSERT/UPDATE solo si event_id existe en events (publicados).
-- Requiere que event_stats tenga columna event_id; si no, ver EXCEPTION al ejecutar.
DO $$
BEGIN
  IF EXISTS (SELECT 1 FROM pg_tables WHERE schemaname = 'public' AND tablename = 'event_stats') THEN
    DROP POLICY IF EXISTS "event_stats_insert_all" ON public.event_stats;
    DROP POLICY IF EXISTS "event_stats_update_all" ON public.event_stats;

    -- INSERT: solo para event_id que exista en eventos publicados
    CREATE POLICY "event_stats_insert_published"
      ON public.event_stats FOR INSERT
      WITH CHECK (
        EXISTS (
          SELECT 1 FROM public.events e
          WHERE e.id = event_stats.event_id AND e.status = 'published'
        )
      );

    -- UPDATE: mismo criterio (solo filas de eventos publicados)
    CREATE POLICY "event_stats_update_published"
      ON public.event_stats FOR UPDATE
      USING (
        EXISTS (
          SELECT 1 FROM public.events e
          WHERE e.id = event_stats.event_id AND e.status = 'published'
        )
      )
      WITH CHECK (
        EXISTS (
          SELECT 1 FROM public.events e
          WHERE e.id = event_stats.event_id AND e.status = 'published'
        )
      );

    RAISE NOTICE '037: políticas event_stats actualizadas';
  ELSE
    RAISE NOTICE '037: tabla event_stats no existe, omitiendo';
  END IF;
EXCEPTION
  WHEN OTHERS THEN
    RAISE WARNING '037: error en políticas event_stats (revisar columnas): %', SQLERRM;
END $$;

-- ============================================
-- 4. RLS events: "Allow anon update event status" USING(true)
-- ============================================
-- Sustituir por UPDATE solo si authenticated y (creador del evento o admin).
-- Si antes anon podía actualizar status, dejará de poder; revisar flujos antes de aplicar.
DO $$
BEGIN
  DROP POLICY IF EXISTS "Allow anon update event status" ON public.events;

  CREATE POLICY "Allow creator or admin update event status"
    ON public.events FOR UPDATE
    USING (
      auth.uid() IS NOT NULL
      AND (
        created_by = auth.uid()
        OR EXISTS (SELECT 1 FROM public.admins a WHERE a.user_id = auth.uid())
      )
    )
    WITH CHECK (
      status = ANY (ARRAY['pending', 'published', 'rejected'])
    );

  RAISE NOTICE '037: política events UPDATE actualizada (solo creator/admin)';
EXCEPTION
  WHEN OTHERS THEN
    RAISE WARNING '037: error en política events: %', SQLERRM;
END $$;
