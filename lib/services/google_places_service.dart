// lib/services/google_places_service.dart
import 'dart:convert';
import 'package:flutter/foundation.dart' show debugPrint;
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

/// Modelo para representar un lugar de Google Places
class GooglePlace {
  final String placeId;
  final String name;
  final String? address;
  final double? lat;
  final double? lng;

  GooglePlace({
    required this.placeId,
    required this.name,
    this.address,
    this.lat,
    this.lng,
  });

  factory GooglePlace.fromMap(Map<String, dynamic> map) {
    final geometry = map['geometry'] as Map<String, dynamic>?;
    final location = geometry?['location'] as Map<String, dynamic>?;
    
    return GooglePlace(
      placeId: map['place_id'] as String,
      name: map['name'] as String,
      address: map['formatted_address'] as String?,
      lat: location != null ? (location['lat'] as num).toDouble() : null,
      lng: location != null ? (location['lng'] as num).toDouble() : null,
    );
  }
  
  // Constructor para la nueva API format
  factory GooglePlace.fromNewFormat(Map<String, dynamic> place) {
    final displayName = place['displayName'] as Map<String, dynamic>?;
    final location = place['location'] as Map<String, dynamic>?;
    
    return GooglePlace(
      placeId: place['id'] as String,
      name: displayName?['text'] as String? ?? '',
      address: place['formattedAddress'] as String?,
      lat: location != null ? (location['latitude'] as num?)?.toDouble() : null,
      lng: location != null ? (location['longitude'] as num?)?.toDouble() : null,
    );
  }
}

/// Servicio para buscar lugares usando Google Places API
class GooglePlacesService {
  GooglePlacesService._();
  
  static final GooglePlacesService instance = GooglePlacesService._();
  
  /// Resetea el estado de bloqueo de la API key (útil si se configura correctamente después)
  static void resetApiKeyStatus() {
    _isApiKeyBlocked = null;
    _isApiNotEnabled = null;
    _errorMessageShown = false;
    debugPrint('🔄 Estado de API key reseteado - se intentará de nuevo en la próxima búsqueda');
  }
  
  // API Key de Google Maps - se carga desde variables de entorno
  // En producción, esto debería estar en el backend
  String? get _apiKey {
    try {
      // Intentar cargar desde .env
      final apiKey = dotenv.env['GOOGLE_MAPS_API_KEY'];
      if (apiKey != null && apiKey.isNotEmpty) {
        return apiKey;
      }
    } catch (e) {
      debugPrint('⚠️ Error al cargar GOOGLE_MAPS_API_KEY desde .env: $e');
    }
    
    // No usar fallback - la app debe tener la key configurada
    debugPrint('❌ GOOGLE_MAPS_API_KEY no encontrada en .env');
    return null;
  }
  
  // Variable estática para cachear si la API key está bloqueada
  static bool? _isApiKeyBlocked;
  
  // Variable estática para cachear si la API no está habilitada
  static bool? _isApiNotEnabled;
  
  // Variable para controlar si ya mostramos el mensaje de error (evitar spam en logs)
  static bool _errorMessageShown = false;

  /// Busca lugares usando Google Places API (New) - Text Search
  /// Filtra por ciudad para obtener resultados más relevantes
  /// Prueba múltiples variaciones automáticamente para encontrar el lugar
  Future<List<GooglePlace>> searchPlaces({
    required String query,
    required String cityName,
    int limit = 5,
  }) async {
    try {
      // Verificar que la API key esté configurada
      final apiKey = _apiKey;
      if (apiKey == null) {
        debugPrint('❌ No se puede buscar en Google Places: API key no configurada');
        return [];
      }
      
      // Si ya sabemos que ambas APIs están bloqueadas, retornar vacío inmediatamente
      // (evitar hacer llamadas innecesarias)
      if (_isApiKeyBlocked == true && _isApiNotEnabled == true) {
        if (!_errorMessageShown) {
          debugPrint('❌ Google Places API no disponible - API key bloqueada y APIs no habilitadas');
          debugPrint('   Solución: Habilitar Places API (New) y Places API (Legacy) en Google Cloud Console');
          debugPrint('   https://console.cloud.google.com/apis/library');
          _errorMessageShown = true;
        }
        return [];
      }
      
      // Si solo la nueva API está bloqueada, saltar directamente a legacy
      if (_isApiKeyBlocked == true || _isApiNotEnabled == true) {
        return await _searchPlacesLegacy(query, cityName, limit, apiKey);
      }
      
      // Probar solo 2 variaciones básicas primero (optimización)
      final queriesToTry = [
        // 1. Query exacta con ciudad y país (más específica)
        '$query, $cityName, España',
        // 2. Query sin país (a veces funciona mejor)
        '$query, $cityName',
      ];
      
      // Probar cada variación
      for (final exactQuery in queriesToTry) {
        debugPrint('🔍 Google Places: Probando query: "$exactQuery"');
        var results = await _searchPlacesNewAPI(exactQuery, limit, apiKey);
        
        // Si detectamos que la API key está bloqueada o formato incorrecto, saltar a legacy
        if (_isApiKeyBlocked == true || _isApiNotEnabled == true) {
          debugPrint('⚠️ Nueva API no disponible, usando legacy...');
          return await _searchPlacesLegacy(query, cityName, limit, apiKey);
        }
        
        if (results.isNotEmpty) {
          debugPrint('✅ Encontrado con query: "$exactQuery"');
          return results;
        }
      }
      
      // Si no encuentra con las 2 variaciones básicas, usar legacy directamente
      // (más rápido que probar muchas variaciones más)
      debugPrint('⚠️ No encontrado con nueva API, usando legacy...');
      return await _searchPlacesLegacy(query, cityName, limit, apiKey);
    } catch (e, stackTrace) {
      debugPrint('❌ Error al buscar en Google Places: $e');
      debugPrint('   Stack trace: $stackTrace');
      return [];
    }
  }
  
  /// Método auxiliar para buscar con la nueva API
  Future<List<GooglePlace>> _searchPlacesNewAPI(
    String searchQuery,
    int limit,
    String apiKey,
  ) async {
    try {
      // Usar la nueva Places API (New) - Text Search
      // Endpoint: /places/v1/search:textSearch
      final url = 'https://places.googleapis.com/v1/places:searchText';
      
      // Construir el cuerpo de la petición
      // Nota: locationBias no acepta 'region', solo 'circle', 'rectangle', o 'point'
      // Usamos locationRestriction para limitar a España
      final requestBody = {
        'textQuery': searchQuery,
        'maxResultCount': limit,
        // Restringir búsqueda a España (península ibérica)
        'locationRestriction': {
          'rectangle': {
            'low': {'latitude': 35.0, 'longitude': -10.0},
            'high': {'latitude': 44.0, 'longitude': 5.0},
          },
        },
      };
      
      debugPrint('🌐 Llamando a Places API (New): $url');
      debugPrint('   Query: $searchQuery');
      debugPrint('   API Key: ${apiKey.substring(0, 10)}...');
      
      final response = await http.post(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
          'X-Goog-Api-Key': apiKey,
          'X-Goog-FieldMask': 'places.id,places.displayName,places.formattedAddress,places.location',
        },
        body: json.encode(requestBody),
      );
      
      debugPrint('📡 Respuesta Places API: ${response.statusCode}');
      debugPrint('   Body length: ${response.body.length}');
      
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        debugPrint('   Respuesta parseada: ${data.keys.toList()}');
        
        if (data['places'] != null && (data['places'] as List).isNotEmpty) {
          final places = data['places'] as List;
          debugPrint('✅ Google Places (New): ${places.length} resultados encontrados');
          
          final results = places
              .take(limit)
              .map((place) {
                try {
                  final parsed = GooglePlace.fromNewFormat(place as Map<String, dynamic>);
                  debugPrint('   📍 ${parsed.name} - ${parsed.address}');
                  return parsed;
                } catch (e) {
                  debugPrint('⚠️ Error al parsear lugar: $e');
                  debugPrint('   Datos: $place');
                  return null;
                }
              })
              .whereType<GooglePlace>()
              .toList();
          
          if (results.isNotEmpty) {
            return results;
          }
        }
        
        // No hay resultados con esta query
        return [];
      } else {
        debugPrint('❌ Error HTTP en Places API (New): ${response.statusCode}');
        if (response.body.length < 500) {
          debugPrint('   Respuesta: ${response.body}');
        } else {
          debugPrint('   Respuesta (primeros 500 chars): ${response.body.substring(0, 500)}...');
        }
        
        // Analizar el error para detectar problemas de configuración
        try {
          final errorData = json.decode(response.body);
          final error = errorData['error'];
          if (error != null) {
            final reason = error['details']?[0]?['reason'] as String?;
            final message = error['message'] as String?;
            final status = error['status'] as String?;
            final fieldViolations = error['details']?[0]?['fieldViolations'] as List?;
            
            // Detectar error de formato (como location_bias con region inválido)
            // Si es un error 400 con INVALID_ARGUMENT, puede ser un problema de formato
            if (response.statusCode == 400 && status == 'INVALID_ARGUMENT') {
              final hasLocationBiasError = fieldViolations?.any((v) => 
                v['field'] == 'location_bias' || 
                (v['description'] as String?)?.contains('location_bias') == true ||
                (v['description'] as String?)?.contains('region') == true
              ) ?? false;
              
              if (hasLocationBiasError) {
                debugPrint('⚠️ Error de formato en location_bias - marcando nueva API como no disponible');
                GooglePlacesService._isApiNotEnabled = true; // Usar como flag para saltar a legacy
                return [];
              }
            }
            
            // Detectar si la API no está habilitada
            if (message != null && (message.contains('has not been used') || 
                message.contains('is disabled'))) {
              GooglePlacesService._isApiNotEnabled = true;
              debugPrint('❌ Places API (New) no está habilitada en el proyecto');
              debugPrint('   Mensaje: $message');
              debugPrint('   Solución: Habilitar Places API (New) en Google Cloud Console:');
              debugPrint('   https://console.cloud.google.com/apis/library/places.googleapis.com');
              debugPrint('   O visita el enlace que aparece en el mensaje de error');
              return [];
            }
            
            // Detectar si la API key está bloqueada para Android
            if (reason == 'API_KEY_ANDROID_APP_BLOCKED') {
              GooglePlacesService._isApiKeyBlocked = true;
              debugPrint('❌ API Key bloqueada para aplicaciones Android');
              debugPrint('   La API key necesita estar configurada en Google Cloud Console con:');
              debugPrint('   - Package name: com.perikopico.fiestapp');
              debugPrint('   - SHA-1 del certificado de firma');
              debugPrint('   Para obtener el SHA-1: keytool -list -v -keystore ~/.android/debug.keystore -alias androiddebugkey -storepass android -keypass android');
              debugPrint('   O desde Android Studio: Gradle > Tasks > android > signingReport');
              return [];
            }
            
            // Detectar si la API key está bloqueada (API_KEY_SERVICE_BLOCKED)
            if (reason == 'API_KEY_SERVICE_BLOCKED') {
              GooglePlacesService._isApiKeyBlocked = true;
              if (!_errorMessageShown) {
                debugPrint('❌ API Key bloqueada para Places API (New)');
                debugPrint('   Status: $status');
                debugPrint('   Mensaje: $message');
                debugPrint('   Solución: Habilitar Places API (New) en Google Cloud Console:');
                debugPrint('   https://console.cloud.google.com/apis/library/places.googleapis.com');
                _errorMessageShown = true;
              }
              return [];
            }
            
            // Otros errores de permisos
            if (status == 'PERMISSION_DENIED' || status == 'REQUEST_DENIED') {
              // Marcar como bloqueada si el mensaje indica que está bloqueada
              if (message != null && (message.contains('blocked') || message.contains('not authorized'))) {
                GooglePlacesService._isApiKeyBlocked = true;
                if (!_errorMessageShown) {
                  debugPrint('❌ Permiso denegado para Places API (New) - API key bloqueada');
                  debugPrint('   Status: $status');
                  debugPrint('   Mensaje: $message');
                  debugPrint('   Solución: Habilitar Places API (New) en Google Cloud Console');
                  _errorMessageShown = true;
                }
                return [];
              }
            }
          }
        } catch (e) {
          // Si no se puede parsear el error, continuar
        }
        
        // Error en la API, retornar vacío para que se pruebe la siguiente variación
        return [];
      }
    } catch (e) {
      debugPrint('❌ Error en _searchPlacesNewAPI: $e');
      return [];
    }
  }
  
  /// Fallback: Busca usando la API legacy (si la nueva falla)
  /// Prueba diferentes variaciones de la query para mejorar los resultados
  /// PRIMERO usa exactamente lo que el usuario escribió, luego prueba variaciones
  Future<List<GooglePlace>> _searchPlacesLegacy(
    String query,
    String cityName,
    int limit,
    String apiKey,
  ) async {
    // PRIMERO: Usar exactamente lo que el usuario escribió
    // Luego probar variaciones si no encuentra resultados
    final searchQueries = [
      '$query, $cityName', // PRIMERO: exactamente lo que el usuario escribió + ciudad
      '$query, $cityName, España', // Con España
      '$query restaurante, $cityName', // Añadir tipo de negocio
      '$query bar, $cityName',
      '$query local, $cityName',
      query, // Solo el nombre del lugar (último recurso)
    ];
    
    for (final searchQuery in searchQueries) {
      try {
        final encodedQuery = Uri.encodeComponent(searchQuery);
        
        // Añadir región y tipo para mejorar resultados
        final url = 'https://maps.googleapis.com/maps/api/place/textsearch/json'
            '?query=$encodedQuery'
            '&region=es' // Priorizar resultados en España
            '&key=$apiKey';
        
        debugPrint('🔄 Llamando a Places API (Legacy) con query: "$searchQuery"');
        final response = await http.get(Uri.parse(url));
        
        debugPrint('📡 Respuesta Places API (Legacy): ${response.statusCode}');
        
        if (response.statusCode == 200) {
          final data = json.decode(response.body);
          debugPrint('   Status: ${data['status']}');
          
          if (data['status'] == 'OK' && data['results'] != null) {
            final results = data['results'] as List;
            if (results.isNotEmpty) {
              debugPrint('✅ Places API (Legacy): ${results.length} resultados con query "$searchQuery"');
              // Filtrar resultados que contengan la ciudad en la dirección
              final filteredResults = results.where((result) {
                final address = (result['formatted_address'] as String? ?? '').toLowerCase();
                final cityLower = cityName.toLowerCase();
                return address.contains(cityLower) || address.contains('barbate') || address.contains('cádiz');
              }).toList();
              
              if (filteredResults.isNotEmpty) {
                debugPrint('   📍 Filtrando ${filteredResults.length} resultados relevantes para $cityName');
                return filteredResults
                    .take(limit)
                    .map((result) {
                      final place = GooglePlace.fromMap(result as Map<String, dynamic>);
                      debugPrint('   📍 ${place.name} - ${place.address}');
                      return place;
                    })
                    .toList();
              } else if (results.isNotEmpty) {
                // Si no hay resultados filtrados, usar los primeros resultados
                debugPrint('   ⚠️ No se encontraron resultados filtrados, usando primeros resultados');
                return results
                    .take(limit)
                    .map((result) {
                      final place = GooglePlace.fromMap(result as Map<String, dynamic>);
                      debugPrint('   📍 ${place.name} - ${place.address}');
                      return place;
                    })
                    .toList();
              }
            }
          } else {
            final status = data['status'] as String?;
            final errorMessage = data['error_message'] as String?;
            debugPrint('⚠️ Places API (Legacy): $status - ${errorMessage ?? ''}');
            
            // Si es REQUEST_DENIED, marcar como bloqueada
            if (status == 'REQUEST_DENIED') {
              GooglePlacesService._isApiKeyBlocked = true;
              if (errorMessage?.contains('not authorized') == true || errorMessage?.contains('blocked') == true) {
                if (!_errorMessageShown) {
                  debugPrint('❌ API key no autorizada para Places API (Legacy)');
                  debugPrint('   Status: $status');
                  debugPrint('   Mensaje: $errorMessage');
                  debugPrint('   Solución: Habilitar Places API en Google Cloud Console:');
                  debugPrint('   https://console.cloud.google.com/apis/library/places-backend.googleapis.com');
                  _errorMessageShown = true;
                }
                // Retornar vacío para no probar más variaciones
                return [];
              }
            }
          }
        } else {
          debugPrint('❌ Error HTTP en Places API (Legacy): ${response.statusCode}');
          if (response.body.length < 300) {
            debugPrint('   Respuesta: ${response.body}');
          }
        }
      } catch (e) {
        debugPrint('❌ Error en fallback legacy API con query "$searchQuery": $e');
        // Continuar con la siguiente query
      }
    }
    
    debugPrint('⚠️ Places API (Legacy): No se encontraron resultados con ninguna variación');
    return [];
  }
  
  /// Obtiene detalles completos de un lugar por su place_id
  Future<GooglePlace?> getPlaceDetails(String placeId) async {
    try {
      // Verificar que la API key esté configurada
      final apiKey = _apiKey;
      if (apiKey == null) {
        debugPrint('❌ No se puede obtener detalles del lugar: API key no configurada');
        return null;
      }
      
      // Intentar con la nueva API primero
      final url = 'https://places.googleapis.com/v1/places/$placeId';
      
      final response = await http.get(
        Uri.parse(url),
        headers: {
          'X-Goog-Api-Key': apiKey,
          'X-Goog-FieldMask': 'id,displayName,formattedAddress,location',
        },
      );
      
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return GooglePlace.fromNewFormat(data);
      }
      
      // Fallback a legacy API
      final legacyUrl = 'https://maps.googleapis.com/maps/api/place/details/json'
          '?place_id=$placeId'
          '&fields=place_id,name,formatted_address,geometry'
          '&key=$apiKey';
      
      final legacyResponse = await http.get(Uri.parse(legacyUrl));
      
      if (legacyResponse.statusCode == 200) {
        final data = json.decode(legacyResponse.body);
        if (data['status'] == 'OK' && data['result'] != null) {
          return GooglePlace.fromMap(data['result'] as Map<String, dynamic>);
        }
      }
      
      return null;
    } catch (e) {
      debugPrint('❌ Error al obtener detalles del lugar: $e');
      return null;
    }
  }
}

