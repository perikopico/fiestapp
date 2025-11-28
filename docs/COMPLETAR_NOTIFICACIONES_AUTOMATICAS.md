# 🔔 Completar Configuración de Notificaciones Automáticas

## 🎯 Objetivo

Configurar notificaciones automáticas que se envíen cuando un admin aprueba/rechaza un evento.

---

## 📋 Paso 1: Crear Service Account en Firebase

### 1.1. Ir a Firebase Console

1. Ve a: https://console.firebase.google.com/
2. Selecciona proyecto **"QuePlan"**
3. Haz clic en **engranaje ⚙️** → **"Configuración del proyecto"**

### 1.2. Ir a Cuentas de Servicio

1. Busca la pestaña **"Cuentas de servicio"** o **"Service accounts"**
2. Si no ves esa pestaña, busca en el menú superior o lateral

### 1.3. Generar Nueva Clave

1. Busca el botón **"Generar nueva clave privada"** o **"Generate new private key"**
2. Haz clic
3. Se descargará un archivo JSON (ejemplo: `queplan-5b9da-firebase-adminsdk-xxxxx.json`)
4. **Guarda este archivo de forma segura** (NO lo subas a Git)

---

## 📋 Paso 2: Obtener Project ID

En la misma pantalla de Firebase, copia el **Project ID**:
- Aparece en la URL: `console.firebase.google.com/u/3/project/queplan-5b9da/...`
- O en la sección de configuración general
- Ejemplo: `queplan-5b9da`

---

## 📋 Paso 3: Crear Supabase Edge Function

Crearemos una función en Supabase que use la Service Account para enviar notificaciones.

### 3.1. Estructura de la función

La función estará en: `supabase/functions/send_notification/`

---

## 📋 Paso 4: Configurar Variables en Supabase

Necesitamos agregar estas variables de entorno en Supabase:
- `FIREBASE_PROJECT_ID`: Tu Project ID
- `FIREBASE_SERVICE_ACCOUNT_KEY`: Contenido del archivo JSON (como string)

---

**¿Tienes ya el archivo JSON de la Service Account? Si lo tienes, dime y continúo con los siguientes pasos.**

