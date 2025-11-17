import 'package:flutter/material.dart';

import 'package:url_launcher/url_launcher.dart';
import 'package:share_plus/share_plus.dart';
import 'package:add_2_calendar/add_2_calendar.dart' as add2cal;

import '../../models/event.dart';
import '../icons/icon_mapper.dart';
import '../common/theme_mode_toggle.dart';

class EventDetailScreen extends StatelessWidget {
  final Event event;

  const EventDetailScreen({super.key, required this.event});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final hasMapsUrl = event.mapsUrl != null && event.mapsUrl!.isNotEmpty;
    final shareText = [
      '${event.title} - ${event.cityName ?? ''}'.trim(),
      (event.place ?? '').trim(),
      '${event.formattedDate} ${event.formattedTime}'.trim(),
      (event.mapsUrl ?? '').trim(),
    ].where((s) => s.isNotEmpty).join('\n');

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        title: const Text('Detalle del evento'),
        centerTitle: true,
        elevation: 0,
        backgroundColor: theme.colorScheme.surface,
        actions: const [ThemeModeToggleAction()],
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
                    color: theme.colorScheme.shadow.withOpacity(0.3),
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
                      ? Image.network(
                          event.imageUrl!,
                          height: 240,
                          width: double.infinity,
                          fit: BoxFit.cover,
                        )
                      : Container(
                          height: 240,
                          width: double.infinity,
                          color: theme.colorScheme.surfaceVariant,
                          alignment: Alignment.center,
                          child: Icon(
                            Icons.event,
                            size: 56,
                            color: theme.colorScheme.onSurfaceVariant,
                          ),
                        ),
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Título
            Text(
              event.title,
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: 8),

            // Chips de meta
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                if (event.cityName != null)
                  Chip(
                    label: Text(
                      event.cityName!,
                      style: theme.textTheme.bodySmall,
                    ),
                    avatar: const Icon(Icons.place, size: 18),
                    backgroundColor: Theme.of(
                      context,
                    ).colorScheme.surfaceVariant,
                    visualDensity: VisualDensity.compact,
                  ),
                if (event.categoryName != null)
                  Chip(
                    label: Text(
                      event.categoryName!,
                      style: theme.textTheme.bodySmall,
                    ),
                    avatar: Icon(iconFromName(event.categoryIcon), size: 18),
                    backgroundColor: Theme.of(
                      context,
                    ).colorScheme.surfaceVariant,
                    visualDensity: VisualDensity.compact,
                  ),
                Chip(
                  label: Text(
                    event.formattedDate,
                    style: theme.textTheme.bodySmall,
                  ),
                  avatar: const Icon(Icons.event, size: 18),
                  backgroundColor: Theme.of(context).colorScheme.surfaceVariant,
                  visualDensity: VisualDensity.compact,
                ),
                Chip(
                  label: Text(
                    event.formattedTime,
                    style: theme.textTheme.bodySmall,
                  ),
                  avatar: const Icon(Icons.schedule, size: 18),
                  backgroundColor: Theme.of(context).colorScheme.surfaceVariant,
                  visualDensity: VisualDensity.compact,
                ),
                if (event.isFree == true)
                  Chip(
                    label: Text(
                      'Gratis',
                      style: theme.textTheme.bodySmall?.copyWith(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: theme.colorScheme.primary,
                      ),
                    ),
                    avatar: Icon(
                      Icons.check_circle,
                      size: 18,
                      color: theme.colorScheme.primary,
                    ),
                    backgroundColor: theme.colorScheme.primary.withOpacity(
                      0.12,
                    ),
                    visualDensity: VisualDensity.compact,
                  ),
              ],
            ),
            const SizedBox(height: 16),

            // Descripción y programación diaria
            _buildDescriptionSection(context, event),

            // Lugar
            if (event.place != null && event.place!.isNotEmpty) ...[
              Text(
                'Lugar',
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
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
                      onPressed: hasMapsUrl
                          ? () async {
                              final uri = Uri.parse(event.mapsUrl!);
                              if (await canLaunchUrl(uri)) {
                                await launchUrl(
                                  uri,
                                  mode: LaunchMode.externalApplication,
                                );
                              }
                            }
                          : null,
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
                        if (shareText.isNotEmpty) {
                          Share.share(shareText);
                        }
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

  Widget _buildDescriptionSection(BuildContext context, Event event) {
    final theme = Theme.of(context);
    final desc = event.description ?? '';

    if (desc.isEmpty) {
      return const SizedBox.shrink();
    }

    // Separar descripción base de programación diaria
    String? mainDesc;
    String? programBlock;

    const marker = '\n\nProgramación:\n';
    if (desc.contains(marker)) {
      final parts = desc.split(marker);
      mainDesc = parts.first.trim();
      programBlock = parts.sublist(1).join(marker).trim();
    } else {
      mainDesc = desc.trim().isEmpty ? null : desc.trim();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (mainDesc != null) ...[
          Text(
            'Descripción',
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            mainDesc,
            style: theme.textTheme.bodyMedium?.copyWith(height: 1.4),
            softWrap: true,
            textAlign: TextAlign.start,
          ),
          const SizedBox(height: 16),
        ],
        if (programBlock != null) ...[
          Text(
            'Programación',
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            programBlock,
            style: theme.textTheme.bodyMedium?.copyWith(height: 1.4),
            softWrap: true,
            textAlign: TextAlign.start,
          ),
          const SizedBox(height: 16),
        ],
      ],
    );
  }
}
