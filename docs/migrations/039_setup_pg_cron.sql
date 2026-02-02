-- Migration: Setup pg_cron para Cron Jobs
-- Description: Habilita pg_cron y crea el cron job para recordatorios de favoritos
-- Date: 2026-02-02

-- ============================================================================
-- 1. HABILITAR EXTENSIÓN pg_cron
-- ============================================================================
-- Nota: pg_cron puede requerir permisos especiales en algunos proyectos de Supabase
-- Si no puedes habilitarlo, contacta con el soporte de Supabase o usa una alternativa

CREATE EXTENSION IF NOT EXISTS pg_cron;

-- Verificar que se habilitó correctamente
SELECT * FROM pg_extension WHERE extname = 'pg_cron';

-- ============================================================================
-- 2. CREAR CRON JOB PARA RECORDATORIOS DE FAVORITOS
-- ============================================================================
-- Ejecuta diariamente a las 10:00 AM UTC
-- Schedule: '0 10 * * *' significa: minuto 0, hora 10, todos los días, todos los meses, todos los días de la semana

-- IMPORTANTE: Reemplaza [TU-SERVICE-ROLE-KEY] con tu Service Role Key real
-- Puedes encontrarlo en: Supabase Dashboard → Settings → API → service_role key

SELECT cron.schedule(
  'send-favorite-reminders-daily',           -- Nombre del job
  '0 10 * * *',                              -- Schedule: 10:00 AM UTC diariamente
  $$
  SELECT net.http_post(
    url := 'https://oudofaiekedtaovrdqeo.supabase.co/functions/v1/send-favorite-reminders',
    headers := jsonb_build_object(
      'Content-Type', 'application/json',
      'Authorization', 'Bearer [TU-SERVICE-ROLE-KEY]'
    ),
    body := '{}'::jsonb
  ) AS request_id;
  $$
);

-- ============================================================================
-- 3. VERIFICAR CRON JOBS CREADOS
-- ============================================================================
SELECT * FROM cron.job WHERE jobname = 'send-favorite-reminders-daily';

-- Ver todos los cron jobs
SELECT * FROM cron.job;

-- ============================================================================
-- 4. PROBAR EL CRON JOB MANUALMENTE
-- ============================================================================
-- Puedes ejecutar manualmente el SQL del cron job para probarlo:
/*
SELECT net.http_post(
  url := 'https://oudofaiekedtaovrdqeo.supabase.co/functions/v1/send-favorite-reminders',
  headers := jsonb_build_object(
    'Content-Type', 'application/json',
    'Authorization', 'Bearer [TU-SERVICE-ROLE-KEY]'
  ),
  body := '{}'::jsonb
) AS request_id;
*/

-- ============================================================================
-- 5. GESTIÓN DE CRON JOBS
-- ============================================================================

-- Ver el historial de ejecuciones
SELECT * FROM cron.job_run_details 
WHERE jobid = (SELECT jobid FROM cron.job WHERE jobname = 'send-favorite-reminders-daily')
ORDER BY start_time DESC 
LIMIT 10;

-- Pausar un cron job
-- SELECT cron.unschedule('send-favorite-reminders-daily');

-- Eliminar un cron job
-- SELECT cron.unschedule('send-favorite-reminders-daily');

-- ============================================================================
-- ALTERNATIVAS SI pg_cron NO ESTÁ DISPONIBLE
-- ============================================================================

-- Opción 1: Usar un servicio externo como GitHub Actions, Vercel Cron, etc.
-- Opción 2: Usar un servicio de terceros como cron-job.org
-- Opción 3: Crear un endpoint público y usar un servicio de cron externo

-- Ejemplo de endpoint público (crear una nueva Edge Function):
-- Esta función puede ser llamada por servicios externos sin autenticación
-- (aunque es recomendable usar un secret compartido)

-- ============================================================================
-- NOTAS IMPORTANTES:
-- ============================================================================
-- 1. pg_cron puede no estar disponible en todos los planes de Supabase
-- 2. Si no puedes habilitar pg_cron, considera usar un servicio externo
-- 3. El Service Role Key debe mantenerse seguro y nunca exponerse públicamente
-- 4. Los cron jobs ejecutan SQL directamente en la base de datos
-- 5. Asegúrate de que la extensión pg_net también esté habilitada
