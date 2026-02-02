-- Migración 046: Venues INSERT solo para usuarios autenticados
-- Seguridad: Evitar spam de venues pendientes por usuarios anónimos
--
-- NOTA: Los venues creados por el script de importación JSON se ejecutan en
-- Supabase SQL Editor (como superuser), por lo que no se ven afectados por RLS.
--
-- Ejecutar en Supabase SQL Editor

-- Eliminar política que permitía a cualquiera crear venues
DROP POLICY IF EXISTS "Anyone can insert venues" ON public.venues;

-- Nueva política: Solo usuarios autenticados pueden crear venues (status=pending)
CREATE POLICY "Authenticated users can insert venues"
  ON public.venues
  FOR INSERT
  WITH CHECK (
    auth.uid() IS NOT NULL
    AND status = 'pending'
  );
