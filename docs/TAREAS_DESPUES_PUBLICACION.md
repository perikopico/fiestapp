# 📱 Tareas Después de la Publicación - QuePlan

**Fecha**: Enero 2025  
**Estado**: Pendiente - Después de publicación en App Store y Play Store

Este documento contiene todas las tareas que se dejarán para después de que la app esté publicada en las tiendas.

---

## 🎯 Objetivo

Enfocarse primero en que la app funcione correctamente antes de preocuparse por funcionalidades opcionales o mejoras que no son críticas para el lanzamiento inicial.

---

## 📋 Tareas Deferidas

### 1. Notificaciones Push 📱

**Estado**: ⏸️ Deferido - Después de publicación

**Razón**: Las notificaciones push son opcionales. El sistema funcionará correctamente sin ellas (solo no enviará notificaciones automáticas).

#### Tareas Pendientes:

- [ ] **Verificar Firebase configurado**
  - Verificar que `google-services.json` está en `android/app/`
  - Verificar que `GoogleService-Info.plist` está en `ios/Runner/` (si aplica)
  - Verificar que FCM está habilitado en Firebase Console
  - **Guía**: `docs/GUIA_VERIFICACION_NOTIFICACIONES.md`

- [ ] **Verificar Edge Function desplegada**
  - Comprobar que `send_fcm_notification` está desplegada en Supabase
  - Verificar variables de entorno (FIREBASE_PROJECT_ID, FIREBASE_SERVICE_ACCOUNT_KEY)

- [ ] **Probar obtención de token FCM**
  - Verificar que se obtiene el token
  - Verificar que se guarda en Supabase

- [ ] **Probar envío de notificaciones**
  - Enviar notificación de prueba
  - Verificar que llega al dispositivo
  - Verificar handlers en todos los estados (foreground, background, cerrada)

**Tiempo estimado**: 54 minutos  
**Prioridad**: Media (después de publicación)

---

### 2. Publicación en App Store y Play Store 🏪

**Estado**: ⏸️ Deferido - Después de verificar que todo funciona

#### Tareas Pendientes:

#### 2.1 Preparación para Play Store (Android)

- [ ] **Configurar firma de la app**
  - Crear keystore para producción
  - Configurar `key.properties`
  - Configurar `build.gradle` para release

- [ ] **Optimizar para producción**
  - Habilitar ProGuard/R8
  - Optimizar imágenes y recursos
  - Reducir tamaño del APK/AAB

- [ ] **Preparar assets de Play Store**
  - Icono de la app (512x512)
  - Screenshots (mínimo 2)
  - Feature graphic (1024x500)
  - Descripción corta y larga
  - Categoría y tags

- [ ] **Configurar políticas de privacidad**
  - Enlazar política de privacidad
  - Configurar permisos de la app
  - Configurar contenido para menores

- [ ] **Crear cuenta de desarrollador**
  - Registrarse en Google Play Console
  - Pagar tarifa única ($25)
  - Completar perfil de desarrollador

- [ ] **Subir build de producción**
  - Generar AAB firmado
  - Subir a Play Console
  - Configurar versión y release notes

**Tiempo estimado**: 4-6 horas  
**Prioridad**: Alta (después de verificar funcionalidades)

---

#### 2.2 Preparación para App Store (iOS)

- [ ] **Configurar certificados y perfiles**
  - Crear certificado de distribución
  - Crear App ID
  - Crear perfil de aprovisionamiento

- [ ] **Optimizar para producción**
  - Configurar build para release
  - Optimizar imágenes y recursos
  - Reducir tamaño del IPA

- [ ] **Preparar assets de App Store**
  - Icono de la app (1024x1024)
  - Screenshots para diferentes tamaños de iPhone/iPad
  - Descripción y keywords
  - Categoría y subcategoría

- [ ] **Configurar App Store Connect**
  - Crear app en App Store Connect
  - Configurar información de la app
  - Configurar precios y disponibilidad

- [ ] **Configurar políticas de privacidad**
  - Enlazar política de privacidad
  - Configurar permisos de la app
  - Configurar edad recomendada

- [ ] **Crear cuenta de desarrollador**
  - Registrarse en Apple Developer Program
  - Pagar tarifa anual ($99)
  - Completar perfil de desarrollador

- [ ] **Subir build de producción**
  - Generar IPA firmado
  - Subir a App Store Connect
  - Configurar versión y release notes

**Tiempo estimado**: 6-8 horas  
**Prioridad**: Alta (después de verificar funcionalidades)

---

### 3. Optimizaciones y Mejoras 🚀

**Estado**: ⏸️ Deferido - Después de publicación

#### 3.1 Optimizaciones de Performance

- [ ] **Optimizar consultas de base de datos**
  - Revisar índices
  - Optimizar queries lentas
  - Optimizar joins

- [ ] **Optimizar carga de imágenes**
  - Implementar caché de imágenes
  - Comprimir imágenes al subir
  - Usar formatos optimizados (WebP)

- [ ] **Optimizar tamaño de la app**
  - Eliminar dependencias no usadas
  - Comprimir recursos
  - Usar ProGuard/R8

**Tiempo estimado**: 4-6 horas  
**Prioridad**: Media

---

#### 3.2 Mejoras de UI/UX

- [ ] **Mejorar manejo de errores**
  - Mensajes de error más amigables
  - Mejor feedback visual
  - Manejo de estados de carga

- [ ] **Añadir loading states**
  - Indicadores de carga en todas las operaciones
  - Skeleton loaders donde sea apropiado

- [ ] **Mejorar animaciones**
  - Transiciones suaves
  - Animaciones de carga
  - Feedback visual mejorado

**Tiempo estimado**: 6-8 horas  
**Prioridad**: Baja

---

### 4. Funcionalidades Adicionales ✨

**Estado**: ⏸️ Deferido - Después de publicación

#### 4.1 Mejoras del Perfil

- [ ] **Mostrar avatar de Google** (si disponible)
- [ ] **Añadir display name editable**
- [ ] **Añadir estadísticas básicas** (eventos guardados, creados)

**Tiempo estimado**: 2-3 horas  
**Prioridad**: Baja

---

#### 4.2 Sistema de Imágenes de Categorías

- [ ] **Crear bucket en Supabase Storage**
- [ ] **Subir imágenes predefinidas por categoría**
- [ ] **Modificar pantalla de creación para usar imágenes**

**Tiempo estimado**: 3-4 horas  
**Prioridad**: Baja

---

#### 4.3 Mejoras en Búsqueda

- [ ] **Añadir filtros avanzados** (fecha, precio, etc.)
- [ ] **Mejorar autocompletado**
- [ ] **Guardar búsquedas recientes**

**Tiempo estimado**: 2-3 horas  
**Prioridad**: Baja

---

## 📊 Resumen

### Tareas Críticas (ANTES de publicación)
- ✅ Seguridad de base de datos
- ✅ Funcionalidades legales
- ✅ Autenticación
- ⏳ Google Maps
- ⏳ Testing completo
- ⏳ Configuración legal/DNS

### Tareas Después de Publicación
- ⏸️ Notificaciones push
- ⏸️ Publicación en tiendas
- ⏸️ Optimizaciones
- ⏸️ Mejoras de UI/UX
- ⏸️ Funcionalidades adicionales

---

## 🎯 Orden Recomendado Después de Publicación

1. **Semana 1-2**: Publicación en tiendas
   - Preparar y subir a Play Store
   - Preparar y subir a App Store

2. **Semana 3**: Notificaciones push
   - Verificar y configurar Firebase
   - Probar envío de notificaciones

3. **Semana 4+**: Optimizaciones y mejoras
   - Optimizaciones de performance
   - Mejoras de UI/UX
   - Funcionalidades adicionales

---

## 📝 Notas

- **Prioridad**: Enfocarse primero en que la app funcione correctamente
- **Notificaciones**: Son opcionales, el sistema funciona sin ellas
- **Publicación**: Requiere tiempo y preparación, mejor hacerlo después de verificar todo
- **Mejoras**: Se pueden añadir gradualmente después del lanzamiento

---

**Última actualización**: Enero 2025

