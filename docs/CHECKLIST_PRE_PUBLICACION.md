# ✅ Checklist Pre-Publicación - QuePlan

**Última actualización**: Febrero 2025

Checklist consolidado para revisar antes de hacer la app pública.  
Incluye las mejoras de seguridad recientes (Edge Functions, venues RLS).

---

## 🔴 CRÍTICO - Hacer antes de publicar

### Seguridad
- [x] **Migraciones SQL base** (007, 008, 011) ejecutadas
- [x] **Migración 046** – Venues solo INSERT con usuario autenticado
- [x] **Edge Function send_fcm_notification** – Validación JWT y permisos admin
- [ ] **Security Advisor** – Comprobar en Supabase Dashboard que todo esté en verde
- [ ] **API Keys** – Verificar restricciones en Google Cloud (Maps, Places) para producción

### Legal / RGPD
- [ ] **URLs legales** – `queplan-app.com/privacy` y `queplan-app.com/terms` funcionando
- [ ] **Documentos legales** – Política de privacidad y términos personalizados con contacto real
- [ ] **Consentimientos** – Pantalla de consentimiento GDPR visible en registro

### Firma de la app (Android)
- [ ] **Keystore de producción** – Crear y configurar (actualmente usa debug para release)
  - Ver `scripts/crear_keystore_release.sh` y `docs/TAREAS_DESPUES_PUBLICACION.md`
  - Configurar `key.properties` y `signingConfigs` en `build.gradle.kts`

---

## 🟡 IMPORTANTE - Verificar antes de publicar

### Funcionalidad
- [ ] **Google Maps** – API Key con restricciones, probar crear evento con mapa
- [ ] **Notificaciones push** – Edge Function desplegada, envío de prueba correcto
- [ ] **Flujo completo** – Crear cuenta → crear evento → aprobar (admin) → ver en dashboard
- [ ] **Ownership** – Reclamar venue → verificar código → aprobar como admin
- [ ] **RGPD** – Exportar datos, eliminar cuenta y comprobar eliminación real

### App Stores
- [ ] **Play Store** – Icono 512x512, screenshots, feature graphic, política de privacidad
- [ ] **App Store** (si aplica) – Iconos, capturas, App Privacy, descripción

### Configuración
- [ ] **Dominio/DNS** – `queplan-app.com` resuelve y SSL activo
- [ ] **Variables de entorno** – Ningún secreto hardcodeado, `.env` en `.gitignore`

---

## 🟢 RECOMENDADO - Revisar

### UX / Errores
- [ ] Mensajes de error claros para el usuario
- [ ] Estados de carga en operaciones asíncronas
- [ ] Modo offline básico o feedback adecuado sin red

### Producción
- [ ] Límites/quotas de Supabase y Firebase revisados para tráfico real
- [ ] Backup de base de datos configurado
- [ ] Monitoreo o logs mínimos para detectar fallos

---

## Resumen rápido

| Área        | Estado   | Acción                                        |
|-------------|----------|-----------------------------------------------|
| Seguridad   | ✅ Mejorado | Verificar Security Advisor y API Keys      |
| Legal       | ⚠️ Pendiente | URLs + personalizar documentos            |
| Firma Android | ⚠️ Pendiente | Keystore de producción                   |
| Funcionalidad | ⚠️ Pendiente | Testing de flujos críticos               |

---

## Archivos de referencia

- `docs/CHECKLIST_LANZAMIENTO.md` – Checklist detallado original
- `docs/MEJORAS_SEGURIDAD_APLICADAS.md` – Cambios de seguridad recientes
- `docs/TAREAS_DESPUES_PUBLICACION.md` – Tareas post-lanzamiento
- `CONFIGURAR_GOOGLE_MAPS.md` – Configuración de Maps
