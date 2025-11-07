import 'package:flutter/material.dart';
import '../../../models/event.dart';
import '../../icons/icon_mapper.dart';

class UpcomingList extends StatelessWidget {
  final List<Event> events;

  const UpcomingList({super.key, required this.events});

  @override
  Widget build(BuildContext context) {
    if (events.isEmpty) {
      return const SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Próximos eventos',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),
        const SizedBox(height: 12),
        ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          padding: EdgeInsets.zero,
          itemCount: events.length,
          separatorBuilder: (context, index) => const SizedBox(height: 12),
          itemBuilder: (context, index) {
            final event = events[index];
            return Card(
              elevation: 0.3,
              color: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Row(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: event.imageUrl != null && event.imageUrl!.isNotEmpty
                          ? Image.network(
                              event.imageUrl!,
                              width: 80,
                              height: 80,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) {
                                return Container(
                                  width: 80,
                                  height: 80,
                                  color: Colors.grey.shade200,
                                  child: Icon(
                                    iconFromName(event.categoryIcon),
                                    size: 28,
                                    color: Colors.grey.shade700,
                                  ),
                                );
                              },
                            )
                          : Container(
                              width: 80,
                              height: 80,
                              color: Colors.grey.shade200,
                              child: Icon(
                                iconFromName(event.categoryIcon),
                                size: 28,
                                color: Colors.grey.shade700,
                              ),
                            ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            event.title,
                            style: const TextStyle(
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            "${event.cityName ?? ''}${event.place != null ? ' · ' + event.place! : ''}",
                            style: const TextStyle(
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 12),
                    Text(
                      event.formattedDate,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: Colors.grey[600],
                          ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ],
    );
  }
}

