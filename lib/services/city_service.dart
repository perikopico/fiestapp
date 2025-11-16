import 'package:supabase_flutter/supabase_flutter.dart';

class City {
  final int id;
  final String name;
  final String slug;
  final int? provinceId;
  final double? lat;
  final double? lng;

  City({
    required this.id,
    required this.name,
    required this.slug,
    this.provinceId,
    this.lat,
    this.lng,
  });

  factory City.fromMap(Map<String, dynamic> m) => City(
    id: m['id'] as int,
    name: m['name'] as String,
    slug: m['slug'] as String,
    provinceId: m['province_id'] as int?,
    lat: (m['lat'] as num?)?.toDouble(),
    lng: (m['lng'] as num?)?.toDouble(),
  );
}

class CityService {
  CityService._();

  static final instance = CityService._();

  final supa = Supabase.instance.client;

  Future<List<City>> fetchCities({int? provinceId}) async {
    dynamic res;

    if (provinceId != null) {
      res = await supa
          .from('cities')
          .select('id, name, slug, province_id, lat, lng')
          .eq('province_id', provinceId)
          .order('name');
    } else {
      res = await supa
          .from('cities')
          .select('id, name, slug, province_id, lat, lng')
          .order('name');
    }

    final list = (res as List).cast<Map<String, dynamic>>();
    return list.map((e) => City.fromMap(e)).toList();
  }

  Future<int?> getProvinceIdBySlug(String slug) async {
    final dynamic r = await supa
        .from('provinces')
        .select('id')
        .eq('slug', slug)
        .maybeSingle();

    if (r == null) return null;

    return (r['id'] as num).toInt();
  }

  Future<List<City>> fetchNearbyCities({
    required double lat,
    required double lng,
    double radiusKm = 25,
  }) async {
    final dynamic res = await supa.rpc('cities_within_radius', params: {
      'center_lat': lat,
      'center_lng': lng,
      'radius_km': radiusKm,
    });

    final list = (res as List).cast<Map<String, dynamic>>();
    return list.map((m) => City.fromMap(m)).toList();
  }

  Future<List<City>> searchCities(String query) async {
    final q = query.trim();

    if (q.isEmpty) return [];

    final dynamic res = await supa
        .from('cities')
        .select('id, name, slug, province_id, lat, lng')
        .ilike('name', '%$q%')
        .order('name');

    final list = (res as List).cast<Map<String, dynamic>>();
    return list.map((m) => City.fromMap(m)).toList();
  }

  /// Devuelve el id de la primera ciudad cuyo nombre contenga [q] (ilike).
  Future<int?> findCityIdByQuery(String q) async {
    final term = q.trim();
    if (term.isEmpty) return null;
    final res = await supa
        .from('cities')
        .select('id,name')
        .ilike('name', '%$term%')
        .limit(1);
    if (res is List && res.isNotEmpty) {
      final m = res.first as Map<String, dynamic>;
      return m['id'] as int?;
    }
    return null;
  }
}

