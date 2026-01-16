import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter/foundation.dart';
import '../models/event.dart';
import 'auth_service.dart';

/// Servicio para que los dueños de venues aprueben/rechacen eventos
class VenueEventApprovalService {
  VenueEventApprovalService._();
  
  static final VenueEventApprovalService instance = VenueEventApprovalService._();
  
  SupabaseClient get _supabase {
    try {
      return Supabase.instance.client;
    } catch (e) {
      throw Exception('Supabase no está inicializado. Asegúrate de que el archivo .env esté configurado correctamente.');
    }
  }
  
  /// Aprueba un evento por parte del dueño del venue
  /// 
  /// [eventId] ID del evento a aprobar
  Future<bool> approveEvent(String eventId) async {
    try {
      final response = await _supabase.rpc(
        'approve_event_by_owner',
        params: {
          'p_event_id': eventId,
          'p_approved': true,
        },
      );
      
      if (response == null || response == false) {
        throw Exception('No se pudo aprobar el evento');
      }
      
      debugPrint('✅ Evento aprobado por dueño: $eventId');
      return true;
    } catch (e) {
      debugPrint('❌ Error al aprobar evento: $e');
      rethrow;
    }
  }
  
  /// Rechaza un evento por parte del dueño del venue
  /// 
  /// [eventId] ID del evento a rechazar
  /// [reason] Razón del rechazo (opcional)
  Future<bool> rejectEvent(String eventId, {String? reason}) async {
    try {
      final response = await _supabase.rpc(
        'approve_event_by_owner',
        params: {
          'p_event_id': eventId,
          'p_approved': false,
          'p_reason': reason,
        },
      );
      
      if (response == null || response == false) {
        throw Exception('No se pudo rechazar el evento');
      }
      
      debugPrint('✅ Evento rechazado por dueño: $eventId');
      return true;
    } catch (e) {
      debugPrint('❌ Error al rechazar evento: $e');
      rethrow;
    }
  }
  
  /// Obtiene los eventos pendientes de aprobación para los venues del usuario
  /// [venueId] Si se proporciona, filtra solo eventos de ese venue
  Future<List<Event>> getPendingEventsForMyVenues({String? venueId}) async {
    try {
      final userId = AuthService.instance.currentUserId;
      if (userId == null) return [];
      
      // Si se proporciona un venueId, verificar que el usuario es dueño
      List<String> venueIds;
      if (venueId != null) {
        // Verificar ownership
        try {
          await _supabase
              .from('venues')
              .select('id')
              .eq('id', venueId)
              .eq('owner_id', userId)
              .single();
          
          venueIds = [venueId];
        } catch (e) {
          debugPrint('⚠️ El usuario no es dueño del venue: $venueId');
          return [];
        }
      } else {
        // Obtener todos los venues del usuario
        final venuesResponse = await _supabase
            .from('venues')
            .select('id')
            .eq('owner_id', userId);
        
        if (venuesResponse.isEmpty) return [];
        
        venueIds = (venuesResponse as List)
          .map((v) => v['id'] as String)
          .toList();
      }
      
      // Obtener eventos pendientes de aprobación del dueño
      var query = _supabase
          .from('events')
          .select('''
            id,
            title,
            city_id,
            city_name,
            category_id,
            category_name,
            starts_at,
            image_url,
            maps_url,
            place,
            is_featured,
            price,
            category_icon,
            category_color,
            description,
            image_alignment,
            status,
            venue_id,
            owner_approved,
            owner_approved_at,
            owner_rejected_reason
          ''');
      
      // Filtrar por múltiples venue_ids usando OR
      if (venueIds.length == 1) {
        query = query.eq('venue_id', venueIds.first);
      } else {
        final orCondition = venueIds.map((id) => 'venue_id.eq.$id').join(',');
        query = query.or(orCondition);
      }
      
      // Filtrar eventos donde owner_approved es NULL (pendientes de aprobación)
      // En Postgrest, usamos el operador 'is' con 'null' como string
      final eventsResponse = await query
          .filter('owner_approved', 'is', 'null')
          .order('starts_at', ascending: true);
      
      return (eventsResponse as List)
          .map((e) => Event.fromMap(e as Map<String, dynamic>))
          .toList();
    } catch (e) {
      debugPrint('❌ Error al obtener eventos pendientes: $e');
      rethrow;
    }
  }
  
  /// Obtiene todos los eventos de los venues del usuario (aprobados y pendientes)
  /// [venueId] Si se proporciona, filtra solo eventos de ese venue
  Future<List<Event>> getAllEventsForMyVenues({String? venueId}) async {
    try {
      final userId = AuthService.instance.currentUserId;
      if (userId == null) return [];
      
      // Si se proporciona un venueId, verificar que el usuario es dueño
      List<String> venueIds;
      if (venueId != null) {
        // Verificar ownership
        try {
          await _supabase
              .from('venues')
              .select('id')
              .eq('id', venueId)
              .eq('owner_id', userId)
              .single();
          
          venueIds = [venueId];
        } catch (e) {
          debugPrint('⚠️ El usuario no es dueño del venue: $venueId');
          return [];
        }
      } else {
        // Obtener todos los venues del usuario
        final venuesResponse = await _supabase
            .from('venues')
            .select('id')
            .eq('owner_id', userId);
        
        if (venuesResponse.isEmpty) return [];
        
        venueIds = (venuesResponse as List)
            .map((v) => v['id'] as String)
            .toList();
      }
      
      // Obtener todos los eventos
      var query = _supabase
          .from('events')
          .select('''
            id,
            title,
            city_id,
            city_name,
            category_id,
            category_name,
            starts_at,
            image_url,
            maps_url,
            place,
            is_featured,
            price,
            category_icon,
            category_color,
            description,
            image_alignment,
            status,
            venue_id,
            owner_approved,
            owner_approved_at,
            owner_rejected_reason
          ''');
      
      // Filtrar por múltiples venue_ids usando OR
      if (venueIds.length == 1) {
        query = query.eq('venue_id', venueIds.first);
      } else {
        final orCondition = venueIds.map((id) => 'venue_id.eq.$id').join(',');
        query = query.or(orCondition);
      }
      
      final eventsResponse = await query
          .order('starts_at', ascending: true);
      
      return (eventsResponse as List)
          .map((e) => Event.fromMap(e as Map<String, dynamic>))
          .toList();
    } catch (e) {
      debugPrint('❌ Error al obtener eventos: $e');
      rethrow;
    }
  }
  
  /// Verifica si el usuario puede aprobar/rechazar un evento
  Future<bool> canApproveEvent(String eventId) async {
    try {
      final userId = AuthService.instance.currentUserId;
      if (userId == null) return false;
      
      // Obtener el venue del evento
      final eventResponse = await _supabase
          .from('events')
          .select('venue_id')
          .eq('id', eventId)
          .single();
      
      final venueId = eventResponse['venue_id'] as String?;
      if (venueId == null) return false;
      
      // Verificar si el usuario es dueño del venue
      final venueResponse = await _supabase
          .from('venues')
          .select('owner_id')
          .eq('id', venueId)
          .single();
      
      return venueResponse['owner_id'] == userId;
    } catch (e) {
      debugPrint('❌ Error al verificar permisos: $e');
      return false;
    }
  }
}

