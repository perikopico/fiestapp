import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/event.dart';

class EventService {
  Future<List<Event>> fetchEvents({int limit = 50}) async {
    try {
      final rows = await Supabase.instance.client
          .from('events')
          .select()
          .order('starts_at', ascending: true)
          .limit(limit);

      return (rows as List)
          .map((e) => Event.fromMap(e as Map<String, dynamic>))
          .toList();
    } catch (e) {
      throw Exception('Error al obtener eventos: ${e.toString()}');
    }
  }
}
