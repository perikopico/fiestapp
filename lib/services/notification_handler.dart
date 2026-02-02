// lib/services/notification_handler.dart
import 'package:flutter/foundation.dart' show debugPrint;
import 'package:flutter/material.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import '../main.dart'; // Para acceder a navigatorKey
import 'firebase_messaging_background.dart'; // Importar el handler de background
import '../models/event.dart';
import 'event_service.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../ui/event/event_detail_screen.dart';
import '../ui/events/my_events_screen.dart';
import 'notifications_count_service.dart';
import 'auth_service.dart';

/// Servicio para manejar notificaciones en diferentes estados de la app
class NotificationHandler {
  NotificationHandler._();
  
  static final NotificationHandler instance = NotificationHandler._();
  
  bool _isInitialized = false;
  
  /// Inicializa los handlers de notificaciones
  Future<void> initialize() async {
    if (_isInitialized) return;
    
    try {
      final messaging = FirebaseMessaging.instance;
      
      // Handler para cuando la app está en foreground
      FirebaseMessaging.onMessage.listen(_handleForegroundMessage);
      
      // Handler para cuando se toca una notificación y la app estaba en background
      FirebaseMessaging.onMessageOpenedApp.listen((message) {
        // Ignoramos el Future; la navegación se hace de forma asíncrona
        _handleMessageOpenedApp(message);
      });
      
      // Handler para cuando se toca una notificación y la app estaba cerrada
      final initialMessage = await messaging.getInitialMessage();
      if (initialMessage != null) {
        await _handleMessageOpenedApp(initialMessage);
      }
      
      // Configurar el handler de background (debe ser una función de nivel superior)
      FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);
      
      _isInitialized = true;
      debugPrint("✅ Handlers de notificaciones inicializados");
    } catch (e) {
      debugPrint("❌ Error al inicializar handlers de notificaciones: $e");
    }
  }
  
  /// Maneja notificaciones cuando la app está en foreground
  void _handleForegroundMessage(RemoteMessage message) {
    debugPrint("📨 Notificación recibida en foreground: ${message.messageId}");
    debugPrint("   Título: ${message.notification?.title}");
    debugPrint("   Cuerpo: ${message.notification?.body}");
    debugPrint("   Datos: ${message.data}");
    
    // Guardar en historial si el usuario está autenticado
    _saveReceivedNotificationToHistory(message);
    
    // Actualizar conteo de notificaciones
    NotificationsCountService.instance.getUnreadCount();
    
    // Mostrar notificación local usando un SnackBar o un diálogo
    // En una app real, podrías usar un plugin como flutter_local_notifications
    _showNotificationInApp(message);
  }
  
  /// Maneja cuando el usuario toca una notificación (app en background o cerrada)
  Future<void> _handleMessageOpenedApp(RemoteMessage message) async {
    debugPrint("👆 Usuario tocó la notificación: ${message.messageId}");
    debugPrint("   Datos: ${message.data}");
    
    // Guardar en historial si el usuario está autenticado
    _saveReceivedNotificationToHistory(message);
    
    // Actualizar conteo de notificaciones
    NotificationsCountService.instance.getUnreadCount();
    
    // Navegar a la pantalla correspondiente según los datos de la notificación
    await _navigateFromNotification(message);
  }
  
  /// Guarda una notificación recibida en el historial
  /// Esto es útil para notificaciones por topic que no se guardan en el backend
  Future<void> _saveReceivedNotificationToHistory(RemoteMessage message) async {
    try {
      final authService = AuthService.instance;
      if (!authService.isAuthenticated) {
        return; // No guardar si el usuario no está autenticado
      }
      
      final userId = authService.currentUserId;
      if (userId == null) {
        return;
      }
      
      final title = message.notification?.title ?? 'Notificación';
      final body = message.notification?.body ?? '';
      final data = message.data;
      final notificationType = data['type'] as String? ?? 'unknown';
      final eventId = data['id'] as String? ?? data['event_id'] as String?;
      
      // Verificar si ya existe esta notificación (evitar duplicados)
      // Buscar por título, cuerpo y event_id en las últimas 24 horas
      final oneDayAgo = DateTime.now().subtract(const Duration(days: 1)).toIso8601String();
      final existing = await Supabase.instance.client
          .from('notifications_history')
          .select('id')
          .eq('user_id', userId)
          .eq('title', title)
          .eq('body', body)
          .gte('sent_at', oneDayAgo)
          .limit(1);
      
      if (existing != null && (existing as List).isNotEmpty) {
        debugPrint('📋 Notificación ya existe en historial, no se duplica');
        return;
      }
      
      // Guardar en historial
      await Supabase.instance.client
          .from('notifications_history')
          .insert({
            'user_id': userId,
            'title': title,
            'body': body,
            'data': data,
            'notification_type': notificationType,
            'event_id': eventId,
            'fcm_message_id': message.messageId,
            'delivery_status': 'delivered', // Ya fue entregada
            'sent_at': DateTime.now().toIso8601String(),
          });
      
      debugPrint('✅ Notificación guardada en historial');
    } catch (e) {
      debugPrint('⚠️ Error guardando notificación en historial: $e');
      // No lanzar error, solo loguear
    }
  }
  
  /// Muestra la notificación en la app cuando está en foreground
  void _showNotificationInApp(RemoteMessage message) {
    final context = navigatorKey.currentContext;
    if (context == null) return;
    
    // Mostrar un SnackBar con la notificación
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (message.notification?.title != null)
              Text(
                message.notification!.title!,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            if (message.notification?.body != null)
              Text(message.notification!.body!),
          ],
        ),
        duration: const Duration(seconds: 4),
        action: SnackBarAction(
          label: 'Ver',
          onPressed: () {
            // Disparamos la navegación pero no esperamos el Future
            _navigateFromNotification(message);
          },
        ),
      ),
    );
  }
  
  /// Navega a la pantalla correspondiente según los datos de la notificación
  Future<void> _navigateFromNotification(RemoteMessage message) async {
    final context = navigatorKey.currentContext;
    if (context == null) return;
    
    final data = message.data;
    
    // 1) Si hay un event_id, intentar abrir directamente el detalle del evento
    if (data.containsKey('event_id')) {
      final rawId = data['event_id'];
      final eventId = rawId?.toString().trim();
      if (eventId != null && eventId.isNotEmpty) {
        try {
          final List<Event> events =
              await EventService.instance.fetchEventsByIds(<String>[eventId]);
          if (events.isNotEmpty) {
            final event = events.first;
            debugPrint("📍 Navegar a EventDetailScreen para evento: $eventId");
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (_) => EventDetailScreen(event: event),
              ),
            );
            return;
          } else {
            debugPrint("⚠️ No se encontró evento con id $eventId");
          }
        } catch (e) {
          debugPrint("❌ Error al cargar evento $eventId desde notificación: $e");
        }
      }
    }
    
    // 2) Si no hay event_id o no se pudo cargar, usar el tipo de notificación
    if (data.containsKey('type')) {
      final type = data['type']?.toString();
      switch (type) {
        case 'event_approved':
        case 'event_rejected':
          // Navegar a pantalla "Mis eventos" para que el usuario vea el estado
          debugPrint("📍 Navegar a MyEventsScreen por tipo: $type");
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (_) => const MyEventsScreen(),
            ),
          );
          break;
        case 'new_event_in_favorite_category':
          // Por ahora solo log; en el futuro podríamos abrir el dashboard filtrado
          debugPrint("📍 Nuevo evento en categoría favorita (sin navegación específica)");
          break;
        default:
          debugPrint("📍 Tipo de notificación desconocido: $type");
      }
    }
  }
}
