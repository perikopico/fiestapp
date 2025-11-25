import 'package:flutter/material.dart';
import '../../models/event.dart';
import '../../services/favorites_local_service.dart';
import '../../services/event_service.dart';
import '../dashboard/widgets/upcoming_list.dart';
import '../dashboard/widgets/bottom_nav_bar.dart';

class FavoritesScreen extends StatefulWidget {
  const FavoritesScreen({super.key});

  @override
  State<FavoritesScreen> createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends State<FavoritesScreen>
    with SingleTickerProviderStateMixin {
  bool _loading = true;
  List<Event> _allEvents = [];
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _load();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _load() async {
    setState(() => _loading = true);
    try {
      final ids = await FavoritesLocalService.instance.getFavoriteIds();
      final events = await EventService.instance.fetchEventsByIds(ids.toList());
      if (mounted) {
        setState(() {
          _allEvents = events;
          _loading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _allEvents = [];
          _loading = false;
        });
      }
    }
  }

  List<Event> get _upcomingEvents {
    return _allEvents
        .where((e) => !e.isPast)
        .toList()
      ..sort((a, b) => a.startsAt.compareTo(b.startsAt));
  }

  List<Event> get _pastEvents {
    return _allEvents
        .where((e) => e.isPast)
        .toList()
      ..sort((a, b) => b.startsAt.compareTo(a.startsAt));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Favoritos'),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'Próximos'),
            Tab(text: 'Pasados'),
          ],
        ),
      ),
      body: _buildBody(context),
      bottomNavigationBar: const BottomNavBar(activeRoute: 'favorites'),
    );
  }

  Widget _buildBody(BuildContext context) {
    if (_loading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_allEvents.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.favorite_border,
              size: 64,
              color: Theme.of(context).colorScheme.onSurfaceVariant.withOpacity(0.5),
            ),
            const SizedBox(height: 16),
            Text(
              'Todavía no tienes eventos en favoritos',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: _load,
      child: TabBarView(
        controller: _tabController,
        children: [
          _buildUpcomingTab(),
          _buildPastTab(),
        ],
      ),
    );
  }

  Widget _buildUpcomingTab() {
    final upcoming = _upcomingEvents;

    if (upcoming.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.event_available,
              size: 64,
              color: Theme.of(context).colorScheme.onSurfaceVariant.withOpacity(0.5),
            ),
            const SizedBox(height: 16),
            Text(
              'No tienes eventos favoritos próximos',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.fromLTRB(8, 4, 8, 16),
      child: UpcomingList(events: upcoming),
    );
  }

  Widget _buildPastTab() {
    final past = _pastEvents;

    if (past.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.history,
              size: 64,
              color: Theme.of(context).colorScheme.onSurfaceVariant.withOpacity(0.5),
            ),
            const SizedBox(height: 16),
            Text(
              'Aún no tienes eventos favoritos que hayan pasado.',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.fromLTRB(8, 4, 8, 16),
      child: UpcomingList(events: past),
    );
  }
}

