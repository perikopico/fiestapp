import 'package:supabase_flutter/supabase_flutter.dart';

class City {
  final int id;
  final String name;
  final String slug;
  final int? provinceId;

  City({required this.id, required this.name, required this.slug, this.provinceId});

  factory City.fromMap(Map<String, dynamic> m) => City(
    id: m['id'] as int,
    name: m['name'] as String,
    slug: m['slug'] as String,
    provinceId: m['province_id'] as int?,
  );
}

class CityService {
  final _c = Supabase.instance.client;

  Future<List<City>> fetchCities({int? provinceId}) async {
    dynamic res;

    if (provinceId != null) {
      res = await _c
          .from('cities')
          .select('id, name, slug, province_id')
          .eq('province_id', provinceId)
          .order('name');
    } else {
      res = await _c
          .from('cities')
          .select('id, name, slug, province_id')
          .order('name');
    }

    final list = (res as List).cast<Map<String, dynamic>>();
    return list.map((e) => City.fromMap(e)).toList();
  }

  Future<int?> getProvinceIdBySlug(String slug) async {
    final dynamic r = await _c
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
    final dynamic res = await _c.rpc('cities_within_radius', params: {
      'center_lat': lat,
      'center_lng': lng,
      'radius_km': radiusKm,
    });

    final list = (res as List).cast<Map<String, dynamic>>();
    return list.map((m) => City.fromMap(m)).toList();
  }
}

