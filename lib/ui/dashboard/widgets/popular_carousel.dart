import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../models/event.dart';
import '../../icons/icon_mapper.dart';
import '../../event/event_detail_screen.dart';
import '../../../services/favorites_service.dart';

class PopularCarousel extends StatefulWidget {
  final List<Event> events;
  final VoidCallback? onClearFilters;
  final String title;

  const PopularCarousel({
    super.key,
    required this.events,
    this.onClearFilters,
    this.title = 'Popular esta semana',
  });

  @override
  State<PopularCarousel> createState() => _PopularCarouselState();
}

class _PopularCarouselState extends State<PopularCarousel> {

  Color _getColorForCategory(String categoryName) {
    final name = categoryName.toLowerCase();
    if (name.contains('música') || name.contains('music')) {
      return Colors.purple;
    } else if (name.contains('mercados') || name.contains('market')) {
      return Colors.orange;
    } else if (name.contains('deporte') || name.contains('sport')) {
      return Colors.green;
    } else if (name.contains('tradición') || name.contains('tradition') || name.contains('tradicion')) {
      return Colors.redAccent;
    } else if (name.contains('gastronomía') || name.contains('gastronomy') || name.contains('comida')) {
      return Colors.amber;
    } else if (name.contains('cultura') || name.contains('culture')) {
      return Colors.blue;
    } else if (name.contains('arte') || name.contains('art')) {
      return Colors.pink;
    } else if (name.contains('naturaleza') || name.contains('nature')) {
      return Colors.teal;
    }
    return Colors.grey;
  }

  /// Construye la imagen del evento con filtro de escala de grises si está en el pasado
  Widget _buildEventImage(BuildContext context, Event event, double width, double height) {
    final imageWidget = event.imageUrl != null && event.imageUrl!.isNotEmpty
        ? Image.network(
            event.imageUrl!,
            width: width,
            height: height,
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) {
              return Container(
                width: width,
                height: height,
                color: Theme.of(context).colorScheme.surfaceVariant,
                child: Center(
                  child: Icon(
                    iconFromName(event.categoryIcon),
                    size: 48,
                    color: event.isPast
                        ? Theme.of(context).disabledColor
                        : Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
                ),
              );
            },
          )
        : Container(
            width: width,
            height: height,
            color: Theme.of(context).colorScheme.surfaceVariant,
            child: Center(
              child: Icon(
                iconFromName(event.categoryIcon),
                size: 48,
                color: event.isPast
                    ? Theme.of(context).disabledColor
                    : Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ),
          );

    if (!event.isPast) {
      return imageWidget;
    }

    // Aplicar filtro de escala de grises y opacidad para eventos pasados
    return ColorFiltered(
      colorFilter: const ColorFilter.matrix(<double>[
        0.2126, 0.7152, 0.0722, 0, 0,
        0.2126, 0.7152, 0.0722, 0, 0,
        0.2126, 0.7152, 0.0722, 0, 0,
        0,      0,      0,      1, 0,
      ]),
      child: Opacity(
        opacity: 0.7,
        child: imageWidget,
      ),
    );
  }

  /// Obtiene el color del chip según si el evento está en el pasado
  Color _getChipColor(BuildContext context, Event event, Color originalColor) {
    if (event.isPast) {
      return Theme.of(context).disabledColor.withOpacity(0.2);
    }
    return originalColor;
  }

  /// Obtiene el color del texto del chip según si el evento está en el pasado
  Color _getChipTextColor(BuildContext context, Event event, Color originalColor) {
    if (event.isPast) {
      return Theme.of(context).disabledColor;
    }
    return originalColor;
  }

  @override
  Widget build(BuildContext context) {
    if (widget.events.isEmpty) {
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
                color: Theme.of(
                  context,
                ).colorScheme.onSurfaceVariant.withOpacity(0.5),
              ),
              const SizedBox(height: 16),
              Text(
                widget.title == 'Popular esta semana'
                    ? 'No hay eventos populares esta semana'
                    : 'No hay eventos populares esta semana en tu provincia',
                style: Theme.of(
                  context,
                ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Text(
                'Vuelve pronto para ver los eventos más destacados.',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.title,
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.w700,
            letterSpacing: -0.5,
          ),
        ),
        const SizedBox(height: 12),
        ValueListenableBuilder<Set<String>>(
          valueListenable: FavoritesService.instance.favoritesNotifier,
          builder: (context, favorites, _) {
            return SizedBox(
              height: 200,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                padding: EdgeInsets.zero,
                itemCount: widget.events.length,
                separatorBuilder: (context, index) => const SizedBox(width: 12),
                itemBuilder: (context, index) {
                  final event = widget.events[index];
                  final isFavorite = FavoritesService.instance.isFavorite(event.id);
                  final isPast = event.isPast;
                  
                  // Obtener color de categoría
                  Color categoryColor = Colors.grey; // Color por defecto
                  if (event.categoryColor != null && event.categoryColor!.isNotEmpty) {
                    try {
                      categoryColor = Color(int.parse(event.categoryColor!.replaceFirst('#', '0xFF')));
                    } catch (e) {
                      // Si falla el parse, usar color por defecto basado en el nombre
                      if (event.categoryName != null) {
                        categoryColor = _getColorForCategory(event.categoryName!);
                      }
                    }
                  } else if (event.categoryName != null) {
                    // Si no hay color, usar color por defecto basado en el nombre de la categoría
                    categoryColor = _getColorForCategory(event.categoryName!);
                  }
                  
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
                        color: Theme.of(context).colorScheme.surface,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            blurRadius: 3,
                            color: Theme.of(context).brightness == Brightness.dark
                                ? Colors.black.withOpacity(0.4)
                                : Colors.black12,
                          ),
                        ],
                      ),
                      child: ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: Stack(
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            // Image on top with fixed height
                            Container(
                              height: 110,
                              width: double.infinity,
                              child: _buildEventImage(context, event, double.infinity, 110),
                            ),
                            // Title and date below
                            Padding(
                              padding: const EdgeInsets.fromLTRB(8, 8, 8, 8),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    event.title,
                                    style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 12,
                                      color: isPast
                                          ? Theme.of(context).disabledColor
                                          : Theme.of(
                                              context,
                                            ).colorScheme.onSurface,
                                    ),
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  const SizedBox(height: 2),
                                  Text(
                                    () {
                                      final fullDate = DateFormat('dd MMM', 'es').format(event.startsAt);
                                      final fullHour = DateFormat('HH:mm').format(event.startsAt);
                                      return "$fullDate · $fullHour";
                                    }(),
                                    style: Theme.of(
                                      context,
                                    ).textTheme.bodySmall?.copyWith(fontSize: 10),
                                  ),
                                  // Chip de categoría
                                  if (event.categoryName != null) ...[
                                    const SizedBox(height: 4),
                                    Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
                                      decoration: BoxDecoration(
                                        color: _getChipColor(context, event, categoryColor.withOpacity(0.2)),
                                        borderRadius: BorderRadius.circular(6),
                                        border: Border.all(
                                          color: _getChipColor(context, event, categoryColor.withOpacity(0.5)),
                                          width: 1,
                                        ),
                                      ),
                                      child: Text(
                                        event.categoryName!,
                                        style: TextStyle(
                                          color: _getChipTextColor(context, event, categoryColor),
                                          fontSize: 9,
                                          fontWeight: FontWeight.w600,
                                        ),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                  ],
                                ],
                              ),
                            ),
                          ],
                        ),
                        // Etiqueta FINALIZADO en rojo (si es pasado)
                        if (isPast)
                          Positioned(
                            top: 8,
                            left: 8,
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(
                                color: Colors.red.withOpacity(0.9),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: const Text(
                                'FINALIZADO',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 11,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        // Icono de favorito en la esquina superior derecha
                        Positioned(
                          top: 8,
                          right: 8,
                          child: Material(
                            color: Colors.transparent,
                            child: InkWell(
                              onTap: () async {
                                await FavoritesService.instance.toggleFavorite(event.id);
                                if (mounted) {
                                  setState(() {});
                                }
                              },
                              borderRadius: BorderRadius.circular(20),
                              child: Container(
                                padding: const EdgeInsets.all(6),
                                decoration: BoxDecoration(
                                  color: Colors.black.withOpacity(0.5),
                                  shape: BoxShape.circle,
                                ),
                                child: Icon(
                                  isFavorite ? Icons.favorite : Icons.favorite_border,
                                  color: isFavorite
                                      ? Colors.red
                                      : Colors.white,
                                  size: 18,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                    ),
                  );
                },
              ),
            );
          },
        ),
      ],
    );
  }
}
