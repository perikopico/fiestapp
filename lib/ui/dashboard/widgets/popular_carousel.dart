import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../../models/event.dart';
import '../../icons/icon_mapper.dart';
import '../../event/event_detail_screen.dart';
import '../../../services/favorites_service.dart';
import '../../common/glass_card.dart';

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

  /// Construye la imagen del evento con filtro de escala de grises si está en el pasado
  Widget _buildEventImage(BuildContext context, Event event, double width, double height) {
    final imageWidget = event.imageUrl != null && event.imageUrl!.isNotEmpty
        ? CachedNetworkImage(
            imageUrl: event.imageUrl!,
            width: width,
            height: height,
            fit: BoxFit.cover,
            memCacheWidth: width.isFinite ? width.toInt() : null,
            memCacheHeight: height.isFinite ? height.toInt() : null,
            fadeInDuration: const Duration(milliseconds: 200),
            fadeOutDuration: const Duration(milliseconds: 100),
            placeholder: (context, url) => Container(
              width: width,
              height: height,
              color: Theme.of(context).colorScheme.surfaceVariant,
              child: Center(
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(
                    Theme.of(context).colorScheme.primary.withOpacity(0.3),
                  ),
                ),
              ),
            ),
            placeholderFadeInDuration: const Duration(milliseconds: 150),
            errorWidget: (context, url, error) {
              debugPrint('❌ Error al cargar imagen del evento ${event.id}: $error');
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

  /// Oscurece un color para usar en el texto (estilo text-*-700)
  Color _darkenColor(Color color, double amount) {
    assert(amount >= 0 && amount <= 1);
    final hsl = HSLColor.fromColor(color);
    return hsl.withLightness((hsl.lightness * (1 - amount)).clamp(0.0, 1.0)).toColor();
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
                    child: GlassCard(
                      width: 180,
                      blur: 15.0,
                      opacity: 0.25,
                      borderRadius: BorderRadius.circular(16),
                      padding: EdgeInsets.zero,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(16),
                        child: Stack(
                          children: [
                            ClipRect(
                              child: Column(
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
                                  Container(
                                    constraints: const BoxConstraints(
                                      minHeight: 96,
                                    ),
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
                                    padding: const EdgeInsets.fromLTRB(10, 3, 10, 3),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Flexible(
                                          fit: FlexFit.loose,
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            mainAxisAlignment: MainAxisAlignment.start,
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              Text(
                                                event.title,
                                                style: TextStyle(
                                                  fontWeight: FontWeight.w600,
                                                  fontSize: 12,
                                                  height: 1.2,
                                                  color: isPast
                                                      ? Theme.of(context).disabledColor
                                                      : Theme.of(
                                                          context,
                                                        ).colorScheme.onSurface,
                                                ),
                                                maxLines: 2,
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                              const SizedBox(height: 3),
                                              Text(
                                                () {
                                                  final fullDate = DateFormat('dd MMM', 'es').format(event.startsAt);
                                                  final fullHour = DateFormat('HH:mm').format(event.startsAt);
                                                  return "$fullDate · $fullHour";
                                                }(),
                                                style: Theme.of(
                                                  context,
                                                ).textTheme.bodySmall?.copyWith(
                                                  fontSize: 9,
                                                  height: 1.0,
                                                  color: Theme.of(context).colorScheme.onSurfaceVariant.withOpacity(0.7),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        // Chip de categoría (siempre abajo) - Light Pill Style
                                        if (event.categoryName != null)
                                          Padding(
                                            padding: const EdgeInsets.only(top: 2),
                                            child: Container(
                                              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 1),
                                              decoration: BoxDecoration(
                                                color: _getChipColor(context, event, categoryColor.withOpacity(0.12)),
                                                borderRadius: BorderRadius.circular(12),
                                              ),
                                              child: Text(
                                                event.categoryName!,
                                                style: TextStyle(
                                                  color: _getChipTextColor(context, event, _darkenColor(categoryColor, 0.3)),
                                                  fontSize: 8.5,
                                                  fontWeight: FontWeight.w600,
                                                  letterSpacing: 0.05,
                                                  height: 1.0,
                                                ),
                                                maxLines: 1,
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                            ),
                                          ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
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
