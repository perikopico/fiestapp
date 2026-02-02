// lib/ui/onboarding/notification_preferences_screen.dart
// Redirige al usuario a la pantalla unificada de preferencias de notificaciones
// en modo onboarding (sin AppBar con back, botón Continuar → Dashboard).

import 'package:flutter/material.dart';
import '../notifications/notification_settings_screen.dart';

class NotificationPreferencesScreen extends StatelessWidget {
  const NotificationPreferencesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const NotificationSettingsScreen(isOnboarding: true);
  }
}
