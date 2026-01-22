import 'package:flutter/foundation.dart';
import 'package:geolocator/geolocator.dart';
import '../models/event.dart';
import '../models/category.dart' as models;
import '../services/event_service.dart';
import '../services/category_service.dart';
import '../services/city_service.dart';
import '../services/cache_service.dart';
import '../services/analytics_service.dart';
import '../services/logger_service.dart';
import '../utils/date_ranges.dart';
import '../utils/dashboard_utils.dart';

/// Provider para gestionar el estado del dashboard
class DashboardProvider extends ChangeNotifier {
  final EventService _eventService = EventService.instance;
  final CategoryService _categoryService = CategoryService();
  final CityService _cityService = CityService.instance;
  final CacheService _cacheService = CacheService.instance;

  // Flag para verificar si el provider está disposed
  bool _isDisposed = false;

  // Estados principales
  List<Event> _upcomingEvents = [];
  List<Event> _featuredEvents = [];
  List<models.Category> _categories = [];
  bool _isLoading = false;
  String? _error;
  
  // Filtros
  int? _selectedCategoryId;
  int? _selectedCityId;
  Set<int> _selectedCityIds = {};
  DateTime? _fromDate;
  DateTime? _toDate;
  String? _selectedDatePreset;
  
  // Modo de ubicación
  LocationMode _mode = LocationMode.radius;
  double _radiusKm = 15.0;
  double? _userLat;
  double? _userLng;
  bool _hasLocationPermission = false;
  
  // Búsqueda
  String? _searchEventTerm;

  // Getters
  List<Event> get upcomingEvents => _upcomingEvents;
  List<Event> get featuredEvents => _featuredEvents;
  List<models.Category> get categories => _categories;
  bool get isLoading => _isLoading;
  String? get error => _error;
  int? get selectedCategoryId => _selectedCategoryId;
  int? get selectedCityId => _selectedCityId;
  Set<int> get selectedCityIds => _selectedCityIds;
  DateTime? get fromDate => _fromDate;
  DateTime? get toDate => _toDate;
  String? get selectedDatePreset => _selectedDatePreset;
  LocationMode get mode => _mode;
  double get radiusKm => _radiusKm;
  double? get userLat => _userLat;
  double? get userLng => _userLng;
  bool get hasLocationPermission => _hasLocationPermission;
  String? get searchEventTerm => _searchEventTerm;

  /// Inicializa el dashboard con datos pre-cargados
  Future<void> initialize({Map<String, dynamic>? preloadedData}) async {
    if (_isDisposed) return;
    
    if (preloadedData != null) {
      _upcomingEvents = preloadedData['upcomingEvents'] as List<Event>? ?? [];
      _featuredEvents = preloadedData['featuredEvents'] as List<Event>? ?? [];
      _categories = preloadedData['categories'] as List<models.Category>? ?? [];
      _safeNotifyListeners();
    }

    if (_isDisposed) return;

    // Establecer filtro por defecto
    _setDefaultDateFilter();

    // Verificar permisos de ubicación
    await _checkLocationPermission();

    if (_isDisposed) return;

    // Cargar todos los datos
    await loadAllData();
  }

  /// Establece el filtro por defecto a "1 Mes"
  void _setDefaultDateFilter() {
    final r = next30DaysRange();
    _fromDate = r.from;
    _toDate = r.to;
    _selectedDatePreset = '30days';
  }

  /// Verifica los permisos de ubicación
  Future<void> _checkLocationPermission() async {
    // Verificar si el provider está disposed antes de continuar
    if (_isDisposed) return;
    
    var permission = await Geolocator.checkPermission();
    
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }
    
    // Verificar de nuevo después de la operación asíncrona
    if (_isDisposed) return;
    
    _hasLocationPermission = permission == LocationPermission.whileInUse ||
        permission == LocationPermission.always;
    
    if (_hasLocationPermission && _mode == LocationMode.radius) {
      await _getUserLocation();
    } else if (!_hasLocationPermission) {
      _mode = LocationMode.city;
    }
    
    // Solo notificar si el provider aún está activo
    _safeNotifyListeners();
  }

  /// Obtiene la ubicación del usuario
  Future<void> _getUserLocation() async {
    // Verificar si el provider está disposed antes de continuar
    if (_isDisposed) return;
    
    try {
      final position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.medium,
      );
      
      // Verificar de nuevo después de la operación asíncrona
      if (_isDisposed) return;
      
      _userLat = position.latitude;
      _userLng = position.longitude;
      
      // Solo notificar si el provider aún está activo
      _safeNotifyListeners();
    } catch (e) {
      // Solo registrar el error si el provider no está disposed
      if (!_isDisposed) {
        LoggerService.instance.error('Error al obtener ubicación', error: e);
      }
    }
  }

  /// Carga todos los datos del dashboard
  Future<void> loadAllData({bool forceRefresh = false}) async {
    if (_isDisposed) return;
    
    _isLoading = true;
    _error = null;
    _safeNotifyListeners();

    try {
      // Cargar datos en paralelo
      await Future.wait([
        loadCategories(forceRefresh: forceRefresh),
        loadEvents(forceRefresh: forceRefresh),
        loadFeaturedEvents(forceRefresh: forceRefresh),
      ], eagerError: false);

      if (_isDisposed) return;
      
      _isLoading = false;
      _safeNotifyListeners();
    } catch (e) {
      if (_isDisposed) return;
      
      _error = e.toString();
      _isLoading = false;
      _safeNotifyListeners();
      rethrow;
    }
  }

  /// Carga las categorías (usando caché)
  Future<void> loadCategories({bool forceRefresh = false}) async {
    if (_isDisposed) return;
    
    try {
      _categories = await _cacheService.getCategories(forceRefresh: forceRefresh);
      _safeNotifyListeners();
    } catch (e) {
      debugPrint('Error al cargar categorías: $e');
    }
  }

  /// Carga los eventos según los filtros actuales
  Future<void> loadEvents({bool forceRefresh = false}) async {
    try {
      final List<int>? cityIds = _mode == LocationMode.city
          ? (_selectedCityIds.isNotEmpty
              ? _selectedCityIds.toList()
              : (_selectedCityId != null ? <int>[_selectedCityId!] : null))
          : null;

      final double? radius = _mode == LocationMode.radius && _hasLocationPermission && _radiusKm > 0
          ? _radiusKm
          : null;

      dynamic center;
      if (_mode == LocationMode.radius && _hasLocationPermission) {
        if (_userLat != null && _userLng != null) {
          center = {'lat': _userLat, 'lng': _userLng};
        } else {
          center = {'lat': 36.1927, 'lng': -5.9219}; // Default
        }
      }

      _upcomingEvents = await _eventService.fetchEvents(
        cityIds: cityIds,
        categoryId: _selectedCategoryId,
        from: _fromDate,
        to: _toDate,
        radiusKm: radius,
        center: center,
        searchTerm: _searchEventTerm,
      );

      if (_isDisposed) return;
      
      _safeNotifyListeners();
    } catch (e) {
      if (_isDisposed) return;
      
      _error = e.toString();
      _safeNotifyListeners();
      rethrow;
    }
  }

  /// Carga los eventos destacados
  Future<void> loadFeaturedEvents({bool forceRefresh = false}) async {
    try {
      // Calcular provinceId según el modo actual
      int? provinceId;
      if (_mode == LocationMode.city && _selectedCityId != null) {
        try {
          // Obtener provinceId de la ciudad seleccionada
          final cities = await _cityService.fetchCities();
          final selectedCity = cities.firstWhere(
            (c) => c.id == _selectedCityId,
            orElse: () => cities.first,
          );
          provinceId = selectedCity.provinceId;
        } catch (e) {
          LoggerService.instance.error('Error al obtener provinceId de la ciudad', error: e);
        }
      }

      _featuredEvents = await _eventService.fetchPopularEvents(
        provinceId: provinceId,
        limit: 7,
      );

      if (_isDisposed) return;
      
      _safeNotifyListeners();
    } catch (e) {
      if (!_isDisposed) {
        LoggerService.instance.error('Error al cargar eventos destacados', error: e);
      }
    }
  }

  /// Establece la categoría seleccionada
  void setSelectedCategory(int? categoryId) {
    if (_isDisposed || _selectedCategoryId == categoryId) return;
    
    _selectedCategoryId = categoryId;
    if (!_isDisposed) {
      AnalyticsService.instance.logCategorySelected(
        categoryId ?? 0,
        categoryName: categoryId != null
            ? _categories.firstWhere((c) => c.id == categoryId).name
            : null,
      );
    }
    
    loadEvents();
  }

  /// Establece la ciudad seleccionada
  void setSelectedCity(int? cityId, {Set<int>? cityIds}) {
    if (cityIds != null) {
      _selectedCityIds = cityIds;
    } else {
      _selectedCityId = cityId;
      _selectedCityIds = cityId != null ? {cityId} : {};
    }
    loadEvents();
  }

  /// Establece el rango de fechas
  void setDateRange(DateTime? from, DateTime? to, {String? preset}) {
    _fromDate = from;
    _toDate = to;
    _selectedDatePreset = preset;
    loadEvents();
  }

  /// Cambia el modo de ubicación
  Future<void> switchMode(LocationMode mode) async {
    if (_mode == mode) return;
    
    _mode = mode;
    AnalyticsService.instance.logLocationModeChanged(
      mode == LocationMode.city ? 'city' : 'radius',
    );
    
    if (mode == LocationMode.radius) {
      await _checkLocationPermission();
    }
    
    loadEvents();
  }

  /// Establece el radio de búsqueda
  void setRadius(double radiusKm) {
    _radiusKm = radiusKm;
    loadEvents();
  }

  /// Establece el término de búsqueda
  void setSearchTerm(String? term) {
    _searchEventTerm = term;
    if (term != null && term.isNotEmpty) {
      AnalyticsService.instance.logSearch(term);
    }
    loadEvents();
  }

  /// Refresca todos los datos
  Future<void> refresh() async {
    await loadAllData(forceRefresh: true);
  }

  @override
  void dispose() {
    _isDisposed = true;
    super.dispose();
  }
  
  /// Método auxiliar para notificar listeners de forma segura
  void _safeNotifyListeners() {
    if (!_isDisposed) {
      try {
        notifyListeners();
      } catch (e) {
        // Ignorar errores si el provider está disposed
        if (!_isDisposed) {
          rethrow;
        }
      }
    }
  }
}
