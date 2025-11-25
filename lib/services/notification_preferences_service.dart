// lib/services/notification_preferences_service.dart
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'dart:convert';
import '../models/notification_rule.dart';

/// Servicio para gestionar las preferencias de notificaciones del usuario
class NotificationPreferencesService {
  NotificationPreferencesService._();
  static final NotificationPreferencesService instance =
      NotificationPreferencesService._();

  final supa = Supabase.instance.client;

  // Keys para SharedPreferences
  static const String _keyNotificationsEnabled = 'notifications_enabled';
  static const String _keyNotifyForFavorites = 'notify_for_favorites';
  static const String _keyNotificationRules = 'notification_rules';

  /// Obtiene el ID del usuario actual (o un ID de dispositivo si no hay autenticación)
  Future<String> _getUserId() async {
    // Si hay autenticación, usar el user ID
    final user = supa.auth.currentUser;
    if (user != null) {
      return user.id;
    }
    // Si no hay autenticación, usar un ID de dispositivo persistente
    final prefs = await SharedPreferences.getInstance();
    String? deviceId = prefs.getString('device_id');
    if (deviceId == null) {
      deviceId = DateTime.now().millisecondsSinceEpoch.toString();
      await prefs.setString('device_id', deviceId);
    }
    return deviceId;
  }

  /// Carga las preferencias de notificaciones desde SharedPreferences
  Future<Map<String, dynamic>> loadPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    return {
      'notificationsEnabled':
          prefs.getBool(_keyNotificationsEnabled) ?? true,
      'notifyForFavorites': prefs.getBool(_keyNotifyForFavorites) ?? true,
    };
  }

  /// Guarda las preferencias de notificaciones en SharedPreferences
  Future<void> savePreferences({
    required bool notificationsEnabled,
    required bool notifyForFavorites,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_keyNotificationsEnabled, notificationsEnabled);
    await prefs.setBool(_keyNotifyForFavorites, notifyForFavorites);

    // También intentar guardar en Supabase si hay autenticación
    try {
      // TODO: Implementar guardado en Supabase cuando haya tabla de user_preferences
      // final userId = await _getUserId();
      // await supa.from('user_preferences').upsert({
      //   'user_id': userId,
      //   'notifications_enabled': notificationsEnabled,
      //   'notify_for_favorites': notifyForFavorites,
      // });
    } catch (e) {
      debugPrint('Error al guardar preferencias en Supabase: $e');
    }
  }

  /// Carga las reglas de notificación desde SharedPreferences
  Future<List<NotificationRule>> loadNotificationRules() async {
    final prefs = await SharedPreferences.getInstance();
    final rulesJson = prefs.getString(_keyNotificationRules);

    if (rulesJson == null || rulesJson.isEmpty) {
      return [];
    }

    try {
      final List<dynamic> rulesList = json.decode(rulesJson);
      return rulesList
          .map((r) => NotificationRule.fromMap(r as Map<String, dynamic>))
          .toList();
    } catch (e) {
      debugPrint('Error al cargar reglas de notificación: $e');
      return [];
    }
  }

  /// Guarda las reglas de notificación en SharedPreferences
  Future<void> saveNotificationRules(List<NotificationRule> rules) async {
    final prefs = await SharedPreferences.getInstance();
    final rulesJson = json.encode(rules.map((r) => r.toMap()).toList());
    await prefs.setString(_keyNotificationRules, rulesJson);

    // También intentar guardar en Supabase si hay autenticación
    try {
      // TODO: Implementar guardado en Supabase cuando haya tabla notification_rules
      // final userId = await _getUserId();
      // Primero eliminar reglas existentes del usuario
      // await supa.from('notification_rules').delete().eq('user_id', userId);
      // Luego insertar las nuevas
      // for (final rule in rules) {
      //   await supa.from('notification_rules').insert({
      //     'user_id': userId,
      //     'province_id': rule.provinceId,
      //     'city_ids': rule.cityIds,
      //     'category_ids': rule.categoryIds,
      //     'is_active': rule.isActive,
      //   });
      // }
    } catch (e) {
      debugPrint('Error al guardar reglas en Supabase: $e');
    }
  }

  /// Carga las reglas desde Supabase (si hay autenticación)
  Future<List<NotificationRule>> fetchNotificationRulesForUser(
      String userId) async {
    try {
      final res = await supa
          .from('notification_rules')
          .select()
          .eq('user_id', userId)
          .order('created_at', ascending: false);

      return (res as List)
          .map((r) => NotificationRule.fromMap(r as Map<String, dynamic>))
          .toList();
    } catch (e) {
      debugPrint('Error al cargar reglas desde Supabase: $e');
      // Fallback a SharedPreferences
      return loadNotificationRules();
    }
  }

  /// Crea una regla por defecto con todas las ciudades y categorías
  Future<NotificationRule> createDefaultRule({
    required int provinceId,
    required List<int> allCityIds,
    required List<int> allCategoryIds,
  }) async {
    return NotificationRule(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      provinceId: provinceId,
      cityIds: allCityIds,
      categoryIds: allCategoryIds,
      isActive: true,
    );
  }
}

