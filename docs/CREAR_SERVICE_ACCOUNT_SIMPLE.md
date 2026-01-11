# 🔑 Crear Service Account - Guía Simple

## ✅ Respuesta Rápida

**NO necesitas elegir ningún lenguaje.** Solo descarga el archivo JSON.

---

## 📋 Pasos Exactos

### 1. Ir a Firebase Console

1. Ve a: https://console.firebase.google.com/
2. Selecciona proyecto **"QuePlan"**
3. Haz clic en el **engranaje ⚙️** (arriba a la izquierda)
4. Selecciona **"Configuración del proyecto"**

### 2. Ir a Cuentas de Servicio

Busca la pestaña **"Cuentas de servicio"** o **"Service accounts"**

Puede estar:
- En la parte superior (tabs horizontales)
- O en el menú lateral izquierdo

### 3. Generar Clave

1. Busca el botón: **"Generar nueva clave privada"** o **"Generate new private key"**
2. Al hacer clic, **NO te pregunta por lenguaje**
3. Se descarga automáticamente un archivo JSON
4. Nombre del archivo: `queplan-5b9da-firebase-adminsdk-xxxxx.json`

### 4. Qué hacer con el archivo

1. **Abre el archivo JSON** con cualquier editor de texto
2. **Copia TODO el contenido** (todo el texto del archivo)
3. **Guárdalo de forma segura** (no lo subas a Git)

---

## 💡 Importante

- ❌ **NO necesitas elegir Node.js, Java, Python o Go**
- ✅ Solo descarga el JSON
- ✅ El JSON funciona con cualquier plataforma

---

## 🎯 Qué contiene el JSON

El archivo tiene esta estructura (ejemplo):

```json
{
  "type": "service_account",
  "project_id": "queplan-5b9da",
  "private_key_id": "...",
  "private_key": "-----BEGIN PRIVATE KEY-----\n...\n-----END PRIVATE KEY-----\n",
  "client_email": "firebase-adminsdk-xxxxx@queplan-5b9da.iam.gserviceaccount.com",
  "client_id": "...",
  "auth_uri": "https://accounts.google.com/o/oauth2/auth",
  "token_uri": "https://oauth2.googleapis.com/token",
  "auth_provider_x509_cert_url": "https://www.googleapis.com/oauth2/v1/certs",
  "client_x509_cert_url": "..."
}
```

**Necesitas copiar TODO este contenido** para pegarlo en Supabase.

---

## ✅ Siguiente Paso

Una vez tengas el JSON:
1. Abre el archivo
2. Copia todo su contenido
3. Pégalo en Supabase como variable `FIREBASE_SERVICE_ACCOUNT_KEY`

---

**¿Ya descargaste el archivo JSON? Si tienes alguna duda sobre dónde encontrarlo, dímelo.**



























