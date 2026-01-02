-- Migración: Permitir que usuarios verifiquen su propio código de ownership
-- Ejecutar en Supabase SQL Editor
-- Fecha: Enero 2025

-- ============================================
-- Función para que el usuario verifique su propio código
-- ============================================
CREATE OR REPLACE FUNCTION public.verify_venue_ownership_by_user(
  p_verification_code text
)
RETURNS boolean AS $$
DECLARE
  v_user_id uuid;
  v_request_record RECORD;
BEGIN
  -- Obtener usuario actual
  v_user_id := auth.uid();
  
  IF v_user_id IS NULL THEN
    RAISE EXCEPTION 'Usuario no autenticado';
  END IF;
  
  -- Buscar solicitud pendiente del usuario con el código proporcionado
  SELECT * INTO v_request_record
  FROM public.venue_ownership_requests
  WHERE user_id = v_user_id
    AND verification_code = p_verification_code
    AND status = 'pending'
    AND expires_at > now();
  
  IF v_request_record IS NULL THEN
    RAISE EXCEPTION 'Código de verificación incorrecto o expirado';
  END IF;
  
  -- Actualizar solicitud
  UPDATE public.venue_ownership_requests
  SET status = 'verified',
      verified_at = now(),
      verified_by = v_user_id, -- El usuario se auto-verifica
      updated_at = now()
  WHERE id = v_request_record.id;
  
  -- Asignar ownership al venue
  UPDATE public.venues
  SET owner_id = v_user_id,
      verified_at = now(),
      verified_by = v_user_id, -- Auto-verificado por el usuario
      updated_at = now()
  WHERE id = v_request_record.venue_id;
  
  -- Crear entrada en venue_managers (para compatibilidad)
  INSERT INTO public.venue_managers (venue_id, user_id)
  VALUES (v_request_record.venue_id, v_user_id)
  ON CONFLICT (venue_id, user_id) DO NOTHING;
  
  -- Marcar notificación como leída (si existe)
  UPDATE public.admin_notifications
  SET read = true,
      read_at = now(),
      read_by = v_user_id
  WHERE type = 'venue_ownership_request'
    AND reference_id = v_request_record.id;
  
  RETURN true;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- Comentario
COMMENT ON FUNCTION public.verify_venue_ownership_by_user IS 
'Permite que un usuario verifique su propio código de ownership. El usuario debe proporcionar el código que recibió del administrador.';

