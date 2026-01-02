-- Script de verificación de Row Level Security (RLS)
-- Ejecutar en Supabase SQL Editor
-- Fecha: Enero 2025
-- 
-- Este script verifica el estado de RLS en todas las tablas públicas
-- y muestra qué tablas necesitan atención

-- ============================================
-- 1. ESTADO DE RLS EN TODAS LAS TABLAS
-- ============================================
SELECT 
    'ESTADO RLS' as seccion,
    tablename AS "Tabla",
    CASE 
        WHEN rowsecurity THEN '✅ RLS Habilitado' 
        ELSE '❌ RLS Deshabilitado - REQUIERE ATENCIÓN' 
    END AS "Estado RLS",
    (SELECT COUNT(*) 
     FROM pg_policies 
     WHERE schemaname = 'public' 
       AND tablename = t.tablename) AS "Número de Políticas",
    CASE 
        WHEN rowsecurity AND (SELECT COUNT(*) FROM pg_policies WHERE schemaname = 'public' AND tablename = t.tablename) > 0 
        THEN '✅ OK'
        WHEN rowsecurity AND (SELECT COUNT(*) FROM pg_policies WHERE schemaname = 'public' AND tablename = t.tablename) = 0 
        THEN '⚠️ RLS habilitado pero sin políticas'
        ELSE '❌ REQUIERE ATENCIÓN'
    END AS "Estado General"
FROM pg_tables t
WHERE schemaname = 'public' 
  AND tablename NOT LIKE 'pg_%'
  AND tablename NOT LIKE '_%'
ORDER BY 
    CASE WHEN rowsecurity THEN 0 ELSE 1 END, -- Priorizar tablas sin RLS
    tablename;

-- ============================================
-- 2. RESUMEN DE SEGURIDAD
-- ============================================
SELECT 
    'RESUMEN' as seccion,
    COUNT(*) as "Total Tablas",
    COUNT(*) FILTER (WHERE rowsecurity) as "Con RLS Habilitado",
    COUNT(*) FILTER (WHERE NOT rowsecurity) as "Sin RLS (CRÍTICO)",
    COUNT(*) FILTER (
        WHERE rowsecurity 
        AND (SELECT COUNT(*) FROM pg_policies WHERE schemaname = 'public' AND tablename = t.tablename) = 0
    ) as "RLS sin Políticas (ADVERTENCIA)"
FROM pg_tables t
WHERE schemaname = 'public' 
  AND tablename NOT LIKE 'pg_%'
  AND tablename NOT LIKE '_%';

-- ============================================
-- 3. TABLAS QUE REQUIEREN ATENCIÓN
-- ============================================
SELECT 
    'TABLAS QUE REQUIEREN ATENCIÓN' as seccion,
    tablename AS "Tabla",
    CASE 
        WHEN NOT rowsecurity THEN '❌ RLS no habilitado'
        WHEN (SELECT COUNT(*) FROM pg_policies WHERE schemaname = 'public' AND tablename = t.tablename) = 0 
        THEN '⚠️ RLS habilitado pero sin políticas'
        ELSE '✅ OK'
    END AS "Problema"
FROM pg_tables t
WHERE schemaname = 'public' 
  AND tablename NOT LIKE 'pg_%'
  AND tablename NOT LIKE '_%'
  AND (
    NOT rowsecurity 
    OR (SELECT COUNT(*) FROM pg_policies WHERE schemaname = 'public' AND tablename = t.tablename) = 0
  )
ORDER BY 
    CASE WHEN NOT rowsecurity THEN 0 ELSE 1 END,
    tablename;

-- ============================================
-- 4. LISTAR TODAS LAS POLÍTICAS POR TABLA
-- ============================================
SELECT 
    'POLÍTICAS CONFIGURADAS' as seccion,
    tablename AS "Tabla",
    policyname AS "Política",
    cmd AS "Operación",
    CASE 
        WHEN cmd = 'SELECT' THEN 'Lectura'
        WHEN cmd = 'INSERT' THEN 'Inserción'
        WHEN cmd = 'UPDATE' THEN 'Actualización'
        WHEN cmd = 'DELETE' THEN 'Eliminación'
        WHEN cmd = 'ALL' THEN 'Todas'
        ELSE cmd
    END AS "Tipo"
FROM pg_policies
WHERE schemaname = 'public'
ORDER BY tablename, cmd, policyname;

-- ============================================
-- 5. VERIFICACIÓN ESPECÍFICA DE TABLAS CRÍTICAS
-- ============================================
SELECT 
    'VERIFICACIÓN TABLAS CRÍTICAS' as seccion,
    tablename AS "Tabla",
    CASE 
        WHEN rowsecurity THEN '✅ RLS ON' 
        ELSE '❌ RLS OFF' 
    END AS "RLS",
    (SELECT COUNT(*) 
     FROM pg_policies 
     WHERE schemaname = 'public' 
       AND tablename = t.tablename) AS "Políticas",
    CASE 
        WHEN rowsecurity AND (SELECT COUNT(*) FROM pg_policies WHERE schemaname = 'public' AND tablename = t.tablename) > 0 
        THEN '✅ SEGURO'
        ELSE '❌ REQUIERE ATENCIÓN'
    END AS "Estado"
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
    'user_fcm_tokens',
    'venue_ownership_requests',
    'admin_notifications',
    'user_consents',
    'content_reports'
  )
ORDER BY 
    CASE WHEN rowsecurity THEN 0 ELSE 1 END,
    tablename;

-- ============================================
-- INTERPRETACIÓN DE RESULTADOS
-- ============================================
-- 
-- ✅ SEGURO: Tabla con RLS habilitado y políticas configuradas
-- ⚠️ ADVERTENCIA: RLS habilitado pero sin políticas (puede ser intencional)
-- ❌ CRÍTICO: RLS no habilitado - REQUIERE CORRECCIÓN INMEDIATA
--
-- Si ves tablas con ❌, ejecuta la migración 007 o habilita RLS manualmente
-- Si ves tablas con ⚠️, verifica si es intencional o añade políticas
--




