# Análisis: Implementación de Múltiples Categorías por Evento

## 📊 Situación Actual

### Estructura de Base de Datos

**Tabla `events`:**
- `category_id` (int8, NOT NULL, FK → categories.id)
- **Un solo campo**: Solo soporta 1 categoría por evento

**Dependencias de `category_id`:**

1. **Vista `events_view`**:
   ```sql
   INNER JOIN categories cat ON e.category_id = cat.id
   ```
   - Usada en muchas consultas
   - Proporciona: `category_name`, `category_icon`, `category_color`

2. **Función `events_within_radius`**:
   - Retorna `category_id`, `category_name`, `category_icon`, `category_color`
   - Usa `INNER JOIN categories cat ON e.category_id = cat.id`

3. **Función `get_popular_events`**:
   - Usa `events_view` (que depende de `category_id`)

4. **Servicio Flutter (`event_service.dart`)**:
   - `fetchEvents(categoryId: ...)` - filtra por `category_id`
   - `listEvents(categoryId: ...)` - filtra por `category_id`
   - Consultas a `events_view` con `.eq('category_id', categoryId)`

### Modelo Event (Dart)
- `categoryId` (int?) - Un solo campo
- `categoryName` (String?) - Un solo campo
- `categoryIcon` (String?) - Un solo campo
- `categoryColor` (String?) - Un solo campo

## 🎯 Requisitos

- **1 categoría obligatoria** (mínimo)
- **2 categorías máximo**
- Mantener compatibilidad con código existente
- Mantener rendimiento de consultas

## 🔍 Opciones de Implementación

### Opción A: Campo `category_id_2` en `events` (SIMPLE)

**Estructura:**
```sql
ALTER TABLE events ADD COLUMN category_id_2 int8 REFERENCES categories(id);
```

**Ventajas:**
- ✅ Muy simple de implementar
- ✅ No requiere cambios en vistas/funciones principales
- ✅ Consultas rápidas (un solo JOIN adicional)
- ✅ Mantiene `category_id` principal (compatibilidad 100%)

**Desventajas:**
- ❌ Límite fijo de 2 categorías (no escalable)
- ❌ Dos campos separados (menos normalizado)

**Cambios necesarios:**
1. Agregar `category_id_2` a tabla `events`
2. Opcional: Actualizar `events_view` para incluir segunda categoría
3. Modificar `Event.fromMap()` para leer `category_id_2`
4. Modificar `submitEvent()` para guardar `category_id_2`

### Opción B: Tabla `event_categories` (NORMALIZADA)

**Estructura:**
```sql
CREATE TABLE event_categories (
  id uuid PRIMARY KEY,
  event_id uuid REFERENCES events(id),
  category_id int8 REFERENCES categories(id),
  is_primary boolean DEFAULT false,
  UNIQUE(event_id, category_id)
);
```

**Ventajas:**
- ✅ Normalizado (mejor diseño)
- ✅ Escalable (fácil agregar más categorías en el futuro)
- ✅ Flexible para queries complejas

**Desventajas:**
- ❌ Más complejo de implementar
- ❌ Requiere cambios en vistas/funciones SQL
- ❌ Consultas más complejas (JOIN adicional)
- ❌ Migración de datos existentes más compleja

**Cambios necesarios:**
1. Crear tabla `event_categories`
2. Modificar `events_view` para hacer LEFT JOIN con `event_categories`
3. Actualizar funciones SQL (`events_within_radius`, etc.)
4. Modificar modelo `Event` para soportar lista de categorías
5. Migrar eventos existentes: `INSERT INTO event_categories SELECT ... FROM events`

## 📋 Recomendación

### **Opción A (Campo `category_id_2`)** - RECOMENDADA

**Razones:**
1. **Simplicidad**: Mínimos cambios en código existente
2. **Rendimiento**: Consultas más rápidas (sin JOINs adicionales)
3. **Compatibilidad**: `category_id` sigue siendo la categoría principal
4. **Suficiente**: Cumple el requisito (1-2 categorías)

**Implementación sugerida:**
- `category_id` → Categoría principal (obligatoria, para compatibilidad)
- `category_id_2` → Segunda categoría (opcional)

### Opción B solo si:
- Se necesita más de 2 categorías en el futuro
- Se quiere un diseño más normalizado
- Se puede invertir más tiempo en migración

## 📝 Próximos Pasos (si se elige Opción A)

1. **Migración SQL**: Agregar `category_id_2` a `events`
2. **Actualizar `Event` model**: Agregar `categoryId2` opcional
3. **Actualizar `Event.fromMap()`**: Leer `category_id_2`
4. **Actualizar `submitEvent()`**: Guardar `category_id_2` si existe
5. **Opcional**: Actualizar `events_view` para incluir segunda categoría
6. **Opcional**: Actualizar UI para mostrar ambas categorías
