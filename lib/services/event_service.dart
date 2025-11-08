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
}
