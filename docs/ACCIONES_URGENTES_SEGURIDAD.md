# 🚨 ACCIONES URGENTES DE SEGURIDAD

## ⚠️ PROBLEMA ENCONTRADO

He detectado que `.env` estaba siendo rastreado por Git. **He hecho lo siguiente:**

1. ✅ Añadido `.env` a `.gitignore`
2. ✅ Eliminado `.env` del tracking de Git (pero el archivo sigue en tu máquina)
3. ⚠️ **DEBES hacer commit** de estos cambios

## 📋 ACCIONES QUE DEBES HACER AHORA

### 1. Hacer commit de la eliminación de .env

```bash
git commit -m "Remove .env from git tracking - security fix"
```

### 2. Si ya pusheaste .env a GitHub (importante):

**⚠️ CRÍTICO**: Si ya hiciste `git push` antes, el `.env` está en GitHub y visible.

**Opciones:**
- **Opción A**: Cambiar todas las credenciales (recomendado):
  - Cambia `ADMIN_PIN` a uno nuevo
  - Regenera las claves de Supabase si es necesario
  
- **Opción B**: Si es un repositorio privado y solo tú tienes acceso, el riesgo es menor, pero aún así deberías cambiar el PIN.

### 3. Verificar que .env ya no está en Git

```bash
git ls-files | grep "\.env"
```

**Resultado esperado**: No debería mostrar nada ✅

---

## 📧 RESPUESTA A TUS PREGUNTAS

### 1. ¿Usuario de prueba en Google - para qué sirve?

**Respuesta**: 
- ✅ Es para **poder iniciar sesión** con Google
- ❌ NO es para registrarse (el registro es automático)
- Mientras tu app está en modo "Testing", solo los emails en "Usuarios de prueba" pueden iniciar sesión
- Si no está tu email, Google bloqueará el acceso

**Resumen**: Es un permiso temporal para usar Google OAuth durante el desarrollo.

---

### 2. ¿Dónde configuro el acceso Admin?

**Respuesta**: Se configura en **Supabase**, NO en Google.

**Pasos:**

1. **Primero**: Regístrate/inicia sesión en la app con Google
   - Esto crea tu usuario en `auth.users` de Supabase

2. **Segundo**: Ejecuta este SQL en Supabase Dashboard > SQL Editor:

```sql
-- Reemplaza 'tu-email@ejemplo.com' con tu email real
INSERT INTO public.admins (user_id)
SELECT id 
FROM auth.users 
WHERE email = 'tu-email@ejemplo.com';
```

3. **Tercero**: Verifica que eres admin:

```sql
SELECT 
  u.email,
  a.created_at as admin_desde
FROM public.admins a
JOIN auth.users u ON a.user_id = u.id;
```

**IMPORTANTE**: 
- ⚠️ Primero debes ejecutar las migraciones SQL (`docs/migrations/001_create_auth_tables.sql`)
- ⚠️ Primero debes iniciar sesión al menos una vez

---

### 3. ¿Cómo verificar seguridad en Supabase?

**Checklist:**

1. ✅ **Ejecutar migraciones SQL**:
   - Ve a Supabase Dashboard > SQL Editor
   - Ejecuta: `docs/migrations/001_create_auth_tables.sql`
   - Esto crea tablas y políticas RLS

2. ✅ **Verificar RLS está activo**:
   ```sql
   SELECT tablename, rowsecurity 
   FROM pg_tables 
   WHERE schemaname = 'public' 
     AND tablename IN ('admins', 'user_favorites', 'events');
   ```
   Todas deben mostrar `rowsecurity = true`

3. ✅ **Verificar políticas RLS**:
   ```sql
   SELECT tablename, policyname, cmd 
   FROM pg_policies 
   WHERE schemaname = 'public';
   ```

---

### 4. ¿Cómo verificar seguridad en GitHub?

**Checklist:**

1. ✅ **`.env` en `.gitignore`**: Ya está hecho
2. ✅ **`.env` eliminado de Git**: Ya está hecho (haz commit)
3. ⚠️ **Si ya pusheaste antes**: Considera cambiar credenciales

**Verificaciones:**

```bash
# Verificar .env está protegido
git check-ignore .env

# Ver si .env está en Git (no debería mostrar nada)
git ls-files | grep "\.env"

# Buscar PIN en código (no debería aparecer en archivos actuales)
git grep "231192" -- lib/
```

---

## ✅ RESUMEN

### Ya hecho:
- ✅ `.env` añadido a `.gitignore`
- ✅ `.env` eliminado del tracking de Git
- ✅ PIN movido a variables de entorno

### Pendiente:
1. ⚠️ **Hacer commit** de la eliminación de `.env`
2. ⚠️ **Ejecutar migraciones SQL** en Supabase
3. ⚠️ **Iniciar sesión** en la app
4. ⚠️ **Añadirte como admin** (SQL en Supabase)
5. ⚠️ **Considerar cambiar PIN** si ya estaba en Git/GitHub

