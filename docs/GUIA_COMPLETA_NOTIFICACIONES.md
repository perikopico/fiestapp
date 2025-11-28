# 🔔 Guía Completa: Configurar Notificaciones Automáticas

## 📋 Paso 1: Crear Service Account en Firebase

1. Ve a **Firebase Console**: https://console.firebase.google.com/
2. Selecciona proyecto **"QuePlan"**
3. **Configuración del proyecto** (⚙️) → **"Cuentas de servicio"**
4. Haz clic en **"Generar nueva clave privada"**
5. Se descarga un archivo JSON → **Guárdalo de forma segura**

---

## 📋 Paso 2: Obtener Project ID

En Firebase Console, copia el **Project ID**:
- En la URL: `console.firebase.google.com/.../project/queplan-5b9da/...`
- O en Configuración → General
- Ejemplo: `queplan-5b9da`

---

## 📋 Paso 3: Configurar Supabase Edge Function

### 3.1. Preparar el archivo JSON

Abre el archivo JSON descargado y cópialo **completo** (todo el contenido).

### 3.2. Configurar variables en Supabase

1. Ve a **Supabase Dashboard** → Tu proyecto
2. Ve a **Edge Functions** o **Project Settings → Edge Functions**
3. Busca **"Secrets"** o **"Variables de entorno"**
4. Agrega estas dos variables:

**Variable 1:**
- Nombre: `FIREBASE_PROJECT_ID`
- Valor: Tu Project ID (ejemplo: `queplan-5b9da`)

**Variable 2:**
- Nombre: `FIREBASE_SERVICE_ACCOUNT_KEY`
- Valor: Todo el contenido del archivo JSON (pégalo completo como texto)

---

## 📋 Paso 4: Desplegar Edge Function

La Edge Function ya está creada en: `supabase/functions/send_fcm_notification/`

Para desplegarla:

```bash
# Si tienes Supabase CLI instalado:
supabase functions deploy send_fcm_notification

# O desde Supabase Dashboard:
# 1. Ve a Edge Functions
# 2. Crea nueva función
# 3. Copia el código de supabase/functions/send_fcm_notification/index.ts
```

---

## 📋 Paso 5: Probar

1. **Reinicia la app**
2. **Crea un evento** (o usa uno pendiente)
3. **Como admin, aprueba el evento**
4. **El creador debería recibir una notificación**

---

## ✅ Listo

Las notificaciones automáticas ya están funcionando. 🎉

---

**¿Necesitas ayuda con algún paso? Dime y te guío.**

