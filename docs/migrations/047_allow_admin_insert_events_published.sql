-- Migración 047: Permitir a admins insertar eventos con status 'published'
--
-- La carga de JSON desde la app (ingesta) inserta eventos directamente como
-- 'published'. La política actual "Anyone can insert events" solo permite
-- INSERT con WITH CHECK (status = 'pending'), por eso falla con 42501/Forbidden.
--
-- Solución: añadir política para que los admins puedan insertar con cualquier status.

DROP POLICY IF EXISTS "Admins can insert events" ON public.events;

CREATE POLICY "Admins can insert events"
  ON public.events
  FOR INSERT
  WITH CHECK (
    EXISTS (
      SELECT 1 FROM public.admins
      WHERE admins.user_id = auth.uid()
    )
  );

COMMENT ON POLICY "Admins can insert events" ON public.events IS
  'Permite a usuarios en la tabla admins insertar eventos con cualquier status (p. ej. published), necesario para la carga de JSON desde la app.';
