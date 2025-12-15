# Configurar URLs de Redirección en Supabase

## 🔴 Problema

Cuando te registras, recibes un email de confirmación pero al hacer clic en el enlace, te lleva a `localhost:3000` que no funciona en móvil.

## ✅ Solución

Necesitas configurar las URLs de redirección correctas en Supabase Dashboard.

### Paso 1: Configurar Site URL y Redirect URLs

1. Ve a tu proyecto en **Supabase Dashboard**: https://supabase.com/dashboard
2. Navega a **Authentication > URL Configuration**
3. Configura lo siguiente:

#### **Site URL**
Para desarrollo, puedes usar cualquier URL válida (no importa mucho para móvil):
```
http://localhost:3000
```

#### **Redirect URLs** (MUY IMPORTANTE)
Añade estas URLs en la lista separadas por comas:

```
io.supabase.fiestapp://login-callback
https://tu-proyecto.supabase.co/auth/v1/callback
http://localhost:3000/auth/callback
```

**Reemplaza `tu-proyecto` con tu ID de proyecto de Supabase** (lo encuentras en Settings > API > Project URL)

### Paso 2: Verificar en el Código

El código ya está actualizado para usar el deep link correcto:
- ✅ `lib/services/auth_service.dart` ya especifica `io.supabase.fiestapp://login-callback` en el registro
- ✅ AndroidManifest.xml ya tiene configurado el deep link

### Paso 3: Probar de Nuevo

1. **Registra un nuevo usuario** con un email diferente
2. **Revisa el email** de confirmación
3. **Haz clic en el enlace** de confirmación
4. **Debería abrir la app** automáticamente y confirmar tu cuenta

## 📱 Cómo Funciona

1. Usuario se registra → Supabase envía email
2. Email contiene enlace con `code` y `token`
3. Enlace apunta a: `https://tu-proyecto.supabase.co/auth/v1/verify?token=...&redirect_to=io.supabase.fiestapp://login-callback`
4. Supabase verifica el token y redirige al deep link
5. El sistema operativo detecta `io.supabase.fiestapp://` y abre la app
6. Supabase Flutter SDK detecta el deep link y completa la confirmación automáticamente

## 🔍 Verificar que Funciona

Después de hacer clic en el enlace de confirmación:

1. La app debería abrirse automáticamente
2. Deberías ver en los logs:
   ```
   ✅ Usuario autenticado: [tu-email]
   ✅ Token FCM guardado después de login
   ```
3. Puedes iniciar sesión normalmente

## ⚠️ Si Sigue Sin Funcionar

1. **Verifica las URLs en Supabase Dashboard**:
   - Authentication > URL Configuration
   - Asegúrate de que `io.supabase.fiestapp://login-callback` esté en la lista

2. **Verifica el AndroidManifest.xml**:
   - Asegúrate de que el intent-filter con `io.supabase.fiestapp` esté presente

3. **Desinstala y reinstala la app**:
   - A veces el sistema necesita registrar los deep links de nuevo

4. **Prueba con un email nuevo**:
   - Los emails antiguos pueden tener el enlace incorrecto

## 🚀 Alternativa: Desactivar Confirmación de Email (Solo para Testing)

Si solo quieres probar rápidamente sin confirmar emails:

1. Ve a Supabase Dashboard
2. **Authentication > Providers > Email**
3. Desactiva **"Confirm email"** temporalmente
4. Los usuarios podrán iniciar sesión inmediatamente después de registrarse

**⚠️ IMPORTANTE**: Vuelve a activarlo en producción para seguridad.

