// lib/services/venue_service.dart
import 'package:flutter/foundation.dart' show debugPrint;
import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/venue.dart';
import '../config/venue_config.dart';
import 'venue_exceptions.dart';
import 'auth_service.dart';
import 'city_service.dart';

/// Configuración del cache de búsquedas (usando VenueConfig)
class _VenueCacheConfig {
  static Duration get expiration => VenueConfig.cacheExpiration;
  static int get maxCacheSize => VenueConfig.maxCacheSize;
  static Duration get cleanupInterval => VenueConfig.cacheCleanupInterval;
}

/// Entrada del cache con timestamp
class _CacheEntry {
  final List<Venue> venues;
  final DateTime timestamp;
  final String userId; // Para invalidar cuando cambia el usuario

  _CacheEntry({
    required this.venues,
    required this.timestamp,
    required this.userId,
  });

  bool get isExpired {
    return DateTime.now().difference(timestamp) > _VenueCacheConfig.expiration;
  }
}

/// Servicio para gestionar lugares/venues
class VenueService {
  VenueService._();
  
  static final VenueService instance = VenueService._();
  
  // Cache de búsquedas: clave = "query-cityId-limit", valor = entrada de cache
  final Map<String, _CacheEntry> _searchCache = {};
  DateTime? _lastCacheCleanup;
  
  SupabaseClient? get _client {
    try {
      return Supabase.instance.client;
    } catch (e) {
      debugPrint('⚠️ Supabase no está inicializado en VenueService: $e');
      return null;
    }
  }
  
  /// Limpia entradas expiradas del cache
  void _cleanupCache() {
    final now = DateTime.now();
    
    // Limpiar según intervalo configurado
    if (_lastCacheCleanup != null &&
        now.difference(_lastCacheCleanup!) < _VenueCacheConfig.cleanupInterval) {
      return;
    }
    
    _lastCacheCleanup = now;
    final currentUserId = AuthService.instance.currentUserId ?? 'anonymous';
    
    // Eliminar entradas expiradas o de otros usuarios
    _searchCache.removeWhere((key, entry) {
      return entry.isExpired || entry.userId != currentUserId;
    });
    
    // Si el cache está muy grande, eliminar las entradas más antiguas
    if (_searchCache.length > _VenueCacheConfig.maxCacheSize) {
      final sortedEntries = _searchCache.entries.toList()
        ..sort((a, b) => a.value.timestamp.compareTo(b.value.timestamp));
      
      final toRemove = sortedEntries.length - _VenueCacheConfig.maxCacheSize;
      for (int i = 0; i < toRemove; i++) {
        _searchCache.remove(sortedEntries[i].key);
      }
      
      debugPrint('🧹 Cache limpiado: ${sortedEntries.length} → ${_searchCache.length} entradas');
    }
  }
  
  /// Invalida todo el cache (útil cuando se crea/aprueba/rechaza un venue)
  void invalidateCache() {
    _searchCache.clear();
    debugPrint('🗑️ Cache de venues invalidado');
  }
  
  /// Sanitiza el texto de búsqueda (limita longitud, elimina caracteres peligrosos)
  String _sanitizeSearchQuery(String query) {
    // Limitar longitud máxima
    if (query.length > VenueConfig.maxQueryLength) {
      query = query.substring(0, VenueConfig.maxQueryLength);
    }
    // Eliminar caracteres de control y espacios extra
    return query
        .replaceAll(RegExp(r'[\x00-\x1F\x7F]'), '') // Caracteres de control
        .trim();
  }
  
  /// Normaliza el texto para búsqueda (elimina acentos, convierte a minúsculas)
  String _normalizeSearchText(String text) {
    final sanitized = _sanitizeSearchQuery(text);
    return sanitized
        .toLowerCase()
        .replaceAll('á', 'a')
        .replaceAll('é', 'e')
        .replaceAll('í', 'i')
        .replaceAll('ó', 'o')
        .replaceAll('ú', 'u')
        .replaceAll('ñ', 'n')
        .trim();
  }

  /// Busca lugares por nombre (para autocompletado)
  /// Retorna lugares aprobados y lugares pendientes del usuario actual
  /// La búsqueda es flexible: busca en el nombre normalizado
  /// Usa cache para evitar consultas repetidas
  Future<List<Venue>> searchVenues({
    required String query,
    int? cityId,
    int limit = 10,
  }) async {
    final client = _client;
    if (client == null) return [];
    
    // Limpiar cache periódicamente
    _cleanupCache();
    
    // Crear clave de cache: query normalizado + cityId + limit + userId
    final normalizedQuery = _normalizeSearchText(query);
    final userId = AuthService.instance.currentUserId ?? 'anonymous';
    final cacheKey = '$normalizedQuery-${cityId ?? 'all'}-$limit-$userId';
    
    // Verificar si hay resultado en cache válido
    final cachedEntry = _searchCache[cacheKey];
    if (cachedEntry != null && !cachedEntry.isExpired) {
      debugPrint('💾 Resultado desde cache: "$query" → ${cachedEntry.venues.length} lugares');
      return cachedEntry.venues;
    }
    
    try {
      debugPrint('🔍 Buscando lugares: "$query" (normalizado: "$normalizedQuery")');
      
      // Hacer dos consultas: lugares aprobados y lugares pendientes del usuario (si existe)
      List<Venue> allVenues = [];
      
      // 1. Buscar lugares aprobados
      dynamic approvedQuery = client
          .from('venues')
          .select()
          .eq('status', 'approved');
      
      if (cityId != null) {
        approvedQuery = approvedQuery.eq('city_id', cityId);
      }
      
      final approvedResponse = await approvedQuery
          .ilike('name', '%$normalizedQuery%')
          .order('name', ascending: true)
          .limit(VenueConfig.maxSearchResults);
      
      allVenues.addAll((approvedResponse as List)
          .map((v) => Venue.fromMap(v as Map<String, dynamic>))
          .toList());
      
      // 2. Si hay usuario, también buscar lugares pendientes que creó
      if (userId != 'anonymous' && allVenues.length < limit) {
        dynamic pendingQuery = client
            .from('venues')
            .select()
            .eq('status', 'pending')
            .eq('created_by', userId);
        
        if (cityId != null) {
          pendingQuery = pendingQuery.eq('city_id', cityId);
        }
        
        final pendingResponse = await pendingQuery
            .ilike('name', '%$normalizedQuery%')
            .order('name', ascending: true)
            .limit(VenueConfig.maxSearchResults - allVenues.length);
        
        allVenues.addAll((pendingResponse as List)
            .map((v) => Venue.fromMap(v as Map<String, dynamic>))
            .toList());
      }
      
      // Eliminar duplicados por ID y ordenar
      final venuesMap = <String, Venue>{};
      for (final venue in allVenues) {
        venuesMap[venue.id] = venue;
      }
      final venues = venuesMap.values.toList()
        ..sort((a, b) => a.name.compareTo(b.name));
      
      // Guardar en cache
      _searchCache[cacheKey] = _CacheEntry(
        venues: venues,
        timestamp: DateTime.now(),
        userId: userId,
      );
      
      debugPrint('📊 Resultados encontrados: ${venues.length} (guardado en cache)');
      for (final venue in venues) {
        debugPrint('   - ${venue.name} (ID: ${venue.id}, status: ${venue.status}, Lat: ${venue.lat}, Lng: ${venue.lng})');
      }
      
      return venues;
    } catch (e) {
      debugPrint('❌ Error al buscar lugares: $e');
      return [];
    }
  }
  
  /// Crea un nuevo lugar (con status='pending')
  /// Si el lugar ya existe (incluso pendiente), lo devuelve en lugar de crear uno nuevo
  Future<Venue> createVenue({
    required String name,
    required int cityId,
    String? address,
    double? lng,
    double? lat,
  }) async {
    final client = _client;
    if (client == null) {
      throw VenueException.network('Supabase no está inicializado');
    }
    
    // Validar entrada
    final trimmedName = name.trim();
    if (trimmedName.length < VenueConfig.minVenueNameLength) {
      throw VenueException.validation(
        'El nombre del lugar debe tener al menos ${VenueConfig.minVenueNameLength} caracteres',
      );
    }
    if (trimmedName.length > VenueConfig.maxVenueNameLength) {
      throw VenueException.validation(
        'El nombre del lugar no puede tener más de ${VenueConfig.maxVenueNameLength} caracteres',
      );
    }
    
    final userId = AuthService.instance.currentUserId;
    
    // PRIMERO: Verificar si el lugar ya existe (incluso si está pendiente)
    try {
      final existingVenueResponse = await client
          .from('venues')
          .select()
          .eq('name', trimmedName)
          .eq('city_id', cityId)
          .maybeSingle();
      
      if (existingVenueResponse != null) {
        final existingVenue = Venue.fromMap(existingVenueResponse as Map<String, dynamic>);
        debugPrint('✅ Lugar ya existe: $trimmedName (ID: ${existingVenue.id}, status: ${existingVenue.status})');
        debugPrint('   Devolviendo lugar existente en lugar de crear uno nuevo');
        return existingVenue;
      }
    } catch (e) {
      debugPrint('⚠️ Error al verificar lugar existente: $e');
      // Continuar con la creación si hay un error al verificar
    }
    
    // Si no existe, crearlo
    try {
      final payload = <String, dynamic>{
        'name': trimmedName,
        'city_id': cityId,
        'status': 'pending',
        if (address != null && address.isNotEmpty) 'address': address.trim(),
        if (lat != null) 'lat': lat,
        if (lng != null) 'lng': lng,
        if (userId != null) 'created_by': userId,
      };
      
      final response = await client
          .from('venues')
          .insert(payload)
          .select()
          .single();
      
      // Invalidar cache cuando se crea un nuevo venue
      invalidateCache();
      
      debugPrint('✅ Lugar creado: $trimmedName (status: pending)');
      return Venue.fromMap(response as Map<String, dynamic>);
    } catch (e) {
      debugPrint('❌ Error al crear lugar: $e');
      
      // Si es un error de duplicado, intentar obtener el lugar existente
      if (e.toString().contains('unique_venue_name_city')) {
        debugPrint('⚠️ Lugar duplicado detectado, obteniendo lugar existente...');
        try {
          final existingVenueResponse = await client
              .from('venues')
              .select()
              .eq('name', trimmedName)
              .eq('city_id', cityId)
              .single();
          
          final existingVenue = Venue.fromMap(existingVenueResponse as Map<String, dynamic>);
          debugPrint('✅ Lugar existente encontrado: ${existingVenue.id} (status: ${existingVenue.status})');
          return existingVenue;
        } catch (e2) {
          debugPrint('❌ Error al obtener lugar existente: $e2');
          throw VenueException.duplicate(
            'Ya existe un lugar con ese nombre en esta ciudad',
            e2,
          );
        }
      }
      
      rethrow;
    }
  }
  
  /// Busca lugares similares (para prevenir duplicados)
  Future<List<Venue>> findSimilarVenues({
    required String name,
    required int cityId,
  }) async {
    final client = _client;
    if (client == null) return [];
    
    try {
      // Usar la función SQL find_similar_venues
      final response = await client.rpc('find_similar_venues', params: {
        'p_name': name,
        'p_city_id': cityId,
      });
      
      if (response == null) return [];
      
      final venues = <Venue>[];
      int count = 0;
      for (var row in response as List) {
        if (count >= VenueConfig.maxSimilarVenues) break;
        
        final venueId = row['id'] as String;
        try {
          // Obtener el lugar completo
          final venueResponse = await client
              .from('venues')
              .select()
              .eq('id', venueId)
              .single();
          
          venues.add(Venue.fromMap(venueResponse as Map<String, dynamic>));
          count++;
        } catch (e) {
          debugPrint('⚠️ Error al obtener venue $venueId: $e');
          // Continuar con el siguiente
        }
      }
      
      return venues;
    } catch (e) {
      debugPrint('⚠️ Error al buscar lugares similares: $e');
      return [];
    }
  }
  
  /// Obtiene lugares pendientes de aprobación (solo para admins)
  Future<List<Venue>> getPendingVenues() async {
    final client = _client;
    if (client == null) return [];
    
    try {
      final response = await client
          .from('venues')
          .select()
          .eq('status', 'pending')
          .order('created_at', ascending: false);
      
      final venues = (response as List)
          .map((v) => Venue.fromMap(v as Map<String, dynamic>))
          .toList();
      
      // Enriquecer con nombres de ciudades
      await _enrichVenuesWithCityNames(venues);
      
      return venues;
    } catch (e) {
      debugPrint('❌ Error al obtener lugares pendientes: $e');
      return [];
    }
  }
  
  /// Enriquece lugares con nombres de ciudades
  Future<void> _enrichVenuesWithCityNames(List<Venue> venues) async {
    if (venues.isEmpty) return;
    
    try {
      // Obtener todas las ciudades de una vez
      final cities = await CityService.instance.fetchCities();
      final cityMap = {
        for (var city in cities) city.id: city.name
      };
      
      // Actualizar lugares con nombres de ciudades
      for (int i = 0; i < venues.length; i++) {
        final venue = venues[i];
        if (cityMap.containsKey(venue.cityId)) {
          final venueMap = venue.toMap();
          venueMap['city_name'] = cityMap[venue.cityId];
          venues[i] = Venue.fromMap(venueMap);
        }
      }
    } catch (e) {
      debugPrint('⚠️ Error al enriquecer lugares con nombres de ciudades: $e');
    }
  }
  
  /// Aprueba un lugar (solo para admins)
  Future<void> approveVenue(String venueId) async {
    final client = _client;
    if (client == null) {
      throw Exception('Supabase no está inicializado');
    }
    
    try {
      await client
          .from('venues')
          .update({'status': 'approved', 'rejected_reason': null})
          .eq('id', venueId);
      
      // Invalidar cache cuando se aprueba un venue (cambia su estado)
      invalidateCache();
      
      debugPrint('✅ Lugar aprobado: $venueId');
    } catch (e) {
      debugPrint('❌ Error al aprobar lugar: $e');
      rethrow;
    }
  }
  
  /// Rechaza un lugar (solo para admins)
  Future<void> rejectVenue(String venueId, {String? reason}) async {
    final client = _client;
    if (client == null) {
      throw Exception('Supabase no está inicializado');
    }
    
    try {
      await client
          .from('venues')
          .update({
            'status': 'rejected',
            'rejected_reason': reason?.trim(),
          })
          .eq('id', venueId);
      
      // Invalidar cache cuando se rechaza un venue (cambia su estado)
      invalidateCache();
      
      debugPrint('✅ Lugar rechazado: $venueId');
    } catch (e) {
      debugPrint('❌ Error al rechazar lugar: $e');
      rethrow;
    }
  }
  
  /// Obtiene un lugar por ID
  Future<Venue?> getVenueById(String venueId) async {
    final client = _client;
    if (client == null) return null;
    
    try {
      final response = await client
          .from('venues')
          .select()
          .eq('id', venueId)
          .maybeSingle();
      
      if (response == null) return null;
      
      return Venue.fromMap(response as Map<String, dynamic>);
    } catch (e) {
      debugPrint('❌ Error al obtener lugar: $e');
      return null;
    }
  }
}
