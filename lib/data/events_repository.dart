import 'package:fiestapp/models/event.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class EventsRepository {
  final _client = Supabase.instance.client;

  Future<List<Event>> fetchNearby({
    required double lat,
    required double lng,
    double radiusKm = 25,
  }) async {
    final res = await _client.rpc('events_within_radius', params: {
      'center_lat': lat,
      'center_lng': lng,
      'radius_km': radiusKm,
    });
    final data = (res as List).cast<Map<String, dynamic>>();
    return data.map((m) => Event.fromMap(m)).toList();
  }
}

