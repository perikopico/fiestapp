import 'package:flutter/material.dart';
import '../../../models/event.dart';
import '../../icons/icon_mapper.dart';
import '../../event/event_detail_screen.dart';

class UpcomingList extends StatelessWidget {
  final List<Event> events;
  final VoidCallback? onClearFilters;

  const UpcomingList({
    super.key,
    required this.events,
    this.onClearFilters,
  });

  @override
  Widget build(BuildContext context) {
    if (events.isEmpty) {
      return Card(
        margin: const EdgeInsets.all(16),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.event_busy,
                size: 64,
                color: Theme.of(context).colorScheme.onSurfaceVariant.withOpacity(0.5),
              ),
              const SizedBox(height: 16),
              Text(
                'No hay eventos para estos filtros',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Text(
                'Prueba cambiando de ciudad o categoría.',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
                textAlign: TextAlign.center,
              ),
              if (onClearFilters != null) ...[
                const SizedBox(height: 16),
                OutlinedButton(
                  onPressed: onClearFilters,
                  child: const Text('Borrar filtros'),
                ),
              ],
            ],
          ),
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Eventos cerca de ti',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 12),
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          padding: EdgeInsets.zero,
          itemCount: events.length,
          itemBuilder: (context, index) {
            final event = events[index];
            final isMobile = MediaQuery.of(context).size.width < 600;
            final imageSize = isMobile ? 64.0 : 72.0;
            
            return Card(
              margin: const EdgeInsets.symmetric(vertical: 6),
              elevation: 0.3,
              color: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: InkWell(
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => EventDetailScreen(event: event),
                    ),
                  );
                },
                borderRadius: BorderRadius.circular(16),
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Row(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Hero(
                          tag: 'event-img-${event.id}',
                          child: event.imageUrl != null && event.imageUrl!.isNotEmpty
                              ? Image.network(
                                  event.imageUrl!,
                                  width: imageSize,
                                  height: imageSize,
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) {
                                    return Container(
                                      width: imageSize,
                                      height: imageSize,
                                      decoration: BoxDecoration(
                                        color: Theme.of(context).colorScheme.surfaceVariant,
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      child: Icon(
                                        iconFromName(event.categoryIcon),
                                        size: imageSize * 0.7,
                                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                                      ),
                                    );
                                  },
                                )
                              : Container(
                                  width: imageSize,
                                  height: imageSize,
                                  decoration: BoxDecoration(
                                    color: Theme.of(context).colorScheme.surfaceVariant,
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Icon(
                                    iconFromName(event.categoryIcon),
                                    size: imageSize * 0.7,
                                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                                  ),
                                ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              event.title,
                              style: const TextStyle(
                                fontWeight: FontWeight.w700,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            if (event.cityName != null || event.place != null) ...[
                              const SizedBox(height: 4),
                              Text(
                                '${event.cityName ?? ''}${event.cityName != null && event.place != null ? ' · ' : ''}${event.place ?? ''}',
                                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                      color: Theme.of(context).colorScheme.onSurfaceVariant.withOpacity(0.7),
                                    ),
                              ),
                            ],
                          ],
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        event.formattedTime,
                        style: Theme.of(context).textTheme.labelLarge?.copyWith(
                              color: Theme.of(context).colorScheme.onSurfaceVariant.withOpacity(0.8),
                            ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ],
    );
  }
}

