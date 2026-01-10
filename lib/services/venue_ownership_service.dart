import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter/foundation.dart';
import '../models/venue.dart';
import 'auth_service.dart';

/// Servicio para gestionar el ownership de venues
class VenueOwnershipService {
  VenueOwnershipService._();
  
  static final VenueOwnershipService instance = VenueOwnershipService._();
  
  SupabaseClient get _supabase {
    try {
      return Supabase.instance.client;
    } catch (e) {
      throw Exception('Supabase no está inicializado. Asegúrate de que el archivo .env esté configurado correctamente.');
    }
  }
  
  /// Crea una solicitud de ownership para un venue
  /// 
  /// [venueId] ID del venue que se quiere reclamar
  /// [verificationMethod] Método de verificación: 'email', 'phone', 'social_media'
  /// [contactInfo] Email, teléfono o handle de redes sociales
  /// 
  /// Retorna el ID de la solicitud creada
  Future<String> requestOwnership({
    required String venueId,
    required String verificationMethod,
    required String contactInfo,
  }) async {
    try {
      final response = await _supabase.rpc(
        'create_venue_ownership_request',
        params: {
          'p_venue_id': venueId,
          'p_verification_method': verificationMethod,
          'p_contact_info': contactInfo,
        },
      );
      
      if (response == null) {
        throw Exception('No se pudo crear la solicitud');
      }
      
      final requestId = response as String;
      
      // Llamar a la función edge para notificar a los admins
      try {
        await _supabase.functions.invoke(
          'notify_venue_ownership_request',
          body: {'request_id': requestId},
        );
      } catch (e) {
        // No fallar si la notificación falla, solo loggear
        debugPrint('⚠️ Error al enviar notificación a admins: $e');
      }
      
      debugPrint('✅ Solicitud de ownership creada: $requestId');
      return requestId;
    } catch (e) {
      debugPrint('❌ Error al crear solicitud de ownership: $e');
      rethrow;
    }
  }
  
  /// Verifica un código de verificación para aprobar el ownership
  /// Solo puede ser llamado por un admin
  /// 
  /// [requestId] ID de la solicitud
  /// [verificationCode] Código de verificación de 6 dígitos
  Future<bool> verifyOwnership({
    required String requestId,
    required String verificationCode,
  }) async {
    try {
      final response = await _supabase.rpc(
        'verify_venue_ownership',
        params: {
          'p_request_id': requestId,
          'p_verification_code': verificationCode,
        },
      );
      
      if (response == null || response == false) {
        throw Exception('No se pudo verificar el ownership');
      }
      
      debugPrint('✅ Ownership verificado para solicitud: $requestId');
      return true;
    } catch (e) {
      debugPrint('❌ Error al verificar ownership: $e');
      rethrow;
    }
  }
  
  /// Verifica un código de verificación para aprobar el ownership
  /// Puede ser llamado por el usuario que creó la solicitud
  /// 
  /// [verificationCode] Código de verificación de 6 dígitos que el usuario recibió del admin
  Future<bool> verifyOwnershipByUser({
    required String verificationCode,
  }) async {
    try {
      final response = await _supabase.rpc(
        'verify_venue_ownership_by_user',
        params: {
          'p_verification_code': verificationCode,
        },
      );
      
      if (response == null || response == false) {
        throw Exception('No se pudo verificar el ownership');
      }
      
      debugPrint('✅ Ownership verificado por usuario con código: $verificationCode');
      return true;
    } catch (e) {
      debugPrint('❌ Error al verificar ownership: $e');
      rethrow;
    }
  }
  
  /// Rechaza una solicitud de ownership
  /// Solo puede ser llamado por un admin
  /// 
  /// [requestId] ID de la solicitud
  /// [reason] Razón del rechazo (opcional)
  Future<bool> rejectOwnership({
    required String requestId,
    String? reason,
  }) async {
    try {
      final response = await _supabase.rpc(
        'reject_venue_ownership',
        params: {
          'p_request_id': requestId,
          'p_reason': reason,
        },
      );
      
      if (response == null || response == false) {
        throw Exception('No se pudo rechazar la solicitud');
      }
      
      debugPrint('✅ Solicitud de ownership rechazada: $requestId');
      return true;
    } catch (e) {
      debugPrint('❌ Error al rechazar ownership: $e');
      rethrow;
    }
  }
  
  /// Obtiene las solicitudes de ownership del usuario actual
  Future<List<VenueOwnershipRequest>> getMyRequests() async {
    try {
      final response = await _supabase
          .from('venue_ownership_requests')
          .select('''
            id,
            venue_id,
            verification_code,
            verification_method,
            contact_info,
            status,
            verified_at,
            expires_at,
            created_at,
            venues!inner(id, name, city_id)
          ''')
          .order('created_at', ascending: false);
      
      return (response as List)
          .map((e) => VenueOwnershipRequest.fromMap(e as Map<String, dynamic>))
          .toList();
    } catch (e) {
      debugPrint('❌ Error al obtener solicitudes: $e');
      rethrow;
    }
  }
  
  /// Obtiene todas las solicitudes pendientes (solo para admins)
  Future<List<VenueOwnershipRequest>> getPendingRequests() async {
    try {
      // Primero obtenemos todas las solicitudes pendientes sin filtrar por expiración
      // para ver todas, incluso las expiradas (las mostraremos con un indicador)
      // Usamos left join para incluir solicitudes incluso si el venue fue eliminado
      final response = await _supabase
          .from('venue_ownership_requests')
          .select('''
            id,
            venue_id,
            verification_code,
            verification_method,
            contact_info,
            status,
            verified_at,
            expires_at,
            created_at,
            user_id,
            venues!left(id, name, city_id)
          ''')
          .eq('status', 'pending')
          .order('created_at', ascending: false);
      
      debugPrint('📋 Solicitudes encontradas: ${(response as List).length}');
      
      if ((response as List).isEmpty) {
        debugPrint('⚠️ No se encontraron solicitudes. Verificando permisos...');
        // Intentar una consulta más simple para verificar permisos
        final testResponse = await _supabase
            .from('venue_ownership_requests')
            .select('id')
            .limit(1);
        debugPrint('📊 Test query result: ${(testResponse as List).length} registros');
      }
      
      final requests = <VenueOwnershipRequest>[];
      for (final item in (response as List)) {
        try {
          debugPrint('📄 Procesando solicitud: ${item['id']}');
          final request = VenueOwnershipRequest.fromMap(item as Map<String, dynamic>);
          requests.add(request);
        } catch (e) {
          debugPrint('⚠️ Error al parsear solicitud: $e');
          debugPrint('⚠️ Datos: $item');
          // Continuar con las demás solicitudes
        }
      }
      
      debugPrint('✅ Solicitudes parseadas: ${requests.length}');
      return requests;
    } catch (e) {
      debugPrint('❌ Error al obtener solicitudes pendientes: $e');
      rethrow;
    }
  }
  
  /// Verifica si el usuario actual es dueño de un venue
  Future<bool> isOwnerOfVenue(String venueId) async {
    try {
      final userId = AuthService.instance.currentUserId;
      if (userId == null) return false;
      
      final response = await _supabase
          .from('venues')
          .select('owner_id')
          .eq('id', venueId)
          .single();
      
      return response['owner_id'] == userId;
    } catch (e) {
      debugPrint('❌ Error al verificar ownership: $e');
      return false;
    }
  }
  
  /// Obtiene los venues de los que el usuario actual es dueño
  Future<List<Venue>> getMyVenues() async {
    try {
      final userId = AuthService.instance.currentUserId;
      if (userId == null) return [];
      
      final response = await _supabase
          .from('venues')
          .select('*')
          .eq('owner_id', userId)
          .order('name', ascending: true);
      
      return (response as List)
          .map((e) => Venue.fromMap(e as Map<String, dynamic>))
          .toList();
    } catch (e) {
      debugPrint('❌ Error al obtener mis venues: $e');
      rethrow;
    }
  }
  
  /// Verifica si un venue ya tiene un dueño
  Future<bool> venueHasOwner(String venueId) async {
    try {
      final response = await _supabase
          .from('venues')
          .select('owner_id')
          .eq('id', venueId)
          .single();
      
      return response['owner_id'] != null;
    } catch (e) {
      debugPrint('❌ Error al verificar si venue tiene dueño: $e');
      return false;
    }
  }
}

/// Modelo para representar una solicitud de ownership
class VenueOwnershipRequest {
  final String id;
  final String venueId;
  final String? userId;
  final String verificationCode;
  final String verificationMethod;
  final String contactInfo;
  final String status; // 'pending', 'verified', 'rejected', 'expired'
  final DateTime? verifiedAt;
  final DateTime expiresAt;
  final DateTime createdAt;
  final Venue? venue;
  
  VenueOwnershipRequest({
    required this.id,
    required this.venueId,
    this.userId,
    required this.verificationCode,
    required this.verificationMethod,
    required this.contactInfo,
    required this.status,
    this.verifiedAt,
    required this.expiresAt,
    required this.createdAt,
    this.venue,
  });
  
  factory VenueOwnershipRequest.fromMap(Map<String, dynamic> map) {
    return VenueOwnershipRequest(
      id: map['id'] as String,
      venueId: map['venue_id'] as String,
      userId: map['user_id'] as String?,
      verificationCode: (map['verification_code'] as String?) ?? '',
      verificationMethod: (map['verification_method'] as String?) ?? 'email',
      contactInfo: (map['contact_info'] as String?) ?? '',
      status: map['status'] as String? ?? 'pending',
      verifiedAt: map['verified_at'] != null 
          ? DateTime.parse(map['verified_at'] as String) 
          : null,
      expiresAt: map['expires_at'] != null
          ? DateTime.parse(map['expires_at'] as String)
          : DateTime.now().add(const Duration(days: 7)),
      createdAt: map['created_at'] != null
          ? DateTime.parse(map['created_at'] as String)
          : DateTime.now(),
      venue: map['venues'] != null 
          ? _parseVenueFromJoin(map['venues'] as Map<String, dynamic>)
          : null,
    );
  }
  
  bool get isPending => status == 'pending';
  bool get isVerified => status == 'verified';
  bool get isRejected => status == 'rejected';
  bool get isExpired => expiresAt.isBefore(DateTime.now());
  bool get isValid => isPending && !isExpired;
  
  /// Parsea un venue desde un join (puede no tener todos los campos)
  static Venue _parseVenueFromJoin(Map<String, dynamic> map) {
    return Venue(
      id: map['id'] as String,
      name: map['name'] as String,
      cityId: (map['city_id'] as num).toInt(),
      cityName: null,
      address: null,
      lat: null,
      lng: null,
      status: 'pending', // Valor por defecto
      createdBy: null,
      rejectedReason: null,
      ownerId: null,
      verifiedAt: null,
      createdAt: DateTime.now(), // Valor por defecto
      updatedAt: DateTime.now(), // Valor por defecto
    );
  }
}

