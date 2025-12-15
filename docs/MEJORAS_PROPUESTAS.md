# Propuestas de Mejora - Resumen de Cambios

## 📋 Resumen de Cambios Realizados

### 1. Eliminación de alineación de imagen (✅ Completado)
- **Archivo**: `lib/ui/events/wizard_steps/step5_image.dart`
- **Cambio**: Se eliminó la funcionalidad de alineación de imagen ya que el usuario selecciona la parte de la imagen al recortarla
- **Estado**: ✅ Funciona correctamente

### 2. Sistema de lugares/venues mejorado (✅ Completado)
- **Archivos**: 
  - `lib/ui/common/venue_search_field.dart`
  - `lib/services/venue_service.dart`
  - `lib/ui/events/wizard_steps/step3_location.dart`
- **Cambios**:
  - Permite usar lugares pendientes sin error
  - Eliminado campo duplicado de "nombre del lugar"
  - Búsqueda mejorada: primero BD, luego Google Maps, mensaje cuando no se encuentra
  - Incluye lugares pendientes del usuario en búsquedas
- **Estado**: ✅ Funciona correctamente

### 3. Panel de administración - Fix de carga de eventos (✅ Completado)
- **Archivo**: `lib/ui/admin/pending_events_screen.dart`
- **Problema**: Error al intentar hacer join anidado desde `events_view` a `venues`
- **Solución**: Separar la carga de venues y combinarlos después
- **Estado**: ✅ Funciona correctamente

### 4. Detección inteligente de lugares similares (✅ SQL creado, pendiente ejecutar)
- **Archivo**: `docs/migrations/006_improve_similar_venues_function.sql`
- **Mejora**: Elimina palabras comunes antes de comparar (restaurante, pub, bar, etc.)
- **Estado**: ⚠️ Pendiente ejecutar en Supabase

---

## 🚀 Mejoras Propuestas

### A. Optimizaciones de Rendimiento

#### 1. **Cache de búsqueda de venues**
**Problema**: Cada búsqueda hace múltiples consultas a la BD (aprobados + pendientes del usuario)

**Mejora**:
```dart
// En venue_service.dart
class VenueService {
  // Cache temporal de búsquedas recientes
  final Map<String, List<Venue>> _searchCache = {};
  DateTime? _lastCacheClear;
  
  Future<List<Venue>> searchVenues({...}) async {
    // Limpiar cache cada 5 minutos
    if (_lastCacheClear == null || 
        DateTime.now().difference(_lastCacheClear!) > Duration(minutes: 5)) {
      _searchCache.clear();
      _lastCacheClear = DateTime.now();
    }
    
    final cacheKey = '$query-$cityId';
    if (_searchCache.containsKey(cacheKey)) {
      return _searchCache[cacheKey]!;
    }
    
    // ... búsqueda actual ...
    
    _searchCache[cacheKey] = venues;
    return venues;
  }
}
```

#### 2. **Optimizar consulta de lugares similares en admin**
**Problema**: Se llama `findSimilarVenues` para cada lugar pendiente individualmente

**Mejora**:
```dart
// En pending_venues_screen.dart
// Cargar todos los lugares pendientes de una vez y hacer una sola llamada
// a findSimilarVenues en batch o con un IN clause
```

#### 3. **Debounce más inteligente en búsqueda**
**Problema**: El debounce de 400ms puede ser demasiado corto para búsquedas largas

**Mejora**:
```dart
// En venue_search_field.dart
// Ajustar debounce según longitud del texto:
// - 1-2 caracteres: 800ms (esperar más antes de buscar)
// - 3+ caracteres: 400ms (búsqueda normal)
```

---

### B. Mejoras de UX/UI

#### 1. **Indicador visual mejorado para lugares pendientes**
**Problema**: El usuario no siempre ve claramente que un lugar está pendiente

**Mejora**:
```dart
// En venue_search_field.dart - Mejorar el mensaje de "lugar desconocido"
// Añadir un icono más claro y explicar mejor el proceso
Widget _buildUnknownVenueOption() {
  return Card(
    margin: EdgeInsets.all(8),
    color: Theme.of(context).colorScheme.surfaceContainerHighest,
    child: ExpansionTile(
      leading: Icon(Icons.help_outline, color: Colors.orange),
      title: Text('Lugar desconocido: "${_query.trim()}"'),
      subtitle: Text('No encontrado en nuestros locales ni en Google Maps'),
      children: [
        Padding(
          padding: EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('¿Qué pasará?'),
              SizedBox(height: 8),
              Text('• Se creará el lugar con estado "Pendiente"'),
              Text('• Un administrador lo revisará y aprobará'),
              Text('• Recibirás una notificación cuando sea aprobado'),
              SizedBox(height: 16),
              ElevatedButton(
                onPressed: _createNewVenue,
                child: Text('Crear lugar y continuar'),
              ),
            ],
          ),
        ),
      ],
    ),
  );
}
```

#### 2. **Mejor feedback al crear lugar desde Google Maps**
**Problema**: El usuario no sabe claramente qué lugar se va a crear

**Mejora**:
```dart
// En venue_search_field.dart - Antes de crear desde Google Place
// Mostrar un diálogo de confirmación con detalles:
Future<void> _confirmCreateFromGooglePlace(GooglePlace place) async {
  final confirmed = await showDialog<bool>(
    context: context,
    builder: (context) => AlertDialog(
      title: Text('Crear lugar desde Google Maps'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Nombre: ${place.name}'),
          if (place.address != null) 
            Text('Dirección: ${place.address}'),
          if (place.lat != null && place.lng != null)
            Text('Ubicación: ${place.lat}, ${place.lng}'),
          SizedBox(height: 16),
          Text(
            'El lugar se creará como "Pendiente" y será revisado por un administrador.',
            style: TextStyle(fontSize: 12, fontStyle: FontStyle.italic),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context, false),
          child: Text('Cancelar'),
        ),
        ElevatedButton(
          onPressed: () => Navigator.pop(context, true),
          child: Text('Crear lugar'),
        ),
      ],
    ),
  );
  
  if (confirmed == true) {
    await _createVenueFromGooglePlace(place);
  }
}
```

#### 3. **Filtro de lugares por estado en búsqueda**
**Problema**: El usuario no puede filtrar para ver solo lugares aprobados vs pendientes

**Mejora**:
```dart
// Añadir un toggle/chip para filtrar:
// - Todos los lugares
// - Solo aprobados
// - Solo mis lugares pendientes
```

---

### C. Mejoras de Lógica de Negocio

#### 1. **Mejorar normalización de nombres en createVenue**
**Problema**: La verificación de duplicados es exacta (case-sensitive con espacios)

**Mejora**:
```dart
// En venue_service.dart - Usar la misma función normalize_venue_name
// para verificar duplicados (o crear una versión Dart equivalente)

// Usar RPC call a la función SQL para normalización consistente
Future<Venue?> _findExistingVenueNormalized(String name, int cityId) async {
  try {
    final response = await client.rpc('find_similar_venues', params: {
      'p_name': name,
      'p_city_id': cityId,
    });
    
    // Si hay resultados con alta similitud (>0.9), considerar duplicado
    if (response != null && response is List && response.isNotEmpty) {
      for (var item in response) {
        if (item['similarity'] > 0.9) {
          // Es probablemente un duplicado
          return await getVenueById(item['id']);
        }
      }
    }
    return null;
  } catch (e) {
    debugPrint('Error al buscar venue normalizado: $e');
    return null;
  }
}
```

#### 2. **Sistema de sugerencias mejorado**
**Problema**: No se sugiere al usuario si hay lugares similares cuando escribe

**Mejora**:
```dart
// En venue_search_field.dart - Durante la escritura
// Si no hay resultados exactos pero hay similares, mostrar sugerencia:
// "¿Quisiste decir: [lugar similar]?"
if (_suggestions.isEmpty && _googlePlacesSuggestions.isEmpty && _query.length >= 3) {
  // Hacer búsqueda de similares en background
  final similarVenues = await _venueService.findSimilarVenues(
    name: _query,
    cityId: widget.cityId!,
  );
  
  if (similarVenues.isNotEmpty && similarVenues.first.name != _query) {
    // Mostrar sugerencia
  }
}
```

#### 3. **Validación de coordenadas antes de crear lugar**
**Problema**: No se valida que las coordenadas estén dentro de la ciudad

**Mejora**:
```dart
// Validar que las coordenadas estén cerca de la ciudad
// Usar una función SQL o Dart para verificar proximidad
Future<bool> _validateCoordinatesInCity(double lat, double lng, int cityId) async {
  // Obtener coordenadas de la ciudad
  final city = await CityService.instance.getCityById(cityId);
  if (city?.lat == null || city?.lng == null) return true; // Si no hay coordenadas, permitir
  
  // Calcular distancia (por ejemplo, máximo 50km de la ciudad)
  final distance = calculateDistance(lat, lng, city!.lat!, city.lng!);
  return distance < 50000; // 50km
}
```

---

### D. Mejoras de Código y Mantenibilidad

#### 1. **Extraer constantes y configuración**
**Problema**: Valores mágicos dispersos por el código

**Mejora**:
```dart
// Crear lib/config/venue_config.dart
class VenueConfig {
  // Búsqueda
  static const int minSearchLength = 3;
  static const int debounceMsShort = 400;
  static const int debounceMsLong = 800;
  static const int maxSearchResults = 5;
  static const int maxSimilarVenues = 5;
  
  // Similitud
  static const double similarityThresholdNormalized = 0.4;
  static const double similarityThresholdOriginal = 0.5;
  static const double similarityThresholdDuplicate = 0.9;
  
  // Cache
  static const Duration cacheExpiration = Duration(minutes: 5);
  
  // Validación
  static const double maxDistanceFromCityKm = 50.0;
}
```

#### 2. **Manejo de errores más robusto**
**Problema**: Algunos errores se silencian o no se reportan bien

**Mejora**:
```dart
// Crear un enum de tipos de error
enum VenueErrorType {
  network,
  duplicate,
  validation,
  permission,
  unknown,
}

class VenueException implements Exception {
  final VenueErrorType type;
  final String message;
  final dynamic originalError;
  
  VenueException(this.type, this.message, [this.originalError]);
  
  @override
  String toString() => message;
}

// Usar en createVenue:
catch (e) {
  if (e.toString().contains('unique_venue_name_city')) {
    throw VenueException(
      VenueErrorType.duplicate,
      'Ya existe un lugar con ese nombre en esta ciudad',
      e,
    );
  }
  // ...
}
```

#### 3. **Tests unitarios para funciones críticas**
**Problema**: No hay tests para la lógica de normalización y búsqueda

**Mejora**:
```dart
// tests/services/venue_service_test.dart
void main() {
  group('VenueService - Normalización', () {
    test('debe eliminar palabras comunes', () {
      expect(
        normalizeVenueName('Restaurante El Boquerón'),
        equals('boqueron'),
      );
    });
    
    test('debe normalizar acentos', () {
      expect(
        normalizeVenueName('Café Essencia'),
        equals('cafe essencia'),
      );
    });
  });
}
```

---

### E. Mejoras de SQL/Database

#### 1. **Índice en nombre normalizado de venues**
**Mejora**:
```sql
-- Crear columna generada para nombre normalizado
ALTER TABLE venues 
ADD COLUMN name_normalized text 
GENERATED ALWAYS AS (lower(trim(name))) STORED;

CREATE INDEX idx_venues_name_normalized ON venues(name_normalized, city_id);
```

#### 2. **Función SQL para validar coordenadas**
**Mejora**:
```sql
CREATE OR REPLACE FUNCTION public.venue_coordinates_in_city(
  p_lat double precision,
  p_lng double precision,
  p_city_id int8,
  p_max_distance_km int DEFAULT 50
)
RETURNS boolean AS $$
DECLARE
  city_lat double precision;
  city_lng double precision;
  distance_km double precision;
BEGIN
  -- Obtener coordenadas de la ciudad
  SELECT lat, lng INTO city_lat, city_lng
  FROM cities
  WHERE id = p_city_id;
  
  IF city_lat IS NULL OR city_lng IS NULL THEN
    RETURN true; -- Si la ciudad no tiene coordenadas, permitir
  END IF;
  
  -- Calcular distancia (fórmula Haversine simplificada)
  -- ... implementar cálculo de distancia ...
  
  RETURN distance_km <= p_max_distance_km;
END;
$$ LANGUAGE plpgsql;
```

#### 3. **Materializar vista events_view para mejor rendimiento**
**Problema**: La vista se recalcula en cada consulta

**Mejora**:
```sql
-- Convertir a MATERIALIZED VIEW si no cambia frecuentemente
-- O añadir índices apropiados en las tablas base
```

---

### F. Mejoras de Seguridad

#### 1. **Validar permisos antes de crear lugares**
**Mejora**:
```dart
// Verificar que el usuario tenga permiso para crear lugares
// (por ejemplo, si implementas límites por usuario)
Future<bool> _canCreateVenue(String userId) async {
  // Verificar límites diarios, etc.
  final countToday = await _countVenuesCreatedToday(userId);
  return countToday < 10; // Límite de 10 lugares por día
}
```

#### 2. **Sanitizar inputs antes de buscar**
**Mejora**:
```dart
String _sanitizeSearchQuery(String query) {
  // Limitar longitud
  if (query.length > 100) {
    query = query.substring(0, 100);
  }
  // Eliminar caracteres peligrosos para SQL injection
  // (aunque Supabase ya lo hace, es buena práctica)
  return query.trim();
}
```

---

## 📊 Prioridades Recomendadas

### 🔴 Alta Prioridad (Implementar pronto)
1. Ejecutar migración SQL de lugares similares
2. Cache de búsquedas de venues
3. Mejor feedback visual para lugares pendientes
4. Normalización consistente en createVenue

### 🟡 Media Prioridad (Próximas semanas)
1. Optimizar carga de lugares similares en admin
2. Confirmación antes de crear desde Google Maps
3. Validación de coordenadas
4. Extraer constantes a configuración

### 🟢 Baja Prioridad (Mejoras futuras)
1. Índices en BD
2. Tests unitarios
3. Materializar vistas
4. Límites de creación por usuario

---

## 🧪 Testing Recomendado

### Casos a probar:
1. ✅ Crear evento con lugar pendiente existente
2. ✅ Buscar lugar que no existe → debe mostrar opción crear
3. ✅ Buscar "essencia" cuando existe "Pub Essencia" → debe encontrarlo
4. ✅ Panel admin carga eventos con venues
5. ⚠️ **Pendiente**: Detección de similares después de ejecutar SQL
6. ⚠️ **Pendiente**: Normalización de nombres (ej: "Restaurante X" vs "X")

---

## 📝 Notas Adicionales

- La migración SQL debe ejecutarse en Supabase antes de que las mejoras de similares funcionen
- Considerar añadir analytics para ver qué lugares se buscan más
- Evaluar añadir un sistema de votación/feedback para lugares pendientes
- Considerar cache distribuido (Redis) si el volumen de búsquedas crece

