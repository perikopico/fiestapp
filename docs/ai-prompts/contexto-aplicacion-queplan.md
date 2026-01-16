# Contexto de la Aplicación QuePlan

## Información para la IA Generadora

Este documento proporciona todo el contexto necesario para que la IA (Gemini) pueda generar eventos coherentes y correctamente estructurados para la aplicación QuePlan.

---

## 1. SOBRE LA APLICACIÓN

**QuePlan** es una aplicación móvil que ayuda a los usuarios a descubrir eventos culturales, deportivos, gastronómicos y de ocio en la **Provincia de Cádiz, España**.

- **Objetivo**: Centralizar información de eventos locales para facilitar la planificación de actividades
- **Ámbito geográfico**: Provincia de Cádiz (Costa de la Luz)
- **Público objetivo**: Residentes y turistas que buscan planes de ocio en la zona

---

## 2. ESTRUCTURA DE LA BASE DE DATOS

### Tabla: `events`
La tabla principal donde se almacenan los eventos tiene estos campos relevantes:

```sql
- id (UUID) - Identificador único
- title (text) - Título del evento
- description (text) - Descripción detallada
- starts_at (timestamptz) - Fecha y hora del evento
- place (text) - Nombre del lugar/venue
- maps_url (text) - URL de Google Maps
- price (text) - Precio como string (ej: "Gratis", "10€")
- info_url (text) - Enlace a fuente original/entradas
- city_id (bigint) - ID de la ciudad (FK a tabla cities)
- category_id (bigint) - ID de la categoría (FK a tabla categories)
- status (text) - 'pending', 'published', 'rejected'
- image_url (text) - URL de la imagen del evento
- image_alignment (text) - 'top', 'center', 'bottom'
- is_featured (boolean) - Si es evento destacado
```

### Tabla: `cities`
Ciudades donde se realizan los eventos:

```sql
- id (bigint) - ID único
- name (text) - Nombre de la ciudad
- lat (double precision) - Latitud
- lng (double precision) - Longitud
- province_id (bigint) - ID de la provincia (Cádiz)
```

### Tabla: `categories`
Categorías de eventos:

```sql
- id (bigint) - ID único
- name (text) - Nombre de la categoría
- slug (text) - Slug único
- icon (text) - Nombre del icono
- color (text) - Color en formato hex (#RRGGBB)
```

---

## 3. CIUDADES DISPONIBLES

### Ciudades Principales de la Provincia de Cádiz

La aplicación se enfoca en estas ciudades (y sus alrededores):

| Nombre de la Ciudad | Coordenadas Aproximadas | Notas |
|---------------------|-------------------------|-------|
| **Barbate** | 36.1927, -5.9219 | Ciudad costera, conocida por el atún |
| **Vejer de la Frontera** | 36.2522, -5.9631 | Pueblo blanco histórico |
| **Zahara de los Atunes** | 36.1364, -5.8458 | Playa y turismo |
| **Conil de la Frontera** | 36.2778, -6.0889 | Playa y pesca |
| **Chiclana de la Frontera** | 36.4194, -6.1375 | Playa y turismo |
| **Jerez de la Frontera** | 36.6866, -6.1370 | Ciudad grande, flamenco, vino |
| **Cádiz** | 36.5270, -6.2886 | Capital de la provincia |
| **El Puerto de Santa María** | 36.5939, -6.2325 | Puerto y playa |
| **Sanlúcar de Barrameda** | 36.7785, -6.3515 | Manzanilla y playa |
| **Rota** | 36.6174, -6.3572 | Base naval y playa |
| **Tarifa** | 36.0139, -5.6044 | Windsurf y kitesurf |
| **Algeciras** | 36.1408, -5.4561 | Puerto y conexión con África |
| **Villaluenga del Rosario** | 36.6964, -5.3847 | Pueblo de montaña |
| **Grazalema** | 36.7581, -5.3664 | Parque Natural |
| **Ubrique** | 36.6778, -5.4450 | Marroquinería |

**IMPORTANTE**: 
- Usa el nombre EXACTO de la ciudad como aparece en la lista
- Si no estás seguro de la ciudad, usa la más cercana geográficamente
- Para generar `gmaps_link`, usa las coordenadas aproximadas o busca el lugar específico

---

## 4. CATEGORÍAS DE EVENTOS

### Categorías Válidas (EXACTAS)

Estas son las ÚNICAS categorías permitidas. Debes usar el nombre EXACTO:

1. **"Música"** (con tilde)
   - Conciertos, festivales, actuaciones musicales, flamenco

2. **"Gastronomía"** (con tilde)
   - Rutas gastronómicas, ferias de comida, degustaciones, tapas

3. **"Deportes"**
   - Competiciones, carreras, eventos deportivos, actividades físicas

4. **"Arte y Cultura"**
   - Exposiciones, teatro, museos, conferencias, talleres culturales

5. **"Aire Libre"**
   - Senderismo, actividades al aire libre, naturaleza, parques

6. **"Tradiciones"**
   - Fiestas populares, tradiciones locales, ferias, romerías

7. **"Mercadillos"**
   - Mercados, mercadillos artesanales, rastros, ferias de artesanía

**CRÍTICO**: 
- Respeta MAYÚSCULAS y TILDES exactamente
- "Música" NO es igual a "Musica"
- "Gastronomía" NO es igual a "Gastronomia"

---

## 5. MAPEO DE CAMPOS: JSON → BASE DE DATOS

Cuando generes el JSON, ten en cuenta cómo se mapea a la BD:

| Campo JSON | Campo BD | Transformación |
|------------|----------|----------------|
| `id` | `id` | Se usa para identificar eventos existentes (UPDATE) o nuevos (INSERT) |
| `status` | - | Lógica de negocio: 'new'→INSERT, 'modified'→UPDATE, 'cancelled'→SOFT DELETE |
| `date` + `time` | `starts_at` | Combinar: `date + "T" + time + ":00Z"` → timestamptz |
| `category` | `category_id` | Buscar por nombre en tabla `categories` |
| `title` | `title` | Directo |
| `description` | `description` | Directo |
| `location_name` | `place` | Directo |
| `gmaps_link` | `maps_url` | Directo |
| `price` | `price` | Directo (ya es string) |
| `info_url` | `info_url` | Directo |

**NOTA**: El backend se encargará de:
- Buscar el `city_id` por nombre de ciudad
- Buscar el `category_id` por nombre de categoría
- Generar UUIDs para eventos nuevos
- Combinar `date` + `time` en `starts_at`

---

## 6. EJEMPLOS DE EVENTOS REALES

### Ejemplo 1: Festival de Música
```json
{
  "id": 1,
  "status": "new",
  "date": "2026-07-15",
  "time": "21:00:00",
  "category": "Música",
  "title": "Festival de Flamenco de Jerez",
  "description": "Gran festival de flamenco con artistas locales e internacionales. Incluye actuaciones en directo, talleres y degustación gastronómica. Una noche inolvidable de música y tradición.",
  "location_name": "Teatro Villamarta",
  "gmaps_link": "https://www.google.com/maps?q=36.6866,-6.1370",
  "price": "25-35€",
  "info_url": "https://www.festivalflamencojerez.com"
}
```

### Ejemplo 2: Ruta Gastronómica
```json
{
  "id": 2,
  "status": "new",
  "date": "2026-02-14",
  "time": "12:00:00",
  "category": "Gastronomía",
  "title": "Ruta de la Tapa de Barbate",
  "description": "Recorre los mejores bares y restaurantes de Barbate degustando tapas exclusivas. Incluye mapa de la ruta y descuentos especiales. Disfruta de la gastronomía local.",
  "location_name": "Centro de Barbate",
  "gmaps_link": "https://www.google.com/maps?q=36.1927,-5.9219",
  "price": "Gratis",
  "info_url": ""
}
```

### Ejemplo 3: Evento Deportivo
```json
{
  "id": 3,
  "status": "new",
  "date": "2026-03-20",
  "time": "10:00:00",
  "category": "Deportes",
  "title": "Trail Urbano Villaluenga",
  "description": "Carrera de trail running por las calles y senderos de Villaluenga del Rosario. Distancias: 10km y 21km. Inscripciones abiertas.",
  "location_name": "Piscina Municipal, Villaluenga del Rosario",
  "gmaps_link": "https://www.google.com/maps?q=36.6964,-5.3847",
  "price": "15€",
  "info_url": "https://www.trailvillaluenga.com"
}
```

### Ejemplo 4: Mercadillo
```json
{
  "id": 4,
  "status": "new",
  "date": "2026-01-25",
  "time": "10:00:00",
  "category": "Mercadillos",
  "title": "Mercadillo Artesanal de Vejer",
  "description": "Mercadillo de productos artesanales y locales en el casco histórico de Vejer. Encuentra artesanía, productos locales y mucho más.",
  "location_name": "Plaza de España, Vejer",
  "gmaps_link": "https://www.google.com/maps?q=36.2522,-5.9631",
  "price": "Gratis",
  "info_url": ""
}
```

---

## 7. CONTEXTO GEOGRÁFICO Y CULTURAL

### Características de la Provincia de Cádiz

- **Clima**: Mediterráneo, veranos cálidos, inviernos suaves
- **Turismo**: Principalmente playas, pero también turismo rural y cultural
- **Cultura**: Fuerte tradición flamenca, gastronomía basada en pescado y marisco
- **Eventos típicos**:
  - Festivales de flamenco (especialmente en Jerez)
  - Ferias y romerías (primavera/verano)
  - Eventos gastronómicos (rutas de tapas, ferias del pescado)
  - Deportes acuáticos (windsurf, kitesurf en Tarifa)
  - Mercadillos artesanales (fines de semana)

### Fechas Importantes

- **Carnaval de Cádiz**: Febrero (muy importante)
- **Feria de Jerez**: Mayo
- **Feria de El Puerto**: Agosto
- **Temporada alta de playa**: Junio-Septiembre
- **Temporada de atún rojo**: Abril-Junio (Barbate, Zahara)

---

## 8. INSTRUCCIONES ESPECIALES PARA LA IA

### Al buscar/generar eventos:

1. **Prioriza eventos reales y verificables**
   - Si encuentras un evento en una web oficial, úsalo
   - Si no encuentras información suficiente, NO inventes detalles

2. **Fechas y horas**
   - Si encuentras "Sábado 24 de enero", convierte a "2026-01-24"
   - Si encuentras "20:00", convierte a "20:00:00"
   - Si no hay hora, usa "00:00:00" pero indica en la descripción que es aproximada

3. **Ubicaciones**
   - Si encuentras "Teatro Falla, Cádiz", usa ese nombre exacto
   - Para `gmaps_link`, busca el lugar en Google Maps y copia la URL
   - Si no encuentras la ubicación exacta, usa coordenadas de la ciudad

4. **Precios**
   - Si dice "Entrada libre" → "Gratis"
   - Si dice "10 euros" → "10€"
   - Si dice "De 15 a 20 euros" → "15-20€"
   - Si no hay información → "Consultar precio"

5. **Categorías**
   - Si es un concierto/flamenco → "Música"
   - Si es comida/restaurante → "Gastronomía"
   - Si es una carrera/deporte → "Deportes"
   - Si es exposición/teatro → "Arte y Cultura"
   - Si es senderismo/naturaleza → "Aire Libre"
   - Si es feria popular/tradicional → "Tradiciones"
   - Si es mercado/artesanía → "Mercadillos"

6. **Status**
   - Si es la primera vez que encuentras el evento → "new"
   - Si encuentras cambios respecto a una versión anterior → "modified"
   - Si el evento está cancelado → "cancelled"
   - Si no hay cambios → "confirmed" (o puedes omitirlo)

---

## 9. FORMATO DE FECHA Y HORA

### Fecha: `date`
- **Formato**: `"YYYY-MM-DD"`
- **Ejemplos válidos**: 
  - `"2026-01-24"`
  - `"2026-12-31"`
- **Ejemplos INVÁLIDOS**:
  - `"24/01/2026"` ❌
  - `"24-01-2026"` ❌
  - `"enero 24, 2026"` ❌

### Hora: `time`
- **Formato**: `"HH:MM:SS"` (24 horas)
- **Ejemplos válidos**:
  - `"10:00:00"` (10:00 AM)
  - `"20:30:00"` (8:30 PM)
  - `"14:15:00"` (2:15 PM)
- **Ejemplos INVÁLIDOS**:
  - `"10:00"` ❌ (falta segundos)
  - `"8:30 PM"` ❌ (formato 12 horas)
  - `"14:15"` ❌ (falta segundos)

---

## 10. CHECKLIST ANTES DE DEVOLVER JSON

Antes de devolver el JSON, verifica:

- [ ] Todos los campos están presentes
- [ ] `date` está en formato "YYYY-MM-DD"
- [ ] `time` está en formato "HH:MM:SS"
- [ ] `category` es uno de los 7 valores permitidos (con tildes correctas)
- [ ] `status` es uno de: "new", "modified", "cancelled", "confirmed"
- [ ] `gmaps_link` es una URL válida de Google Maps
- [ ] `price` es un string (no número)
- [ ] `title` tiene entre 3-100 caracteres
- [ ] `description` tiene al menos 10 caracteres
- [ ] `location_name` corresponde a un lugar real en la ciudad mencionada
- [ ] No hay campos adicionales no definidos

---

## RESUMEN RÁPIDO PARA LA IA

Cuando busques eventos para QuePlan:

1. **Ámbito**: Provincia de Cádiz, España
2. **Ciudades**: Barbate, Vejer, Zahara, Jerez, Cádiz, etc.
3. **Categorías**: 7 categorías exactas (respetar tildes)
4. **Formato**: JSON estricto según el schema definido
5. **Fechas**: "YYYY-MM-DD" y "HH:MM:SS"
6. **Status**: Determina la acción (new/modified/cancelled)
7. **Veracidad**: Solo eventos reales, no inventar detalles

---

**Última actualización**: Enero 2026
