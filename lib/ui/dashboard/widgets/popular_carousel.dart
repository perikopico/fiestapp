import 'package:flutter/material.dart';
import '../../../models/event.dart';
import '../../icons/icon_mapper.dart';
import '../../event/event_detail_screen.dart';

class PopularCarousel extends StatelessWidget {
  final List<Event> events;

  const PopularCarousel({super.key, required this.events});

  @override
  Widget build(BuildContext context) {
    if (events.isEmpty) {
      return const SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Popular esta semana',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),
        const SizedBox(height: 12),
        SizedBox(
          height: 200,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            padding: EdgeInsets.zero,
            itemCount: events.length,
            separatorBuilder: (context, index) => const SizedBox(width: 12),
            itemBuilder: (context, index) {
              final event = events[index];
              return InkWell(
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => EventDetailScreen(event: event),
                    ),
                  );
                },
                borderRadius: BorderRadius.circular(16),
                child: Container(
                  width: 180,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        blurRadius: 3,
                        color: Colors.black12,
                      ),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // Image on top with fixed height
                        Container(
                          height: 115,
                          width: double.infinity,
                          color: Colors.grey.shade200,
                          child: Hero(
                            tag: 'event-img-${event.id}',
                            child: event.imageUrl != null && event.imageUrl!.isNotEmpty
                                ? Image.network(
                                    event.imageUrl!,
                                    width: double.infinity,
                                    height: 115,
                                    fit: BoxFit.cover,
                                    errorBuilder: (context, error, stackTrace) {
                                      return Center(
                                        child: Icon(
                                          iconFromName(event.categoryIcon),
                                          size: 48,
                                          color: Colors.grey.shade700,
                                        ),
                                      );
                                    },
                                  )
                                : Center(
                                    child: Icon(
                                      iconFromName(event.categoryIcon),
                                      size: 48,
                                      color: Colors.grey.shade700,
                                    ),
                                  ),
                          ),
                        ),
                        // Title and date below
                        Padding(
                          padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                event.title,
                                style: const TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 13,
                                ),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                              const SizedBox(height: 3),
                              Text(
                                event.formattedDate,
                                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                      fontSize: 11,
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

