import 'package:flutter/material.dart';
import '../../models/event.dart';
import '../../services/favorites_local_service.dart';
import '../../services/event_service.dart';
import '../common/app_bar_logo.dart';
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
    final theme = Theme.of(context);
    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        title: const AppBarLogo(),
        centerTitle: true,
        elevation: 0,
        backgroundColor: theme.scaffoldBackgroundColor,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(48),
          child: Material(
            color: theme.scaffoldBackgroundColor,
            child: TabBar(
              controller: _tabController,
              labelColor: theme.colorScheme.primary,
              unselectedLabelColor: theme.colorScheme.onSurfaceVariant,
              indicatorColor: theme.colorScheme.primary,
              indicatorWeight: 3,
              tabs: const [
                Tab(text: 'Próximos'),
                Tab(text: 'Pasados'),
              ],
            ),
          ),
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
      return _buildEmptyState(
        context,
        icon: Icons.favorite_border,
        message: 'Todavía no tienes eventos en favoritos',
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
      return _buildEmptyState(
        context,
        icon: Icons.event_available,
        message: 'No tienes eventos favoritos próximos',
      );
    }

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 100),
      child: UpcomingList(events: upcoming, scrollable: true),
    );
  }

  Widget _buildEmptyState(BuildContext context, {required IconData icon, required String message}) {
    final theme = Theme.of(context);
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: theme.colorScheme.primaryContainer.withOpacity(0.3),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Icon(
                icon,
                size: 56,
                color: theme.colorScheme.primary,
              ),
            ),
            const SizedBox(height: 24),
            Text(
              message,
              style: theme.textTheme.titleMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
                height: 1.4,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPastTab() {
    final past = _pastEvents;

    if (past.isEmpty) {
      return _buildEmptyState(
        context,
        icon: Icons.history,
        message: 'Aún no tienes eventos favoritos que hayan pasado.',
      );
    }

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 100),
      child: UpcomingList(events: past, scrollable: true),
    );
  }
}

