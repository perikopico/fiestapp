// lib/services/notifications_count_service.dart
// Servicio para obtener el conteo de notificaciones no leídas

import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'auth_service.dart';

class NotificationsCountService {
  NotificationsCountService._();
  
  static final NotificationsCountService instance = NotificationsCountService._();
  
  final AuthService _authService = AuthService.instance;
  
  final ValueNotifier<int> unreadCount = ValueNotifier<int>(0);
  
  /// Obtiene el conteo de notificaciones no leídas
  Future<int> getUnreadCount() async {
    if (!_authService.isAuthenticated) {
      unreadCount.value = 0;
      return 0;
    }
    
    try {
      final userId = _authService.currentUserId;
      if (userId == null) {
        unreadCount.value = 0;
        return 0;
      }
      
      // Obtener conteo directamente desde la tabla
      // Usar filter con operador 'is' para verificar NULL (debe ser string 'null')
      final response = await Supabase.instance.client
          .from('notifications_history')
          .select('id')
          .eq('user_id', userId)
          .filter('read_at', 'is', 'null');
      
      final count = (response as List).length;
      unreadCount.value = count;
      return count;
    } catch (e) {
      debugPrint('Error obteniendo conteo de notificaciones: $e');
      unreadCount.value = 0;
      return 0;
    }
  }
  
  /// Actualiza el conteo periódicamente
  void startPolling({Duration interval = const Duration(seconds: 30)}) {
    // Obtener conteo inicial
    getUnreadCount();
    
    // Actualizar periódicamente
    Future.delayed(interval, () {
      if (_authService.isAuthenticated) {
        getUnreadCount();
        startPolling(interval: interval);
      }
    });
  }
  
  /// Detiene el polling (útil para cleanup)
  void stopPolling() {
    // En una implementación más compleja, podrías cancelar timers
    // Por ahora, simplemente no llamamos startPolling de nuevo
  }
}
