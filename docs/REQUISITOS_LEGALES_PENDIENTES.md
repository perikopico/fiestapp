# ⚖️ Requisitos Legales Pendientes - QuePlan App

**Fecha**: Diciembre 2024  
**Estado**: ❌ **CRÍTICO** - Requisitos legales esenciales faltantes

---

## 🚨 REQUISITOS CRÍTICOS - OBLIGATORIOS ANTES DE PUBLICAR

### 1. 📄 Política de Privacidad
**Estado**: ❌ **NO IMPLEMENTADO**  
**Prioridad**: 🔴 **CRÍTICA**

**Qué falta:**
- [ ] Crear documento de Política de Privacidad completo
- [ ] Hostear en URL pública (ej: `https://queplan.app/privacy` o GitHub Pages)
- [ ] Añadir enlace en la app (pantalla de perfil/configuración)
- [ ] Mostrar en el registro (consentimiento explícito)
- [ ] Incluir en Google Play Store (requerido)
- [ ] Incluir en Apple App Store (requerido)

**Contenido mínimo requerido:**
- Qué datos personales se recopilan
- Cómo se usan los datos
- Con quién se comparten (Supabase, Firebase, Google)
- Derechos del usuario (acceso, rectificación, supresión, portabilidad)
- Cookies y tecnologías de seguimiento
- Contacto del responsable de datos
- Base legal para el tratamiento (RGPD)

**Ubicación en la app:**
- Pantalla de perfil → "Política de Privacidad"
- Pantalla de registro → Enlace antes de aceptar
- Configuración → Sección legal

---

### 2. 📋 Términos y Condiciones / Términos de Uso
**Estado**: ❌ **NO IMPLEMENTADO**  
**Prioridad**: 🔴 **CRÍTICA**

**Qué falta:**
- [ ] Crear documento de Términos y Condiciones
- [ ] Hostear en URL pública
- [ ] Añadir enlace en la app
- [ ] Mostrar en el registro (aceptación obligatoria)
- [ ] Incluir en stores (requerido)

**Contenido mínimo requerido:**
- Reglas de uso de la app
- Prohibiciones (contenido inapropiado, spam, etc.)
- Responsabilidades del usuario
- Limitación de responsabilidad
- Propiedad intelectual
- Modificaciones de los términos
- Ley aplicable y jurisdicción

**Ubicación en la app:**
- Pantalla de registro → Checkbox obligatorio "Acepto los términos"
- Pantalla de perfil → "Términos y Condiciones"

---

### 3. ✅ Consentimiento GDPR/RGPD Explícito
**Estado**: ❌ **NO IMPLEMENTADO**  
**Prioridad**: 🔴 **CRÍTICA** (Especialmente si operas en UE/España)

**Qué falta:**
- [ ] Pantalla de consentimiento al primer uso
- [ ] Consentimiento granular (por tipo de dato)
- [ ] Opción de rechazar (no solo aceptar)
- [ ] Guardar registro de consentimientos
- [ ] Permitir retirar consentimiento
- [ ] Mostrar qué datos se recopilan y para qué

**Datos que requieren consentimiento:**
- ✅ Ubicación (ya solicitado en onboarding)
- ✅ Imágenes/fotos (ya solicitado en onboarding)
- ❌ **Email** (registro) - Falta explicar uso
- ❌ **Notificaciones push** - Falta consentimiento explícito
- ❌ **Datos de perfil** - Falta explicar uso
- ❌ **Favoritos** - Falta explicar almacenamiento

**Implementación sugerida:**
```dart
// Pantalla de consentimiento GDPR
- Mostrar qué datos se recopilan
- Checkboxes individuales por tipo de dato
- Botón "Aceptar todo" / "Rechazar todo" / "Personalizar"
- Guardar preferencias en Supabase
```

---

### 4. 🗑️ Eliminación de Cuenta (Derecho al Olvido - RGPD Art. 17)
**Estado**: ❌ **NO IMPLEMENTADO**  
**Prioridad**: 🔴 **CRÍTICA**

**Qué falta:**
- [ ] Botón "Eliminar cuenta" en perfil
- [ ] Confirmación con advertencia clara
- [ ] Eliminar todos los datos del usuario:
  - Cuenta de autenticación (Supabase Auth)
  - Favoritos (`user_favorites`)
  - Tokens FCM (`user_fcm_tokens`)
  - Eventos creados (opcional: anonimizar o eliminar)
  - Datos de administrador (si aplica)
- [ ] Confirmación de eliminación
- [ ] Tiempo de retención (30 días para recuperación opcional)

**Implementación:**
```sql
-- Función para eliminar todos los datos de un usuario
CREATE OR REPLACE FUNCTION delete_user_data(user_uuid uuid)
RETURNS void AS $$
BEGIN
  -- Eliminar favoritos (CASCADE automático)
  DELETE FROM public.user_favorites WHERE user_id = user_uuid;
  
  -- Eliminar tokens FCM
  DELETE FROM public.user_fcm_tokens WHERE user_id = user_uuid;
  
  -- Eliminar eventos creados (o anonimizar)
  UPDATE public.events SET created_by = NULL WHERE created_by = user_uuid;
  
  -- Eliminar de admins
  DELETE FROM public.admins WHERE user_id = user_uuid;
  
  -- Eliminar cuenta de auth (desde la app con Supabase)
  -- Supabase.client.auth.admin.deleteUser(user_uuid)
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;
```

---

### 5. 📤 Exportación de Datos (Derecho de Portabilidad - RGPD Art. 20)
**Estado**: ❌ **NO IMPLEMENTADO**  
**Prioridad**: 🟡 **ALTA**

**Qué falta:**
- [ ] Botón "Exportar mis datos" en perfil
- [ ] Generar archivo JSON/CSV con todos los datos del usuario:
  - Perfil
  - Favoritos
  - Eventos creados
  - Preferencias de notificaciones
- [ ] Enviar por email o descargar
- [ ] Formato legible y estructurado

**Implementación:**
```dart
// Servicio para exportar datos
Future<Map<String, dynamic>> exportUserData(String userId) async {
  // Obtener todos los datos del usuario
  // Generar JSON
  // Enviar por email o permitir descarga
}
```

---

### 6. 🚩 Sistema de Reporte de Contenido
**Estado**: ❌ **NO IMPLEMENTADO**  
**Prioridad**: 🟡 **ALTA**

**Qué falta:**
- [ ] Botón "Reportar evento" en detalle de evento
- [ ] Formulario de reporte con categorías:
  - Contenido inapropiado
  - Spam
  - Información falsa
  - Violación de derechos
  - Otro
- [ ] Guardar reportes en base de datos
- [ ] Notificar a administradores
- [ ] Proceso de revisión y moderación

**Tabla sugerida:**
```sql
CREATE TABLE public.content_reports (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  reported_by uuid REFERENCES auth.users(id),
  content_type text NOT NULL, -- 'event', 'venue', 'user'
  content_id uuid NOT NULL,
  reason text NOT NULL,
  description text,
  status text DEFAULT 'pending', -- 'pending', 'reviewed', 'resolved', 'dismissed'
  reviewed_by uuid REFERENCES auth.users(id),
  created_at timestamptz DEFAULT now()
);
```

---

### 7. 📧 Información de Contacto del Responsable
**Estado**: ❌ **NO IMPLEMENTADO**  
**Prioridad**: 🔴 **CRÍTICA**

**Qué falta:**
- [ ] Email de contacto para temas legales/privacidad
- [ ] Mostrar en Política de Privacidad
- [ ] Añadir en pantalla "Sobre la app" o "Contacto"
- [ ] Responder a solicitudes RGPD en 30 días

**Ubicación:**
- Política de Privacidad
- Términos y Condiciones
- Pantalla "Sobre" / "Contacto" en la app

---

### 8. 🍪 Política de Cookies (si aplica)
**Estado**: ❌ **NO IMPLEMENTADO**  
**Prioridad**: 🟢 **MEDIA** (si usas web o analytics)

**Qué falta:**
- [ ] Identificar qué cookies/tecnologías se usan
- [ ] Documentar en Política de Privacidad
- [ ] Consentimiento de cookies (si hay web)
- [ ] Banner de cookies (si hay versión web)

**Nota**: Si solo es app móvil, puede no ser necesario, pero si usas:
- Google Analytics
- Firebase Analytics
- Tracking de terceros

Debes informarlo.

---

### 9. 👶 Verificación de Edad Mínima
**Estado**: ❌ **NO IMPLEMENTADO**  
**Prioridad**: 🟡 **ALTA**

**Qué falta:**
- [ ] Verificar edad mínima (13-16 años según país)
- [ ] En registro, solicitar fecha de nacimiento
- [ ] Bloquear registro si es menor de edad
- [ ] Obtener consentimiento de padres si es menor

**RGPD**: En España, edad mínima es 14 años para consentimiento sin padres.

---

### 10. 📱 Avisos Legales en la App
**Estado**: ❌ **NO IMPLEMENTADO**  
**Prioridad**: 🟡 **ALTA**

**Qué falta:**
- [ ] Pantalla "Sobre la app" con:
  - Versión de la app
  - Información del desarrollador
  - Enlaces a Política de Privacidad
  - Enlaces a Términos y Condiciones
  - Email de contacto
  - Copyright

**Ubicación:**
- Menú de perfil → "Sobre QuePlan"
- Footer en pantallas principales

---

## 🟡 REQUISITOS IMPORTANTES - RECOMENDADOS

### 11. 🔔 Consentimiento Explícito para Notificaciones
**Estado**: ⚠️ **PARCIAL** (solicita permiso, pero falta explicación)

**Qué falta:**
- [ ] Explicar para qué se usan las notificaciones
- [ ] Consentimiento explícito antes de activar
- [ ] Opción de desactivar fácilmente
- [ ] Informar sobre tipos de notificaciones

---

### 12. 📊 Registro de Actividades de Tratamiento (RGPD Art. 30)
**Estado**: ❌ **NO IMPLEMENTADO**  
**Prioridad**: 🟢 **MEDIA**

**Qué falta:**
- [ ] Documentar qué datos se procesan
- [ ] Finalidad del tratamiento
- [ ] Categorías de datos
- [ ] Categorías de destinatarios
- [ ] Plazos de conservación
- [ ] Medidas de seguridad

**Nota**: Esto es más para documentación interna, pero es obligatorio.

---

### 13. 🔒 Medidas de Seguridad Documentadas
**Estado**: ⚠️ **PARCIAL** (RLS implementado, falta documentar)

**Qué falta:**
- [ ] Documentar medidas de seguridad implementadas
- [ ] Encriptación de datos
- [ ] Acceso restringido
- [ ] Backups
- [ ] Procedimientos de respuesta a brechas

---

## 📋 CHECKLIST LEGAL COMPLETO

### Documentos Requeridos
- [ ] Política de Privacidad (URL pública)
- [ ] Términos y Condiciones (URL pública)
- [ ] Aviso Legal (si aplica)
- [ ] Política de Cookies (si aplica)

### Funcionalidades en la App
- [ ] Consentimiento GDPR explícito
- [ ] Enlaces a documentos legales
- [ ] Eliminación de cuenta
- [ ] Exportación de datos
- [ ] Reporte de contenido
- [ ] Verificación de edad
- [ ] Información de contacto
- [ ] Pantalla "Sobre la app"

### Cumplimiento RGPD
- [ ] Base legal documentada
- [ ] Derechos del usuario implementados
- [ ] Registro de actividades
- [ ] Medidas de seguridad documentadas
- [ ] Procedimiento de respuesta a brechas

### Stores (Google Play / App Store)
- [ ] Política de Privacidad enlazada
- [ ] Términos enlazados
- [ ] Información de contacto
- [ ] Categoría de edad correcta
- [ ] Permisos justificados

---

## 🚀 PLAN DE IMPLEMENTACIÓN SUGERIDO

### Fase 1: Documentos Legales (1-2 días)
1. Crear Política de Privacidad
2. Crear Términos y Condiciones
3. Hostear en URL pública (GitHub Pages, Netlify, o dominio propio)

### Fase 2: Funcionalidades Críticas (3-5 días)
1. Pantalla de consentimiento GDPR
2. Eliminación de cuenta
3. Exportación de datos
4. Sistema de reportes

### Fase 3: UI/UX Legal (1-2 días)
1. Añadir enlaces en perfil
2. Pantalla "Sobre la app"
3. Avisos en registro

### Fase 4: Verificación (1 día)
1. Revisar cumplimiento RGPD
2. Probar todas las funcionalidades
3. Verificar enlaces y documentos

---

## 📚 RECURSOS ÚTILES

### Plantillas y Generadores
- [Privacy Policy Generator](https://www.privacypolicygenerator.info/)
- [Terms of Service Generator](https://www.termsofservicegenerator.net/)
- [GDPR Compliance Checklist](https://gdpr.eu/checklist/)

### Documentación RGPD
- [RGPD Oficial (UE)](https://eur-lex.europa.eu/legal-content/ES/TXT/?uri=CELEX:32016R0679)
- [AEPD - Guía RGPD](https://www.aepd.es/es/guias/guia-rgpd.pdf)

### Para Apps Móviles
- [Google Play - Política de Privacidad](https://support.google.com/googleplay/android-developer/answer/10787469)
- [Apple App Store - Política de Privacidad](https://developer.apple.com/app-store/review/guidelines/#privacy)

---

## ⚠️ ADVERTENCIA IMPORTANTE

**NO publiques la app en las stores sin:**
1. ✅ Política de Privacidad
2. ✅ Términos y Condiciones
3. ✅ Consentimiento GDPR
4. ✅ Eliminación de cuenta
5. ✅ Información de contacto

**Riesgos de no cumplir:**
- ❌ Rechazo en Google Play Store
- ❌ Rechazo en Apple App Store
- ❌ Multas por incumplimiento RGPD (hasta 4% facturación o 20M€)
- ❌ Demandas de usuarios
- ❌ Pérdida de confianza

---

## 📝 NOTAS ADICIONALES

### Si operas desde España:
- Debes cumplir con **RGPD** (Reglamento General de Protección de Datos)
- Debes cumplir con **LOPDGDD** (Ley Orgánica de Protección de Datos)
- Puede ser necesario registrar el fichero en la AEPD (si aplica)

### Si operas desde otros países UE:
- RGPD aplica igualmente
- Verificar requisitos específicos del país

### Si operas fuera de UE:
- Verificar leyes locales de privacidad
- RGPD puede aplicar si tienes usuarios en UE

---

**Última actualización**: Diciembre 2024  
**Prioridad**: 🔴 **CRÍTICA** - Implementar antes de publicar en stores

