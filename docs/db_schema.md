# Esquema de Base de Datos

## Tablas

### cities

| Columna | Tipo | Restricciones |
|---------|------|---------------|
| id | int8 | PRIMARY KEY |
| slug | text | UNIQUE |
| name | text | |

### categories

| Columna | Tipo | Restricciones |
|---------|------|---------------|
| id | int8 | PRIMARY KEY |
| name | text | |
| slug | text | UNIQUE |
| icon | text | |
| color | text | |

### events

| Columna | Tipo | Restricciones |
|---------|------|---------------|
| id | uuid | PRIMARY KEY |
| title | text | |
| place | text | |
| maps_url | text | NULLABLE |
| image_url | text | NULLABLE |
| is_featured | bool | |
| is_free | bool | |
| starts_at | timestamptz | |
| city_id | int8 | FOREIGN KEY -> cities.id |
| category_id | int8 | FOREIGN KEY -> categories.id |

## Vistas

### events_view

Vista que combina la tabla `events` con información de las tablas relacionadas `cities` y `categories`.

**Columnas:**
- Todas las columnas de `events` (events.*)
- `city_name` (desde cities.name)
- `category_name` (desde categories.name)
- `category_icon` (desde categories.icon)
- `category_color` (desde categories.color)

