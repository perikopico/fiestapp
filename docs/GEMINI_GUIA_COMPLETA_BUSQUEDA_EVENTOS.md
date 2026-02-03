# Guía Completa para Gemini: Búsqueda Exhaustiva y Generación de Eventos

> **Documento maestro** para iniciar cualquier conversación con Gemini sobre la extracción de eventos en la provincia de Cádiz. Incluye todo lo necesario para una búsqueda exhaustiva y la generación de JSON con el formato correcto.

---

## 1. Contexto y Objetivo

### ¿Qué es QuePlan?
QuePlan es una app de eventos (fiestas, cultura, deportes, ocio) en la **provincia de Cádiz, España**. Los usuarios consultan qué hacer en la zona.

### Tu misión
Realizar una **búsqueda exhaustiva** de eventos en fuentes oficiales y fiables, y generar un archivo JSON listo para importar en la app. Cada evento debe tener datos completos, verificables y en el formato exacto especificado.

### Alcance geográfico
**Solo la provincia de Cádiz.** No incluir eventos fuera de esta provincia (ej: Sevilla, Málaga capital).

---

## 2. Dónde Buscar Eventos

### 2.1 Fuentes prioritarias (oficiales y fiables)

| Tipo de fuente | Ejemplos | URLs típicas | Qué buscar específicamente |
|----------------|----------|--------------|---------------------------|
| **Webs de ayuntamientos** | Barbate, Cádiz, Jerez, Vejer, Tarifa, etc. | `https://www.ayuntamiento-nombre.es`, secciones: agenda, cultura, deportes, ocio | **CRÍTICO**: Buscar eventos de **discotecas, pubs, bares con música en vivo, locales nocturnos**. Revisar secciones de "Agenda", "Cultura", "Ocio", "Eventos", "Actividades". Muchos ayuntamientos publican calendarios de eventos que incluyen actividades nocturnas y de ocio. |
| **Diputación de Cádiz** | Agenda cultural provincial | `dipucadiz.es`, `agendaculturaldecadiz.es` | Eventos culturales y de ocio de toda la provincia |
| **Turismo oficial** | Turismo Cádiz, Costa de la Luz | `turismocadiz.com`, webs de turismo por comarca | Eventos turísticos, fiestas, ocio nocturno |
| **Clubes deportivos** | Federaciones, clubes de fútbol, atletismo, vela | Webs oficiales de clubes, federaciones andaluzas | Competiciones, partidos, eventos deportivos |
| **Instalaciones deportivas municipales** | Polideportivos, estadios, pistas | Calendarios de reservas/actividades | Eventos deportivos programados |
| **Teatros y salas** | Teatro Principal Cádiz, Gran Teatro Falla | Programación oficial | Conciertos, espectáculos, eventos culturales |
| **Museos y centros culturales** | Baluarte de la Candelaria, Fundaciones | Agenda de exposiciones y actividades | Exposiciones, actividades culturales |
| **Webs de locales nocturnos** | Discotecas, pubs, bares con música | Webs oficiales, redes sociales verificadas | Eventos programados, noches temáticas, conciertos en vivo |

### 2.2 Búsquedas sugeridas (por categoría)

- **Música**: "conciertos Cádiz", "festivales música Cádiz", "flamenco en vivo [ciudad]", **"discotecas [ciudad] eventos", "pubs [ciudad] música en vivo", "bares con música [ciudad]", "agenda ocio nocturno [ciudad]", "eventos discotecas ayuntamiento [ciudad]"**
- **Deportes**: "deportes provincia Cádiz", "competiciones deportivas Cádiz", "liga provincial fútbol Cádiz", "regatas Cádiz", "trail running Sierra de Cádiz", "ciclismo Cádiz", "natación Cádiz"
- **Gastronomía**: "rutas gastronómicas Cádiz", "ferias del vino Jerez", "tapa Cádiz", "degustaciones"
- **Arte y Cultura**: "exposiciones Cádiz", "teatro Cádiz", "agenda cultural ayuntamiento"
- **Tradiciones**: "ferias y fiestas Cádiz", "romerías provincia Cádiz", "Semana Santa Cádiz", "carnaval Cádiz"
- **Mercadillos**: "mercadillos artesanales Cádiz", "mercado medieval", "mercado semanal [ciudad]"
- **Aire Libre**: "rutas senderismo Cádiz", "avistamiento aves", "actividades naturaleza"

**IMPORTANTE - Búsqueda exhaustiva de eventos nocturnos**: Para cada ciudad/pueblo, busca específicamente en la web del ayuntamiento:
- Sección "Agenda de eventos" o "Calendario de actividades"
- Sección "Ocio" o "Cultura"
- Eventos de discotecas, pubs, bares con música en vivo
- Noches temáticas, DJs, conciertos en locales nocturnos
- Eventos programados en establecimientos de hostelería con música

### 2.3 Ciudades y comarcas a cubrir

**OBLIGATORIO**: Incluir eventos de **TODAS** las ciudades y pueblos de la provincia de Cádiz. Para cada ciudad/pueblo, buscar exhaustivamente en:
1. Web oficial del ayuntamiento (secciones: Agenda, Cultura, Ocio, Eventos)
2. Webs de turismo local
3. Fuentes oficiales verificables

Lista completa de ciudades y pueblos válidos (usar nombre exacto tal como aparece):

**La Janda**: 
- Barbate, Zahara de los Atunes, Vejer de la Frontera, Conil de la Frontera, Medina Sidonia, Benalup-Casas Viejas, Alcalá de los Gazules, Paterna de Rivera

**Bahía de Cádiz**: 
- Cádiz, Jerez de la Frontera, San Fernando, El Puerto de Santa María, Chiclana de la Frontera, Puerto Real, La Barca de la Florida, Guadalcacín, Nueva Jarilla, San Isidro del Guadalete, Torrecera, Estella del Marqués, El Torno

**Costa Noroeste**: 
- Sanlúcar de Barrameda, Chipiona, Rota, Trebujena

**Sierra de Cádiz**: 
- Arcos de la Frontera, Ubrique, Olvera, Villamartín, Bornos, Prado del Rey, Algodonales, Puerto Serrano, Alcalá del Valle, San José del Valle, Espera, El Bosque, Grazalema, Setenil de las Bodegas, Benaocaz, Villaluenga del Rosario, El Gastor, Zahara de la Sierra, Algar, Torre Alháquime

**Campo de Gibraltar**: 
- Algeciras, La Línea de la Concepción, San Roque, Los Barrios, Tarifa, Jimena de la Frontera, Castellar de la Frontera, Sotogrande, Facinas, Tahivilla, San Pablo de Buceite, San Martín del Tesorillo

**Otras localidades importantes**:
- Vejer (también conocido como Vejer de la Frontera)
- Zahara (puede referirse a Zahara de los Atunes o Zahara de la Sierra - verificar contexto)

**IMPORTANTE**: Para cada ciudad/pueblo, buscar específicamente eventos de discotecas, pubs, bares con música en vivo y locales nocturnos en la web del ayuntamiento correspondiente.

---

## 3. Tipos de Eventos a Incluir

### 3.1 Por categoría

| Categoría | Ejemplos |
|-----------|----------|
| **Música** | Conciertos, festivales, jam sessions, recitales flamenco |
| **Gastronomía** | Degustaciones, rutas de tapas, ferias del vino, showcookings |
| **Deportes** | Partidos, torneos, carreras populares, regatas, ciclismo, trail, natación |
| **Arte y Cultura** | Exposiciones, teatro, danza, cine, presentaciones de libros |
| **Aire Libre** | Senderismo, rutas guiadas, avistamiento de aves, actividades en naturaleza |
| **Tradiciones** | Ferias, romerías, Semana Santa, carnaval, fiestas patronales |
| **Mercadillos** | Mercados artesanales, medievales, semanales, de antigüedades |

### 3.2 Qué excluir

- Eventos pasados (solo futuros o vigentes)
- Eventos privados o de invitación
- Anuncios comerciales sin fecha concreta
- Eventos fuera de la provincia de Cádiz

---

## 4. Regla Crítica: Eventos de Varios Días

**Si un evento dura más de un día, debes crear UN evento por cada día.**

### Ejemplo

Un "Mercado medieval de Vejer" del 15 al 21 de marzo:

- **NO** un solo evento con fecha 15-21.
- **SÍ** 7 eventos: uno para el 15, otro para el 16, otro para el 17, etc.

Cada evento debe tener:
- **Mismo título** (o variar ligeramente si el día tiene actividad especial: "Día del toro", "Día infantil", etc.)
- **Misma ciudad, lugar y categoría**
- **Fecha y hora** específicas de ese día
- **IDs distintos**: evt_001 (día 15), evt_002 (día 16), evt_003 (día 17), etc.

Si no hay horario concreto por día, usa un horario razonable (ej: 10:00 para mercados, 20:00 para conciertos).

---

## 5. Formato JSON Obligatorio

### 5.1 Estructura de cada evento

```json
{
  "id": "evt_001",
  "status": "new",
  "source_lang": "es",
  "translations": {
    "es": {
      "title": "Título en español",
      "description": "Descripción completa en español (mín. 20 caracteres). Incluir: qué es, dónde, horario, precio, enlace si aplica."
    },
    "en": {
      "title": "Title in English",
      "description": "Full description in English."
    },
    "de": {
      "title": "Titel auf Deutsch",
      "description": "Vollständige Beschreibung auf Deutsch."
    },
    "zh": {
      "title": "标题（中文）",
      "description": "完整的中文描述。"
    }
  },
  "city": "Nombre exacto de la ciudad",
  "category": "Una de: Música, Gastronomía, Deportes, Arte y Cultura, Aire Libre, Tradiciones, Mercadillos",
  "place": "Nombre del recinto o lugar",
  "date": "YYYY-MM-DD",
  "time": "HH:mm",
  "price": "Gratis | 15€ | Desde 10€",
  "gmaps_link": "https://www.google.com/maps/...",
  "info_url": "https://url-oficial-del-evento.es",
  "image_alignment": "center"
}
```

### 5.2 Campos obligatorios

| Campo | Formato | Ejemplo |
|-------|---------|---------|
| `id` | **String con formato "evt_" + números** (evt_001, evt_002, evt_042, etc.). **NO usar solo números**. Debe ser texto que empiece con "evt_" seguido de números. | `"evt_042"` |
| `status` | "new", "modified", "cancelled" | `"new"` |
| `translations.es.title` | Texto | `"Mercado artesanal"` |
| `translations.es.description` | Texto, mín. 20 caracteres | Descripción útil |
| `city` | Nombre exacto de la lista | `"Barbate"` |
| `category` | Exactamente una de las 7 | `"Mercadillos"` |
| `place` | Lugar/recinto | `"Paseo Marítimo"` |
| `date` | YYYY-MM-DD | `"2026-03-15"` |
| `time` | HH:mm (24h) | `"10:00"` |
| `price` | Gratis o precio | `"Gratis"` |

### 5.3 Campos recomendados

- `gmaps_link`: Enlace a Google Maps del lugar
- `info_url`: Web oficial, entradas, más información
- `translations.en`, `translations.de`, `translations.zh`: Si no tienes texto original, **traduce tú** desde el español

---

## 6. Reglas del Campo `status`

| Valor | Cuándo usarlo |
|-------|----------------|
| `"new"` | Evento que incorporas por primera vez |
| `"modified"` | Evento que **ya existe** en la app y ha cambiado (fecha, descripción, precio). Usa el **mismo id** que tenía |
| `"cancelled"` | Evento cancelado. Solo incluir `id` y `status` |

**Importante**: El `id` es **estable**. Si en una semana anterior añadiste "evt_042" y esta semana ese evento cambia de fecha, devuélvelo con `"status": "modified"` y el mismo `id`: `"evt_042"`.

Para eventos **cancelled**, el objeto mínimo es:

```json
{
  "id": "evt_042",
  "status": "cancelled"
}
```

---

## 7. Venues (Lugares/Recintos)

- El campo **`place`** es el nombre del venue donde ocurre el evento.
- Los venues que no existan en la app **se crean automáticamente** al importar el JSON.
- **Regla crítica**: Un evento solo puede publicarse si su venue existe y está aprobado. El script de importación crea y aprueba los venues necesarios.
- **Siempre incluye `place`** cuando conozcas el lugar (plaza, teatro, recinto, estadio, etc.).

---

## 8. Categorías Válidas

Usar **exactamente** uno de estos nombres:

- Música
- Gastronomía
- Deportes
- Arte y Cultura
- Aire Libre
- Tradiciones
- Mercadillos

---

## 9. Checklist Antes de Entregar el JSON

- [ ] Todos los eventos tienen `status`: "new", "modified" o "cancelled"
- [ ] Eventos con status "new" o "modified" tienen `translations.es.title` y `translations.es.description`
- [ ] Los "cancelled" solo tienen `id` y `status`
- [ ] Fechas futuras y en formato YYYY-MM-DD
- [ ] Horas en formato HH:mm (24h)
- [ ] Ciudades con nombre exacto de la lista
- [ ] Categorías exactamente como en la lista
- [ ] Si un evento dura N días, hay N eventos (uno por día)
- [ ] Cada evento tiene `place` cuando el lugar es conocido
- [ ] IDs únicos y estables con formato "evt_XXX" (string con prefijo "evt_" seguido de números, ej: "evt_001", "evt_042")
- [ ] Un mismo evento real = mismo id en futuras actualizaciones

---

## 10. Prompts para Iniciar una Nueva Conversación

### Búsqueda general (exhaustiva)

```
Necesito que busques eventos en la provincia de Cádiz (España) siguiendo la guía completa en docs/GEMINI_GUIA_COMPLETA_BUSQUEDA_EVENTOS.md.

Instrucciones:
1. Busca en webs de ayuntamientos (CRÍTICO: revisar secciones de Agenda, Cultura, Ocio para eventos de discotecas, pubs, bares con música en vivo), Diputación de Cádiz, turismo oficial, clubes deportivos y webs de teatros/museos.
2. Incluye eventos de: música (especialmente discotecas, pubs, música en vivo), gastronomía, deportes, arte y cultura, aire libre, tradiciones y mercadillos.
3. Para cada ciudad/pueblo de la lista completa del documento, busca exhaustivamente en la web del ayuntamiento eventos de ocio nocturno y locales con música.
4. Si un evento dura varios días, crea un evento por cada día.
5. Genera un JSON con el formato exacto del documento (translations en es, en, de, zh; campos city, category, place, date, time, price).
6. Usa status "new" e IDs con formato "evt_001", "evt_002", etc. (string con prefijo "evt_" seguido de números).

Rango de fechas: [especificar, ej: febrero-marzo 2026]
```

### Búsqueda por categoría (música - discotecas y pubs)

```
Busca eventos de MÚSICA (especialmente discotecas, pubs, bares con música en vivo) en la provincia de Cádiz siguiendo docs/GEMINI_GUIA_COMPLETA_BUSQUEDA_EVENTOS.md.

Fuentes prioritarias: webs de ayuntamientos (secciones Agenda, Cultura, Ocio), webs oficiales de locales nocturnos, turismo local.
Incluye: eventos en discotecas, pubs con música en vivo, bares con conciertos, noches temáticas, DJs, eventos programados en locales de hostelería con música.
Para cada ciudad/pueblo de la lista completa, busca exhaustivamente en la web del ayuntamiento.
Genera JSON con formato completo. Un evento por día si dura varios días. Status "new", IDs con formato "evt_001", "evt_002" (string con prefijo "evt_").
```

### Búsqueda por categoría (deportes)

```
Busca eventos DEPORTIVOS en la provincia de Cádiz siguiendo docs/GEMINI_GUIA_COMPLETA_BUSQUEDA_EVENTOS.md.

Fuentes prioritarias: webs de ayuntamientos (sección deportes), federaciones, clubes, polideportivos municipales.
Incluye: partidos de liga, torneos, carreras populares, regatas, ciclismo, trail running, natación, etc.
Genera JSON con formato completo. Un evento por día si dura varios días. Status "new", IDs con formato "evt_001", "evt_002" (string con prefijo "evt_").
```

### Búsqueda por ciudad

```
Busca todos los eventos de [Barbate / Cádiz / Jerez / etc.] en la provincia de Cádiz.

Consulta: web del ayuntamiento (CRÍTICO: revisar secciones Agenda, Cultura, Ocio para eventos de discotecas, pubs, música en vivo), turismo local, agenda cultural.
Busca específicamente eventos de discotecas, pubs, bares con música en vivo y locales nocturnos en la web del ayuntamiento.
Sigue el formato de docs/GEMINI_GUIA_COMPLETA_BUSQUEDA_EVENTOS.md.
Genera JSON con traducciones es, en, de, zh.
Usa IDs con formato "evt_001", "evt_002" (string con prefijo "evt_").
```

### Actualización de eventos existentes

```
Tengo eventos ya importados en la app. Necesito que busques actualizaciones.

Para cada evento que encuentres:
- Si es nuevo: status "new" y un id con formato "evt_XXX" único (string con prefijo "evt_" seguido de números, ej: "evt_042").
- Si ya existía y ha cambiado algo (fecha, descripción, precio): status "modified" y el MISMO id que tenía antes (formato "evt_XXX").

Genera JSON según docs/GEMINI_GUIA_COMPLETA_BUSQUEDA_EVENTOS.md.
```

---

## 11. Documentos Relacionados

- **FORMATO_JSON_EVENTOS_MULTIIDIOMA.md**: Detalle técnico del formato JSON
- **INSTRUCCIONES_GEMINI_ENTRADA_EVENTOS.md**: Resumen ejecutivo para Gemini

---

## 12. Flujo de Trabajo Completo

1. **Tú** inicias conversación con Gemini usando un prompt de la sección 10.
2. **Gemini** busca en fuentes oficiales y genera JSON.
3. **Tú** validas con el checklist (sección 9).
4. **Script** `python scripts/generar_sql_eventos_simple.py < eventos.json > output.sql`
5. **Tú** ejecutas el SQL en Supabase SQL Editor.
6. Los eventos (y venues nuevos) quedan importados en QuePlan.
