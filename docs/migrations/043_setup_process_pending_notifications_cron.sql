-- ============================================================================
-- CRON Job: Procesar Notificaciones Pendientes
-- ============================================================================
-- 
-- Este CRON job ejecuta la Edge Function process-pending-notifications
-- cada 5 minutos para procesar notificaciones en cola.
--
-- IMPORTANTE: Reemplaza [TU-PROJECT-REF] y [TU-SERVICE-ROLE-KEY] antes de ejecutar
-- ============================================================================

-- Verificar que pg_cron esté habilitado
CREATE EXTENSION IF NOT EXISTS pg_cron;

-- Verificar que pg_net esté habilitado (necesario para HTTP requests)
CREATE EXTENSION IF NOT EXISTS pg_net;

-- Eliminar el job si ya existe (para poder recrearlo)
SELECT cron.unschedule('process-pending-notifications-job')
WHERE EXISTS (
  SELECT 1 FROM cron.job WHERE jobname = 'process-pending-notifications-job'
);

-- Crear el CRON job
-- Ejecuta cada 5 minutos: "*/5 * * * *"
SELECT cron.schedule(
  'process-pending-notifications-job',
  '*/5 * * * *', -- Cada 5 minutos
  $$
  SELECT net.http_post(
    url := 'https://oudofaiekedtaovrdqeo.supabase.co/functions/v1/process-pending-notifications',
    headers := jsonb_build_object(
      'Content-Type', 'application/json',
      'Authorization', 'Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Im91ZG9mYWlla2VkdGFvdnJkcWVvIiwicm9sZSI6InNlcnZpY2Vfcm9sZSIsImlhdCI6MTc2MjI3NTg4MywiZXhwIjoyMDc3ODUxODgzfQ.DmsxMPWEAtn-TJNLpGvWY6Lqvu4KeYz83BYYslqLCFA'
    ),
    body := '{}'::jsonb
  ) AS request_id;
  $$
);

-- Comentario
COMMENT ON EXTENSION pg_cron IS 'Extension para ejecutar tareas programadas (CRON jobs)';
COMMENT ON EXTENSION pg_net IS 'Extension para hacer HTTP requests desde PostgreSQL';

-- Verificar que el job se creó correctamente
SELECT 
  jobid,
  schedule,
  command,
  nodename,
  nodeport,
  database,
  username,
  active
FROM cron.job
WHERE jobname = 'process-pending-notifications-job';
