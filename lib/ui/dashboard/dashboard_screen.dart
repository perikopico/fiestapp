import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' hide Category;
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:fiestapp/services/event_service.dart';
import '../../services/category_service.dart';
import '../../models/event.dart';
import '../../models/category.dart' as model;
import 'widgets/hero_banner.dart';
import 'widgets/upcoming_list.dart';
import 'widgets/categories_grid.dart';
import 'widgets/popular_carousel.dart';
import '../icons/icon_mapper.dart';

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

  Event? _featuredEvent;
  List<Event> _upcomingEvents = [];
  List<Event> _featuredEvents = [];
  List<model.Category> _categories = [];
  bool _isLoading = true;
  String? _error;
  int? _selectedCategoryId;
  int? _selectedCityId;
  List<City> _cities = [];

  @override
  void initState() {
    super.initState();
    _reloadEvents();
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
        _categories = results[2] as List<model.Category>;
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


  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Scaffold(
        appBar: AppBar(title: const Text('Fiestapp')),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    if (_error != null) {
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
            // Próximos eventos
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
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
                child: PopularThisWeekSection(
                  events: _featuredEvents,
                  onClearFilters: _clearFilters,
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
  final List<model.Category> categories;
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
  final List<model.Category> categories;
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

    // Chips de ciudades
    for (final city in cities) {
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
    for (final category in categories.where((model.Category c) => c.id != null)) {
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
