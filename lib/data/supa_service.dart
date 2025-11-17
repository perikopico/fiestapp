// lib/data/supa_service.dart
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../models.dart';

/// Servicio de datos: conecta con Supabase si hay .env válido,
/// o usa datos de prueba locales para desarrollo sin conexión.
class SupaService {
  final _client = Supabase.instance.client;

  bool get _useSupabase {
    final url = dotenv.env['SUPABASE_URL'] ?? '';
    final key = dotenv.env['SUPABASE_ANON_KEY'] ?? '';
    return url.isNotEmpty && key.isNotEmpty;
  }

  // ---------- MOCK local ----------
  List<EventItem> _mockNow() {
    final now = DateTime.now();

    DateTime nextWeekendDay(DateTime base, int weekday) {
      int diff = (weekday - base.weekday) % 7;
      if (diff <= 0) diff += 7;
      return DateTime(
        base.year,
        base.month,
        base.day,
      ).add(Duration(days: diff));
    }

    return [
      EventItem(
        id: '1',
        title: 'Zambomba en la Peña Flamenca',
        cityId: 'barbate',
        categoryId: 'tradicion',
        categoryName: 'Tradición',
        place: 'Peña Flamenca',
        start: DateTime(now.year, now.month, now.day, 21, 30),
        end: DateTime(now.year, now.month, now.day, 23, 30),
        isFree: true,
        imageUrl:
            'https://images.unsplash.com/photo-1519681393784-d120267933ba?q=80&w=1200&auto=format&fit=crop',
      ),
      EventItem(
        id: '2',
        title: 'Concentración de deportivos',
        cityId: 'vejer',
        categoryId: 'motor',
        categoryName: 'Motor',
        place: 'Plaza de España, Medina/Vejer',
        start: nextWeekendDay(
          now,
          DateTime.saturday,
        ).add(const Duration(hours: 10)),
        end: nextWeekendDay(
          now,
          DateTime.saturday,
        ).add(const Duration(hours: 18)),
        isFree: true,
        imageUrl:
            'https://images.unsplash.com/photo-1483721310020-03333e577078?q=80&w=1200&auto=format&fit=crop',
      ),
      EventItem(
        id: '3',
        title: 'Mercado artesanal',
        cityId: 'zahara',
        categoryId: 'mercados',
        categoryName: 'Mercados',
        place: 'Paseo marítimo, Zahara',
        start: nextWeekendDay(
          now,
          DateTime.sunday,
        ).add(const Duration(hours: 11)),
        end: nextWeekendDay(
          now,
          DateTime.sunday,
        ).add(const Duration(hours: 15)),
        isFree: true,
        imageUrl:
            'https://images.unsplash.com/photo-1565011691358-7f4e6c2b0b59?q=80&w=1200&auto=format&fit=crop',
      ),
    ];
  }

  // Mapeos entre el modelo de la app y la tabla real
  static const _cityToTown = {
    'barbate': 'Barbate',
    'zahara': 'Zahara',
    'vejer': 'Vejer',
  };

  static const _catIdToName = {
    'tradicion': 'Tradición',
    'motor': 'Motor',
    'mercados': 'Mercados',
  };

  static String _townToCityId(String town) {
    switch (town.toLowerCase()) {
      case 'barbate':
        return 'barbate';
      case 'zahara':
        return 'zahara';
      case 'vejer':
        return 'vejer';
      default:
        return town.toLowerCase();
    }
  }

  static String _catNameToId(String name) {
    final n = name.toLowerCase();
    if (n.startsWith('trad')) return 'tradicion';
    if (n.startsWith('motor')) return 'motor';
    if (n.startsWith('mercad')) return 'mercados';
    return n;
  }

  // ---------- Query principal ----------
  Future<List<EventItem>> fetchEvents({
    required String cityId,
    String? categoryId, // 'tradicion' | 'motor' | 'mercados' | 'all'/null
  }) async {
    if (!_useSupabase) {
      final data = _mockNow().where((e) {
        if (e.cityId != cityId) return false;
        if (categoryId == null || categoryId == 'all') return true;
        return e.categoryId == categoryId;
      }).toList()..sort((a, b) => a.start.compareTo(b.start));
      return data;
    }

    final town = _cityToTown[cityId] ?? cityId;
    final catName = (categoryId == null || categoryId == 'all')
        ? null
        : _catIdToName[categoryId] ?? categoryId;

    const columns = '''
      id, title, town, category, starts_at, place, maps_url, image_url, is_featured
    ''';

    // Encadenamos TODO en una sola expresión para evitar choques de tipos
    final rows = (catName != null)
        ? await Supabase.instance.client
              .from('events')
              .select(columns)
              .filter('town', 'eq', town)
              .filter('category', 'eq', catName)
              .order('starts_at')
        : await Supabase.instance.client
              .from('events')
              .select(columns)
              .filter('town', 'eq', town)
              .order('starts_at');

    return (rows as List<dynamic>).map((raw) {
      final map = raw as Map<String, dynamic>;
      final townName = (map['town'] ?? '').toString();
      final cat = (map['category'] ?? '').toString();

      return EventItem(
        id: map['id'].toString(),
        title: (map['title'] ?? '').toString(),
        cityId: _townToCityId(townName),
        categoryId: _catNameToId(cat),
        categoryName: cat,
        place: (map['place'] ?? '').toString(),
        start: DateTime.parse(map['starts_at'].toString()),
        end: DateTime.parse(
          map['starts_at'].toString(),
        ).add(const Duration(hours: 2)),
        isFree: true,
        imageUrl: map['image_url'] as String?,
      );
    }).toList();
  }
}

// ---------- Utilidades de agrupación por fechas ----------
class EventBuckets {
  final List<EventItem> today;
  final List<EventItem> weekend;
  final List<EventItem> nextDays;
  EventBuckets({
    required this.today,
    required this.weekend,
    required this.nextDays,
  });
}

EventBuckets splitByDate(List<EventItem> all) {
  final now = DateTime.now();
  final today0 = DateTime(now.year, now.month, now.day);
  final today1 = today0.add(const Duration(days: 1));

  DateTime nextWeekendDay(DateTime base, int weekday) {
    int diff = (weekday - base.weekday) % 7;
    if (diff <= 0) diff += 7;
    return DateTime(base.year, base.month, base.day).add(Duration(days: diff));
  }

  final weekendStart = nextWeekendDay(now, DateTime.saturday);
  final weekendEnd = nextWeekendDay(now, DateTime.monday);

  final today =
      all
          .where((e) => e.start.isAfter(today0) && e.start.isBefore(today1))
          .toList()
        ..sort((a, b) => a.start.compareTo(b.start));
  final weekend =
      all
          .where(
            (e) =>
                e.start.isAfter(weekendStart) && e.start.isBefore(weekendEnd),
          )
          .toList()
        ..sort((a, b) => a.start.compareTo(b.start));
  final nextDays = all.where((e) => e.start.isAfter(today1)).toList()
    ..sort((a, b) => a.start.compareTo(b.start));

  return EventBuckets(today: today, weekend: weekend, nextDays: nextDays);
}
