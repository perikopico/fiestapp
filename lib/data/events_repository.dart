import 'package:fiestapp/models/event.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class EventsRepository {
  final _client = Supabase.instance.client;

  Future<List<Event>> fetchNearby({
    required double lat,
    required double lng,
    double radiusKm = 25,
  }) async {
    print('fetchNearby(): lat=$lat, lng=$lng, radiusKm=$radiusKm');

    final res = await _client.rpc('events_within_radius', params: {
      'p_lat': lat,
      'p_lng': lng,
      'p_radius_km': radiusKm,
    });

    if (res is! List) {
      print('fetchNearby(): respuesta no es List -> $res');
      return [];
    }

    final data = (res as List).cast<Map<String, dynamic>>();
    print('fetchNearby(): radiusKm=$radiusKm -> ${data.length} eventos');

    return data.map((m) => Event.fromMap(m)).toList();
  }
}

