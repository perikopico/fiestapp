# Crear Admin para info@queplan-app.com

## 📋 Pasos para Crearte como Administrador

### Paso 1: Asegúrate de estar registrado en la app

**IMPORTANTE**: Primero debes iniciar sesión en la app al menos una vez para que tu usuario exista en Supabase.

1. Abre tu app Flutter
2. Ve a la pantalla de login
3. Haz clic en "Continuar con Google"
4. Inicia sesión con `info@queplan-app.com` (debe estar en usuarios de prueba de Google)
5. Esto creará tu usuario en `auth.users` de Supabase

### Paso 2: Ejecutar SQL para hacerte admin

1. Ve a **Supabase Dashboard** > **SQL Editor**
2. Ejecuta este SQL:

```sql
-- Crear admin para info@queplan-app.com
INSERT INTO public.admins (user_id)
SELECT id 
FROM auth.users 
WHERE email = 'info@queplan-app.com'
ON CONFLICT (user_id) DO NOTHING;
```

**Nota**: El `ON CONFLICT DO NOTHING` evita errores si ya eres admin.

### Paso 3: Verificar que se creó correctamente

Ejecuta este SQL para verificar:

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

**Resultado esperado**: Deberías ver una fila con:
- Tu `user_id`
- `email`: info@queplan-app.com
- `usuario_desde`: Fecha cuando te registraste
- `admin_id`: ID del registro de admin
- `admin_desde`: Fecha cuando te hiciste admin

### Paso 4: Ver todos los administradores

Si quieres ver todos los admins:

```sql
-- Ver todos los administradores
SELECT 
  u.email,
  u.created_at as usuario_desde,
  a.created_at as admin_desde
FROM public.admins a
JOIN auth.users u ON a.user_id = u.id
ORDER BY a.created_at DESC;
```

---

## 🔍 Si hay problemas

### Error: "no rows to insert"

**Causa**: Tu usuario no existe en `auth.users` todavía.

**Solución**: 
1. Asegúrate de haber iniciado sesión en la app al menos una vez
2. Verifica que tu usuario existe:

```sql
-- Verificar si tu usuario existe
SELECT id, email, created_at 
FROM auth.users 
WHERE email = 'info@queplan-app.com';
```

Si no aparece, inicia sesión en la app primero.

### Error: "relation 'public.admins' does not exist"

**Causa**: Las migraciones SQL no se han ejecutado.

**Solución**: Ejecuta primero `docs/migrations/001_create_auth_tables.sql`

---

## ✅ Verificación Completa

### 1. Verificar que eres admin (SQL):

```sql
-- Verificación completa
SELECT 
  'Usuario existe' as check_1,
  (SELECT COUNT(*) FROM auth.users WHERE email = 'info@queplan-app.com') > 0 as resultado_1
UNION ALL
SELECT 
  'Eres admin' as check_2,
  EXISTS (
    SELECT 1 FROM public.admins a
    JOIN auth.users u ON a.user_id = u.id
    WHERE u.email = 'info@queplan-app.com'
  ) as resultado_2;
```

### 2. Verificar en la app:

1. Inicia sesión en la app con `info@queplan-app.com`
2. Haz clic en el icono de perfil
3. Deberías ver la opción **"Panel de administración"** si eres admin
4. O usa el método de 3 toques para acceder al panel admin

---

## 📝 SQL Completo (Todo en Uno)

Si quieres ejecutar todo de una vez:

```sql
-- 1. Verificar que el usuario existe
SELECT id, email, created_at 
FROM auth.users 
WHERE email = 'info@queplan-app.com';

-- 2. Crear admin (ejecutar solo si el usuario existe)
INSERT INTO public.admins (user_id)
SELECT id 
FROM auth.users 
WHERE email = 'info@queplan-app.com'
ON CONFLICT (user_id) DO NOTHING;

-- 3. Verificar que eres admin
SELECT 
  u.email,
  a.created_at as admin_desde
FROM public.admins a
JOIN auth.users u ON a.user_id = u.id
WHERE u.email = 'info@queplan-app.com';
```

