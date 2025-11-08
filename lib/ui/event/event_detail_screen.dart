import 'package:flutter/material.dart';

import 'package:url_launcher/url_launcher.dart';
import 'package:share_plus/share_plus.dart';
import 'package:add_2_calendar/add_2_calendar.dart' as add2cal;

import '../../models/event.dart';
import '../icons/icon_mapper.dart';

class EventDetailScreen extends StatelessWidget {
  final Event event;

  const EventDetailScreen({super.key, required this.event});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      backgroundColor: const Color(0xFFFBF5EF),
      appBar: AppBar(
        title: const Text('Detalle del evento'),
        centerTitle: true,
        elevation: 0,
        backgroundColor: const Color(0xFFF2E6DB),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 32),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Imagen principal (con fallback)
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(18),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(18),
                child: Hero(
                  tag: 'event-img-${event.id}',
                  child: event.imageUrl != null && event.imageUrl!.isNotEmpty
                      ? Image.network(event.imageUrl!, height: 240, width: double.infinity, fit: BoxFit.cover)
                      : Container(
                          height: 240,
                          width: double.infinity,
                          color: Colors.black12,
                          alignment: Alignment.center,
                          child: const Icon(Icons.event, size: 56),
                        ),
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Título
            Text(event.title, style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w800)),
            const SizedBox(height: 8),

            // Chips de meta
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                if (event.cityName != null)
                  Chip(
                    label: Text(event.cityName!, style: theme.textTheme.bodySmall),
                    avatar: const Icon(Icons.place, size: 18),
                    backgroundColor: Theme.of(context).colorScheme.surfaceVariant,
                    visualDensity: VisualDensity.compact,
                  ),
                if (event.categoryName != null)
                  Chip(
                    label: Text(event.categoryName!, style: theme.textTheme.bodySmall),
                    avatar: Icon(
                      iconFromName(event.categoryIcon),
                      size: 18,
                    ),
                    backgroundColor: Theme.of(context).colorScheme.surfaceVariant,
                    visualDensity: VisualDensity.compact,
                  ),
                Chip(
                  label: Text(event.formattedDate, style: theme.textTheme.bodySmall),
                  avatar: const Icon(Icons.event, size: 18),
                  backgroundColor: Theme.of(context).colorScheme.surfaceVariant,
                  visualDensity: VisualDensity.compact,
                ),
                Chip(
                  label: Text(event.formattedTime, style: theme.textTheme.bodySmall),
                  avatar: const Icon(Icons.schedule, size: 18),
                  backgroundColor: Theme.of(context).colorScheme.surfaceVariant,
                  visualDensity: VisualDensity.compact,
                ),
                if (event.isFree == true)
                  Chip(
                    label: const Text('Gratis', style: TextStyle(fontSize: 12)),
                    avatar: const Icon(Icons.check_circle, size: 18),
                    backgroundColor: const Color(0xFFDFF5DD),
                    visualDensity: VisualDensity.compact,
                  ),
              ],
            ),
            const SizedBox(height: 16),

            // Descripción
            if (event.description != null && event.description!.isNotEmpty) ...[
              Text('Descripción', style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600)),
              const SizedBox(height: 6),
              Text(
                event.description!,
                style: theme.textTheme.bodyMedium?.copyWith(
                  height: 1.4,
                ),
              ),
              const SizedBox(height: 16),
            ],

            // Lugar
            if (event.place != null && event.place!.isNotEmpty) ...[
              Text('Lugar', style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600)),
              const SizedBox(height: 6),
              Text(event.place!, style: theme.textTheme.bodyMedium),
              const SizedBox(height: 16),
            ],

            // Botones de acción
            Row(
              children: [
                Expanded(
                  child: SizedBox(
                    height: 44,
                    child: FilledButton.icon(
                      onPressed: () async {
                        final url = event.mapsUrl ?? '';
                        if (url.isEmpty) return;
                        final uri = Uri.parse(url);
                        if (await canLaunchUrl(uri)) {
                          await launchUrl(uri, mode: LaunchMode.externalApplication);
                        }
                      },
                      icon: const Icon(Icons.map),
                      label: const Text('Ver en mapa'),
                      style: FilledButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: SizedBox(
                    height: 44,
                    child: OutlinedButton.icon(
                      onPressed: () {
                        final parts = <String>[
                          event.title,
                          if (event.place != null && event.place!.isNotEmpty) 'Lugar: ${event.place!}',
                          if (event.cityName != null) 'Ciudad: ${event.cityName!}',
                          '${event.formattedDate} ${event.formattedTime}',
                          if (event.mapsUrl != null && event.mapsUrl!.isNotEmpty) 'Mapa: ${event.mapsUrl}',
                        ];
                        Share.share(parts.where((s) => s.trim().isNotEmpty).join('\n'));
                      },
                      icon: const Icon(Icons.ios_share),
                      label: const Text('Compartir'),
                      style: OutlinedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            // Botón añadir al calendario
            SizedBox(
              width: double.infinity,
              child: TextButton.icon(
                onPressed: () async {
                  final location = [
                    event.place,
                    event.cityName,
                  ].where((s) => s != null && s!.isNotEmpty).join(' · ');
                  
                  final calEvent = add2cal.Event(
                    title: event.title,
                    description: event.description ?? '',
                    location: location,
                    startDate: event.startsAt,
                    endDate: event.startsAt.add(const Duration(hours: 2)),
                  );
                  
                  await add2cal.Add2Calendar.addEvent2Cal(calEvent);
                },
                icon: const Icon(Icons.calendar_today),
                label: const Text('Añadir al calendario'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

