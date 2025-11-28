// lib/services/notification_handler.dart
import 'package:flutter/foundation.dart' show debugPrint;
import 'package:flutter/material.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import '../main.dart'; // Para acceder a navigatorKey
import 'firebase_messaging_background.dart'; // Importar el handler de background

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
      FirebaseMessaging.onMessageOpenedApp.listen(_handleMessageOpenedApp);
      
      // Handler para cuando se toca una notificación y la app estaba cerrada
      final initialMessage = await messaging.getInitialMessage();
      if (initialMessage != null) {
        _handleMessageOpenedApp(initialMessage);
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
    
    // Mostrar notificación local usando un SnackBar o un diálogo
    // En una app real, podrías usar un plugin como flutter_local_notifications
    _showNotificationInApp(message);
  }
  
  /// Maneja cuando el usuario toca una notificación (app en background o cerrada)
  void _handleMessageOpenedApp(RemoteMessage message) {
    debugPrint("👆 Usuario tocó la notificación: ${message.messageId}");
    debugPrint("   Datos: ${message.data}");
    
    // Navegar a la pantalla correspondiente según los datos de la notificación
    _navigateFromNotification(message);
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
          onPressed: () => _navigateFromNotification(message),
        ),
      ),
    );
  }
  
  /// Navega a la pantalla correspondiente según los datos de la notificación
  void _navigateFromNotification(RemoteMessage message) {
    final context = navigatorKey.currentContext;
    if (context == null) return;
    
    final data = message.data;
    
    // Ejemplo: Si la notificación tiene un event_id, navegar al detalle del evento
    if (data.containsKey('event_id')) {
      final eventId = data['event_id'] as String;
      // TODO: Navegar a EventDetailScreen con el eventId
      debugPrint("📍 Navegar a evento: $eventId");
      // Navigator.of(context).pushNamed('/event/$eventId');
    }
    
    // Ejemplo: Si la notificación tiene un tipo, manejar según el tipo
    if (data.containsKey('type')) {
      final type = data['type'] as String;
      switch (type) {
        case 'event_approved':
          // Navegar a "Mis eventos"
          debugPrint("📍 Evento aprobado, navegar a mis eventos");
          break;
        case 'event_rejected':
          // Navegar a "Mis eventos"
          debugPrint("📍 Evento rechazado, navegar a mis eventos");
          break;
        case 'new_event_in_favorite_category':
          // Navegar al dashboard o al evento
          debugPrint("📍 Nuevo evento en categoría favorita");
          break;
        default:
          debugPrint("📍 Tipo de notificación desconocido: $type");
      }
    }
  }
}
