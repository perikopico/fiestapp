-- ============================================
-- Migración: Corregir problemas de seguridad detectados por Supabase Security Advisor
-- ============================================
-- Ejecutar en Supabase SQL Editor
-- Fecha: Diciembre 2024
--
-- Este script corrige los errores de seguridad más comunes:
-- 1. Tablas sin RLS habilitado (cities, categories)
-- 2. Tablas con RLS pero sin políticas apropiadas
-- 3. Verificación de todas las tablas públicas
-- ============================================

-- ============================================
-- 1. HABILITAR RLS EN TABLAS DE REFERENCIA
-- ============================================

-- Habilitar RLS en cities (tabla de referencia)
ALTER TABLE IF EXISTS public.cities ENABLE ROW LEVEL SECURITY;

-- Habilitar RLS en categories (tabla de referencia)
ALTER TABLE IF EXISTS public.categories ENABLE ROW LEVEL SECURITY;

-- Habilitar RLS en otras tablas que puedan existir
ALTER TABLE IF EXISTS public.venues ENABLE ROW LEVEL SECURITY;
ALTER TABLE IF EXISTS public.venue_managers ENABLE ROW LEVEL SECURITY;
ALTER TABLE IF EXISTS public.user_fcm_tokens ENABLE ROW LEVEL SECURITY;

-- ============================================
-- 2. POLÍTICAS PARA TABLA 'cities'
-- ============================================
-- Las ciudades son datos de referencia públicos (solo lectura)

-- Cualquiera puede leer ciudades (son datos de referencia públicos)
DROP POLICY IF EXISTS "Anyone can read cities" ON public.cities;
CREATE POLICY "Anyone can read cities"
  ON public.cities
  FOR SELECT
  USING (true);

-- Solo admins pueden modificar ciudades
DROP POLICY IF EXISTS "Admins can manage cities" ON public.cities;
CREATE POLICY "Admins can manage cities"
  ON public.cities
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
-- 3. POLÍTICAS PARA TABLA 'categories'
-- ============================================
-- Las categorías son datos de referencia públicos (solo lectura)

-- Cualquiera puede leer categorías (son datos de referencia públicos)
DROP POLICY IF EXISTS "Anyone can read categories" ON public.categories;
CREATE POLICY "Anyone can read categories"
  ON public.categories
  FOR SELECT
  USING (true);

-- Solo admins pueden modificar categorías
DROP POLICY IF EXISTS "Admins can manage categories" ON public.categories;
CREATE POLICY "Admins can manage categories"
  ON public.categories
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
-- 4. VERIFICAR Y CORREGIR POLÍTICAS DE OTRAS TABLAS
-- ============================================

-- Asegurar que user_fcm_tokens tiene políticas (si no las tiene ya)
DO $$
BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM pg_policies 
    WHERE schemaname = 'public' 
    AND tablename = 'user_fcm_tokens'
  ) THEN
    -- Crear política si no existe
    CREATE POLICY "Users can manage own tokens" ON public.user_fcm_tokens
      FOR ALL
      USING (auth.uid() = user_id)
      WITH CHECK (auth.uid() = user_id);
  END IF;
END $$;

-- Asegurar que venues tiene políticas (si no las tiene ya)
DO $$
BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM pg_policies 
    WHERE schemaname = 'public' 
    AND tablename = 'venues'
    AND policyname = 'Anyone can read approved venues'
  ) THEN
    CREATE POLICY "Anyone can read approved venues" ON public.venues
      FOR SELECT
      USING (status = 'approved');
  END IF;
END $$;

-- ============================================
-- 5. VERIFICACIÓN DE SEGURIDAD
-- ============================================
-- Este query te mostrará el estado de RLS en todas las tablas

SELECT 
    'VERIFICACIÓN DE SEGURIDAD' AS seccion,
    tablename AS "Tabla",
    CASE 
        WHEN rowsecurity THEN '✅ RLS Habilitado' 
        ELSE '❌ RLS Deshabilitado - REQUIERE ATENCIÓN' 
    END AS "Estado RLS",
    (SELECT COUNT(*) FROM pg_policies WHERE schemaname = 'public' AND tablename = t.tablename) AS "Número de Políticas"
FROM pg_tables t
WHERE schemaname = 'public' 
AND tablename IN (
    'admins',
    'user_favorites', 
    'events',
    'cities',
    'categories',
    'venues',
    'venue_managers',
    'user_fcm_tokens'
)
ORDER BY 
    CASE WHEN rowsecurity THEN 0 ELSE 1 END, -- Priorizar tablas sin RLS
    tablename;

-- ============================================
-- 6. LISTAR TODAS LAS POLÍTICAS EXISTENTES
-- ============================================

SELECT 
    'POLÍTICAS CONFIGURADAS' AS seccion,
    tablename AS "Tabla",
    policyname AS "Política",
    cmd AS "Operación"
FROM pg_policies
WHERE schemaname = 'public'
ORDER BY tablename, cmd;

-- ============================================
-- NOTAS IMPORTANTES:
-- ============================================
-- 1. Este script habilita RLS en todas las tablas públicas
-- 2. Las tablas cities y categories ahora tienen políticas de solo lectura pública
-- 3. Solo los administradores pueden modificar cities y categories
-- 4. Ejecuta este script y luego revisa el Security Advisor en Supabase
-- 5. Si aún hay errores, revisa el dashboard de Supabase > Security Advisor
--    para ver qué problemas específicos detecta
--
-- Para verificar después de ejecutar:
-- SELECT tablename, rowsecurity 
-- FROM pg_tables 
-- WHERE schemaname = 'public';
-- ============================================

