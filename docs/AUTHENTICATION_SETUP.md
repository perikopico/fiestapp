# Guía de Configuración de Autenticación

## ✅ Implementación Completada

Se ha implementado un sistema completo de autenticación con las siguientes características:

### 1. **Sistema de Autenticación**
- ✅ Login con email y contraseña
- ✅ Registro de nuevos usuarios
- ✅ Login con Google OAuth
- ✅ Recuperación de contraseña
- ✅ Gestión de sesión

### 2. **Seguridad Mejorada**
- ✅ PIN de administrador movido a variables de entorno
- ✅ Autenticación del lado del servidor con Supabase Auth
- ✅ Validación de permisos de administrador en cada operación
- ✅ Scripts SQL para Row Level Security (RLS)

### 3. **Funcionalidades de Usuario**
- ✅ Pantalla de perfil personal
- ✅ Favoritos sincronizados con Supabase
- ✅ Panel personal para usuarios autenticados
- ✅ Acceso opcional: ver eventos sin login, funciones completas con login

## 📋 Pasos para Completar la Configuración

### Paso 1: Configurar Variables de Entorno

1. Edita tu archivo `.env` y añade:
```env
ADMIN_PIN=231192
SUPABASE_URL=tu_url_de_supabase
SUPABASE_ANON_KEY=tu_clave_anonima
```

2. **IMPORTANTE**: Asegúrate de que `.env` está en `.gitignore` (ya debería estarlo).

### Paso 2: Configurar Google OAuth en Supabase

1. Ve a tu proyecto en Supabase Dashboard
2. Navega a **Authentication > Providers**
3. Habilita **Google**
4. Configura las credenciales OAuth:
   - Ve a [Google Cloud Console](https://console.cloud.google.com/)
   - Selecciona tu proyecto existente (o crea uno nuevo)
   - Ve a **APIs & Services > Credentials**
   - Haz clic en **Create Credentials > OAuth client ID**
   - Si es la primera vez, configura la pantalla de consentimiento OAuth
   - Selecciona **Application type: Web application**
   - Nombre: "QuePlan - Supabase"
   - **Authorized redirect URIs**: Añade estas URLs (reemplaza `TU-PROYECTO` con tu ID de proyecto Supabase):
     ```
     https://TU-PROYECTO.supabase.co/auth/v1/callback
     ```
     Para encontrar tu ID de proyecto: Ve a Supabase Dashboard > Settings > API > Project URL
   - **Restricción de aplicación**: Selecciona "Sitios web"
   - **Restricciones de API**: Deja en "No restrictivo" (o selecciona solo "People API" si quieres ser más específico)
   - Copia el **Client ID** y **Client Secret** a Supabase Dashboard > Authentication > Providers > Google

### Paso 3: Ejecutar Migraciones SQL

1. Ve a Supabase Dashboard > SQL Editor
2. Ejecuta el script `docs/migrations/001_create_auth_tables.sql`
   - Esto creará:
     - Tabla `admins` para gestionar administradores
     - Tabla `user_favorites` para favoritos sincronizados
     - Políticas RLS (Row Level Security) para seguridad

### Paso 4: Crear el Primer Administrador

Ejecuta en el SQL Editor de Supabase:

```sql
-- Reemplaza 'tu-email@ejemplo.com' con tu email real
INSERT INTO public.admins (user_id)
SELECT id 
FROM auth.users 
WHERE email = 'tu-email@ejemplo.com';
```

**Nota**: Asegúrate de haberte registrado en la app primero para que tu usuario exista en `auth.users`.

### Paso 5: Configurar Deep Links (Solo para Mobile)

Para que el OAuth funcione correctamente en móvil:

#### Android (`android/app/src/main/AndroidManifest.xml`):
✅ **Ya configurado** - El deep link ya está añadido en el manifest.

#### iOS (`ios/Runner/Info.plist`):
Añade:
```xml
<key>CFBundleURLTypes</key>
<array>
    <dict>
        <key>CFBundleURLSchemes</key>
        <array>
            <string>io.supabase.fiestapp</string>
        </array>
    </dict>
</array>
```

## 🔐 Seguridad Implementada

### Autenticación del Cliente
- ✅ Validación de PIN en el cliente (requiere variable de entorno)
- ✅ Validación de autenticación antes de mostrar panel admin

### Autenticación del Servidor
- ✅ **RLS habilitado**: Solo usuarios autenticados pueden ver sus datos
- ✅ **Política de administradores**: Solo usuarios en tabla `admins` pueden aprobar/rechazar eventos
- ✅ **Validación doble**: Cliente verifica permisos + Servidor valida con RLS

### Favoritos
- ✅ Sincronización automática entre local y Supabase
- ✅ Cada usuario solo ve sus propios favoritos
- ✅ Los favoritos locales se migran automáticamente al iniciar sesión

## 📱 Funcionalidades por Tipo de Usuario

### Usuario No Autenticado
- ✅ Ver todos los eventos publicados
- ✅ Explorar categorías y ciudades
- ✅ Guardar favoritos localmente (se perderán si desinstala la app)

### Usuario Autenticado
- ✅ Todo lo anterior +
- ✅ Favoritos sincronizados en la nube
- ✅ Panel personal en "Mi perfil"
- ✅ Ver historial de favoritos
- ✅ Crear eventos (pendientes de revisión)

### Administrador
- ✅ Todo lo anterior +
- ✅ Acceso al panel de administración
- ✅ Aprobar/rechazar eventos pendientes
- ✅ Ver eventos rechazados
- ✅ Modificar eventos publicados

## 🚨 Problemas Comunes y Soluciones

### Error: "ADMIN_PIN no está configurado en .env"
**Solución**: Añade `ADMIN_PIN=tu_pin` a tu archivo `.env`

### Error: "No tienes permisos para aprobar eventos"
**Solución**: Tu usuario debe estar en la tabla `admins`. Ejecuta el SQL del Paso 4.

### Google OAuth no funciona en móvil
**Solución**: Verifica que los deep links estén configurados (Paso 5) y que las URLs de redirección en Google Console coincidan.

### Favoritos no se sincronizan
**Solución**: Verifica que el usuario esté autenticado y que la tabla `user_favorites` exista (ejecuta migraciones SQL).

## 📚 Archivos Importantes

- `lib/services/auth_service.dart` - Servicio de autenticación
- `lib/services/admin_moderation_service.dart` - Gestión de moderación (ahora con validación)
- `lib/ui/auth/` - Pantallas de login, registro y perfil
- `docs/migrations/001_create_auth_tables.sql` - Migraciones de base de datos
- `docs/migrations/002_add_admin_helper.sql` - Scripts útiles para gestión

## 🔄 Próximos Pasos (Opcionales)

1. **Mejorar UI del perfil**: Añadir avatar, nombre de usuario personalizable
2. **Notificaciones**: Enviar notificaciones cuando se apruebe un evento del usuario
3. **Historial**: Ver eventos que el usuario ha creado
4. **Roles adicionales**: Moderadores, editores, etc.

