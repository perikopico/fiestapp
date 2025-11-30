# ✅ Checklist de Testing Rápido

## 🔍 Verificación de Código (Automática)

### ✅ Status de Eventos
- [x] `lib/services/event_service.dart:520` - Eventos siempre con `status='pending'`
- [x] Verificado: No hay otros lugares donde se creen eventos sin status

### ✅ Status de Lugares
- [x] `lib/services/venue_service.dart:78` - Lugares siempre con `status='pending'`
- [x] Verificado: No hay otros lugares donde se creen lugares sin status

### ✅ Validación de Duplicados
- [x] `lib/ui/common/venue_search_field.dart` - Verifica lugares similares antes de crear
- [x] `lib/ui/events/event_submit_screen.dart` - Verifica eventos similares antes de crear
- [x] `lib/ui/admin/widgets/possible_duplicates_section.dart` - Muestra eventos similares al admin

### ✅ Google Places API
- [x] `lib/services/google_places_service.dart` - Lee API key desde `.env`
- [x] `lib/ui/common/venue_search_field.dart` - Integra búsqueda de Google Places
- [x] Verificado: Fallback a API legacy implementado

---

## 🧪 Testing Manual (Hacer en dispositivo)

### Test 1: Crear Evento Completo ⏳
**Tiempo estimado**: 5 minutos

1. [ ] Abrir app como usuario normal
2. [ ] Ir a "Crear evento"
3. [ ] Completar formulario:
   - [ ] Título: "Test Evento"
   - [ ] Ciudad: Seleccionar "Barbate"
   - [ ] Categoría: Seleccionar una
   - [ ] Lugar: Escribir "El Campero"
   - [ ] Fecha: Seleccionar fecha futura
   - [ ] Descripción: Escribir descripción
4. [ ] Click en "Crear evento"
5. [ ] Verificar mensaje de éxito
6. [ ] Verificar que aparece en "Mis Eventos" como "Pendiente"

**Resultado esperado**: ✅ Evento creado con status='pending'

---

### Test 2: Detección de Lugares Similares ⏳
**Tiempo estimado**: 3 minutos

1. [ ] Crear un lugar: "Restaurante Test" en Barbate
2. [ ] Intentar crear otro lugar: "Restaurante Test" en Barbate
3. [ ] Verificar que aparece diálogo con lugar similar
4. [ ] Opción A: Seleccionar lugar existente → Verificar que no se crea duplicado
5. [ ] Opción B: Crear nuevo lugar → Verificar que se crea con status='pending'

**Resultado esperado**: ✅ Diálogo aparece, permite evitar duplicados

---

### Test 3: Detección de Eventos Duplicados ⏳
**Tiempo estimado**: 3 minutos

1. [ ] Crear evento: "Feria Test" el 15 de agosto en Barbate
2. [ ] Intentar crear evento similar: "Feria Test" el 15 de agosto en Barbate
3. [ ] Verificar que aparece diálogo con eventos similares
4. [ ] Opción A: Cancelar → Verificar que no se crea evento
5. [ ] Opción B: "Crear de todas formas" → Verificar que se crea con status='pending'

**Resultado esperado**: ✅ Diálogo aparece, permite evitar duplicados

---

### Test 4: Google Places API ⏳
**Tiempo estimado**: 5 minutos

1. [ ] En "Crear evento", seleccionar ciudad "Barbate"
2. [ ] En "Lugar", escribir: "embarcadero"
3. [ ] Esperar 1-2 segundos
4. [ ] Verificar sugerencias:
   - [ ] Si API está habilitada: Aparecen sugerencias con icono azul de mapa
   - [ ] Si API no está habilitada: Solo aparece opción de crear lugar nuevo
5. [ ] Si hay sugerencias: Seleccionar una
6. [ ] Verificar que se crea lugar con coordenadas

**Resultado esperado**: ✅ Sugerencias aparecen (si API habilitada) o se puede crear manualmente

---

### Test 5: Panel Admin - Revisar Evento Pendiente ⏳
**Tiempo estimado**: 5 minutos

1. [ ] Iniciar sesión como admin
2. [ ] Ir a "Panel de administración" > "Pendientes"
3. [ ] Verificar que aparecen eventos con status='pending'
4. [ ] Abrir un evento pendiente
5. [ ] Verificar sección "Eventos similares encontrados" al inicio
6. [ ] Si el evento tiene venue_id, verificar que se muestra:
   - [ ] Nombre del lugar
   - [ ] Estado del lugar (Aprobado/Pendiente/Rechazado) con color
   - [ ] Dirección del lugar (si existe)
7. [ ] Hacer clic en un evento similar → Verificar que abre detalles
8. [ ] Probar aprobar evento → Verificar que cambia a "Publicado"
9. [ ] Probar rechazar evento → Verificar que cambia a "Rechazado"

**Resultado esperado**: ✅ Admin ve toda la información necesaria para tomar decisión

---

### Test 6: Flujo Completo Usuario → Admin ⏳
**Tiempo estimado**: 10 minutos

1. [ ] **Como usuario normal**:
   - [ ] Crear evento con lugar nuevo
   - [ ] Verificar que aparece en "Mis Eventos" como "Pendiente"
2. [ ] **Como admin**:
   - [ ] Ir a "Panel de administración" > "Pendientes"
   - [ ] Verificar que aparece el evento creado
   - [ ] Abrir evento → Verificar eventos similares y estado del venue
   - [ ] Aprobar evento
3. [ ] **Como usuario normal**:
   - [ ] Ir a "Mis Eventos"
   - [ ] Verificar que el evento aparece como "Aprobado" o "Publicado"

**Resultado esperado**: ✅ Flujo completo funciona correctamente

---

## 🐛 Problemas Conocidos

### Google Places API
- **Síntoma**: No aparecen sugerencias de Google Places
- **Causa posible**: API no habilitada en Google Cloud Console
- **Solución**: Habilitar "Places API (New)" en Google Cloud Console
- **Verificar**: Revisar logs en terminal para ver errores de API

### API Key
- **Síntoma**: Error al cargar mapa o buscar lugares
- **Causa posible**: API key no configurada en `.env` o `android/local.properties`
- **Solución**: Añadir `GOOGLE_MAPS_API_KEY=...` a ambos archivos
- **Verificar**: Revisar que la key esté en ambos archivos

---

## 📊 Resumen de Testing

| Test | Estado | Notas |
|------|--------|-------|
| Test 1: Crear Evento | ⏳ Pendiente | |
| Test 2: Lugares Similares | ⏳ Pendiente | |
| Test 3: Eventos Duplicados | ⏳ Pendiente | |
| Test 4: Google Places | ⏳ Pendiente | |
| Test 5: Panel Admin | ⏳ Pendiente | |
| Test 6: Flujo Completo | ⏳ Pendiente | |

---

## ✅ Criterios de Éxito

- [ ] Todos los eventos nuevos tienen `status='pending'`
- [ ] Todos los lugares nuevos tienen `status='pending'`
- [ ] Los diálogos de duplicados aparecen correctamente
- [ ] El panel admin muestra información completa
- [ ] Google Places funciona (o muestra error claro si no está habilitada)
- [ ] El flujo completo usuario → admin funciona

---

**Fecha de testing**: [Completar]  
**Tester**: [Completar]  
**Dispositivo**: [Completar]  
**Versión**: [Completar]

