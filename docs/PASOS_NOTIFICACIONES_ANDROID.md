# 🚀 Configuración de Notificaciones Push - Android (Ubuntu/PC)

**Enfoque:** Solo Android por ahora. iOS se configurará más tarde en Mac.

---

## ✅ PASO 1: Verificaciones Iniciales (Ya completado)

### 1.1 Archivo google-services.json ✅
- ✅ **Verificado:** El archivo existe en `android/app/google-services.json`
- ✅ **Gitignore:** Correctamente excluido de Git (línea 34 de .gitignore)

### 1.2 Permiso POST_NOTIFICATIONS ✅
- ✅ **Añadido:** Permiso `POST_NOTIFICATIONS` en `AndroidManifest.xml`
- ✅ **Ubicación:** `android/app/src/main/AndroidManifest.xml`
- ✅ **Necesario para:** Android 13+ (API 33+)

### 1.3 Plugin Google Services ✅
- ✅ **Verificado:** Plugin `com.google.gms.google-services` aplicado en `build.gradle.kts`

---

## ✅ PASO 2: Verificar Código Flutter (Ya completado)

### 2.1 Dependencias ✅
- ✅ `firebase_core: ^3.6.0` - Instalado
- ✅ `firebase_messaging: ^15.1.3` - Instalado

### 2.2 Inicialización ✅
- ✅ Firebase inicializado en `main.dart`
- ✅ `FCMTokenService` implementado
- ✅ `NotificationHandler` implementado
- ✅ Background handler configurado

---

## 🔧 PASO 3: Configurar Supabase Edge Function (15 minutos)

### 3.1 Obtener Firebase Service Account

1. Ir a [Firebase Console](https://console.firebase.google.com/)
2. Seleccionar tu proyecto
3. Ir a ⚙️ **Configuración del proyecto** → Pestaña **Cuentas de servicio**
4. Click en **"Generar nueva clave privada"**
5. Se descargará un archivo JSON (ej: `fiestapp-firebase-adminsdk-xxxxx.json`)
6. **⚠️ IMPORTANTE:** Guardar este archivo de forma segura (contiene credenciales sensibles)

---

### 3.2 Obtener Firebase Project ID

1. En Firebase Console, ir a ⚙️ **Configuración del proyecto**
2. En la pestaña **General**, encontrar:
   - **ID del proyecto** (ej: `fiestapp-12345`)
   - Copiar este ID

---

### 3.3 Configurar Secrets en Supabase

**Opción A: Desde Supabase Dashboard (Recomendado)**

1. Ir a [Supabase Dashboard](https://app.supabase.com/)
2. Seleccionar tu proyecto
3. Ir a **Edge Functions** → Buscar **`send_fcm_notification`**
4. Click en **"Settings"** o **"Secrets"** (depende de la versión del dashboard)
5. Añadir dos secrets:

**Secret 1:**
- **Nombre:** `FIREBASE_PROJECT_ID`
- **Valor:** El ID del proyecto que copiaste (ej: `fiestapp-12345`)

**Secret 2:**
- **Nombre:** `FIREBASE_SERVICE_ACCOUNT_KEY`
- **Valor:** El contenido COMPLETO del archivo JSON descargado
  - Abrir el archivo JSON con un editor de texto
  - Copiar TODO el contenido (desde `{` hasta `}`)
  - Pegarlo como valor del secret
  - ⚠️ Debe ser un JSON válido

**Opción B: Desde CLI de Supabase**

```bash
# Instalar Supabase CLI si no lo tienes
npm install -g supabase

# Login
supabase login

# Obtener tu project ref (está en la URL del dashboard: app.supabase.com/project/[PROJECT_REF])
# Configurar secrets
supabase secrets set FIREBASE_PROJECT_ID=tu-project-id --project-ref tu-project-ref

# Para el Service Account Key, necesitas el JSON completo en una línea
supabase secrets set FIREBASE_SERVICE_ACCOUNT_KEY='{"type":"service_account",...}' --project-ref tu-project-ref
```

---

## ✅ PASO 4: Probar la Configuración (10 minutos)

### 4.1 Limpiar y Recompilar

```bash
# Desde la raíz del proyecto
flutter clean
flutter pub get
```

### 4.2 Ejecutar en Android

```bash
# Conecta un dispositivo Android físico o inicia un emulador
flutter run
```

**⚠️ IMPORTANTE:** Para notificaciones push, es mejor usar un **dispositivo físico**. Los emuladores pueden tener problemas con FCM.

### 4.3 Verificar Logs

Busca en los logs de Flutter estos mensajes:

**✅ Mensajes de éxito:**
```
✅ Firebase inicializado con éxito
✅ FCMTokenService inicializado
✅ NotificationHandler inicializado
✅ Permisos de notificación concedidos
🔑 FCM TOKEN obtenido: [token]...
✅ Token FCM guardado en Supabase
```

**⚠️ Si ves errores:**
- `Firebase no está inicializado` → Verificar que `google-services.json` esté en `android/app/`
- `Permisos de notificación denegados` → El usuario debe conceder permisos manualmente
- `Token FCM no disponible` → Normal en la primera ejecución, se obtendrá automáticamente

---

## 🧪 PASO 5: Probar Envío de Notificación (Opcional)

### 5.1 Obtener Token FCM

1. Ejecutar la app en Android
2. En los logs, buscar: `🔑 FCM TOKEN obtenido: [token]`
3. Copiar el token completo

### 5.2 Enviar Notificación desde Firebase Console

1. Ir a [Firebase Console](https://console.firebase.google.com/)
2. Seleccionar tu proyecto
3. Ir a **Cloud Messaging** (en el menú lateral)
4. Click en **"Enviar tu primer mensaje"** o **"Nuevo mensaje"**
5. Completar:
   - **Título:** "Prueba de notificación"
   - **Texto:** "Esta es una notificación de prueba"
6. Click en **"Siguiente"**
7. En **"Destinatarios"**, seleccionar **"Token FCM"**
8. Pegar el token que copiaste
9. Click en **"Probar"** o **"Enviar"**

**Si recibes la notificación:** ✅ **¡Todo funciona correctamente!**

---

## 📋 Checklist de Verificación Android

- [x] ✅ `google-services.json` existe en `android/app/`
- [x] ✅ Permiso `POST_NOTIFICATIONS` en `AndroidManifest.xml`
- [x] ✅ Plugin `com.google.gms.google-services` aplicado
- [x] ✅ Dependencias instaladas (`firebase_core`, `firebase_messaging`)
- [x] ✅ Firebase inicializado en código
- [x] ✅ FCM Token Service implementado
- [x] ✅ Notification Handler implementado
- [ ] ⚠️ **PENDIENTE:** Configurar secrets en Supabase Edge Function
- [ ] ⚠️ **PENDIENTE:** Probar compilación y ejecución
- [ ] ⚠️ **PENDIENTE:** Probar envío de notificación

---

## 🎯 Próximo Paso

**Ahora debes configurar los secrets en Supabase (PASO 3).**

¿Tienes acceso a:
1. ✅ Firebase Console (para obtener Service Account)
2. ✅ Supabase Dashboard (para configurar secrets)

Si tienes acceso, continúa con el **PASO 3**. Si necesitas ayuda con algún paso específico, dímelo.
