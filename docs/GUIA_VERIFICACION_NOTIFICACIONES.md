# 📱 Guía Completa de Verificación de Notificaciones Push

**Fecha**: Enero 2025  
**Tiempo estimado**: 20-30 minutos  
**Estado**: Listo para verificación

---

## 📊 Estado Actual del Código (Revisado)

### ✅ Componentes Implementados

1. **Firebase Core** ✅
   - ✅ `firebase_core: ^3.6.0` instalado
   - ✅ `firebase_messaging: ^15.1.3` instalado
   - ✅ Firebase inicializado en `main.dart`
   - ✅ `google-services.json` debe estar en `android/app/` (verificar)

2. **Servicios Flutter** ✅
   - ✅ `FCMTokenService` - Gestiona tokens FCM
   - ✅ `NotificationHandler` - Maneja notificaciones en foreground/background
   - ✅ `firebaseMessagingBackgroundHandler` - Handler para app cerrada
   - ✅ Inicialización en `main.dart` ✅

3. **Base de Datos** ✅
   - ✅ Tabla `user_fcm_tokens` creada (migración 003)
   - ✅ RLS habilitado y políticas configuradas
   - ✅ Índices creados para optimización

4. **Edge Function** ✅
   - ✅ `send_fcm_notification` implementada
   - ✅ Usa FCM API V1
   - ✅ Requiere variables de entorno en Supabase

5. **Integración con Autenticación** ✅
   - ✅ Token se guarda al iniciar sesión
   - ✅ Token se elimina al cerrar sesión
   - ✅ Token se actualiza cuando cambia

---

## 📋 Checklist de Verificación

### 1. Configuración de Firebase ⚠️ CRÍTICO

#### 1.1 Verificar google-services.json
- [ ] **Archivo existe**: `android/app/google-services.json`
- [ ] **Archivo correcto**: Debe ser del proyecto Firebase correcto
- [ ] **En .gitignore**: Verificar que está excluido del repositorio

**Cómo verificar**:
```bash
# Desde la raíz del proyecto
ls -la android/app/google-services.json
```

**Si no existe**:
1. Ir a Firebase Console: https://console.firebase.google.com/
2. Seleccionar el proyecto
3. Ir a Project Settings > General
4. Descargar `google-services.json`
5. Colocar en `android/app/google-services.json`

**Tiempo**: 5 minutos

---

#### 1.2 Verificar Firebase Cloud Messaging habilitado
- [ ] **FCM habilitado** en Firebase Console
- [ ] **Cloud Messaging API (V1)** habilitada en Google Cloud Console

**Cómo verificar**:
1. Ir a Firebase Console > Project Settings > Cloud Messaging
2. Verificar que "Cloud Messaging API (V1)" está habilitada
3. Si no está, habilitarla

**Tiempo**: 2 minutos

---

### 2. Edge Function en Supabase ⚠️ CRÍTICO

#### 2.1 Verificar que la función está desplegada
- [ ] **Función existe**: `send_fcm_notification`
- [ ] **Estado**: Desplegada (no en borrador)
- [ ] **Versión**: Última versión desplegada

**Pasos**:
1. Ir a Supabase Dashboard
2. Navegar a **Edge Functions** (menú lateral)
3. Buscar `send_fcm_notification`
4. Verificar que aparece en la lista y está activa

**Si no está desplegada**:
```bash
# Desde la raíz del proyecto
supabase functions deploy send_fcm_notification
```

**Tiempo**: 3 minutos

---

#### 2.2 Verificar Variables de Entorno (Secrets)
- [ ] **FIREBASE_PROJECT_ID** configurado
- [ ] **FIREBASE_SERVICE_ACCOUNT_KEY** configurado

**Pasos**:
1. En Supabase Dashboard, ir a **Project Settings** > **Edge Functions** > **Secrets**
2. Verificar que existen:
   - `FIREBASE_PROJECT_ID` - ID del proyecto Firebase (ej: `mi-proyecto-12345`)
   - `FIREBASE_SERVICE_ACCOUNT_KEY` - JSON completo del Service Account

**Cómo obtener FIREBASE_PROJECT_ID**:
- En Firebase Console > Project Settings > General
- Copiar el "Project ID"

**Cómo obtener FIREBASE_SERVICE_ACCOUNT_KEY**:
1. Ir a Firebase Console > Project Settings > Service Accounts
2. Hacer clic en "Generate new private key"
3. Descargar el JSON
4. Copiar TODO el contenido del JSON (como string) en el secret

**⚠️ IMPORTANTE**: El JSON debe estar como string completo, no como objeto.

**Tiempo**: 10 minutos

---

### 3. Base de Datos ⚠️ IMPORTANTE

#### 3.1 Verificar tabla user_fcm_tokens
- [ ] **Tabla existe**
- [ ] **RLS habilitado**
- [ ] **Políticas correctas**

**Verificar en Supabase SQL Editor**:
```sql
-- Verificar que la tabla existe
SELECT table_name 
FROM information_schema.tables 
WHERE table_schema = 'public' 
  AND table_name = 'user_fcm_tokens';

-- Verificar RLS
SELECT tablename, rowsecurity 
FROM pg_tables 
WHERE schemaname = 'public' 
  AND tablename = 'user_fcm_tokens';

-- Verificar políticas
SELECT * FROM pg_policies 
WHERE tablename = 'user_fcm_tokens';
```

**Resultado esperado**:
- Tabla existe ✅
- `rowsecurity = true` ✅
- Política "Users can manage own tokens" existe ✅

**Si la tabla no existe**:
- Ejecutar migración `docs/migrations/003_create_fcm_tokens_table.sql`

**Tiempo**: 3 minutos

---

#### 3.2 Verificar tokens guardados
- [ ] **Hay tokens en la tabla** (si hay usuarios con la app instalada)

**Verificar en Supabase SQL Editor**:
```sql
-- Contar tokens
SELECT COUNT(*) as total_tokens
FROM user_fcm_tokens;

-- Ver tokens (últimos 10)
SELECT 
  user_id,
  token,
  device_type,
  created_at,
  updated_at
FROM user_fcm_tokens
ORDER BY created_at DESC
LIMIT 10;
```

**Resultado esperado**:
- Si hay usuarios con la app instalada, debería haber tokens
- Si no hay tokens, es normal si nadie ha usado la app aún

**Tiempo**: 2 minutos

---

### 4. Funcionalidad en la App ⚠️ IMPORTANTE

#### 4.1 Verificar inicialización de Firebase
- [ ] **Firebase se inicializa correctamente**
- [ ] **No hay errores en consola**

**Cómo verificar**:
1. Ejecutar la app: `flutter run`
2. Revisar logs en consola
3. Buscar mensajes:
   - ✅ "Firebase inicializado con éxito"
   - ✅ "FCMTokenService inicializado"
   - ✅ "Handlers de notificaciones inicializados"

**Si hay errores**:
- Verificar que `google-services.json` existe
- Verificar que Firebase está configurado correctamente

**Tiempo**: 5 minutos

---

#### 4.2 Verificar obtención de token FCM
- [ ] **Token se obtiene al iniciar la app**
- [ ] **Token se guarda en Supabase al iniciar sesión**

**Cómo verificar**:
1. Ejecutar la app
2. Revisar logs en consola
3. Buscar mensajes:
   - ✅ "🔑 FCM TOKEN obtenido: ..."
   - ✅ "✅ Token FCM guardado en Supabase"

4. Verificar en Supabase:
   - Ir a Table Editor > `user_fcm_tokens`
   - Verificar que hay un registro con tu `user_id`

**Si no se obtiene token**:
- Verificar permisos de notificaciones
- Verificar que Firebase está configurado
- Revisar logs de error

**Tiempo**: 5 minutos

---

#### 4.3 Verificar permisos de notificaciones
- [ ] **Permisos solicitados al iniciar la app**
- [ ] **Permisos concedidos**

**Cómo verificar**:
1. Ejecutar la app
2. Verificar que se solicita permiso de notificaciones
3. Conceder permiso
4. Verificar en logs: "✅ Permisos de notificación concedidos"

**Si no se solicitan permisos**:
- Verificar que `FCMTokenService.initialize()` se llama
- Revisar código de inicialización

**Tiempo**: 2 minutos

---

### 5. Probar Envío de Notificación ⚠️ CRÍTICO

#### 5.1 Obtener token FCM del dispositivo
- [ ] **Token FCM obtenido**

**Cómo obtener**:
1. Ejecutar la app
2. Iniciar sesión
3. Revisar logs: "🔑 FCM TOKEN obtenido: ..."
4. O verificar en Supabase:
```sql
SELECT token 
FROM user_fcm_tokens 
WHERE user_id = 'TU_USER_ID'
LIMIT 1;
```

**Tiempo**: 2 minutos

---

#### 5.2 Probar envío desde Supabase Edge Function
- [ ] **Notificación enviada correctamente**
- [ ] **Notificación llega al dispositivo**

**Pasos**:
1. Ir a Supabase Dashboard > Edge Functions
2. Seleccionar `send_fcm_notification`
3. Ir a la pestaña "Invoke" o "Test"
4. Enviar payload de prueba:
```json
{
  "token": "TOKEN_FCM_DEL_DISPOSITIVO",
  "title": "Test de notificación",
  "body": "Esta es una notificación de prueba desde Supabase"
}
```

5. Verificar que:
   - ✅ La función retorna `{ "success": true }`
   - ✅ La notificación llega al dispositivo

**Si hay error**:
- Verificar variables de entorno (FIREBASE_PROJECT_ID, FIREBASE_SERVICE_ACCOUNT_KEY)
- Verificar que el token FCM es válido
- Revisar logs de la Edge Function

**Tiempo**: 5 minutos

---

#### 5.3 Verificar handlers de notificaciones
- [ ] **Notificación en foreground se muestra**
- [ ] **Notificación en background se recibe**
- [ ] **Notificación con app cerrada se recibe**

**Cómo probar**:
1. **Foreground**:
   - Mantener la app abierta
   - Enviar notificación
   - Verificar que aparece SnackBar con la notificación

2. **Background**:
   - Minimizar la app (no cerrar)
   - Enviar notificación
   - Verificar que llega la notificación en el sistema
   - Tocar la notificación
   - Verificar que la app se abre

3. **App cerrada**:
   - Cerrar completamente la app
   - Enviar notificación
   - Verificar que llega la notificación
   - Tocar la notificación
   - Verificar que la app se abre

**Tiempo**: 10 minutos

---

## 🐛 Problemas Comunes y Soluciones

### Problema 1: "Firebase credentials not configured"
**Causa**: Variables de entorno no configuradas en Supabase

**Solución**:
1. Ir a Supabase Dashboard > Project Settings > Edge Functions > Secrets
2. Añadir `FIREBASE_PROJECT_ID` y `FIREBASE_SERVICE_ACCOUNT_KEY`
3. Verificar que el JSON del Service Account está como string completo

---

### Problema 2: "Token FCM no se obtiene"
**Causa**: Firebase no configurado o permisos no concedidos

**Soluciones**:
1. Verificar que `google-services.json` existe
2. Verificar que Firebase está inicializado
3. Verificar que se concedieron permisos de notificaciones
4. Revisar logs de error en consola

---

### Problema 3: "Notificación no llega"
**Causas posibles**:
1. Token FCM no válido
2. Variables de entorno incorrectas
3. Firebase no configurado correctamente
4. Permisos de notificaciones no concedidos

**Soluciones**:
1. Verificar que el token FCM es válido (obtener uno nuevo)
2. Verificar variables de entorno en Supabase
3. Verificar configuración de Firebase
4. Verificar permisos en la app

---

### Problema 4: "Edge Function no está desplegada"
**Solución**:
```bash
# Desde la raíz del proyecto
supabase functions deploy send_fcm_notification
```

O desplegar manualmente desde Supabase Dashboard.

---

### Problema 5: "Tabla user_fcm_tokens no existe"
**Solución**:
Ejecutar migración en Supabase SQL Editor:
```sql
-- Ejecutar docs/migrations/003_create_fcm_tokens_table.sql
```

---

## ✅ Resultado Esperado

Después de completar todas las verificaciones:

- ✅ Firebase configurado correctamente
- ✅ Edge Function desplegada
- ✅ Variables de entorno configuradas
- ✅ Tabla de tokens existe y tiene datos
- ✅ Token FCM se obtiene y guarda
- ✅ Notificaciones se envían y reciben correctamente
- ✅ Handlers funcionan en todos los estados (foreground, background, cerrada)

---

## 📝 Notas Importantes

1. **Notificaciones son opcionales**: El sistema funcionará sin ellas, solo no enviará notificaciones automáticas.

2. **Variables de entorno**: Si no se configuran ahora, se puede hacer después del lanzamiento.

3. **Testing**: Se puede probar con un dispositivo físico o emulador con Google Play Services.

4. **Service Account**: El JSON del Service Account debe estar como string completo en el secret, no como objeto JSON.

---

## 🎯 Orden Recomendado de Verificación

1. **Configuración de Firebase** (7 minutos)
   - Verificar `google-services.json`
   - Verificar FCM habilitado

2. **Base de Datos** (5 minutos)
   - Verificar tabla existe
   - Verificar RLS y políticas

3. **Edge Function** (13 minutos)
   - Verificar función desplegada
   - Verificar variables de entorno

4. **Funcionalidad en App** (12 minutos)
   - Verificar inicialización
   - Verificar obtención de token
   - Verificar permisos

5. **Probar Envío** (17 minutos)
   - Obtener token
   - Probar envío
   - Verificar handlers

**Tiempo total**: ~54 minutos (puede variar según problemas encontrados)

---

## 📞 Siguiente Paso

Después de completar todas las verificaciones:

1. Si todo funciona: ✅ Marcar como completado en el roadmap
2. Si hay problemas: Anotar los problemas y buscar soluciones
3. Si falta configuración: Configurar lo que falta y volver a probar

---

**Última actualización**: Enero 2025  
**Próxima revisión**: Después de completar verificaciones

