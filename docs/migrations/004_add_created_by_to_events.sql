-- Migración: Añadir campo created_by a la tabla events
-- Ejecutar en Supabase SQL Editor
-- Fecha: Diciembre 2024

-- ============================================
-- 1. Añadir columna created_by a events
-- ============================================
ALTER TABLE public.events
ADD COLUMN IF NOT EXISTS created_by uuid REFERENCES auth.users(id) ON DELETE SET NULL;

-- ============================================
-- 2. Crear índice para búsquedas rápidas
-- ============================================
CREATE INDEX IF NOT EXISTS idx_events_created_by ON public.events(created_by);

-- ============================================
-- 3. Actualizar políticas RLS
-- ============================================
-- Los usuarios pueden leer sus propios eventos (incluso si están pendientes/rechazados)
DROP POLICY IF EXISTS "Users can read own events" ON public.events;
CREATE POLICY "Users can read own events"
  ON public.events
  FOR SELECT
  USING (
    created_by = auth.uid()
  );

-- ============================================
-- 4. Comentarios
-- ============================================
COMMENT ON COLUMN public.events.created_by IS 'ID del usuario que creó el evento (null si fue creado por un admin o sin autenticación)';

-- ============================================
-- NOTAS:
-- ============================================
-- - Esta columna permite identificar qué eventos fueron creados por cada usuario
-- - Si un usuario se elimina, los eventos creados por él permanecen pero created_by se pone en NULL
-- - Los usuarios pueden ver sus propios eventos incluso si están pendientes o rechazados
-- - Para eventos antiguos, created_by será NULL (no se puede determinar el creador)
