import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:fiestapp/services/event_service.dart';
import '../../services/category_service.dart';
import '../../models/event.dart';
import '../../models/category.dart';
import 'widgets/hero_banner.dart';
import 'widgets/upcoming_list.dart';
import 'widgets/categories_grid.dart';
import 'widgets/popular_carousel.dart';

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
  List<Category> _categories = [];
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
        _categories = results[2] as List<Category>;
        _cities = results[3] as List<City>;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _error = e.toString();
        _isLoading = false;
      });
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
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // === HERO destacado ===
                DashboardHero(featured: _featuredEvent),

                const SizedBox(height: 16),

                // === Filtro de ciudades ===
                CitiesSection(
                  cities: _cities,
                  selectedCityId: _selectedCityId,
                  onCityTap: (cityId) {
                    setState(() {
                      _selectedCityId = cityId;
                    });
                  },
                ),

                const SizedBox(height: 16),

                // === Próximos eventos ===
                UpcomingEventsSection(
                  events: _upcomingEvents,
                  selectedCategoryId: _selectedCategoryId,
                  selectedCityId: _selectedCityId,
                  categories: _categories,
                  onClearCategoryFilter: () {
                    setState(() {
                      _selectedCategoryId = null;
                    });
                  },
                ),

                const SizedBox(height: 24),

                // === Categorías ===
                CategoriesSection(
                  categories: _categories,
                  selectedCategoryId: _selectedCategoryId,
                  onCategoryTap: (categoryId) {
                    setState(() {
                      _selectedCategoryId = _selectedCategoryId == categoryId ? null : categoryId;
                    });
                  },
                ),

                const SizedBox(height: 24),

                // === Destacados ===
                PopularThisWeekSection(events: _featuredEvents),
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
    return HeroBanner(featured: featured);
  }
}

class UpcomingEventsSection extends StatelessWidget {
  final List<Event> events;
  final int? selectedCategoryId;
  final int? selectedCityId;
  final List<Category> categories;
  final VoidCallback onClearCategoryFilter;

  const UpcomingEventsSection({
    super.key,
    required this.events,
    this.selectedCategoryId,
    this.selectedCityId,
    required this.categories,
    required this.onClearCategoryFilter,
  });

  @override
  Widget build(BuildContext context) {
    // Aplicar filtros combinados: ciudad y categoría
    final filtered = events.where((e) {
      final okCat = selectedCategoryId == null || e.categoryId == selectedCategoryId;
      final okCity = selectedCityId == null || e.cityId == selectedCityId;
      return okCat && okCity;
    }).toList();

    // Buscar la categoría seleccionada para mostrar el chip
    Category? selectedCategory;
    if (selectedCategoryId != null) {
      selectedCategory = categories.firstWhere(
        (c) => c.id == selectedCategoryId,
        orElse: () => Category(name: '', id: null),
      );
      if (selectedCategory.id == null) {
        selectedCategory = null;
      }
    }

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.7),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (selectedCategory != null)
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
              child: Row(
                children: [
                  Chip(
                    label: Text(selectedCategory.name),
                    onDeleted: onClearCategoryFilter,
                    deleteIcon: const Icon(Icons.close, size: 18),
                  ),
                ],
              ),
            ),
          UpcomingList(events: filtered),
        ],
      ),
    );
  }
}

class CitiesSection extends StatelessWidget {
  final List<City> cities;
  final int? selectedCityId;
  final ValueChanged<int?> onCityTap;

  const CitiesSection({
    super.key,
    required this.cities,
    this.selectedCityId,
    required this.onCityTap,
  });

  @override
  Widget build(BuildContext context) {
    if (cities.isEmpty) {
      return const SizedBox.shrink();
    }

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          // Chip "Todas"
          Padding(
            padding: const EdgeInsets.only(right: 8),
            child: ChoiceChip(
              label: const Text('Todas'),
              selected: selectedCityId == null,
              onSelected: (selected) {
                if (selected) {
                  onCityTap(null);
                }
              },
            ),
          ),
          // Chips de ciudades
          ...cities.map((city) {
            final isSelected = city.id == selectedCityId;
            return Padding(
              padding: const EdgeInsets.only(right: 8),
              child: ChoiceChip(
                label: Text(city.name),
                selected: isSelected,
                onSelected: (selected) {
                  if (selected) {
                    onCityTap(city.id);
                  }
                },
              ),
            );
          }).toList(),
        ],
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

  const PopularThisWeekSection({super.key, required this.events});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.7),
        borderRadius: BorderRadius.circular(16),
      ),
      child: PopularCarousel(events: events),
    );
  }
}
