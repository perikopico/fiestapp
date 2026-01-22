import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/foundation.dart';
import 'logger_service.dart';

/// Servicio de analytics para trackear eventos de la aplicación
class AnalyticsService {
  AnalyticsService._();
  static final instance = AnalyticsService._();

  final FirebaseAnalytics _analytics = FirebaseAnalytics.instance;
  bool _isEnabled = true;

  /// Habilita o deshabilita el tracking de analytics
  void setEnabled(bool enabled) {
    _isEnabled = enabled;
  }

  /// Trackea visualización de un evento
  Future<void> logEventView(String eventId, {String? eventTitle}) async {
    if (!_isEnabled) return;

    try {
      await _analytics.logEvent(
        name: 'event_view',
        parameters: {
          'event_id': eventId,
          if (eventTitle != null) 'event_title': eventTitle,
        },
      );
      LoggerService.instance.debug('Analytics: Evento visto', data: {'event_id': eventId});
    } catch (e) {
      LoggerService.instance.error('Error al trackear event_view', error: e);
    }
  }

  /// Trackea búsqueda realizada
  Future<void> logSearch(String searchTerm) async {
    if (!_isEnabled) return;

    try {
      await _analytics.logSearch(searchTerm: searchTerm);
      LoggerService.instance.debug('Analytics: Búsqueda realizada', data: {'search_term': searchTerm});
    } catch (e) {
      LoggerService.instance.error('Error al trackear búsqueda', error: e);
    }
  }

  /// Trackea selección de categoría
  Future<void> logCategorySelected(int categoryId, {String? categoryName}) async {
    if (!_isEnabled) return;

    try {
      await _analytics.logEvent(
        name: 'category_selected',
        parameters: {
          'category_id': categoryId,
          if (categoryName != null) 'category_name': categoryName,
        },
      );
      LoggerService.instance.debug('Analytics: Categoría seleccionada', data: {'category_id': categoryId});
    } catch (e) {
      LoggerService.instance.error('Error al trackear selección de categoría', error: e);
    }
  }

  /// Trackea evento compartido
  Future<void> logEventShared(String eventId, {String? shareMethod}) async {
    if (!_isEnabled) return;

    try {
      await _analytics.logShare(
        contentType: 'event',
        itemId: eventId,
        method: shareMethod ?? 'unknown',
      );
      LoggerService.instance.debug('Analytics: Evento compartido', data: {'event_id': eventId});
    } catch (e) {
      LoggerService.instance.error('Error al trackear evento compartido', error: e);
    }
  }

  /// Trackea evento agregado a favoritos
  Future<void> logEventFavorited(String eventId) async {
    if (!_isEnabled) return;

    try {
      await _analytics.logEvent(
        name: 'event_favorited',
        parameters: {'event_id': eventId},
      );
      LoggerService.instance.debug('Analytics: Evento favorito', data: {'event_id': eventId});
    } catch (e) {
      LoggerService.instance.error('Error al trackear evento favorito', error: e);
    }
  }

  /// Trackea creación de evento
  Future<void> logEventCreated(String eventId) async {
    if (!_isEnabled) return;

    try {
      await _analytics.logEvent(
        name: 'event_created',
        parameters: {'event_id': eventId},
      );
      LoggerService.instance.debug('Analytics: Evento creado', data: {'event_id': eventId});
    } catch (e) {
      LoggerService.instance.error('Error al trackear evento creado', error: e);
    }
  }

  /// Trackea cambio de modo de búsqueda (ciudad/radio)
  Future<void> logLocationModeChanged(String mode) async {
    if (!_isEnabled) return;

    try {
      await _analytics.logEvent(
        name: 'location_mode_changed',
        parameters: {'mode': mode},
      );
      LoggerService.instance.debug('Analytics: Modo de ubicación cambiado', data: {'mode': mode});
    } catch (e) {
      LoggerService.instance.error('Error al trackear cambio de modo', error: e);
    }
  }

  /// Trackea pantalla vista
  Future<void> logScreenView(String screenName) async {
    if (!_isEnabled) return;

    try {
      await _analytics.logScreenView(screenName: screenName);
      LoggerService.instance.debug('Analytics: Pantalla vista', data: {'screen_name': screenName});
    } catch (e) {
      LoggerService.instance.error('Error al trackear pantalla', error: e);
    }
  }
}
