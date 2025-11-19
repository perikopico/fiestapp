import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:intl/intl.dart';
import 'package:fiestapp/services/admin_moderation_service.dart';
import '../../models/event.dart';
import '../event/event_detail_screen.dart';

class PendingEventsScreen extends StatefulWidget {
  const PendingEventsScreen({super.key});

  @override
  State<PendingEventsScreen> createState() => _PendingEventsScreenState();
}

class _PendingEventsScreenState extends State<PendingEventsScreen> {
  bool _isLoading = true;
  String? _error;
  List<Map<String, dynamic>> _pendingEvents = [];
  final DateFormat _dateFormat = DateFormat('d MMM yyyy, HH:mm');

  @override
  void initState() {
    super.initState();
    _loadPendingEvents();
  }

  Future<void> _loadPendingEvents() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final supa = Supabase.instance.client;
      // Usar events_view para obtener todos los campos necesarios para Event
      final res = await supa
          .from('events_view')
          .select(
            'id, title, city_id, city_name, category_id, category_name, starts_at, image_url, maps_url, place, is_featured, is_free, category_icon, category_color, description, image_alignment',
          )
          .eq('status', 'pending')
          .order('created_at', ascending: false);

      if (mounted) {
        setState(() {
          _pendingEvents = (res as List).cast<Map<String, dynamic>>();
          _isLoading = false;
        });
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Eventos pendientes'), elevation: 0),
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
                    onPressed: _loadPendingEvents,
                    child: const Text('Reintentar'),
                  ),
                ],
              ),
            )
          : _pendingEvents.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.event_busy,
                    size: 64,
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'No hay eventos pendientes',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            )
          : RefreshIndicator(
              onRefresh: _loadPendingEvents,
              child: ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: _pendingEvents.length,
                itemBuilder: (context, index) {
                  final event = _pendingEvents[index];
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

                  return Card(
                    margin: const EdgeInsets.only(bottom: 12),
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                      side: BorderSide(
                        color: Theme.of(
                          context,
                        ).colorScheme.outline.withOpacity(0.2),
                      ),
                    ),
                    child: InkWell(
                      onTap: eventObj != null
                          ? () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (_) => EventDetailScreen(event: eventObj!),
                                ),
                              );
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
                                        style: Theme.of(context)
                                            .textTheme
                                            .titleMedium
                                            ?.copyWith(
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
                                              color: Theme.of(
                                                context,
                                              ).colorScheme.onSurfaceVariant,
                                            ),
                                            const SizedBox(width: 4),
                                            Flexible(
                                              child: Text(
                                                _dateFormat.format(startsAt),
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .bodyMedium
                                                    ?.copyWith(
                                                      color: Theme.of(context)
                                                          .colorScheme
                                                          .onSurfaceVariant,
                                                    ),
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                            ),
                                          ],
                                        )
                                      else
                                        Text(
                                          'Fecha no disponible',
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyMedium
                                              ?.copyWith(
                                                color: Theme.of(
                                                  context,
                                                ).colorScheme.onSurfaceVariant,
                                              ),
                                        ),
                                      const SizedBox(height: 4),
                                      Row(
                                        children: [
                                          Icon(
                                            Icons.location_on,
                                            size: 16,
                                            color: Theme.of(
                                              context,
                                            ).colorScheme.onSurfaceVariant,
                                          ),
                                          const SizedBox(width: 4),
                                          Flexible(
                                            child: Text(
                                              cityDisplay,
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .bodyMedium
                                                  ?.copyWith(
                                                    color: Theme.of(
                                                      context,
                                                    ).colorScheme.onSurfaceVariant,
                                                  ),
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
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
                                        ScaffoldMessenger.of(
                                          context,
                                        ).showSnackBar(
                                          const SnackBar(
                                            content: Text(
                                              'Error: ID de evento no encontrado',
                                            ),
                                          ),
                                        );
                                        return;
                                      }

                                      try {
                                        await AdminModerationService.instance
                                            .approveEvent(eventId);

                                        if (!mounted) return;
                                        ScaffoldMessenger.of(
                                          context,
                                        ).showSnackBar(
                                          const SnackBar(
                                            content: Text('Evento aprobado'),
                                          ),
                                        );

                                        // Recargar la lista de pendientes
                                        await _loadPendingEvents();
                                      } catch (e) {
                                        if (!mounted) return;
                                        ScaffoldMessenger.of(
                                          context,
                                        ).showSnackBar(
                                          SnackBar(
                                            content: const Text(
                                              'Error al aprobar el evento. Por favor, inténtalo de nuevo.',
                                            ),
                                            backgroundColor: Theme.of(
                                              context,
                                            ).colorScheme.error,
                                            duration: const Duration(
                                              seconds: 3,
                                            ),
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
                                        backgroundColor: Theme.of(
                                          context,
                                        ).colorScheme.error,
                                        foregroundColor: Theme.of(
                                          context,
                                        ).colorScheme.onError,
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 12,
                                          vertical: 8,
                                        ),
                                      ),
                                      onPressed: () async {
                                      final eventId = event['id'] as String?;
                                      if (eventId == null) {
                                        ScaffoldMessenger.of(
                                          context,
                                        ).showSnackBar(
                                          const SnackBar(
                                            content: Text(
                                              'Error: ID de evento no encontrado',
                                            ),
                                          ),
                                        );
                                        return;
                                      }

                                      try {
                                        await AdminModerationService.instance
                                            .rejectEvent(eventId);

                                        if (!mounted) return;
                                        ScaffoldMessenger.of(
                                          context,
                                        ).showSnackBar(
                                          const SnackBar(
                                            content: Text('Evento rechazado'),
                                          ),
                                        );

                                        await _loadPendingEvents();
                                      } catch (e) {
                                        if (!mounted) return;
                                        ScaffoldMessenger.of(
                                          context,
                                        ).showSnackBar(
                                          SnackBar(
                                            content: const Text(
                                              'Error al rechazar el evento. Por favor, inténtalo de nuevo.',
                                            ),
                                            backgroundColor: Theme.of(
                                              context,
                                            ).colorScheme.error,
                                            duration: const Duration(
                                              seconds: 3,
                                            ),
                                          ),
                                        );
                                      }
                                    },
                                    ),
                                  ],
                                ),
                              ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
    );
  }
}
