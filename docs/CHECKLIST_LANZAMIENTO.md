# ✅ Checklist Pre-Lanzamiento - QuePlan

**Fecha de creación**: Enero 2025  
**Última actualización**: Enero 2025

Este documento contiene el checklist completo de tareas necesarias antes del lanzamiento de la app.

---

## 🔴 CRÍTICO - Hacer ANTES del lanzamiento

### 1. Seguridad de Base de Datos ⚠️
- [x] **Ejecutar migración 011_create_venue_ownership_system.sql** ✅ **COMPLETADO - Enero 2025**
  - Sistema de ownership de venues
  - **Archivo**: `docs/migrations/011_create_venue_ownership_system.sql`
  - **Tiempo**: 3 minutos
  - **Estado**: ✅ Ejecutado sin errores

- [x] **Ejecutar migración 007_fix_security_issues.sql** ✅ **YA ESTABA EJECUTADA**
  - Habilita RLS en todas las tablas
  - Añade políticas de seguridad
  - **Estado**: ✅ Confirmado ejecutada previamente

- [x] **Ejecutar migración 008_add_legal_functions.sql** ✅ **YA ESTABA EJECUTADA**
  - Funcionalidades legales (RGPD)
  - **Estado**: ✅ Confirmado ejecutada previamente

- [x] **Verificar migración 011 con script de verificación** ✅ **COMPLETADO - Enero 2025**
  - Ejecutado `docs/VERIFICAR_OWNERSHIP_SIMPLE.sql` en Supabase
  - **Resultado**: ✅ TODAS LAS VERIFICACIONES PASARON - MIGRACIÓN CORRECTA
  - **Estado**: ✅ Verificado correctamente

- [x] **Verificar Security Advisor en Supabase** ✅ **COMPLETADO - Enero 2025**
  - Ejecutado script `VERIFICAR_RLS.sql`
  - **Resultado**: ✅ Todo en verde - Todas las tablas con RLS y políticas correctas
  - **Estado**: ✅ Verificado correctamente

### 2. Configuración Legal y Dominio ⚠️
- [ ] **Verificar propagación DNS para queplan-app.com**
  - Comprobar que el dominio resuelve correctamente
  - **Comando**: `nslookup queplan-app.com` o usar herramienta online
  - **Tiempo**: 5 minutos

- [ ] **Verificar SSL activo**
  - Comprobar que `https://queplan-app.com` funciona
  - **Tiempo**: 2 minutos

- [ ] **Verificar URLs legales funcionan**
  - [ ] `https://queplan-app.com/privacy` → Muestra política de privacidad
  - [ ] `https://queplan-app.com/terms` → Muestra términos y condiciones
  - **Tiempo**: 5 minutos

- [ ] **Personalizar documentos legales**
  - Revisar y personalizar `docs/legal/privacy_policy.html`
  - Revisar y personalizar `docs/legal/terms_of_service.html`
  - Añadir información de contacto real
  - **Tiempo**: 30-60 minutos

### 3. Google Maps 🗺️
- [ ] **Verificar API Key de Google Maps**
  - Comprobar que la API Key está configurada correctamente
  - Verificar restricciones de API Key
  - **Archivo**: `android/app/src/main/AndroidManifest.xml` y `ios/Runner/AppDelegate.swift`
  - **Tiempo**: 10 minutos

- [ ] **Probar funcionalidad de mapas**
  - [ ] Crear evento y seleccionar ubicación en mapa
  - [ ] Ver mapa en detalle de evento
  - [ ] Verificar que funciona en Android
  - [ ] Verificar que funciona en iOS
  - **Tiempo**: 15 minutos

### 4. Notificaciones Push 📱
- [ ] **Verificar Edge Function desplegada**
  - Comprobar que `send_fcm_notification` está desplegada en Supabase
  - **Tiempo**: 5 minutos

- [ ] **Probar envío de notificaciones**
  - Enviar notificación de prueba desde admin
  - Verificar que llega al dispositivo
  - **Tiempo**: 10 minutos

### 5. Testing Básico 🧪
- [ ] **Probar flujo completo de creación de evento**
  - [ ] Crear cuenta
  - [ ] Iniciar sesión
  - [ ] Crear evento
  - [ ] Verificar que aparece en dashboard
  - **Tiempo**: 15 minutos

- [ ] **Probar sistema de ownership**
  - [ ] Reclamar venue
  - [ ] Verificar notificación a admin
  - [ ] Verificar código de verificación
  - [ ] Aprobar ownership
  - [ ] Crear evento para venue con dueño
  - [ ] Aprobar evento como dueño
  - **Tiempo**: 20 minutos

- [ ] **Probar funcionalidades legales**
  - [ ] Exportar datos de usuario
  - [ ] Eliminar cuenta
  - [ ] Verificar que se eliminan todos los datos
  - **Tiempo**: 15 minutos

---

## 🟡 IMPORTANTE - Hacer pronto después del lanzamiento

### 6. Mejoras de UX
- [ ] **Mejorar manejo de errores**
  - Mensajes de error más amigables
  - Mejor feedback visual
  - **Tiempo**: 2-3 horas

- [ ] **Añadir loading states**
  - Indicadores de carga en todas las operaciones
  - **Tiempo**: 1-2 horas

### 7. Optimizaciones
- [ ] **Optimizar consultas de eventos**
  - Revisar índices en base de datos
  - Optimizar queries lentas
  - **Tiempo**: 2-3 horas

- [ ] **Optimizar carga de imágenes**
  - Implementar caché de imágenes
  - Comprimir imágenes
  - **Tiempo**: 2-3 horas

### 8. Documentación
- [ ] **Actualizar README.md**
  - Añadir instrucciones de instalación
  - Añadir configuración necesaria
  - **Tiempo**: 30 minutos

- [ ] **Documentar sistema de ownership**
  - Ya creado: `docs/venue_ownership_system.md`
  - Verificar que está completo
  - **Tiempo**: 15 minutos

---

## 🟢 OPCIONAL - Mejoras futuras

### 9. Funcionalidades Adicionales
- [ ] Mejorar perfil de usuario (avatar, display name)
- [ ] Sistema de imágenes de categorías
- [ ] Mejoras en búsqueda
- [ ] Estadísticas para admins

---

## 📋 Orden de Ejecución Recomendado

### Día 1 (Crítico - 2-3 horas)
1. ✅ Ejecutar migraciones SQL (007, 008, 011)
2. ✅ Verificar Security Advisor
3. ✅ Verificar configuración legal/DNS
4. ✅ Probar Google Maps

### Día 2 (Testing - 2-3 horas)
1. ✅ Testing completo de funcionalidades
2. ✅ Probar notificaciones push
3. ✅ Probar sistema de ownership
4. ✅ Probar funcionalidades legales

### Día 3 (Ajustes finales - 1-2 horas)
1. ✅ Personalizar documentos legales
2. ✅ Ajustes de UX menores
3. ✅ Verificación final

---

## ✅ Verificación Final

Antes de lanzar, verificar:

- [ ] Todas las migraciones SQL ejecutadas
- [ ] Security Advisor sin errores
- [ ] URLs legales funcionando
- [ ] Google Maps funcionando
- [ ] Notificaciones push funcionando
- [ ] Testing básico completado
- [ ] Documentos legales personalizados
- [ ] README actualizado

---

## 📝 Notas

- **Tiempo total estimado**: 6-8 horas de trabajo
- **Prioridad**: Seguridad > Legal > Funcionalidad > UX
- **Riesgo de no hacer tareas críticas**: Alto (vulnerabilidades, incumplimiento legal)

---

**Última actualización**: Enero 2025

