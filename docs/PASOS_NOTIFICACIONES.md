# 🔔 Pasos para Completar las Notificaciones Push

Sigue estos pasos en orden para implementar completamente las notificaciones push.

---

## ✅ PASO 1: Ejecutar Migración SQL

**Ubicación**: Supabase Dashboard > SQL Editor

1. Abre el archivo: `docs/migrations/003_create_fcm_tokens_table.sql`
2. Copia todo el contenido
3. Pégalo en el SQL Editor de Supabase
4. Ejecuta el script (botón RUN o `Ctrl+Enter`)
5. Verifica que no haya errores

**Qué hace**: Crea la tabla `user_fcm_tokens` para almacenar los tokens FCM de cada usuario.

---

## ✅ PASO 2: Actualizar main.dart

**Archivo**: `lib/main.dart`

Necesitas hacer estos cambios:

1. **Añadir imports** al inicio del archivo (después de la línea 11):
```dart
import 'services/fcm_token_service.dart';
import 'services/notification_handler.dart';
```

2. **Reemplazar la función `_initializeFCMToken()`** con inicialización de los nuevos servicios.

3. **Actualizar el listener de autenticación** para guardar/eliminar tokens.

4. **Inicializar NotificationHandler** después de Firebase.

**Voy a hacer estos cambios por ti, pero primero ejecuta el PASO 1.**

---

## ✅ PASO 3: Probar que los Tokens se Guardan

1. Abre la app
2. Inicia sesión con tu usuario
3. Revisa los logs - deberías ver: "✅ Token FCM guardado en Supabase"
4. Ve a Supabase Dashboard > Table Editor > `user_fcm_tokens`
5. Verifica que aparece tu token

---

## ✅ PASO 4: Crear Función para Enviar Notificaciones

Crearemos una función en Supabase que permita enviar notificaciones desde el backend.

---

## 🧪 PASO 5: Probar Notificaciones

Cómo enviar una notificación de prueba y verificar que funciona.

---

## 📝 Resumen de Archivos Creados

Ya he creado estos archivos por ti:

1. ✅ `docs/migrations/003_create_fcm_tokens_table.sql` - Migración SQL
2. ✅ `lib/services/fcm_token_service.dart` - Servicio para gestionar tokens
3. ✅ `lib/services/notification_handler.dart` - Handlers de notificaciones
4. ✅ `docs/IMPLEMENTAR_NOTIFICACIONES.md` - Documentación completa
5. ✅ `docs/PASOS_NOTIFICACIONES.md` - Esta guía paso a paso

---

**¿Empezamos con el PASO 1?** 🚀
