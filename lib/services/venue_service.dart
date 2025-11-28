// lib/services/venue_service.dart
import 'package:flutter/foundation.dart' show debugPrint;
import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/venue.dart';
import 'auth_service.dart';
import 'city_service.dart';

/// Servicio para gestionar lugares/venues
class VenueService {
  VenueService._();
  
  static final VenueService instance = VenueService._();
  
  SupabaseClient? get _client {
    try {
      return Supabase.instance.client;
    } catch (e) {
      debugPrint('⚠️ Supabase no está inicializado en VenueService: $e');
      return null;
    }
  }
  
  /// Busca lugares por nombre (para autocompletado)
  /// Solo retorna lugares aprobados
  Future<List<Venue>> searchVenues({
    required String query,
    int? cityId,
    int limit = 10,
  }) async {
    final client = _client;
    if (client == null) return [];
    
    try {
      // Construir la consulta - aplicar todos los filtros eq() antes de ilike()
      dynamic queryBuilder = client
          .from('venues')
          .select()
          .eq('status', 'approved');
      
      if (cityId != null) {
        queryBuilder = queryBuilder.eq('city_id', cityId);
      }
      
      // Aplicar ilike después de los filtros eq
      final response = await queryBuilder
          .ilike('name', '%$query%')
          .order('name', ascending: true)
          .limit(limit);
      
      return (response as List)
          .map((v) => Venue.fromMap(v as Map<String, dynamic>))
          .toList();
    } catch (e) {
      debugPrint('❌ Error al buscar lugares: $e');
      return [];
    }
  }
  
  /// Crea un nuevo lugar (con status='pending')
  Future<Venue> createVenue({
    required String name,
    required int cityId,
    String? address,
    double? lat,
    double? lng,
  }) async {
    final client = _client;
    if (client == null) {
      throw Exception('Supabase no está inicializado');
    }
    
    final userId = AuthService.instance.currentUserId;
    
    try {
      final payload = <String, dynamic>{
        'name': name.trim(),
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
      
      debugPrint('✅ Lugar creado: $name (status: pending)');
      return Venue.fromMap(response as Map<String, dynamic>);
    } catch (e) {
      debugPrint('❌ Error al crear lugar: $e');
      
      // Si es un error de duplicado, lanzar mensaje más amigable
      if (e.toString().contains('unique_venue_name_city')) {
        throw Exception('Ya existe un lugar con ese nombre en esta ciudad');
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
      for (var row in response as List) {
        final venueId = row['id'] as String;
        // Obtener el lugar completo
        final venueResponse = await client
            .from('venues')
            .select()
            .eq('id', venueId)
            .single();
        
        venues.add(Venue.fromMap(venueResponse as Map<String, dynamic>));
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
