# 📧 Configurar Confirmación de Email

Esta guía explica cómo configurar correctamente la confirmación de email para que funcione tanto en móvil como en web.

## ✅ Cambios Realizados

1. **Código actualizado** (`lib/services/auth_service.dart`):
   - En móvil: usa deep link `io.supabase.fiestapp://auth/confirmed`
   - En web: usa URL `https://queplan-app.com/auth/confirmed`

2. **Página HTML creada** (`/auth/confirmed.html`):
   - Página de confirmación desplegada en Firebase Hosting
   - Intenta abrir la app automáticamente si está instalada

3. **Firebase Hosting configurado**:
   - Rewrite `/auth/confirmed` → `/auth/confirmed.html`

## 🔧 Configurar en Supabase Dashboard

Para que funcione correctamente, necesitas añadir estas URLs en Supabase:

### Paso 1: Ir a Configuración de Autenticación

1. Ve a [Supabase Dashboard](https://app.supabase.com)
2. Selecciona tu proyecto
3. Ve a **Authentication** → **URL Configuration**

### Paso 2: Añadir Redirect URLs

En la sección **Redirect URLs**, añade estas URLs (una por línea):

```
io.supabase.fiestapp://auth/confirmed
https://queplan-app.com/auth/confirmed
```

**Nota**: También deberías tener estas URLs para otras funcionalidades:

```
io.supabase.fiestapp://login-callback
io.supabase.fiestapp://reset-password
io.supabase.fiestapp://
```

### Paso 3: Verificar Site URL

Asegúrate de que la **Site URL** esté configurada correctamente:
- Para desarrollo: `http://localhost` o tu URL local
- Para producción: `https://queplan-app.com` o tu dominio

## 🧪 Probar la Confirmación

1. **Registra un nuevo usuario** con email y contraseña
2. **Revisa tu email** - deberías recibir un email de confirmación
3. **Haz clic en el enlace** del email:
   - **En móvil**: Debería abrir la app automáticamente
   - **En web**: Debería mostrar la página de confirmación y luego intentar abrir la app

## 🔍 Verificar que Funciona

### En Móvil (Android/iOS):
- El enlace del email debería abrir la app directamente
- La app debería detectar la confirmación automáticamente
- El usuario debería quedar autenticado

### En Web:
- El enlace debería mostrar la página de confirmación
- La página intentará abrir la app si está instalada
- Si no está instalada, el usuario puede cerrar la página manualmente

## 🐛 Solución de Problemas

### El enlace muestra error "requested path is invalid"
- ✅ **Solucionado**: Ahora usa deep link en móvil y página HTML en web
- Verifica que las URLs estén en Supabase Dashboard

### El enlace no abre la app en móvil
- Verifica que el deep link esté en Supabase Dashboard
- Verifica que `AndroidManifest.xml` tenga el intent-filter configurado
- Prueba abrir manualmente: `adb shell am start -W -a android.intent.action.VIEW -d "io.supabase.fiestapp://auth/confirmed"`

### La página web muestra error 404
- Verifica que la página esté desplegada: `https://queplan-app.com/auth/confirmed`
- Verifica que `firebase.json` tenga el rewrite configurado
- Redespliega: `cd queplan-legal-hosting && firebase deploy --only hosting`

### El usuario no queda autenticado después de confirmar
- Verifica que el deep link esté correctamente configurado
- Revisa los logs de la app para ver si hay errores
- Asegúrate de que el listener de `onAuthStateChange` esté funcionando

## 📝 URLs que Deben Estar en Supabase

Resumen de todas las URLs que deben estar configuradas:

```
# Deep links para móvil
io.supabase.fiestapp://
io.supabase.fiestapp://login-callback
io.supabase.fiestapp://auth/confirmed
io.supabase.fiestapp://reset-password

# URLs para web
https://queplan-app.com/auth/confirmed
```

---

**Última actualización**: Diciembre 2024

