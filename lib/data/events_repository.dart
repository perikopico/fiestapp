import 'package:flutter/foundation.dart' show debugPrint;
import 'package:fiestapp/models/event.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class EventsRepository {
  final _client = Supabase.instance.client;

  Future<List<Event>> fetchNearby({
    required double lat,
    required double lng,
    double radiusKm = 25,
    DateTime? from,
  }) async {
    debugPrint('fetchNearby(): lat=$lat, lng=$lng, radiusKm=$radiusKm, from=$from');

    final res = await _client.rpc(
      'events_within_radius',
      params: {'p_lat': lat, 'p_lng': lng, 'p_radius_km': radiusKm},
    );

    if (res is! List) {
      debugPrint('fetchNearby(): respuesta no es List -> $res');
      return [];
    }

    final data = (res as List).cast<Map<String, dynamic>>();
    debugPrint('fetchNearby(): radiusKm=$radiusKm -> ${data.length} eventos');

    // Convertir a eventos
    List<Event> events = data.map((m) => Event.fromMap(m)).toList();

    // Filtrar eventos pasados si no se especifica un 'from' (por defecto, solo futuros)
    if (from != null) {
      // Si hay un filtro de fecha, respetarlo
      events = events
          .where((e) => e.startsAt.isAfter(from.subtract(const Duration(seconds: 1))))
          .toList();
    } else {
      // Por defecto, solo eventos desde hoy a las 00:00 en adelante
      final todayStart = DateTime.now();
      final todayStartNormalized = DateTime(todayStart.year, todayStart.month, todayStart.day);
      events = events
          .where((e) => e.startsAt.isAfter(todayStartNormalized.subtract(const Duration(seconds: 1))))
          .toList();
    }

    debugPrint('fetchNearby(): después de filtrar por fecha -> ${events.length} eventos');

    return events;
  }
}
