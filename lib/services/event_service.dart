import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter/foundation.dart';

import '../models/event.dart';

class EventService {
  final _c = Supabase.instance.client;

  Future<List<Event>> fetchUpcoming({int limit = 50}) async {
    final r = await _c.from('events_view').select().order('starts_at', ascending: true).limit(limit);
    return (r as List).map((e) => Event.fromMap(e as Map<String, dynamic>)).toList();
  }

  Future<List<Event>> fetchFeatured({int limit = 10}) async {
    final r = await _c.from('events_view').select().eq('is_featured', true).order('starts_at', ascending: true).limit(limit);
    return (r as List).map((e) => Event.fromMap(e as Map<String, dynamic>)).toList();
  }

  Future<List<Event>> searchEvents({
    required String query,
    int? cityId,
    int? provinceId,
    double? lat,
    double? lng,
    double? radiusKm,
  }) async {
    final q = query.trim();

    // Si no hay query y tampoco filtro por ciudad, devolvemos vacío (UI decide)
    if (q.isEmpty && cityId == null) return [];

    dynamic qb = Supabase.instance.client
        .from('events')
        .select('id, title, place, starts_at, image_url, city_id, category_id, is_free, is_featured');

    if (cityId != null) {
      qb = qb.eq('city_id', cityId);
    }

    if (q.isNotEmpty) {
      qb = qb.ilike('title', '%$q%');
    }

    qb = qb.order('starts_at');

    final res = await qb;
    final list = (res as List).cast<Map<String, dynamic>>();
    return list.map((m) => Event.fromMap(m)).toList();
  }

  Future<List<Event>> listEvents({
    int? cityId,
    int? categoryId,
    DateTime? from,
    DateTime? to,
    String? textQuery,
    double? radiusKm,
    double? userLat,
    double? userLng,
    int limit = 50,
  }) async {
    final supa = Supabase.instance.client;

    // --- Base query ---
    dynamic qb = supa.from('events_view').select('''
    id, title, image_url, maps_url, place, is_featured, is_free,
    starts_at, city_id, category_id,
    city_name, category_name, category_icon, category_color
  ''');

    // --- Fechas (en UTC, rango inclusivo/exclusivo) ---
    DateTime? startUtc;
    DateTime? endUtc;
    if (from != null) startUtc = DateTime.utc(from.year, from.month, from.day);
    if (to != null) endUtc = DateTime.utc(to.year, to.month, to.day).add(const Duration(days: 1));

    if (startUtc != null) qb = qb.gte('starts_at', startUtc.toIso8601String());
    if (endUtc != null) qb = qb.lt('starts_at', endUtc.toIso8601String());

    // --- Filtros por ciudad y categoría ---
    if (cityId != null) qb = qb.eq('city_id', cityId);
    if (categoryId != null) qb = qb.eq('category_id', categoryId);

    // --- Búsqueda por texto ---
    if (textQuery != null && textQuery.trim().isNotEmpty) {
      final q = textQuery.trim();
      qb = qb.ilike('title', '%$q%');
    }

    // --- Logs de depuración ---
    debugPrint('[EVENTS] params -> cityId=$cityId categoryId=$categoryId from=$from to=$to text="$textQuery"');

    // --- Ejecución final con orden y límite ---
    final rows = await qb.order('starts_at', ascending: true).limit(limit);

    final events = (rows as List)
        .cast<Map<String, dynamic>>()
        .map(Event.fromMap)
        .toList();

    debugPrint('[EVENTS] results -> ${events.length} items');
    for (final e in events.take(10)) {
      debugPrint(' - ${e.title} @ ${e.startsAt.toIso8601String()} (cityId=${e.cityId}, catId=${e.categoryId})');
    }

    return events;
  }
}
