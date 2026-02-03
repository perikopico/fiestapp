import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../services/auth_service.dart';
import '../services/category_service.dart';
import '../services/city_service.dart';

/// Resultado del procesamiento de un evento individual
class EventIngestionResult {
  final int eventId;
  final String status; // 'new', 'modified', 'cancelled', 'confirmed'
  final bool success;
  final String? error;
  final String action; // 'INSERT', 'UPDATE', 'DELETE', 'IGNORED'

  EventIngestionResult({
    required this.eventId,
    required this.status,
    required this.success,
    this.error,
    required this.action,
  });
}

/// Resultado del procesamiento completo del JSON
class IngestionSummary {
  final int total;
  final int success;
  final int failed;
  final List<EventIngestionResult> results;

  IngestionSummary({
    required this.total,
    required this.success,
    required this.failed,
    required this.results,
  });
}

class EventIngestionService {
  EventIngestionService._();

  static final EventIngestionService instance = EventIngestionService._();

  final _client = Supabase.instance.client;
  final _authService = AuthService.instance;
  final _categoryService = CategoryService();
  final _cityService = CityService.instance;

  /// Verifica permisos de administrador
  Future<bool> _checkAdminPermissions() async {
    if (!_authService.isAuthenticated) {
      debugPrint('❌ Usuario no autenticado');
      return false;
    }

    final isAdmin = await _authService.isAdmin();
    if (!isAdmin) {
      debugPrint('❌ Usuario no es administrador');
    }
    return isAdmin;
  }

  /// Valida el formato básico del JSON.
  /// Acepta dos formatos:
  /// 1) Flat: id, status, date, time, category, title, description, location_name, gmaps_link, price, info_url
  /// 2) Gemini/script: id, status, date, time, category, city, place, translations (con es.title), price
  bool _validateJsonFormat(dynamic json) {
    if (json is! List) {
      return false;
    }

    for (final item in json) {
      if (item is! Map<String, dynamic>) {
        return false;
      }

      // Campos comunes obligatorios en ambos formatos
      if (!item.containsKey('id') || !item.containsKey('status') ||
          !item.containsKey('date') || !item.containsKey('time') ||
          !item.containsKey('category') || !item.containsKey('price')) {
        return false;
      }

      // Formato flat: title, description, location_name, gmaps_link, info_url
      final hasFlat = item.containsKey('title') &&
          item.containsKey('description') &&
          item.containsKey('location_name') &&
          item.containsKey('gmaps_link') &&
          item.containsKey('info_url');

      // Formato Gemini: city, place, translations con es
      final translations = item['translations'];
      final hasTranslations = translations is Map<String, dynamic> &&
          translations.containsKey('es') &&
          (translations['es'] is Map) &&
          (translations['es'] as Map).containsKey('title');
      final hasCityPlace = item.containsKey('city') && item.containsKey('place');

      if (!hasFlat && !(hasTranslations && hasCityPlace)) {
        return false;
      }
    }

    return true;
  }

  /// Parsea external_id: "evt_001" -> 1, 42 -> 42
  int _parseExternalId(dynamic idVal) {
    if (idVal == null) throw Exception('id es obligatorio');
    if (idVal is int) return idVal;
    final s = idVal.toString().trim();
    final match = RegExp(r'evt_?(\d+)', caseSensitive: false).firstMatch(s);
    if (match != null) return int.parse(match.group(1)!);
    final parsed = int.tryParse(s);
    if (parsed != null) return parsed;
    throw Exception('id inválido: $idVal');
  }

  /// Normaliza un objeto evento del JSON a un mapa con campos planos (title, description, location_name, cityName, etc.)
  Map<String, dynamic> _normalizeEventData(Map<String, dynamic> eventData) {
    if (eventData.containsKey('title') && eventData.containsKey('description') && eventData.containsKey('location_name')) {
      // Ya está en formato flat; asegurar id numérico
      final id = _parseExternalId(eventData['id']);
      return {
        ...eventData,
        'id': id,
        'external_id': id,
      };
    }

    // Formato Gemini: translations, city, place
    final translations = eventData['translations'] as Map<String, dynamic>?;
    final es = translations?['es'] as Map<String, dynamic>?;
    final title = (es?['title'] as String?)?.trim() ?? '';
    final description = (es?['description'] as String?)?.trim() ?? '';

    final city = (eventData['city'] as String?)?.trim() ?? '';
    final place = (eventData['place'] as String?)?.trim() ?? '';
    final locationName = place.isNotEmpty ? place : city;

    final id = _parseExternalId(eventData['id']);

    return {
      'id': id,
      'external_id': id,
      'status': eventData['status'],
      'date': eventData['date'],
      'time': eventData['time'],
      'category': eventData['category'],
      'title': title,
      'description': description,
      'location_name': locationName,
      'city_name_for_lookup': city,
      'gmaps_link': (eventData['gmaps_link'] ?? eventData['maps_url'] ?? '') as String? ?? '',
      'price': (eventData['price'] as String?) ?? '',
      'info_url': (eventData['info_url'] as String?) ?? '',
      'translations': eventData['translations'],
    };
  }

  /// Obtiene el ID de una categoría por nombre
  Future<int?> _getCategoryIdByName(String categoryName) async {
    try {
      final categories = await _categoryService.fetchAll();
      final category = categories.firstWhere(
        (c) => c.name == categoryName,
        orElse: () => categories.firstWhere(
          (c) => c.name.toLowerCase().replaceAll(' ', '-') == categoryName.toLowerCase().replaceAll(' ', '-'),
          orElse: () => throw Exception('Categoría no encontrada'),
        ),
      );
      return category.id;
    } catch (e) {
      debugPrint('⚠️ Error al buscar categoría "$categoryName": $e');
      return null;
    }
  }

  /// Guarda en event_translations las traducciones en, de, zh cuando vienen en el JSON.
  Future<void> _saveEventTranslationsIfPresent(String eventId, dynamic translations) async {
    if (translations is! Map<String, dynamic>) return;
    for (final lang in ['en', 'de', 'zh']) {
      final block = translations[lang];
      if (block is! Map<String, dynamic>) continue;
      final title = (block['title'] as String?)?.trim();
      if (title == null || title.isEmpty) continue;
      final description = (block['description'] as String?)?.trim();
      try {
        await _client.from('event_translations').upsert(
          {
            'event_id': eventId,
            'language_code': lang,
            'title': title,
            'description': (description?.trim().isEmpty ?? true) ? null : description,
          },
          onConflict: 'event_id,language_code',
        );
      } catch (_) {
        // No fallar el ingesta si falla la traducción
      }
    }
  }

  /// Intenta extraer la ciudad del location_name o gmaps_link
  /// Si no se puede determinar, retorna null
  Future<int?> _findCityId(String locationName, String gmapsLink, String? cityName) async {
    // Si se proporciona el nombre de ciudad explícitamente, usarlo
    if (cityName != null && cityName.isNotEmpty) {
      final cityId = await _cityService.findCityIdByQuery(cityName);
      if (cityId != null) {
        return cityId;
      }
    }

    // Intentar buscar ciudades conocidas en el location_name
    final knownCities = ['Barbate', 'Vejer', 'Zahara', 'Conil', 'Chiclana', 'Jerez', 'Cádiz', 'El Puerto', 'Sanlúcar', 'Rota', 'Tarifa', 'Algeciras'];
    
    for (final city in knownCities) {
      if (locationName.toLowerCase().contains(city.toLowerCase())) {
        final cityId = await _cityService.findCityIdByQuery(city);
        if (cityId != null) {
          return cityId;
        }
      }
    }

    // Si no se encuentra, buscar todas las ciudades y intentar match
    final cities = await _cityService.fetchCities();
    for (final city in cities) {
      if (locationName.toLowerCase().contains(city.name.toLowerCase())) {
        return city.id;
      }
    }

    return null;
  }

  /// Procesa un evento individual según su status.
  /// Acepta formato flat o Gemini; internamente se normaliza.
  Future<EventIngestionResult> _processEvent(
    Map<String, dynamic> eventData,
    String? defaultCityName,
  ) async {
    final data = _normalizeEventData(eventData);
    final eventId = data['external_id'] as int;
    final status = data['status'] as String;
    final date = data['date'] as String;
    final time = data['time'] as String;
    final categoryName = data['category'] as String;
    final title = data['title'] as String;
    final description = data['description'] as String;
    final locationName = data['location_name'] as String;
    final gmapsLink = (data['gmaps_link'] as String?) ?? '';
    final price = (data['price'] as String?) ?? '';
    final infoUrl = (data['info_url'] as String?) ?? '';
    final cityNameForLookup = (data['city_name_for_lookup'] as String?)?.trim().isNotEmpty == true
        ? data['city_name_for_lookup'] as String
        : defaultCityName;

    try {
      // Si es 'confirmed', ignorar
      if (status == 'confirmed') {
        return EventIngestionResult(
          eventId: eventId,
          status: status,
          success: true,
          action: 'IGNORED',
        );
      }

      // Obtener category_id
      final categoryId = await _getCategoryIdByName(categoryName);
      if (categoryId == null) {
        return EventIngestionResult(
          eventId: eventId,
          status: status,
          success: false,
          error: 'Categoría "$categoryName" no encontrada',
          action: 'ERROR',
        );
      }

      // Obtener city_id (priorizar ciudad explícita del JSON o ciudad por defecto)
      final cityId = await _findCityId(locationName, gmapsLink, cityNameForLookup);
      if (cityId == null) {
        return EventIngestionResult(
          eventId: eventId,
          status: status,
          success: false,
          error: 'No se pudo determinar la ciudad para "$locationName"${cityNameForLookup != null ? " (ciudad por defecto: $cityNameForLookup)" : ""}',
          action: 'ERROR',
        );
      }

      // Parsear fecha y hora (normalizar HH:mm -> HH:mm:00 si hace falta)
      final timeStr = time.length == 5 && time.contains(':') ? '$time:00' : time;
      final startsAtStr = '$date $timeStr';
      DateTime startsAt;
      try {
        startsAt = DateTime.parse(startsAtStr);
      } catch (e) {
        return EventIngestionResult(
          eventId: eventId,
          status: status,
          success: false,
          error: 'Formato de fecha/hora inválido: $startsAtStr',
          action: 'ERROR',
        );
      }

      // Construir el objeto del evento
      final eventMap = {
        'title': title,
        'description': description,
        'starts_at': startsAt.toIso8601String(),
        'place': locationName,
        'maps_url': gmapsLink,
        'price': price,
        'info_url': infoUrl.isNotEmpty ? infoUrl : null,
        'city_id': cityId,
        'category_id': categoryId,
        'status': 'pending', // Pendientes para que el admin asigne imagen y publique
        'external_id': eventId, // Almacenar el ID del JSON
      };

      // Procesar según el status
      if (status == 'new') {
        // INSERT - crear nuevo evento
        // Verificar si ya existe un evento con este external_id
        final existingEvent = await _client
            .from('events')
            .select('id')
            .eq('external_id', eventId)
            .maybeSingle();

        if (existingEvent != null) {
          // Si ya existe, actualizarlo en lugar de crear uno nuevo
          final eventUuid = existingEvent['id'] as String;
          await _client.from('events').update(eventMap).eq('id', eventUuid);
          await _saveEventTranslationsIfPresent(eventUuid, data['translations']);
          return EventIngestionResult(
            eventId: eventId,
            status: status,
            success: true,
            action: 'UPDATE (ya existía con este external_id)',
          );
        } else {
          final insertRes = await _client.from('events').insert(eventMap).select('id').single();
          final eventUuid = insertRes['id'] as String;
          await _saveEventTranslationsIfPresent(eventUuid, data['translations']);
          return EventIngestionResult(
            eventId: eventId,
            status: status,
            success: true,
            action: 'INSERT',
          );
        }
      } else if (status == 'modified') {
        // UPDATE - buscar evento por external_id
        final existingEvent = await _client
            .from('events')
            .select('id')
            .eq('external_id', eventId)
            .maybeSingle();

        if (existingEvent != null) {
          final eventUuid = existingEvent['id'] as String;
          await _client.from('events').update(eventMap).eq('id', eventUuid);
          await _saveEventTranslationsIfPresent(eventUuid, data['translations']);
          return EventIngestionResult(
            eventId: eventId,
            status: status,
            success: true,
            action: 'UPDATE',
          );
        } else {
          // Si no se encuentra, crear uno nuevo
          final insertRes = await _client.from('events').insert(eventMap).select('id').single();
          final eventUuid = insertRes['id'] as String;
          await _saveEventTranslationsIfPresent(eventUuid, data['translations']);
          return EventIngestionResult(
            eventId: eventId,
            status: status,
            success: true,
            action: 'INSERT (no encontrado con external_id, creado nuevo)',
          );
        }
      } else if (status == 'cancelled') {
        // SOFT DELETE - buscar por external_id y marcar como rechazado
        final existingEvent = await _client
            .from('events')
            .select('id')
            .eq('external_id', eventId)
            .maybeSingle();

        if (existingEvent != null) {
          final eventUuid = existingEvent['id'] as String;
          // Marcar como rechazado (soft delete)
          await _client
              .from('events')
              .update({'status': 'rejected'})
              .eq('id', eventUuid);
          return EventIngestionResult(
            eventId: eventId,
            status: status,
            success: true,
            action: 'DELETE (soft)',
          );
        } else {
          return EventIngestionResult(
            eventId: eventId,
            status: status,
            success: false,
            error: 'Evento no encontrado con external_id $eventId para cancelar',
            action: 'ERROR',
          );
        }
      }

      return EventIngestionResult(
        eventId: eventId,
        status: status,
        success: false,
        error: 'Status desconocido: $status',
        action: 'ERROR',
      );
    } catch (e) {
      return EventIngestionResult(
        eventId: eventId,
        status: status,
        success: false,
        error: e.toString(),
        action: 'ERROR',
      );
    }
  }

  /// Procesa un JSON completo de eventos
  Future<IngestionSummary> processEventsJson(
    String jsonString, {
    String? defaultCityName,
  }) async {
    // Verificar permisos
    final hasPermissions = await _checkAdminPermissions();
    if (!hasPermissions) {
      throw Exception('No tienes permisos de administrador');
    }

    // Parsear JSON
    dynamic jsonData;
    try {
      jsonData = jsonDecode(jsonString);
    } catch (e) {
      throw Exception('JSON inválido: $e');
    }

    // Validar formato
    if (!_validateJsonFormat(jsonData)) {
      throw Exception('Formato de JSON inválido. Debe ser un array de objetos con los campos requeridos.');
    }

    final events = jsonData as List;
    final results = <EventIngestionResult>[];

    // Procesar cada evento
    for (final eventData in events) {
      final result = await _processEvent(
        eventData as Map<String, dynamic>,
        defaultCityName,
      );
      results.add(result);
    }

    // Calcular resumen
    final success = results.where((r) => r.success).length;
    final failed = results.where((r) => !r.success).length;

    return IngestionSummary(
      total: events.length,
      success: success,
      failed: failed,
      results: results,
    );
  }
}
