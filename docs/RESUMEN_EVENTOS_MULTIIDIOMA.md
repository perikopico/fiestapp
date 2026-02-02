# Resumen: Eventos Multilingüe

## Archivos creados/modificados

### Documentación
| Archivo | Descripción |
|---------|-------------|
| `docs/FORMATO_JSON_EVENTOS_MULTIIDIOMA.md` | Especificación del formato JSON para entrada de eventos con traducciones en los 4 idiomas |
| `docs/INSTRUCCIONES_GEMINI_ENTRADA_EVENTOS.md` | Instrucciones para pasar a Gemini al buscar/extraer eventos |
| `docs/PLAN_TRADUCCION_EVENTOS.md` | Actualizado con el estado actual de implementación |

### Base de datos
| Archivo | Descripción |
|---------|-------------|
| `docs/migrations/044_create_event_translations.sql` | Crea tabla `event_translations` con RLS para admins |

### Código
| Archivo | Descripción |
|---------|-------------|
| `lib/services/event_translation_service.dart` | Servicio para guardar y cargar traducciones |
| `lib/ui/admin/admin_event_edit_screen.dart` | Sección "Traducciones (EN, DE, ZH)" con campos para título y descripción en inglés, alemán y chino |

---

## Uso

### Para Gemini
1. Copia el contenido de `INSTRUCCIONES_GEMINI_ENTRADA_EVENTOS.md`
2. Úsalo como prompt o contexto cuando pidas a Gemini que busque eventos
3. El JSON generado debe seguir el formato de `FORMATO_JSON_EVENTOS_MULTIIDIOMA.md`

### Para el admin
1. Ejecuta la migración 044 en Supabase
2. En el panel admin, al abrir un evento pendiente (o publicado) para revisar/editar
3. Expande la sección "Traducciones (EN, DE, ZH)"
4. Completa título y descripción en inglés, alemán y/o chino
5. Guarda (o guarda y aprueba)

### Venues (lugares)
- El campo `place` del JSON es el nombre del venue. Si no existe, **se crea automáticamente** al importar (con status='approved').
- **Regla**: Un evento solo puede aceptarse si su venue existe y está aprobado. El script crea los venues necesarios.

### Eventos modificados (Gemini puede devolver actualizaciones)
- **Campo `status`**: `"new"` (nuevo), `"modified"` (actualizar existente), `"cancelled"` (cancelar).
- **Script Python**: Genera UPSERT (INSERT ... ON CONFLICT) usando `external_id`. Si un evento con el mismo `id` ya existe, se actualiza en lugar de duplicar.
- **EventIngestionService**: Ya soportaba `status` y `external_id`; usa formato con `location_name`. Para el formato con `translations` y `place`/`city`, usar el script Python.

### Completado (punto 3)
- **Script Python** (`generar_sql_eventos_simple.py`): Soporta formato con `translations` (es, en, de, zh) y genera INSERTs en `event_translations` para EN, DE, ZH cuando existen. Compatible con formato legacy.
- **Visualización en la app**: `EventService` enriquece todos los eventos con traducciones según el idioma del dispositivo (`PlatformDispatcher.instance.locale`). Si el idioma es en, de o zh y existe traducción en `event_translations`, se muestra título y descripción traducidos.
