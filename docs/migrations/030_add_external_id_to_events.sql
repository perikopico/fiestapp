-- Migración 030: Agregar campo external_id a la tabla events
-- Este campo almacenará el ID del JSON original para poder mapear eventos de forma confiable

-- Paso 1: Agregar el campo external_id como bigint nullable
ALTER TABLE public.events 
ADD COLUMN IF NOT EXISTS external_id bigint;

-- Paso 2: Agregar un índice único para external_id (para garantizar que no haya duplicados)
CREATE UNIQUE INDEX IF NOT EXISTS idx_events_external_id 
ON public.events(external_id) 
WHERE external_id IS NOT NULL;

-- Verificar que la migración se aplicó correctamente
DO $$
BEGIN
  IF EXISTS (
    SELECT 1 
    FROM information_schema.columns 
    WHERE table_schema = 'public' 
    AND table_name = 'events' 
    AND column_name = 'external_id'
  ) THEN
    RAISE NOTICE '✅ Campo external_id agregado correctamente a la tabla events';
  ELSE
    RAISE EXCEPTION '❌ Error: El campo external_id no se agregó correctamente';
  END IF;
END $$;
