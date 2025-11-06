import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/event.dart';

class EventService {
  Future<List<Event>> fetchFeatured({int limit = 1}) async {
    try {
      final rows = await Supabase.instance.client
          .from('events')
          .select('*')
          .eq('is_featured', true)
          .order('starts_at', ascending: true)
          .limit(limit);

      return (rows as List)
          .map((e) => Event.fromMap(e as Map<String, dynamic>))
          .toList();
    } catch (e) {
      throw Exception('Error al obtener eventos destacados: ${e.toString()}');
    }
  }

  Future<List<Event>> fetchUpcoming({String? cityName, int limit = 10}) async {
    try {
      final now = DateTime.now().toUtc().toIso8601String();
      var query = Supabase.instance.client
          .from('events')
          .select('*')
          .gte('starts_at', now);

      if (cityName != null) {
        query = query.eq('town', cityName);
      }

      final rows = await query
          .order('starts_at', ascending: true)
          .limit(limit);

      return (rows as List)
          .map((e) => Event.fromMap(e as Map<String, dynamic>))
          .toList();
    } catch (e) {
      throw Exception('Error al obtener próximos eventos: ${e.toString()}');
    }
  }

  Future<List<Event>> fetchPopularWeek({int limit = 10}) async {
    try {
      final now = DateTime.now().toUtc().toIso8601String();
      final weekLater = DateTime.now()
          .add(const Duration(days: 7))
          .toUtc()
          .toIso8601String();

      final rows = await Supabase.instance.client
          .from('events')
          .select('*')
          .gte('starts_at', now)
          .lte('starts_at', weekLater)
          .order('starts_at', ascending: true)
          .limit(limit * 2); // Obtener más para ordenar después

      final events = (rows as List)
          .map((e) => Event.fromMap(e as Map<String, dynamic>))
          .toList();

      // Ordenar por is_featured primero (desc), luego por starts_at (asc)
      events.sort((a, b) {
        if (a.isFeatured != b.isFeatured) {
          return b.isFeatured ? 1 : -1; // featured primero
        }
        if (a.startsAt != null && b.startsAt != null) {
          return a.startsAt!.compareTo(b.startsAt!);
        }
        return 0;
      });

      return events.take(limit).toList();
    } catch (e) {
      throw Exception('Error al obtener eventos populares: ${e.toString()}');
    }
  }
}

