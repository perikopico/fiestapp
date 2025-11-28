# 🔑 Crear Service Account para Notificaciones

## 📍 Dónde Está

La Service Account está en **Firebase Console**, NO en Google Cloud Console.

---

## 🎯 Pasos para Crear Service Account

### Paso 1: Ir a Firebase Console

1. Ve a: https://console.firebase.google.com/
2. Selecciona tu proyecto **"QuePlan"**
3. Haz clic en el **engranaje ⚙️** (arriba a la izquierda)
4. Selecciona **"Configuración del proyecto"**

### Paso 2: Ir a Cuentas de Servicio

1. Busca la pestaña **"Cuentas de servicio"** o **"Service accounts"**
2. Ahí verás las Service Accounts existentes

### Paso 3: Generar Nueva Clave

1. Busca el botón **"Generar nueva clave privada"** o **"Generate new private key"**
2. Haz clic en él
3. Se descargará un archivo **JSON** (guárdalo de forma segura)

---

## 📝 Qué contiene el archivo JSON

El archivo JSON tiene esta estructura:
```json
{
  "type": "service_account",
  "project_id": "queplan-5b9da",
  "private_key_id": "...",
  "private_key": "-----BEGIN PRIVATE KEY-----\n...\n-----END PRIVATE KEY-----\n",
  "client_email": "...",
  "client_id": "...",
  ...
}
```

**⚠️ Importante:** Este archivo es **muy sensible**. No lo subas a Git ni lo compartas públicamente.

---

## 🔄 Próximos Pasos

Una vez tengas el archivo JSON, necesitamos:

1. **Configurar Supabase Edge Function** para usar este JSON
2. **O usar el JSON en un servidor** para enviar notificaciones

---

## 💡 Alternativa Simple

Si quieres evitar configurar Edge Functions por ahora, podemos:
- Dejar las notificaciones automáticas deshabilitadas
- Usar solo notificaciones manuales desde Firebase Console (que funcionan perfectamente)

---

**¿Quieres crear la Service Account ahora o dejamos las automáticas para más adelante?**

