# Análisis del Roadmap - Tareas Pendientes

## 1. 📱 Revisar Perfil de Usuario (No Admin)

### Estado Actual
El perfil de usuario (`lib/ui/auth/profile_screen.dart`) incluye:
- ✅ Avatar y email
- ✅ Indicador de email verificado/no verificado
- ✅ Panel de administración (solo para admins)
- ✅ Mis favoritos (pero el route `/favorites` puede no estar configurado)
- ✅ ID de usuario
- ✅ Cerrar sesión

### Funcionalidades Faltantes Identificadas

1. **Pantalla de Favoritos**
   - Existe `lib/ui/events/favorites_screen.dart` 
   - Pero el route `/favorites` puede no estar configurado en el router principal
   - Necesita verificación y posible corrección del routing

2. **Mis Eventos Creados**
   - Los usuarios no pueden ver los eventos que han creado
   - Necesitamos:
     - Tabla `user_events` o campo `created_by` en la tabla `events`
     - Pantalla para mostrar eventos del usuario
     - Opciones para editar/eliminar sus propios eventos

3. **Configuración del Usuario**
   - Preferencias de notificaciones
   - Configuración de privacidad
   - Cambiar contraseña (si usan email/password)

4. **Mejoras Visuales**
   - Avatar personalizado (si tienen foto de Google)
   - Nombre de usuario/display name
   - Estadísticas básicas (eventos guardados, eventos creados)

### Acciones Recomendadas
- [ ] Verificar y corregir route `/favorites`
- [ ] Añadir pantalla "Mis Eventos Creados"
- [ ] Añadir link a configuración de notificaciones
- [ ] Mostrar avatar de Google si está disponible
- [ ] Añadir display name del usuario

---

## 2. 🗺️ Reparar Google Maps

### Estado Actual
Google Maps se usa en:
- `lib/ui/event/event_detail_screen.dart` - Muestra mapa del evento
- `lib/ui/events/event_submit_screen.dart` - Seleccionar ubicación al crear evento
- `lib/ui/admin/admin_event_edit_screen.dart` - Editar ubicación de evento

### Posibles Problemas

1. **API Key de Google Maps**
   - La key está en `AndroidManifest.xml`: `AIzaSyBlGvnFjcZ2NMNBgIt4ylNIo5W8TeBtyuI`
   - Puede estar mal configurada o sin restricciones correctas
   - Puede estar expirada o sin permisos para Android

2. **Configuración de Permisos**
   - Los permisos de ubicación están en AndroidManifest.xml
   - Pero puede faltar la configuración en iOS

3. **Inicialización del Mapa**
   - Los mapas pueden no estar inicializándose correctamente
   - Puede haber errores de configuración en `GoogleMapController`

### Acciones Recomendadas
- [ ] Verificar que la API Key de Google Maps esté activa
- [ ] Revisar logs de errores cuando se intenta mostrar el mapa
- [ ] Verificar permisos de ubicación en runtime
- [ ] Añadir manejo de errores más robusto
- [ ] Verificar configuración en iOS (si aplica)

---

## 3. 🔔 Comprobar Funcionamiento de Notificaciones

### Estado Actual
- ✅ Firebase Messaging está instalado (`firebase_messaging: ^15.1.3`)
- ✅ Firebase Core está inicializado en `main.dart`
- ✅ Función `_initializeFCMToken()` obtiene el token FCM
- ✅ Se solicitan permisos de notificación
- ✅ Se loggea el token en consola

### Funcionalidades Faltantes

1. **Handlers de Notificaciones**
   - No hay handlers para notificaciones cuando la app está en:
     - Foreground (abierta)
     - Background (minimizada)
     - Terminada (cerrada)

2. **Almacenamiento del Token**
   - El token FCM no se guarda en Supabase
   - No hay forma de enviar notificaciones a usuarios específicos

3. **Integración con Backend**
   - No hay endpoint/trigger en Supabase para enviar notificaciones
   - No hay tabla para guardar tokens FCM

4. **Pruebas**
   - No hay forma de probar las notificaciones
   - No hay documentación sobre cómo enviar notificaciones de prueba

### Acciones Recomendadas
- [ ] Implementar handlers para notificaciones en foreground/background/terminated
- [ ] Crear tabla `user_fcm_tokens` en Supabase
- [ ] Guardar token FCM cuando el usuario inicia sesión
- [ ] Crear función para enviar notificaciones de prueba
- [ ] Documentar cómo probar las notificaciones

---

## 4. 📸 Subir Fotos de Categorías a Supabase Storage

### Estado Actual
- Las categorías tienen campos `icon` y `color` en la tabla
- Los eventos pueden tener `image_url` pero no hay selección de imágenes predefinidas
- No hay bucket de Supabase Storage configurado para categorías

### Requisitos

1. **Supabase Storage**
   - Crear bucket `category-images` (o similar) en Supabase Storage
   - Subir fotos para cada categoría de Cádiz
   - Organizar por categoría: `categoria-tradicion/`, `categoria-motor/`, etc.

2. **Modificar Pantalla de Creación de Eventos**
   - Cuando el usuario no tiene foto al crear evento
   - Mostrar opción "Seleccionar foto de categoría"
   - Mostrar galería de imágenes disponibles para la categoría seleccionada
   - Permitir seleccionar una de las imágenes predefinidas

3. **Gestión de Imágenes**
   - Tabla o vista para listar imágenes disponibles por categoría
   - API/service para obtener URLs de imágenes de categorías
   - Caché local de URLs de imágenes

### Acciones Recomendadas
- [ ] Crear bucket en Supabase Storage para imágenes de categorías
- [ ] Crear estructura de carpetas: `category-images/cadiz/{categoria}/`
- [ ] Subir imágenes para cada categoría (solo Cádiz por ahora)
- [ ] Crear servicio para obtener imágenes de categorías
- [ ] Modificar `EventSubmitScreen` para mostrar selector de imágenes
- [ ] Añadir opción "Usar foto de categoría" cuando no hay imagen

---

## 📋 Priorización Sugerida

1. **Alta Prioridad:**
   - Reparar Google Maps (afecta experiencia de usuario)
   - Verificar y corregir route de favoritos (funcionalidad rota)

2. **Media Prioridad:**
   - Completar sistema de notificaciones (funcionalidad parcial)
   - Añadir "Mis Eventos Creados" al perfil

3. **Baja Prioridad:**
   - Subir fotos de categorías (nueva funcionalidad)
   - Mejoras visuales del perfil

---

## 🔧 Próximos Pasos

1. Empezar con Google Maps - diagnosticar el problema específico
2. Corregir route de favoritos
3. Implementar handlers de notificaciones
4. Crear sistema de imágenes de categorías

