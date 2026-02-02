# Formato JSON para Entrada de Eventos Multilingüe

## Resumen

Este documento define el formato de entrada de datos para eventos que serán buscados/extraídos con Gemini e importados a la app QuePlan. La app soporta **4 idiomas**: español (es), inglés (en), alemán (de) y chino (zh).

---

## 1. Estructura del JSON

### 1.1 Formato recomendado: Objeto `translations` por idioma

Cada evento debe incluir ** título y descripción** en los 4 idiomas. El idioma español es obligatorio como base; el resto son opcionales (si faltan, se puede dejar vacío o el admin los completará después).

```json
[
  {
    "id": "evt_001",
    "source_lang": "es",
    "translations": {
      "es": {
        "title": "Mercado artesanal de Barbate",
        "description": "Mercado semanal con productos locales, artesanía y gastronomía típica de la zona."
      },
      "en": {
        "title": "Barbate Craft Market",
        "description": "Weekly market with local products, crafts and typical gastronomy of the area."
      },
      "de": {
        "title": "Kunsthandwerksmarkt in Barbate",
        "description": "Wöchentlicher Markt mit lokalen Produkten, Kunsthandwerk und typischer Gastronomie der Region."
      },
      "zh": {
        "title": "巴爾瓦特手工藝品市場",
        "description": "每週市場，提供當地產品、手工藝和該地區典型美食。"
      }
    },
    "city": "Barbate",
    "category": "Mercadillos",
    "place": "Paseo Marítimo",
    "date": "2026-02-15",
    "time": "10:00",
    "price": "Gratis",
    "gmaps_link": "https://www.google.com/maps/search/?api=1&query=36.1927,-5.9219",
    "info_url": "https://ejemplo.com/evento",
    "image_alignment": "center"
  }
]
```

### 1.2 Formato alternativo: Campos planos por idioma

Si prefieres campos separados:

```json
{
  "id": "evt_002",
  "title_es": "Concierto de flamenco",
  "title_en": "Flamenco concert",
  "title_de": "Flamenco-Konzert",
  "title_zh": "弗拉門戈音樂會",
  "description_es": "Noche de flamenco en vivo con artistas locales.",
  "description_en": "Live flamenco night with local artists.",
  "description_de": "Live-Flamenco-Abend mit lokalen Künstlern.",
  "description_zh": "與當地藝術家一起的現場弗拉門戈之夜。",
  "city": "Vejer",
  "category": "Música",
  "place": "Plaza de España",
  "date": "2026-02-20",
  "time": "20:30",
  "price": "15€"
}
```

**Recomendación**: Usar el formato 1.1 (objeto `translations`) por claridad.

---

## 2. Campos obligatorios (por idioma)

| Campo | Obligatorio | Descripción |
|-------|-------------|-------------|
| `id` | Sí | Identificador único y estable (ej: evt_001). Se usa para `external_id` en BD. Si actualizas un evento, usa el mismo id. |
| `status` | Sí | `"new"` (nuevo), `"modified"` (actualizar uno existente), `"cancelled"` (cancelar/ocultar). Para cancelled solo se necesita id y status. |
| `translations.es` o `title_es` | Sí | Título en español (idioma base). |
| `translations.es.description` o `description_es` | Sí | Descripción en español. Mínimo 20 caracteres. |
| `city` | Sí | Nombre de la ciudad (debe existir en la BD). |
| `category` | Sí | Categoría: Música, Gastronomía, Deportes, Arte y Cultura, Aire Libre, Tradiciones, Mercadillos. |
| `place` | Recomendado | Lugar/sede del evento (nombre del venue). Si no existe, se crea. El evento solo se acepta si el venue existe y está aprobado. |
| `date` | Sí | Fecha en formato YYYY-MM-DD. |
| `time` | Sí | Hora en formato HH:mm (24h). |
| `price` | Sí | Ej: "Gratis", "15€", "Desde 10€". |

---

## 3. Campos opcionales

| Campo | Descripción |
|-------|-------------|
| `translations.en`, `translations.de`, `translations.zh` | Traducciones EN, DE, ZH. Si faltan, el admin las completará. |
| `gmaps_link` / `maps_url` | Enlace a Google Maps. |
| `info_url` | URL de más información (web oficial, entradas, etc.). |
| `image_alignment` | "center", "top", "bottom". Default: "center". |
| `source_lang` | Idioma original si difiere de es. Default: "es". |

---

## 4. Categorías admitidas

- **Música**
- **Gastronomía**
- **Deportes**
- **Arte y Cultura**
- **Aire Libre**
- **Tradiciones**
- **Mercadillos**

---

## 5. Venues (lugares)

- El campo `place` del evento es el **nombre del venue**.
- Venues que no existan se **crean automáticamente** al importar (con `status='approved'` para que el evento pueda publicarse).
- Un evento con `venue_id` solo puede ser aceptado si ese venue existe y está aprobado en la app.

---

## 6. Ciudades

Las ciudades deben existir en la tabla `cities`. Ejemplos: Barbate, Vejer, Zahara, Cádiz, Jerez de la Frontera, El Puerto de Santa María, Sanlúcar de Barrameda, etc. Ver lista completa en la BD.

---

## 7. Flujo de datos

1. **Gemini** genera el JSON con eventos (nuevos o modificados) según este formato.
2. **Script Python** o **EventIngestionService** procesa el JSON:
   - `status: "new"` → INSERT (o UPSERT si ya existe con ese external_id).
   - `status: "modified"` → UPDATE del evento existente (identificado por `id` → `external_id`).
   - `status: "cancelled"` → Marcar evento como rechazado/oculto.
3. Se inserta o actualiza en `events` (title/description = español).
4. Las traducciones se guardan o actualizan en `event_translations` (en, de, zh).
5. La app muestra título/descripción según el idioma del dispositivo.
6. **Panel admin**: El admin puede añadir traducciones EN, DE, ZH al revisar eventos.

---

## 8. Ejemplo mínimo (solo español)

Si solo tienes datos en español, está bien. El admin podrá añadir traducciones después:

```json
{
  "id": "evt_003",
  "translations": {
    "es": {
      "title": "Ruta guiada por el casco histórico",
      "description": "Recorrido a pie por el centro histórico de Zahara con guía local. Duración aproximada 2 horas."
    }
  },
  "city": "Zahara",
  "category": "Arte y Cultura",
  "place": "Plaza Principal",
  "date": "2026-03-01",
  "time": "10:00",
  "price": "Gratis"
}
```

---

## 9. Compatibilidad con formato actual

El script de generación SQL actual usa campos como `title`, `description`, `city`, `category`, `place`, `date`, `time`, `price`, `starts_at`, `gmaps_link`. El nuevo formato con `translations` debe ser soportado por una versión actualizada del script que:

1. Use `translations.es.title` como `title` principal en `events`.
2. Use `translations.es.description` como `description` en `events`.
3. Inserte en `event_translations` los bloques `en`, `de`, `zh` si existen.
