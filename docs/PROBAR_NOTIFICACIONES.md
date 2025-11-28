# 🧪 Cómo Probar las Notificaciones Push

## ✅ Estado Actual

- ✅ Tabla `user_fcm_tokens` creada en Supabase
- ✅ Servicio FCMTokenService implementado
- ✅ Handlers de notificaciones implementados
- ✅ Integración con autenticación completa

---

## 📱 PASO 1: Verificar que los Tokens se Guardan

### 1.1. Reinicia la App

1. Cierra completamente la app
2. Ábrela de nuevo
3. Revisa la consola de logs

### 1.2. Inicia Sesión

1. Ve a la pantalla de login
2. Inicia sesión con tu usuario
3. Revisa los logs - deberías ver:
   ```
   ✅ Usuario autenticado: tu-email@ejemplo.com
   ✅ Token FCM guardado después de login
   ```

### 1.3. Verificar en Supabase

1. Ve a **Supabase Dashboard > Table Editor**
2. Selecciona la tabla **`user_fcm_tokens`**
3. Deberías ver una fila con:
   - `user_id`: Tu ID de usuario
   - `token`: Tu token FCM (cadena larga)
   - `device_type`: 'android', 'ios' o 'web'
   - `created_at`: Fecha de creación
   - `updated_at`: Fecha de actualización

---

## 🔔 PASO 2: Probar Notificaciones en Diferentes Estados

### 2.1. Notificación en Foreground (App abierta)

**Cómo probar:**
1. Abre la app y déjala visible en pantalla
2. Envía una notificación de prueba (ver PASO 3)
3. Deberías ver un SnackBar en la app con la notificación

### 2.2. Notificación en Background (App minimizada)

**Cómo probar:**
1. Abre la app
2. Minimízala (no la cierres)
3. Envía una notificación de prueba
4. Deberías recibir la notificación en la bandeja del sistema
5. Toca la notificación - debería abrir la app

### 2.3. Notificación cuando la App está Cerrada

**Cómo probar:**
1. Cierra completamente la app
2. Envía una notificación de prueba
3. Deberías recibir la notificación en la bandeja del sistema
4. Toca la notificación - debería abrir la app

---

## 🧪 PASO 3: Enviar Notificación de Prueba

### Opción A: Usar Firebase Console (Más Fácil)

1. Ve a [Firebase Console](https://console.firebase.google.com/)
2. Selecciona tu proyecto
3. Ve a **Engage > Cloud Messaging**
4. Haz clic en **"Send test message"** o **"Nueva notificación"**
5. Completa:
   - **Título**: "Prueba de notificación"
   - **Texto**: "Esto es una prueba"
   - **FCM registration token**: Copia el token desde Supabase (tabla `user_fcm_tokens`)
6. Haz clic en **"Test"** o **"Enviar"**

### Opción B: Usar curl (Línea de Comandos)

```bash
# Reemplaza:
# - YOUR_SERVER_KEY: Tu Server Key de Firebase (en Firebase Console > Project Settings > Cloud Messaging)
# - YOUR_FCM_TOKEN: El token de la tabla user_fcm_tokens

curl -X POST https://fcm.googleapis.com/fcm/send \
  -H "Authorization: key=YOUR_SERVER_KEY" \
  -H "Content-Type: application/json" \
  -d '{
    "to": "YOUR_FCM_TOKEN",
    "notification": {
      "title": "Prueba de notificación",
      "body": "Esto es una prueba desde curl"
    },
    "data": {
      "type": "test",
      "event_id": "123"
    }
  }'
```

### Opción C: Crear Función en Supabase (Recomendado para Producción)

Ver sección "PASO 4" más abajo.

---

## 🔍 PASO 4: Verificar Logs

### En la App (Flutter Logs)

Busca estos mensajes:
- `✅ Token FCM guardado en Supabase` - Token guardado correctamente
- `📨 Notificación recibida en foreground` - Notificación recibida con app abierta
- `📨 Notificación recibida en background` - Notificación recibida con app minimizada
- `👆 Usuario tocó la notificación` - Usuario interactuó con la notificación

### En Supabase (Logs)

1. Ve a **Supabase Dashboard > Logs**
2. Revisa:
   - **Auth Logs**: Para ver intentos de login
   - **Postgres Logs**: Para ver queries a la base de datos
   - **API Logs**: Para ver requests a la API

---

## ✅ Checklist de Verificación

- [ ] Token FCM se obtiene correctamente (revisar logs)
- [ ] Token se guarda en Supabase después de login (verificar tabla)
- [ ] Notificación en foreground muestra SnackBar
- [ ] Notificación en background aparece en bandeja del sistema
- [ ] Notificación cuando app está cerrada funciona
- [ ] Al tocar notificación, la app se abre correctamente
- [ ] Logs muestran información correcta

---

## 🚨 Problemas Comunes

### Problema: "Token no se guarda en Supabase"

**Solución:**
1. Verifica que estés autenticado
2. Revisa los logs para ver el error específico
3. Verifica que la tabla `user_fcm_tokens` existe
4. Verifica que las políticas RLS están correctas

### Problema: "No recibo notificaciones"

**Solución:**
1. Verifica que los permisos de notificación estén concedidos
2. Verifica que el token FCM es correcto
3. Verifica que Firebase está correctamente configurado
4. En Android, verifica que el servicio de Firebase Messaging está en AndroidManifest.xml

### Problema: "Notificación no abre la app"

**Solución:**
1. Verifica que `navigatorKey` está configurado correctamente
2. Revisa los logs para ver si hay errores de navegación
3. Verifica que los datos de la notificación están en el formato correcto

---

## 📝 Próximos Pasos

Una vez verificado que todo funciona:

1. **Crear función en Supabase para enviar notificaciones**
   - Permite enviar notificaciones desde el backend
   - Se puede llamar cuando se aprueban eventos, etc.

2. **Configurar notificaciones automáticas**
   - Cuando se aprueba un evento del usuario
   - Cuando hay nuevos eventos en categorías favoritas
   - Recordatorios de eventos próximos

3. **Mejorar navegación desde notificaciones**
   - Navegar a eventos específicos
   - Navegar a "Mis eventos"
   - Navegar al dashboard

---

**¿Todo funcionando? ¡Excelente! 🎉**
