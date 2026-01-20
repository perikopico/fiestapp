import 'package:flutter/foundation.dart';
import '../models/category.dart';
import 'category_service.dart';
import 'city_service.dart';

/// Servicio de caché para datos que cambian raramente (categorías, ciudades)
class CacheService {
  CacheService._();
  static final instance = CacheService._();

  // Caché de categorías
  List<Category>? _cachedCategories;
  DateTime? _categoriesCacheTime;
  static const _categoriesCacheTTL = Duration(minutes: 30);

  // Caché de ciudades
  Map<int?, List<dynamic>> _cachedCities = {};
  Map<int?, DateTime> _citiesCacheTime = {};
  static const _citiesCacheTTL = Duration(minutes: 30);

  /// Obtiene categorías desde caché o la base de datos
  Future<List<Category>> getCategories({bool forceRefresh = false}) async {
    // Si hay caché válido y no se fuerza refresh, devolverlo
    if (!forceRefresh &&
        _cachedCategories != null &&
        _categoriesCacheTime != null &&
        DateTime.now().difference(_categoriesCacheTime!) < _categoriesCacheTTL) {
      debugPrint('✅ Categorías obtenidas desde caché');
      return _cachedCategories!;
    }

    // Cargar desde la base de datos
    debugPrint('📥 Cargando categorías desde BD...');
    final categories = await CategoryService().fetchAll();
    
    // Actualizar caché
    _cachedCategories = categories;
    _categoriesCacheTime = DateTime.now();
    
    return categories;
  }

  /// Obtiene ciudades desde caché o la base de datos
  Future<List<dynamic>> getCities({int? provinceId, bool forceRefresh = false}) async {
    // Si hay caché válido y no se fuerza refresh, devolverlo
    if (!forceRefresh &&
        _cachedCities.containsKey(provinceId) &&
        _citiesCacheTime.containsKey(provinceId) &&
        DateTime.now().difference(_citiesCacheTime[provinceId]!) < _citiesCacheTTL) {
      debugPrint('✅ Ciudades obtenidas desde caché (provinceId: $provinceId)');
      return _cachedCities[provinceId]!;
    }

    // Cargar desde la base de datos
    debugPrint('📥 Cargando ciudades desde BD (provinceId: $provinceId)...');
    final cities = await CityService.instance.fetchCities(provinceId: provinceId);
    
    // Actualizar caché
    _cachedCities[provinceId] = cities;
    _citiesCacheTime[provinceId] = DateTime.now();
    
    return cities;
  }

  /// Limpia la caché de categorías
  void clearCategoriesCache() {
    _cachedCategories = null;
    _categoriesCacheTime = null;
    debugPrint('🗑️ Caché de categorías limpiada');
  }

  /// Limpia la caché de ciudades
  void clearCitiesCache({int? provinceId}) {
    if (provinceId != null) {
      _cachedCities.remove(provinceId);
      _citiesCacheTime.remove(provinceId);
      debugPrint('🗑️ Caché de ciudades limpiada (provinceId: $provinceId)');
    } else {
      _cachedCities.clear();
      _citiesCacheTime.clear();
      debugPrint('🗑️ Toda la caché de ciudades limpiada');
    }
  }

  /// Limpia toda la caché
  void clearAllCache() {
    clearCategoriesCache();
    clearCitiesCache();
    debugPrint('🗑️ Toda la caché limpiada');
  }
}
