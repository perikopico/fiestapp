# Mejoras de Seguridad Aplicadas

## 1. Edge Function `send_fcm_notification`

### Cambio
- **Antes**: Cualquiera con el anon key podía invocar la función y enviar notificaciones FCM a tokens arbitrarios.
- **Después**: Solo usuarios **autenticados como admin** pueden invocar la función.

### Implementación
- Validación del header `Authorization` (JWT).
- Verificación del usuario con `supabase.auth.getUser(token)`.
- Comprobación de que el usuario está en la tabla `admins`.
- Respuestas 401 (no autenticado) y 403 (no admin) según corresponda.

### Quién la usa
- La app Flutter (`AdminModerationService`) cuando un admin aprueba o rechaza un evento, para notificar al creador.

### Despliegue
Después de editar, vuelve a desplegar la función:
```bash
supabase functions deploy send_fcm_notification
```

---

## 2. Política RLS de Venues (INSERT)

### Cambio
- **Antes**: Cualquier usuario, incluidos anónimos, podía crear venues con `status='pending'` (riesgo de spam).
- **Después**: Solo usuarios **autenticados** (`auth.uid() IS NOT NULL`) pueden crear venues pendientes.

### Migración
- Archivo: `docs/migrations/046_venues_insert_requires_auth.sql`
- Ejecutar en Supabase SQL Editor.

### Importación JSON
Los venues creados por el script de importación (`generar_sql_eventos_simple.py`) se ejecutan en el SQL Editor de Supabase (superusuario), por lo que no se ven afectados por RLS.

### Flujo en la app
- `VenueService.createVenue()` solo se usa cuando el usuario crea un evento y selecciona un lugar nuevo.
- Este flujo exige que el usuario esté autenticado; la app ya envía `created_by` cuando existe sesión.
