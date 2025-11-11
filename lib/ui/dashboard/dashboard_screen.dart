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
import '../icons/icon_mapper.dart';
import 'package:fiestapp/ui/common/shimmer_widgets.dart';
import '../../utils/date_ranges.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  final EventService _eventService = EventService();
  final CategoryService _categoryService = CategoryService();
  final CityService _cityService = CityService();
  final _repo = EventsRepository();
  final _repoNearby = EventsRepository();

  Event? _featuredEvent;
  List<Event> _upcomingEvents = [];
  List<Event> _featuredEvents = [];
  List<Category> _categories = [];
  bool _isLoading = true;
  String? _error;
  int? _selectedCategoryId;
  int? _selectedCityId;
  List<City> _cities = [];
  DateTime? _fromDate;
  DateTime? _toDate;
  
  // Nearby events state
  double _radiusKm = 25;
  double? _userLat = 36.1927; // Barbate (temporal)
  double? _userLng = -5.9219; // Barbate (temporal)
  bool _isNearbyLoading = false;
  List<model.Event> _nearbyEvents = [];
  List<City> _nearbyCities = [];
  
  // Search state
  final _searchCtrl = TextEditingController();
  String _searchQuery = '';
  Timer? _searchDebouncer;
  bool _isSearching = false;
  List<Event> _searchResults = [];
  
  // City search state
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

  Future<void> _reloadEvents() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final results = await Future.wait([
        _eventService.fetchUpcoming(limit: 10),
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
    });
  }

  void _clearFilters() {
    setState(() {
      _selectedCategoryId = null;
      _selectedCityId = null;
    });
  }

  Future<void> _reloadWithDateRange({DateTime? from, DateTime? to}) async {
    setState(() {
      _fromDate = from;
      _toDate = to;
      _isLoading = true;
    });
    final events = await EventService().listEvents(
      cityId: _selectedCityId,
      categoryId: _selectedCategoryId,
      from: _fromDate,
      to: _toDate,
    );
    if (!mounted) return;
    setState(() {
      _upcomingEvents = events;
      _isLoading = false;
    });
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

    final cities = await CityService().fetchNearbyCities(
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
          });
          // aquí si filtras por ciudad en la lista principal, refresca como ya hacías
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
            });
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
            });
          },
          materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
          visualDensity: VisualDensity.compact,
        )),
      ],
    );
  }

  Widget _buildCityChips() {
    // Si hay resultado por radio, mostramos solo esa fila.
    if (_nearbyCities.isNotEmpty) {
      return _buildNearbyCityChips();
    }
    // Si no hay ciudades cercanas (no hay ubicación o radio pequeño), mostramos la fila estática
    return _buildProvinceCityChips();
  }

  Future<void> _runSearch(String q) async {
    setState(() {
      _isSearching = true;
      _searchQuery = q;
    });

    final events = await EventService().searchEvents(
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

    final res = await CityService().searchCities(q);

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
                  ).textTheme.bodyMedium?.copyWith(color: Colors.grey[600]),
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
      appBar: AppBar(title: const Text('Fiestapp'), elevation: 0),
      body: RefreshIndicator(
        onRefresh: _reloadEvents,
        child: SingleChildScrollView(
          physics: defaultTargetPlatform == TargetPlatform.iOS
              ? const BouncingScrollPhysics()
              : const ClampingScrollPhysics(),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SafeArea(
                  bottom: false,
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
                    child: DashboardHero(featured: _featuredEvent),
                  ),
                ),
                if (!_isLoading) ...[
                  TextField(
                    controller: _citySearchCtrl,
                    decoration: InputDecoration(
                      hintText: 'Buscar ciudad o pueblo (ej. "Zahara", "Vejer")',
                      prefixIcon: const Icon(Icons.location_searching, size: 20),
                      suffixIcon: _citySearchQuery.isNotEmpty
                          ? IconButton(
                              icon: const Icon(Icons.clear),
                              onPressed: () {
                                _citySearchCtrl.clear();
                                setState(() {
                                  _citySearchQuery = '';
                                  _citySearchResults = [];
                                });
                              },
                            )
                          : null,
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                      isDense: true,
                    ),
                    onChanged: (txt) {
                      _citySearchDebouncer?.cancel();
                      _citySearchDebouncer = Timer(const Duration(milliseconds: 300), () {
                        final t = txt.trim();
                        if (t.isEmpty) {
                          setState(() {
                            _citySearchQuery = '';
                            _citySearchResults = [];
                          });
                        } else {
                          _runCitySearch(t);
                        }
                      });
                    },
                  ),
                  if (_citySearchQuery.isNotEmpty) ...[
                    const SizedBox(height: 8),
                    if (_isCitySearching)
                      const Center(child: SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2))),
                    if (!_isCitySearching && _citySearchResults.isEmpty)
                      const Text('Sin ciudades para esa búsqueda'),
                    if (!_isCitySearching && _citySearchResults.isNotEmpty)
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: _citySearchResults.map((c) => ActionChip(
                          label: Text(c.name, style: Theme.of(context).textTheme.labelLarge),
                          onPressed: () {
                            // fijamos ciudad seleccionada y limpiamos búsqueda
                            setState(() {
                              _selectedCityId = c.id;
                              _citySearchCtrl.clear();
                              _citySearchQuery = '';
                              _citySearchResults = [];
                            });
                            // opcional: scroll a la sección de eventos
                          },
                          materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                          visualDensity: VisualDensity.compact,
                        )).toList(),
                      ),
                    const SizedBox(height: 8),
                  ],
                  const SizedBox(height: 10),
                  TextField(
                    controller: _searchCtrl,
                    decoration: InputDecoration(
                      hintText: 'Buscar eventos (ej. flamenco, mercadillo...)',
                      prefixIcon: const Icon(Icons.search, size: 20),
                      suffixIcon: _searchQuery.isNotEmpty
                          ? IconButton(
                              icon: const Icon(Icons.clear),
                              onPressed: () {
                                _searchCtrl.clear();
                                setState(() {
                                  _searchQuery = '';
                                  _searchResults = [];
                                });
                              },
                            )
                          : null,
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                      isDense: true,
                    ),
                    onChanged: (txt) {
                      _searchDebouncer?.cancel();
                      _searchDebouncer = Timer(const Duration(milliseconds: 350), () {
                        if (txt.trim().isEmpty) {
                          setState(() {
                            _searchQuery = '';
                            _searchResults = [];
                          });
                        } else {
                          _runSearch(txt.trim());
                        }
                      });
                    },
                  ),
                  const SizedBox(height: 8),
                  _FilterHeaderWidget(
                    cities: _cities,
                    categories: _categories,
                    selectedCityId: _selectedCityId,
                    selectedCategoryId: _selectedCategoryId,
                    onCityTap: (cityId) {
                      setState(() {
                        _selectedCityId = cityId;
                      });
                    },
                    onCategoryTap: (categoryId) {
                      setState(() {
                        _selectedCategoryId = _selectedCategoryId == categoryId ? null : categoryId;
                      });
                    },
                    showCityChips: false,
                  ),
                  const SizedBox(height: 8),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        const SizedBox(width: 8),
                        ActionChip(
                          label: const Text('Hoy'),
                          onPressed: () {
                            final r = todayRange();
                            _reloadWithDateRange(from: r.from, to: r.to);
                          },
                        ),
                        const SizedBox(width: 8),
                        ActionChip(
                          label: const Text('Fin de semana'),
                          onPressed: () {
                            final r = weekendRange();
                            _reloadWithDateRange(from: r.from, to: r.to);
                          },
                        ),
                        const SizedBox(width: 8),
                        ActionChip(
                          label: const Text('Este mes'),
                          onPressed: () {
                            final r = thisMonthRange();
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
                              _reloadWithDateRange(from: picked.start, to: picked.end);
                            }
                          },
                        ),
                        const SizedBox(width: 8),
                      ],
                    ),
                  ),
                  const SizedBox(height: 4),
                  if (_fromDate != null || _toDate != null) ...[
                    const SizedBox(height: 6),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: TextButton.icon(
                        icon: const Icon(Icons.close),
                        label: const Text('Borrar filtro de fecha'),
                        onPressed: () => _reloadWithDateRange(from: null, to: null),
                      ),
                    ),
                  ],
                ],
                if (!_isLoading)
                  _NearbyControlWidget(
                    radiusKm: _radiusKm,
                    onRadiusChanged: (value) async {
                      setState(() {
                        _radiusKm = value;
                      });
                      if (_userLat != null && _userLng != null) {
                        await _loadNearby();
                        await _loadNearbyCities();
                      }
                    },
                    onUseLocation: _getUserLocation,
                  ),
                if (!_isLoading) ...[
                  const SizedBox(height: 8),
                  Padding(
                    padding: const EdgeInsets.only(left: 16, bottom: 6),
                    child: Text(
                      'Ciudades dentro del radio',
                      style: Theme.of(context).textTheme.titleMedium!.copyWith(
                        fontWeight: FontWeight.w600,
                        color: const Color(0xFF5b351f),
                      ),
                    ),
                  ),
                  _buildCityChips(),
                  const SizedBox(height: 8),
                ],
                // Resultados de búsqueda
                if (_searchQuery.isNotEmpty) ...[
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Resultados para "$_searchQuery"', style: Theme.of(context).textTheme.titleMedium),
                      if (_isSearching) const SizedBox(width: 16),
                      if (_isSearching) const SizedBox(
                        width: 16, height: 16, child: CircularProgressIndicator(strokeWidth: 2),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  if (_searchResults.isEmpty && !_isSearching)
                    const Text('Sin resultados'),
                  if (_searchResults.isNotEmpty)
                    // reutiliza tu widget de lista de eventos
                    UpcomingList(events: _searchResults),
                  const SizedBox(height: 16),
                ],
                // Próximos eventos
                if (_isLoading)
                  Padding(
                    padding: const EdgeInsets.fromLTRB(8, 8, 8, 16),
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.7),
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
                      selectedCityId: _selectedCityId,
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
                        color: Colors.white.withOpacity(0.7),
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
                // Cerca de ti
                if (_isNearbyLoading)
                  Padding(
                    padding: const EdgeInsets.fromLTRB(8, 8, 8, 16),
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.7),
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
                    padding: const EdgeInsets.fromLTRB(8, 8, 8, 16),
                    child: NearbyEventsSection(
                      events: _selectedCityId == null
                          ? _nearbyEvents
                          : _nearbyEvents.where((e) => e.cityId == _selectedCityId).toList(),
                    ),
                  ),
                const SizedBox(height: 24),
              ],
            ),
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
        color: Colors.white.withOpacity(0.7),
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
        color: Colors.white.withOpacity(0.7),
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
        color: Colors.white.withOpacity(0.7),
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
        color: Colors.white.withOpacity(0.7),
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
        label: const Text(
          'Todas',
          style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
        ),
        avatar: const Icon(Icons.place_outlined, size: 16),
        selected: isAllSelected,
        selectedColor: const Color(0xFFFFE9DC),
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
            style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
          ),
          selected: isSelected,
          selectedColor: const Color(0xFFFFE9DC),
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
        label: const Text(
          'Todas',
          style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
        ),
        selected: isAllSelected,
        selectedColor: const Color(0xFFFFE9DC),
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
          label: Text(
            category.name,
            style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
          ),
          selected: isSelected,
          selectedColor: const Color(0xFFFFE9DC),
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
              height: 40,
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 16),
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
