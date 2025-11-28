# 🔐 Respuestas a tus Preguntas de Seguridad

## 1. ¿Para qué sirve el Usuario de Prueba en Google?

### ✅ Respuesta corta:
El **usuario de prueba en Google** es para **poder iniciar sesión** con Google mientras tu app está en modo "Testing".

### 📋 Explicación detallada:

1. **¿Es para registrarse?** 
   - ❌ NO, no es para registrarse
   - ✅ Es para **iniciar sesión** (el registro se hace automáticamente la primera vez)

2. **¿Cómo funciona?**
   - Tu app está en modo "Testing" (por defecto en Google)
   - Google solo permite que los emails en "Usuarios de prueba" inicien sesión
   - Si tu email NO está en la lista, Google bloqueará el acceso con error "Access blocked"
   - Cuando añades tu email como test user, puedes iniciar sesión normalmente

3. **¿Qué pasa cuando inicias sesión?**
   - Google autoriza el acceso
   - Tu cuenta se crea automáticamente en Supabase Auth
   - Ya estás autenticado y puedes usar todas las funciones

**Resumen**: El usuario de prueba = permiso para usar Google OAuth mientras la app está en modo Testing.

---

## 2. ¿Dónde configuro el acceso Admin?

### ✅ Respuesta:
El acceso admin **NO se configura en Google**. Se configura en **Supabase** usando SQL.

### 📋 Pasos para convertirte en Admin:

#### Paso 1: Primero, regístrate/inicia sesión en la app
1. Abre tu app Flutter
2. Ve a login y haz clic en "Continuar con Google"
3. Inicia sesión con tu email (el que está como test user)
4. Esto crea tu usuario en `auth.users` de Supabase

#### Paso 2: Ejecutar SQL en Supabase para hacerte admin

1. Ve a **Supabase Dashboard** > **SQL Editor**
2. Ejecuta este SQL (reemplaza con tu email real):

```sql
-- Añadir tu email como administrador
INSERT INTO public.admins (user_id)
SELECT id 
FROM auth.users 
WHERE email = 'tu-email@ejemplo.com';
```

3. Si todo va bien, verás "Success. No rows returned"

#### Paso 3: Verificar que eres admin

Ejecuta este SQL:

```sql
-- Ver todos los administradores
SELECT 
  u.email,
  a.created_at as admin_desde
FROM public.admins a
JOIN auth.users u ON a.user_id = u.id;
```

Deberías ver tu email en la lista.

#### Paso 4: Probar el panel admin

1. En tu app, haz clic en el icono de perfil (si estás logueado)
2. Deberías ver la opción "Panel de administración" si eres admin
3. También puedes usar el método de 3 toques (como antes)

**IMPORTANTE**: 
- ⚠️ Primero debes ejecutar las migraciones SQL (`docs/migrations/001_create_auth_tables.sql`)
- ⚠️ Primero debes iniciar sesión al menos una vez para que tu usuario exista en `auth.users`

---

## 3. ¿Cómo verificar que Supabase está securizado?

### ✅ Checklist de Seguridad Supabase:

#### A. Ejecutar Migraciones SQL (OBLIGATORIO)

1. Ve a **Supabase Dashboard** > **SQL Editor**
2. Ejecuta el script completo: `docs/migrations/001_create_auth_tables.sql`
   - Esto crea la tabla `admins`
   - Esto crea la tabla `user_favorites`
   - Esto habilita RLS (Row Level Security) en todas las tablas
   - Esto crea las políticas de seguridad

#### B. Verificar que RLS está activo

Ejecuta en SQL Editor:

```sql
-- Verificar RLS en tablas importantes
SELECT 
  tablename,
  rowsecurity as rls_enabled
FROM pg_tables
WHERE schemaname = 'public'
  AND tablename IN ('admins', 'user_favorites', 'events')
ORDER BY tablename;
```

**Resultado esperado**: Todas deben mostrar `rls_enabled = true` ✅

#### C. Verificar Políticas RLS

Ejecuta:

```sql
-- Ver todas las políticas de seguridad
SELECT 
  tablename,
  policyname,
  cmd as operacion,
  roles
FROM pg_policies
WHERE schemaname = 'public'
  AND tablename IN ('admins', 'user_favorites', 'events')
ORDER BY tablename, cmd;
```

**Resultado esperado**: Deberías ver políticas para:
- `admins`: SELECT (usuarios pueden verificar si son admin)
- `user_favorites`: SELECT, INSERT, DELETE (usuarios gestionan sus propios favoritos)
- `events`: SELECT (todos pueden ver publicados, solo admins pueden ver pendientes), UPDATE (solo admins)

#### D. Verificar que solo admins pueden aprobar eventos

La función `approveEvent()` y `rejectEvent()` en `AdminModerationService` verifican:
1. ✅ Que el usuario esté autenticado
2. ✅ Que el usuario esté en la tabla `admins`
3. ✅ Las políticas RLS también bloquean operaciones no autorizadas

---

## 4. ¿Cómo verificar que GitHub está securizado?

### ✅ Checklist de Seguridad GitHub:

#### A. Verificar que `.env` está en `.gitignore`

**PROBLEMA ENCONTRADO**: ⚠️ `.env` NO estaba en `.gitignore` (ya lo he añadido)

Verifica ahora:
```bash
git check-ignore .env
```

Debería mostrar `.env` ✅

#### B. Verificar que `.env` no está en Git

Ejecuta:
```bash
git ls-files | grep "\.env$"
```

**Resultado esperado**: No debería mostrar nada ✅

#### C. Verificar que no hay credenciales hardcodeadas

Busca el PIN antiguo en el código:
```bash
git grep "231192"
```

**Resultado esperado**: 
- ❌ Puede aparecer en commits antiguos (historial)
- ✅ NO debería aparecer en el código actual (ahora carga desde `.env`)

#### D. Verificar que `admin_config.dart` no tiene PIN hardcodeado

El archivo debería verse así:
```dart
String get kAdminPin {
  final pin = dotenv.env['ADMIN_PIN'];
  // ...
}
```

✅ Ya está correcto - carga desde `.env`

#### E. Si el PIN estaba en commits anteriores:

**RECOMENDACIÓN**: Cambia el PIN a uno nuevo por seguridad

1. Edita `.env` y cambia:
   ```
   ADMIN_PIN=nuevo_pin_seguro_123
   ```
2. Actualiza también en Supabase si lo usas en algún lado
3. El PIN antiguo queda como "comprometido" pero ya no se usa

---

## 📋 Resumen de Acciones Pendientes

### ⚠️ CRÍTICO - Hazlo ahora:

1. ✅ **`.env` añadido a `.gitignore`** (ya hecho)
2. ⚠️ **Verifica que `.env` no está en Git**: 
   ```bash
   git ls-files .env
   ```
   Si muestra algo, elimínalo:
   ```bash
   git rm --cached .env
   git commit -m "Remove .env from git tracking"
   ```

3. ⚠️ **Ejecuta migraciones SQL en Supabase**
   - Ve a Supabase Dashboard > SQL Editor
   - Ejecuta: `docs/migrations/001_create_auth_tables.sql`

4. ⚠️ **Hazte administrador**
   - Primero inicia sesión en la app
   - Luego ejecuta el SQL para añadirte como admin

### ✅ Ya está bien:

- ✅ PIN movido a `.env`
- ✅ `admin_config.dart` carga desde variables de entorno
- ✅ Sistema de autenticación implementado
- ✅ Validación de permisos en el servidor

---

## 🧪 Comandos de Verificación Rápida

```bash
# Verificar .env está protegido
git check-ignore .env

# Ver si .env está en Git
git ls-files | grep "\.env"

# Buscar PIN en código
git grep "231192" -- lib/

# Ver qué archivos sensibles están rastreados
git ls-files | grep -iE "env|secret|key|password|pin"
```

