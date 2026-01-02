# 🚀 Roadmap de Verificación Pre-Lanzamiento - QuePlan

**Fecha de creación**: Enero 2025  
**Última actualización**: Enero 2025  
**Estado**: En progreso

Este documento contiene el roadmap completo de todas las verificaciones y tareas necesarias antes del lanzamiento de la app.

**⚠️ IMPORTANTE**: 
- Las notificaciones push y la publicación en App Store/Play Store se han deferido para después de la publicación. Ver `docs/TAREAS_DESPUES_PUBLICACION.md` para más detalles.
- **Signing para release**: ⚠️ CRÍTICO antes de publicar en Play Store. Ver `docs/GUIA_SIGNING_RELEASE.md` para instrucciones completas.

---

## 📊 Resumen Ejecutivo

### Estado General
- **Funcionalidades Core**: 90% ✅
- **Seguridad**: 98% ✅ (pendiente verificar restricciones API Keys y funciones ownership)
- **Legal/RGPD**: 100% ✅ **COMPLETADO** (DNS, SSL, URLs legales, documentos personalizados, funcionalidades probadas)
- **Autenticación**: 100% ✅ **COMPLETADO**
- **Código**: 98% ✅ (correcciones aplicadas: print() → debugPrint())
- **Testing**: 40% 🟡 (pendiente testing completo)
- **Configuración**: 90% ✅ (autenticación completada)
- **Build/Publicación**: 0% ⚠️ (signing pendiente antes de publicar)

### Tiempo Estimado Total
- **Crítico**: 3-4 horas
- **Importante**: 2-3 horas
- **Recomendado**: 2-3 horas
- **Total**: 7-10 horas

---

## 🔴 CRÍTICO - Hacer ANTES del lanzamiento

### 1. Seguridad de Base de Datos ⚠️

#### 1.1 Migraciones SQL
- [x] **Migración 007_fix_security_issues.sql** ✅ **COMPLETADO**
  - Habilita RLS en todas las tablas
  - Añade políticas de seguridad
  - **Archivo**: `docs/migrations/007_fix_security_issues.sql`
  - **Estado**: ✅ Ejecutada y verificada

- [x] **Migración 008_add_legal_functions.sql** ✅ **COMPLETADO**
  - Funcionalidades legales (RGPD)
  - Exportación de datos
  - Eliminación de cuenta
  - **Archivo**: `docs/migrations/008_add_legal_functions.sql`
  - **Estado**: ✅ Ejecutada y verificada

- [x] **Migración 011_create_venue_ownership_system.sql** ✅ **COMPLETADO**
  - Sistema de ownership de venues
  - Tabla `venue_ownership_requests`
  - Funciones de verificación
  - **Archivo**: `docs/migrations/011_create_venue_ownership_system.sql`
  - **Estado**: ✅ Ejecutada y verificada

- [x] **Migración 012_add_user_verification_function.sql** ✅ **COMPLETADO**
  - Función para que usuarios verifiquen su propio código
  - **Archivo**: `docs/migrations/012_add_user_verification_function.sql`
  - **Estado**: ✅ Ejecutada

#### 1.2 Verificación de Seguridad
- [x] **Verificar Security Advisor en Supabase** ✅ **COMPLETADO**
  - Ejecutar script `docs/VERIFICAR_RLS.sql`
  - Verificar que todas las tablas tienen RLS habilitado
  - Verificar que todas las políticas están correctas
  - **Resultado**: ✅ Todo en verde
  - **Estado**: ✅ Verificado

- [x] **Verificar que no hay API Keys expuestas** ✅ **COMPLETADO - Enero 2025**
  - Revisar código por API Keys hardcodeadas
  - Verificar que `.env` no está en el repositorio
  - Verificar que `AndroidManifest.xml` no tiene keys sensibles
  - **Tiempo**: 15 minutos
  - **Prioridad**: 🔴 CRÍTICO
  - **Resultado**: ✅ No se encontraron API Keys hardcodeadas
  - ✅ Google Maps API Key se lee desde `local.properties` (en .gitignore)
  - ✅ Supabase keys se leen desde `.env` (en .gitignore)
  - ✅ Todos los archivos sensibles están en `.gitignore`
  - **Ver documento**: `docs/VERIFICAR_API_KEYS_SEGURIDAD.md`

- [x] **Verificar restricciones de API Keys** ✅ **COMPLETADO - Enero 2025**
  - Google Maps API Key con restricciones correctas
  - Supabase keys con restricciones correctas
  - **Tiempo**: 10 minutos
  - **Prioridad**: 🔴 CRÍTICO
  - **Estado**: ✅ Restricciones configuradas en Google Cloud Console
  - **Nota**: API Keys separadas para Android e iOS
  - **Ver guía**: `docs/VERIFICAR_API_KEYS_SEGURIDAD.md`

#### 1.3 Verificación de Funciones SQL
- [x] **Probar función de exportación de datos** ✅ **COMPLETADO - Enero 2025**
  - Ejecutar `export_user_data(user_id)`
  - Verificar que retorna todos los datos del usuario
  - **Tiempo**: 10 minutos
  - **Estado**: ✅ Verificado y funcionando correctamente

- [x] **Probar función de eliminación de cuenta** ✅ **COMPLETADO - Enero 2025**
  - Ejecutar `delete_user_account(user_id)`
  - Verificar que elimina todos los datos
  - Verificar que no rompe referencias
  - **Tiempo**: 15 minutos
  - **Estado**: ✅ Verificado y funcionando correctamente

- [ ] **Probar funciones de ownership** ⏳ **PENDIENTE - Para mañana**
  - Verificar `create_venue_ownership_request`
  - Verificar `verify_venue_ownership`
  - Verificar `verify_venue_ownership_by_user`
  - **Tiempo**: 15 minutos
  - **Estado**: ⏳ Pendiente para mañana

---

### 2. Configuración Legal y RGPD ⚠️

#### 2.1 Dominio y DNS
- [x] **Verificar propagación DNS para queplan-app.com** ✅ **COMPLETADO - Enero 2025**
  - Comprobar que el dominio resuelve correctamente
  - **Comando**: `nslookup queplan-app.com` o usar herramienta online
  - **Tiempo**: 5 minutos
  - **Prioridad**: 🔴 CRÍTICO
  - **Estado**: ✅ Verificado

- [x] **Verificar SSL activo** ✅ **COMPLETADO - Enero 2025**
  - Comprobar que `https://queplan-app.com` funciona
  - Verificar certificado SSL válido
  - **Tiempo**: 2 minutos
  - **Prioridad**: 🔴 CRÍTICO
  - **Estado**: ✅ Verificado

#### 2.2 URLs Legales
- [x] **Verificar URLs legales funcionan** ✅ **COMPLETADO - Enero 2025**
  - [x] `https://queplan-app.com/privacy` → Muestra política de privacidad
  - [x] `https://queplan-app.com/terms` → Muestra términos y condiciones
  - [x] Verificar que los documentos se cargan correctamente
  - **Tiempo**: 5 minutos
  - **Prioridad**: 🔴 CRÍTICO
  - **Estado**: ✅ Verificado

#### 2.3 Personalización de Documentos
- [x] **Personalizar Política de Privacidad** ✅ **COMPLETADO - Enero 2025**
  - Revisar `docs/legal/privacy_policy.html`
  - Añadir información de contacto real
  - Añadir información de la empresa
  - Verificar que cumple con RGPD
  - **Tiempo**: 30-45 minutos
  - **Prioridad**: 🔴 CRÍTICO
  - **Estado**: ✅ Completado

- [x] **Personalizar Términos y Condiciones** ✅ **COMPLETADO - Enero 2025**
  - Revisar `docs/legal/terms_of_service.html`
  - Añadir información de contacto real
  - Añadir información de la empresa
  - Verificar que cubre todos los casos de uso
  - **Tiempo**: 30-45 minutos
  - **Prioridad**: 🔴 CRÍTICO
  - **Estado**: ✅ Completado

#### 2.4 Funcionalidades Legales en la App
- [ ] **Probar exportación de datos**
  - Ir a Perfil → Exportar datos
  - Verificar que se descarga un archivo JSON
  - Verificar que contiene todos los datos del usuario
  - **Tiempo**: 10 minutos

- [ ] **Probar eliminación de cuenta**
  - Ir a Perfil → Eliminar cuenta
  - Confirmar eliminación
  - Verificar que se eliminan todos los datos
  - Verificar que no se puede iniciar sesión después
  - **Tiempo**: 15 minutos

- [ ] **Verificar consentimiento GDPR**
  - Verificar que aparece en registro
  - Verificar que se guarda en base de datos
  - Verificar que se puede revocar
  - **Tiempo**: 10 minutos

---

### 3. Autenticación y OAuth 🔐 ✅ **COMPLETADO**

#### 3.1 Google OAuth
- [x] **Verificar configuración de Google OAuth** ✅ **COMPLETADO - Enero 2025**
  - Verificar que las Redirect URLs están configuradas en Supabase
  - Verificar que las Redirect URLs están en Google Cloud Console
  - URLs a verificar:
    - `io.supabase.fiestapp://login-callback`
    - `io.supabase.fiestapp://auth/confirmed`
    - `io.supabase.fiestapp://reset-password`
  - **Tiempo**: 10 minutos
  - **Prioridad**: 🔴 CRÍTICO
  - **Estado**: ✅ Verificado y funcionando correctamente

- [x] **Probar login con Google** ✅ **COMPLETADO - Enero 2025**
  - Probar en Android
  - Probar en iOS (si aplica)
  - Verificar que no redirige a Gmail
  - Verificar que inicia sesión correctamente
  - **Tiempo**: 15 minutos
  - **Prioridad**: 🔴 CRÍTICO
  - **Estado**: ✅ Funcionando correctamente

- [x] **Probar flujo completo de OAuth** ✅ **COMPLETADO - Enero 2025**
  - Login → Seleccionar cuenta → Verificar que inicia sesión
  - Verificar que se guarda la sesión
  - Verificar que se puede cerrar sesión
  - **Tiempo**: 10 minutos
  - **Estado**: ✅ Funcionando correctamente

#### 3.2 Email/Password
- [x] **Probar registro con email** ✅ **COMPLETADO - Enero 2025**
  - Crear cuenta nueva
  - Verificar que se envía email de confirmación (si está habilitado)
  - Verificar que se puede iniciar sesión
  - **Tiempo**: 10 minutos
  - **Estado**: ✅ Funcionando correctamente

- [x] **Probar recuperación de contraseña** ✅ **COMPLETADO - Enero 2025**
  - Solicitar recuperación
  - Verificar que se envía email
  - Verificar que se puede resetear contraseña
  - **Tiempo**: 10 minutos
  - **Estado**: ✅ Funcionando correctamente

---

### 4. Google Maps 🗺️

#### 4.1 Configuración
- [x] **Verificar API Key de Google Maps** ✅ **COMPLETADO - Enero 2025**
  - Comprobar que la API Key está configurada correctamente
  - Verificar en `android/app/src/main/AndroidManifest.xml`
  - Verificar en `ios/Runner/Info.plist`
  - **Tiempo**: 5 minutos
  - **Prioridad**: 🔴 CRÍTICO
  - **Estado**: ✅ API Keys configuradas para Android e iOS (separadas)

- [x] **Verificar restricciones de API Key** ✅ **COMPLETADO - Enero 2025**
  - Verificar que tiene restricciones por aplicación
  - Verificar que tiene restricciones por API
  - Verificar que solo permite las APIs necesarias
  - **Tiempo**: 10 minutos
  - **Prioridad**: 🔴 CRÍTICO
  - **Estado**: ✅ Restricciones configuradas en Google Cloud Console

- [x] **Verificar permisos de ubicación** ✅ **COMPLETADO - Enero 2025**
  - Verificar en `AndroidManifest.xml`
  - Verificar en `Info.plist` (iOS)
  - Verificar que se solicitan en runtime
  - **Tiempo**: 5 minutos
  - **Estado**: ✅ Permisos configurados en ambos manifiestos

#### 4.2 Funcionalidad
- [ ] **Probar crear evento con mapa**
  - Crear evento nuevo
  - Seleccionar ubicación en mapa
  - Verificar que se guarda la ubicación
  - **Tiempo**: 10 minutos
  - **Prioridad**: 🔴 CRÍTICO

- [ ] **Probar ver mapa en detalle de evento**
  - Abrir evento
  - Verificar que se muestra el mapa
  - Verificar que el marcador está en la ubicación correcta
  - **Tiempo**: 10 minutos
  - **Prioridad**: 🔴 CRÍTICO

- [ ] **Probar en Android**
  - Verificar que los mapas cargan
  - Verificar que no hay errores en consola
  - **Tiempo**: 10 minutos

- [ ] **Probar en iOS** (si aplica)
  - Verificar que los mapas cargan
  - Verificar que no hay errores en consola
  - **Tiempo**: 10 minutos

---

### 5. Configuración de Build y Signing para Release 🔐

**📖 Ver guía completa**: `docs/GUIA_SIGNING_RELEASE.md`

#### 5.1 ¿Qué es el Signing?

El **signing** (firma digital) es el proceso de firmar tu aplicación Android con un certificado digital antes de publicarla en Google Play Store. Es como una "firma" que identifica que la app es realmente tuya y no ha sido modificada.

**¿Por qué es necesario?**
- ✅ Google Play Store **requiere** que todas las apps estén firmadas
- ✅ Identifica que la app es tuya
- ✅ Permite actualizar la app en el futuro (debe usar la misma firma)
- ✅ Protege contra modificaciones no autorizadas

**⚠️ CRÍTICO**: Si pierdes el keystore, NO podrás actualizar tu app en Play Store. ¡Guárdalo de forma segura!

#### 5.2 Configurar Signing para Release
- [ ] **Crear keystore**
  - Ejecutar comando: `keytool -genkey -v -keystore ~/upload-keystore.jks -keyalg RSA -keysize 2048 -validity 10000 -alias upload`
  - Guardar contraseñas de forma segura
  - **Tiempo**: 5 minutos
  - **Prioridad**: 🔴 CRÍTICO (antes de publicar)
  - **Ver guía**: `docs/GUIA_SIGNING_RELEASE.md`

- [ ] **Crear archivo key.properties**
  - Crear `android/key.properties` con credenciales
  - Añadir a `.gitignore`
  - **Tiempo**: 5 minutos
  - **Prioridad**: 🔴 CRÍTICO

- [ ] **Actualizar build.gradle.kts**
  - Añadir configuración de signing
  - Cambiar de debug a release signing
  - **Tiempo**: 10 minutos
  - **Prioridad**: 🔴 CRÍTICO
  - **Ver guía**: `docs/GUIA_SIGNING_RELEASE.md`

- [ ] **Verificar build de release**
  - Ejecutar `flutter build appbundle --release`
  - Verificar que se genera correctamente
  - **Tiempo**: 5 minutos
  - **Prioridad**: 🔴 CRÍTICO

- [ ] **Hacer backup del keystore**
  - Copiar keystore a lugar seguro
  - Guardar contraseñas en gestor de contraseñas
  - **Tiempo**: 5 minutos
  - **Prioridad**: 🔴 CRÍTICO

**Tiempo total**: 30 minutos  
**Estado**: ⏳ Pendiente (hacer antes de publicar en Play Store)

---

### 6. Notificaciones Push 📱 ⏸️ **DEFERIDO - Después de publicación**

**📖 Ver guía completa**: `docs/GUIA_VERIFICACION_NOTIFICACIONES.md`

**⚠️ DECISIÓN**: Las notificaciones push y la configuración relacionada se dejarán para después de la publicación de la app en App Store y Play Store. El sistema funcionará correctamente sin ellas (solo no enviará notificaciones automáticas).

**Razón**: Enfocarse primero en que la app funcione correctamente antes de preocuparse por funcionalidades opcionales como notificaciones push.

#### 5.1 Configuración Firebase ⏸️ DEFERIDO
- [ ] **Verificar Firebase configurado** ⏸️
  - Verificar que `google-services.json` está en `android/app/`
  - Verificar que `GoogleService-Info.plist` está en `ios/Runner/` (si aplica)
  - Verificar que Firebase está inicializado en `main.dart`
  - Verificar que FCM está habilitado en Firebase Console
  - **Tiempo**: 7 minutos
  - **Estado**: ⏸️ Dejar para después de publicación

- [ ] **Verificar Edge Function desplegada** ⏸️
  - Comprobar que `send_fcm_notification` está desplegada en Supabase
  - Verificar en Supabase Dashboard → Edge Functions
  - **Tiempo**: 3 minutos
  - **Estado**: ⏸️ Dejar para después de publicación

- [ ] **Verificar Variables de Entorno (Secrets)** ⏸️
  - Verificar `FIREBASE_PROJECT_ID` configurado
  - Verificar `FIREBASE_SERVICE_ACCOUNT_KEY` configurado
  - **Tiempo**: 10 minutos
  - **Estado**: ⏸️ Dejar para después de publicación

- [ ] **Verificar tabla user_fcm_tokens** ⏸️
  - Verificar que la tabla existe
  - Verificar que tiene los campos correctos
  - Verificar que tiene RLS habilitado
  - Verificar que hay tokens guardados (si hay usuarios)
  - **Tiempo**: 5 minutos
  - **Estado**: ⏸️ Ya está creada, solo falta verificar funcionamiento

#### 5.2 Funcionalidad ⏸️ DEFERIDO
- [ ] **Probar obtención de token FCM** ⏸️
  - Iniciar sesión
  - Verificar que se obtiene el token
  - Verificar que se guarda en Supabase
  - Verificar permisos de notificaciones
  - **Tiempo**: 12 minutos
  - **Estado**: ⏸️ Dejar para después de publicación

- [ ] **Probar envío de notificaciones** ⏸️
  - Obtener token FCM del dispositivo
  - Enviar notificación de prueba desde Supabase Edge Function
  - Verificar que llega al dispositivo
  - Verificar que se muestra correctamente
  - **Tiempo**: 17 minutos
  - **Estado**: ⏸️ Dejar para después de publicación

- [ ] **Probar handlers de notificaciones** ⏸️
  - Probar cuando app está en foreground
  - Probar cuando app está en background
  - Probar cuando app está cerrada
  - **Tiempo**: 10 minutos
  - **Estado**: ⏸️ Dejar para después de publicación

---

### 6. Testing Funcionalidades Core 🧪

#### 6.1 Sistema de Ownership
- [ ] **Test 1: Solicitar propiedad de venue**
  - Usuario normal solicita propiedad
  - Verificar que se crea la solicitud
  - Verificar que aparece notificación para admin
  - **Tiempo**: 10 minutos
  - **Ver documento**: `docs/TESTING_SISTEMA_OWNERSHIP.md`

- [ ] **Test 2: Ver solicitud como admin**
  - Admin ve solicitudes pendientes
  - Verificar que se muestra el código de verificación
  - **Tiempo**: 5 minutos

- [ ] **Test 3: Verificar ownership (admin)**
  - Admin verifica ownership con código
  - Verificar que se asigna el ownership
  - **Tiempo**: 5 minutos

- [ ] **Test 4: Verificar ownership (usuario)**
  - Usuario ingresa código de verificación
  - Verificar que se verifica correctamente
  - **Tiempo**: 5 minutos

- [ ] **Test 5: Ver locales propios**
  - Dueño ve sus locales
  - Verificar que se listan correctamente
  - **Tiempo**: 5 minutos

- [ ] **Test 6: Aprobar/rechazar eventos**
  - Dueño aprueba evento
  - Dueño rechaza evento
  - Verificar que funciona correctamente
  - **Tiempo**: 10 minutos

#### 6.2 Creación y Gestión de Eventos
- [ ] **Probar flujo completo de creación de evento**
  - Crear cuenta
  - Iniciar sesión
  - Crear evento
  - Subir imagen
  - Seleccionar ubicación
  - Verificar que aparece en dashboard
  - **Tiempo**: 15 minutos
  - **Prioridad**: 🔴 CRÍTICO

- [ ] **Probar aprobación de eventos**
  - Admin aprueba evento pendiente
  - Verificar que aparece en dashboard
  - Verificar que se puede ver el detalle
  - **Tiempo**: 10 minutos

- [ ] **Probar rechazo de eventos**
  - Admin rechaza evento
  - Verificar que no aparece en dashboard
  - Verificar que el creador puede ver el estado
  - **Tiempo**: 10 minutos

- [ ] **Probar "Mis Eventos Creados"**
  - Usuario crea evento
  - Verificar que aparece en "Mis Eventos Creados"
  - Verificar que muestra el estado correcto
  - **Tiempo**: 10 minutos

#### 6.3 Sistema de Venues
- [ ] **Probar creación de venue**
  - Crear venue nuevo
  - Verificar que aparece pendiente de aprobación
  - **Tiempo**: 10 minutos

- [ ] **Probar aprobación de venue**
  - Admin aprueba venue
  - Verificar que aparece en búsqueda
  - **Tiempo**: 5 minutos

- [ ] **Probar búsqueda de venues**
  - Buscar venue existente
  - Verificar que aparece en resultados
  - **Tiempo**: 5 minutos

#### 6.4 Favoritos
- [ ] **Probar agregar a favoritos**
  - Agregar evento a favoritos
  - Verificar que aparece en lista de favoritos
  - **Tiempo**: 5 minutos

- [ ] **Probar eliminar de favoritos**
  - Eliminar evento de favoritos
  - Verificar que desaparece de la lista
  - **Tiempo**: 5 minutos

- [ ] **Probar sincronización de favoritos**
  - Agregar favorito sin sesión
  - Iniciar sesión
  - Verificar que se sincronizan
  - **Tiempo**: 10 minutos

---

## 🟡 IMPORTANTE - Hacer pronto después del lanzamiento

**📖 Ver documento completo**: `docs/TAREAS_DESPUES_PUBLICACION.md`

**⚠️ NOTA**: Las notificaciones push y la publicación en tiendas se han deferido para después de la publicación. Enfocarse primero en que la app funcione correctamente.

### 7. Optimizaciones y Performance ⚡

#### 7.1 Base de Datos
- [ ] **Optimizar consultas de eventos**
  - Revisar índices en base de datos
  - Identificar queries lentas
  - Añadir índices si es necesario
  - **Tiempo**: 1-2 horas

- [ ] **Verificar rendimiento de consultas**
  - Probar consultas con muchos datos
  - Verificar tiempos de respuesta
  - **Tiempo**: 30 minutos

#### 7.2 Carga de Imágenes
- [ ] **Optimizar carga de imágenes**
  - Implementar caché de imágenes
  - Comprimir imágenes al subir
  - Verificar que las imágenes se cargan correctamente
  - **Tiempo**: 1-2 horas

#### 7.3 UI/UX
- [ ] **Mejorar manejo de errores**
  - Mensajes de error más amigables
  - Mejor feedback visual
  - **Tiempo**: 2-3 horas

- [ ] **Añadir loading states**
  - Indicadores de carga en todas las operaciones
  - Skeleton loaders donde sea apropiado
  - **Tiempo**: 1-2 horas

---

### 8. Documentación 📚

#### 8.1 Documentación Técnica
- [ ] **Actualizar README.md**
  - Añadir instrucciones de instalación
  - Añadir configuración necesaria
  - Añadir requisitos del sistema
  - **Tiempo**: 30 minutos

- [ ] **Documentar sistema de ownership**
  - Verificar que `docs/venue_ownership_system.md` está completo
  - Añadir diagramas de flujo si es necesario
  - **Tiempo**: 15 minutos

- [ ] **Documentar configuración de APIs**
  - Documentar cómo configurar Google Maps
  - Documentar cómo configurar Firebase
  - Documentar cómo configurar Supabase
  - **Tiempo**: 30 minutos

#### 8.2 Documentación de Usuario
- [ ] **Crear guía de usuario básica**
  - Cómo crear eventos
  - Cómo reclamar venues
  - Cómo usar favoritos
  - **Tiempo**: 1 hora

---

## 🟢 RECOMENDADO - Mejoras futuras

### 9. Funcionalidades Adicionales

#### 9.1 Perfil de Usuario
- [ ] **Mejorar perfil de usuario**
  - Mostrar avatar de Google (si disponible)
  - Añadir display name editable
  - Añadir estadísticas básicas
  - **Tiempo**: 2-3 horas

#### 9.2 Sistema de Imágenes de Categorías
- [ ] **Implementar imágenes de categorías**
  - Crear bucket en Supabase Storage
  - Subir imágenes predefinidas
  - Modificar pantalla de creación para usar imágenes
  - **Tiempo**: 3-4 horas

#### 9.3 Mejoras en Búsqueda
- [ ] **Optimizar búsqueda de eventos**
  - Añadir filtros avanzados
  - Mejorar autocompletado
  - Guardar búsquedas recientes
  - **Tiempo**: 2-3 horas

---

## 📋 Checklist Final Pre-Lanzamiento

Antes de considerar la app lista para lanzar, verificar:

### Seguridad
- [x] Todas las migraciones SQL ejecutadas (007, 008, 011, 012) ✅
- [x] Security Advisor sin errores ✅
- [x] No hay API Keys expuestas ✅ **COMPLETADO**
- [x] Restricciones de API Keys configuradas ✅ **COMPLETADO - Enero 2025**
  - Google Maps API Keys separadas para Android e iOS
  - Restricciones configuradas en Google Cloud Console

### Legal/RGPD
- [x] URLs legales funcionando ✅ **COMPLETADO - Enero 2025**
- [x] DNS y SSL verificados ✅ **COMPLETADO - Enero 2025**
- [x] Documentos legales personalizados ✅ **COMPLETADO**
- [x] Funcionalidades legales probadas (exportación, eliminación) ✅ **COMPLETADO**

### Autenticación
- [x] Google OAuth funcionando correctamente ✅ **COMPLETADO**
- [x] Email/Password funcionando ✅ **COMPLETADO**
- [x] Recuperación de contraseña funcionando ✅ **COMPLETADO**

### Funcionalidades Core
- [ ] Google Maps funcionando (pendiente probar funcionalidad)
- [ ] Notificaciones push funcionando ⏸️ **DEFERIDO - Después de publicación**
- [ ] Sistema de ownership probado completamente
- [ ] Creación de eventos funcionando
- [ ] Favoritos funcionando

### Build y Publicación
- [ ] Configurar signing para release (antes de publicar en Play Store) ⚠️ **CRÍTICO**
  - **Ver guía**: `docs/GUIA_SIGNING_RELEASE.md`

### Testing
- [ ] Testing básico completado
- [ ] Testing de ownership completado
- [ ] Testing de funcionalidades legales completado

---

## 🎯 Orden de Ejecución Recomendado

### Día 1: Seguridad y Legal (3-4 horas)
1. ✅ Verificar migraciones SQL ejecutadas
2. ✅ Verificar Security Advisor
3. ✅ Verificar configuración legal/DNS **COMPLETADO**
4. ✅ Personalizar documentos legales **COMPLETADO**
5. ✅ Probar funcionalidades legales **COMPLETADO**

### Día 2: Autenticación y APIs (2-3 horas)
1. Verificar Google OAuth
2. Verificar Google Maps
3. Verificar notificaciones push
4. Probar todos los flujos de autenticación

### Día 3: Testing Completo (2-3 horas)
1. Testing completo de funcionalidades
2. Testing de sistema de ownership
3. Testing de creación de eventos
4. Testing de favoritos

### Día 4: Ajustes Finales y Preparación para Publicación (2-3 horas)
1. Optimizaciones menores
2. Ajustes de UX
3. Verificación final
4. ⚠️ **Configurar signing para release** (CRÍTICO antes de publicar)
   - Ver guía: `docs/GUIA_SIGNING_RELEASE.md`
5. Preparación para lanzamiento

---

## 📝 Notas Importantes

### ⚠️ Advertencias Críticas

1. **NO LANZAR sin ejecutar las migraciones SQL**
   - La app tendrá vulnerabilidades de seguridad
   - Funcionalidades no funcionarán correctamente

2. **Verificar Security Advisor después de migraciones**
   - Asegura que no hay problemas de seguridad
   - Toma solo 5 minutos

3. ✅ **Personalizar documentos legales** **COMPLETADO**
   - Requerido para cumplimiento legal
   - Añadir información de contacto real

4. **⚠️ Configurar Signing para Release (CRÍTICO antes de publicar)**
   - **NO puedes publicar en Play Store sin signing configurado**
   - Si pierdes el keystore, NO podrás actualizar tu app
   - **Ver guía completa**: `docs/GUIA_SIGNING_RELEASE.md`
   - **Tiempo**: 30 minutos
   - **Cuándo hacerlo**: Justo antes de publicar en Play Store

5. **Probar Google OAuth completamente**
   - El problema de redirección a Gmail debe estar resuelto
   - Probar en múltiples dispositivos

### 📊 Métricas de Éxito

- **Seguridad**: 100% de migraciones ejecutadas, Security Advisor sin errores
- **Legal**: URLs funcionando, documentos personalizados
- **Funcionalidades**: Todas las funcionalidades core probadas y funcionando
- **Testing**: Al menos 80% de los tests pasando

---

## 🔄 Actualización de este Documento

Este documento debe actualizarse conforme se completan las tareas:

1. Marcar tareas completadas con ✅
2. Añadir fecha de completación
3. Añadir notas sobre problemas encontrados
4. Actualizar estado general del proyecto

---

**Última actualización**: Enero 2025  
**Próxima revisión**: Después de completar tareas críticas

