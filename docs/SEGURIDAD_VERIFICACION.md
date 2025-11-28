# ✅ Verificación de Seguridad - Checklist Completo

## 📧 1. Usuario de Prueba en Google

### ¿Para qué sirve?

El **email en "Usuarios de prueba"** de Google es para:
- ✅ **Poder iniciar sesión** mientras tu app está en modo "Testing"
- ✅ **NO es para registrarse**, es solo para poder usar el login con Google
- ✅ **Sin este email**, Google bloqueará el acceso con el error "Access blocked"

### ¿Cómo funciona?

1. Te registras/inicias sesión en la app con Google usando ese email
2. Google verifica que el email esté en la lista de test users
3. Si está, permite el acceso
4. Tu cuenta se crea automáticamente en Supabase Auth

**Importante**: Cuando publiques la app, podrás quitar esta restricción.

---

## 🔐 2. Panel de Administración

### ¿Dónde configuro el acceso admin?

El acceso admin **NO se configura en Google**. Se configura en **Supabase** después de registrarte.

### Pasos para ser Administrador:

#### Paso 1: Regístrate/Inicia sesión en la app
1. Abre tu app
2. Haz login con Google (usando tu email de test user)
3. Esto creará tu usuario en `auth.users` de Supabase

#### Paso 2: Ejecutar SQL en Supabase

1. Ve a **Supabase Dashboard** > **SQL Editor**
2. Ejecuta este SQL (reemplaza `tu-email@ejemplo.com` con tu email real):

```sql
-- Añadir tu email como administrador
INSERT INTO public.admins (user_id)
SELECT id 
FROM auth.users 
WHERE email = 'tu-email@ejemplo.com';
```

3. Si todo va bien, verás "Success. No rows returned"

#### Paso 3: Verificar que eres admin

Ejecuta este SQL para verificar:

```sql
-- Ver todos los administradores
SELECT 
  a.id,
  u.email,
  a.created_at
FROM public.admins a
JOIN auth.users u ON a.user_id = u.id;
```

Deberías ver tu email en la lista.

---

## 🔒 3. Verificación de Seguridad en Supabase

### ✅ Checklist Supabase:

#### A. Ejecutar Migraciones SQL
- [ ] ¿Has ejecutado `docs/migrations/001_create_auth_tables.sql`?
  - Esto crea las tablas `admins` y `user_favorites`
  - Esto habilita RLS (Row Level Security)

#### B. Verificar que RLS está activo

Ejecuta en SQL Editor:

```sql
-- Verificar RLS en tablas importantes
SELECT 
  tablename,
  rowsecurity as rls_enabled
FROM pg_tables
WHERE schemaname = 'public'
  AND tablename IN ('admins', 'user_favorites', 'events');
```

Todas deberían mostrar `rlsenabled = true`

#### C. Verificar Políticas RLS

Ejecuta:

```sql
-- Ver políticas de seguridad
SELECT 
  schemaname,
  tablename,
  policyname,
  permissive,
  roles,
  cmd
FROM pg_policies
WHERE schemaname = 'public'
  AND tablename IN ('admins', 'user_favorites', 'events');
```

Deberías ver políticas para SELECT, INSERT, UPDATE, DELETE según corresponda.

#### D. Verificar que solo admins pueden aprobar eventos

La política debería verificar la tabla `admins` antes de permitir actualizar eventos.

---

## 🔐 4. Verificación de Seguridad en GitHub

### ✅ Checklist GitHub:

#### A. Verificar que `.env` está en `.gitignore`

Ejecuta:
```bash
git check-ignore .env
```

Si muestra `.env`, está protegido ✅

#### B. Verificar que no hay credenciales en el código

Busca en Git:

```bash
# Buscar archivos sensibles que puedan estar en Git
git ls-files | grep -E "\.env$|admin_config"

# Verificar si admin_config tiene el PIN hardcodeado
git grep "231192"
```

**Resultado esperado**:
- ❌ `admin_config.dart` puede estar en Git (pero ahora carga desde .env)
- ✅ No debería mostrar `.env`
- ✅ No debería mostrar el PIN `231192` en ningún archivo

#### C. Verificar que `admin_config.dart` ya no tiene el PIN

El archivo debería usar `dotenv.env['ADMIN_PIN']`, no tener el PIN hardcodeado.

#### D. Verificar credenciales en commits anteriores

Si el PIN estaba en commits anteriores, deberías:
1. **Cambiar el PIN** a uno nuevo
2. Considerar hacer el PIN anterior como comprometido
3. Actualizar `.env` con el nuevo PIN

---

## 🔑 5. Archivos Sensibles a Proteger

### Archivos que NO deben estar en Git:

- ✅ `.env` - Variables de entorno (incluye ADMIN_PIN, SUPABASE keys)
- ⚠️ `admin_config.dart` - Ya está en Git, pero ahora carga desde .env

### Verificación completa:

```bash
# Verificar que .env está ignorado
cat .gitignore | grep -E "^\.env$|^\.env"

# Ver qué archivos están siendo rastreados
git ls-files | grep -i "env\|secret\|key\|password\|pin"
```

---

## 📋 Resumen de Acciones Necesarias

### ✅ Ya completado:
1. ✅ PIN movido a `.env`
2. ✅ `admin_config.dart` carga desde variables de entorno
3. ✅ Autenticación implementada
4. ✅ RLS configurado en migraciones SQL

### ⚠️ Pendiente de verificar/ejecutar:
1. ⚠️ Ejecutar migraciones SQL en Supabase
2. ⚠️ Añadirte como admin en Supabase (SQL)
3. ⚠️ Verificar que `.env` no está en Git
4. ⚠️ Cambiar PIN si estaba en commits anteriores

---

## 🚨 Si encuentras problemas de seguridad:

1. **PIN comprometido**: Cambia `ADMIN_PIN` en `.env` a un valor nuevo
2. **Credenciales en Git**: Si `.env` está en Git, elimínalo del historial:
   ```bash
   git rm --cached .env
   git commit -m "Remove .env from tracking"
   ```
3. **RLS no activo**: Ejecuta las migraciones SQL

