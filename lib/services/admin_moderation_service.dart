import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter/foundation.dart';
import 'auth_service.dart';
import 'notification_sender_service.dart';

class AdminModerationService {
  AdminModerationService._();

  static final AdminModerationService instance = AdminModerationService._();

  SupabaseClient get _client => Supabase.instance.client;
  final _authService = AuthService.instance;

  /// Verifica si el usuario actual tiene permisos de administrador
  /// Primero verifica autenticación, luego si es admin en la BD
  Future<bool> _checkAdminPermissions() async {
    if (!_authService.isAuthenticated) {
      debugPrint('❌ Usuario no autenticado');
      return false;
    }

    final userId = _authService.currentUserId;
    if (userId == null) {
      debugPrint('❌ No se pudo obtener ID de usuario');
      return false;
    }

    try {
      final response = await _client
          .from('admins')
          .select('user_id')
          .eq('user_id', userId)
          .maybeSingle();

      final isAdmin = response != null;
      if (!isAdmin) {
        debugPrint('❌ Usuario no es administrador');
      }
      return isAdmin;
    } catch (e) {
      debugPrint('❌ Error al verificar permisos de admin: $e');
      return false;
    }
  }

  Future<void> approveEvent(String eventId) async {
    // Verificar permisos antes de aprobar
    final hasPermissions = await _checkAdminPermissions();
    if (!hasPermissions) {
      throw Exception('No tienes permisos para aprobar eventos');
    }

    try {
      // Obtener información del evento antes de aprobarlo (para la notificación)
      final eventResponse = await _client
          .from('events')
          .select('title, created_by')
          .eq('id', eventId)
          .single();
      
      final eventTitle = eventResponse['title'] as String? ?? 'Tu evento';
      final createdByUserId = eventResponse['created_by'] as String?;
      
      // Aprobar el evento
      await _client
          .from('events')
          .update({'status': 'published'})
          .eq('id', eventId);
      
      debugPrint('✅ Evento $eventId aprobado por ${_authService.currentUserEmail}');
      
      // Enviar notificación al creador del evento
      if (createdByUserId != null && createdByUserId.isNotEmpty) {
        NotificationSenderService.instance
            .sendEventApprovedNotification(
              eventId: eventId,
              eventTitle: eventTitle,
              userId: createdByUserId,
            )
            .catchError((e) {
              debugPrint('⚠️ Error al enviar notificación de aprobación: $e');
              // No lanzamos el error para no interrumpir el flujo de aprobación
            });
      } else {
        debugPrint('⚠️ Evento no tiene created_by, no se enviará notificación');
      }
    } catch (e) {
      debugPrint('❌ Error al aprobar evento: $e');
      rethrow;
    }
  }

  Future<void> rejectEvent(String eventId, {String? reason}) async {
    // Verificar permisos antes de rechazar
    final hasPermissions = await _checkAdminPermissions();
    if (!hasPermissions) {
      throw Exception('No tienes permisos para rechazar eventos');
    }

    try {
      // Obtener información del evento antes de rechazarlo (para la notificación)
      final eventResponse = await _client
          .from('events')
          .select('title, created_by')
          .eq('id', eventId)
          .single();
      
      final eventTitle = eventResponse['title'] as String? ?? 'Tu evento';
      final createdByUserId = eventResponse['created_by'] as String?;
      
      // Rechazar el evento
      await _client
          .from('events')
          .update({'status': 'rejected'})
          .eq('id', eventId);
      
      debugPrint('✅ Evento $eventId rechazado por ${_authService.currentUserEmail}');
      
      // Enviar notificación al creador del evento
      if (createdByUserId != null && createdByUserId.isNotEmpty) {
        NotificationSenderService.instance
            .sendEventRejectedNotification(
              eventId: eventId,
              eventTitle: eventTitle,
              userId: createdByUserId,
              reason: reason,
            )
            .catchError((e) {
              debugPrint('⚠️ Error al enviar notificación de rechazo: $e');
              // No lanzamos el error para no interrumpir el flujo de rechazo
            });
      } else {
        debugPrint('⚠️ Evento no tiene created_by, no se enviará notificación');
      }
    } catch (e) {
      debugPrint('❌ Error al rechazar evento: $e');
      rethrow;
    }
  }
}
