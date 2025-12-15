// lib/services/gdpr_consent_service.dart
import 'package:supabase_flutter/supabase_flutter.dart';

/// Servicio para gestionar consentimientos GDPR
class GDPRConsentService {
  static final GDPRConsentService instance = GDPRConsentService._();
  GDPRConsentService._();

  /// Guarda o actualiza los consentimientos del usuario
  Future<void> saveConsents({
    required bool consentLocation,
    required bool consentNotifications,
    required bool consentProfile,
    required bool consentAnalytics,
    required bool acceptedTerms,
    required bool acceptedPrivacyPolicy,
  }) async {
    final user = Supabase.instance.client.auth.currentUser;
    if (user == null) {
      throw Exception('No hay usuario autenticado');
    }

    try {
      await Supabase.instance.client.from('user_consents').upsert({
        'user_id': user.id,
        'consent_location': consentLocation,
        'consent_notifications': consentNotifications,
        'consent_profile': consentProfile,
        'consent_analytics': consentAnalytics,
        'accepted_terms': acceptedTerms,
        'accepted_privacy_policy': acceptedPrivacyPolicy,
        'consent_date': DateTime.now().toIso8601String(),
      });
    } catch (e) {
      throw Exception('Error al guardar consentimientos: $e');
    }
  }

  /// Obtiene los consentimientos del usuario actual
  Future<Map<String, dynamic>?> getConsents() async {
    final user = Supabase.instance.client.auth.currentUser;
    if (user == null) {
      return null;
    }

    try {
      final response = await Supabase.instance.client
          .from('user_consents')
          .select()
          .eq('user_id', user.id)
          .maybeSingle();

      return response as Map<String, dynamic>?;
    } catch (e) {
      return null;
    }
  }

  /// Verifica si el usuario ha aceptado los términos
  Future<bool> hasAcceptedTerms() async {
    final consents = await getConsents();
    return consents?['accepted_terms'] == true;
  }

  /// Verifica si el usuario ha aceptado la política de privacidad
  Future<bool> hasAcceptedPrivacyPolicy() async {
    final consents = await getConsents();
    return consents?['accepted_privacy_policy'] == true;
  }

  /// Verifica si el usuario necesita mostrar la pantalla de consentimiento
  Future<bool> needsConsentScreen() async {
    final consents = await getConsents();
    if (consents == null) {
      return true; // No tiene consentimientos guardados
    }
    // Si no ha aceptado términos o privacidad, necesita mostrar pantalla
    return consents['accepted_terms'] != true || 
           consents['accepted_privacy_policy'] != true;
  }
}

