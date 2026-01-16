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
  // Parámetros para búsqueda ampliada
  final bool isRadiusMode;
  final double? currentRadiusKm;
  final VoidCallback? onExpandRadius;
  // Texto del filtro de fecha activo
  final String? dateFilterText;

  const UpcomingList({
    super.key,
    required this.events,
    this.onClearFilters,
    this.showCategory = true,
    this.isRadiusMode = false,
    this.currentRadiusKm,
    this.onExpandRadius,
    this.dateFilterText,
  });

  @override
  State<UpcomingList> createState() => _UpcomingListState();
}

class _UpcomingListState extends State<UpcomingList> {

  Color _getColorForCategory(String categoryName) {
    if (categoryName.isEmpty) return Colors.grey;
    
    final name = categoryName.toLowerCase();
    
    // Música
    if (name.contains('música') || name.contains('musica') || name.contains('music')) {
      return const Color(0xFF9C27B0); // Purple
    }
    // Gastronomía
    else if (name.contains('gastronomía') || name.contains('gastronomia') || name.contains('gastronomy') || name.contains('comida')) {
      return const Color(0xFFFF6F00); // Amber
    }
    // Deportes
    else if (name.contains('deporte') || name.contains('deportes') || name.contains('sport')) {
      return const Color(0xFF4CAF50); // Green
    }
    // Arte y Cultura
    else if (name.contains('arte') || name.contains('cultura') || name.contains('culture') || name.contains('art')) {
      return const Color(0xFF2196F3); // Blue
    }
    // Aire Libre
    else if (name.contains('aire libre') || name.contains('aire-libre') || name.contains('naturaleza') || name.contains('nature')) {
      return const Color(0xFF00BCD4); // Cyan/Teal
    }
    // Tradiciones
    else if (name.contains('tradición') || name.contains('tradiciones') || name.contains('tradicion') || name.contains('tradition')) {
      return const Color(0xFFE91E63); // Pink/Red
    }
    // Mercadillos
    else if (name.contains('mercadillo') || name.contains('mercadillos') || name.contains('mercado') || name.contains('mercados') || name.contains('market')) {
      return const Color(0xFFFF9800); // Orange
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
              debugPrint('❌ Error al cargar imagen del evento ${event.id}: $error');
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
            loadingBuilder: (context, child, loadingProgress) {
              if (loadingProgress == null) return child;
              return Container(
                width: width,
                height: height,
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surfaceVariant,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Center(
                  child: CircularProgressIndicator(
                    value: loadingProgress.expectedTotalBytes != null
                        ? loadingProgress.cumulativeBytesLoaded /
                            loadingProgress.expectedTotalBytes!
                        : null,
                    strokeWidth: 2,
                  ),
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
      // Verificar si debemos mostrar el botón de búsqueda ampliada
      final shouldShowExpandButton = widget.isRadiusMode &&
          widget.currentRadiusKm != null &&
          widget.currentRadiusKm! < 50 &&
          widget.onExpandRadius != null;

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
                shouldShowExpandButton
                    ? 'No hay planes cerca. ¿Buscar en 50km?'
                    : 'Prueba cambiando de ciudad o categoría.',
                style: Theme.of(context).textTheme.bodySmall,
              ),
              const SizedBox(height: 12),
              // Botón de búsqueda ampliada (solo en modo radio con radio < 50km)
              if (shouldShowExpandButton)
                ElevatedButton.icon(
                  onPressed: widget.onExpandRadius,
                  icon: const Icon(Icons.search, size: 18),
                  label: const Text('Buscar en 50km'),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 12,
                    ),
                  ),
                )
              else if (widget.onClearFilters != null)
                OutlinedButton(
                  onPressed: widget.onClearFilters,
                  child: const Text('Borrar filtros'),
                ),
            ],
          ),
        ),
      );
    }

    // Hay eventos: mostramos cabecera con filtro de fecha + botón "Borrar filtros" + grid
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Cabecera con filtro de fecha y botón "Borrar filtros"
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Mostrar filtro de fecha activo si está disponible
            if (widget.dateFilterText != null && widget.dateFilterText!.isNotEmpty)
              Expanded(
                child: Text(
                  widget.dateFilterText!,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant.withOpacity(0.7),
                    fontSize: 12,
                  ),
                ),
              )
            else
              const Spacer(),
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
            return GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                childAspectRatio: 0.68, // Ratio ajustado para media foto + información
              ),
              itemCount: widget.events.length,
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
                  elevation: 2, // Sombra sutil para dar profundidad
                  shadowColor: Colors.black.withOpacity(0.1),
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
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(16),
                      child: Stack(
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              // Imagen en la parte superior (media altura, similar a populares)
                              Container(
                                height: 110,
                                width: double.infinity,
                                child: _buildEventImage(context, event, double.infinity, 110),
                              ),
                              // Título, fecha y categoría debajo con fondo grisáceo
                              Container(
                                width: double.infinity,
                                height: 90, // Altura fija para alinear chips
                                decoration: BoxDecoration(
                                  color: Theme.of(context).brightness == Brightness.dark
                                      ? Colors.grey.shade900.withOpacity(0.9)
                                      : Colors.grey.shade100,
                                  border: Border(
                                    top: BorderSide(
                                      color: Theme.of(context).dividerColor.withOpacity(0.1),
                                      width: 0.5,
                                    ),
                                  ),
                                ),
                                padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Text(
                                          event.title,
                                          style: TextStyle(
                                            fontWeight: FontWeight.w600,
                                            fontSize: 13,
                                            height: 1.3,
                                            color: isPast
                                                ? Theme.of(context).disabledColor
                                                : Theme.of(context).colorScheme.onSurface,
                                          ),
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          () {
                                            final fullDate = DateFormat('dd MMM', 'es').format(event.startsAt);
                                            final fullHour = DateFormat('HH:mm').format(event.startsAt);
                                            return "$fullDate · $fullHour";
                                          }(),
                                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                            fontSize: 11,
                                            color: Theme.of(context).colorScheme.onSurfaceVariant.withOpacity(0.8),
                                          ),
                                        ),
                                      ],
                                    ),
                                    // Chip de categoría (siempre abajo)
                                    if (widget.showCategory && event.categoryName != null)
                                      Container(
                                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
                                        decoration: BoxDecoration(
                                          color: _getChipColor(context, event, categoryColor.withOpacity(0.2)),
                                          borderRadius: BorderRadius.circular(8),
                                          border: Border.all(
                                            color: _getChipColor(context, event, categoryColor.withOpacity(0.4)),
                                            width: 1,
                                          ),
                                        ),
                                        child: Text(
                                          event.categoryName!,
                                          style: TextStyle(
                                            color: _getChipTextColor(context, event, categoryColor),
                                            fontSize: 10,
                                            fontWeight: FontWeight.w600,
                                            letterSpacing: 0.2,
                                          ),
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
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
                                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
                                decoration: BoxDecoration(
                                  color: Colors.red.withOpacity(0.9),
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                child: const Text(
                                  'FINALIZADO',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 9,
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
                                    color: isFavorite ? Colors.red : Colors.white,
                                    size: 16,
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
            );
          },
        ),
      ],
    );
  }
}
