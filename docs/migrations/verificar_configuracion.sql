-- ============================================
-- Script de Verificación de Configuración
-- ============================================
-- Ejecuta este script en Supabase SQL Editor para verificar
-- que todo esté correctamente configurado
-- ============================================

-- ============================================
-- 1. VERIFICAR TABLAS
-- ============================================
SELECT '1. VERIFICACIÓN DE TABLAS' AS seccion;

SELECT 
    table_name AS "Tabla",
    CASE 
        WHEN table_name IN ('admins', 'user_favorites', 'events', 'cities', 'categories') 
        THEN '✅ Existe' 
        ELSE '⚠️ No requerida' 
    END AS "Estado"
FROM information_schema.tables 
WHERE table_schema = 'public'
AND table_name IN ('admins', 'user_favorites', 'events', 'cities', 'categories')
ORDER BY table_name;

-- ============================================
-- 2. VERIFICAR ROW LEVEL SECURITY (RLS)
-- ============================================
SELECT '' AS "---";
SELECT '2. VERIFICACIÓN DE RLS (Row Level Security)' AS seccion;

SELECT 
    tablename AS "Tabla",
    CASE 
        WHEN rowsecurity THEN '✅ RLS Habilitado' 
        ELSE '❌ RLS Deshabilitado' 
    END AS "Estado"
FROM pg_tables 
WHERE schemaname = 'public' 
AND tablename IN ('admins', 'user_favorites', 'events')
ORDER BY tablename;

-- ============================================
-- 3. VERIFICAR POLÍTICAS RLS
-- ============================================
SELECT '' AS "---";
SELECT '3. VERIFICACIÓN DE POLÍTICAS RLS' AS seccion;

SELECT 
    tablename AS "Tabla",
    policyname AS "Política",
    cmd AS "Operación",
    CASE 
        WHEN policyname IS NOT NULL THEN '✅ Existe' 
        ELSE '❌ Falta' 
    END AS "Estado"
FROM pg_policies
WHERE schemaname = 'public'
AND tablename IN ('admins', 'user_favorites', 'events')
ORDER BY tablename, cmd;

-- ============================================
-- 4. VERIFICAR COLUMNAS DE TABLAS IMPORTANTES
-- ============================================
SELECT '' AS "---";
SELECT '4. VERIFICACIÓN DE COLUMNAS' AS seccion;

-- Verificar tabla events
SELECT 
    'events' AS "Tabla",
    column_name AS "Columna",
    data_type AS "Tipo",
    CASE 
        WHEN column_name = 'status' THEN '✅ Necesaria' 
        ELSE 'OK' 
    END AS "Estado"
FROM information_schema.columns
WHERE table_schema = 'public' 
AND table_name = 'events'
AND column_name = 'status';

-- Verificar tabla admins
SELECT 
    'admins' AS "Tabla",
    column_name AS "Columna",
    data_type AS "Tipo",
    'OK' AS "Estado"
FROM information_schema.columns
WHERE table_schema = 'public' 
AND table_name = 'admins'
AND column_name = 'user_id';

-- Verificar tabla user_favorites
SELECT 
    'user_favorites' AS "Tabla",
    column_name AS "Columna",
    data_type AS "Tipo",
    'OK' AS "Estado"
FROM information_schema.columns
WHERE table_schema = 'public' 
AND table_name = 'user_favorites'
AND column_name IN ('user_id', 'event_id');

-- ============================================
-- 5. VERIFICAR USUARIOS REGISTRADOS
-- ============================================
SELECT '' AS "---";
SELECT '5. USUARIOS REGISTRADOS (últimos 10)' AS seccion;

SELECT 
    email AS "Email",
    CASE 
        WHEN email_confirmed_at IS NOT NULL THEN '✅ Confirmado' 
        ELSE '⏳ Pendiente' 
    END AS "Estado",
    created_at AS "Fecha de Registro"
FROM auth.users
ORDER BY created_at DESC
LIMIT 10;

-- ============================================
-- 6. VERIFICAR ADMINISTRADORES
-- ============================================
SELECT '' AS "---";
SELECT '6. ADMINISTRADORES' AS seccion;

SELECT 
    u.email AS "Email",
    a.created_at AS "Fecha de Creación",
    '✅ Es Admin' AS "Estado"
FROM public.admins a
JOIN auth.users u ON u.id = a.user_id
ORDER BY a.created_at DESC;

-- Si no hay administradores, mostrar mensaje
DO $$
BEGIN
    IF NOT EXISTS (SELECT 1 FROM public.admins) THEN
        RAISE NOTICE '⚠️ No hay administradores registrados. Usa el siguiente SQL para crear uno:';
        RAISE NOTICE 'INSERT INTO public.admins (user_id) SELECT id FROM auth.users WHERE email = ''tu-email@ejemplo.com'';';
    END IF;
END $$;

-- ============================================
-- 7. VERIFICAR FAVORITOS
-- ============================================
SELECT '' AS "---";
SELECT '7. ESTADÍSTICAS DE FAVORITOS' AS seccion;

SELECT 
    COUNT(*) AS "Total Favoritos",
    COUNT(DISTINCT user_id) AS "Usuarios con Favoritos",
    COUNT(DISTINCT event_id) AS "Eventos Favoritos"
FROM public.user_favorites;

-- ============================================
-- 8. VERIFICAR EVENTOS
-- ============================================
SELECT '' AS "---";
SELECT '8. ESTADÍSTICAS DE EVENTOS' AS seccion;

SELECT 
    status AS "Estado",
    COUNT(*) AS "Cantidad"
FROM public.events
GROUP BY status
ORDER BY status;

-- ============================================
-- 9. VERIFICAR FUNCIONES
-- ============================================
SELECT '' AS "---";
SELECT '9. FUNCIONES AUXILIARES' AS seccion;

SELECT 
    routine_name AS "Función",
    CASE 
        WHEN routine_name = 'is_admin' THEN '✅ Existe' 
        ELSE 'OK' 
    END AS "Estado"
FROM information_schema.routines
WHERE routine_schema = 'public'
AND routine_name = 'is_admin';

-- ============================================
-- 10. RESUMEN FINAL
-- ============================================
SELECT '' AS "---";
SELECT '10. RESUMEN DE VERIFICACIÓN' AS seccion;

SELECT 
    'Tablas requeridas' AS "Verificación",
    CASE 
        WHEN EXISTS (SELECT 1 FROM information_schema.tables WHERE table_schema = 'public' AND table_name = 'admins')
         AND EXISTS (SELECT 1 FROM information_schema.tables WHERE table_schema = 'public' AND table_name = 'user_favorites')
         AND EXISTS (SELECT 1 FROM information_schema.tables WHERE table_schema = 'public' AND table_name = 'events')
        THEN '✅ OK'
        ELSE '❌ Falta alguna tabla'
    END AS "Estado"
UNION ALL
SELECT 
    'RLS Habilitado',
    CASE 
        WHEN (SELECT COUNT(*) FROM pg_tables WHERE schemaname = 'public' AND tablename IN ('admins', 'user_favorites', 'events') AND rowsecurity) = 3
        THEN '✅ OK'
        ELSE '❌ Falta habilitar RLS'
    END
UNION ALL
SELECT 
    'Políticas RLS',
    CASE 
        WHEN (SELECT COUNT(*) FROM pg_policies WHERE schemaname = 'public' AND tablename IN ('admins', 'user_favorites', 'events')) >= 7
        THEN '✅ OK'
        ELSE '⚠️ Pueden faltar políticas'
    END
UNION ALL
SELECT 
    'Columna status en events',
    CASE 
        WHEN EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema = 'public' AND table_name = 'events' AND column_name = 'status')
        THEN '✅ OK'
        ELSE '❌ Falta columna status'
    END
UNION ALL
SELECT 
    'Usuarios registrados',
    CASE 
        WHEN EXISTS (SELECT 1 FROM auth.users)
        THEN CONCAT('✅ ', (SELECT COUNT(*)::text FROM auth.users), ' usuario(s)')
        ELSE '⚠️ No hay usuarios'
    END
UNION ALL
SELECT 
    'Administradores',
    CASE 
        WHEN EXISTS (SELECT 1 FROM public.admins)
        THEN CONCAT('✅ ', (SELECT COUNT(*)::text FROM public.admins), ' admin(s)')
        ELSE '⚠️ No hay administradores'
    END;

-- ============================================
-- FIN DEL SCRIPT
-- ============================================
