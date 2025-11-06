import 'package:flutter/material.dart';
import '../../services/event_service.dart';
import '../../services/category_service.dart';
import '../../models/event.dart';
import '../../models/category.dart';
import 'widgets/hero_banner.dart';
import 'widgets/upcoming_list.dart';
import 'widgets/categories_grid.dart';
import 'widgets/popular_carousel.dart';

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
  List<Event> _popularEvents = [];
  List<Category> _categories = [];
  bool _isLoading = true;
  String? _error;

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
        _eventService.fetchFeatured(limit: 1),
        _eventService.fetchUpcoming(limit: 10),
        _eventService.fetchPopularWeek(limit: 10),
        _categoryService.fetchAll(),
      ]);

      setState(() {
        final featured = results[0] as List<Event>;
        _featuredEvent = featured.isNotEmpty ? featured.first : null;
        _upcomingEvents = results[1] as List<Event>;
        _popularEvents = results[2] as List<Event>;
        _categories = results[3] as List<Category>;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _error = e.toString();
        _isLoading = false;
      });
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
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Colors.grey[600],
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
      ),
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

                // === Próximos eventos ===
                UpcomingEventsSection(events: _upcomingEvents),

                const SizedBox(height: 24),

                // === Categorías ===
                CategoriesSection(categories: _categories),

                const SizedBox(height: 24),

                // === Popular esta semana ===
                PopularThisWeekSection(events: _popularEvents),
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

  const UpcomingEventsSection({super.key, required this.events});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.7),
        borderRadius: BorderRadius.circular(16),
      ),
      child: UpcomingList(events: events),
    );
  }
}

class CategoriesSection extends StatelessWidget {
  final List<Category> categories;

  const CategoriesSection({super.key, required this.categories});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.7),
        borderRadius: BorderRadius.circular(16),
      ),
      child: CategoriesGrid(categories: categories),
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

