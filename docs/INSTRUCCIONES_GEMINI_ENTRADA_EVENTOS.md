# Instrucciones para Gemini: Búsqueda y Extracción de Eventos

> Para una **guía completa** con búsqueda exhaustiva, fuentes, ciudades, reglas de eventos multiformes y prompts listos: **[GEMINI_GUIA_COMPLETA_BUSQUEDA_EVENTOS.md](./GEMINI_GUIA_COMPLETA_BUSQUEDA_EVENTOS.md)**

## Objetivo

Extraer eventos de fiestas, cultura, deportes y ocio en la provincia de Cádiz (España) y generar un JSON estructurado listo para importar en la app QuePlan. **Pueden ser eventos nuevos o modificaciones de eventos ya existentes.**

**IMPORTANTE**: Buscar exhaustivamente eventos de **discotecas, pubs, bares con música en vivo y locales nocturnos** en las webs de ayuntamientos de todas las ciudades/pueblos de la provincia. Revisar específicamente las secciones de "Agenda", "Cultura", "Ocio" y "Eventos" de cada ayuntamiento.

---

## Campo `status`: nuevo vs modificado

| Valor | Cuándo usarlo |
|-------|----------------|
| `"new"` | Evento que no existía antes. Es la primera vez que lo incorporamos. |
| `"modified"` | Evento que **ya está en la app** y queremos actualizar (ej: cambió la fecha, la descripción, el precio). El `id` debe ser el mismo que cuando se creó. |
| `"cancelled"` | Evento que se cancela y debe dejar de mostrarse. Solo incluir `id` y `status`. |

**Importante**: El `id` (evt_001, evt_002, …) es el identificador estable del evento. Si en la semana 1 añadiste "evt_042" y en la semana 2 ese evento cambia de fecha o descripción, debes devolverlo de nuevo con `"status": "modified"` y el mismo `id`: `"evt_042"`.

---

## Formato de salida obligatorio

Genera un array JSON. Cada evento debe seguir **exactamente** esta estructura:

```json
[
  {
    "id": "evt_XXX",
    "status": "new",
    "source_lang": "es",
    "translations": {
      "es": {
        "title": "Título del evento en español",
        "description": "Descripción completa en español (mínimo 20 caracteres). Incluir detalles relevantes: qué es, dónde, horario, precio si se conoce."
      },
      "en": {
        "title": "Event title in English",
        "description": "Full description in English. Include relevant details."
      },
      "de": {
        "title": "Titel der Veranstaltung auf Deutsch",
        "description": "Vollständige Beschreibung auf Deutsch."
      },
      "zh": {
        "title": "活动标题（中文）",
        "description": "完整的中文描述。"
      }
    },
    "city": "Nombre de la ciudad (ej: Barbate, Vejer, Cádiz)",
    "category": "Una de: Música, Gastronomía, Deportes, Arte y Cultura, Aire Libre, Tradiciones, Mercadillos",
    "place": "Lugar o recinto del evento",
    "date": "YYYY-MM-DD",
    "time": "HH:mm",
    "price": "Gratis | Precio en € (ej: 15€, Desde 10€)",
    "gmaps_link": "URL de Google Maps (opcional)",
    "info_url": "URL de más información (opcional)",
    "image_alignment": "center"
  }
]
```

---

## Reglas estrictas

1. **ID único y estable**: Formato **string con "evt_" + números** (ej: `"evt_001"`, `"evt_002"`, `"evt_042"`). **NO usar solo números, debe ser texto que empiece con "evt_"**. Un mismo evento real debe tener siempre el mismo id. Si actualizas un evento ya existente, usa el mismo id y `"status": "modified"`.
2. **Traducciones**: Proporciona las 4 traducciones (es, en, de, zh). Si no encuentras la info en otros idiomas, traduce tú el título y descripción desde el español.
3. **Ciudad**: Usa el nombre oficial exacto de la ciudad/pueblo. Debes buscar eventos en **TODAS** las ciudades y pueblos de la provincia de Cádiz. Lista completa disponible en `GEMINI_GUIA_COMPLETA_BUSQUEDA_EVENTOS.md`. Para cada ciudad/pueblo, buscar específicamente en la web del ayuntamiento eventos de discotecas, pubs, bares con música en vivo y locales nocturnos.
4. **Categoría**: Exactamente una de: `Música`, `Gastronomía`, `Deportes`, `Arte y Cultura`, `Aire Libre`, `Tradiciones`, `Mercadillos`.
5. **place (lugar/venue)**: Nombre del recinto o lugar donde ocurre el evento. **Importante**: Si el venue no existe en la app, se creará automáticamente. Un evento solo puede ser aceptado/publicado si su venue existe y está aprobado en la app. Incluye siempre el lugar cuando lo conozcas.
6. **Fecha**: Siempre `YYYY-MM-DD`. Ej: `2026-02-15`.
7. **Hora**: Siempre `HH:mm` en formato 24h. Ej: `20:30`, `10:00`.
8. **Descripción**: Mínimo ~20 caracteres. Incluir información útil para el usuario.

---

## Venues (lugares/recintos)

- El campo **`place`** indica el nombre del venue donde ocurre el evento.
- Los venues que no existan en la app se **crean automáticamente** al importar el JSON.
- **Regla crítica**: Un evento cuyo venue no existe o no está aprobado **no puede ser aceptado** en la app. El script de importación crea los venues necesarios y los aprueba para que el evento se publique.

---

## Ejemplo de evento modificado

Si el evento "Mercado artesanal de Barbate" (evt_001) ya está en la app y cambia la fecha o la descripción:

```json
{
  "id": "evt_001",
  "status": "modified",
  "translations": {
    "es": {
      "title": "Mercado artesanal de Barbate",
      "description": "Nueva descripción actualizada. El mercado se traslada al domingo. Mercado semanal con productos locales."
    },
    "en": { "title": "Barbate Craft Market", "description": "Updated description. Market moves to Sunday." }
  },
  "city": "Barbate",
  "category": "Mercadillos",
  "place": "Paseo Marítimo",
  "date": "2026-02-16",
  "time": "10:00",
  "price": "Gratis"
}
```

---

## Ejemplo de prompt para Gemini

**Solo eventos nuevos:**
```
Busca eventos de [tema/mes/ciudad] en la provincia de Cádiz y genera un JSON 
con el formato especificado en INSTRUCCIONES_GEMINI_ENTRADA_EVENTOS.md. 
Busca específicamente eventos de discotecas, pubs, bares con música en vivo en las webs de ayuntamientos.
Para cada ciudad/pueblo, revisa exhaustivamente la web del ayuntamiento (secciones Agenda, Cultura, Ocio).
Usa status "new" y IDs con formato "evt_001", "evt_002" (string con prefijo "evt_" seguido de números).
```

**Incluyendo actualizaciones:**
```
Busca eventos de [tema/mes/ciudad]. Para cada evento:
- Si es nuevo: status "new" y un id con formato "evt_XXX" único (string con prefijo "evt_" seguido de números, ej: "evt_042").
- Si ya lo habíamos añadido antes y ha cambiado algo: status "modified" y el mismo id que tenía (formato "evt_XXX").
Busca específicamente eventos de discotecas, pubs, bares con música en vivo en las webs de ayuntamientos.
Para cada ciudad/pueblo, revisa exhaustivamente la web del ayuntamiento (secciones Agenda, Cultura, Ocio).
Incluye traducciones en es, en, de, zh.
```

---

## Validación previa a la importación

Antes de importar, verifica que:
- Cada evento tiene `status`: "new", "modified" o "cancelled".
- Los eventos con status "new" o "modified" tienen `translations.es.title` y `translations.es.description`.
- Los "cancelled" solo necesitan `id` y `status`.
- Las fechas son futuras y en formato correcto.
- Las categorías y ciudades están en la lista permitida.
- Los IDs son estables: un mismo evento real siempre usa el mismo id.
