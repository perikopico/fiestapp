# Plan de Traducción de Eventos Dinámicos

## Estado actual (implementado)

- **Tabla `event_translations`**: Migración 044 creada. Almacena título y descripción en EN, DE, ZH por evento.
- **Panel admin**: En la pantalla de edición/aprobación de eventos hay una sección expandible "Traducciones (EN, DE, ZH)" donde el admin puede añadir título y descripción en inglés, alemán y chino.
- **Entrada por JSON**: Formato definido en `FORMATO_JSON_EVENTOS_MULTIIDIOMA.md`. Instrucciones para Gemini en `INSTRUCCIONES_GEMINI_ENTRADA_EVENTOS.md`.
- **Pendiente**: Modificar la lógica de visualización para que la app muestre el título/descripción traducido según el idioma del dispositivo (ver sección "Al mostrar eventos" más abajo).

## Problema
Los eventos se crean dinámicamente (por administradores y usuarios), y necesitan traducciones a múltiples idiomas (ES, EN, DE, ZH).

## Solución implementada

### 1. Al crear/editar un evento:
- Usuario crea en un solo idioma (típicamente español) → se guarda en `events.title` y `events.description`.
- Admin revisa y puede añadir traducciones EN, DE, ZH en el panel → se guardan en `event_translations`.
- Eventos desde JSON (Gemini) pueden traer ya las 4 traducciones en el formato definido.

### 3. Estructura de Base de Datos

**Opción A: Tabla de traducciones (RECOMENDADA)**
```sql
CREATE TABLE event_translations (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  event_id uuid NOT NULL REFERENCES events(id) ON DELETE CASCADE,
  language_code text NOT NULL, -- 'es', 'en', 'de', 'zh'
  title text NOT NULL,
  description text,
  place text,
  created_at timestamptz DEFAULT now(),
  UNIQUE(event_id, language_code)
);

CREATE INDEX idx_event_translations_event_id ON event_translations(event_id);
CREATE INDEX idx_event_translations_lang ON event_translations(language_code);
```

**Opción B: Campos JSON en events**
```sql
ALTER TABLE events ADD COLUMN title_translations jsonb;
ALTER TABLE events ADD COLUMN description_translations jsonb;
-- Ejemplo: {"es": "Título", "en": "Title", "de": "Titel", "zh": "标题"}
```

## APIs de Traducción Recomendadas

### 1. Google Cloud Translation API (Mejor calidad)
- Coste: $20 por millón de caracteres
- Calidad: Excelente
- Requiere: Cuenta Google Cloud

### 2. DeepL API (Mejor calidad para europeos)
- Coste: Gratis hasta 500k caracteres/mes, luego €5.99/mes
- Calidad: Excelente (especialmente ES, EN, DE)
- No soporta Chino (ZH) en plan gratuito

### 3. LibreTranslate (Open Source, Gratis)
- Coste: Gratis (self-hosted o público)
- Calidad: Buena
- Limitaciones: Rate limits en versión pública

## Implementación Recomendada

1. **Servicio de traducción** en Supabase Edge Function o servicio externo
2. **Trigger en PostgreSQL** para traducir automáticamente al insertar/actualizar eventos
3. **Modificar modelo Event** para incluir método `getLocalizedTitle(locale)`
4. **Usar traducciones guardadas** en lugar de campos originales cuando hay traducción disponible

## Flujo de Trabajo

### Al crear evento:
1. Usuario crea evento en español (o cualquier idioma)
2. Guardar en `events` con idioma original
3. Trigger/Servicio traduce automáticamente a EN, DE, ZH
4. Guardar traducciones en `event_translations`

### Al mostrar evento:
1. Detectar idioma del usuario (ES, EN, DE, ZH)
2. Buscar traducción en `event_translations` para ese idioma
3. Si existe: mostrar traducción
4. Si no existe: mostrar original o traducir on-the-fly (fallback)

## Ventajas de esta Solución

✅ **Rendimiento**: Traducciones pre-calculadas, no hay latencia
✅ **Calidad**: Traducciones revisables y editables
✅ **Coste**: Traduce una vez, no cada visualización
✅ **Escalable**: Funciona con miles de eventos
✅ **Flexible**: Admite traducciones manuales/curated
