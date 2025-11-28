# Guía de Verificación de Supabase

Esta guía te ayudará a verificar que todo esté correctamente configurado en Supabase para que el registro y la autenticación funcionen correctamente.

## 📋 Checklist de Verificación

### 1. ✅ Variables de Entorno

**Ubicación**: Archivo `.env` en la raíz del proyecto

Verifica que tienes estas variables configuradas:
```env
SUPABASE_URL=https://tu-proyecto.supabase.co
SUPABASE_ANON_KEY=tu_clave_anonima_aqui
```

**Cómo verificar:**
1. Abre el archivo `.env` en la raíz del proyecto
2. Confirma que `SUPABASE_URL` y `SUPABASE_ANON_KEY` no están vacías
3. La URL debe ser similar a: `https://xxxxxxxxxxxxx.supabase.co`
4. La clave anónima es una cadena larga que comienza con `eyJ...`

**Dónde encontrar estos valores en Supabase:**
- Ve a tu proyecto en [Supabase Dashboard](https://app.supabase.com)
- Navega a **Settings > API**
- Copia:
  - **Project URL** → `SUPABASE_URL`
  - **Project API keys > anon/public** → `SUPABASE_ANON_KEY`

---

### 2. ✅ Configuración de Autenticación

**Ubicación**: Supabase Dashboard > Authentication > Settings

#### 2.1. Habilitar Registro por Email

1. Ve a **Authentication > Providers**
2. Asegúrate de que **Email** esté **habilitado**
3. Verifica las siguientes configuraciones:

**Site URL:**
- Debe ser la URL de tu aplicación (para producción) o `http://localhost` (para desarrollo)
- Ejemplo: `io.supabase.fiestapp://`

**Redirect URLs:**
- Añade todas las URLs de redirección necesarias:
  ```
  io.supabase.fiestapp://login-callback
  io.supabase.fiestapp://reset-password
  http://localhost:3000/auth/callback
  ```

#### 2.2. Configuración de Email de Confirmación

1. Ve a **Authentication > Settings > Email Auth**
2. Verifica:
   - ✅ **Enable email confirmations**: Debe estar activado para producción
   - ✅ **Enable email signup**: Debe estar activado

**Para desarrollo/testing:**
- Puedes desactivar temporalmente la confirmación de email
- Ve a **Authentication > Settings > Email Auth**
- Desactiva **Enable email confirmations** (solo para testing)

#### 2.3. Configuración de Email SMTP (Opcional pero recomendado)

Para que los emails de confirmación se envíen correctamente:

1. Ve a **Settings > Auth > SMTP Settings**
2. Configura un proveedor SMTP o usa el predeterminado de Supabase
3. Verifica que los emails de prueba lleguen correctamente

**Nota**: Supabase tiene un límite diario de emails. Para producción, configura tu propio SMTP.

---

### 3. ✅ Tablas de Base de Datos

**Ubicación**: Supabase Dashboard > Table Editor

Verifica que existan las siguientes tablas:

#### Tablas Requeridas:

1. **`auth.users`** (se crea automáticamente)
   - Esta tabla es gestionada por Supabase Auth
   - No necesitas crearla manualmente

2. **`public.admins`**
   - Columnas: `id`, `user_id`, `created_at`, `created_by`
   - Verifica que existe con: `Table Editor > admins`

3. **`public.user_favorites`**
   - Columnas: `id`, `user_id`, `event_id`, `created_at`
   - Verifica que existe con: `Table Editor > user_favorites`

4. **`public.events`**
   - Verifica que existe y tiene la columna `status` (valores: 'pending', 'published', 'rejected')

**Cómo verificar:**
1. Ve a **Table Editor** en Supabase Dashboard
2. Deberías ver todas estas tablas listadas
3. Si alguna falta, ejecuta el script de migración (ver sección 4)

---

### 4. ✅ Migraciones SQL Ejecutadas

**Ubicación**: Supabase Dashboard > SQL Editor

Verifica que hayas ejecutado el script de migración:

1. Ve a **SQL Editor** en Supabase Dashboard
2. Revisa el historial de queries ejecutadas
3. Busca referencias a:
   - `CREATE TABLE public.admins`
   - `CREATE TABLE public.user_favorites`
   - Políticas RLS (Row Level Security)

**Si no has ejecutado las migraciones:**

1. Ve a **SQL Editor**
2. Abre el archivo: `docs/migrations/001_create_auth_tables.sql`
3. Copia todo el contenido
4. Pégalo en el SQL Editor de Supabase
5. Haz clic en **RUN** o presiona `Ctrl+Enter`
6. Verifica que no haya errores

**Verificar que las políticas RLS estén activas:**

Ejecuta esta query en el SQL Editor:
```sql
-- Verificar que RLS está habilitado
SELECT tablename, rowsecurity 
FROM pg_tables 
WHERE schemaname = 'public' 
AND tablename IN ('admins', 'user_favorites', 'events');
```

Deberías ver `rowsecurity = true` para todas las tablas.

---

### 5. ✅ Políticas de Seguridad (RLS)

**Ubicación**: Supabase Dashboard > Authentication > Policies

Verifica que existan las siguientes políticas:

#### Para `user_favorites`:
- ✅ "Users can read own favorites"
- ✅ "Users can insert own favorites"
- ✅ "Users can delete own favorites"

#### Para `admins`:
- ✅ "Users can read if they are admin"

#### Para `events`:
- ✅ "Anyone can read published events"
- ✅ "Admins can read all events"
- ✅ "Anyone can insert events"
- ✅ "Admins can update event status"
- ✅ "Admins can delete events"

**Cómo verificar:**
1. Ve a **Table Editor**
2. Selecciona una tabla (ej: `user_favorites`)
3. Haz clic en la pestaña **Policies** o **RLS**
4. Deberías ver las políticas listadas

---

### 6. ✅ Usuario Administrador

**Ubicación**: Supabase Dashboard > Table Editor > admins

Verifica que tu usuario esté registrado como administrador:

1. Primero, regístrate en la app o verifica que tu usuario existe:
   - Ve a **Authentication > Users**
   - Busca tu email
   - Si no existe, regístrate en la app primero

2. Luego, ejecuta esta query en el **SQL Editor**:

```sql
-- Verificar si eres admin
SELECT a.*, u.email
FROM public.admins a
JOIN auth.users u ON u.id = a.user_id
WHERE u.email = 'tu-email@ejemplo.com';
```

**Si no apareces como admin, créalo:**

```sql
-- Añadir tu usuario como administrador
INSERT INTO public.admins (user_id)
SELECT id 
FROM auth.users 
WHERE email = 'tu-email@ejemplo.com'
ON CONFLICT (user_id) DO NOTHING;
```

---

### 7. ✅ Configuración de Google OAuth (Opcional)

**Ubicación**: Supabase Dashboard > Authentication > Providers > Google

Si quieres habilitar el login con Google:

1. Ve a **Authentication > Providers**
2. Habilita **Google**
3. Añade:
   - **Client ID** (desde Google Cloud Console)
   - **Client Secret** (desde Google Cloud Console)

4. Verifica que en Google Cloud Console tengas configurada la URL de redirección:
   ```
   https://TU-PROYECTO.supabase.co/auth/v1/callback
   ```

**Nota**: Si no quieres usar Google OAuth ahora, puedes omitir este paso. El registro por email funcionará igual.

---

### 8. ✅ Probar el Registro

**Prueba completa de registro:**

1. Abre la app en tu dispositivo/emulador
2. Ve a la pantalla de login (icono de login en la barra superior)
3. Haz clic en **"Regístrate"**
4. Llena el formulario:
   - Email: usa un email real para recibir confirmación
   - Contraseña: mínimo 6 caracteres
5. Haz clic en **"Crear cuenta"**

**Resultado esperado:**
- ✅ Deberías ver un mensaje: "Registro exitoso"
- ✅ Deberías recibir un email de confirmación (si está habilitado)
- ✅ El email debe contener un enlace de confirmación

**Verificar en Supabase:**
1. Ve a **Authentication > Users**
2. Deberías ver el nuevo usuario con estado:
   - **Confirmed**: `false` (hasta que confirme el email)
   - O `true` si desactivaste la confirmación

**Confirmar el email:**
1. Abre el email de confirmación
2. Haz clic en el enlace
3. Deberías ser redirigido y el usuario quedar confirmado

**Iniciar sesión:**
1. Después de confirmar el email
2. Ve a la pantalla de login
3. Ingresa tu email y contraseña
4. Deberías poder iniciar sesión exitosamente

---

### 9. ✅ Verificar Logs y Errores

**En la aplicación:**
- Revisa la consola de Flutter/Dart
- Busca mensajes que empiecen con:
  - `✅` = Todo bien
  - `⚠️` = Advertencias (pueden ignorarse a veces)
  - `❌` = Errores que necesitan atención

**En Supabase:**
1. Ve a **Logs** en el Dashboard
2. Revisa:
   - **Auth Logs**: Para ver intentos de login/registro
   - **Postgres Logs**: Para ver errores de base de datos
   - **API Logs**: Para ver requests a la API

---

## 🚨 Problemas Comunes y Soluciones

### Problema: "Error al registrarse: Supabase no está inicializado"

**Solución:**
1. Verifica que el archivo `.env` existe y tiene las variables correctas
2. Reinicia la app después de modificar `.env`
3. Verifica en los logs: `✅ Supabase inicializado con éxito`

---

### Problema: "Email no confirmado" al intentar login

**Solución:**
1. Revisa tu bandeja de entrada (y spam)
2. Haz clic en el enlace de confirmación
3. O temporalmente desactiva la confirmación en Supabase:
   - **Authentication > Settings > Email Auth**
   - Desactiva **Enable email confirmations**

---

### Problema: "No tienes permisos" al intentar acciones de admin

**Solución:**
1. Verifica que tu usuario esté en la tabla `admins` (ver sección 6)
2. Ejecuta el SQL para añadirte como admin
3. Cierra sesión y vuelve a iniciar sesión

---

### Problema: Los favoritos no se sincronizan

**Solución:**
1. Verifica que la tabla `user_favorites` existe (sección 3)
2. Verifica que las políticas RLS están activas (sección 5)
3. Verifica que estás autenticado correctamente
4. Revisa los logs en Supabase para errores

---

### Problema: Error "relation does not exist"

**Solución:**
- La tabla no existe en la base de datos
- Ejecuta las migraciones SQL (sección 4)

---

## ✅ Checklist Rápida

Copia y pega esto en un archivo para ir marcando:

```
[ ] Variables de entorno configuradas (.env)
[ ] Email Auth habilitado en Supabase
[ ] Redirect URLs configuradas
[ ] Tabla 'admins' existe
[ ] Tabla 'user_favorites' existe
[ ] Tabla 'events' existe con columna 'status'
[ ] Migraciones SQL ejecutadas
[ ] Políticas RLS habilitadas y configuradas
[ ] Mi usuario está en la tabla 'admins'
[ ] Probar registro desde la app funciona
[ ] Email de confirmación llega correctamente
[ ] Puedo iniciar sesión después de confirmar email
[ ] Los favoritos se sincronizan correctamente
```

---

## 🔍 Comandos SQL Útiles para Verificar

Copia y ejecuta estos en el **SQL Editor** de Supabase:

### Ver todas las tablas:
```sql
SELECT table_name 
FROM information_schema.tables 
WHERE table_schema = 'public';
```

### Ver políticas RLS:
```sql
SELECT schemaname, tablename, policyname, permissive, roles, cmd, qual
FROM pg_policies
WHERE schemaname = 'public';
```

### Ver usuarios registrados:
```sql
SELECT id, email, email_confirmed_at, created_at
FROM auth.users
ORDER BY created_at DESC
LIMIT 10;
```

### Ver administradores:
```sql
SELECT a.id, u.email, a.created_at
FROM public.admins a
JOIN auth.users u ON u.id = a.user_id;
```

### Verificar estado de RLS:
```sql
SELECT tablename, rowsecurity 
FROM pg_tables 
WHERE schemaname = 'public';
```

---

## 📞 Obtener Ayuda

Si después de seguir esta guía sigues teniendo problemas:

1. Revisa los logs en Supabase Dashboard > Logs
2. Revisa los logs de la aplicación Flutter
3. Verifica la documentación oficial de Supabase: https://supabase.com/docs

---

**Última actualización**: Esta guía corresponde a la configuración actual de la app.
