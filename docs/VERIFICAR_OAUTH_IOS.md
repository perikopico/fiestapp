# 🔍 Guía: Verificar Configuración OAuth para iOS

**Fecha**: Enero 2025  
**Problema**: Error "Safari no puede abrir la página porque la dirección no es válida" al iniciar sesión con Google

---

## 📋 Checklist de Verificación

Antes de empezar, necesitas tener:
- ✅ Acceso a [Supabase Dashboard](https://app.supabase.com/)
- ✅ Acceso a [Google Cloud Console](https://console.cloud.google.com/)
- ✅ Tu URL de Supabase (ejemplo: `https://oudofaiekedtaovrdqeo.supabase.co`)

---

## 🔵 Paso 1: Verificar en Supabase Dashboard

### 1.1 Acceder a Supabase Dashboard

1. Ve a: **https://app.supabase.com/**
2. Inicia sesión con tu cuenta
3. Selecciona tu proyecto (el que tiene la URL `oudofaiekedtaovrdqeo.supabase.co`)

### 1.2 Ir a Authentication → URL Configuration

**Ruta exacta:**
1. En el menú lateral izquierdo, busca **"Authentication"** (icono de candado 🔒)
2. Haz clic en **"Authentication"**
3. En el submenú, busca **"URL Configuration"** o **"URLs"**
4. Haz clic en **"URL Configuration"**

**Si no encuentras "URL Configuration":**
- Busca en **"Settings"** → **"Authentication"** → **"URL Configuration"**
- O en **"Project Settings"** → **"Authentication"** → **"URL Configuration"**

### 1.3 Verificar Site URL

**Debe contener:**
```
io.supabase.fiestapp://
```

**O puede estar vacío** (no es crítico para deep links)

### 1.4 Verificar Redirect URLs (⚠️ CRÍTICO)

**En la sección "Redirect URLs" o "Redirect URIs", DEBES tener estas URLs (una por línea):**

```
io.supabase.fiestapp://login-callback
io.supabase.fiestapp://auth/confirmed
io.supabase.fiestapp://reset-password
```

**⚠️ IMPORTANTE:**
- Cada URL debe estar en una línea separada
- NO debe haber espacios al inicio o final
- NO debe haber comillas
- Debe ser exactamente como se muestra arriba

**Si no están:**
1. Haz clic en **"Add URL"** o el botón **"+"**
2. Añade cada URL una por una
3. Haz clic en **"Save"** o **"Update"**

### 1.5 Verificar que Google OAuth está habilitado

1. En el menú de Authentication, ve a **"Providers"**
2. Busca **"Google"** en la lista
3. Verifica que el toggle esté **activado** (ON/verde)
4. Si no está activado, actívalo
5. Verifica que tienes:
   - **Client ID** configurado
   - **Client Secret** configurado

---

## 🟢 Paso 2: Verificar en Google Cloud Console

### 2.1 Acceder a Google Cloud Console

1. Ve a: **https://console.cloud.google.com/**
2. Inicia sesión con tu cuenta de Google
3. Selecciona tu proyecto (probablemente "QuePlan" o similar)

### 2.2 Ir a APIs & Services → Credentials

**Ruta exacta:**
1. En el menú lateral izquierdo (☰), busca **"APIs & Services"**
2. Haz clic en **"APIs & Services"**
3. En el submenú, haz clic en **"Credentials"**

**O ve directamente a:**
```
https://console.cloud.google.com/apis/credentials
```

### 2.3 Encontrar tu OAuth 2.0 Client ID

1. En la lista de credenciales, busca una entrada de tipo **"OAuth 2.0 Client ID"**
2. El nombre probablemente sea algo como:
   - "QuePlan - Supabase"
   - "Web client" 
   - O similar
3. Haz clic en el nombre para abrir los detalles

### 2.4 Verificar Authorized redirect URIs (⚠️ CRÍTICO)

**En la sección "Authorized redirect URIs", DEBES tener esta URL:**

```
https://oudofaiekedtaovrdqeo.supabase.co/auth/v1/callback
```

**⚠️ IMPORTANTE:**
- Debe ser exactamente esta URL (con tu ID de proyecto de Supabase)
- Si tu proyecto tiene otro ID, reemplaza `oudofaiekedtaovrdqeo` con tu ID
- NO debe haber espacios
- Debe empezar con `https://` y terminar con `/auth/v1/callback`

**Si no está:**
1. Haz clic en el botón de editar (✏️) o en **"EDIT"**
2. En **"Authorized redirect URIs"**, haz clic en **"+ ADD URI"**
3. Pega la URL: `https://oudofaiekedtaovrdqeo.supabase.co/auth/v1/callback`
4. Haz clic en **"SAVE"**

### 2.5 Verificar Application type

**Debe estar configurado como:**
- **Application type**: `Web application`

**NO debe ser:**
- ❌ iOS
- ❌ Android
- ❌ Desktop app

---

## ✅ Resumen de Configuración Correcta

### En Supabase Dashboard:
```
Authentication → URL Configuration → Redirect URLs:
✅ io.supabase.fiestapp://login-callback
✅ io.supabase.fiestapp://auth/confirmed
✅ io.supabase.fiestapp://reset-password

Authentication → Providers → Google:
✅ Toggle activado (ON)
✅ Client ID configurado
✅ Client Secret configurado
```

### En Google Cloud Console:
```
APIs & Services → Credentials → OAuth 2.0 Client ID:
✅ Application type: Web application
✅ Authorized redirect URIs:
   https://oudofaiekedtaovrdqeo.supabase.co/auth/v1/callback
```

---

## 🧪 Cómo Probar

Después de verificar/actualizar la configuración:

1. **Desinstala la app del iPhone** (importante para limpiar caché)
2. **Recompila y reinstala:**
   ```bash
   flutter clean
   flutter pub get
   flutter run
   ```
3. **Intenta iniciar sesión con Google**
4. **Deberías ver:**
   - Se abre Safari con la página de Google para autorizar
   - Después de autorizar, Safari se cierra automáticamente
   - La app vuelve al primer plano
   - El login se completa exitosamente

---

## 🚨 Problemas Comunes

### Error: "Safari no puede abrir la página"
**Causa**: Las Redirect URLs no están configuradas en Supabase  
**Solución**: Verifica el Paso 1.4

### Error: "redirect_uri_mismatch"
**Causa**: La URL en Google Cloud Console no coincide  
**Solución**: Verifica el Paso 2.4

### Se abre Safari pero no vuelve a la app
**Causa**: El deep link no está configurado en Info.plist  
**Solución**: Ya está configurado ✅, pero verifica que el archivo se guardó correctamente

### La app se cierra al intentar login
**Causa**: Error en el código o configuración  
**Solución**: Revisa los logs con `flutter run -v`

---

## 📸 Dónde Encontrar Cada Configuración

### Supabase Dashboard:
```
Dashboard → Tu Proyecto → Authentication → URL Configuration
Dashboard → Tu Proyecto → Authentication → Providers → Google
```

### Google Cloud Console:
```
Google Cloud Console → Tu Proyecto → APIs & Services → Credentials → OAuth 2.0 Client ID
```

---

## 🔗 Enlaces Directos

Si tienes problemas encontrando las secciones:

**Supabase Dashboard:**
- URL Configuration: https://app.supabase.com/project/_/auth/url-configuration
- Providers: https://app.supabase.com/project/_/auth/providers

**Google Cloud Console:**
- Credentials: https://console.cloud.google.com/apis/credentials

---

## ✅ Checklist Final

Antes de probar, verifica:

- [ ] Redirect URLs configuradas en Supabase (3 URLs)
- [ ] Google OAuth habilitado en Supabase
- [ ] Client ID y Secret configurados en Supabase
- [ ] Authorized redirect URI configurado en Google Cloud Console
- [ ] Application type es "Web application" en Google Cloud Console
- [ ] Info.plist tiene CFBundleURLTypes configurado (ya está ✅)
- [ ] AppDelegate.swift maneja deep links (ya está ✅)

---

## 💡 Nota Importante

**Los cambios en Supabase y Google Cloud Console pueden tardar unos minutos en aplicarse.** Si acabas de hacer cambios, espera 1-2 minutos antes de probar.

