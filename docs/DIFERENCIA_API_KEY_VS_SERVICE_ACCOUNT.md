# 🔑 Diferencia: API Key vs Service Account

## ❓ ¿Qué estás viendo ahora?

Estás viendo una **API Key** en Google Cloud Console. Esta clave es para que la **app cliente** (tu app Flutter) pueda usar servicios de Google Cloud.

## ❌ ¿Por qué no sirve para notificaciones?

Las **API Keys** son para:
- ✅ Acceder a servicios desde la **app cliente**
- ✅ Identificar tu proyecto
- ❌ **NO** para enviar notificaciones desde el servidor

---

## ✅ ¿Qué necesitamos realmente?

Para **enviar notificaciones automáticas desde el backend**, necesitamos:

### **Service Account** (Cuenta de Servicio)

1. **Ve a Firebase Console:**
   - Configuración del proyecto (⚙️)
   - Pestaña **"Cuentas de servicio"** o **"Service accounts"**

2. **Crea o usa una Service Account:**
   - Haz clic en **"Generar nueva clave privada"** o **"Generate new private key"**
   - Se descargará un archivo **JSON**

3. **Ese JSON** es lo que necesitamos para autenticarnos y enviar notificaciones

---

## 🎯 Resumen

| Tipo | Para qué sirve | ¿Sirve para enviar notificaciones? |
|------|----------------|-----------------------------------|
| **API Key** | App cliente → Servicios Google | ❌ No |
| **Service Account** | Servidor → Enviar notificaciones | ✅ Sí |

---

**¿Quieres que te guíe para crear la Service Account?**

