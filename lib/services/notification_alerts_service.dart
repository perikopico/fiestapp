import 'package:shared_preferences/shared_preferences.dart';
import 'logger_service.dart';

/// Servicio simple para gestionar alertas de notificaciones (categorías, eventos, ciudades)
/// Usa SharedPreferences para persistencia local
class NotificationAlertsService {
  NotificationAlertsService._();
  static final NotificationAlertsService instance = NotificationAlertsService._();

  // Keys para SharedPreferences
  static const String _keyCategoryPrefix = 'alert_category_';
  static const String _keyFollowedEventsPrefix = 'followed_event_';
  static const String _keyFollowedCitiesPrefix = 'followed_city_';

  /// Verifica si las alertas están activas para una categoría
  Future<bool> isCategoryAlertEnabled(int categoryId) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return prefs.getBool('$_keyCategoryPrefix$categoryId') ?? false;
    } catch (e) {
      LoggerService.instance.error('Error al verificar alerta de categoría', error: e);
      return false;
    }
  }

  /// Activa o desactiva las alertas para una categoría
  Future<void> setCategoryAlertEnabled(int categoryId, bool enabled) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('$_keyCategoryPrefix$categoryId', enabled);
      LoggerService.instance.debug('Alerta de categoría actualizada', data: {
        'categoryId': categoryId,
        'enabled': enabled,
      });
    } catch (e) {
      LoggerService.instance.error('Error al actualizar alerta de categoría', error: e);
    }
  }

  /// Verifica si un evento está siendo seguido
  Future<bool> isEventFollowed(String eventId) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return prefs.getBool('$_keyFollowedEventsPrefix$eventId') ?? false;
    } catch (e) {
      LoggerService.instance.error('Error al verificar seguimiento de evento', error: e);
      return false;
    }
  }

  /// Activa o desactiva el seguimiento de un evento
  Future<void> setEventFollowed(String eventId, bool followed) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('$_keyFollowedEventsPrefix$eventId', followed);
      LoggerService.instance.debug('Seguimiento de evento actualizado', data: {
        'eventId': eventId,
        'followed': followed,
      });
    } catch (e) {
      LoggerService.instance.error('Error al actualizar seguimiento de evento', error: e);
    }
  }

  /// Verifica si una ciudad está siendo seguida
  Future<bool> isCityFollowed(int cityId) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return prefs.getBool('$_keyFollowedCitiesPrefix$cityId') ?? false;
    } catch (e) {
      LoggerService.instance.error('Error al verificar seguimiento de ciudad', error: e);
      return false;
    }
  }

  /// Activa o desactiva el seguimiento de una ciudad
  Future<void> setCityFollowed(int cityId, bool followed) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('$_keyFollowedCitiesPrefix$cityId', followed);
      LoggerService.instance.debug('Seguimiento de ciudad actualizado', data: {
        'cityId': cityId,
        'followed': followed,
      });
    } catch (e) {
      LoggerService.instance.error('Error al actualizar seguimiento de ciudad', error: e);
    }
  }

  /// Obtiene todas las categorías con alertas activas
  Future<Set<int>> getEnabledCategoryIds() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final keys = prefs.getKeys();
      final enabledIds = <int>{};
      
      for (final key in keys) {
        if (key.startsWith(_keyCategoryPrefix)) {
          final categoryIdStr = key.substring(_keyCategoryPrefix.length);
          final categoryId = int.tryParse(categoryIdStr);
          if (categoryId != null && (prefs.getBool(key) ?? false)) {
            enabledIds.add(categoryId);
          }
        }
      }
      
      return enabledIds;
    } catch (e) {
      LoggerService.instance.error('Error al obtener categorías con alertas', error: e);
      return {};
    }
  }
}
