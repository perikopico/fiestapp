# 🔍 Análisis de Localización y Textos Hardcodeados

## ⚠️ Problemas Identificados

### 1. **Textos Hardcodeados en UI** 🔴 CRÍTICO

#### Dashboard
- ❌ `'Todas'` - Aparece 8+ veces hardcodeado
- ❌ `'Todas las categorías'` - Hardcodeado
- ❌ `'Ver eventos destacados'` - Hardcodeado en hero_banner.dart
- ❌ Mensajes de permisos de ubicación (4+ instancias)
- ❌ Mensajes de error genéricos

**Archivos afectados:**
- `lib/ui/dashboard/dashboard_screen.dart` (múltiples)
- `lib/ui/dashboard/widgets/categories_grid.dart`
- `lib/ui/dashboard/widgets/hero_banner.dart`

#### Pantallas Legales
- ❌ `'Debes aceptar los Términos y la Política de Privacidad para continuar'`
- ❌ `'Consentimientos guardados correctamente'`
- ❌ `'Error al guardar'`
- ❌ `'Consentimiento de Datos'`
- ❌ `'Acepto los Términos y Condiciones'`
- ❌ `'Leer términos'`
- ❌ `'Acepto la Política de Privacidad'`
- ❌ `'Leer política de privacidad'`
- ❌ `'Ubicación'`, `'Notificaciones'`, `'Perfil y favoritos'`, `'Analytics'`
- ❌ `'Guardar y continuar'`
- ❌ `'Aceptar todo'`
- ❌ `'Sobre QuePlan'`
- ❌ `'Contacto'`
- ❌ `'Política de Privacidad'`
- ❌ `'Términos y Condiciones'`
- ❌ `'Gestionar consentimientos'`
- ❌ `'Modificar tus preferencias de privacidad'`

**Archivos afectados:**
- `lib/ui/legal/gdpr_consent_screen.dart`
- `lib/ui/legal/about_screen.dart`

#### ErrorHandlerService
- ❌ `'Error de conexión. Por favor, verifica tu conexión a internet.'`
- ❌ `'Se necesitan permisos para continuar...'`
- ❌ `'Error de autenticación. Por favor, inicia sesión nuevamente.'`
- ❌ `'Error al cargar los datos...'`
- ❌ `'Ha ocurrido un error inesperado...'`
- ❌ `'Reintentar'` (en botones)

**Archivo afectado:**
- `lib/services/error_handler_service.dart`

### 2. **Taglines Mensuales** 🟡 MEDIO

Los taglines mensuales están hardcodeados en español:
- `lib/ui/dashboard/dashboard_screen.dart` - `kMonthlyTaglines`

**Recomendación:** Mover a archivos de localización o mantener como constantes si son específicos del mercado español.

---

## ✅ Solución: Plan de Localización

### Fase 1: Agregar Strings a app_es.arb

```json
{
  "allCategories": "Todas",
  "@allCategories": {
    "description": "Etiqueta para mostrar todas las categorías"
  },
  "allCategoriesLabel": "Todas las categorías",
  "viewFeaturedEvents": "Ver eventos destacados",
  "enableLocationServices": "Por favor, activa los servicios de ubicación en Configuración para usar el modo Radio.",
  "locationPermissionsDisabled": "Los permisos de ubicación están deshabilitados. Por favor, habilítalos en Configuración para usar el modo Radio.",
  "locationPermissionRequired": "Se necesitan permisos de ubicación para usar el modo Radio.",
  "errorLoadingData": "Error al cargar datos: {error}",
  "@errorLoadingData": {
    "placeholders": {
      "error": {
        "type": "String"
      }
    }
  },
  "retry": "Reintentar",
  "errorConnection": "Error de conexión. Por favor, verifica tu conexión a internet.",
  "errorPermissions": "Se necesitan permisos para continuar. Por favor, verifica los permisos en la configuración.",
  "errorAuthentication": "Error de autenticación. Por favor, inicia sesión nuevamente.",
  "errorDatabase": "Error al cargar los datos. Por favor, intenta de nuevo más tarde.",
  "errorUnknown": "Ha ocurrido un error inesperado. Por favor, intenta de nuevo.",
  "mustAcceptTerms": "Debes aceptar los Términos y la Política de Privacidad para continuar",
  "consentsSaved": "Consentimientos guardados correctamente",
  "errorSaving": "Error al guardar: {error}",
  "@errorSaving": {
    "placeholders": {
      "error": {
        "type": "String"
      }
    }
  },
  "dataConsent": "Consentimiento de Datos",
  "acceptTerms": "Acepto los Términos y Condiciones",
  "readTerms": "Leer términos",
  "acceptPrivacy": "Acepto la Política de Privacidad",
  "readPrivacy": "Leer política de privacidad",
  "location": "Ubicación",
  "notifications": "Notificaciones",
  "profileAndFavorites": "Perfil y favoritos",
  "analytics": "Analytics",
  "saveAndContinue": "Guardar y continuar",
  "acceptAll": "Aceptar todo",
  "aboutQuePlan": "Sobre QuePlan",
  "contact": "Contacto",
  "privacyPolicy": "Política de Privacidad",
  "termsAndConditions": "Términos y Condiciones",
  "manageConsents": "Gestionar consentimientos",
  "modifyPrivacyPreferences": "Modificar tus preferencias de privacidad"
}
```

### Fase 2: Reemplazar Textos Hardcodeados

1. **Dashboard widgets** → Usar `AppLocalizations.of(context)!.allCategories`
2. **ErrorHandlerService** → Pasar `BuildContext` y usar localización
3. **Pantallas legales** → Usar localización en todos los textos

### Fase 3: Traducciones a otros idiomas

Agregar las mismas keys a:
- `app_en.arb` (Inglés)
- `app_de.arb` (Alemán)
- `app_zh.arb` (Chino)

---

## 🎯 Prioridad de Implementación

### 🔴 Alta Prioridad
1. ErrorHandlerService - Mensajes de error críticos
2. Dashboard - "Todas" y mensajes principales
3. Pantallas legales - Textos importantes para RGPD

### 🟡 Media Prioridad
4. Taglines mensuales (si se quiere internacionalizar)
5. Mensajes de permisos

### 🟢 Baja Prioridad
6. Textos decorativos
7. Mensajes de depuración

---

## 📝 Notas

- El sistema de localización ya existe (`AppLocalizations`)
- Solo falta **usarlo consistentemente** en todo el código
- Algunos textos podrían quedarse en español si son específicos del mercado local
- ErrorHandlerService necesita refactor para recibir `BuildContext`

---

**Fecha**: $(date)
