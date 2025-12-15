# 🗺️ Roadmap - QuePlan App

Este documento contiene el roadmap del proyecto y se actualiza conforme avanzamos en el desarrollo.

**Última actualización**: Diciembre 2024 (actualizado con funcionalidades legales y cumplimiento RGPD)

**✨ Nuevo**: 
- Sistema de moderación completo (eventos y lugares pendientes) - Diciembre 2024
- Validación de duplicados implementada - Diciembre 2024
- 61 lugares de interés de Barbate añadidos a la base de datos - Diciembre 2024
- Integración Google Places API mejorada - Diciembre 2024
- **Funcionalidades legales completas (RGPD) implementadas** - Diciembre 2024
- **Firebase Hosting configurado para documentos legales** - Diciembre 2024

---

## 📊 Estado General del Proyecto

### ✅ Funcionalidades Completadas

- **Autenticación y Usuarios**
  - ✅ Login con email y contraseña
  - ✅ Registro de nuevos usuarios
  - ✅ Login con Google OAuth
  - ✅ Recuperación de contraseña
  - ✅ Perfil de usuario básico
  - ✅ Gestión de sesión
  - ✅ Panel de administración

- **Base de Datos**
  - ✅ Tablas configuradas (events, cities, categories, admins, user_favorites, venues, venue_managers, user_fcm_tokens)
  - ✅ Políticas RLS (Row Level Security) implementadas
  - ✅ Migraciones SQL ejecutadas
  - ✅ Esquema de base de datos documentado
  - ✅ Script de verificación de configuración creado
  - ✅ Verificación de Supabase completada
  - ✅ Campo created_by en eventos para identificar creadores

- **Dashboard Principal**
  - ✅ Visualización de eventos
  - ✅ Filtros por ciudad y categoría
  - ✅ Búsqueda de eventos
  - ✅ Eventos destacados (hero banner)
  - ✅ Eventos próximos
  - ✅ Eventos populares
  - ✅ Modo radio (cerca de ti)
  - ✅ Modo ciudad (búsqueda por ciudad)

- **Gestión de Eventos**
  - ✅ Creación de eventos por usuarios
  - ✅ Modificación de eventos por administradores
  - ✅ Aprobación/rechazo de eventos pendientes
  - ✅ Subida de imágenes para eventos
  - ✅ Selección de ubicación en mapa
  - ✅ Sistema de lugares/venues con aprobación
  - ✅ Autocompletado de lugares al crear eventos
  - ✅ Panel admin para aprobar lugares pendientes
  - ✅ "Mis Eventos Creados" - ver eventos propios

- **Favoritos**
  - ✅ Sistema de favoritos local
  - ✅ Sincronización con Supabase
  - ✅ Pantalla de favoritos
  - ✅ Gestión de favoritos por usuario

- **Notificaciones**
  - ✅ Firebase Messaging configurado
  - ✅ Permisos de notificaciones
  - ✅ Obtención de token FCM
  - ✅ Sistema de preferencias de notificaciones
  - ✅ Reglas de notificación por ciudad/categoría

- **UI/UX**
  - ✅ Onboarding de permisos
  - ✅ Diseño responsive
  - ✅ Modo oscuro/claro
  - ✅ Navegación intuitiva

- **Cumplimiento Legal y RGPD**
  - ✅ Sistema de eliminación de cuenta (Derecho al Olvido)
  - ✅ Sistema de exportación de datos (Derecho de Portabilidad)
  - ✅ Sistema de reportes de contenido
  - ✅ Pantalla de consentimiento GDPR
  - ✅ Gestión de consentimientos en base de datos
  - ✅ Pantalla "Sobre QuePlan" con información legal
  - ✅ Enlaces a documentos legales en perfil y registro
  - ✅ Firebase Hosting configurado para documentos legales
  - ✅ Migraciones SQL para funcionalidades legales

---

## 🚧 Funcionalidades Pendientes / En Progreso

### 🔴 Alta Prioridad

#### 1. Verificar y Completar Configuración Legal
- [ ] Ejecutar migración SQL de funcionalidades legales (`docs/migrations/008_add_legal_functions.sql`)
- [ ] Verificar propagación DNS para dominio `queplan-app.com`
- [ ] Completar verificación de dominio en Firebase Hosting
- [ ] Verificar que SSL esté activo en `https://queplan-app.com`
- [ ] Verificar que funcionen las URLs:
  - [ ] `https://queplan-app.com/privacy`
  - [ ] `https://queplan-app.com/terms`
- [ ] Personalizar documentos legales (Política de Privacidad y Términos) con información específica
- [ ] Actualizar email de contacto en `about_screen.dart` si es necesario
- **Estado**: Implementación completa, pendiente verificación DNS y personalización
- **Notas**: 
  - Dominio configurado en Firebase Hosting
  - Registros DNS añadidos en Squarespace
  - Esperando propagación DNS (puede tardar 24-48 horas)
  - Documentos legales en `docs/legal/` listos para personalizar

#### 2. Corregir Errores de Seguridad en Supabase
- [ ] Ejecutar script de seguridad (`docs/migrations/007_fix_security_issues.sql`)
- **Estado**: Script creado, pendiente ejecutar
- **Archivo**: `docs/migrations/007_fix_security_issues.sql`
- **Tiempo estimado**: 5 minutos
- **Notas**: Supabase Security Advisor detectó 3 errores (probablemente tablas sin RLS)

#### 3. Configuración de Emails SMTP
- [ ] Configurar SMTP para emails de confirmación
- [ ] Habilitar confirmación de email en producción
- [ ] Personalizar templates de email
- **Estado**: Documentación creada (`docs/CONFIGURAR_EMAILS.md`), pendiente implementación
- **Notas**: Se puede dejar desactivado para desarrollo - Decidido dejarlo para más adelante

#### 4. Reparar/Verificar Google Maps
- [ ] Diagnosticar problemas con Google Maps
- [ ] Verificar API Key y permisos
- [ ] Mejorar manejo de errores en mapas
- [ ] Verificar funcionalidad en iOS
- **Estado**: Pendiente verificación
- **Archivos relacionados**: 
  - `lib/ui/event/event_detail_screen.dart`
  - `lib/ui/events/event_submit_screen.dart`
  - `lib/ui/admin/admin_event_edit_screen.dart`

#### 5. Completar Sistema de Notificaciones Push
- [x] Implementar handlers para notificaciones en foreground - Diciembre 2024
- [x] Implementar handlers para notificaciones en background - Diciembre 2024
- [x] Implementar handlers para notificaciones cuando app está cerrada - Diciembre 2024
- [x] Crear tabla `user_fcm_tokens` en Supabase - Diciembre 2024
- [x] Guardar token FCM al iniciar sesión - Diciembre 2024
- [x] Crear funciones para enviar notificaciones desde backend - Diciembre 2024
- [ ] Verificar que Edge Function `send_fcm_notification` esté desplegada en Supabase
- [ ] Probar envío de notificaciones
- **Estado**: ✅ Implementación completa - Pendiente verificar despliegue y probar envío

---

### 🟡 Media Prioridad

#### 4. Mejorar Perfil de Usuario
- [ ] Mostrar avatar de Google (si disponible)
- [ ] Añadir display name editable
- [ ] Pantalla "Mis Eventos Creados"
- [ ] Historial de eventos creados
- [ ] Editar/eliminar eventos propios
- [ ] Estadísticas básicas (eventos guardados, creados)
- **Estado**: Funcionalidad básica implementada, falta ampliar

#### 5. Gestión de Imágenes de Categorías
- [ ] Crear bucket en Supabase Storage para imágenes de categorías
- [ ] Subir imágenes predefinidas por categoría
- [ ] Modificar pantalla de creación de eventos para usar imágenes de categoría
- [ ] Crear servicio para obtener URLs de imágenes de categorías
- [ ] Galería de imágenes disponibles por categoría
- **Estado**: Pendiente implementación
- **Notas**: Mejora UX - permite usar imágenes predefinidas cuando no hay imagen propia

#### 6. Mejorar Sistema de Búsqueda
- [ ] Optimizar búsqueda de eventos
- [ ] Añadir filtros avanzados (fecha, precio, etc.)
- [ ] Mejorar autocompletado de búsqueda
- [ ] Guardar búsquedas recientes
- **Estado**: Búsqueda básica funcionando

#### 7. Mejorar Detalle de Eventos
- [ ] Compartir eventos (ya implementado, mejorar)
- [ ] Añadir al calendario (ya implementado, mejorar)
- [ ] Ver más eventos del mismo organizador
- [ ] Comentarios/reseñas de eventos (futuro)
- [ ] Reportar evento

---

### 🟢 Baja Prioridad / Mejoras Futuras

#### 8. Mejoras de UI/UX
- [ ] Animaciones y transiciones suaves
- [ ] Pull to refresh en listas
- [ ] Loading states mejorados
- [ ] Mensajes de error más amigables
- [ ] Onboarding mejorado con más información

#### 9. Estadísticas y Analytics
- [ ] Dashboard de estadísticas para administradores
- [ ] Métricas de eventos más populares
- [ ] Estadísticas de usuarios activos
- [ ] Gráficos y reportes

#### 10. Social y Compartir
- [ ] Integración con redes sociales
- [ ] Compartir en WhatsApp/Telegram
- [ ] Generar imágenes para compartir (con QR)
- [ ] Invitar amigos a eventos

#### 11. Funcionalidades Avanzadas
- [ ] Sistema de comentarios en eventos
- [ ] Sistema de calificaciones/reseñas
- [ ] Notificaciones cuando eventos favoritos están próximos
- [ ] Recordatorios de eventos
- [ ] Eventos recurrentes
- [ ] Colaboradores/multi-organizadores

#### 12. Internacionalización
- [ ] Soporte para múltiples idiomas
- [ ] Traducciones de textos
- [ ] Formato de fechas por región

---

## 🔧 Tareas Técnicas Pendientes

### Base de Datos
- [x] Verificar configuración completa de Supabase - Diciembre 2024
- [ ] Optimizar consultas de eventos
- [ ] Añadir índices para mejorar rendimiento
- [ ] Backup automático configurado
- [ ] Migración de datos si es necesario

### Código y Arquitectura
- [x] Crear roadmap completo del proyecto - Diciembre 2024
- [x] Crear documentación de verificación de Supabase - Diciembre 2024
- [x] Crear guía de configuración de emails - Diciembre 2024
- [ ] Refactorizar código legacy
- [ ] Mejorar manejo de errores global
- [ ] Añadir más tests unitarios
- [ ] Documentación de código mejorada
- [ ] Cleanup de código no usado

### Seguridad
- [x] Implementar funcionalidades legales (eliminación cuenta, exportación datos) - Diciembre 2024
- [x] Sistema de reportes de contenido - Diciembre 2024
- [x] Consentimiento GDPR implementado - Diciembre 2024
- [ ] Ejecutar script de corrección de seguridad Supabase (`007_fix_security_issues.sql`)
- [ ] Auditoría de seguridad completa
- [ ] Validación de inputs más robusta
- [ ] Rate limiting en APIs
- [ ] Protección contra spam en creación de eventos

### Performance
- [ ] Optimizar carga de imágenes
- [ ] Implementar caché de datos
- [ ] Lazy loading de listas largas
- [ ] Compresión de imágenes

---

## 📅 Próximos Pasos Inmediatos

1. **Esta semana:**
   - [ ] Verificar propagación DNS y completar configuración de dominio legal
   - [ ] Ejecutar migraciones SQL pendientes (007 y 008)
   - [ ] Verificar/Reparar Google Maps
   - [x] Completar handlers de notificaciones push - Diciembre 2024
   - [x] Guardar tokens FCM en Supabase - Diciembre 2024
   - [x] Implementar funcionalidades legales completas - Diciembre 2024
   - [ ] Verificar despliegue de Edge Function `send_fcm_notification`
   - [ ] Probar envío de notificaciones push

2. **Próximas 2 semanas:**
   - [ ] Mejorar perfil de usuario con "Mis Eventos"
   - [ ] Configurar SMTP (cuando esté cerca producción)
   - [ ] Implementar imágenes de categorías

3. **Este mes:**
   - [ ] Mejoras de UI/UX
   - [ ] Optimizaciones de performance
   - [ ] Testing completo

---

## 📝 Notas de Desarrollo

### Funcionalidades Parcialmente Implementadas

1. **Notificaciones**: Firebase configurado pero falta guardar tokens y handlers
2. **Emails**: Infraestructura lista, falta configurar SMTP
3. **Perfil**: Básico funcionando, falta "Mis Eventos"

### Decisiones Pendientes

- [ ] ¿Implementar sistema de comentarios/reseñas?
- [ ] ¿Añadir chat entre usuarios?
- [ ] ¿Sistema de puntos/recompensas?
- [ ] ¿Versión web además de móvil?

---

## 🎯 Objetivos a Largo Plazo

- **Q1 2024**: App estable en producción
- **Q2 2024**: Funcionalidades sociales (comentarios, compartir)
- **Q3 2024**: Expansión a más ciudades/regiones
- **Q4 2024**: API pública para desarrolladores

---

## 📊 Métricas de Progreso

- **Funcionalidades Core**: 85% ✅
- **UI/UX**: 75% ✅
- **Backend/Base de Datos**: 90% ✅
- **Notificaciones**: 85% ✅
- **Cumplimiento Legal/RGPD**: 95% ✅ (pendiente verificación DNS)
- **Testing**: 30% 🟡
- **Documentación**: 75% ✅

---

## 🔄 Cómo Actualizar Este Roadmap

1. Al completar una tarea, marca con ✅
2. Al iniciar una tarea, añade fecha de inicio
3. Al añadir nueva funcionalidad, añádela en la sección apropiada
4. Actualiza la fecha de "Última actualización" al final

---

**Formato de actualización sugerido:**
```markdown
- [x] Tarea completada - {{ fecha }}
- [ ] Tarea en progreso - {{ fecha inicio }}
- [ ] Nueva tarea añadida - {{ fecha }}
```

---

*Este roadmap es un documento vivo y se actualiza conforme el proyecto evoluciona.*
