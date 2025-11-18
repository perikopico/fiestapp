import 'package:flutter/material.dart';

import 'package:url_launcher/url_launcher.dart';
import 'package:share_plus/share_plus.dart';
import 'package:add_2_calendar/add_2_calendar.dart' as add2cal;

import '../../models/event.dart';
import '../icons/icon_mapper.dart';
import '../common/theme_mode_toggle.dart';
import 'fullscreen_image_screen.dart';

class EventDetailScreen extends StatelessWidget {
  final Event event;

  const EventDetailScreen({super.key, required this.event});

  Alignment _alignmentFromString(String? value) {
    switch (value) {
      case 'top':
        return Alignment.topCenter;
      case 'bottom':
        return Alignment.bottomCenter;
      case 'center':
      default:
        return Alignment.center;
    }
  }

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
            if (event.imageUrl != null && event.imageUrl!.isNotEmpty) ...[
              GestureDetector(
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => FullscreenImageScreen(imageUrl: event.imageUrl!),
                    ),
                  );
                },
                child: SizedBox(
                  height: 220,
                  width: double.infinity,
                  child: Stack(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(0),
                        child: Hero(
                          tag: 'event-img-${event.id}',
                          child: Image.network(
                            event.imageUrl!,
                            width: double.infinity,
                            height: double.infinity,
                            fit: BoxFit.cover,
                            alignment: _alignmentFromString(event.imageAlignment),
                            errorBuilder: (context, error, stackTrace) {
                              return Container(
                                color: theme.colorScheme.surfaceVariant,
                                alignment: Alignment.center,
                                child: Icon(
                                  Icons.event,
                                  size: 56,
                                  color: theme.colorScheme.onSurfaceVariant,
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                      // Banner "Ampliar" encima de la imagen
                      Positioned(
                        top: 8,
                        right: 8,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.black.withOpacity(0.6),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(
                                Icons.fullscreen,
                                color: Colors.white,
                                size: 16,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                'Ampliar',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
            ] else ...[
              SizedBox(
                height: 220,
                width: double.infinity,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(0),
                  child: Container(
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
              const SizedBox(height: 16),
            ],

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
        if (mainDesc != null && mainDesc.isNotEmpty) ...[
          const SizedBox(height: 8),
          Text(
            'Descripción',
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
            decoration: BoxDecoration(
              color: theme.colorScheme.surfaceVariant,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              mainDesc,
              style: theme.textTheme.bodyLarge?.copyWith(height: 1.5),
              softWrap: true,
              textAlign: TextAlign.start,
            ),
          ),
          const SizedBox(height: 16),
        ],
        if (programBlock != null && programBlock.isNotEmpty) ...[
          Text(
            'Programación',
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
            decoration: BoxDecoration(
              color: theme.colorScheme.surfaceVariant,
              borderRadius: BorderRadius.circular(12),
            ),
            child: _buildProgrammingItems(theme, programBlock),
          ),
          const SizedBox(height: 16),
        ],
      ],
    );
  }

  Widget _buildProgrammingItems(ThemeData theme, String programBlock) {
    final items = programBlock.split('\n').where((item) => item.trim().isNotEmpty).toList();
    
    if (items.isEmpty) {
      return const SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: items.asMap().entries.map((entry) {
        final index = entry.key;
        final item = entry.value.trim();
        return Padding(
          padding: EdgeInsets.only(bottom: index < items.length - 1 ? 8 : 0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 2, right: 8),
                child: Icon(
                  Icons.schedule,
                  size: 16,
                  color: theme.colorScheme.onSurfaceVariant.withOpacity(0.7),
                ),
              ),
              Expanded(
                child: Text(
                  item,
                  style: theme.textTheme.bodyMedium?.copyWith(height: 1.4),
                  softWrap: true,
                  textAlign: TextAlign.start,
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }
}
