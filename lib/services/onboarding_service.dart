// lib/services/onboarding_service.dart
import 'package:shared_preferences/shared_preferences.dart';

/// Servicio para manejar el estado del onboarding
class OnboardingService {
  OnboardingService._();
  static final OnboardingService instance = OnboardingService._();

  static const String _keyHasSeenPermissionOnboarding = 'hasSeenPermissionOnboarding';
  static const String _keyHasSeenNotificationPreferences = 'hasSeenNotificationPreferences';

  /// Verifica si el usuario ya ha visto el onboarding de permisos
  Future<bool> hasSeenPermissionOnboarding() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_keyHasSeenPermissionOnboarding) ?? false;
  }

  /// Marca que el usuario ha visto el onboarding de permisos
  Future<void> markPermissionOnboardingSeen() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_keyHasSeenPermissionOnboarding, true);
  }

  /// Verifica si el usuario ya ha configurado las preferencias de notificaciones
  Future<bool> hasSeenNotificationPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_keyHasSeenNotificationPreferences) ?? false;
  }

  /// Marca que el usuario ha configurado las preferencias de notificaciones
  Future<void> markNotificationPreferencesSeen() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_keyHasSeenNotificationPreferences, true);
  }

  /// Resetea todos los flags (útil para testing)
  Future<void> reset() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_keyHasSeenPermissionOnboarding);
    await prefs.remove(_keyHasSeenNotificationPreferences);
  }
}

