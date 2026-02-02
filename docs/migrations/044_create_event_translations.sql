-- Migración 044: Tabla event_translations para soporte multilingüe
-- Permite almacenar título y descripción en ES, EN, DE, ZH
-- Los campos events.title y events.description contienen el idioma original (típicamente español)

-- Paso 1: Crear tabla event_translations
CREATE TABLE IF NOT EXISTS public.event_translations (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  event_id uuid NOT NULL REFERENCES public.events(id) ON DELETE CASCADE,
  language_code text NOT NULL CHECK (language_code IN ('es', 'en', 'de', 'zh')),
  title text NOT NULL,
  description text,
  created_at timestamptz DEFAULT now(),
  updated_at timestamptz DEFAULT now(),
  UNIQUE(event_id, language_code)
);

-- Índices para consultas frecuentes
CREATE INDEX IF NOT EXISTS idx_event_translations_event_id 
  ON public.event_translations(event_id);
CREATE INDEX IF NOT EXISTS idx_event_translations_language 
  ON public.event_translations(language_code);

-- RLS: Solo lecturas públicas (la app muestra traducciones según idioma del usuario)
ALTER TABLE public.event_translations ENABLE ROW LEVEL SECURITY;

-- Política: Cualquiera puede leer traducciones (eventos publicados se ven por todos)
CREATE POLICY "event_translations_select" ON public.event_translations
  FOR SELECT USING (true);

-- Política: Solo admins pueden insertar/actualizar (desde panel admin)
CREATE POLICY "event_translations_insert_admin" ON public.event_translations
  FOR INSERT WITH CHECK (
    EXISTS (SELECT 1 FROM public.admins WHERE user_id = auth.uid())
  );

CREATE POLICY "event_translations_update_admin" ON public.event_translations
  FOR UPDATE USING (
    EXISTS (SELECT 1 FROM public.admins WHERE user_id = auth.uid())
  );

CREATE POLICY "event_translations_delete_admin" ON public.event_translations
  FOR DELETE USING (
    EXISTS (SELECT 1 FROM public.admins WHERE user_id = auth.uid())
  );

-- Función para actualizar updated_at
CREATE OR REPLACE FUNCTION public.update_event_translations_updated_at()
RETURNS TRIGGER AS $$
BEGIN
  NEW.updated_at = now();
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trigger_event_translations_updated_at
  BEFORE UPDATE ON public.event_translations
  FOR EACH ROW EXECUTE FUNCTION public.update_event_translations_updated_at();

-- Comentarios
COMMENT ON TABLE public.event_translations IS 'Traducciones de título y descripción de eventos en ES, EN, DE, ZH';
COMMENT ON COLUMN public.event_translations.language_code IS 'Código ISO: es, en, de, zh';
COMMENT ON COLUMN public.event_translations.title IS 'Título traducido del evento';
COMMENT ON COLUMN public.event_translations.description IS 'Descripción traducida del evento';
