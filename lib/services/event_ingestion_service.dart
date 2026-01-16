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

  /// Valida el formato básico del JSON
  bool _validateJsonFormat(dynamic json) {
    if (json is! List) {
      return false;
    }

    for (final item in json) {
      if (item is! Map<String, dynamic>) {
        return false;
      }

      final requiredFields = ['id', 'status', 'date', 'time', 'category', 'title', 'description', 'location_name', 'gmaps_link', 'price', 'info_url'];
      for (final field in requiredFields) {
        if (!item.containsKey(field)) {
          return false;
        }
      }
    }

    return true;
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

  /// Procesa un evento individual según su status
  Future<EventIngestionResult> _processEvent(
    Map<String, dynamic> eventData,
    String? cityName,
  ) async {
    final eventId = eventData['id'] as int;
    final status = eventData['status'] as String;
    final date = eventData['date'] as String;
    final time = eventData['time'] as String;
    final categoryName = eventData['category'] as String;
    final title = eventData['title'] as String;
    final description = eventData['description'] as String;
    final locationName = eventData['location_name'] as String;
    final gmapsLink = eventData['gmaps_link'] as String;
    final price = eventData['price'] as String;
    final infoUrl = eventData['info_url'] as String? ?? '';

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

      // Obtener city_id
      final cityId = await _findCityId(locationName, gmapsLink, cityName);
      if (cityId == null) {
        return EventIngestionResult(
          eventId: eventId,
          status: status,
          success: false,
          error: 'No se pudo determinar la ciudad para "$locationName"',
          action: 'ERROR',
        );
      }

      // Parsear fecha y hora
      final startsAtStr = '$date $time';
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
        'status': 'published', // Los eventos ingresados se publican directamente
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
          return EventIngestionResult(
            eventId: eventId,
            status: status,
            success: true,
            action: 'UPDATE (ya existía con este external_id)',
          );
        } else {
          await _client.from('events').insert(eventMap);
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
          return EventIngestionResult(
            eventId: eventId,
            status: status,
            success: true,
            action: 'UPDATE',
          );
        } else {
          // Si no se encuentra, crear uno nuevo
          await _client.from('events').insert(eventMap);
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
