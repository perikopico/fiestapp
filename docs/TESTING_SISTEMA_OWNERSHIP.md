# 🧪 Testing del Sistema de Ownership de Venues

**Fecha**: Enero 2025  
**Tiempo estimado**: 15-20 minutos

---

## 📋 Checklist de Testing

### Test 1: Reclamar un Venue (Usuario Normal)

**Pasos**:
1. [ ] Abrir la app
2. [ ] Iniciar sesión con una cuenta de usuario normal (no admin)
3. [ ] Ir a crear un evento o buscar un venue
4. [ ] Buscar un venue aprobado que no tenga dueño
5. [ ] Verificar que aparece el botón "Reclamar" (icono de persona)
6. [ ] Tocar el botón "Reclamar"
7. [ ] Verificar que se abre la pantalla `ClaimVenueScreen`
8. [ ] Seleccionar método de contacto (email, teléfono, redes sociales)
9. [ ] Introducir información de contacto
10. [ ] Enviar la solicitud
11. [ ] Verificar que aparece mensaje de éxito
12. [ ] Verificar que se muestra el ID de solicitud

**Resultado esperado**: ✅ Solicitud creada correctamente

**Verificar en Supabase** (opcional):
```sql
SELECT * FROM venue_ownership_requests 
ORDER BY created_at DESC 
LIMIT 1;
```
Deberías ver una solicitud con `status = 'pending'` y un `verification_code` de 6 dígitos.

---

### Test 2: Ver Solicitud como Admin

**Pasos**:
1. [ ] Cerrar sesión del usuario normal
2. [ ] Iniciar sesión con cuenta de admin
3. [ ] Ir a Perfil
4. [ ] Verificar que aparece la opción "Solicitudes de ownership"
5. [ ] Tocar "Solicitudes de ownership"
6. [ ] Verificar que se abre `VenueOwnershipRequestsScreen`
7. [ ] Verificar que aparece la solicitud creada en el Test 1
8. [ ] Verificar que se muestra:
   - Nombre del venue
   - Email del usuario
   - Método de contacto
   - Información de contacto
   - **Código de verificación** (6 dígitos)
   - Fecha de expiración

**Resultado esperado**: ✅ La solicitud aparece con toda la información

**Verificar en Supabase** (opcional):
```sql
SELECT * FROM admin_notifications 
WHERE type = 'venue_ownership_request' 
ORDER BY created_at DESC 
LIMIT 1;
```
Deberías ver una notificación con el código de verificación en el campo `metadata`.

---

### Test 3: Verificar Ownership (Admin)

**Pasos**:
1. [ ] En la pantalla de solicitudes, tocar el botón "Verificar"
2. [ ] Verificar que se abre `VerifyOwnershipScreen`
3. [ ] Introducir el código de verificación (el que aparece en la solicitud)
4. [ ] Tocar "Verificar código"
5. [ ] Verificar que aparece mensaje de éxito
6. [ ] Verificar que la solicitud desaparece de la lista (o cambia a "verificada")

**Resultado esperado**: ✅ Ownership verificado correctamente

**Verificar en Supabase** (opcional):
```sql
SELECT v.name, v.owner_id, u.email as owner_email
FROM venues v
LEFT JOIN auth.users u ON u.id = v.owner_id
WHERE v.owner_id IS NOT NULL
ORDER BY v.verified_at DESC
LIMIT 1;
```
Deberías ver el venue con el `owner_id` asignado.

---

### Test 4: Ver Mis Venues (Dueño)

**Pasos**:
1. [ ] Cerrar sesión del admin
2. [ ] Iniciar sesión con el usuario que ahora es dueño (del Test 1)
3. [ ] Ir a Perfil
4. [ ] Verificar que aparece la opción "Mis eventos de venues"
5. [ ] Tocar "Mis eventos de venues"
6. [ ] Verificar que se abre `OwnerEventsScreen`
7. [ ] Verificar que hay dos tabs: "Pendientes" y "Todos"

**Resultado esperado**: ✅ El usuario puede acceder a la gestión de eventos

---

### Test 5: Crear Evento para Venue con Dueño

**Pasos**:
1. [ ] Con otro usuario (no el dueño), crear un nuevo evento
2. [ ] Seleccionar el venue que ahora tiene dueño (del Test 3)
3. [ ] Completar el formulario y crear el evento
4. [ ] Verificar que el evento se crea con `status = 'pending'`

**Resultado esperado**: ✅ Evento creado, pendiente de aprobación del dueño

**Verificar en Supabase** (opcional):
```sql
SELECT id, title, venue_id, owner_approved, status
FROM events
WHERE venue_id = 'ID_DEL_VENUE'
ORDER BY created_at DESC
LIMIT 1;
```
Deberías ver `owner_approved = NULL` (requiere aprobación).

---

### Test 6: Aprobar Evento como Dueño

**Pasos**:
1. [ ] Iniciar sesión con el usuario dueño
2. [ ] Ir a "Mis eventos de venues"
3. [ ] Ir al tab "Pendientes"
4. [ ] Verificar que aparece el evento creado en el Test 5
5. [ ] Verificar que muestra "Pendiente de aprobación"
6. [ ] Tocar el botón "Aprobar"
7. [ ] Confirmar la aprobación
8. [ ] Verificar que el evento desaparece de "Pendientes"
9. [ ] Ir al tab "Todos"
10. [ ] Verificar que el evento aparece con estado "Aprobado por ti"

**Resultado esperado**: ✅ Evento aprobado por el dueño

**Verificar en Supabase** (opcional):
```sql
SELECT id, title, owner_approved, owner_approved_at
FROM events
WHERE id = 'ID_DEL_EVENTO';
```
Deberías ver `owner_approved = true` y `owner_approved_at` con fecha.

---

### Test 7: Rechazar Evento como Dueño

**Pasos**:
1. [ ] Crear otro evento para el mismo venue (con otro usuario)
2. [ ] Como dueño, ir a "Mis eventos de venues" > "Pendientes"
3. [ ] Verificar que aparece el nuevo evento
4. [ ] Tocar el botón "Rechazar"
5. [ ] Opcionalmente, añadir una razón
6. [ ] Confirmar el rechazo
7. [ ] Verificar que el evento desaparece de "Pendientes"
8. [ ] Ir al tab "Todos"
9. [ ] Verificar que el evento aparece con estado "Rechazado por ti"

**Resultado esperado**: ✅ Evento rechazado por el dueño

**Verificar en Supabase** (opcional):
```sql
SELECT id, title, owner_approved, owner_rejected_reason
FROM events
WHERE id = 'ID_DEL_EVENTO';
```
Deberías ver `owner_approved = false` y `owner_rejected_reason` si se añadió.

---

### Test 8: Verificar que Venue no se puede Reclamar dos veces

**Pasos**:
1. [ ] Con otro usuario, intentar reclamar el mismo venue (que ya tiene dueño)
2. [ ] Verificar que NO aparece el botón "Reclamar"
3. [ ] O si aparece, verificar que muestra "Tiene dueño verificado"

**Resultado esperado**: ✅ No se puede reclamar un venue que ya tiene dueño

---

## ✅ Resumen de Tests

- [ ] Test 1: Reclamar venue - ✅/❌
- [ ] Test 2: Ver solicitud como admin - ✅/❌
- [ ] Test 3: Verificar ownership - ✅/❌
- [ ] Test 4: Ver mis venues - ✅/❌
- [ ] Test 5: Crear evento para venue con dueño - ✅/❌
- [ ] Test 6: Aprobar evento como dueño - ✅/❌
- [ ] Test 7: Rechazar evento como dueño - ✅/❌
- [ ] Test 8: Verificar protección contra reclamaciones duplicadas - ✅/❌

---

## 🐛 Problemas Comunes y Soluciones

### Problema: No aparece el botón "Reclamar"
**Solución**: Verificar que:
- El usuario está autenticado
- El venue está aprobado (`status = 'approved'`)
- El venue no tiene dueño (`owner_id IS NULL`)

### Problema: Error al crear solicitud
**Solución**: Verificar que:
- El usuario está autenticado
- El venue existe
- No hay una solicitud activa pendiente

### Problema: No aparece "Mis eventos de venues" en perfil
**Solución**: Verificar que:
- El usuario tiene al menos un venue como dueño
- El servicio `VenueOwnershipService.getMyVenues()` funciona

### Problema: No aparecen eventos pendientes
**Solución**: Verificar que:
- El evento tiene `venue_id` asignado
- El venue tiene `owner_id` asignado
- El evento tiene `owner_approved = NULL`

---

## 📝 Notas

- Los tests se pueden hacer en cualquier orden
- Algunos tests dependen de otros (Test 6 depende de Test 5)
- Si un test falla, anota el error y continúa con los demás
- Los tests opcionales de Supabase ayudan a verificar que los datos se guardan correctamente

---

**Tiempo estimado total**: 15-20 minutos




