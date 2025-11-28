# 🔔 Configurar Notificaciones con API V1 (Solución Definitiva)

## ✅ Situación

Firebase ya no permite habilitar la API heredada. Usaremos la **API V1 moderna** con una **Supabase Edge Function**.

---

## 🎯 Solución: Supabase Edge Function + Firebase Service Account

### Ventajas:
- ✅ Usa la API V1 moderna (recomendada)
- ✅ Credenciales seguras (en el servidor)
- ✅ Escalable y mantenible

---

## 📋 Pasos

### Paso 1: Crear Service Account en Firebase

1. **En Firebase Console**, ve a:
   - **Configuración del proyecto** (⚙️)
   - Pestaña **"Cuentas de servicio"** o **"Service accounts"**

2. **Clic en "Generar nueva clave privada"** o **"Generate new private key"**
3. **Se descargará un archivo JSON** (guárdalo de forma segura)

### Paso 2: Obtener Project ID

En la misma pantalla de Firebase, copia el **Project ID**:
- Aparece en la URL: `console.firebase.google.com/u/3/project/queplan-5b9da/...`
- El Project ID es: `queplan-5b9da` (o similar)

### Paso 3: Configurar en Supabase

1. Ve a **Supabase Dashboard** → Tu proyecto
2. Ve a **Edge Functions** o **Functions**
3. Crea una nueva función o configura las variables de entorno:
   - `FIREBASE_PROJECT_ID`: Tu Project ID de Firebase
   - `FIREBASE_SERVICE_ACCOUNT_KEY`: Contenido del archivo JSON (como string)

---

## 🔄 Alternativa Simple: Trigger en Supabase + Webhook

Una alternativa más simple es crear un **trigger en PostgreSQL** que llame a un webhook cuando se aprueba un evento. Esto es más fácil de configurar.

---

**¿Quieres que implementemos la Edge Function o prefieres una solución más simple con triggers de Supabase?**

