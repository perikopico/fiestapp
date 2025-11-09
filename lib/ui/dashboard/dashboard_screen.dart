import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' hide Category;
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:fiestapp/services/event_service.dart';
import 'package:fiestapp/data/events_repository.dart';
import 'package:fiestapp/models/event.dart' as model;
import '../../services/category_service.dart';
import '../../models/event.dart';
import '../../models/category.dart';
import 'widgets/hero_banner.dart';
import 'widgets/upcoming_list.dart';
import 'widgets/categories_grid.dart';
import 'widgets/popular_carousel.dart';
import '../icons/icon_mapper.dart';
import 'package:fiestapp/ui/common/shimmer_widgets.dart';

// Clase simple para ciudades
class City {
  final int id;
  final String name;
  final String? slug;

  City({
    required this.id,
    required this.name,
    this.slug,
  });
}

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  final EventService _eventService = EventService();
  final CategoryService _categoryService = CategoryService();
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
  
  // Nearby events state
  double _radiusKm = 25;
  double? _userLat = 36.1927; // Barbate (temporal)
  double? _userLng = -5.9219; // Barbate (temporal)
  bool _isNearbyLoading = false;
  List<model.Event> _nearbyEvents = [];

  @override
  void initState() {
    super.initState();
    _reloadEvents().then((_) => _loadNearby());
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
        _fetchCities(),
      ]);

      setState(() {
        final upcoming = results[0] as List<Event>;
        final featured = results[1] as List<Event>;
        _upcomingEvents = upcoming;
        _featuredEvents = featured;
        _featuredEvent = featured.isNotEmpty ? featured.first : null;
        _categories = results[2] as List<Category>;
        _cities = results[3] as List<City>;
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

  Future<List<City>> _fetchCities() async {
    try {
      final rows = await Supabase.instance.client
          .from('cities')
          .select('id, name, slug')
          .order('name', ascending: true);

      return (rows as List)
          .map((e) => City(
                id: (e['id'] as num).toInt(),
                name: e['name'] as String,
                slug: e['slug'] as String?,
              ))
          .toList();
    } catch (e) {
      // Si falla, retornar lista vacía
      return [];
    }
  }

  void _clearFilters() {
    setState(() {
      _selectedCategoryId = null;
      _selectedCityId = null;
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
        child: CustomScrollView(
          physics: defaultTargetPlatform == TargetPlatform.iOS
              ? const BouncingScrollPhysics()
              : const ClampingScrollPhysics(),
          slivers: [
            SliverToBoxAdapter(
              child: SafeArea(
                bottom: false,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
                  child: DashboardHero(featured: _featuredEvent),
                ),
              ),
            ),
            if (!_isLoading)
              SliverPersistentHeader(
                pinned: true,
                delegate: _FilterHeaderDelegate(
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
                ),
              ),
            if (!_isLoading)
              SliverPersistentHeader(
                pinned: true,
                delegate: _NearbyControlHeaderDelegate(
                  radiusKm: _radiusKm,
                  onRadiusChanged: (value) {
                    setState(() {
                      _radiusKm = value;
                    });
                    if (_userLat != null && _userLng != null) {
                      _loadNearby();
                    }
                  },
                  onUseLocation: _getUserLocation,
                ),
              ),
            // Próximos eventos
            if (_isLoading)
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
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
                ),
              )
            else
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
                  child: UpcomingEventsSection(
                    events: _upcomingEvents,
                    selectedCategoryId: _selectedCategoryId,
                    selectedCityId: _selectedCityId,
                    onClearFilters: _clearFilters,
                  ),
                ),
              ),
            // Popular esta semana
            if (_isLoading)
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
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
                ),
              )
            else
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
                  child: PopularThisWeekSection(
                    events: _featuredEvents,
                    onClearFilters: _clearFilters,
                  ),
                ),
              ),
            // Cerca de ti
            if (_isNearbyLoading)
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
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
                ),
              )
            else
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
                  child: NearbyEventsSection(
                    events: _nearbyEvents,
                  ),
                ),
              ),
            const SliverToBoxAdapter(child: SizedBox(height: 24)),
          ],
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
    return HeroBanner(featured: featured);
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
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
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

// Delegate para SliverPersistentHeader de filtros
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
        label: Text('Todas', style: theme.textTheme.bodySmall),
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
          label: Text(city.name, style: theme.textTheme.bodySmall),
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
        label: Text('Todas', style: theme.textTheme.bodySmall),
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
          label: Text(category.name, style: theme.textTheme.bodySmall),
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
