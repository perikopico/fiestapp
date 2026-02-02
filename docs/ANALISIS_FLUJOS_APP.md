# Análisis de Flujos y Optimización de la App QuePlan

> Revisión de ambigüedades, pestañas redundantes, código muerto y oportunidades de mejora.
>
> **Estado**: Recomendaciones aplicadas (2026-02).

---

## 1. Resumen Ejecutivo

| Área | Problema | Estado |
|------|----------|--------|
| Eventos | `EventSubmitScreen` no se usa | ✅ Eliminado |
| Admin | `AdminDashboardScreen` no se usa | ✅ Conectado como hub desde Profile |
| Notificaciones | 3 pantallas con solapamiento | ✅ AlertsScreen eliminada, unificado en Settings |
| Onboarding | `NotificationPreferencesScreen` ≈ `NotificationSettingsScreen` | ✅ Redirige a NotificationSettingsScreen(isOnboarding: true) |
| Perfil | Duplicación de accesos | ✅ Admin unificado, sección "Mis venues" |
| Bottom nav | Textos largos | ✅ Solo iconos, ancho reducido, efecto espejo |

---

## 2. Código Muerto o Huérfano

### 2.1 EventSubmitScreen

**Ubicación**: `lib/ui/events/event_submit_screen.dart`  
**Estado**: No referenciado en ninguna navegación. Solo se usa `EventWizardScreen` desde el bottom nav (botón "Crear").

- **EventWizardScreen**: Wizard de 6 pasos (ubicación → info → fecha → categoría → imagen → resumen). Es el flujo activo.
- **EventSubmitScreen**: Formulario alternativo (probablemente legacy). Nunca se navega a él.

**Recomendación**: Si no hay plan de reactivarlo, eliminar `EventSubmitScreen` para reducir mantenimiento. Si se quiere conservar como alternativa, documentar y añadir un enlace desde alguna parte (p. ej. en Profile para admins o como "Modo avanzado").

---

### 2.2 AdminDashboardScreen

**Ubicación**: `lib/ui/admin/admin_dashboard_screen.dart`  
**Estado**: No se usa. El admin entra directo a `PendingEventsScreen` desde Profile ("Panel de administración").

`AdminDashboardScreen` tiene gráficos y estadísticas (eventos por categoría, por mes, pendientes, usuarios activos). Es una pantalla de analytics que nunca se muestra.

**Recomendación**:
- Opción A: Hacer que "Panel de administración" abra primero `AdminDashboardScreen` con un botón para ir a eventos pendientes.
- Opción B: Eliminar `AdminDashboardScreen` si las estadísticas no aportan valor.
- Opción C: Usar `AdminDashboardScreen` como "hub" del admin con tarjetas a: Eventos pendientes, Lugares pendientes, Solicitudes, Ingesta JSON, etc.

---

## 3. Notificaciones: Solapamiento y Ambigüedad

### 3.1 Pantallas implicadas

| Pantalla | Acceso | Función |
|----------|--------|---------|
| **NotificationsScreen** | Tab "Notis" | Contenedor: Buzón (NotificationsInboxScreen) + botón Configurar |
| **NotificationsInboxScreen** | Contenido del tab Notis | Lista de notificaciones (historial) |
| **NotificationSettingsScreen** | Tab Notis → Configurar / Profile → Preferencias | Ciudades + categorías para FCM topics |
| **AlertsScreen** | Profile → Mis Alertas | Activar/desactivar alertas por categoría (NotificationAlertsService) |

### 3.2 Problema: Dos sistemas de preferencias

1. **NotificationSettingsScreen** + **FCMTopicService**  
   - Suscripción a topics FCM (`city_barbate`, `category_deportes`, etc.).  
   - El backend envía push a esos topics.  
   - Es el sistema que realmente controla las notificaciones push.

2. **AlertsScreen** + **NotificationAlertsService**  
   - Guarda preferencias por categoría en SharedPreferences (solo local).  
   - No está claro que el backend las use para enviar notificaciones.

**Riesgo**: El usuario puede activar "alertas" en AlertsScreen pensando que afecta a las push, cuando el control real está en NotificationSettingsScreen.

**Recomendación**: Unificar en una sola pantalla de preferencias:
- Una pantalla que gestione ciudades y categorías usando FCMTopicService.
- Eliminar AlertsScreen o integrarla como pestaña/sección dentro de NotificationSettingsScreen.
- Revisar si NotificationAlertsService se usa en el backend; si no, considerarlo legacy y deprecarlo.

---

### 3.3 Duplicación de acceso

- **Profile** → "Preferencias de Notificaciones"  
- **Tab Notis** → "Configurar"

Ambos llevan a `NotificationSettingsScreen`. Tener dos accesos puede ser útil (descubribilidad), pero conviene etiquetas consistentes ("Preferencias" o "Configurar notificaciones") para evitar confusión.

---

## 4. Perfil: Densidad y Duplicación

### 4.1 Opciones actuales (usuario autenticado)

- Tema (claro/oscuro/automático)
- Preferencias de Notificaciones
- Mis Alertas
- [Admin] Panel de administración, Ingesta JSON, Lugares pendientes, Solicitudes
- [Venue owner] Mis locales, Mis eventos de venues
- Mis favoritos
- Mis eventos creados
- Solicitar ser propietario
- Verificar código de propiedad
- Legal: Privacidad, Términos, Consentimientos, Exportar datos
- Información: Sobre QuePlan

### 4.2 Duplicación

- **Mis favoritos**: También accesible desde el tab "Fav". Es intencional (dos puntos de entrada) y coherente.

### 4.3 Posible simplificación

- Agrupar "Preferencias de Notificaciones" y "Mis Alertas" en una sola sección "Notificaciones" que lleve a una pantalla unificada.
- Para admins: considerar un submenú "Administración" con todas las opciones admin en un solo nivel.
- Para venue owners: agrupar "Mis locales" y "Mis eventos de venues" bajo "Mis venues".

---

## 5. Bottom Navigation Bar

### 5.1 Ítems actuales

| Ítem | Label | Destino |
|------|-------|---------|
| 1 | Inicio | Dashboard |
| 2 | Fav | FavoritesScreen |
| 3 | Crear | EventWizardScreen |
| 4 | Notis | NotificationsScreen (buzón + configurar) |
| 5 | Cuenta | ProfileScreen |

### 5.2 Abreviaturas

- "Fav" y "Notis" son cortas pero pueden no ser obvias para nuevos usuarios.
- Alternativas: "Favoritos" / "Notificaciones" (más claras, ocupan más espacio) o mantener abreviaturas con tooltips/accessibility labels.

---

## 6. Onboarding de Notificaciones

- **PermissionsOnboardingScreen**: Permisos de notificaciones y ubicación.  
- **NotificationPreferencesScreen**: Selección de ciudades y categorías tras el onboarding.  
- **NotificationSettingsScreen**: Misma lógica (ciudades + categorías) usada más tarde.

`NotificationPreferencesScreen` y `NotificationSettingsScreen` comparten estructura y lógica (ciudades, categorías, FCMTopicService).

**Recomendación**: Extraer un widget/componente común (p. ej. `NotificationPreferencesContent`) y reutilizarlo en:
- Onboarding (NotificationPreferencesScreen)
- Configuración posterior (NotificationSettingsScreen)

---

## 7. Flujo de Venue Ownership

Secuencia de pantallas:

1. **RequestVenueOwnershipScreen** – Solicitar propiedad  
2. **EnterVerificationCodeScreen** – Código enviado por email  
3. **VerifyOwnershipScreen** – Verificación  
4. **MyVenuesScreen** – Mis locales  
5. **OwnerEventsScreen** – Eventos de mis venues  
6. **ClaimVenueScreen** – ¿Usado? (comprobar)

El flujo tiene sentido pero es largo. Posibles mejoras:

- Breadcrumbs o indicador de progreso (paso 1/3, etc.).
- En Profile, un único ítem "Gestionar mis venues" que lleve a MyVenuesScreen, y desde ahí a eventos y solicitudes.

---

## 8. Dashboard

- Una sola vista con scroll (sin tabs).
- Secciones: Hero/Banner, búsqueda, filtros (ciudad/radio), categorías, destacados, populares, próximos eventos.
- Estructura clara; no se detectan redundancias graves.

---

## 9. Plan de Acción Priorizado

### Prioridad alta

1. **Unificar notificaciones**
   - Revisar si NotificationAlertsService se usa en backend.
   - Si no: integrar AlertsScreen en NotificationSettingsScreen o eliminarla.
   - Dejar una única pantalla de preferencias de notificaciones.

2. **AdminDashboardScreen**
   - Decidir: usar como hub del admin o eliminarlo.
   - Si se usa: conectar desde Profile ("Panel de administración").

### Prioridad media

3. **EventSubmitScreen**
   - Eliminar si es código muerto, o documentar y enlazar si se planea usarlo.

4. **Componente común de preferencias**
   - Extraer `NotificationPreferencesContent` para evitar duplicación entre onboarding y settings.

### Prioridad baja

5. **Perfil**
   - Agrupar opciones (Notificaciones, Admin, Venues) para reducir ruido.

6. **Labels del bottom nav**
   - Evaluar "Favoritos" / "Notificaciones" o mejorar accesibilidad de "Fav" / "Notis".

7. **Flujo de venues**
   - Añadir indicadores de progreso o un punto de entrada único desde Profile.

---

## 10. Referencias de Código

- `EventSubmitScreen`: `lib/ui/events/event_submit_screen.dart` – no referenciado.
- `EventWizardScreen`: `lib/ui/events/event_wizard_screen.dart` – usado en bottom nav.
- `AdminDashboardScreen`: `lib/ui/admin/admin_dashboard_screen.dart` – no referenciado.
- `PendingEventsScreen`: `lib/ui/admin/pending_events_screen.dart` – usado desde Profile.
- `NotificationSettingsScreen`: `lib/ui/notifications/notification_settings_screen.dart`.
- `AlertsScreen`: `lib/ui/notifications/alerts_screen.dart`.
- `NotificationAlertsService`: `lib/services/notification_alerts_service.dart` – solo local.
- `FCMTopicService`: usado por NotificationSettingsScreen para topics FCM.
