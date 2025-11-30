# 🧪 Plan de Testing - Sistema de Moderación y Validación

**Fecha**: Diciembre 2024  
**Objetivo**: Verificar que el sistema de moderación, validación de duplicados y Google Maps funcionan correctamente

---

## ✅ Checklist de Verificación de Código

### 1. Sistema de Moderación

#### ✅ Eventos siempre con status='pending'
- [x] `lib/services/event_service.dart` línea 520: `'status': 'pending'`
- [x] Verificado: Todos los eventos nuevos se crean como pendientes

#### ✅ Lugares siempre con status='pending'
- [x] `lib/services/venue_service.dart` línea 78: `'status': 'pending'`
- [x] Verificado: Todos los lugares nuevos se crean como pendientes

#### ✅ Panel Admin muestra eventos pendientes
- [x] `lib/ui/admin/pending_events_screen.dart`: Filtra por `status='pending'`
- [x] Verificado: Query correcta implementada

#### ✅ Panel Admin muestra estado de venues
- [x] `lib/ui/admin/pending_events_screen.dart`: Incluye información de venues
- [x] Verificado: Widget `_buildVenueInfo` implementado

---

### 2. Validación de Duplicados

#### ✅ Detección de lugares similares
- [x] `lib/ui/common/venue_search_field.dart`: Llama a `findSimilarVenues` antes de crear
- [x] Verificado: Diálogo implementado con opciones

#### ✅ Detección de eventos duplicados
- [x] `lib/ui/events/event_submit_screen.dart`: Llama a `getPotentialDuplicateEvents` antes de crear
- [x] Verificado: Diálogo implementado con eventos similares

#### ✅ Eventos similares en panel admin
- [x] `lib/ui/admin/widgets/possible_duplicates_section.dart`: Muestra eventos similares
- [x] Verificado: Widget mejorado con mejor UI

---

### 3. Google Maps y Places API

#### ✅ API Key en variables de entorno
- [x] `lib/services/google_places_service.dart`: Lee desde `.env`
- [x] `lib/ui/events/event_submit_screen.dart`: Lee desde `.env`
- [x] `android/app/src/main/AndroidManifest.xml`: Usa API key (necesario para Maps SDK)

#### ✅ Búsqueda de lugares con Google Places
- [x] `lib/services/google_places_service.dart`: Implementa Places API (New)
- [x] `lib/ui/common/venue_search_field.dart`: Integra búsqueda de Google Places
- [x] Verificado: Fallback a API legacy implementado

#### ✅ Creación de lugares con coordenadas
- [x] `lib/ui/common/venue_search_field.dart`: Busca coordenadas antes de crear
- [x] Verificado: Guarda lat/lng cuando encuentra el lugar en Google Places

---

## 🧪 Casos de Prueba Manuales

### Test 1: Crear Evento con Lugar Nuevo
**Pasos**:
1. Iniciar sesión como usuario normal
2. Ir a "Crear evento"
3. Seleccionar ciudad: "Barbate"
4. En "Lugar", escribir: "El Campero"
5. Verificar que aparecen sugerencias de Google Places (si la API está habilitada)
6. Si no hay sugerencias, crear lugar nuevo
7. Completar formulario y crear evento

**Resultado esperado**:
- ✅ Lugar se crea con `status='pending'`
- ✅ Evento se crea con `status='pending'`
- ✅ Si hay lugares similares, se muestra diálogo
- ✅ Si hay eventos similares, se muestra diálogo

---

### Test 2: Crear Evento con Lugar Existente
**Pasos**:
1. Iniciar sesión como usuario normal
2. Ir a "Crear evento"
3. Seleccionar ciudad: "Barbate"
4. En "Lugar", escribir nombre de lugar existente
5. Seleccionar lugar de la lista

**Resultado esperado**:
- ✅ Lugar se selecciona correctamente
- ✅ Evento se crea con `venue_id` del lugar seleccionado
- ✅ Evento se crea con `status='pending'`

---

### Test 3: Admin Revisa Evento Pendiente
**Pasos**:
1. Iniciar sesión como admin
2. Ir a "Panel de administración" > "Pendientes"
3. Abrir un evento pendiente
4. Revisar información

**Resultado esperado**:
- ✅ Se muestra sección de "Eventos similares encontrados" al inicio
- ✅ Si el evento tiene `venue_id`, se muestra estado del venue (Aprobado/Pendiente/Rechazado)
- ✅ Se puede hacer clic en eventos similares para ver detalles
- ✅ Se pueden aprobar/rechazar eventos

---

### Test 4: Detección de Lugares Similares
**Pasos**:
1. Crear un lugar: "Restaurante El Campero" en Barbate
2. Intentar crear otro lugar: "El Campero" en Barbate
3. Verificar diálogo

**Resultado esperado**:
- ✅ Se muestra diálogo con lugar similar encontrado
- ✅ Se puede seleccionar lugar existente o crear nuevo
- ✅ Si se crea nuevo, se crea con `status='pending'`

---

### Test 5: Detección de Eventos Duplicados
**Pasos**:
1. Crear evento: "Feria de Barbate 2024" el 15 de agosto
2. Intentar crear evento similar: "Feria Barbate" el 15 de agosto
3. Verificar diálogo

**Resultado esperado**:
- ✅ Se muestra diálogo con eventos similares
- ✅ Se puede cancelar o crear de todas formas
- ✅ Si se crea, se crea con `status='pending'`

---

### Test 6: Google Places API
**Pasos**:
1. En "Crear evento", seleccionar ciudad
2. En "Lugar", escribir: "embarcadero"
3. Verificar sugerencias

**Resultado esperado**:
- ✅ Si la API está habilitada, aparecen sugerencias de Google Places
- ✅ Las sugerencias tienen icono azul de mapa
- ✅ Al seleccionar, se crea lugar con coordenadas automáticamente
- ✅ Si la API falla, se muestra opción de crear lugar manualmente

---

## 🔍 Verificaciones Técnicas

### Verificar que no hay eventos creados sin status
```dart
// Buscar en código:
grep -r "from('events').insert" lib/
// Verificar que siempre incluye 'status': 'pending'
```

### Verificar que no hay lugares creados sin status
```dart
// Buscar en código:
grep -r "from('venues').insert" lib/
// Verificar que siempre incluye 'status': 'pending'
```

### Verificar queries de admin
```dart
// Verificar que filtran por status='pending'
grep -r "eq('status', 'pending')" lib/ui/admin/
```

---

## 📋 Checklist de Testing Manual

### Flujo Completo Usuario → Admin

- [ ] Usuario crea evento → Evento aparece en "Pendientes" del admin
- [ ] Admin ve evento pendiente → Ve eventos similares
- [ ] Admin ve evento pendiente → Ve estado del venue (si existe)
- [ ] Admin aprueba evento → Evento aparece como "Publicado"
- [ ] Admin rechaza evento → Evento aparece como "Rechazado"
- [ ] Usuario ve sus eventos → Ve estado (Pendiente/Aprobado/Rechazado)

### Validación de Duplicados

- [ ] Crear lugar similar → Aparece diálogo con lugares similares
- [ ] Crear evento similar → Aparece diálogo con eventos similares
- [ ] Seleccionar lugar existente → No se crea duplicado
- [ ] Cancelar creación → No se crea nada

### Google Maps y Places

- [ ] Búsqueda de lugar → Aparecen sugerencias de Google Places
- [ ] Seleccionar sugerencia de Google → Se crea lugar con coordenadas
- [ ] Crear lugar manualmente → Se buscan coordenadas automáticamente
- [ ] Abrir mapa → Muestra ubicación correcta del lugar

---

## 🐛 Problemas Conocidos a Verificar

1. **Google Places API**: Verificar que esté habilitada en Google Cloud Console
2. **API Key**: Verificar que esté en `.env` y `android/local.properties`
3. **Permisos de ubicación**: Verificar en Android/iOS
4. **Conexión a Supabase**: Verificar que las queries funcionan

---

## 📝 Notas de Testing

- **Fecha de testing**: [Pendiente]
- **Tester**: [Pendiente]
- **Dispositivo**: [Pendiente]
- **Versión de app**: [Pendiente]

### Resultados

#### Test 1: [Pendiente]
- Estado: ⏳
- Notas: 

#### Test 2: [Pendiente]
- Estado: ⏳
- Notas: 

#### Test 3: [Pendiente]
- Estado: ⏳
- Notas: 

---

## ✅ Criterios de Aceptación

Para considerar el testing completo, se deben cumplir:

1. ✅ Todos los eventos nuevos tienen `status='pending'`
2. ✅ Todos los lugares nuevos tienen `status='pending'`
3. ✅ Los admins pueden ver eventos pendientes
4. ✅ Los admins ven eventos similares al revisar
5. ✅ Los usuarios ven diálogo de lugares similares antes de crear
6. ✅ Los usuarios ven diálogo de eventos similares antes de crear
7. ✅ Google Places API funciona (o muestra error claro si no está habilitada)
8. ✅ Los lugares se crean con coordenadas cuando se encuentran en Google Places

---

**Última actualización**: Diciembre 2024

