-- Migración 036: Corregir errores del Security Linter de Supabase
--
-- Resuelve:
-- 1. auth_users_exposed: venue_ownership_view exponía auth.users (owner_email)
-- 2. security_definer_view: venue_ownership_view y events_view con SECURITY DEFINER
-- 3. rls_disabled_in_public: event_categories y provinces sin RLS
--
-- Referencias: https://supabase.com/docs/guides/database/database-linter

-- ============================================
-- 1. venue_ownership_view: quitar auth.users y usar SECURITY INVOKER
-- ============================================
-- Eliminamos el JOIN a auth.users para no exponer datos de usuarios.
-- owner_email se quita; si se necesita, usar un RPC seguro (solo owner/admin).
DROP VIEW IF EXISTS public.venue_ownership_view;

CREATE VIEW public.venue_ownership_view
  WITH (security_invoker = true)
AS
SELECT
  v.id           AS venue_id,
  v.name         AS venue_name,
  v.city_id,
  v.owner_id,
  v.verified_at,
  vor.id         AS request_id,
  vor.status     AS request_status,
  vor.verification_code,
  vor.verification_method,
  vor.contact_info,
  vor.expires_at
FROM public.venues v
LEFT JOIN public.venue_ownership_requests vor
  ON vor.venue_id = v.id
  AND vor.status = 'pending'
  AND vor.expires_at > now();

COMMENT ON VIEW public.venue_ownership_view IS
  'Vista de ownership de venues. Sin owner_email para no exponer auth.users. SECURITY INVOKER.';

-- ============================================
-- 2. events_view: SECURITY INVOKER
-- ============================================
DROP FUNCTION IF EXISTS public.get_popular_events_this_week(integer) CASCADE;
DROP FUNCTION IF EXISTS public.get_popular_events(bigint, integer) CASCADE;

DROP VIEW IF EXISTS public.events_view CASCADE;

CREATE VIEW public.events_view
  WITH (security_invoker = true)
AS
SELECT
  e.*,
  c.name   AS city_name,
  cat.name AS category_name,
  cat.icon AS category_icon,
  cat.color AS category_color
FROM public.events e
INNER JOIN public.cities c ON e.city_id = c.id
INNER JOIN public.categories cat ON e.category_id = cat.id;

CREATE OR REPLACE FUNCTION public.get_popular_events_this_week(p_limit integer)
RETURNS SETOF events_view
LANGUAGE sql
STABLE
AS $$
  SELECT *
  FROM events_view
  WHERE status = 'published'
    AND starts_at >= date_trunc('week', CURRENT_DATE)
    AND starts_at < date_trunc('week', CURRENT_DATE) + interval '1 week'
  ORDER BY is_featured DESC, starts_at ASC
  LIMIT p_limit;
$$;

CREATE OR REPLACE FUNCTION public.get_popular_events(
  p_province_id bigint DEFAULT NULL,
  p_limit integer DEFAULT 10
)
RETURNS SETOF events_view
LANGUAGE sql
STABLE
AS $$
  SELECT *
  FROM events_view
  WHERE status = 'published'
    AND starts_at >= CURRENT_TIMESTAMP
    AND (p_province_id IS NULL OR city_id IN (
      SELECT id FROM cities WHERE province_id = p_province_id
    ))
  ORDER BY is_featured DESC, starts_at ASC
  LIMIT p_limit;
$$;

-- ============================================
-- 3. RLS en event_categories y provinces
-- ============================================
-- event_categories: lectura pública; escritura solo authenticated (app crea/actualiza eventos).
-- provinces: solo lectura (lookup).

ALTER TABLE public.event_categories ENABLE ROW LEVEL SECURITY;

DROP POLICY IF EXISTS "Allow read event_categories" ON public.event_categories;
CREATE POLICY "Allow read event_categories"
  ON public.event_categories
  FOR SELECT
  USING (true);

DROP POLICY IF EXISTS "Allow insert event_categories authenticated" ON public.event_categories;
CREATE POLICY "Allow insert event_categories authenticated"
  ON public.event_categories
  FOR INSERT
  WITH CHECK (auth.uid() IS NOT NULL);

DROP POLICY IF EXISTS "Allow update event_categories authenticated" ON public.event_categories;
CREATE POLICY "Allow update event_categories authenticated"
  ON public.event_categories
  FOR UPDATE
  USING (auth.uid() IS NOT NULL)
  WITH CHECK (auth.uid() IS NOT NULL);

DROP POLICY IF EXISTS "Allow delete event_categories authenticated" ON public.event_categories;
CREATE POLICY "Allow delete event_categories authenticated"
  ON public.event_categories
  FOR DELETE
  USING (auth.uid() IS NOT NULL);

ALTER TABLE public.provinces ENABLE ROW LEVEL SECURITY;

DROP POLICY IF EXISTS "Allow read provinces" ON public.provinces;
CREATE POLICY "Allow read provinces"
  ON public.provinces
  FOR SELECT
  USING (true);

-- ============================================
-- Verificación
-- ============================================
DO $$
BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM information_schema.views
    WHERE table_schema = 'public' AND table_name = 'venue_ownership_view'
  ) THEN
    RAISE EXCEPTION 'venue_ownership_view no existe tras migración';
  END IF;
  IF NOT EXISTS (
    SELECT 1 FROM information_schema.views
    WHERE table_schema = 'public' AND table_name = 'events_view'
  ) THEN
    RAISE EXCEPTION 'events_view no existe tras migración';
  END IF;
  IF NOT EXISTS (
    SELECT 1 FROM pg_policies WHERE tablename = 'event_categories'
  ) THEN
    RAISE EXCEPTION 'Falta política RLS en event_categories';
  END IF;
  IF NOT EXISTS (
    SELECT 1 FROM pg_policies WHERE tablename = 'provinces'
  ) THEN
    RAISE EXCEPTION 'Falta política RLS en provinces';
  END IF;
  RAISE NOTICE '036_fix_supabase_security_linter: OK';
END $$;
