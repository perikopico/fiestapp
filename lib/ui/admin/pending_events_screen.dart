import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show debugPrint;
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:intl/intl.dart';
import 'package:fiestapp/services/admin_moderation_service.dart';
import '../../models/event.dart';
import 'admin_event_edit_screen.dart';

enum AdminEventFilter { pending, published }

class PendingEventsScreen extends StatefulWidget {
  const PendingEventsScreen({super.key});

  @override
  State<PendingEventsScreen> createState() => _PendingEventsScreenState();
}

class _PendingEventsScreenState extends State<PendingEventsScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  bool _isLoading = true;
  String? _error;
  List<Map<String, dynamic>> _pendingEvents = [];
  List<Map<String, dynamic>> _publishedEvents = [];
  final DateFormat _dateFormat = DateFormat('d MMM yyyy, HH:mm');
  AdminEventFilter _currentFilter = AdminEventFilter.pending;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _tabController.addListener(() {
      if (_tabController.indexIsChanging) {
        setState(() {
          _currentFilter = _tabController.index == 0
              ? AdminEventFilter.pending
              : AdminEventFilter.published;
        });
        _loadEvents();
      }
    });
    _loadEvents();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _loadEvents() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final supa = Supabase.instance.client;
      final now = DateTime.now();

      if (_currentFilter == AdminEventFilter.pending) {
        // Cargar eventos pendientes con información del venue
        final res = await supa
            .from('events_view')
            .select(
              'id, title, city_id, city_name, category_id, category_name, starts_at, image_url, maps_url, place, is_featured, is_free, category_icon, category_color, description, image_alignment, status, venue_id, venues(id, name, status, address)',
            )
            .eq('status', 'pending')
            .order('created_at', ascending: false);

        if (mounted) {
          setState(() {
            _pendingEvents = (res as List).cast<Map<String, dynamic>>();
            _isLoading = false;
          });
        }
      } else {
        // Cargar eventos publicados (vigentes) con información del venue
        final res = await supa
            .from('events_view')
            .select(
              'id, title, city_id, city_name, category_id, category_name, starts_at, image_url, maps_url, place, is_featured, is_free, category_icon, category_color, description, image_alignment, status, venue_id, venues(id, name, status, address)',
            )
            .eq('status', 'published')
            .gte('starts_at', now.toIso8601String())
            .order('starts_at', ascending: true);

        if (mounted) {
          setState(() {
            _publishedEvents = (res as List).cast<Map<String, dynamic>>();
            _isLoading = false;
          });
        }
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _error = e.toString();
          _isLoading = false;
        });
      }
    }
  }

  String? _getCityName(Map<String, dynamic> event) {
    try {
      // Primero intentar obtener city_name directamente (desde events_view)
      if (event['city_name'] != null) {
        return event['city_name'] as String?;
      }
      // Fallback: intentar obtener desde la relación cities (por compatibilidad)
      final cities = event['cities'] as Map<String, dynamic>?;
      return cities?['name'] as String?;
    } catch (e) {
      return null;
    }
  }

  Widget _buildVenueInfo(Map<String, dynamic> event) {
    try {
      final venues = event['venues'];
      if (venues == null) return const SizedBox.shrink();
      
      // Puede ser un Map o una List
      Map<String, dynamic>? venue;
      if (venues is Map) {
        venue = venues as Map<String, dynamic>?;
      } else if (venues is List && venues.isNotEmpty) {
        venue = venues.first as Map<String, dynamic>?;
      }
      
      if (venue == null) return const SizedBox.shrink();
      
      final venueName = venue['name'] as String? ?? 'Sin nombre';
      final venueStatus = venue['status'] as String? ?? 'pending';
      final venueAddress = venue['address'] as String?;
      
      Color statusColor;
      IconData statusIcon;
      String statusText;
      
      switch (venueStatus) {
        case 'approved':
          statusColor = Colors.green;
          statusIcon = Icons.check_circle;
          statusText = 'Aprobado';
          break;
        case 'rejected':
          statusColor = Colors.red;
          statusIcon = Icons.cancel;
          statusText = 'Rechazado';
          break;
        default:
          statusColor = Colors.orange;
          statusIcon = Icons.pending;
          statusText = 'Pendiente';
      }
      
      return Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: statusColor.withOpacity(0.1),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: statusColor.withOpacity(0.3),
            width: 1,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.place,
                  size: 14,
                  color: statusColor,
                ),
                const SizedBox(width: 4),
                Expanded(
                  child: Text(
                    venueName,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: statusColor,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Chip(
                  label: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(statusIcon, size: 12, color: statusColor),
                      const SizedBox(width: 4),
                      Text(
                        statusText,
                        style: TextStyle(
                          fontSize: 10,
                          color: statusColor,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                  padding: EdgeInsets.zero,
                  visualDensity: VisualDensity.compact,
                  backgroundColor: statusColor.withOpacity(0.1),
                  side: BorderSide(color: statusColor.withOpacity(0.3)),
                ),
              ],
            ),
            if (venueAddress != null && venueAddress.isNotEmpty) ...[
              const SizedBox(height: 4),
              Padding(
                padding: const EdgeInsets.only(left: 18),
                child: Text(
                  venueAddress,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    fontSize: 11,
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ],
        ),
      );
    } catch (e) {
      debugPrint('Error al construir info del venue: $e');
      return const SizedBox.shrink();
    }
  }

  @override
  Widget build(BuildContext context) {
    final currentEvents = _currentFilter == AdminEventFilter.pending
        ? _pendingEvents
        : _publishedEvents;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Panel de administración'),
        elevation: 0,
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'Pendientes'),
            Tab(text: 'Publicados'),
          ],
        ),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _error != null
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.error_outline,
                    size: 64,
                    color: Theme.of(context).colorScheme.error,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Error al cargar eventos',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 8),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 32),
                    child: Text(
                      _error!,
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: _loadEvents,
                    child: const Text('Reintentar'),
                  ),
                ],
              ),
            )
          : currentEvents.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    _currentFilter == AdminEventFilter.pending
                        ? Icons.event_busy
                        : Icons.event_available,
                    size: 64,
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    _currentFilter == AdminEventFilter.pending
                        ? 'No hay eventos pendientes'
                        : 'No hay eventos publicados',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            )
          : RefreshIndicator(
              onRefresh: _loadEvents,
              child: TabBarView(
                controller: _tabController,
                children: [
                  _buildEventsList(_pendingEvents, AdminEventFilter.pending),
                  _buildEventsList(_publishedEvents, AdminEventFilter.published),
                ],
              ),
            ),
    );
  }

  Widget _buildEventsList(
    List<Map<String, dynamic>> events,
    AdminEventFilter filter,
  ) {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: events.length,
      itemBuilder: (context, index) {
        final event = events[index];
        final title = event['title'] as String? ?? 'Sin título';
        final startsAtStr = event['starts_at'] as String?;
        final cityId = event['city_id'] as int?;
        final cityName = _getCityName(event);
        final cityDisplay =
            cityName ??
            (cityId != null ? 'Ciudad ID: $cityId' : 'Sin ciudad');

        DateTime? startsAt;
        if (startsAtStr != null) {
          try {
            startsAt = DateTime.parse(startsAtStr);
          } catch (e) {
            // Ignorar error de parsing
          }
        }

        // Convertir el Map a Event para poder navegar al detalle
        Event? eventObj;
        try {
          eventObj = Event.fromMap(event);
        } catch (e) {
          // Si falla la conversión, continuar sin navegación al detalle
          debugPrint('Error al convertir evento a Event: $e');
        }

        final isPublished = filter == AdminEventFilter.published;

        return Card(
          margin: const EdgeInsets.only(bottom: 12),
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
            side: BorderSide(
              color: Theme.of(context).colorScheme.outline.withOpacity(0.2),
            ),
          ),
          child: InkWell(
            onTap: eventObj != null
                ? () async {
                    final result = await Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => AdminEventEditScreen(
                          event: eventObj!,
                          isPublished: isPublished,
                        ),
                      ),
                    );
                    // Si se guardó, refrescar la lista
                    if (result == true) {
                      _loadEvents();
                    }
                  }
                : null,
            borderRadius: BorderRadius.circular(16),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              title,
                              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.w600,
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 8),
                            if (startsAt != null)
                              Row(
                                children: [
                                  Icon(
                                    Icons.calendar_today,
                                    size: 16,
                                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                                  ),
                                  const SizedBox(width: 4),
                                  Flexible(
                                    child: Text(
                                      _dateFormat.format(startsAt),
                                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                                      ),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ],
                              )
                            else
                              Text(
                                'Fecha no disponible',
                                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                                ),
                              ),
                            const SizedBox(height: 4),
                            Row(
                              children: [
                                Icon(
                                  Icons.location_on,
                                  size: 16,
                                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                                ),
                                const SizedBox(width: 4),
                                Flexible(
                                  child: Text(
                                    cityDisplay,
                                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            ),
                            // Mostrar información del lugar (venue)
                            if (event['venue_id'] != null) ...[
                              const SizedBox(height: 8),
                              _buildVenueInfo(event),
                            ] else if (event['place'] != null && (event['place'] as String).isNotEmpty) ...[
                              const SizedBox(height: 4),
                              Row(
                                children: [
                                  Icon(
                                    Icons.place,
                                    size: 14,
                                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                                  ),
                                  const SizedBox(width: 4),
                                  Flexible(
                                    child: Text(
                                      event['place'] as String,
                                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                                        fontStyle: FontStyle.italic,
                                      ),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ],
                        ),
                      ),
                      if (!isPublished) ...[
                        const SizedBox(width: 8),
                        Flexible(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              ElevatedButton.icon(
                                icon: const Icon(Icons.check, size: 18),
                                label: const Text('Aprobar'),
                                style: ElevatedButton.styleFrom(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 12,
                                    vertical: 8,
                                  ),
                                ),
                                onPressed: () async {
                                  final eventId = event['id'] as String?;
                                  if (eventId == null) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text('Error: ID de evento no encontrado'),
                                      ),
                                    );
                                    return;
                                  }

                                  try {
                                    await AdminModerationService.instance.approveEvent(eventId);

                                    if (!mounted) return;
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(content: Text('Evento aprobado')),
                                    );

                                    // Recargar la lista
                                    await _loadEvents();
                                  } catch (e) {
                                    if (!mounted) return;
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: const Text(
                                          'Error al aprobar el evento. Por favor, inténtalo de nuevo.',
                                        ),
                                        backgroundColor: Theme.of(context).colorScheme.error,
                                        duration: const Duration(seconds: 3),
                                      ),
                                    );
                                  }
                                },
                              ),
                              const SizedBox(height: 4),
                              ElevatedButton.icon(
                                icon: const Icon(Icons.close, size: 18),
                                label: const Text('Rechazar'),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Theme.of(context).colorScheme.error,
                                  foregroundColor: Theme.of(context).colorScheme.onError,
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 12,
                                    vertical: 8,
                                  ),
                                ),
                                onPressed: () async {
                                  final eventId = event['id'] as String?;
                                  if (eventId == null) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text('Error: ID de evento no encontrado'),
                                      ),
                                    );
                                    return;
                                  }

                                  try {
                                    await AdminModerationService.instance.rejectEvent(eventId);

                                    if (!mounted) return;
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(content: Text('Evento rechazado')),
                                    );

                                    await _loadEvents();
                                  } catch (e) {
                                    if (!mounted) return;
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: const Text(
                                          'Error al rechazar el evento. Por favor, inténtalo de nuevo.',
                                        ),
                                        backgroundColor: Theme.of(context).colorScheme.error,
                                        duration: const Duration(seconds: 3),
                                      ),
                                    );
                                  }
                                },
                              ),
                            ],
                          ),
                        ),
                      ] else ...[
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 8,
                          ),
                          decoration: BoxDecoration(
                            color: Theme.of(context).colorScheme.primaryContainer,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            'Publicado',
                            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: Theme.of(context).colorScheme.onPrimaryContainer,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
