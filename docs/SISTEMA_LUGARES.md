# 🏢 Sistema de Gestión de Lugares (Venues)

## 📋 Resumen del Sistema

Este sistema permite gestionar lugares/locales/negocios de forma estructurada:

- **Tabla `venues`**: Almacena lugares con estado de aprobación
- **Gestión de gestores**: Asignar usuarios como gestores de lugares
- **Autocompletado**: Al crear eventos, sugerencias de lugares existentes
- **Aprobación**: Admin aprueba lugares nuevos antes de que se puedan usar
- **Prevención de duplicados**: Sistema para detectar lugares similares

---

## 🎯 Funcionalidades

### Para Usuarios:
- ✅ Crear eventos y seleccionar lugar existente
- ✅ Crear nuevo lugar si no existe (pendiente de aprobación)
- ✅ Ver lugares aprobados en autocompletado

### Para Admins:
- ✅ Ver lugares pendientes de aprobación
- ✅ Aprobar/rechazar lugares
- ✅ Ver posibles duplicados
- ✅ Asignar gestores a lugares

### Para Gestores (Futuro):
- ✅ Gestionar sus lugares asignados
- ✅ Crear/editar eventos en sus lugares

---

## 📊 Estructura de Base de Datos

### Tabla `venues`
- `id` (uuid, PRIMARY KEY)
- `name` (text) - Nombre del lugar
- `city_id` (int8, FK -> cities.id) - Ciudad del lugar
- `address` (text, nullable) - Dirección completa
- `lat` (float8, nullable) - Latitud
- `lng` (float8, nullable) - Longitud
- `status` (text) - 'pending', 'approved', 'rejected'
- `created_by` (uuid, FK -> auth.users.id, nullable) - Usuario que creó el lugar
- `created_at` (timestamptz)
- `updated_at` (timestamptz)
- `rejected_reason` (text, nullable) - Razón si fue rechazado

### Tabla `venue_managers` (Para el futuro - gestores)
- `id` (uuid, PRIMARY KEY)
- `venue_id` (uuid, FK -> venues.id)
- `user_id` (uuid, FK -> auth.users.id)
- `created_at` (timestamptz)

### Modificar tabla `events`
- Añadir `venue_id` (uuid, FK -> venues.id, nullable)
- Mantener `place` (text) para compatibilidad con eventos antiguos

---

## 🔄 Flujo de Trabajo

### Crear Evento:
1. Usuario escribe en campo "Lugar"
2. Sistema muestra sugerencias de lugares aprobados
3. Si selecciona uno existente → usar `venue_id`
4. Si escribe uno nuevo → crear lugar con status='pending'
5. Evento se crea con `venue_id` o `place` (si lugar pendiente)

### Aprobar Lugar:
1. Admin ve lugares pendientes
2. Admin revisa y aprueba/rechaza
3. Si aprueba → status='approved', puede usarse en eventos
4. Si rechaza → status='rejected', no puede usarse

---

## 📝 Implementación Paso a Paso

### PASO 1: Crear tablas en Supabase
### PASO 2: Crear modelo Venue
### PASO 3: Crear servicio VenueService
### PASO 4: Widget de autocompletado para lugares
### PASO 5: Actualizar creación de eventos
### PASO 6: Panel admin para aprobar lugares

---

**Empezamos con el PASO 1: Migraciones SQL** 🚀
