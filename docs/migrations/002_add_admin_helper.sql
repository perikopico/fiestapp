-- Helper: Scripts útiles para gestión de administradores
-- Estos son comandos SQL que puedes ejecutar cuando necesites gestionar admins

-- ============================================
-- 1. Listar todos los administradores actuales
-- ============================================
-- SELECT 
--   a.id,
--   a.user_id,
--   u.email,
--   a.created_at
-- FROM public.admins a
-- JOIN auth.users u ON a.user_id = u.id
-- ORDER BY a.created_at DESC;

-- ============================================
-- 2. Añadir un nuevo administrador por email
-- ============================================
-- IMPORTANTE: Reemplaza 'email-del-usuario@ejemplo.com' con el email real
--
-- INSERT INTO public.admins (user_id, created_by)
-- SELECT 
--   u.id as user_id,
--   (SELECT id FROM auth.users WHERE email = 'admin-principal@ejemplo.com') as created_by
-- FROM auth.users u
-- WHERE u.email = 'email-del-usuario@ejemplo.com'
-- ON CONFLICT (user_id) DO NOTHING;

-- ============================================
-- 3. Eliminar un administrador
-- ============================================
-- DELETE FROM public.admins
-- WHERE user_id = (SELECT id FROM auth.users WHERE email = 'email-del-usuario@ejemplo.com');

-- ============================================
-- 4. Verificar si un usuario es admin (por email)
-- ============================================
-- SELECT 
--   u.email,
--   public.is_admin(u.id) as is_admin
-- FROM auth.users u
-- WHERE u.email = 'email-del-usuario@ejemplo.com';

-- ============================================
-- 5. Ver todos los usuarios y su estado de admin
-- ============================================
-- SELECT 
--   u.id,
--   u.email,
--   u.created_at,
--   CASE 
--     WHEN a.user_id IS NOT NULL THEN true 
--     ELSE false 
--   END as is_admin,
--   a.created_at as admin_since
-- FROM auth.users u
-- LEFT JOIN public.admins a ON u.id = a.user_id
-- ORDER BY u.created_at DESC;

