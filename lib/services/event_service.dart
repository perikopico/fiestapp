import 'package:supabase_flutter/supabase_flutter.dart';

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
}
