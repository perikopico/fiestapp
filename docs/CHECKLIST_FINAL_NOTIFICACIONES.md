# ✅ Checklist Final - Notificaciones Automáticas

## 🎯 Resumen

Todo el código está listo. Solo necesitas completar estos 3 pasos:

---

## ✅ Paso 1: Crear Service Account

**⚠️ Si Firebase muestra restricción, ve directamente a Google Cloud Console:**

### Opción A: Desde Google Cloud Console (Recomendado)

1. Ve a: https://console.cloud.google.com/
2. Selecciona proyecto **"queplan-5b9da"**
3. **"IAM & Admin"** → **"Service Accounts"**
4. **"Create Service Account"** o **"Crear cuenta de servicio"**
5. Nombre: `fcm-notifications`
6. Asignar rol: **"Firebase Cloud Messaging API Admin"**
7. **"Keys"** → **"Add Key"** → **"Create new key"** → Selecciona **"JSON"**
8. **Descarga el archivo JSON** → Ábrelo y copia todo su contenido

### Opción B: Desde Firebase (Si no hay restricción)

1. **Firebase Console** → ⚙️ → **"Configuración del proyecto"**
2. Pestaña **"Cuentas de servicio"**
3. Clic en **"Generar nueva clave privada"**
4. **Descarga el archivo JSON** → Ábrelo y copia todo su contenido

### Obtener Project ID

En cualquier caso, copia el **Project ID**: `queplan-5b9da`

---

## ✅ Paso 2: Configurar en Supabase

1. **Supabase Dashboard** → Tu proyecto → ⚙️ → **"Edge Functions"**
2. Busca **"Secrets"** o **"Environment Variables"**
3. Agrega estas variables:

```
FIREBASE_PROJECT_ID = queplan-5b9da
FIREBASE_SERVICE_ACCOUNT_KEY = {pega aquí todo el contenido del JSON}
```

---

## ✅ Paso 3: Desplegar Edge Function

1. **Supabase Dashboard** → **"Edge Functions"**
2. **"Create a new function"** o **"Nueva función"**
3. **Nombre:** `send_fcm_notification`
4. **Copia el código** de: `supabase/functions/send_fcm_notification/index.ts`
5. **Pega y despliega**

---

## 🧪 Paso 4: Probar

1. Reinicia la app
2. Aprueba un evento como admin
3. El creador debería recibir una notificación

---

**¿Listo? Sigue estos 3 pasos y las notificaciones automáticas funcionarán. 🚀**

