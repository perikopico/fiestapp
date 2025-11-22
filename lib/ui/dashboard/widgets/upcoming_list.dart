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

  /// Construye la imagen del evento con filtro de escala de grises si está en el pasado
  Widget _buildEventImage(BuildContext context, Event event, double width, double height) {
    final imageWidget = event.imageUrl != null && event.imageUrl!.isNotEmpty
        ? Image.network(
            event.imageUrl!,
            width: width,
            height: height,
            fit: BoxFit.cover,
            alignment: _alignmentFromString(event.imageAlignment),
            errorBuilder: (context, error, stackTrace) {
              return Container(
                width: width,
                height: height,
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surfaceVariant,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  iconFromName(event.categoryIcon),
                  size: 50,
                  color: event.isPast
                      ? Theme.of(context).disabledColor
                      : Theme.of(context).colorScheme.onSurfaceVariant,
                ),
              );
            },
          )
        : Container(
            width: width,
            height: height,
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surfaceVariant,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              iconFromName(event.categoryIcon),
              size: 50,
              color: event.isPast
                  ? Theme.of(context).disabledColor
                  : Theme.of(context).colorScheme.onSurfaceVariant,
            ),
          );

    if (!event.isPast) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: imageWidget,
      );
    }

    // Aplicar filtro de escala de grises y opacidad para eventos pasados
    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: ColorFiltered(
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
              ).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w700,
                letterSpacing: -0.5,
              ),
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
                
                final isPast = event.isPast;
                
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
                          // Imagen más grande con etiqueta FINALIZADO si está en el pasado
                          Stack(
                            children: [
                              _buildEventImage(context, event, 100, 100),
                              // Etiqueta FINALIZADO en rojo
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
                            ],
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
                                    color: isPast
                                        ? Theme.of(context).disabledColor
                                        : Theme.of(context).colorScheme.onSurface,
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
                                if (widget.showCategory && event.categoryName != null)
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                    decoration: BoxDecoration(
                                      color: _getChipColor(context, event, categoryColor.withOpacity(0.2)),
                                      borderRadius: BorderRadius.circular(8),
                                      border: Border.all(
                                        color: _getChipColor(context, event, categoryColor.withOpacity(0.5)),
                                        width: 1,
                                      ),
                                    ),
                                    child: Text(
                                      event.categoryName!,
                                      style: TextStyle(
                                        color: _getChipTextColor(context, event, categoryColor),
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
