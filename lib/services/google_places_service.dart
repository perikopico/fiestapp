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
  
  // API Key de Google Maps - se carga desde variables de entorno
  // En producción, esto debería estar en el backend
  String get _apiKey {
    try {
      // Intentar cargar desde .env
      final apiKey = dotenv.env['GOOGLE_MAPS_API_KEY'];
      if (apiKey != null && apiKey.isNotEmpty) {
        return apiKey;
      }
    } catch (e) {
      debugPrint('⚠️ Error al cargar GOOGLE_MAPS_API_KEY desde .env: $e');
    }
    
    // Fallback: usar una key por defecto (solo para desarrollo)
    // En producción, esto debería fallar si no hay key
    debugPrint('⚠️ GOOGLE_MAPS_API_KEY no encontrada en .env, usando fallback');
    return 'AIzaSyDCE_o8jBruKq0__AJRL7SA8ztMCJrsK04';
  }
  
  /// Busca lugares usando Google Places API (New) - Text Search
  /// Filtra por ciudad para obtener resultados más relevantes
  Future<List<GooglePlace>> searchPlaces({
    required String query,
    required String cityName,
    int limit = 5,
  }) async {
    try {
      // Construir la query de búsqueda: "nombre del lugar, ciudad"
      final searchQuery = '$query, $cityName';
      debugPrint('🔍 Google Places: Buscando "$searchQuery"');
      
      // Usar la nueva Places API (New) - Text Search
      // Endpoint: /places/v1/search:textSearch
      final url = 'https://places.googleapis.com/v1/places:searchText';
      
      final requestBody = {
        'textQuery': searchQuery,
        'maxResultCount': limit,
        'locationBias': {
          'region': 'ES', // España
        },
      };
      
      debugPrint('🌐 Llamando a Places API (New): $url');
      debugPrint('   Query: $searchQuery');
      debugPrint('   API Key: ${_apiKey.substring(0, 10)}...');
      
      final response = await http.post(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
          'X-Goog-Api-Key': _apiKey,
          'X-Goog-FieldMask': 'places.id,places.displayName,places.formattedAddress,places.location',
        },
        body: json.encode(requestBody),
      );
      
      debugPrint('📡 Respuesta Places API: ${response.statusCode}');
      
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        
        if (data['places'] != null) {
          final places = data['places'] as List;
          debugPrint('✅ Google Places: ${places.length} resultados encontrados');
          
          return places
              .take(limit)
              .map((place) {
                try {
                  return GooglePlace.fromNewFormat(place as Map<String, dynamic>);
                } catch (e) {
                  debugPrint('⚠️ Error al parsear lugar: $e');
                  debugPrint('   Datos: $place');
                  return null;
                }
              })
              .whereType<GooglePlace>()
              .toList();
        } else {
          debugPrint('⚠️ Google Places: No se encontraron lugares para: $searchQuery');
          debugPrint('   Respuesta completa: ${response.body.substring(0, 200)}...');
          return [];
        }
      } else {
        debugPrint('❌ Error HTTP en Places API (New): ${response.statusCode}');
        debugPrint('   Respuesta: ${response.body}');
        
        // Si es error 403 con API_KEY_ANDROID_APP_BLOCKED, no intentar fallback
        // porque el problema es la configuración de la API key
        try {
          final errorData = json.decode(response.body);
          final error = errorData['error'];
          if (error != null) {
            final reason = error['details']?[0]?['reason'] as String?;
            if (reason == 'API_KEY_ANDROID_APP_BLOCKED') {
              debugPrint('⚠️ API Key bloqueada para aplicaciones Android');
              debugPrint('   Solución: Configurar package name y SHA-1 en Google Cloud Console');
              debugPrint('   Package name: com.perikopico.fiestapp');
              return []; // No intentar fallback, el problema es de configuración
            }
          }
        } catch (e) {
          // Si no se puede parsear el error, continuar con fallback
        }
        
        // Si falla la nueva API, intentar con la legacy como fallback
        debugPrint('🔄 Intentando con API legacy como fallback...');
        return await _searchPlacesLegacy(query, cityName, limit);
      }
    } catch (e, stackTrace) {
      debugPrint('❌ Error al buscar en Google Places: $e');
      debugPrint('   Stack trace: $stackTrace');
      return [];
    }
  }
  
  /// Fallback: Busca usando la API legacy (si la nueva falla)
  Future<List<GooglePlace>> _searchPlacesLegacy(
    String query,
    String cityName,
    int limit,
  ) async {
    try {
      final searchQuery = '$query, $cityName';
      final encodedQuery = Uri.encodeComponent(searchQuery);
      
      final url = 'https://maps.googleapis.com/maps/api/place/textsearch/json'
          '?query=$encodedQuery'
          '&key=$_apiKey';
      
      debugPrint('🔄 Llamando a Places API (Legacy): $url');
      final response = await http.get(Uri.parse(url));
      
      debugPrint('📡 Respuesta Places API (Legacy): ${response.statusCode}');
      
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        
        if (data['status'] == 'OK' && data['results'] != null) {
          final results = data['results'] as List;
          debugPrint('✅ Places API (Legacy): ${results.length} resultados');
          return results
              .take(limit)
              .map((result) => GooglePlace.fromMap(result as Map<String, dynamic>))
              .toList();
        } else {
          debugPrint('⚠️ Places API (Legacy): ${data['status']} - ${data['error_message'] ?? ''}');
        }
      } else {
        debugPrint('❌ Error HTTP en Places API (Legacy): ${response.statusCode}');
        debugPrint('   Respuesta: ${response.body.substring(0, 200)}...');
      }
      return [];
    } catch (e) {
      debugPrint('❌ Error en fallback legacy API: $e');
      return [];
    }
  }
  
  /// Obtiene detalles completos de un lugar por su place_id
  Future<GooglePlace?> getPlaceDetails(String placeId) async {
    try {
      // Intentar con la nueva API primero
      final url = 'https://places.googleapis.com/v1/places/$placeId';
      
      final response = await http.get(
        Uri.parse(url),
        headers: {
          'X-Goog-Api-Key': _apiKey,
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
          '&key=$_apiKey';
      
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

