-- Migración: Crear sistema de gestión de lugares (venues)
-- Ejecutar en Supabase SQL Editor
-- Fecha: Diciembre 2024

-- ============================================
-- 0. Función para actualizar updated_at (si no existe)
-- ============================================
CREATE OR REPLACE FUNCTION update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = now();
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- ============================================
-- 1. Tabla de lugares/venues
-- ============================================
CREATE TABLE IF NOT EXISTS public.venues (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  name text NOT NULL,
  city_id int8 NOT NULL REFERENCES public.cities(id) ON DELETE RESTRICT,
  address text, -- Dirección completa del lugar
  lat double precision, -- Latitud
  lng double precision, -- Longitud
  status text NOT NULL DEFAULT 'pending', -- 'pending', 'approved', 'rejected'
  created_by uuid REFERENCES auth.users(id) ON DELETE SET NULL,
  rejected_reason text, -- Razón del rechazo si status='rejected'
  created_at timestamptz NOT NULL DEFAULT now(),
  updated_at timestamptz NOT NULL DEFAULT now(),
  -- Evitar nombres duplicados en la misma ciudad
  CONSTRAINT unique_venue_name_city UNIQUE (name, city_id)
);

-- Índices para búsquedas rápidas
CREATE INDEX IF NOT EXISTS idx_venues_city_id ON public.venues(city_id);
CREATE INDEX IF NOT EXISTS idx_venues_status ON public.venues(status);
CREATE INDEX IF NOT EXISTS idx_venues_name ON public.venues(name);
CREATE INDEX IF NOT EXISTS idx_venues_created_by ON public.venues(created_by);

-- ============================================
-- 2. Modificar tabla events para añadir venue_id
-- ============================================
ALTER TABLE public.events
ADD COLUMN IF NOT EXISTS venue_id uuid REFERENCES public.venues(id) ON DELETE SET NULL;

-- Índice para búsquedas rápidas por venue
CREATE INDEX IF NOT EXISTS idx_events_venue_id ON public.events(venue_id);

-- ============================================
-- 3. Tabla de gestores de lugares (para el futuro)
-- ============================================
CREATE TABLE IF NOT EXISTS public.venue_managers (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  venue_id uuid NOT NULL REFERENCES public.venues(id) ON DELETE CASCADE,
  user_id uuid NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
  created_at timestamptz NOT NULL DEFAULT now(),
  UNIQUE(venue_id, user_id) -- Un usuario solo puede ser gestor una vez por lugar
);

-- Índices
CREATE INDEX IF NOT EXISTS idx_venue_managers_venue_id ON public.venue_managers(venue_id);
CREATE INDEX IF NOT EXISTS idx_venue_managers_user_id ON public.venue_managers(user_id);

-- ============================================
-- 4. Row Level Security (RLS) para venues
-- ============================================
ALTER TABLE public.venues ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.venue_managers ENABLE ROW LEVEL SECURITY;

-- Política: Cualquiera puede leer lugares aprobados
DROP POLICY IF EXISTS "Anyone can read approved venues" ON public.venues;
CREATE POLICY "Anyone can read approved venues"
  ON public.venues
  FOR SELECT
  USING (status = 'approved');

-- Política: Usuarios pueden leer lugares que crearon (incluso pendientes/rechazados)
DROP POLICY IF EXISTS "Users can read own venues" ON public.venues;
CREATE POLICY "Users can read own venues"
  ON public.venues
  FOR SELECT
  USING (created_by = auth.uid());

-- Política: Solo admins pueden leer todos los lugares
DROP POLICY IF EXISTS "Admins can read all venues" ON public.venues;
CREATE POLICY "Admins can read all venues"
  ON public.venues
  FOR SELECT
  USING (
    EXISTS (
      SELECT 1 FROM public.admins
      WHERE admins.user_id = auth.uid()
    )
  );

-- Política: Cualquiera puede crear lugares (status='pending')
DROP POLICY IF EXISTS "Anyone can insert venues" ON public.venues;
CREATE POLICY "Anyone can insert venues"
  ON public.venues
  FOR INSERT
  WITH CHECK (status = 'pending');

-- Política: Solo admins pueden actualizar lugares (aprobar/rechazar)
DROP POLICY IF EXISTS "Admins can update venues" ON public.venues;
CREATE POLICY "Admins can update venues"
  ON public.venues
  FOR UPDATE
  USING (
    EXISTS (
      SELECT 1 FROM public.admins
      WHERE admins.user_id = auth.uid()
    )
  )
  WITH CHECK (
    EXISTS (
      SELECT 1 FROM public.admins
      WHERE admins.user_id = auth.uid()
    )
  );

-- Política: Solo admins pueden eliminar lugares
DROP POLICY IF EXISTS "Admins can delete venues" ON public.venues;
CREATE POLICY "Admins can delete venues"
  ON public.venues
  FOR DELETE
  USING (
    EXISTS (
      SELECT 1 FROM public.admins
      WHERE admins.user_id = auth.uid()
    )
  );

-- ============================================
-- 5. RLS para venue_managers
-- ============================================
-- Política: Los usuarios pueden ver si son gestores de un lugar
DROP POLICY IF EXISTS "Users can read own venue managers" ON public.venue_managers;
CREATE POLICY "Users can read own venue managers"
  ON public.venue_managers
  FOR SELECT
  USING (user_id = auth.uid());

-- Política: Solo admins pueden gestionar venue_managers
DROP POLICY IF EXISTS "Admins can manage venue managers" ON public.venue_managers;
CREATE POLICY "Admins can manage venue managers"
  ON public.venue_managers
  FOR ALL
  USING (
    EXISTS (
      SELECT 1 FROM public.admins
      WHERE admins.user_id = auth.uid()
    )
  )
  WITH CHECK (
    EXISTS (
      SELECT 1 FROM public.admins
      WHERE admins.user_id = auth.uid()
    )
  );

-- ============================================
-- 6. Trigger para actualizar updated_at
-- ============================================
DROP TRIGGER IF EXISTS update_venues_updated_at ON public.venues;
CREATE TRIGGER update_venues_updated_at
    BEFORE UPDATE ON public.venues
    FOR EACH ROW
    EXECUTE FUNCTION update_updated_at_column();

-- ============================================
-- 7. Función para buscar lugares similares (prevenir duplicados)
-- ============================================
CREATE OR REPLACE FUNCTION public.find_similar_venues(
  p_name text,
  p_city_id int8
)
RETURNS TABLE (
  id uuid,
  name text,
  city_id int8,
  similarity real
) AS $$
BEGIN
  RETURN QUERY
  SELECT 
    v.id,
    v.name,
    v.city_id,
    similarity(v.name, p_name) as similarity
  FROM public.venues v
  WHERE v.city_id = p_city_id
    AND v.status IN ('approved', 'pending')
    AND similarity(v.name, p_name) > 0.3 -- Umbral de similitud
  ORDER BY similarity DESC
  LIMIT 5;
END;
$$ LANGUAGE plpgsql;

-- Necesitamos habilitar la extensión pg_trgm para similarity
CREATE EXTENSION IF NOT EXISTS pg_trgm;

-- ============================================
-- 8. Comentarios
-- ============================================
COMMENT ON TABLE public.venues IS 'Lugares/locales/negocios donde se realizan eventos';
COMMENT ON COLUMN public.venues.status IS 'Estado del lugar: pending (pendiente de aprobación), approved (aprobado), rejected (rechazado)';
COMMENT ON COLUMN public.venues.created_by IS 'Usuario que creó el lugar';
COMMENT ON COLUMN public.venues.rejected_reason IS 'Razón del rechazo si status=rejected';
COMMENT ON TABLE public.venue_managers IS 'Gestores asignados a lugares (para el futuro)';
COMMENT ON COLUMN public.venue_managers.venue_id IS 'Lugar gestionado';
COMMENT ON COLUMN public.venue_managers.user_id IS 'Usuario gestor del lugar';

-- ============================================
-- NOTAS IMPORTANTES:
-- ============================================
-- 1. La tabla venues tiene un constraint UNIQUE(name, city_id) para evitar 
--    lugares duplicados exactos en la misma ciudad
--
-- 2. Los lugares se crean siempre con status='pending' y requieren aprobación
--
-- 3. La función find_similar_venues() ayuda a detectar posibles duplicados
--
-- 4. Los eventos pueden tener venue_id (si usan un lugar aprobado) o place (texto libre)
--
-- 5. Para el futuro, los gestores podrán gestionar eventos en sus lugares asignados
