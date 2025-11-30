# 🔧 Solución: Restricción al Crear Service Account Key

## ⚠️ Problema

Firebase muestra: *"No se permite crear claves en esta cuenta de servicio. Verifica si las políticas de la organización restringen la creación de claves en cuentas de servicio."*

Esto significa que hay una política de organización que lo bloquea.

---

## ✅ Solución 1: Crear Nueva Service Account en Google Cloud Console

### Paso 1: Ir a Google Cloud Console

1. Ve a: https://console.cloud.google.com/
2. Selecciona el proyecto **"queplan-5b9da"** (o "QuePlan")

### Paso 2: Crear Nueva Service Account

1. Ve a **"IAM & Admin"** → **"Service Accounts"**
2. Haz clic en **"Create Service Account"** o **"Crear cuenta de servicio"**
3. Completa:
   - **Service account name:** `fcm-notifications`
   - **Description:** `Service account para enviar notificaciones FCM`
4. Haz clic en **"Create and Continue"**

### Paso 3: Asignar Rol

1. En **"Grant this service account access to project"**, agrega el rol:
   - **"Firebase Cloud Messaging API Admin"** o **"Firebase Admin SDK Administrator Service Agent"**
2. Haz clic en **"Continue"** y luego **"Done"**

### Paso 4: Crear y Descargar Clave

1. En la lista de Service Accounts, haz clic en la que acabas de crear (`fcm-notifications`)
2. Ve a la pestaña **"Keys"**
3. Haz clic en **"Add Key"** → **"Create new key"**
4. Selecciona **"JSON"**
5. Haz clic en **"Create"**
6. **Se descargará el archivo JSON** → Guárdalo

---

## ✅ Solución 2: Verificar Otras Service Accounts

1. En la pantalla donde estás, haz clic en el enlace **"3 cuentas de servicio"**
2. Revisa si alguna permite crear claves
3. Si alguna funciona, úsala

---

## ✅ Solución 3: Solicitar Permisos (Si estás en organización)

Si el proyecto pertenece a una organización de Google Cloud:

1. Contacta al administrador de la organización
2. Solicita que permitan crear claves para Service Accounts
3. O que creen la clave por ti

---

## 🎯 Recomendación

**Usa la Solución 1** (crear nueva Service Account en Google Cloud Console) - Es la más directa y suele funcionar.

---

**¿Quieres que te guíe paso a paso por Google Cloud Console para crear la Service Account?**


