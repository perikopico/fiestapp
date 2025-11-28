// lib/services/firebase_messaging_background.dart
// IMPORTANTE: Este archivo debe ser importado en main.dart antes de runApp()
// porque contiene una función de nivel superior necesaria para el background handler

import 'package:flutter/foundation.dart' show debugPrint;
import 'package:firebase_messaging/firebase_messaging.dart';

/// Handler para notificaciones cuando la app está en background o cerrada
/// Esta función DEBE ser de nivel superior (no dentro de una clase)
/// y debe ser anotada con @pragma('vm:entry-point')
@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  debugPrint("📨 Notificación recibida en background: ${message.messageId}");
  debugPrint("   Título: ${message.notification?.title}");
  debugPrint("   Cuerpo: ${message.notification?.body}");
  debugPrint("   Datos: ${message.data}");
  
  // Aquí puedes procesar la notificación en background
  // Por ejemplo, actualizar una base de datos local, mostrar una notificación local, etc.
}
