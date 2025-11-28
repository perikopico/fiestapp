# 🏢 Sistema de Gestión de Lugares - Guía de Implementación

## ✅ Lo que ya está implementado

1. **Migración SQL** (`005_create_venues_system.sql`):
   - Tabla `venues` con campos necesarios
   - Tabla `venue_managers` (para el futuro)
   - Campo `venue_id` en tabla `events`
   - Políticas RLS
   - Función para buscar lugares similares

2. **Modelo Venue** (`lib/models/venue.dart`):
   - Modelo completo con todos los campos

3. **Servicio VenueService** (`lib/services/venue_service.dart`):
   - Buscar lugares (para autocompletado)
   - Crear lugar nuevo (status='pending')
   - Buscar lugares similares
   - Aprobar/rechazar lugares (admins)

4. **Widget VenueSearchField** (`lib/ui/common/venue_search_field.dart`):
   - Autocompletado con sugerencias
   - Crear lugar nuevo si no existe
   - Indicador de lugar pendiente

5. **Integración en EventSubmitScreen**:
   - Usa VenueSearchField en lugar de TextField simple
   - Guarda `venue_id` cuando hay lugar seleccionado
   - Mantiene compatibilidad con texto libre

---

## 🚀 Pasos para Completar la Implementación

### **PASO 1: Ejecutar Migración SQL** ⚠️ CRÍTICO

1. Ve a Supabase Dashboard > SQL Editor
2. Abre: `docs/migrations/005_create_venues_system.sql`
3. Copia todo el contenido
4. Pégalo en el SQL Editor
5. Ejecuta el script (RUN o `Ctrl+Enter`)
6. Verifica que no haya errores

**Nota**: Esta migración necesita que exista la función `update_updated_at_column()`. Si no existe, añade esto antes de ejecutar la migración:

```sql
-- Función para actualizar updated_at automáticamente
CREATE OR REPLACE FUNCTION update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = now();
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;
```

---

### **PASO 2: Probar el Sistema de Lugares**

1. **Crear un evento con lugar nuevo**:
   - Ve a crear evento
   - Selecciona una ciudad
   - Escribe un nombre de lugar que no exista
   - Debe aparecer la opción "Crear nuevo lugar: ..."
   - Toca esa opción
   - El lugar se crea con status='pending'

2. **Crear un evento con lugar existente**:
   - Escribe las primeras letras de un lugar existente
   - Debe aparecer en las sugerencias
   - Selecciona el lugar
   - El evento se crea con `venue_id` asignado

---

### **PASO 3: Crear Panel Admin para Aprobar Lugares** (Pendiente)

Necesitamos crear una pantalla similar a `PendingEventsScreen` para lugares pendientes:

- Ver lugares con status='pending'
- Ver información del lugar (nombre, ciudad, creador)
- Aprobar o rechazar lugares
- Ver lugares similares (prevenir duplicados)

**Ubicación sugerida**: `lib/ui/admin/pending_venues_screen.dart`

---

### **PASO 4: Integrar en Panel Admin** (Pendiente)

Añadir un enlace en el panel de administración para gestionar lugares pendientes.

---

## 📋 Funcionalidades Pendientes

### Panel Admin para Lugares:

```dart
// lib/ui/admin/pending_venues_screen.dart
- Lista de lugares pendientes
- Aprobar lugar → status='approved'
- Rechazar lugar → status='rejected' + razón
- Ver lugares similares antes de aprobar
- Ver información del creador
```

### Gestión de Gestores (Futuro):

```dart
// Cuando implementemos gestores:
- Asignar gestores a lugares desde admin
- Los gestores pueden gestionar eventos en sus lugares
- Los gestores pueden editar información de sus lugares
```

---

## 🔧 Detalles Técnicos

### Flujo de Creación de Lugar:

1. Usuario escribe nombre de lugar
2. Sistema busca lugares similares en la misma ciudad
3. Si no encuentra, muestra opción "Crear nuevo lugar"
4. Si selecciona crear:
   - Se crea en BD con status='pending'
   - Se asigna al usuario actual (created_by)
   - Se muestra mensaje: "Lugar creado. Está pendiente de aprobación"
5. El lugar solo se puede usar en eventos después de aprobación

### Flujo de Creación de Evento:

1. Usuario selecciona ciudad
2. Usuario busca/selecciona lugar:
   - Si selecciona lugar aprobado → `venue_id` se guarda en evento
   - Si crea lugar nuevo → lugar pendiente, evento también pendiente
   - Si escribe texto libre → solo se guarda `place` (texto)
3. Evento se crea con:
   - `venue_id` (si hay lugar aprobado)
   - `place` (nombre del lugar, para compatibilidad)

### Prevención de Duplicados:

- Constraint UNIQUE(name, city_id) en tabla venues
- Función SQL `find_similar_venues()` para detectar similares
- Admin puede ver lugares similares antes de aprobar

---

## ✅ Checklist de Verificación

- [ ] Ejecutar migración SQL (`005_create_venues_system.sql`)
- [ ] Verificar que la función `update_updated_at_column()` existe
- [ ] Crear un evento con lugar nuevo
- [ ] Verificar que el lugar se crea con status='pending'
- [ ] Crear un evento seleccionando lugar existente
- [ ] Verificar que se guarda `venue_id` en el evento
- [ ] Ver lugares pendientes en Supabase Table Editor
- [ ] Crear pantalla admin para aprobar lugares (PENDIENTE)
- [ ] Añadir enlace a panel admin (PENDIENTE)

---

## 📝 Notas Importantes

1. **Compatibilidad hacia atrás**: Los eventos antiguos seguirán funcionando con solo `place` (texto).

2. **Lugares pendientes**: No aparecen en búsquedas hasta que sean aprobados.

3. **Lugares rechazados**: No se pueden usar en eventos nuevos.

4. **Gestores**: La tabla `venue_managers` está lista para cuando implementemos el sistema de gestores.

---

**¿Listo para ejecutar el SQL?** 🚀
