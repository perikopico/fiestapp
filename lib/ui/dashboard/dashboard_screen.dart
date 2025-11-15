import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' hide Category;
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:fiestapp/services/event_service.dart';
import 'package:fiestapp/data/events_repository.dart';
import 'package:fiestapp/models/event.dart' as model;
import 'package:fiestapp/services/city_service.dart';
import '../../services/category_service.dart';
import '../../models/event.dart';
import '../../models/category.dart';
import 'widgets/hero_banner.dart';
import 'widgets/upcoming_list.dart';
import 'widgets/categories_grid.dart';
import 'widgets/popular_carousel.dart';
import 'widgets/unified_search_bar.dart';
import 'widgets/city_radio_toggle.dart';
import '../icons/icon_mapper.dart';
import 'package:fiestapp/ui/common/shimmer_widgets.dart';
import '../../utils/date_ranges.dart';
import 'package:intl/intl.dart';

import '../../utils/dashboard_utils.dart';
import '../../main.dart' show appThemeMode;

// ==== Búsqueda unificada ====
enum SearchMode { city, event }

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  final EventService _eventService = EventService.instance;
  final CategoryService _categoryService = CategoryService();
  final CityService _cityService = CityService.instance;
  final _repo = EventsRepository();
  final _repoNearby = EventsRepository();
  final DateFormat _df = DateFormat('d MMM');

  LocationMode _mode = LocationMode.radius;
  SearchMode _searchMode = SearchMode.city;
  final TextEditingController _searchCtrl = TextEditingController();
  String? _searchEventTerm;

  Event? _featuredEvent;
  List<Event> _upcomingEvents = [];
  List<Event> _featuredEvents = [];
  List<Category> _categories = [];
  bool _isLoading = true;
  String? _error;
  int? _selectedCategoryId;
  int? _selectedCityId;
  Set<int> _selectedCityIds = {};
  String? _selectedCityName;
  List<City> _cities = [];
  DateTime? _fromDate;
  DateTime? _toDate;
  String? _selectedDatePreset;
  bool _isToday = false;
  bool _isWeekend = false;
  bool _isThisMonth = false;
  
  // Nearby events state
  double _radiusKm = 5;
  double? _userLat = 36.1927; // Barbate (temporal)
  double? _userLng = -5.9219; // Barbate (temporal)
  bool _isNearbyLoading = false;
  List<model.Event> _nearbyEvents = [];
  List<City> _nearbyCities = [];
  
  // Legacy search state (mantener por compatibilidad)
  String _searchQuery = '';
  Timer? _searchDebouncer;
  bool _isSearching = false;
  List<Event> _searchResults = [];
  
  // Legacy city search state (mantener por compatibilidad)
  final _citySearchCtrl = TextEditingController();
  String _citySearchQuery = '';
  Timer? _citySearchDebouncer;
  bool _isCitySearching = false;
  List<City> _citySearchResults = [];

  @override
  void initState() {
    super.initState();
    _reloadEvents().then((_) => _loadNearby());
    _loadCities();
    _loadNearbyCities();
  }

  @override
  void dispose() {
    _searchDebouncer?.cancel();
    _searchCtrl.dispose();
    _citySearchDebouncer?.cancel();
    _citySearchCtrl.dispose();
    super.dispose();
  }

  void _switchMode(LocationMode mode) {
    if (_mode == mode) return;
    setState(() {
      _mode = mode;
      if (_mode == LocationMode.city) {
        // Al volver a Ciudad, el radio no se aplica (pero mantenemos el valor para cuando vuelvas a Radio)
        // No hacemos nada con _radiusKm
      } else {
        // Al ir a Radio, descartamos selección de ciudad para evitar conflicto visual/lógico
        _selectedCityId = null;
        _selectedCityIds.clear();
        _selectedCityName = null;
        // Inicializar radio a un valor válido si está en 0
        if (_radiusKm == 0 || _radiusKm < 5) _radiusKm = 25;
      }
    });
    _reloadEvents();
  }


  Future<void> _reloadEvents() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final List<int>? cityIds =
          _mode == LocationMode.city
              ? (_selectedCityIds.isNotEmpty
                    ? _selectedCityIds.toList()
                    : (_selectedCityId != null ? <int>[_selectedCityId!] : null))
              : null;

      final double? radius =
          _mode == LocationMode.radius && _radiusKm > 0 ? _radiusKm : null;

      // Crear objeto center para el modo radio
      // Si estamos en modo radio, siempre necesitamos una ubicación (usar valores por defecto si no hay)
      dynamic center;
      if (_mode == LocationMode.radius) {
        if (_userLat != null && _userLng != null) {
          center = {'lat': _userLat, 'lng': _userLng};
        } else {
          // Si no hay ubicación del usuario pero estamos en modo radio, usar valores por defecto
          center = {'lat': 36.1927, 'lng': -5.9219}; // Barbate por defecto
        }
      }

      final results = await Future.wait([
        EventService.instance.fetchEvents(
          cityIds: cityIds,
          categoryId: _selectedCategoryId,
          from: _fromDate,
          to: _toDate,
          radiusKm: radius,
          center: center,
          searchTerm: _searchEventTerm,
        ),
        _eventService.fetchFeatured(limit: 10),
        _categoryService.fetchAll(),
      ]);

      setState(() {
        final upcoming = results[0] as List<Event>;
        final featured = results[1] as List<Event>;
        _upcomingEvents = upcoming;
        _featuredEvents = featured;
        _featuredEvent = featured.isNotEmpty ? featured.first : null;
        _categories = results[2] as List<Category>;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _error = e.toString();
        _isLoading = false;
      });
      
      // Mostrar SnackBar con error y botón de reintentar
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error al cargar datos: ${e.toString()}'),
            action: SnackBarAction(
              label: 'Reintentar',
              onPressed: _reloadEvents,
            ),
            duration: const Duration(seconds: 5),
          ),
        );
      }
    }
  }

  Future<void> _loadCities() async {
    // por ahora usamos Cádiz por slug (para producción usaremos selector)
    final provId = await _cityService.getProvinceIdBySlug('cadiz');
    final cities = await _cityService.fetchCities(provinceId: provId);
    if (!mounted) return;
    setState(() {
      _cities = cities;
      // si no hay selección, seleccionar la primera o mantener null (tu criterio)
      _selectedCityId ??= _cities.isNotEmpty ? _cities.first.id : null;
      if (_selectedCityId != null) {
        final city = _cities.firstWhere((c) => c.id == _selectedCityId, orElse: () => _cities.first);
        _selectedCityName = city.name;
        _selectedCityIds = {city.id};
      }
    });
  }

  void _clearFilters() {
    setState(() {
      // Ciudad
      _selectedCityId = null;
      _selectedCityIds.clear();
      _selectedCityName = null;

      // Categoría
      _selectedCategoryId = null;

      // Fechas
      _fromDate = null;
      _toDate = null;
      _isToday = false;
      _isWeekend = false;
      _isThisMonth = false;
      _selectedDatePreset = null;

      // Búsqueda de eventos
      _searchEventTerm = null;
      _searchCtrl.clear();
    });

    // Recargar eventos con el estado limpio
    _reloadEvents();
  }

  Future<void> _reloadWithDateRange({DateTime? from, DateTime? to}) async {
    setState(() {
      _fromDate = from;
      _toDate = to;
      _isLoading = true;
    });
    try {
      final List<int>? cityIds =
          _mode == LocationMode.city
              ? (_selectedCityIds.isNotEmpty
                    ? _selectedCityIds.toList()
                    : (_selectedCityId != null ? <int>[_selectedCityId!] : null))
              : null;

      final double? radius =
          _mode == LocationMode.radius && _radiusKm > 0 ? _radiusKm : null;

      // Crear objeto center para el modo radio
      // Si estamos en modo radio, siempre necesitamos una ubicación (usar valores por defecto si no hay)
      dynamic center;
      if (_mode == LocationMode.radius) {
        if (_userLat != null && _userLng != null) {
          center = {'lat': _userLat, 'lng': _userLng};
        } else {
          // Si no hay ubicación del usuario pero estamos en modo radio, usar valores por defecto
          center = {'lat': 36.1927, 'lng': -5.9219}; // Barbate por defecto
        }
      }

      final events = await EventService.instance.fetchEvents(
        cityIds: cityIds,
        categoryId: _selectedCategoryId,
        from: _fromDate,
        to: _toDate,
        radiusKm: radius,
        center: center,
        searchTerm: _searchEventTerm,
      );
      if (!mounted) return;
      setState(() {
        _upcomingEvents = events; // nunca null
      });
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No se pudieron cargar eventos del rango seleccionado')),
      );
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  Widget _activeDatePill() {
    if (_fromDate == null && _toDate == null) return const SizedBox.shrink();

    final fromTxt = _fromDate != null ? _df.format(_fromDate!) : '–';
    final toTxt = _toDate != null ? _df.format(_toDate!) : '–';

    return Padding(
      padding: const EdgeInsets.only(left: 8, right: 8, bottom: 6),
      child: Row(
        children: [
          InputChip(
            label: Text('Fechas: $fromTxt → $toTxt'),
            onDeleted: () => _reloadWithDateRange(from: null, to: null),
          ),
        ],
      ),
    );
  }

  Future<void> _loadNearby() async {
    if (_userLat == null || _userLng == null) return;

    setState(() => _isNearbyLoading = true);

    try {
      final list = await _repoNearby.fetchNearby(
        lat: _userLat!,
        lng: _userLng!,
        radiusKm: _radiusKm,
      );
      setState(() => _nearbyEvents = list);
    } finally {
      if (mounted) setState(() => _isNearbyLoading = false);
    }
  }

  Future<void> _loadNearbyCities() async {
    if (_userLat == null || _userLng == null) return;

    final cities = await CityService.instance.fetchNearbyCities(
      lat: _userLat!,
      lng: _userLng!,
      radiusKm: _radiusKm,
    );

    if (!mounted) return;

    setState(() {
      _nearbyCities = cities;
      // Limpia selección si la ciudad elegida ya no está en el radio
      if (_selectedCityId != null &&
          !_nearbyCities.any((c) => c.id == _selectedCityId)) {
        _selectedCityId = null;
      }
    });
  }

  Widget _buildProvinceCityChips() {
    if (_cities.isEmpty) return const SizedBox.shrink();

    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: _cities.map((city) => ChoiceChip(
        label: Text(city.name, style: Theme.of(context).textTheme.labelLarge),
        selected: _selectedCityId == city.id,
        onSelected: (_) {
          setState(() {
            _selectedCityId = city.id;
            _selectedCityName = city.name;
            _selectedCityIds = {city.id};
          });
          _reloadEvents();
        },
        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
        visualDensity: VisualDensity.compact,
      )).toList(),
    );
  }

  Widget _buildNearbyCityChips() {
    if (_nearbyCities.isEmpty) return const SizedBox.shrink();

    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: [
        ChoiceChip(
          label: Text('Todas', style: Theme.of(context).textTheme.labelLarge),
          selected: _selectedCityId == null,
          onSelected: (_) {
            setState(() {
              _selectedCityId = null; // todas las ciudades del radio
              _selectedCityName = null;
              _selectedCityIds.clear();
            });
            _reloadEvents();
          },
          materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
          visualDensity: VisualDensity.compact,
        ),
        ..._nearbyCities.map((city) => ChoiceChip(
          label: Text(city.name, style: Theme.of(context).textTheme.labelLarge),
          selected: _selectedCityId == city.id,
          onSelected: (_) {
            setState(() {
              _selectedCityId = city.id;
              _selectedCityName = city.name;
              _selectedCityIds = {city.id};
            });
            _reloadEvents();
          },
          materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
          visualDensity: VisualDensity.compact,
        )),
      ],
    );
  }

  Widget _buildCityChips() {
    // En modo Ciudad, siempre mostramos las ciudades de la provincia, no las del radio
    return _buildProvinceCityChips();
  }



  String _getSelectedCategoryName() {
    if (_selectedCategoryId == null) return 'Todas las categorías';
    final selectedCategory = _categories.firstWhere(
      (c) => c.id == _selectedCategoryId,
      orElse: () => _categories.first,
    );
    return selectedCategory.name;
  }

  String _getSelectedDateLabel() {
    if (_fromDate == null && _toDate == null) return '';
    
    // Si hay un rango personalizado, mostrar formato corto
    if (_fromDate != null && _toDate != null) {
      final fromTxt = _df.format(_fromDate!);
      final toTxt = _df.format(_toDate!);
      return '$fromTxt → $toTxt';
    }
    
    return '';
  }

  String _getFiltersSubtitle() {
    final categoryName = _selectedCategoryId != null ? _getSelectedCategoryName() : null;
    final hasDateFilter = _fromDate != null || _toDate != null;
    
    // Detectar el preset de fecha usando los estados existentes o comparando fechas
    String? dateLabel;
    if (hasDateFilter) {
      if (_isToday) {
        dateLabel = 'Hoy';
      } else if (_isWeekend) {
        dateLabel = 'Fin de semana';
      } else if (_isThisMonth) {
        dateLabel = 'Este mes';
      } else if (_fromDate != null && _toDate != null) {
        // Rango personalizado
        dateLabel = _getSelectedDateLabel();
      }
    }
    
    // Construir el subtítulo
    if (categoryName == null && dateLabel == null) {
      return 'Categoría y fecha';
    } else if (categoryName != null && dateLabel == null) {
      return 'Categoría: $categoryName';
    } else if (categoryName == null && dateLabel != null) {
      return 'Fecha: $dateLabel';
    } else {
      return '$categoryName · $dateLabel';
    }
  }

  Widget _buildCategoryChipsContent() {
    if (_categories.isEmpty) return const SizedBox.shrink();
    
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Wrap(
        spacing: 8,
        runSpacing: 8,
        children: [
          // Chip "Todas"
          FilterChip(
            avatar: const Icon(Icons.grid_view, size: 16),
            label: const Text('Todas'),
            selected: _selectedCategoryId == null,
            onSelected: (_) {
              setState(() {
                _selectedCategoryId = null;
              });
              _reloadEvents();
            },
          ),
          // Chips de categorías
          ..._categories.where((Category c) => c.id != null).map((category) {
            final isSelected = category.id == _selectedCategoryId;
            final icon = iconFromName(category.icon);
            return FilterChip(
              avatar: Icon(icon, size: 16),
              label: Text(category.name),
              selected: isSelected,
              onSelected: (_) {
                setState(() {
                  _selectedCategoryId = isSelected ? null : category.id;
                });
                _reloadEvents();
              },
            );
          }),
        ],
      ),
    );
  }


  Widget _buildRadiusAndLocationContent() {
    return _NearbyControlWidget(
      radiusKm: _radiusKm,
      onRadiusChanged: (value) async {
        setState(() {
          _radiusKm = value;
        });
        // Actualizar eventos cercanos con el nuevo radio
        if (_userLat != null && _userLng != null) {
          await _loadNearby();
          await _loadNearbyCities();
        } else {
          // Si no hay ubicación del usuario, usar valores por defecto para cargar eventos cercanos
          final defaultLat = 36.1927; // Barbate
          final defaultLng = -5.9219;
          setState(() => _isNearbyLoading = true);
          try {
            final list = await _repoNearby.fetchNearby(
              lat: defaultLat,
              lng: defaultLng,
              radiusKm: _radiusKm,
            );
            setState(() => _nearbyEvents = list);
          } finally {
            if (mounted) setState(() => _isNearbyLoading = false);
          }
          // Cargar ciudades cercanas con valores por defecto
          final cities = await CityService.instance.fetchNearbyCities(
            lat: defaultLat,
            lng: defaultLng,
            radiusKm: _radiusKm,
          );
          if (mounted) {
            setState(() => _nearbyCities = cities);
          }
        }
        // Recargar eventos principales con el nuevo radio
        _reloadEvents();
      },
      onUseLocation: _getUserLocation,
    );
  }



  Future<void> _runSearch(String q) async {
    setState(() {
      _isSearching = true;
      _searchQuery = q;
    });

    final events = await EventService.instance.searchEvents(
      query: q,
      cityId: _selectedCityId,       // respeta filtro si hay
      // provinceId: ... (si lo tienes en estado)
      // lat/lng/radius si quieres mezclar con "cerca de ti" más adelante
    );

    if (!mounted) return;

    setState(() {
      _searchResults = events;
      _isSearching = false;
    });
  }

  Future<void> _runCitySearch(String q) async {
    setState(() {
      _isCitySearching = true;
      _citySearchQuery = q;
    });

    final res = await CityService.instance.searchCities(q);

    if (!mounted) return;

    setState(() {
      _citySearchResults = res;
      _isCitySearching = false;
    });
  }

  Future<void> _getUserLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      debugPrint('Servicios de ubicación desactivados.');
      return;
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        debugPrint('Permiso de ubicación denegado.');
        return;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      debugPrint('Permiso de ubicación denegado permanentemente.');
      return;
    }

    final pos = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    setState(() {
      _userLat = pos.latitude;
      _userLng = pos.longitude;
    });
    await _loadNearby();
    await _loadNearbyCities();
  }

  void _openSearchBottomSheet() {
    final searchController = TextEditingController(text: _searchEventTerm ?? '');
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Theme.of(context).colorScheme.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
          left: 16,
          right: 16,
          top: 16,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Buscar eventos',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: searchController,
              autofocus: true,
              textInputAction: TextInputAction.search,
              style: TextStyle(
                color: Theme.of(context).colorScheme.onSurface,
              ),
              decoration: InputDecoration(
                hintText: 'Buscar eventos (ej. flamenco, mercadillo...)',
                prefixIcon: Icon(
                  Icons.search,
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
              ),
              onSubmitted: (value) {
                final query = value.trim();
                setState(() {
                  _searchEventTerm = query.isEmpty ? null : query;
                });
                _reloadEvents();
                Navigator.pop(context);
              },
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Cancelar'),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  onPressed: () {
                    final query = searchController.text.trim();
                    setState(() {
                      _searchEventTerm = query.isEmpty ? null : query;
                    });
                    _reloadEvents();
                    Navigator.pop(context);
                  },
                  child: const Text('Buscar'),
                ),
              ],
            ),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }

  Widget _buildFilterPanel() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        elevation: 0,
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 1. Toggle Ciudad/Radio
              CityRadioToggle(
                selectedMode: _mode,
                onModeChanged: (mode) {
                  if (mode != _mode) {
                    _switchMode(mode);
                  }
                },
                selectedCityName: _selectedCityName,
                radiusKm: _radiusKm,
              ),
              const SizedBox(height: 12),
              // 2. Contenido dependiente del modo
              if (_mode == LocationMode.city)
                // Barra de búsqueda unificada (solo en modo Ciudad)
                UnifiedSearchBar(
                  selectedCityId: _selectedCityId,
                  onCitySelected: (city) {
                    if (mounted) {
                      setState(() {
                        _selectedCityId = city.id;
                        _selectedCityIds = {city.id};
                        _selectedCityName = city.name;
                      });
                      _reloadEvents(); // esto sí: al elegir ciudad, recargamos eventos
                    }
                  },
                  // De momento no usamos onSearchChanged para refrescar la lista global,
                  // la búsqueda de eventos globales la manejamos con el botón de lupa del AppBar.
                  onSearchChanged: null,
                )
              else
                // Slider de radio + botón "Usar mi ubicación" (solo en modo Radio)
                _buildRadiusAndLocationContent(),
              const SizedBox(height: 12),
              // 3. Chips rápidos de fecha
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    ActionChip(
                      label: const Text('Hoy'),
                      onPressed: () {
                        final r = todayRange();
                        setState(() {
                          _isToday = true;
                          _isWeekend = false;
                          _isThisMonth = false;
                        });
                        _reloadWithDateRange(from: r.from, to: r.to);
                      },
                    ),
                    const SizedBox(width: 8),
                    ActionChip(
                      label: const Text('Fin de semana'),
                      onPressed: () {
                        final r = weekendRange();
                        setState(() {
                          _isToday = false;
                          _isWeekend = true;
                          _isThisMonth = false;
                        });
                        _reloadWithDateRange(from: r.from, to: r.to);
                      },
                    ),
                    const SizedBox(width: 8),
                    ActionChip(
                      label: const Text('Este mes'),
                      onPressed: () {
                        final r = thisMonthRange();
                        setState(() {
                          _isToday = false;
                          _isWeekend = false;
                          _isThisMonth = true;
                        });
                        _reloadWithDateRange(from: r.from, to: r.to);
                      },
                    ),
                    const SizedBox(width: 8),
                    OutlinedButton.icon(
                      icon: const Icon(Icons.date_range, size: 18),
                      label: const Text('Rango...'),
                      onPressed: () async {
                        final now = DateTime.now();
                        final first = DateTime(now.year - 1, 1, 1);
                        final last = DateTime(now.year + 2, 12, 31);

                        final picked = await showDateRangePicker(
                          context: context,
                          firstDate: first,
                          lastDate: last,
                          initialDateRange: (_fromDate != null && _toDate != null)
                              ? DateTimeRange(start: _fromDate!, end: _toDate!)
                              : null,
                        );
                        if (picked != null) {
                          setState(() {
                            _selectedDatePreset = null;
                            _isToday = false;
                            _isWeekend = false;
                            _isThisMonth = false;
                          });
                          _reloadWithDateRange(from: picked.start, to: picked.end);
                        }
                      },
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),
              // 4. ExpansionTile "Filtros" (categorías + rango de fecha)
              ExpansionTile(
                title: Text(
                  'Filtros',
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
                ),
                subtitle: Text(
                  _buildFiltersSubtitle(),
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
                ),
                leading: Icon(
                  Icons.filter_list,
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
                children: [
                  // Categorías
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Categoría',
                          style: Theme.of(context).textTheme.labelLarge?.copyWith(
                                fontWeight: FontWeight.w600,
                              ),
                        ),
                        const SizedBox(height: 8),
                        if (_categories.isEmpty)
                          const Text('No hay categorías disponibles')
                        else
                          Wrap(
                            spacing: 8,
                            runSpacing: 8,
                            children: [
                              // Chip "Todas"
                              FilterChip(
                                avatar: Icon(
                                  Icons.grid_view,
                                  size: 16,
                                  color: _selectedCategoryId == null
                                      ? Theme.of(context).colorScheme.onPrimaryContainer
                                      : Theme.of(context).colorScheme.onSurfaceVariant,
                                ),
                                label: const Text('Todas'),
                                selected: _selectedCategoryId == null,
                                onSelected: (_) {
                                  setState(() {
                                    _selectedCategoryId = null;
                                  });
                                  _reloadEvents();
                                },
                              ),
                              // Chips de categorías
                              ..._categories.where((Category c) => c.id != null).map((category) {
                                final isSelected = category.id == _selectedCategoryId;
                                final icon = iconFromName(category.icon);
                                return FilterChip(
                                  avatar: Icon(
                                    icon,
                                    size: 16,
                                    color: isSelected
                                        ? Theme.of(context).colorScheme.onPrimaryContainer
                                        : Theme.of(context).colorScheme.onSurfaceVariant,
                                  ),
                                  label: Text(category.name),
                                  selected: isSelected,
                                  onSelected: (_) {
                                    setState(() {
                                      _selectedCategoryId = isSelected ? null : category.id;
                                    });
                                    _reloadEvents();
                                  },
                                );
                              }),
                            ],
                          ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 12),
                  // Rango de fecha
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Rango de fecha',
                          style: Theme.of(context).textTheme.labelLarge?.copyWith(
                                fontWeight: FontWeight.w600,
                              ),
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            Expanded(
                              child: OutlinedButton.icon(
                                icon: const Icon(Icons.date_range, size: 18),
                                label: Text(
                                  _fromDate != null && _toDate != null
                                      ? '${_df.format(_fromDate!)} → ${_df.format(_toDate!)}'
                                      : 'Seleccionar rango',
                                ),
                                onPressed: () async {
                                  final now = DateTime.now();
                                  final first = DateTime(now.year - 1, 1, 1);
                                  final last = DateTime(now.year + 2, 12, 31);

                                  final picked = await showDateRangePicker(
                                    context: context,
                                    firstDate: first,
                                    lastDate: last,
                                    initialDateRange: (_fromDate != null && _toDate != null)
                                        ? DateTimeRange(start: _fromDate!, end: _toDate!)
                                        : null,
                                  );
                                  if (picked != null) {
                                    setState(() {
                                      _selectedDatePreset = null;
                                      _isToday = false;
                                      _isWeekend = false;
                                      _isThisMonth = false;
                                    });
                                    _reloadWithDateRange(from: picked.start, to: picked.end);
                                  }
                                },
                              ),
                            ),
                            if (_fromDate != null || _toDate != null) ...[
                              const SizedBox(width: 8),
                              IconButton(
                                icon: const Icon(Icons.clear),
                                onPressed: () {
                                  setState(() {
                                    _isToday = false;
                                    _isWeekend = false;
                                    _isThisMonth = false;
                                  });
                                  _reloadWithDateRange(from: null, to: null);
                                },
                              ),
                            ],
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 8),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _buildFiltersSubtitle() {
    final parts = <String>[];
    
    if (_selectedCategoryId != null) {
      parts.add(_getSelectedCategoryName());
    }
    
    if (_fromDate != null && _toDate != null) {
      parts.add('${_df.format(_fromDate!)} → ${_df.format(_toDate!)}');
    } else if (_isToday) {
      parts.add('Hoy');
    } else if (_isWeekend) {
      parts.add('Fin de semana');
    } else if (_isThisMonth) {
      parts.add('Este mes');
    }
    
    return parts.isEmpty ? 'Todos los filtros' : parts.join(' · ');
  }

  @override
  Widget build(BuildContext context) {
    if (_error != null && !_isLoading) {
      return Scaffold(
        appBar: AppBar(title: const Text('Fiestapp')),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline, size: 64, color: Colors.red),
              const SizedBox(height: 16),
              Text(
                'Error al cargar datos',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 8),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 32),
                child: Text(
                  _error!,
                  textAlign: TextAlign.center,
                  style: Theme.of(
                    context,
                  ).textTheme.bodyMedium?.copyWith(
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
                ),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: _reloadEvents,
                child: const Text('Reintentar'),
              ),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Fiestapp'),
        elevation: 0,
        actions: [
          // Botón claro/oscuro
          IconButton(
            icon: Icon(
              Theme.of(context).brightness == Brightness.dark
                  ? Icons.wb_sunny_outlined
                  : Icons.nightlight_round,
              color: Theme.of(context).colorScheme.onSurface,
            ),
            onPressed: () {
              // Alternar entre claro y oscuro
              if (appThemeMode.value == ThemeMode.dark) {
                appThemeMode.value = ThemeMode.light;
              } else {
                appThemeMode.value = ThemeMode.dark;
              }
            },
          ),
        ],
      ),
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: _reloadEvents,
          child: CustomScrollView(
            slivers: [
            SliverToBoxAdapter(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
                    child: DashboardHero(featured: _featuredEvent),
                  ),
                  if (!_isLoading) ...[
                    _buildFilterPanel(),
                  ],
                  // Resultados de búsqueda
                  if (_searchEventTerm != null && _searchEventTerm!.isNotEmpty) ...[
                    const SizedBox(height: 8),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Resultados para "$_searchEventTerm"', style: Theme.of(context).textTheme.titleMedium),
                        ],
                      ),
                    ),
                    const SizedBox(height: 8),
                  ],
                  // Próximos eventos
                  if (_isLoading)
                    Padding(
                      padding: const EdgeInsets.fromLTRB(8, 8, 8, 16),
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.surfaceVariant,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: ListView.separated(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                          physics: const NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          itemCount: 4,
                          separatorBuilder: (BuildContext context, int index) =>
                              const SizedBox(height: 12),
                          itemBuilder: (BuildContext context, int index) {
                            return const Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                ShimmerBlock(height: 180),
                                ShimmerBlock(height: 16, width: 180),
                                ShimmerBlock(height: 14, width: 120),
                              ],
                            );
                          },
                        ),
                      ),
                    )
                  else
                    Padding(
                      padding: const EdgeInsets.fromLTRB(8, 4, 8, 16),
                      child: UpcomingEventsSection(
                        events: _upcomingEvents,
                        selectedCategoryId: _selectedCategoryId,
                        // En modo Radio no aplicamos filtro por ciudad
                        selectedCityId: _mode == LocationMode.city ? _selectedCityId : null,
                        onClearFilters: _clearFilters,
                      ),
                    ),
                  // Popular esta semana
                  if (_isLoading)
                    Padding(
                      padding: const EdgeInsets.fromLTRB(8, 0, 8, 24),
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.surfaceVariant,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: SizedBox(
                          height: 210,
                          child: ListView.separated(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            scrollDirection: Axis.horizontal,
                            itemCount: 5,
                            separatorBuilder: (BuildContext context, int index) =>
                                const SizedBox(width: 12),
                            itemBuilder: (BuildContext context, int index) {
                              return const SizedBox(
                                width: 280,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    ShimmerBlock(height: 150),
                                    ShimmerBlock(height: 16, width: 160),
                                    ShimmerBlock(height: 14, width: 120),
                                  ],
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                    )
                  else
                    Padding(
                      padding: const EdgeInsets.fromLTRB(8, 0, 8, 24),
                      child: PopularThisWeekSection(
                        events: _featuredEvents,
                        onClearFilters: _clearFilters,
                      ),
                    ),
                  // Sección "Cerca de ti" (solo en modo Radio)
                  if (_isNearbyLoading)
                    Padding(
                      padding: const EdgeInsets.fromLTRB(8, 8, 8, 16),
                      child: ShimmerBlock(
                        height: 80,
                      ),
                    )
                  else if (_mode == LocationMode.radius)
                    Padding(
                      padding: const EdgeInsets.fromLTRB(8, 8, 8, 16),
                      child: NearbyEventsSection(
                        events: _nearbyEvents,
                      ),
                    )
                  else
                    const SizedBox.shrink(),
                  const SizedBox(height: 24),
                ],
              ),
            ),
          ],
          ),
        ),
      ),
    );
  }
}

// === Section Widgets ===

class DashboardHero extends StatelessWidget {
  final Event? featured;

  const DashboardHero({super.key, this.featured});

  @override
  Widget build(BuildContext context) {
    if (featured == null) {
      return const SizedBox.shrink();
    }

    return HeroBanner(
      title: featured!.title,
      subtitle: 'Temporada actual',
      imageUrl: featured!.imageUrl ?? '',
      onFeaturedTap: () {
        // TODO: Navegar a eventos destacados
      },
    );
  }
}

class UpcomingEventsSection extends StatelessWidget {
  final List<Event> events;
  final int? selectedCategoryId;
  final int? selectedCityId;
  final VoidCallback? onClearFilters;

  const UpcomingEventsSection({
    super.key,
    required this.events,
    this.selectedCategoryId,
    this.selectedCityId,
    this.onClearFilters,
  });

  @override
  Widget build(BuildContext context) {
    // Aplicar filtros combinados: ciudad y categoría (null-safe)
    final filtered = events.where((e) =>
      (selectedCityId == null || e.cityId == selectedCityId) &&
      (selectedCategoryId == null || e.categoryId == selectedCategoryId)
    ).toList();

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceVariant,
        borderRadius: BorderRadius.circular(16),
      ),
      child: UpcomingList(
        events: filtered,
        onClearFilters: onClearFilters,
      ),
    );
  }
}

class CategoriesSection extends StatelessWidget {
  final List<Category> categories;
  final int? selectedCategoryId;
  final ValueChanged<int?> onCategoryTap;

  const CategoriesSection({
    super.key,
    required this.categories,
    this.selectedCategoryId,
    required this.onCategoryTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceVariant,
        borderRadius: BorderRadius.circular(16),
      ),
      child: CategoriesGrid(
        categories: categories,
        selectedCategoryId: selectedCategoryId,
        onCategoryTap: onCategoryTap,
      ),
    );
  }
}

class PopularThisWeekSection extends StatelessWidget {
  final List<Event> events;
  final VoidCallback? onClearFilters;

  const PopularThisWeekSection({
    super.key,
    required this.events,
    this.onClearFilters,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceVariant,
        borderRadius: BorderRadius.circular(16),
      ),
      child: PopularCarousel(
        events: events,
        onClearFilters: onClearFilters,
      ),
    );
  }
}

class NearbyEventsSection extends StatelessWidget {
  final List<model.Event> events;

  const NearbyEventsSection({
    super.key,
    required this.events,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceVariant,
        borderRadius: BorderRadius.circular(16),
      ),
      child: events.isEmpty
          ? Padding(
              padding: const EdgeInsets.all(24),
              child: Center(
                child: Text(
                  'No hay eventos en este radio.',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                  textAlign: TextAlign.center,
                ),
              ),
            )
          : Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Text(
                    'Cerca de ti',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                ),
                const SizedBox(height: 12),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: UpcomingList(
                    events: events.map((e) => Event(
                      id: e.id,
                      title: e.title,
                      startsAt: e.startsAt,
                      cityName: e.cityName,
                      categoryName: e.categoryName,
                      categoryIcon: e.categoryIcon,
                      categoryColor: e.categoryColor,
                      place: e.place,
                      imageUrl: e.imageUrl,
                      categoryId: e.categoryId,
                      cityId: e.cityId,
                      isFree: e.isFree,
                      mapsUrl: e.mapsUrl,
                      description: e.description,
                    )).toList(),
                  ),
                ),
              ],
            ),
    );
  }
}

// Widget para filtros de ciudad y categoría
class _FilterHeaderWidget extends StatelessWidget {
  const _FilterHeaderWidget({
    required this.cities,
    required this.categories,
    this.selectedCityId,
    this.selectedCategoryId,
    required this.onCityTap,
    required this.onCategoryTap,
    this.showCityChips = true,
  });

  final List<City> cities;
  final List<Category> categories;
  final int? selectedCityId;
  final int? selectedCategoryId;
  final ValueChanged<int?> onCityTap;
  final ValueChanged<int?> onCategoryTap;
  final bool showCityChips;

  List<Widget> buildCityChips(BuildContext context) {
    final chips = <Widget>[];

    // Chip "Todas"
    final isAllSelected = selectedCityId == null;
    chips.add(
      ChoiceChip(
        label: Text(
          'Todas',
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: isAllSelected
                ? Theme.of(context).colorScheme.onPrimaryContainer
                : Theme.of(context).colorScheme.onSurface,
          ),
        ),
        avatar: Icon(
          Icons.place_outlined,
          size: 16,
          color: isAllSelected
              ? Theme.of(context).colorScheme.onPrimaryContainer
              : Theme.of(context).colorScheme.onSurfaceVariant,
        ),
        selected: isAllSelected,
        selectedColor: Theme.of(context).colorScheme.primaryContainer,
        onSelected: (selected) {
          if (selected) {
            onCityTap(null);
          }
        },
        visualDensity: VisualDensity.compact,
        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
      ),
    );

    // Chips de ciudades (construidos dinámicamente desde cities)
    for (final city in cities) {
      final isSelected = city.id == selectedCityId;
      chips.add(
        ChoiceChip(
          label: Text(
            city.name,
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: isSelected
                  ? Theme.of(context).colorScheme.onPrimaryContainer
                  : Theme.of(context).colorScheme.onSurface,
            ),
          ),
          selected: isSelected,
          selectedColor: Theme.of(context).colorScheme.primaryContainer,
          onSelected: (selected) {
            if (selected) {
              onCityTap(city.id);
            }
          },
          visualDensity: VisualDensity.compact,
          materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
        ),
      );
    }

    return chips;
  }

  List<Widget> buildCategoryChips(BuildContext context) {
    final chips = <Widget>[];

    // Chip "Todas"
    final isAllSelected = selectedCategoryId == null;
    chips.add(
      ChoiceChip(
        label: Text(
          'Todas',
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: isAllSelected
                ? Theme.of(context).colorScheme.onPrimaryContainer
                : Theme.of(context).colorScheme.onSurface,
          ),
        ),
        selected: isAllSelected,
        selectedColor: Theme.of(context).colorScheme.primaryContainer,
        avatar: Icon(
          Icons.grid_view,
          size: 16,
          color: isAllSelected
              ? Theme.of(context).colorScheme.onPrimaryContainer
              : Theme.of(context).colorScheme.onSurfaceVariant,
        ),
        onSelected: (selected) {
          if (selected) {
            onCategoryTap(null);
          }
        },
        visualDensity: VisualDensity.compact,
        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
      ),
    );

    // Chips de categorías (solo mostrar categorías con id)
    for (final category in categories.where((Category c) => c.id != null)) {
      final isSelected = category.id == selectedCategoryId;
      final icon = iconFromName(category.icon);

      chips.add(
        ChoiceChip(
          label: Text(
            category.name,
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: isSelected
                  ? Theme.of(context).colorScheme.onPrimaryContainer
                  : Theme.of(context).colorScheme.onSurface,
            ),
          ),
          selected: isSelected,
          selectedColor: Theme.of(context).colorScheme.primaryContainer,
          avatar: Icon(
            icon,
            size: 16,
            color: isSelected
                ? Theme.of(context).colorScheme.onPrimaryContainer
                : Theme.of(context).colorScheme.onSurfaceVariant,
          ),
          onSelected: (selected) {
            if (selected) {
              onCategoryTap(category.id);
            } else if (isSelected) {
              // Toggle: si ya está seleccionado, deseleccionar
              onCategoryTap(null);
            }
          },
          visualDensity: VisualDensity.compact,
          materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
        ),
      );
    }

    return chips;
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Theme.of(context).scaffoldBackgroundColor,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Fila 1: chips de ciudades (scroll horizontal)
            if (showCityChips) ...[
              SizedBox(
                height: 40,
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Row(
                    children: [
                      ...buildCityChips(context),
                    ]
                        .expand((w) => [w, const SizedBox(width: 8)])
                        .toList()
                      ..removeLast(),
                  ),
                ),
              ),
              const SizedBox(height: 8),
            ],
            // Fila 2: chips de categorías (scroll horizontal)
            SizedBox(
              height: 42,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 12),
                itemBuilder: (context, i) {
                  if (i == 0) {
                    // Chip "Todas"
                    final isAllSelected = selectedCategoryId == null;
                    return FilterChip(
                      avatar: const Icon(Icons.grid_view, size: 16),
                      label: const Text('Todas'),
                      selected: isAllSelected,
                      onSelected: (_) => onCategoryTap(null),
                    );
                  }
                  // Chips de categorías
                  final category = categories.where((Category c) => c.id != null).toList()[i - 1];
                  final selected = selectedCategoryId == category.id;
                  final icon = iconFromName(category.icon);
                  return FilterChip(
                    avatar: Icon(icon, size: 16),
                    label: Text(category.name),
                    selected: selected,
                    onSelected: (_) => onCategoryTap(category.id),
                  );
                },
                separatorBuilder: (_, __) => const SizedBox(width: 8),
                itemCount: categories.where((Category c) => c.id != null).length + 1,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Widget para control de eventos cercanos
class _NearbyControlWidget extends StatelessWidget {
  const _NearbyControlWidget({
    required this.radiusKm,
    required this.onRadiusChanged,
    required this.onUseLocation,
  });

  final double radiusKm;
  final ValueChanged<double> onRadiusChanged;
  final VoidCallback onUseLocation;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Theme.of(context).scaffoldBackgroundColor,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Radio',
                            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                  fontWeight: FontWeight.w500,
                                ),
                          ),
                          Text(
                            '${radiusKm.toInt()} km',
                            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                  fontWeight: FontWeight.w600,
                                ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      SliderTheme(
                        data: SliderTheme.of(context).copyWith(
                          trackHeight: 4,
                          thumbShape: const RoundSliderThumbShape(
                            enabledThumbRadius: 8,
                          ),
                        ),
                        child: Slider(
                          value: radiusKm,
                          min: 5,
                          max: 100,
                          divisions: 19,
                          label: '${radiusKm.round()} km',
                          onChanged: onRadiusChanged,
                        ),
                      ),
                      const SizedBox(height: 12),
                    ],
                  ),
                ),
                const SizedBox(width: 12),
                OutlinedButton.icon(
                  onPressed: onUseLocation,
                  icon: const Icon(Icons.location_on, size: 18),
                  label: const Text('Usar mi ubicación'),
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// Delegate para SliverPersistentHeader de filtros (mantenido por compatibilidad, pero ya no se usa)
class _FilterHeaderDelegate extends SliverPersistentHeaderDelegate {
  _FilterHeaderDelegate({
    required this.cities,
    required this.categories,
    this.selectedCityId,
    this.selectedCategoryId,
    required this.onCityTap,
    required this.onCategoryTap,
    this.min = 112.0,
    this.max = 112.0,
  });

  final List<City> cities;
  final List<Category> categories;
  final int? selectedCityId;
  final int? selectedCategoryId;
  final ValueChanged<int?> onCityTap;
  final ValueChanged<int?> onCategoryTap;
  final double min;
  final double max;

  @override
  double get minExtent => min;

  @override
  double get maxExtent => max;

  List<Widget> buildCityChips(BuildContext context) {
    final theme = Theme.of(context);
    final chips = <Widget>[];

    // Chip "Todas"
    chips.add(
      ChoiceChip(
        label: Text('Todas', style: theme.textTheme.labelLarge),
        selected: selectedCityId == null,
        onSelected: (selected) {
          if (selected) {
            onCityTap(null);
          }
        },
        visualDensity: VisualDensity.compact,
        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
      ),
    );

    // Nombres oficiales completos permitidos
    const officialCityNames = {
      'Barbate',
      'Vejer de la Frontera',
      'Zahara de los Atunes',
    };

    // Filtrar ciudades para mostrar solo nombres oficiales completos
    final filteredCities = cities.where((city) => 
      officialCityNames.contains(city.name)
    ).toList();

    // Ordenar según el orden deseado
    filteredCities.sort((a, b) {
      const order = ['Barbate', 'Vejer de la Frontera', 'Zahara de los Atunes'];
      final indexA = order.indexOf(a.name);
      final indexB = order.indexOf(b.name);
      if (indexA == -1) return 1;
      if (indexB == -1) return -1;
      return indexA.compareTo(indexB);
    });

    // Chips de ciudades (solo nombres oficiales completos)
    for (final city in filteredCities) {
      final isSelected = city.id == selectedCityId;
      chips.add(
        ChoiceChip(
          label: Text(city.name, style: theme.textTheme.labelLarge),
          selected: isSelected,
          onSelected: (selected) {
            if (selected) {
              onCityTap(city.id);
            }
          },
          visualDensity: VisualDensity.compact,
          materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
        ),
      );
    }

    return chips;
  }

  List<Widget> buildCategoryChips(BuildContext context) {
    final theme = Theme.of(context);
    final chips = <Widget>[];

    // Chip "Todas"
    chips.add(
      ChoiceChip(
        label: Text('Todas', style: theme.textTheme.labelLarge),
        selected: selectedCategoryId == null,
        avatar: const Icon(Icons.grid_view, size: 16),
        onSelected: (selected) {
          if (selected) {
            onCategoryTap(null);
          }
        },
        visualDensity: VisualDensity.compact,
        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
      ),
    );

    // Chips de categorías (solo mostrar categorías con id)
    for (final category in categories.where((Category c) => c.id != null)) {
      final isSelected = category.id == selectedCategoryId;
      final icon = iconFromName(category.icon);

      chips.add(
        ChoiceChip(
          label: Text(category.name, style: theme.textTheme.labelLarge),
          selected: isSelected,
          avatar: Icon(icon, size: 16),
          onSelected: (selected) {
            if (selected) {
              onCategoryTap(category.id);
            } else if (isSelected) {
              // Toggle: si ya está seleccionado, deseleccionar
              onCategoryTap(null);
            }
          },
          visualDensity: VisualDensity.compact,
          materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
        ),
      );
    }

    return chips;
  }

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Material(
      color: Theme.of(context).scaffoldBackgroundColor,
      child: SizedBox.expand(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Fila 1: chips de ciudades (scroll horizontal "ligero")
              SizedBox(
                height: 36,
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: Row(
                    children: [
                      ...buildCityChips(context),
                    ]
                        .expand((w) => [w, const SizedBox(width: 8)])
                        .toList()
                      ..removeLast(),
                  ),
                ),
              ),
              const SizedBox(height: 8),
              // Fila 2: chips de categorías (scroll horizontal "ligero")
              SizedBox(
                height: 36,
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: Row(
                    children: [
                      ...buildCategoryChips(context),
                    ]
                        .expand((w) => [w, const SizedBox(width: 8)])
                        .toList()
                      ..removeLast(),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  bool shouldRebuild(covariant _FilterHeaderDelegate old) {
    return old.selectedCityId != selectedCityId ||
        old.selectedCategoryId != selectedCategoryId ||
        old.cities.length != cities.length ||
        old.categories.length != categories.length;
  }
}

// Delegate para SliverPersistentHeader de control nearby
class _NearbyControlHeaderDelegate extends SliverPersistentHeaderDelegate {
  _NearbyControlHeaderDelegate({
    required this.radiusKm,
    required this.onRadiusChanged,
    required this.onUseLocation,
    this.min = 80.0,
    this.max = 80.0,
  });

  final double radiusKm;
  final ValueChanged<double> onRadiusChanged;
  final VoidCallback onUseLocation;
  final double min;
  final double max;

  @override
  double get minExtent => min;

  @override
  double get maxExtent => max;

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Material(
      color: Theme.of(context).scaffoldBackgroundColor,
      child: SizedBox.expand(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'A ${radiusKm.round()} km',
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                fontWeight: FontWeight.w600,
                              ),
                        ),
                        Slider(
                          value: radiusKm,
                          min: 5,
                          max: 100,
                          divisions: 19,
                          label: '${radiusKm.round()} km',
                          onChanged: onRadiusChanged,
                        ),
                        const SizedBox(height: 12),
                      ],
                    ),
                  ),
                  const SizedBox(width: 12),
                  ElevatedButton.icon(
                    onPressed: onUseLocation,
                    icon: const Icon(Icons.location_on, size: 18),
                    label: const Text('Usar mi ubicación'),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  bool shouldRebuild(covariant _NearbyControlHeaderDelegate old) {
    return old.radiusKm != radiusKm;
  }
}
