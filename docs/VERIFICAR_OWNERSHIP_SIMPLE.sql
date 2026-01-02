-- Verificación Simple de Migración 011 - Sistema de Ownership
-- Ejecutar en Supabase SQL Editor
-- Si todos los resultados muestran ✅, la migración está correcta

-- ============================================
-- VERIFICACIÓN RÁPIDA
-- ============================================

-- 1. Verificar tablas (debe devolver 2)
SELECT 
    '1. TABLAS' as verificacion,
    COUNT(*) as encontradas,
    CASE WHEN COUNT(*) = 2 THEN '✅ CORRECTO' ELSE '❌ FALTA ALGO' END as estado
FROM information_schema.tables 
WHERE table_schema = 'public' 
  AND table_name IN ('venue_ownership_requests', 'admin_notifications');

-- 2. Verificar funciones (debe devolver 5)
SELECT 
    '2. FUNCIONES' as verificacion,
    COUNT(*) as encontradas,
    CASE WHEN COUNT(*) = 5 THEN '✅ CORRECTO' ELSE '❌ FALTA ALGO' END as estado
FROM information_schema.routines 
WHERE routine_schema = 'public' 
  AND routine_name IN (
    'generate_verification_code',
    'create_venue_ownership_request',
    'verify_venue_ownership',
    'reject_venue_ownership',
    'approve_event_by_owner'
  );

-- 3. Verificar campos en venues (debe devolver 3)
SELECT 
    '3. CAMPOS VENUES' as verificacion,
    COUNT(*) as encontrados,
    CASE WHEN COUNT(*) = 3 THEN '✅ CORRECTO' ELSE '❌ FALTA ALGO' END as estado
FROM information_schema.columns 
WHERE table_schema = 'public' 
  AND table_name = 'venues' 
  AND column_name IN ('owner_id', 'verified_at', 'verified_by');

-- 4. Verificar campos en events (debe devolver 3)
SELECT 
    '4. CAMPOS EVENTS' as verificacion,
    COUNT(*) as encontrados,
    CASE WHEN COUNT(*) = 3 THEN '✅ CORRECTO' ELSE '❌ FALTA ALGO' END as estado
FROM information_schema.columns 
WHERE table_schema = 'public' 
  AND table_name = 'events' 
  AND column_name IN ('owner_approved', 'owner_approved_at', 'owner_rejected_reason');

-- 5. Verificar triggers (debe devolver 2)
SELECT 
    '5. TRIGGERS' as verificacion,
    COUNT(*) as encontrados,
    CASE WHEN COUNT(*) = 2 THEN '✅ CORRECTO' ELSE '❌ FALTA ALGO' END as estado
FROM information_schema.triggers
WHERE trigger_schema = 'public'
  AND trigger_name IN (
    'update_venue_ownership_requests_updated_at',
    'trigger_set_owner_approval_on_event_insert'
  );

-- 6. Verificar vista (debe devolver 1)
SELECT 
    '6. VISTA' as verificacion,
    COUNT(*) as encontradas,
    CASE WHEN COUNT(*) = 1 THEN '✅ CORRECTO' ELSE '❌ FALTA ALGO' END as estado
FROM information_schema.views
WHERE table_schema = 'public'
  AND table_name = 'venue_ownership_view';

-- ============================================
-- RESUMEN FINAL
-- ============================================
SELECT 
    'RESUMEN' as tipo,
    CASE 
        WHEN (
            (SELECT COUNT(*) FROM information_schema.tables WHERE table_schema = 'public' AND table_name IN ('venue_ownership_requests', 'admin_notifications')) = 2
            AND (SELECT COUNT(*) FROM information_schema.routines WHERE routine_schema = 'public' AND routine_name IN ('generate_verification_code', 'create_venue_ownership_request', 'verify_venue_ownership', 'reject_venue_ownership', 'approve_event_by_owner')) = 5
            AND (SELECT COUNT(*) FROM information_schema.columns WHERE table_schema = 'public' AND table_name = 'venues' AND column_name IN ('owner_id', 'verified_at', 'verified_by')) = 3
            AND (SELECT COUNT(*) FROM information_schema.columns WHERE table_schema = 'public' AND table_name = 'events' AND column_name IN ('owner_approved', 'owner_approved_at', 'owner_rejected_reason')) = 3
            AND (SELECT COUNT(*) FROM information_schema.triggers WHERE trigger_schema = 'public' AND trigger_name IN ('update_venue_ownership_requests_updated_at', 'trigger_set_owner_approval_on_event_insert')) = 2
            AND (SELECT COUNT(*) FROM information_schema.views WHERE table_schema = 'public' AND table_name = 'venue_ownership_view') = 1
        ) THEN '✅ TODAS LAS VERIFICACIONES PASARON - MIGRACIÓN CORRECTA'
        ELSE '❌ ALGUNAS VERIFICACIONES FALLARON - REVISAR RESULTADOS ARRIBA'
    END as resultado;

