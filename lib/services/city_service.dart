import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter/foundation.dart' show debugPrint;

class City {
  final int id;
  final String name;
  final String slug;
  final int? provinceId;
  final double? lat;
  final double? lng;
  final String? region;
  // Límites geográficos para restringir el mapa a esta ciudad
  final double? latMin;
  final double? latMax;
  final double? lngMin;
  final double? lngMax;

  City({
    required this.id,
    required this.name,
    required this.slug,
    this.provinceId,
    this.lat,
    this.lng,
    this.region,
    this.latMin,
    this.latMax,
    this.lngMin,
    this.lngMax,
  });

  factory City.fromMap(Map<String, dynamic> m) => City(
    id: m['id'] as int,
    name: m['name'] as String,
    slug: m['slug'] as String,
    provinceId: m['province_id'] as int?,
    lat: (m['lat'] as num?)?.toDouble(),
    lng: (m['lng'] as num?)?.toDouble(),
    region: m['region'] as String?,
    latMin: (m['lat_min'] as num?)?.toDouble(),
    latMax: (m['lat_max'] as num?)?.toDouble(),
    lngMin: (m['lng_min'] as num?)?.toDouble(),
    lngMax: (m['lng_max'] as num?)?.toDouble(),
  );
  
  /// Verifica si una coordenada está dentro de los límites de la ciudad
  bool isWithinBounds(double lat, double lng) {
    if (latMin == null || latMax == null || lngMin == null || lngMax == null) {
      return true; // Si no hay límites definidos, permitir cualquier ubicación
    }
    return lat >= latMin! && lat <= latMax! && lng >= lngMin! && lng <= lngMax!;
  }
}

class CityService {
  CityService._();

  static final instance = CityService._();

  final supa = Supabase.instance.client;

  /// Obtiene ciudades, por defecto solo de Cádiz (province_id = 1)
  /// Para obtener todas las ciudades de todas las provincias, pasa null explícitamente
  Future<List<City>> fetchCities({int? provinceId}) async {
    dynamic res;

    // Si no se especifica provincia, obtener solo Cádiz (por defecto)
    final provinceIdToUse = provinceId ?? await _getCadizProvinceId();

    if (provinceIdToUse != null) {
      res = await supa
          .from('cities')
          .select('id, name, slug, province_id, lat, lng, region, lat_min, lat_max, lng_min, lng_max')
          .eq('province_id', provinceIdToUse)
          .order('region')
          .order('name');
    } else {
      // Si no existe provincia Cádiz o hay error, obtener todas (fallback)
      res = await supa
          .from('cities')
          .select('id, name, slug, province_id, lat, lng, region, lat_min, lat_max, lng_min, lng_max')
          .order('name');
    }

    final list = (res as List).cast<Map<String, dynamic>>();
    return list.map((e) => City.fromMap(e)).toList();
  }

  /// Obtiene el ID de la provincia de Cádiz
  Future<int?> _getCadizProvinceId() async {
    try {
      final res = await supa
          .from('provinces')
          .select('id')
          .eq('slug', 'cadiz')
          .maybeSingle();
      
      if (res != null) {
        return (res['id'] as num).toInt();
      }
      return null;
    } catch (e) {
      debugPrint('Error al obtener ID de provincia Cádiz: $e');
      return null;
    }
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
    final dynamic res = await supa.rpc(
      'cities_within_radius',
      params: {'center_lat': lat, 'center_lng': lng, 'radius_km': radiusKm},
    );

    final list = (res as List).cast<Map<String, dynamic>>();
    return list.map((m) => City.fromMap(m)).toList();
  }

  /// Busca ciudades, filtrando solo por Cádiz
  Future<List<City>> searchCities(String query, {int? provinceId}) async {
    final q = query.trim();

    if (q.isEmpty) return [];

    // Filtrar solo por Cádiz por defecto
    final provinceIdToUse = provinceId ?? await _getCadizProvinceId();

    dynamic res;
    if (provinceIdToUse != null) {
      res = await supa
          .from('cities')
          .select('id, name, slug, province_id, lat, lng, region, lat_min, lat_max, lng_min, lng_max')
          .eq('province_id', provinceIdToUse)
          .ilike('name', '%$q%')
          .order('name');
    } else {
      // Fallback si no hay provincia
      res = await supa
          .from('cities')
          .select('id, name, slug, province_id, lat, lng, region, lat_min, lat_max, lng_min, lng_max')
          .ilike('name', '%$q%')
          .order('name');
    }

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
