-- Script de verificación para el sistema de ownership de venues
-- Ejecutar en Supabase SQL Editor después de la migración 011
-- Fecha: Enero 2025

-- ============================================
-- 1. VERIFICAR TABLAS
-- ============================================
SELECT 
    'TABLAS' as tipo,
    table_name as nombre,
    CASE 
        WHEN table_name IN ('venue_ownership_requests', 'admin_notifications') 
        THEN '✅ Existe'
        ELSE '❌ No encontrada'
    END as estado
FROM information_schema.tables 
WHERE table_schema = 'public' 
  AND table_name IN ('venue_ownership_requests', 'admin_notifications')
ORDER BY table_name;

-- ============================================
-- 2. VERIFICAR FUNCIONES SQL
-- ============================================
SELECT 
    'FUNCIONES' as tipo,
    routine_name as nombre,
    CASE 
        WHEN routine_name IN (
            'generate_verification_code',
            'create_venue_ownership_request',
            'verify_venue_ownership',
            'reject_venue_ownership',
            'approve_event_by_owner'
        ) 
        THEN '✅ Existe'
        ELSE '❌ No encontrada'
    END as estado
FROM information_schema.routines 
WHERE routine_schema = 'public' 
  AND routine_name IN (
    'generate_verification_code',
    'create_venue_ownership_request',
    'verify_venue_ownership',
    'reject_venue_ownership',
    'approve_event_by_owner'
  )
ORDER BY routine_name;

-- ============================================
-- 3. VERIFICAR CAMPOS NUEVOS EN VENUES
-- ============================================
SELECT 
    'CAMPOS VENUES' as tipo,
    column_name as nombre,
    '✅ Existe' as estado
FROM information_schema.columns 
WHERE table_schema = 'public' 
  AND table_name = 'venues' 
  AND column_name IN ('owner_id', 'verified_at', 'verified_by')
ORDER BY column_name;

-- ============================================
-- 4. VERIFICAR CAMPOS NUEVOS EN EVENTS
-- ============================================
SELECT 
    'CAMPOS EVENTS' as tipo,
    column_name as nombre,
    '✅ Existe' as estado
FROM information_schema.columns 
WHERE table_schema = 'public' 
  AND table_name = 'events' 
  AND column_name IN ('owner_approved', 'owner_approved_at', 'owner_rejected_reason')
ORDER BY column_name;

-- ============================================
-- 5. VERIFICAR POLÍTICAS RLS
-- ============================================
SELECT 
    'POLÍTICAS RLS' as tipo,
    tablename || ' - ' || policyname as nombre,
    '✅ Existe' as estado
FROM pg_policies
WHERE schemaname = 'public'
  AND (
    (tablename = 'venue_ownership_requests' AND policyname LIKE '%ownership%')
    OR (tablename = 'admin_notifications' AND policyname LIKE '%notification%')
    OR (tablename = 'venues' AND policyname LIKE '%Owner%')
    OR (tablename = 'events' AND policyname LIKE '%owner%')
  )
ORDER BY tablename, policyname;

-- ============================================
-- 6. VERIFICAR TRIGGERS
-- ============================================
SELECT 
    'TRIGGERS' as tipo,
    trigger_name as nombre,
    event_object_table as tabla,
    '✅ Existe' as estado
FROM information_schema.triggers
WHERE trigger_schema = 'public'
  AND trigger_name IN (
    'update_venue_ownership_requests_updated_at',
    'trigger_set_owner_approval_on_event_insert'
  )
ORDER BY trigger_name;

-- ============================================
-- 7. VERIFICAR VISTA
-- ============================================
SELECT 
    'VISTAS' as tipo,
    table_name as nombre,
    '✅ Existe' as estado
FROM information_schema.views
WHERE table_schema = 'public'
  AND table_name = 'venue_ownership_view';

-- ============================================
-- RESUMEN FINAL
-- ============================================
SELECT 
    'RESUMEN' as tipo,
    'Total elementos verificados' as nombre,
    COUNT(*)::text as estado
FROM (
    SELECT 'tabla' FROM information_schema.tables WHERE table_schema = 'public' AND table_name IN ('venue_ownership_requests', 'admin_notifications')
    UNION ALL
    SELECT 'funcion' FROM information_schema.routines WHERE routine_schema = 'public' AND routine_name IN ('generate_verification_code', 'create_venue_ownership_request', 'verify_venue_ownership', 'reject_venue_ownership', 'approve_event_by_owner')
    UNION ALL
    SELECT 'campo_venues' FROM information_schema.columns WHERE table_schema = 'public' AND table_name = 'venues' AND column_name IN ('owner_id', 'verified_at', 'verified_by')
    UNION ALL
    SELECT 'campo_events' FROM information_schema.columns WHERE table_schema = 'public' AND table_name = 'events' AND column_name IN ('owner_approved', 'owner_approved_at', 'owner_rejected_reason')
) as elementos;

