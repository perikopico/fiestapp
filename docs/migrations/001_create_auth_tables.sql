-- Migración: Crear tablas y políticas para autenticación y administración
-- Ejecutar en Supabase SQL Editor

-- ============================================
-- 1. Tabla de administradores
-- ============================================
-- Esta tabla almacena los usuarios que tienen permisos de administrador
CREATE TABLE IF NOT EXISTS public.admins (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id uuid NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
  created_at timestamptz NOT NULL DEFAULT now(),
  created_by uuid REFERENCES auth.users(id),
  UNIQUE(user_id)
);

-- Índice para búsquedas rápidas
CREATE INDEX IF NOT EXISTS idx_admins_user_id ON public.admins(user_id);

-- Comentarios
COMMENT ON TABLE public.admins IS 'Usuarios con permisos de administrador';
COMMENT ON COLUMN public.admins.user_id IS 'ID del usuario de Supabase Auth';
COMMENT ON COLUMN public.admins.created_by IS 'Usuario que creó este registro de admin';

-- ============================================
-- 2. Tabla de favoritos de usuarios
-- ============================================
-- Almacena los eventos favoritos de cada usuario
CREATE TABLE IF NOT EXISTS public.user_favorites (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id uuid NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
  event_id uuid NOT NULL REFERENCES public.events(id) ON DELETE CASCADE,
  created_at timestamptz NOT NULL DEFAULT now(),
  UNIQUE(user_id, event_id)
);

-- Índices para búsquedas rápidas
CREATE INDEX IF NOT EXISTS idx_user_favorites_user_id ON public.user_favorites(user_id);
CREATE INDEX IF NOT EXISTS idx_user_favorites_event_id ON public.user_favorites(event_id);

-- Comentarios
COMMENT ON TABLE public.user_favorites IS 'Eventos marcados como favoritos por los usuarios';
COMMENT ON COLUMN public.user_favorites.user_id IS 'ID del usuario que marcó el evento como favorito';
COMMENT ON COLUMN public.user_favorites.event_id IS 'ID del evento favorito';

-- ============================================
-- 3. Row Level Security (RLS) Policies
-- ============================================

-- Habilitar RLS en todas las tablas
ALTER TABLE public.admins ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.user_favorites ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.events ENABLE ROW LEVEL SECURITY;

-- ============================================
-- POLÍTICAS PARA TABLA 'admins'
-- ============================================

-- Los usuarios pueden leer si son admin (para verificar sus propios permisos)
DROP POLICY IF EXISTS "Users can read if they are admin" ON public.admins;
CREATE POLICY "Users can read if they are admin"
  ON public.admins
  FOR SELECT
  USING (
    auth.uid() = user_id
  );

-- Solo los super-admins pueden insertar/actualizar/eliminar
-- Nota: Esto requiere que un super-admin se defina manualmente primero
-- Por ahora, permitimos que los usuarios vean si son admin, pero no pueden modificarlo
-- La creación de admins debe hacerse manualmente por un super-admin o desde el SQL Editor

-- ============================================
-- POLÍTICAS PARA TABLA 'user_favorites'
-- ============================================

-- Los usuarios pueden leer sus propios favoritos
DROP POLICY IF EXISTS "Users can read own favorites" ON public.user_favorites;
CREATE POLICY "Users can read own favorites"
  ON public.user_favorites
  FOR SELECT
  USING (auth.uid() = user_id);

-- Los usuarios pueden insertar sus propios favoritos
DROP POLICY IF EXISTS "Users can insert own favorites" ON public.user_favorites;
CREATE POLICY "Users can insert own favorites"
  ON public.user_favorites
  FOR INSERT
  WITH CHECK (auth.uid() = user_id);

-- Los usuarios pueden eliminar sus propios favoritos
DROP POLICY IF EXISTS "Users can delete own favorites" ON public.user_favorites;
CREATE POLICY "Users can delete own favorites"
  ON public.user_favorites
  FOR DELETE
  USING (auth.uid() = user_id);

-- ============================================
-- POLÍTICAS PARA TABLA 'events'
-- ============================================

-- Cualquiera puede leer eventos publicados
DROP POLICY IF EXISTS "Anyone can read published events" ON public.events;
CREATE POLICY "Anyone can read published events"
  ON public.events
  FOR SELECT
  USING (status = 'published');

-- Solo admins pueden leer eventos pendientes o rechazados
DROP POLICY IF EXISTS "Admins can read all events" ON public.events;
CREATE POLICY "Admins can read all events"
  ON public.events
  FOR SELECT
  USING (
    EXISTS (
      SELECT 1 FROM public.admins
      WHERE admins.user_id = auth.uid()
    )
  );

-- Solo admins pueden actualizar el estado de eventos
DROP POLICY IF EXISTS "Admins can update event status" ON public.events;
CREATE POLICY "Admins can update event status"
  ON public.events
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

-- Cualquiera puede insertar eventos (se crearán como 'pending')
DROP POLICY IF EXISTS "Anyone can insert events" ON public.events;
CREATE POLICY "Anyone can insert events"
  ON public.events
  FOR INSERT
  WITH CHECK (status = 'pending');

-- Solo admins pueden eliminar eventos
DROP POLICY IF EXISTS "Admins can delete events" ON public.events;
CREATE POLICY "Admins can delete events"
  ON public.events
  FOR DELETE
  USING (
    EXISTS (
      SELECT 1 FROM public.admins
      WHERE admins.user_id = auth.uid()
    )
  );

-- ============================================
-- 4. Función helper para verificar si un usuario es admin
-- ============================================
CREATE OR REPLACE FUNCTION public.is_admin(user_uuid uuid)
RETURNS boolean AS $$
BEGIN
  RETURN EXISTS (
    SELECT 1 FROM public.admins
    WHERE admins.user_id = user_uuid
  );
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- ============================================
-- 5. Función para convertir favoritos locales a la nueva tabla
-- ============================================
-- Esta función puede ser útil si ya tienes datos de favoritos en otra ubicación
-- Ejemplo de uso:
-- SELECT migrate_favorites_from_old_table();

-- ============================================
-- NOTAS IMPORTANTES:
-- ============================================
-- 1. Para crear el primer administrador, ejecuta:
--    INSERT INTO public.admins (user_id) 
--    SELECT id FROM auth.users WHERE email = 'tu-email@ejemplo.com';
--
-- 2. Asegúrate de que el usuario ya existe en auth.users antes de añadirlo a admins
--
-- 3. Para añadir más administradores:
--    INSERT INTO public.admins (user_id, created_by)
--    SELECT id, (SELECT id FROM auth.users WHERE email = 'admin-principal@ejemplo.com')
--    FROM auth.users WHERE email = 'nuevo-admin@ejemplo.com';
--
-- 4. Las políticas RLS se aplican automáticamente. Los usuarios no autenticados
--    solo pueden ver eventos publicados y crear eventos (que quedarán como 'pending')
--
-- 5. Los usuarios autenticados pueden gestionar sus favoritos
--
-- 6. Solo los administradores pueden aprobar/rechazar eventos

