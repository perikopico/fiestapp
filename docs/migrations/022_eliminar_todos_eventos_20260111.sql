-- ============================================
-- LIMPIEZA COMPLETA: EVENTOS Y VENUES CON PROPIETARIOS
-- ============================================
-- ⚠️ ADVERTENCIA: Este script elimina:
-- 1. TODOS los eventos de la tabla public.events
-- 2. TODOS los venues (lugares) que tienen propietario (created_by IS NOT NULL)
--
-- Los venues sin propietario (created_by IS NULL) se mantienen, ya que son
-- lugares del sistema/oficiales.
--
-- Úsalo solo si quieres empezar completamente limpio.
-- ============================================

-- ============================================
-- 1. CONTAR ANTES DE ELIMINAR
-- ============================================
SELECT COUNT(*) as eventos_antes FROM public.events;
SELECT COUNT(*) as venues_con_propietario_antes FROM public.venues WHERE created_by IS NOT NULL;

-- ============================================
-- 2. ELIMINAR TODOS LOS EVENTOS
-- ============================================
DELETE FROM public.events;

-- ============================================
-- 3. ELIMINAR VENUES CON PROPIETARIOS (DE PRUEBA)
-- ============================================
-- Solo eliminar los venues que fueron creados por usuarios (tienen created_by)
-- Los venues oficiales (created_by IS NULL) se mantienen
DELETE FROM public.venues WHERE created_by IS NOT NULL;

-- ============================================
-- 4. VERIFICAR ELIMINACIÓN
-- ============================================
SELECT COUNT(*) as eventos_despues FROM public.events;
SELECT COUNT(*) as venues_con_propietario_despues FROM public.venues WHERE created_by IS NOT NULL;
SELECT COUNT(*) as venues_oficiales_restantes FROM public.venues WHERE created_by IS NULL;

-- Si eventos_despues = 0 y venues_con_propietario_despues = 0, la limpieza fue exitosa
