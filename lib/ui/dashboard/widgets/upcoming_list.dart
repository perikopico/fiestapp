import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../models/event.dart';
import '../../icons/icon_mapper.dart';
import '../../event/event_detail_screen.dart';
import '../../../services/favorites_service.dart';

class UpcomingList extends StatefulWidget {
  final List<Event> events;
  final VoidCallback? onClearFilters;
  final bool showCategory;

  const UpcomingList({
    super.key,
    required this.events,
    this.onClearFilters,
    this.showCategory = true,
  });

  @override
  State<UpcomingList> createState() => _UpcomingListState();
}

class _UpcomingListState extends State<UpcomingList> {

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
    // Estado vacío: mantenemos la tarjeta con "Borrar filtros"
    if (widget.events.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.event_busy, size: 40),
              const SizedBox(height: 8),
              Text(
                'No hay eventos para estos filtros',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              const SizedBox(height: 4),
              Text(
                'Prueba cambiando de ciudad o categoría.',
                style: Theme.of(context).textTheme.bodySmall,
              ),
              const SizedBox(height: 12),
              if (widget.onClearFilters != null)
                OutlinedButton(
                  onPressed: widget.onClearFilters,
                  child: const Text('Borrar filtros'),
                ),
            ],
          ),
        ),
      );
    }

    // Hay eventos: mostramos cabecera + botón "Borrar filtros" + lista
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Próximos eventos',
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
            ),
            if (widget.onClearFilters != null)
              TextButton(
                onPressed: widget.onClearFilters,
                child: const Text('Borrar filtros'),
              ),
          ],
        ),
        const SizedBox(height: 12),
        ValueListenableBuilder<Set<String>>(
          valueListenable: FavoritesService.instance.favoritesNotifier,
          builder: (context, favorites, _) {
            return ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: widget.events.length,
              separatorBuilder: (_, __) => const SizedBox(height: 12),
              itemBuilder: (context, index) {
                final event = widget.events[index];
                final isFavorite = FavoritesService.instance.isFavorite(event.id);

                // Obtener color de categoría
                Color? categoryColor;
                if (event.categoryColor != null && event.categoryColor!.isNotEmpty) {
                  try {
                    categoryColor = Color(int.parse(event.categoryColor!.replaceFirst('#', '0xFF')));
                  } catch (e) {
                    categoryColor = null;
                  }
                }
                
                return Card(
                  margin: EdgeInsets.zero,
                  elevation: 0.3,
                  color: Theme.of(context).colorScheme.surface,
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
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Imagen más grande
                          ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child:
                                event.imageUrl != null && event.imageUrl!.isNotEmpty
                                ? Image.network(
                                    event.imageUrl!,
                                    width: 100,
                                    height: 100,
                                    fit: BoxFit.cover,
                                    alignment: _alignmentFromString(event.imageAlignment),
                                    errorBuilder: (context, error, stackTrace) {
                                      return Container(
                                        width: 100,
                                        height: 100,
                                        decoration: BoxDecoration(
                                          color: Theme.of(
                                            context,
                                          ).colorScheme.surfaceVariant,
                                          borderRadius: BorderRadius.circular(12),
                                        ),
                                        child: Icon(
                                          iconFromName(event.categoryIcon),
                                          size: 50,
                                          color: Theme.of(
                                            context,
                                          ).colorScheme.onSurfaceVariant,
                                        ),
                                      );
                                    },
                                  )
                                : Container(
                                    width: 100,
                                    height: 100,
                                    decoration: BoxDecoration(
                                      color: Theme.of(
                                        context,
                                      ).colorScheme.surfaceVariant,
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: Icon(
                                      iconFromName(event.categoryIcon),
                                      size: 50,
                                      color: Theme.of(
                                        context,
                                      ).colorScheme.onSurfaceVariant,
                                    ),
                                  ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Text(
                                  event.title,
                                  style: TextStyle(
                                    fontWeight: FontWeight.w700,
                                    fontSize: 16,
                                    color: Theme.of(context).colorScheme.onSurface,
                                  ),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                const SizedBox(height: 6),
                                // Fecha y lugar
                                Row(
                                  children: [
                                    Text(
                                      DateFormat('dd MMM', 'es').format(event.startsAt),
                                      style: Theme.of(context).textTheme.bodySmall
                                          ?.copyWith(
                                            color: Theme.of(context)
                                                .colorScheme
                                                .onSurfaceVariant
                                                .withOpacity(0.7),
                                          ),
                                    ),
                                    if (event.cityName != null) ...[
                                      Text(
                                        ' · ',
                                        style: Theme.of(context).textTheme.bodySmall
                                            ?.copyWith(
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .onSurfaceVariant
                                                  .withOpacity(0.7),
                                            ),
                                      ),
                                      Text(
                                        event.cityName!,
                                        style: Theme.of(context).textTheme.bodySmall
                                            ?.copyWith(
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .onSurfaceVariant
                                                  .withOpacity(0.7),
                                            ),
                                      ),
                                    ],
                                  ],
                                ),
                                const SizedBox(height: 8),
                                // Chip de categoría con color (solo si showCategory es true)
                                if (widget.showCategory && event.categoryName != null && categoryColor != null)
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                    decoration: BoxDecoration(
                                      color: categoryColor.withOpacity(0.2),
                                      borderRadius: BorderRadius.circular(8),
                                      border: Border.all(
                                        color: categoryColor.withOpacity(0.5),
                                        width: 1,
                                      ),
                                    ),
                                    child: Text(
                                      event.categoryName!,
                                      style: TextStyle(
                                        color: categoryColor,
                                        fontSize: 12,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 8),
                          // Iconos de corazón y ubicación
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              IconButton(
                                icon: Icon(
                                  isFavorite ? Icons.favorite : Icons.favorite_border,
                                  color: isFavorite
                                      ? Theme.of(context).colorScheme.error
                                      : Theme.of(context).colorScheme.onSurfaceVariant,
                                ),
                                onPressed: () async {
                                  await FavoritesService.instance.toggleFavorite(event.id);
                                  if (mounted) {
                                    setState(() {});
                                  }
                                },
                                padding: EdgeInsets.zero,
                                constraints: const BoxConstraints(),
                                iconSize: 22,
                              ),
                              const SizedBox(height: 4),
                              IconButton(
                                icon: Icon(
                                  Icons.location_on_outlined,
                                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                                ),
                                onPressed: () {
                                  // TODO: Abrir mapa o detalles de ubicación
                                },
                                padding: EdgeInsets.zero,
                                constraints: const BoxConstraints(),
                                iconSize: 22,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            );
          },
        ),
      ],
    );
  }
}
