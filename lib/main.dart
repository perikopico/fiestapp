import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';

void main() => runApp(const Fiestapp());

/* ================== MODELOS ================== */
class City {
  final String id, name;
  const City(this.id, this.name);
}

class EventItem {
  final String id, title, cityId, category, place;
  final DateTime start, end;
  final bool isFree;
  final String? imageUrl;
  const EventItem({
    required this.id,
    required this.title,
    required this.cityId,
    required this.category,
    required this.place,
    required this.start,
    required this.end,
    required this.isFree,
    this.imageUrl,
  });
}

/* ================== DATOS MOCK ================== */
const cities = <City>[
  City('barbate', 'Barbate'),
  City('zahara', 'Zahara'),
  City('vejer', 'Vejer'),
];

final now = DateTime.now();

DateTime _nextWeekendDay(DateTime base, int weekday) {
  int diff = (weekday - base.weekday) % 7;
  if (diff <= 0) diff += 7;
  return DateTime(base.year, base.month, base.day).add(Duration(days: diff));
}

final mock = <EventItem>[
  EventItem(
    id: '1',
    title: 'Zambomba en la Peña Flamenca',
    cityId: 'barbate',
    category: 'Tradición',
    place: 'Plaza del Abasto, Barbate',
    start: DateTime(now.year, now.month, now.day, 21, 30),
    end: DateTime(now.year, now.month, now.day, 23, 30),
    isFree: true,
    imageUrl:
    'https://images.unsplash.com/photo-1519681393784-d120267933ba?q=80&w=1200&auto=format&fit=crop',
  ),
  EventItem(
    id: '2',
    title: 'Concentración de deportivos',
    cityId: 'vejer',
    category: 'Motor',
    place: 'Plaza de España, Medina/Vejer',
    start: _nextWeekendDay(now, DateTime.saturday).add(const Duration(hours: 10)),
    end: _nextWeekendDay(now, DateTime.saturday).add(const Duration(hours: 18)),
    isFree: true,
    imageUrl:
    'https://images.unsplash.com/photo-1483721310020-03333e577078?q=80&w=1200&auto=format&fit=crop',
  ),
  EventItem(
    id: '3',
    title: 'Mercado artesanal',
    cityId: 'zahara',
    category: 'Mercados',
    place: 'Paseo marítimo, Zahara',
    start: _nextWeekendDay(now, DateTime.sunday).add(const Duration(hours: 11)),
    end: _nextWeekendDay(now, DateTime.sunday).add(const Duration(hours: 15)),
    isFree: true,
    imageUrl:
    'https://images.unsplash.com/photo-1565011691358-7f4e6c2b0b59?q=80&w=1200&auto=format&fit=crop',
  ),
];

/* ================== APP ================== */
class Fiestapp extends StatelessWidget {
  const Fiestapp({super.key});

  @override
  Widget build(BuildContext context) {
    final router = GoRouter(
      routes: [
        GoRoute(
          path: '/',
          builder: (_, __) => const HomeScreen(),
          routes: [
            GoRoute(
              path: 'event/:id',
              builder: (_, state) {
                final id = state.pathParameters['id']!;
                final e = mock.firstWhere((x) => x.id == id);
                return EventDetail(event: e);
              },
            ),
          ],
        ),
      ],
    );

    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      title: 'Fiestapp',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF005A8D),
          brightness: Brightness.light,
        ),
        scaffoldBackgroundColor: Colors.white,
        useMaterial3: true,
      ),
      routerConfig: router,
    );
  }
}

/* ================== HOME ================== */
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String city = cities.first.id;

  // categorías para filtrar
  final List<String> categories = const ['Todo', 'Tradición', 'Motor', 'Mercados'];
  String selectedCategory = 'Todo';

  @override
  Widget build(BuildContext context) {
    final today0 = DateTime(now.year, now.month, now.day);
    final today1 = today0.add(const Duration(days: 1));
    final weekendStart = _nextWeekendDay(now, DateTime.saturday);
    final weekendEnd = _nextWeekendDay(now, DateTime.monday);
    final dfTime = DateFormat('HH:mm');

    List<EventItem> filter(Iterable<EventItem> src) {
      final byCity = src.where((e) => e.cityId == city);
      if (selectedCategory != 'Todo') {
        return byCity.where((e) => e.category == selectedCategory).toList();
      }
      return byCity.toList();
    }

    final todayItems = filter(mock.where((e) => e.start.isAfter(today0) && e.start.isBefore(today1)));
    final weekendItems = filter(mock.where((e) => e.start.isAfter(weekendStart) && e.start.isBefore(weekendEnd)));
    final nextDays = filter(mock.where((e) => e.start.isAfter(today1))).toList()
      ..sort((a, b) => a.start.compareTo(b.start));

    return Scaffold(
      appBar: AppBar(
        title: const Text('Qué hay hoy'),
        actions: [IconButton(onPressed: () {}, icon: const Icon(Icons.notifications_none))],
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
        children: [
          // selector de ciudad
          SizedBox(
            height: 44,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: cities.length,
              separatorBuilder: (_, __) => const SizedBox(width: 8),
              itemBuilder: (_, i) {
                final c = cities[i];
                return ChoiceChip(
                  label: Text(c.name),
                  selected: city == c.id,
                  onSelected: (_) => setState(() => city = c.id),
                );
              },
            ),
          ),
          const SizedBox(height: 10),

          // selector de categorías
          SizedBox(
            height: 40,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: categories.length,
              separatorBuilder: (_, __) => const SizedBox(width: 8),
              itemBuilder: (_, i) {
                final c = categories[i];
                return ChoiceChip(
                  label: Text(c),
                  selected: selectedCategory == c,
                  onSelected: (_) => setState(() => selectedCategory = c),
                );
              },
            ),
          ),

          const SizedBox(height: 16),
          _Section(title: 'HOY', items: todayItems, dfTime: dfTime),
          const SizedBox(height: 16),
          _Section(title: 'ESTE FIN DE SEMANA', items: weekendItems, dfTime: dfTime),
          const SizedBox(height: 16),

          Text('PRÓXIMOS DÍAS', style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 8),
          ...nextDays.map((e) => Card(
            elevation: 0,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
            color: Colors.white,
            child: ListTile(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
              title: Text(e.title, style: const TextStyle(fontWeight: FontWeight.w600)),
              subtitle: Text(
                '${DateFormat('EEE d MMM', 'es_ES').format(e.start)} · ${dfTime.format(e.start)} • ${e.place}',
              ),
              trailing: const Icon(Icons.chevron_right),
              onTap: () => context.go('/event/${e.id}'),
            ),
          )),
        ],
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: 0,
        destinations: const [
          NavigationDestination(icon: Icon(Icons.home_outlined), label: 'Inicio'),
          NavigationDestination(icon: Icon(Icons.map_outlined), label: 'Mapa'),
          NavigationDestination(icon: Icon(Icons.settings_outlined), label: 'Ajustes'),
        ],
      ),
    );
  }
}

/* ================== SECCIÓN HORIZONTAL ================== */
class _Section extends StatelessWidget {
  final String title;
  final List<EventItem> items;
  final DateFormat dfTime;
  const _Section({required this.title, required this.items, required this.dfTime});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: Theme.of(context).textTheme.titleLarge),
        const SizedBox(height: 8),
        SizedBox(
          height: 240,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: items.length,
            separatorBuilder: (_, __) => const SizedBox(width: 12),
            itemBuilder: (_, i) {
              final e = items[i];
              return GestureDetector(
                onTap: () => GoRouter.of(context).go('/event/${e.id}'),
                child: Container(
                  width: 200,
                  decoration: const BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                        blurRadius: 12,
                        spreadRadius: 0,
                        offset: Offset(0, 3),
                        color: Colors.black12,
                      )
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(18),
                    child: Stack(
                      fit: StackFit.expand,
                      children: [
                        Image.network(
                          e.imageUrl ?? '',
                          fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) => Container(color: Colors.black12),
                        ),
                        Container(
                          decoration: const BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [Colors.transparent, Colors.black54],
                            ),
                          ),
                        ),
                        Positioned(
                          left: 10,
                          right: 10,
                          bottom: 12,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                e.title,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                '${dfTime.format(e.start)}  •  ${e.cityId}',
                                style: const TextStyle(
                                  color: Colors.white70,
                                  fontSize: 13,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}

/* ================== DETALLE ================== */
class EventDetail extends StatelessWidget {
  final EventItem event;
  const EventDetail({super.key, required this.event});

  Future<void> _openMaps(String place) async {
    final q = Uri.encodeComponent(place);
    final url = Uri.parse('https://www.google.com/maps/search/?api=1&query=$q');
    await launchUrl(url, mode: LaunchMode.externalApplication);
  }

  @override
  Widget build(BuildContext context) {
    final df1 = DateFormat('EEE, d MMM', 'es_ES');
    final df2 = DateFormat('HH:mm');

    return Scaffold(
      appBar: AppBar(title: Text(event.title)),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 32),
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: AspectRatio(
              aspectRatio: 16 / 9,
              child: event.imageUrl == null
                  ? Container(color: Colors.black12)
                  : Image.network(event.imageUrl!, fit: BoxFit.cover),
            ),
          ),
          const SizedBox(height: 16),
          Row(children: [
            const Icon(Icons.event_outlined),
            const SizedBox(width: 8),
            Text('${df1.format(event.start)} · ${df2.format(event.start)}–${df2.format(event.end)}'),
          ]),
          const SizedBox(height: 8),
          Row(children: [
            const Icon(Icons.place_outlined),
            const SizedBox(width: 8),
            Expanded(child: Text(event.place)),
          ]),
          const SizedBox(height: 16),
          Wrap(spacing: 8, children: [
            Chip(label: Text(event.category)),
            Chip(label: Text(event.cityId)),
            Chip(label: Text(event.isFree ? 'Gratis' : 'De pago')),
          ]),
          const SizedBox(height: 16),
          Row(children: [
            Expanded(child: FilledButton.tonal(onPressed: () => _openMaps(event.place), child: const Text('Cómo llegar'))),
            const SizedBox(width: 12),
            Expanded(child: FilledButton.tonal(onPressed: () {}, child: const Text('Añadir al calendario'))),
          ]),
          const SizedBox(height: 8),
          OutlinedButton.icon(onPressed: () {}, icon: const Icon(Icons.share_outlined), label: const Text('Compartir')),
        ],
      ),
    );
  }
}
