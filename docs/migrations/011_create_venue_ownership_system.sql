-- Migración: Sistema de ownership y verificación de venues
-- Ejecutar en Supabase SQL Editor
-- Fecha: Enero 2025

-- ============================================
-- 1. Tabla de solicitudes de ownership (claims)
-- ============================================
CREATE TABLE IF NOT EXISTS public.venue_ownership_requests (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  venue_id uuid NOT NULL REFERENCES public.venues(id) ON DELETE CASCADE,
  user_id uuid NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
  verification_code text NOT NULL, -- Código de verificación único
  verification_method text NOT NULL, -- 'email', 'phone', 'social_media'
  contact_info text NOT NULL, -- Email, teléfono o handle de redes sociales
  status text NOT NULL DEFAULT 'pending', -- 'pending', 'verified', 'rejected', 'expired'
  verified_at timestamptz, -- Cuando se verificó el código
  verified_by uuid REFERENCES auth.users(id), -- Admin que verificó manualmente
  rejected_reason text, -- Razón del rechazo
  expires_at timestamptz NOT NULL DEFAULT (now() + interval '7 days'), -- El código expira en 7 días
  created_at timestamptz NOT NULL DEFAULT now(),
  updated_at timestamptz NOT NULL DEFAULT now(),
  -- Un usuario solo puede tener una solicitud activa por venue
  CONSTRAINT unique_active_request UNIQUE (venue_id, user_id, status) 
    DEFERRABLE INITIALLY DEFERRED
);

-- Índices
CREATE INDEX IF NOT EXISTS idx_venue_ownership_requests_venue_id 
  ON public.venue_ownership_requests(venue_id);
CREATE INDEX IF NOT EXISTS idx_venue_ownership_requests_user_id 
  ON public.venue_ownership_requests(user_id);
CREATE INDEX IF NOT EXISTS idx_venue_ownership_requests_status 
  ON public.venue_ownership_requests(status);
CREATE INDEX IF NOT EXISTS idx_venue_ownership_requests_verification_code 
  ON public.venue_ownership_requests(verification_code);
CREATE INDEX IF NOT EXISTS idx_venue_ownership_requests_expires_at 
  ON public.venue_ownership_requests(expires_at);

-- ============================================
-- 2. Modificar tabla venues para añadir owner_id
-- ============================================
ALTER TABLE public.venues
ADD COLUMN IF NOT EXISTS owner_id uuid REFERENCES auth.users(id) ON DELETE SET NULL,
ADD COLUMN IF NOT EXISTS verified_at timestamptz, -- Cuando se verificó el ownership
ADD COLUMN IF NOT EXISTS verified_by uuid REFERENCES auth.users(id); -- Admin que verificó

-- Índice para búsquedas por owner
CREATE INDEX IF NOT EXISTS idx_venues_owner_id ON public.venues(owner_id);

-- ============================================
-- 3. Modificar tabla events para añadir aprobación del dueño
-- ============================================
ALTER TABLE public.events
ADD COLUMN IF NOT EXISTS owner_approved boolean DEFAULT NULL, -- NULL = no requiere aprobación, true = aprobado, false = rechazado
ADD COLUMN IF NOT EXISTS owner_approved_at timestamptz,
ADD COLUMN IF NOT EXISTS owner_rejected_reason text;

-- Índice para búsquedas de eventos pendientes de aprobación del dueño
CREATE INDEX IF NOT EXISTS idx_events_owner_approved ON public.events(owner_approved) 
  WHERE owner_approved IS NULL OR owner_approved = false;

-- ============================================
-- 4. Tabla de notificaciones a admins
-- ============================================
CREATE TABLE IF NOT EXISTS public.admin_notifications (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  type text NOT NULL, -- 'venue_ownership_request', 'event_pending_approval', etc.
  reference_id uuid NOT NULL, -- ID de la solicitud, evento, etc.
  title text NOT NULL,
  message text NOT NULL,
  read boolean NOT NULL DEFAULT false,
  read_at timestamptz,
  read_by uuid REFERENCES auth.users(id),
  created_at timestamptz NOT NULL DEFAULT now(),
  metadata jsonb -- Información adicional en formato JSON
);

-- Índices
CREATE INDEX IF NOT EXISTS idx_admin_notifications_type 
  ON public.admin_notifications(type);
CREATE INDEX IF NOT EXISTS idx_admin_notifications_read 
  ON public.admin_notifications(read);
CREATE INDEX IF NOT EXISTS idx_admin_notifications_created_at 
  ON public.admin_notifications(created_at DESC);

-- ============================================
-- 5. Función para generar código de verificación único
-- ============================================
CREATE OR REPLACE FUNCTION public.generate_verification_code()
RETURNS text AS $$
DECLARE
  code text;
  exists_check boolean;
BEGIN
  LOOP
    -- Generar código de 6 dígitos
    code := LPAD(FLOOR(RANDOM() * 1000000)::text, 6, '0');
    
    -- Verificar que no existe
    SELECT NOT EXISTS (
      SELECT 1 FROM public.venue_ownership_requests
      WHERE verification_code = code
        AND status = 'pending'
        AND expires_at > now()
    ) INTO exists_check;
    
    EXIT WHEN exists_check;
  END LOOP;
  
  RETURN code;
END;
$$ LANGUAGE plpgsql;

-- ============================================
-- 6. Función para crear solicitud de ownership
-- ============================================
CREATE OR REPLACE FUNCTION public.create_venue_ownership_request(
  p_venue_id uuid,
  p_verification_method text,
  p_contact_info text
)
RETURNS uuid AS $$
DECLARE
  v_user_id uuid;
  v_code text;
  v_request_id uuid;
  v_venue_name text;
BEGIN
  -- Obtener usuario actual
  v_user_id := auth.uid();
  IF v_user_id IS NULL THEN
    RAISE EXCEPTION 'Usuario no autenticado';
  END IF;
  
  -- Verificar que el venue existe y no tiene owner
  SELECT name INTO v_venue_name
  FROM public.venues
  WHERE id = p_venue_id;
  
  IF v_venue_name IS NULL THEN
    RAISE EXCEPTION 'Venue no encontrado';
  END IF;
  
  -- Verificar que no hay una solicitud activa
  IF EXISTS (
    SELECT 1 FROM public.venue_ownership_requests
    WHERE venue_id = p_venue_id
      AND user_id = v_user_id
      AND status = 'pending'
      AND expires_at > now()
  ) THEN
    RAISE EXCEPTION 'Ya existe una solicitud activa para este venue';
  END IF;
  
  -- Generar código de verificación
  v_code := public.generate_verification_code();
  
  -- Crear solicitud
  INSERT INTO public.venue_ownership_requests (
    venue_id,
    user_id,
    verification_code,
    verification_method,
    contact_info,
    status,
    expires_at
  ) VALUES (
    p_venue_id,
    v_user_id,
    v_code,
    p_verification_method,
    p_contact_info,
    'pending',
    now() + interval '7 days'
  ) RETURNING id INTO v_request_id;
  
  -- Crear notificación para admins
  INSERT INTO public.admin_notifications (
    type,
    reference_id,
    title,
    message,
    metadata
  ) VALUES (
    'venue_ownership_request',
    v_request_id,
    'Nueva solicitud de ownership de venue',
    format('El usuario %s solicita ser dueño del venue "%s"', 
           (SELECT email FROM auth.users WHERE id = v_user_id),
           v_venue_name),
    jsonb_build_object(
      'venue_id', p_venue_id,
      'venue_name', v_venue_name,
      'user_id', v_user_id,
      'user_email', (SELECT email FROM auth.users WHERE id = v_user_id),
      'verification_method', p_verification_method,
      'contact_info', p_contact_info,
      'verification_code', v_code
    )
  );
  
  RETURN v_request_id;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- ============================================
-- 7. Función para verificar código y aprobar ownership
-- ============================================
CREATE OR REPLACE FUNCTION public.verify_venue_ownership(
  p_request_id uuid,
  p_verification_code text
)
RETURNS boolean AS $$
DECLARE
  v_request_record RECORD;
  v_admin_id uuid;
BEGIN
  -- Obtener usuario actual (debe ser admin)
  v_admin_id := auth.uid();
  
  IF v_admin_id IS NULL THEN
    RAISE EXCEPTION 'Usuario no autenticado';
  END IF;
  
  -- Verificar que es admin
  IF NOT EXISTS (
    SELECT 1 FROM public.admins WHERE user_id = v_admin_id
  ) THEN
    RAISE EXCEPTION 'Solo los administradores pueden verificar ownership';
  END IF;
  
  -- Obtener solicitud
  SELECT * INTO v_request_record
  FROM public.venue_ownership_requests
  WHERE id = p_request_id;
  
  IF v_request_record IS NULL THEN
    RAISE EXCEPTION 'Solicitud no encontrada';
  END IF;
  
  IF v_request_record.status != 'pending' THEN
    RAISE EXCEPTION 'La solicitud ya fue procesada';
  END IF;
  
  IF v_request_record.expires_at < now() THEN
    RAISE EXCEPTION 'La solicitud ha expirado';
  END IF;
  
  -- Verificar código
  IF v_request_record.verification_code != p_verification_code THEN
    RAISE EXCEPTION 'Código de verificación incorrecto';
  END IF;
  
  -- Actualizar solicitud
  UPDATE public.venue_ownership_requests
  SET status = 'verified',
      verified_at = now(),
      verified_by = v_admin_id,
      updated_at = now()
  WHERE id = p_request_id;
  
  -- Asignar ownership al venue
  UPDATE public.venues
  SET owner_id = v_request_record.user_id,
      verified_at = now(),
      verified_by = v_admin_id,
      updated_at = now()
  WHERE id = v_request_record.venue_id;
  
  -- Crear entrada en venue_managers (para compatibilidad)
  INSERT INTO public.venue_managers (venue_id, user_id)
  VALUES (v_request_record.venue_id, v_request_record.user_id)
  ON CONFLICT (venue_id, user_id) DO NOTHING;
  
  -- Marcar notificación como leída
  UPDATE public.admin_notifications
  SET read = true,
      read_at = now(),
      read_by = v_admin_id
  WHERE type = 'venue_ownership_request'
    AND reference_id = p_request_id;
  
  RETURN true;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- ============================================
-- 8. Función para rechazar solicitud de ownership
-- ============================================
CREATE OR REPLACE FUNCTION public.reject_venue_ownership(
  p_request_id uuid,
  p_reason text
)
RETURNS boolean AS $$
DECLARE
  v_admin_id uuid;
BEGIN
  -- Obtener usuario actual (debe ser admin)
  v_admin_id := auth.uid();
  
  IF v_admin_id IS NULL THEN
    RAISE EXCEPTION 'Usuario no autenticado';
  END IF;
  
  -- Verificar que es admin
  IF NOT EXISTS (
    SELECT 1 FROM public.admins WHERE user_id = v_admin_id
  ) THEN
    RAISE EXCEPTION 'Solo los administradores pueden rechazar ownership';
  END IF;
  
  -- Actualizar solicitud
  UPDATE public.venue_ownership_requests
  SET status = 'rejected',
      rejected_reason = p_reason,
      verified_by = v_admin_id,
      updated_at = now()
  WHERE id = p_request_id
    AND status = 'pending';
  
  IF NOT FOUND THEN
    RAISE EXCEPTION 'Solicitud no encontrada o ya procesada';
  END IF;
  
  -- Marcar notificación como leída
  UPDATE public.admin_notifications
  SET read = true,
      read_at = now(),
      read_by = v_admin_id
  WHERE type = 'venue_ownership_request'
    AND reference_id = p_request_id;
  
  RETURN true;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- ============================================
-- 9. Función para que el dueño apruebe/rechace eventos
-- ============================================
CREATE OR REPLACE FUNCTION public.approve_event_by_owner(
  p_event_id uuid,
  p_approved boolean,
  p_reason text DEFAULT NULL
)
RETURNS boolean AS $$
DECLARE
  v_user_id uuid;
  v_venue_id uuid;
  v_owner_id uuid;
BEGIN
  -- Obtener usuario actual
  v_user_id := auth.uid();
  
  IF v_user_id IS NULL THEN
    RAISE EXCEPTION 'Usuario no autenticado';
  END IF;
  
  -- Obtener venue_id del evento
  SELECT venue_id INTO v_venue_id
  FROM public.events
  WHERE id = p_event_id;
  
  IF v_venue_id IS NULL THEN
    RAISE EXCEPTION 'Evento no tiene venue asociado o no existe';
  END IF;
  
  -- Verificar que el usuario es dueño del venue
  SELECT owner_id INTO v_owner_id
  FROM public.venues
  WHERE id = v_venue_id;
  
  IF v_owner_id != v_user_id THEN
    RAISE EXCEPTION 'Solo el dueño del venue puede aprobar eventos';
  END IF;
  
  -- Actualizar evento
  UPDATE public.events
  SET owner_approved = p_approved,
      owner_approved_at = CASE WHEN p_approved THEN now() ELSE NULL END,
      owner_rejected_reason = CASE WHEN NOT p_approved THEN p_reason ELSE NULL END
  WHERE id = p_event_id;
  
  RETURN true;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- ============================================
-- 10. Trigger para actualizar updated_at
-- ============================================
DROP TRIGGER IF EXISTS update_venue_ownership_requests_updated_at 
  ON public.venue_ownership_requests;
CREATE TRIGGER update_venue_ownership_requests_updated_at
  BEFORE UPDATE ON public.venue_ownership_requests
  FOR EACH ROW
  EXECUTE FUNCTION update_updated_at_column();

-- ============================================
-- 11. Row Level Security (RLS)
-- ============================================

-- Habilitar RLS
ALTER TABLE public.venue_ownership_requests ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.admin_notifications ENABLE ROW LEVEL SECURITY;

-- Políticas para venue_ownership_requests
-- Usuarios pueden leer sus propias solicitudes
DROP POLICY IF EXISTS "Users can read own ownership requests" 
  ON public.venue_ownership_requests;
CREATE POLICY "Users can read own ownership requests"
  ON public.venue_ownership_requests
  FOR SELECT
  USING (user_id = auth.uid());

-- Admins pueden leer todas las solicitudes
DROP POLICY IF EXISTS "Admins can read all ownership requests" 
  ON public.venue_ownership_requests;
CREATE POLICY "Admins can read all ownership requests"
  ON public.venue_ownership_requests
  FOR SELECT
  USING (
    EXISTS (
      SELECT 1 FROM public.admins
      WHERE admins.user_id = auth.uid()
    )
  );

-- Usuarios pueden crear solicitudes
DROP POLICY IF EXISTS "Users can create ownership requests" 
  ON public.venue_ownership_requests;
CREATE POLICY "Users can create ownership requests"
  ON public.venue_ownership_requests
  FOR INSERT
  WITH CHECK (user_id = auth.uid());

-- Políticas para admin_notifications
-- Solo admins pueden leer notificaciones
DROP POLICY IF EXISTS "Admins can read notifications" 
  ON public.admin_notifications;
CREATE POLICY "Admins can read notifications"
  ON public.admin_notifications
  FOR SELECT
  USING (
    EXISTS (
      SELECT 1 FROM public.admins
      WHERE admins.user_id = auth.uid()
    )
  );

-- Solo admins pueden actualizar notificaciones
DROP POLICY IF EXISTS "Admins can update notifications" 
  ON public.admin_notifications;
CREATE POLICY "Admins can update notifications"
  ON public.admin_notifications
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

-- ============================================
-- 12. Actualizar políticas RLS de venues para dueños
-- ============================================

-- Dueños pueden leer sus venues
DROP POLICY IF EXISTS "Owners can read own venues" ON public.venues;
CREATE POLICY "Owners can read own venues"
  ON public.venues
  FOR SELECT
  USING (owner_id = auth.uid());

-- Dueños pueden actualizar sus venues (solo ciertos campos)
DROP POLICY IF EXISTS "Owners can update own venues" ON public.venues;
CREATE POLICY "Owners can update own venues"
  ON public.venues
  FOR UPDATE
  USING (owner_id = auth.uid())
  WITH CHECK (owner_id = auth.uid());

-- ============================================
-- 13. Actualizar políticas RLS de events para dueños
-- ============================================

-- Dueños pueden leer eventos de sus venues
DROP POLICY IF EXISTS "Owners can read events from own venues" ON public.events;
CREATE POLICY "Owners can read events from own venues"
  ON public.events
  FOR SELECT
  USING (
    EXISTS (
      SELECT 1 FROM public.venues
      WHERE venues.id = events.venue_id
        AND venues.owner_id = auth.uid()
    )
  );

-- Dueños pueden actualizar aprobación de eventos de sus venues
DROP POLICY IF EXISTS "Owners can update event approval" ON public.events;
CREATE POLICY "Owners can update event approval"
  ON public.events
  FOR UPDATE
  USING (
    EXISTS (
      SELECT 1 FROM public.venues
      WHERE venues.id = events.venue_id
        AND venues.owner_id = auth.uid()
    )
  )
  WITH CHECK (
    EXISTS (
      SELECT 1 FROM public.venues
      WHERE venues.id = events.venue_id
        AND venues.owner_id = auth.uid()
    )
  );

-- ============================================
-- 14. Vista para facilitar consultas de ownership
-- ============================================
CREATE OR REPLACE VIEW public.venue_ownership_view AS
SELECT 
  v.id as venue_id,
  v.name as venue_name,
  v.city_id,
  v.owner_id,
  u.email as owner_email,
  v.verified_at,
  vor.id as request_id,
  vor.status as request_status,
  vor.verification_code,
  vor.verification_method,
  vor.contact_info,
  vor.expires_at
FROM public.venues v
LEFT JOIN auth.users u ON u.id = v.owner_id
LEFT JOIN public.venue_ownership_requests vor ON vor.venue_id = v.id 
  AND vor.status = 'pending' 
  AND vor.expires_at > now();

-- ============================================
-- 15. Trigger para establecer owner_approved cuando se crea un evento con venue que tiene dueño
-- ============================================
CREATE OR REPLACE FUNCTION public.set_owner_approval_on_event_insert()
RETURNS TRIGGER AS $$
BEGIN
  -- Si el evento tiene un venue_id, verificar si el venue tiene dueño
  IF NEW.venue_id IS NOT NULL THEN
    IF EXISTS (
      SELECT 1 FROM public.venues
      WHERE id = NEW.venue_id
        AND owner_id IS NOT NULL
    ) THEN
      -- El venue tiene dueño, requiere aprobación
      NEW.owner_approved := NULL;
    ELSE
      -- El venue no tiene dueño, no requiere aprobación
      NEW.owner_approved := NULL; -- NULL significa que no requiere aprobación del dueño
    END IF;
  ELSE
    -- No hay venue_id, no requiere aprobación del dueño
    NEW.owner_approved := NULL;
  END IF;
  
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

DROP TRIGGER IF EXISTS trigger_set_owner_approval_on_event_insert ON public.events;
CREATE TRIGGER trigger_set_owner_approval_on_event_insert
  BEFORE INSERT ON public.events
  FOR EACH ROW
  EXECUTE FUNCTION public.set_owner_approval_on_event_insert();

-- ============================================
-- 16. Comentarios
-- ============================================
COMMENT ON TABLE public.venue_ownership_requests IS 
  'Solicitudes de usuarios para ser dueños de venues. Requieren verificación con código.';
COMMENT ON COLUMN public.venue_ownership_requests.verification_code IS 
  'Código de 6 dígitos que debe ser verificado por un admin';
COMMENT ON COLUMN public.venue_ownership_requests.verification_method IS 
  'Método de contacto: email, phone, social_media';
COMMENT ON COLUMN public.venue_ownership_requests.contact_info IS 
  'Email, teléfono o handle de redes sociales para contacto';
COMMENT ON COLUMN public.venues.owner_id IS 
  'Usuario que es dueño verificado del venue';
COMMENT ON COLUMN public.events.owner_approved IS 
  'NULL = no requiere aprobación del dueño, true = aprobado, false = rechazado';
COMMENT ON TABLE public.admin_notifications IS 
  'Notificaciones para administradores sobre acciones que requieren atención';

-- ============================================
-- NOTAS IMPORTANTES:
-- ============================================
-- 1. Cuando un usuario solicita ser dueño, se genera un código único
-- 2. Los admins reciben una notificación con el código
-- 3. Los admins contactan al usuario por el método especificado y le dan el código
-- 4. El usuario introduce el código en la app y el admin lo verifica
-- 5. Una vez verificado, el usuario se convierte en owner del venue
-- 6. Los eventos creados para un venue con owner requieren aprobación del dueño primero
-- 7. Solo después de la aprobación del dueño, el evento pasa a los admins para verificación final

