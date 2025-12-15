# 📋 Resumen de Tareas Pendientes - QuePlan App

**Fecha de revisión**: Diciembre 2024  
**Estado del proyecto**: 87% completado  
**Última actualización**: 14 Diciembre 2024 - Funcionalidades legales implementadas

---

## 🔴 ALTA PRIORIDAD - Hacer Ahora

### 1. ⏳ Verificar y Completar Configuración Legal
- **Estado**: Implementación completa, pendiente verificación DNS
- **Tareas**:
  - [ ] Ejecutar migración SQL `008_add_legal_functions.sql` en Supabase
  - [ ] Verificar propagación DNS para `queplan-app.com` (puede tardar 24-48h)
  - [ ] Completar verificación de dominio en Firebase Hosting
  - [ ] Verificar que SSL esté activo en `https://queplan-app.com`
  - [ ] Probar URLs:
    - [ ] `https://queplan-app.com/privacy`
    - [ ] `https://queplan-app.com/terms`
  - [ ] Personalizar documentos legales con información específica
- **Tiempo estimado**: 30 minutos (después de propagación DNS)
- **Notas**: 
  - Firebase Hosting configurado ✅
  - Registros DNS añadidos en Squarespace ✅
  - Esperando propagación DNS ⏳
  - Documentos en `docs/legal/` listos para personalizar

### 2. ✅ Corregir Errores de Seguridad en Supabase
- **Estado**: Script creado, pendiente ejecutar
- **Archivo**: `docs/migrations/007_fix_security_issues.sql`
- **Acción**: Ejecutar en Supabase SQL Editor
- **Tiempo estimado**: 5 minutos
- **Notas**: Supabase Security Advisor detectó 3 errores (probablemente tablas sin RLS)

### 3. 🔧 Verificar/Reparar Google Maps
- **Estado**: Pendiente diagnóstico
- **Archivos relacionados**:
  - `lib/ui/event/event_detail_screen.dart`
  - `lib/ui/events/event_submit_screen.dart`
  - `lib/ui/admin/admin_event_edit_screen.dart`
- **Tareas**:
  - [ ] Diagnosticar problemas con Google Maps
  - [ ] Verificar API Key y permisos
  - [ ] Mejorar manejo de errores en mapas
  - [ ] Verificar funcionalidad en iOS
- **Tiempo estimado**: 2-3 horas
- **Documentación**: Ver `docs/DIAGNOSTICAR_GOOGLE_MAPS.md`

### 4. 🔔 Completar Sistema de Notificaciones Push
- **Estado**: Implementación completa, falta verificar despliegue
- **Tareas**:
  - [x] Handlers de notificaciones implementados ✅
  - [x] Tabla `user_fcm_tokens` creada ✅
  - [x] Guardar token FCM al iniciar sesión ✅
  - [x] Funciones para enviar notificaciones creadas ✅
  - [ ] **Verificar que Edge Function `send_fcm_notification` esté desplegada en Supabase**
  - [ ] **Probar envío de notificaciones**
- **Tiempo estimado**: 1-2 horas
- **Archivos**:
  - `supabase/functions/send_fcm_notification/index.ts`
  - `supabase/functions/send_notification/index.ts`

---

## 🟡 MEDIA PRIORIDAD - Próximas Semanas

### 4. 👤 Mejorar Perfil de Usuario
- **Estado**: Funcionalidad básica implementada
- **Tareas**:
  - [ ] Mostrar avatar de Google (si disponible)
  - [ ] Añadir display name editable
  - [x] Pantalla "Mis Eventos Creados" - Implementada ✅
  - [ ] Historial de eventos creados
  - [ ] Editar/eliminar eventos propios
  - [ ] Estadísticas básicas (eventos guardados, creados)
- **Tiempo estimado**: 4-6 horas
- **Archivos relacionados**:
  - `lib/ui/auth/profile_screen.dart`
  - `lib/ui/events/my_events_screen.dart`

### 5. 🖼️ Gestión de Imágenes de Categorías
- **Estado**: Pendiente implementación
- **Tareas**:
  - [ ] Crear bucket en Supabase Storage para imágenes de categorías
  - [ ] Subir imágenes predefinidas por categoría
  - [ ] Modificar pantalla de creación de eventos para usar imágenes de categoría
  - [ ] Crear servicio para obtener URLs de imágenes de categorías
  - [ ] Galería de imágenes disponibles por categoría
- **Tiempo estimado**: 3-4 horas
- **Notas**: Mejora UX - permite usar imágenes predefinidas cuando no hay imagen propia

### 6. 🔍 Mejorar Sistema de Búsqueda
- **Estado**: Búsqueda básica funcionando
- **Tareas**:
  - [ ] Optimizar búsqueda de eventos
  - [ ] Añadir filtros avanzados (fecha, precio, etc.)
  - [ ] Mejorar autocompletado de búsqueda
  - [ ] Guardar búsquedas recientes
- **Tiempo estimado**: 3-4 horas

### 7. 📱 Mejorar Detalle de Eventos
- **Estado**: Funcionalidad básica implementada
- **Tareas**:
  - [x] Compartir eventos ✅
  - [x] Añadir al calendario ✅
  - [ ] Ver más eventos del mismo organizador
  - [ ] Comentarios/reseñas de eventos (futuro)
  - [ ] Reportar evento
- **Tiempo estimado**: 2-3 horas
- **Archivo**: `lib/ui/event/event_detail_screen.dart`

---

## 🟢 BAJA PRIORIDAD - Mejoras Futuras

### 8. 🎨 Mejoras de UI/UX
- [ ] Animaciones y transiciones suaves
- [ ] Pull to refresh en listas
- [ ] Loading states mejorados
- [ ] Mensajes de error más amigables
- [ ] Onboarding mejorado con más información

### 9. 📊 Estadísticas y Analytics
- [ ] Dashboard de estadísticas para administradores
- [ ] Métricas de eventos más populares
- [ ] Estadísticas de usuarios activos
- [ ] Gráficos y reportes

### 10. 📱 Social y Compartir
- [ ] Integración con redes sociales
- [ ] Compartir en WhatsApp/Telegram
- [ ] Generar imágenes para compartir (con QR)
- [ ] Invitar amigos a eventos

### 11. ⚙️ Funcionalidades Avanzadas
- [ ] Sistema de comentarios en eventos
- [ ] Sistema de calificaciones/reseñas
- [ ] Notificaciones cuando eventos favoritos están próximos
- [ ] Recordatorios de eventos
- [ ] Eventos recurrentes
- [ ] Colaboradores/multi-organizadores

### 12. 🌍 Internacionalización
- [ ] Soporte para múltiples idiomas
- [ ] Traducciones de textos
- [ ] Formato de fechas por región

---

## 🔧 TAREAS TÉCNICAS PENDIENTES

### Base de Datos
- [x] Verificar configuración completa de Supabase ✅
- [ ] Optimizar consultas de eventos
- [ ] Añadir índices para mejorar rendimiento
- [ ] Backup automático configurado
- [ ] Migración de datos si es necesario

### Código y Arquitectura
- [x] Crear roadmap completo del proyecto ✅
- [x] Crear documentación de verificación de Supabase ✅
- [ ] Refactorizar código legacy
- [ ] Mejorar manejo de errores global
- [ ] Añadir más tests unitarios
- [ ] Documentación de código mejorada
- [ ] Cleanup de código no usado

### Seguridad
- [ ] Auditoría de seguridad (después de corregir errores actuales)
- [ ] Validación de inputs más robusta
- [ ] Rate limiting en APIs
- [ ] Protección contra spam en creación de eventos

### Performance
- [ ] Optimizar carga de imágenes
- [ ] Implementar caché de datos
- [ ] Lazy loading de listas largas
- [ ] Compresión de imágenes

---

## 📝 TODOs ENCONTRADOS EN EL CÓDIGO

### `lib/services/auth_service.dart`
- [ ] Implementar actualización de perfil cuando sea necesario (línea 232)

### `lib/services/notification_handler.dart`
- [ ] Navegar a EventDetailScreen con el eventId (línea 109)

### `lib/ui/event/event_detail_screen.dart`
- [ ] Reemplazar con flag real del modelo cuando se implemente (línea 104)
- [ ] Implementar lógica real cuando se agregue el flag al modelo (línea 108)

### `lib/ui/dashboard/widgets/upcoming_list.dart`
- [ ] Abrir mapa o detalles de ubicación (línea 411)

---

## 🎯 PLAN DE ACCIÓN INMEDIATO

### Esta Semana (Prioridad Máxima)
1. ⏳ **Verificar configuración legal y dominio**
   - Tiempo: 30 min (después de propagación DNS)
   - Impacto: Crítico - Requisito legal antes de publicar
   - Estado: Esperando propagación DNS (24-48h)

2. ✅ **Ejecutar script de seguridad** (`007_fix_security_issues.sql`)
   - Tiempo: 5 minutos
   - Impacto: Crítico - Resuelve errores de Security Advisor

3. ✅ **Ejecutar migración legal** (`008_add_legal_functions.sql`)
   - Tiempo: 5 minutos
   - Impacto: Crítico - Habilita funcionalidades legales

4. 🔧 **Verificar Google Maps**
   - Tiempo: 2-3 horas
   - Impacto: Alto - Funcionalidad core de la app

5. 🔔 **Verificar despliegue de Edge Functions**
   - Tiempo: 1 hora
   - Impacto: Alto - Notificaciones push

### Próximas 2 Semanas
4. 👤 **Mejorar perfil de usuario** (editar/eliminar eventos propios)
5. 🖼️ **Implementar imágenes de categorías**
6. 🔍 **Mejorar sistema de búsqueda**

### Este Mes
7. 🎨 **Mejoras de UI/UX**
8. 📊 **Optimizaciones de performance**
9. 🧪 **Testing completo**

---

## 📊 MÉTRICAS DE PROGRESO ACTUAL

- **Funcionalidades Core**: 85% ✅
- **UI/UX**: 75% ✅
- **Backend/Base de Datos**: 90% ✅
- **Notificaciones**: 85% ✅ (falta verificar despliegue)
- **Cumplimiento Legal/RGPD**: 95% ✅ (pendiente verificación DNS)
- **Testing**: 30% 🟡
- **Documentación**: 75% ✅
- **Seguridad**: 95% ✅ (después de ejecutar scripts)

---

## 🚀 PRÓXIMOS PASOS RECOMENDADOS

1. **Hoy**: Ejecutar script de seguridad en Supabase
2. **Esta semana**: Verificar Google Maps y Edge Functions
3. **Próxima semana**: Mejorar perfil de usuario
4. **Este mes**: Implementar imágenes de categorías y mejorar búsqueda

---

**Nota**: Este documento se actualiza conforme se completan tareas. Marca las tareas completadas con ✅ y actualiza las fechas.

