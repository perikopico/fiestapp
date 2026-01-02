# Sistema de Ownership de Venues

Este documento explica el sistema implementado para que los dueños de negocios puedan reclamar y gestionar sus venues en QuePlan.

## Descripción General

El sistema permite que usuarios registrados reclamen la propiedad de un venue (local/negocio) mediante un proceso de verificación. Una vez verificado, el dueño puede:

- Aprobar o rechazar eventos que se crean para su venue
- Gestionar su venue
- Tener control sobre futuras funcionalidades (monetización, etc.)

## Flujo del Sistema

### 1. Solicitud de Ownership

1. Un usuario registrado selecciona un venue que quiere reclamar
2. Completa un formulario con:
   - Método de contacto (email, teléfono, redes sociales)
   - Información de contacto correspondiente
3. Se crea una solicitud en la base de datos con:
   - Un código de verificación único de 6 dígitos
   - Estado "pending"
   - Fecha de expiración (7 días)

### 2. Notificación a Admins

Cuando se crea una solicitud:
- Se crea una notificación en la tabla `admin_notifications`
- Se envía una notificación push a todos los admins (si tienen tokens FCM configurados)
- La notificación incluye:
  - Nombre del venue
  - Email del usuario
  - Método de contacto
  - Información de contacto
  - **Código de verificación**

### 3. Verificación

1. Un admin contacta al usuario por el método especificado (email, teléfono, redes sociales)
2. El admin le proporciona el código de verificación
3. El usuario introduce el código en la app (o el admin lo verifica directamente)
4. El admin verifica el código en la pantalla de administración
5. Si el código es correcto:
   - El usuario se convierte en `owner` del venue
   - Se crea una entrada en `venue_managers` (para compatibilidad)
   - La solicitud se marca como "verified"

### 4. Aprobación de Eventos

Cuando se crea un evento para un venue que tiene dueño:

1. El evento se crea con `owner_approved = NULL` (requiere aprobación)
2. El dueño recibe una notificación (futuro)
3. El dueño puede:
   - **Aprobar** el evento → `owner_approved = true`
   - **Rechazar** el evento → `owner_approved = false` (con razón opcional)
4. Solo después de la aprobación del dueño, el evento pasa a los admins para verificación final
5. Los admins hacen la verificación final y publican el evento

## Estructura de Base de Datos

### Tablas Nuevas

#### `venue_ownership_requests`
Almacena las solicitudes de ownership:
- `id`: UUID
- `venue_id`: ID del venue
- `user_id`: ID del usuario que solicita
- `verification_code`: Código de 6 dígitos
- `verification_method`: 'email', 'phone', 'social_media'
- `contact_info`: Email, teléfono o handle de redes sociales
- `status`: 'pending', 'verified', 'rejected', 'expired'
- `expires_at`: Fecha de expiración (7 días)

#### `admin_notifications`
Notificaciones para administradores:
- `type`: Tipo de notificación ('venue_ownership_request', etc.)
- `reference_id`: ID de la solicitud/evento relacionado
- `title`, `message`: Información de la notificación
- `read`: Si ha sido leída
- `metadata`: JSON con información adicional

### Campos Añadidos

#### Tabla `venues`
- `owner_id`: ID del usuario dueño (UUID, nullable)
- `verified_at`: Fecha de verificación
- `verified_by`: ID del admin que verificó

#### Tabla `events`
- `venue_id`: ID del venue asociado (ya existía)
- `owner_approved`: NULL = no requiere aprobación, true = aprobado, false = rechazado
- `owner_approved_at`: Fecha de aprobación
- `owner_rejected_reason`: Razón del rechazo

## Funciones SQL

### `create_venue_ownership_request`
Crea una solicitud de ownership y notifica a los admins.

**Parámetros:**
- `p_venue_id`: UUID del venue
- `p_verification_method`: 'email', 'phone', 'social_media'
- `p_contact_info`: Información de contacto

**Retorna:** ID de la solicitud creada

### `verify_venue_ownership`
Verifica un código y asigna el ownership.

**Parámetros:**
- `p_request_id`: UUID de la solicitud
- `p_verification_code`: Código de 6 dígitos

**Retorna:** true si se verificó correctamente

### `reject_venue_ownership`
Rechaza una solicitud de ownership.

**Parámetros:**
- `p_request_id`: UUID de la solicitud
- `p_reason`: Razón del rechazo (opcional)

### `approve_event_by_owner`
Aprueba o rechaza un evento por parte del dueño.

**Parámetros:**
- `p_event_id`: UUID del evento
- `p_approved`: true para aprobar, false para rechazar
- `p_reason`: Razón del rechazo (opcional)

## Servicios Flutter

### `VenueOwnershipService`
Gestiona las solicitudes de ownership:
- `requestOwnership()`: Crea una solicitud
- `verifyOwnership()`: Verifica un código (solo admins)
- `rejectOwnership()`: Rechaza una solicitud (solo admins)
- `getMyRequests()`: Obtiene las solicitudes del usuario
- `getPendingRequests()`: Obtiene solicitudes pendientes (solo admins)
- `isOwnerOfVenue()`: Verifica si el usuario es dueño de un venue
- `getMyVenues()`: Obtiene los venues del usuario
- `venueHasOwner()`: Verifica si un venue tiene dueño

### `VenueEventApprovalService`
Gestiona la aprobación de eventos por parte de dueños:
- `approveEvent()`: Aprueba un evento
- `rejectEvent()`: Rechaza un evento
- `getPendingEventsForMyVenues()`: Obtiene eventos pendientes
- `getAllEventsForMyVenues()`: Obtiene todos los eventos
- `canApproveEvent()`: Verifica si el usuario puede aprobar un evento

## Pantallas UI

### Para Usuarios

#### `ClaimVenueScreen`
Pantalla para que los usuarios reclamen un venue:
- Muestra información del venue
- Formulario para seleccionar método de contacto
- Campo para información de contacto
- Envía la solicitud

#### `OwnerEventsScreen`
Pantalla para que los dueños gestionen eventos:
- Tab "Pendientes": Eventos que requieren aprobación
- Tab "Todos": Todos los eventos del venue
- Botones para aprobar/rechazar eventos
- Muestra estado de aprobación

### Para Admins

#### `VenueOwnershipRequestsScreen`
Pantalla para gestionar solicitudes:
- Lista de solicitudes pendientes
- Muestra código de verificación
- Botones para verificar o rechazar
- Información de contacto del usuario

#### `VerifyOwnershipScreen`
Pantalla para verificar códigos:
- Campo para introducir código de 6 dígitos
- Verifica el código contra la base de datos
- Asigna el ownership si es correcto

## Políticas RLS (Row Level Security)

### Venues
- Cualquiera puede leer venues aprobados
- Usuarios pueden leer sus propios venues (incluso pendientes)
- Dueños pueden leer y actualizar sus venues
- Admins pueden leer y gestionar todos los venues

### Events
- Cualquiera puede leer eventos publicados
- Usuarios pueden leer sus propios eventos
- Dueños pueden leer eventos de sus venues
- Dueños pueden actualizar `owner_approved` de eventos de sus venues
- Admins pueden leer y gestionar todos los eventos

### Venue Ownership Requests
- Usuarios pueden leer sus propias solicitudes
- Admins pueden leer todas las solicitudes
- Usuarios pueden crear solicitudes

### Admin Notifications
- Solo admins pueden leer y actualizar notificaciones

## Flujo de Aprobación de Eventos

1. **Usuario crea evento** → Se asigna `venue_id` si seleccionó un venue
2. **Trigger automático** → Si el venue tiene dueño, `owner_approved = NULL`
3. **Evento aparece en "Pendientes"** del dueño
4. **Dueño aprueba/rechaza** → Se actualiza `owner_approved`
5. **Si aprobado** → Evento pasa a los admins para verificación final
6. **Admin verifica y publica** → `status = 'published'`

## Notas Importantes

1. **Códigos de verificación**: Se generan automáticamente y son únicos. Expiran después de 7 días.

2. **Un venue solo puede tener un dueño**: Si un venue ya tiene dueño, no se pueden crear nuevas solicitudes.

3. **Verificación manual**: Los admins deben contactar al usuario manualmente para verificar su identidad. El código se proporciona en la notificación.

4. **Aprobación en dos niveles**:
   - Nivel 1: Dueño del venue (si tiene dueño)
   - Nivel 2: Admins de QuePlan (siempre)

5. **Eventos sin venue**: Si un evento no tiene `venue_id` o el venue no tiene dueño, no requiere aprobación del dueño.

6. **Compatibilidad**: El sistema es compatible con el sistema existente de `venue_managers`.

## Próximos Pasos (Futuro)

- Notificaciones push a dueños cuando hay eventos pendientes
- Dashboard para dueños con estadísticas
- Sistema de monetización para dueños
- Múltiples dueños por venue (socios)
- Transferencia de ownership

## Migración

Para aplicar el sistema, ejecuta la migración SQL:

```sql
-- Ejecutar en Supabase SQL Editor
\i docs/migrations/011_create_venue_ownership_system.sql
```

O copia y pega el contenido del archivo en el SQL Editor de Supabase.

