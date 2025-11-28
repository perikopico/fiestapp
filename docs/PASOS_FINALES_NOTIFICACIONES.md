# ✅ Pasos Finales para Completar Notificaciones Automáticas

## 🎯 Objetivo

Configurar todo para que las notificaciones automáticas funcionen cuando se aprueba un evento.

---

## 📋 PASO 1: Crear Service Account en Firebase (5 minutos)

### 1.1. Ve a Firebase Console

1. Abre: https://console.firebase.google.com/
2. Selecciona proyecto **"QuePlan"**
3. Haz clic en el **engranaje ⚙️** (arriba a la izquierda)
4. Selecciona **"Configuración del proyecto"**

### 1.2. Busca "Cuentas de servicio"

1. Busca la pestaña **"Cuentas de servicio"** o **"Service accounts"**
   - Puede estar en la parte superior (tabs horizontales)
   - O en el menú lateral izquierdo

### 1.3. Generar Nueva Clave

1. Busca el botón: **"Generar nueva clave privada"** o **"Generate new private key"**
2. Haz clic
3. Se descargará un archivo JSON (ejemplo: `queplan-5b9da-firebase-adminsdk-xxxxx.json`)
4. **Abre ese archivo JSON** - necesitarás copiar todo su contenido

### 1.4. Obtener Project ID

En la misma pantalla de configuración, busca el **Project ID**:
- Ejemplo: `queplan-5b9da`
- Está en la URL o en la sección "General"

---

## 📋 PASO 2: Configurar en Supabase (5 minutos)

### 2.1. Ir a Supabase Dashboard

1. Ve a: https://supabase.com/dashboard
2. Selecciona tu proyecto

### 2.2. Configurar Secrets/Variables

1. Ve a **Project Settings** (⚙️)
2. Busca **"Edge Functions"** o **"Functions"** en el menú
3. Busca **"Secrets"** o **"Environment Variables"**
4. Agrega estas dos variables:

**Variable 1:**
- **Nombre:** `FIREBASE_PROJECT_ID`
- **Valor:** Tu Project ID (ejemplo: `queplan-5b9da`)

**Variable 2:**
- **Nombre:** `FIREBASE_SERVICE_ACCOUNT_KEY`
- **Valor:** Todo el contenido del archivo JSON (cópialo completo)

---

## 📋 PASO 3: Desplegar Edge Function (10 minutos)

### Opción A: Desde Supabase Dashboard (Más Fácil)

1. Ve a **Edge Functions** en Supabase Dashboard
2. Haz clic en **"Create a new function"** o **"Nueva función"**
3. **Nombre:** `send_fcm_notification`
4. **Copia el código** del archivo: `supabase/functions/send_fcm_notification/index.ts`
5. Pega el código en el editor
6. Haz clic en **"Deploy"** o **"Desplegar"**

### Opción B: Desde Terminal (Si tienes Supabase CLI)

```bash
# Instalar Supabase CLI (si no lo tienes)
npm install -g supabase

# Login
supabase login

# Desplegar
supabase functions deploy send_fcm_notification
```

---

## 📋 PASO 4: Probar (2 minutos)

1. **Reinicia la app Flutter**
2. **Crea un evento** (o usa uno pendiente)
3. **Como admin, aprueba el evento** desde el panel de administración
4. **El usuario que creó el evento debería recibir una notificación**

---

## ✅ Checklist Final

- [ ] Service Account creada en Firebase
- [ ] Archivo JSON descargado
- [ ] Project ID copiado
- [ ] Variables configuradas en Supabase (FIREBASE_PROJECT_ID y FIREBASE_SERVICE_ACCOUNT_KEY)
- [ ] Edge Function desplegada en Supabase
- [ ] App reiniciada
- [ ] Notificación de prueba enviada

---

## 🆘 Si Algo No Funciona

### Error: "Firebase credentials not configured"
- Verifica que las variables de entorno estén configuradas en Supabase
- Verifica que los nombres sean exactos: `FIREBASE_PROJECT_ID` y `FIREBASE_SERVICE_ACCOUNT_KEY`

### Error: "Failed to get access token"
- Verifica que el contenido del JSON esté completo y correcto
- No debe tener saltos de línea extra ni caracteres especiales

### Error: "Edge Function not found"
- Verifica que la función esté desplegada en Supabase
- Verifica que el nombre sea exacto: `send_fcm_notification`

---

**¿Necesitas ayuda con algún paso? Dime cuál y te guío paso a paso.**

