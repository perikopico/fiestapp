-- ============================================================================
-- SETUP COMPLETO: Cron Job para Recordatorios de Favoritos
-- ============================================================================
-- INSTRUCCIONES:
-- 1. Ve a Supabase Dashboard → SQL Editor
-- 2. Copia y pega TODO este archivo
-- 3. Reemplaza [TU-SERVICE-ROLE-KEY] con tu Service Role Key real
--    (Encuéntralo en: Settings → API → service_role key)
-- 4. Ejecuta el script
-- ============================================================================

-- Paso 1: Habilitar extensiones necesarias
CREATE EXTENSION IF NOT EXISTS pg_net;
CREATE EXTENSION IF NOT EXISTS pg_cron;

-- Paso 2: Verificar que las extensiones están habilitadas
DO $$
BEGIN
  IF NOT EXISTS (SELECT 1 FROM pg_extension WHERE extname = 'pg_net') THEN
    RAISE EXCEPTION 'pg_net no está disponible. Contacta con soporte de Supabase.';
  END IF;
  
  IF NOT EXISTS (SELECT 1 FROM pg_extension WHERE extname = 'pg_cron') THEN
    RAISE EXCEPTION 'pg_cron no está disponible en tu plan. Usa GitHub Actions como alternativa (ver docs/ALTERNATIVAS_CRON_JOBS.md)';
  END IF;
  
  RAISE NOTICE '✅ Extensiones habilitadas correctamente';
END $$;

-- Paso 3: Eliminar cron job existente si existe (para evitar duplicados)
SELECT cron.unschedule('send-favorite-reminders-daily') WHERE EXISTS (
  SELECT 1 FROM cron.job WHERE jobname = 'send-favorite-reminders-daily'
);

-- Paso 4: Crear el cron job
-- ⚠️ IMPORTANTE: Reemplaza [TU-SERVICE-ROLE-KEY] con tu Service Role Key real
SELECT cron.schedule(
  'send-favorite-reminders-daily',           -- Nombre del job
  '0 10 * * *',                              -- Schedule: 10:00 AM UTC diariamente
  $$
  SELECT net.http_post(
    url := 'https://oudofaiekedtaovrdqeo.supabase.co/functions/v1/send-favorite-reminders',
    headers := jsonb_build_object(
      'Content-Type', 'application/json',
      'Authorization', 'Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Im91ZG9mYWlla2VkdGFvdnJkcWVvIiwicm9sZSI6InNlcnZpY2Vfcm9sZSIsImlhdCI6MTc2MjI3NTg4MywiZXhwIjoyMDc3ODUxODgzfQ.DmsxMPWEAtn-TJNLpGvWY6Lqvu4KeYz83BYYslqLCFA'
    ),
    body := '{}'::jsonb,
    timeout_milliseconds := 60000
  ) AS request_id;
  $$
);

-- Paso 5: Verificar que el cron job se creó correctamente
DO $$
DECLARE
  job_count INTEGER;
BEGIN
  SELECT COUNT(*) INTO job_count
  FROM cron.job
  WHERE jobname = 'send-favorite-reminders-daily';
  
  IF job_count > 0 THEN
    RAISE NOTICE '✅ Cron job creado exitosamente: send-favorite-reminders-daily';
    RAISE NOTICE '📅 Se ejecutará diariamente a las 10:00 AM UTC';
  ELSE
    RAISE EXCEPTION '❌ Error: El cron job no se creó. Verifica los logs.';
  END IF;
END $$;

-- Paso 6: Mostrar información del cron job
SELECT 
  jobid,
  jobname,
  schedule,
  command,
  nodename,
  nodeport,
  database,
  username,
  active,
  jobid
FROM cron.job
WHERE jobname = 'send-favorite-reminders-daily';

-- Paso 7: Probar manualmente (opcional - descomenta para probar)
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
-- COMANDOS ÚTILES PARA GESTIÓN
-- ============================================================================

-- Ver todos los cron jobs
-- SELECT * FROM cron.job;

-- Ver historial de ejecuciones del último día
-- SELECT 
--   jobid,
--   runid,
--   job_pid,
--   database,
--   username,
--   command,
--   status,
--   return_message,
--   start_time,
--   end_time
-- FROM cron.job_run_details
-- WHERE jobid = (SELECT jobid FROM cron.job WHERE jobname = 'send-favorite-reminders-daily')
-- ORDER BY start_time DESC
-- LIMIT 10;

-- Pausar el cron job (descomenta para usar)
-- SELECT cron.unschedule('send-favorite-reminders-daily');

-- Eliminar el cron job completamente (descomenta para usar)
-- SELECT cron.unschedule('send-favorite-reminders-daily');

-- ============================================================================
-- NOTAS IMPORTANTES:
-- ============================================================================
-- 1. El cron job se ejecuta en UTC. Ajusta el horario según tu zona horaria.
--    Ejemplo para 10:00 AM hora de España (UTC+1 en invierno, UTC+2 en verano):
--    - Invierno: '0 9 * * *' (9:00 AM UTC = 10:00 AM España)
--    - Verano: '0 8 * * *' (8:00 AM UTC = 10:00 AM España)
--
-- 2. Si pg_cron no está disponible, usa GitHub Actions (ver docs/ALTERNATIVAS_CRON_JOBS.md)
--
-- 3. El Service Role Key es muy sensible. NUNCA lo compartas públicamente.
--
-- 4. Puedes probar el cron job manualmente ejecutando el SELECT net.http_post
--    que está comentado arriba.
