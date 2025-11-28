# Pasos Después del Login Exitoso

## ✅ Ya completado
- [x] Login con Google funciona
- [x] Usuario `info@queplan-app.com` está registrado en Supabase

## 📋 Próximos pasos

### Paso 1: Convertirte en Administrador

Ahora que ya iniciaste sesión, necesitas hacerte administrador para poder acceder al panel de administración.

#### 1.1 Ir al SQL Editor de Supabase

1. Ve a [Supabase Dashboard](https://supabase.com/dashboard)
2. Selecciona tu proyecto
3. Ve a **SQL Editor** (menú lateral izquierdo)

#### 1.2 Ejecutar SQL para hacerte admin

Copia y pega este SQL en el editor:

```sql
-- Crear admin para info@queplan-app.com
INSERT INTO public.admins (user_id)
SELECT id 
FROM auth.users 
WHERE email = 'info@queplan-app.com'
ON CONFLICT (user_id) DO NOTHING;
```

Haz clic en **RUN** (o presiona Ctrl+Enter).

**Resultado esperado**: Deberías ver un mensaje como "Success. No rows returned" o "Success. Rows returned: 1"

#### 1.3 Verificar que eres admin

Ejecuta este SQL para confirmar:

```sql
-- Verificar que eres admin
SELECT 
  u.id as user_id,
  u.email,
  u.created_at as usuario_desde,
  a.id as admin_id,
  a.created_at as admin_desde
FROM public.admins a
JOIN auth.users u ON a.user_id = u.id
WHERE u.email = 'info@queplan-app.com';
```

**Resultado esperado**: Deberías ver una fila con tu información de usuario y admin.

### Paso 2: Verificar en la App

#### 2.1 Cerrar y reabrir la app

1. Cierra completamente la app en Android
2. Vuelve a abrirla

#### 2.2 Acceder al perfil

1. En la pantalla principal, busca el **icono de perfil** (👤) en la esquina superior derecha
2. Tócalo para abrir tu perfil

#### 2.3 Verificar acceso al panel de administración

En la pantalla de perfil, deberías ver:

- Tu email: `info@queplan-app.com`
- Una sección **"Cuenta"** con:
  - **"Panel de administración"** (con icono de admin 🛡️)
  - **"Mis favoritos"**

Si ves la opción "Panel de administración", ¡felicidades! Ya eres admin.

### Paso 3: Acceder al Panel de Administración

1. En la pantalla de perfil, toca **"Panel de administración"**
2. Esto te llevará a la pantalla de **"Eventos Pendientes"**
3. Aquí podrás:
   - Ver eventos que están en estado `pending`
   - Aprobar eventos (cambiar estado a `published`)
   - Rechazar eventos
   - Ver detalles de eventos

## 🔍 Si no funciona

### No aparece "Panel de administración"

1. **Verifica que ejecutaste el SQL correctamente**:
   ```sql
   SELECT 
     u.email,
     a.id as admin_id
   FROM public.admins a
   JOIN auth.users u ON a.user_id = u.id
   WHERE u.email = 'info@queplan-app.com';
   ```
   
   Si no aparece ninguna fila, ejecuta de nuevo el INSERT.

2. **Cierra y reabre la app completamente**:
   - No solo minimizar, sino cerrar completamente la app
   - Luego vuelve a abrirla

3. **Verifica que estás logueado con el email correcto**:
   - En la app, ve a perfil
   - Verifica que el email sea `info@queplan-app.com`

### Error al ejecutar el SQL

Si te sale un error como "relation 'public.admins' does not exist":

1. Primero ejecuta la migración: `docs/migrations/001_create_auth_tables.sql`
2. Luego ejecuta el SQL para hacerte admin

## ✅ Checklist Final

- [ ] Ejecuté el SQL para hacerme admin
- [ ] Verifiqué que el SQL se ejecutó correctamente
- [ ] Cerré y reabrí la app completamente
- [ ] Veo el icono de perfil en la pantalla principal
- [ ] Veo "Panel de administración" en mi perfil
- [ ] Puedo acceder al panel de administración

## 🎉 ¡Listo!

Una vez que puedas acceder al panel de administración, ya estarás listo para:
- Revisar eventos pendientes
- Aprobar o rechazar eventos
- Gestionar el contenido de la app

