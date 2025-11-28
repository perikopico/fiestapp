# 🔔 Configurar Notificaciones Automáticas

## ✅ Estado

Las notificaciones automáticas están implementadas. Cuando un admin aprueba o rechaza un evento, se envía automáticamente una notificación al usuario que lo creó.

---

## 🔑 Paso 1: Habilitar API Heredada y Obtener Server Key

**⚠️ Importante:** La API heredada está deshabilitada por defecto. Necesitas habilitarla primero.

### 1.1. Habilitar la API Heredada

1. **En la pantalla de Cloud Messaging** donde estás ahora
2. **Busca la sección "API de Cloud Messaging (heredada)"**
3. **Debería decir "Inhabilitado"** con un menú de tres puntos (⋯) a la derecha
4. **Haz clic en los tres puntos** (⋯)
5. **Selecciona "Habilitar"**

### 1.2. Obtener el Server Key

Una vez habilitada:

1. **La sección mostrará "Habilitado"**
2. **Aparecerá un campo "Clave del servidor"** o **"Server key"**
3. **Haz clic en "mostrar" o "copiar"** para verla
4. **Copia la clave completa** (empieza con `AAAA...`)

**Nota:** Esta clave será necesaria para enviar notificaciones desde el backend.

---

## 📝 Paso 2: Agregar Server Key al .env

1. Abre el archivo `.env` en la raíz del proyecto
2. Agrega esta línea:

```env
FCM_SERVER_KEY=AAAAxxxxx:APA91b...tu-server-key-aqui...
```

**Ejemplo:**
```env
SUPABASE_URL=https://xxxxx.supabase.co
SUPABASE_ANON_KEY=eyJhbGc...
FCM_SERVER_KEY=AAAAxxxxx:APA91bH_xxxxxxxxxxxxx...
```

3. **Guarda el archivo**

---

## 🧪 Paso 3: Probar

1. **Instala las dependencias:**
   ```bash
   flutter pub get
   ```

2. **Reinicia la app**

3. **Crea un evento** desde la app (o usa uno existente pendiente)

4. **Como admin, aprueba el evento** desde el panel de administración

5. **El usuario que creó el evento debería recibir una notificación** que dice:
   - **Título**: "✅ Tu evento ha sido aprobado"
   - **Texto**: "[Título del evento] ya está publicado en QuePlan"

---

## 📱 Cómo funciona

1. **Usuario crea un evento** → Estado: `pending`
2. **Admin aprueba el evento** → Estado cambia a: `published`
3. **Sistema automáticamente:**
   - Obtiene el `created_by` del evento
   - Busca los tokens FCM del usuario en la tabla `user_fcm_tokens`
   - Envía la notificación a todos los dispositivos del usuario

---

## 🔍 Verificar que funciona

### Ver logs en la consola de Flutter:

Busca estos mensajes:
- `✅ Evento [id] aprobado por [email]`
- `✅ Notificación enviada exitosamente`

Si hay errores:
- `⚠️ FCM_SERVER_KEY no está configurado en .env`
- `⚠️ El usuario [id] no tiene tokens FCM registrados`
- `❌ Error al enviar notificación: ...`

---

## 🚨 Solución de Problemas

### Problema: "FCM_SERVER_KEY no está configurado"

**Solución:**
- Verifica que agregaste `FCM_SERVER_KEY=...` al archivo `.env`
- Verifica que no hay espacios alrededor del `=`
- Reinicia la app después de agregar la variable

### Problema: "El usuario no tiene tokens FCM registrados"

**Solución:**
- El usuario debe estar autenticado
- El usuario debe haber abierto la app al menos una vez (para obtener el token)
- Verifica en Supabase → Tabla `user_fcm_tokens` que existe un token para ese usuario

### Problema: "Error al enviar notificación"

**Solución:**
- Verifica que el Server Key sea correcto
- Verifica que Cloud Messaging esté habilitado en Firebase Console
- Revisa los logs de Flutter para ver el error específico

---

## 📝 Archivos Relacionados

- `lib/services/notification_sender_service.dart` - Servicio para enviar notificaciones
- `lib/services/admin_moderation_service.dart` - Servicio de moderación (integrado con notificaciones)
- `lib/services/fcm_token_service.dart` - Servicio para gestionar tokens FCM

---

**¡Listo!** Las notificaciones automáticas están configuradas. 🎉

