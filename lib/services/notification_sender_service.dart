// lib/services/notification_sender_service.dart
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter/foundation.dart';

/// Servicio para enviar notificaciones push desde el backend
/// 
/// Este servicio usa Supabase Edge Function "send_fcm_notification" que a su vez
/// usa la API V1 de Firebase Cloud Messaging.
/// 
/// Requiere que la Edge Function esté desplegada y configurada con:
/// - FIREBASE_PROJECT_ID
/// - FIREBASE_SERVICE_ACCOUNT_KEY
class NotificationSenderService {
  NotificationSenderService._();
  
  static final NotificationSenderService instance = NotificationSenderService._();
  
  SupabaseClient get _client {
    try {
      return Supabase.instance.client;
    } catch (e) {
      throw Exception('Supabase no está inicializado. Asegúrate de que el archivo .env esté configurado correctamente.');
    }
  }
  
  /// Obtiene todos los tokens FCM de un usuario
  Future<List<String>> getUserTokens(String userId) async {
    try {
      final response = await _client
          .from('user_fcm_tokens')
          .select('token')
          .eq('user_id', userId);
      
      if (response == null || response.isEmpty) {
        return [];
      }
      
      return (response as List)
          .map((row) => row['token'] as String)
          .toList();
    } catch (e) {
      debugPrint('❌ Error al obtener tokens del usuario $userId: $e');
      return [];
    }
  }
  
  /// Envía una notificación a un token FCM específico usando Supabase Edge Function
  Future<bool> sendToToken({
    required String token,
    required String title,
    required String body,
    Map<String, dynamic>? data,
  }) async {
    try {
      // Llamar a la Supabase Edge Function
      final response = await _client.functions.invoke(
        'send_fcm_notification',
        body: {
          'token': token,
          'title': title,
          'body': body,
          if (data != null) 'data': data,
        },
      );
      
      if (response.status == 200) {
        final responseData = response.data;
        if (responseData['success'] == true) {
          debugPrint('✅ Notificación enviada exitosamente');
          return true;
        } else {
          debugPrint('⚠️ Error al enviar notificación: ${responseData['error']}');
          
          // Verificar si el error es UNREGISTERED (token inválido)
          final errorDetails = responseData['details'];
          if (errorDetails != null && errorDetails['error'] != null) {
            final fcmError = errorDetails['error'];
            final errorCode = fcmError['errorCode'] as String?;
            
            if (errorCode == 'UNREGISTERED') {
              debugPrint('🗑️ Token FCM inválido (UNREGISTERED), eliminándolo de la BD');
              await _deleteInvalidToken(token);
            }
          }
          
          return false;
        }
      } else {
        debugPrint('❌ Error HTTP al enviar notificación: ${response.status}');
        debugPrint('Respuesta: ${response.data}');
        
        // Verificar si el error es UNREGISTERED en la respuesta
        final responseData = response.data;
        if (responseData != null && responseData['details'] != null) {
          final errorDetails = responseData['details'];
          if (errorDetails['error'] != null) {
            final fcmError = errorDetails['error'];
            final errorCode = fcmError['errorCode'] as String?;
            
            if (errorCode == 'UNREGISTERED') {
              debugPrint('🗑️ Token FCM inválido (UNREGISTERED), eliminándolo de la BD');
              await _deleteInvalidToken(token);
            }
          }
        }
        
        return false;
      }
    } catch (e) {
      debugPrint('❌ Error al enviar notificación: $e');
      
      // Intentar extraer información del error si es FunctionException
      if (e.toString().contains('UNREGISTERED')) {
        debugPrint('🗑️ Token FCM inválido (UNREGISTERED), eliminándolo de la BD');
        await _deleteInvalidToken(token);
      }
      
      debugPrint('💡 Asegúrate de que la Edge Function "send_fcm_notification" esté desplegada');
      return false;
    }
  }
  
  /// Elimina un token FCM inválido de la base de datos
  Future<void> _deleteInvalidToken(String token) async {
    try {
      await _client
          .from('user_fcm_tokens')
          .delete()
          .eq('token', token);
      debugPrint('✅ Token inválido eliminado: ${token.substring(0, 20)}...');
    } catch (e) {
      debugPrint('⚠️ Error al eliminar token inválido: $e');
    }
  }
  
  /// Envía una notificación a todos los tokens de un usuario
  Future<bool> sendToUser({
    required String userId,
    required String title,
    required String body,
    Map<String, dynamic>? data,
  }) async {
    final tokens = await getUserTokens(userId);
    
    if (tokens.isEmpty) {
      debugPrint('⚠️ El usuario $userId no tiene tokens FCM registrados');
      return false;
    }
    
    bool atLeastOneSuccess = false;
    for (final token in tokens) {
      final success = await sendToToken(
        token: token,
        title: title,
        body: body,
        data: data,
      );
      if (success) {
        atLeastOneSuccess = true;
      }
      // Continuamos con los demás tokens aunque uno falle
    }
    
    return atLeastOneSuccess;
  }
  
  /// Envía notificación cuando un evento es aprobado
  Future<void> sendEventApprovedNotification({
    required String eventId,
    required String eventTitle,
    required String? userId, // ID del usuario que creó el evento
  }) async {
    if (userId == null || userId.isEmpty) {
      debugPrint('⚠️ No se puede enviar notificación: usuario no tiene ID');
      return;
    }
    
    await sendToUser(
      userId: userId,
      title: '✅ Tu evento ha sido aprobado',
      body: '"$eventTitle" ya está publicado en QuePlan',
      data: {
        'type': 'event_approved',
        'event_id': eventId,
        'route': '/event_detail',
      },
    );
  }
  
  /// Envía notificación cuando un evento es rechazado
  Future<void> sendEventRejectedNotification({
    required String eventId,
    required String eventTitle,
    required String? userId,
    String? reason,
  }) async {
    if (userId == null || userId.isEmpty) {
      debugPrint('⚠️ No se puede enviar notificación: usuario no tiene ID');
      return;
    }
    
    final body = reason != null && reason.isNotEmpty
        ? '"$eventTitle" ha sido rechazado: $reason'
        : '"$eventTitle" ha sido rechazado';
    
    await sendToUser(
      userId: userId,
      title: '❌ Tu evento ha sido rechazado',
      body: body,
      data: {
        'type': 'event_rejected',
        'event_id': eventId,
        'route': '/my_events',
      },
    );
  }
}

