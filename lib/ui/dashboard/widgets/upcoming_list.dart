import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:cached_network_image/cached_network_image.dart';
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
  // Información de búsqueda activa
  final bool hasActiveSearch;
  final String? searchTerm;

  const UpcomingList({
    super.key,
    required this.events,
    this.onClearFilters,
    this.showCategory = true,
    this.isRadiusMode = false,
    this.currentRadiusKm,
    this.onExpandRadius,
    this.dateFilterText,
    this.hasActiveSearch = false,
    this.searchTerm,
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

  /// Construye sugerencias basadas en el término de búsqueda
  Widget _buildSuggestions(BuildContext context) {
    if (widget.searchTerm == null || widget.searchTerm!.isEmpty) {
      return const SizedBox.shrink();
    }

    final searchTerm = widget.searchTerm!.toLowerCase();
    final suggestions = <String>[];

    // Sugerencias basadas en el término de búsqueda
    if (searchTerm.length < 3) {
      suggestions.add('Intenta usar más de 3 letras');
      suggestions.add('Verifica la ortografía');
    } else {
      suggestions.add('Verifica la ortografía del término');
      suggestions.add('Intenta usar términos más generales');
      suggestions.add('Prueba buscar solo por ciudad o categoría');
      if (searchTerm.contains('evento') || searchTerm.contains('plan')) {
        suggestions.add('Busca por el nombre específico del evento');
      }
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: suggestions.map((suggestion) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 4),
            child: Text(
              '• $suggestion',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
                fontSize: 12,
              ),
            ),
          );
        }).toList(),
      ),
    );
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
        ? CachedNetworkImage(
            imageUrl: event.imageUrl!,
            width: width,
            height: height,
            fit: BoxFit.cover,
            alignment: _alignmentFromString(event.imageAlignment),
            memCacheWidth: width.isFinite ? width.toInt() : null,
            memCacheHeight: height.isFinite ? height.toInt() : null,
            fadeInDuration: const Duration(milliseconds: 200),
            fadeOutDuration: const Duration(milliseconds: 100),
            placeholder: (context, url) => Container(
              width: width,
              height: height,
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surfaceVariant,
                borderRadius: BorderRadius.circular(12),
              ),
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

  /// Oscurece un color para usar en el texto (estilo text-*-700)
  Color _darkenColor(Color color, double amount) {
    assert(amount >= 0 && amount <= 1);
    final hsl = HSLColor.fromColor(color);
    return hsl.withLightness((hsl.lightness * (1 - amount)).clamp(0.0, 1.0)).toColor();
  }

  @override
  Widget build(BuildContext context) {
    // Estado vacío: mostrar mensaje según si hay búsqueda activa o no
    if (widget.events.isEmpty) {
      // Si no hay búsqueda activa, mostrar mensaje de bienvenida
      if (!widget.hasActiveSearch) {
        return Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 48, horizontal: 24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Utiliza los filtros de arriba para localizar tu localidad o evento',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                Text(
                  'Selecciona una ciudad, categoría o fecha para encontrar planes',
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

      // Si hay búsqueda activa pero sin resultados, mostrar mensaje con sugerencias
      // Verificar si debemos mostrar el botón de búsqueda ampliada
      final shouldShowExpandButton = widget.isRadiusMode &&
          widget.currentRadiusKm != null &&
          widget.currentRadiusKm! < 50 &&
          widget.onExpandRadius != null;

      return Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 32, horizontal: 24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'No se encontraron eventos',
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: Theme.of(context).colorScheme.onSurface,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              if (widget.searchTerm != null && widget.searchTerm!.isNotEmpty) ...[
                Text(
                  'No hay resultados para "${widget.searchTerm}"',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 12),
                _buildSuggestions(context),
              ] else ...[
                Text(
                  shouldShowExpandButton
                      ? 'No hay planes cerca. ¿Buscar en 50km?'
                      : 'Prueba cambiando de ciudad o categoría.',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
              const SizedBox(height: 16),
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
        const SizedBox(height: 8),
        ValueListenableBuilder<Set<String>>(
          valueListenable: FavoritesService.instance.favoritesNotifier,
          builder: (context, favorites, _) {
            return GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 12,
                mainAxisSpacing: 8, // Espaciado entre eventos para mejor separación visual
                childAspectRatio: 1.02, // Ratio ajustado para eliminar overflow (tarjetas más anchas, menos altas)
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
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              // Imagen en la parte superior
                              Container(
                                height: 105,
                                width: double.infinity,
                                child: _buildEventImage(context, event, double.infinity, 105),
                              ),
                              // Título, fecha y categoría debajo con fondo grisáceo
                              Container(
                                width: double.infinity,
                                decoration: BoxDecoration(
                                  color: Theme.of(context).brightness == Brightness.dark
                                      ? Colors.grey.shade900.withOpacity(0.9)
                                      : Colors.grey.shade100,
                                  borderRadius: const BorderRadius.only(
                                    bottomLeft: Radius.circular(16),
                                    bottomRight: Radius.circular(16),
                                  ),
                                  border: Border(
                                    top: BorderSide(
                                      color: Theme.of(context).dividerColor.withOpacity(0.1),
                                      width: 0.5,
                                    ),
                                  ),
                                ),
                                padding: const EdgeInsets.only(left: 10, top: 6, right: 10, bottom: 6), // Padding inferior ajustado para evitar overflow
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        SizedBox(
                                          height: 30.0, // Altura fija para 2 líneas (ligeramente reducida para evitar overflow)
                                          child: Text(
                                            event.title,
                                            style: TextStyle(
                                              fontWeight: FontWeight.w600,
                                              fontSize: 13,
                                              height: 1.2,
                                              color: isPast
                                                  ? Theme.of(context).disabledColor
                                                  : Theme.of(context).colorScheme.onSurface,
                                            ),
                                            maxLines: 2, // Dos líneas máximo
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                        const SizedBox(height: 4), // Reducido de 5 a 4
                                        // Fecha/Hora y Ubicación (Ciudad) con tamaño menor y color gris medio
                                        Text(
                                          () {
                                            final fullDate = DateFormat('dd MMM', 'es').format(event.startsAt);
                                            final fullHour = DateFormat('HH:mm').format(event.startsAt);
                                            final location = event.cityName ?? '';
                                            if (location.isNotEmpty) {
                                              return "$fullDate · $fullHour · $location";
                                            }
                                            return "$fullDate · $fullHour";
                                          }(),
                                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                            fontSize: 10,
                                            height: 1.1,
                                            color: Theme.of(context).colorScheme.onSurfaceVariant.withOpacity(0.7),
                                          ),
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ],
                                    ),
                                    // Chips de categoría (discreto, con baja opacidad) - Light Pill Style
                                    // Reservar espacio para hasta 2 categorías + espacio visual
                                    Padding(
                                      padding: const EdgeInsets.only(top: 1), // Espacio entre texto y chips
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          // Primera categoría (si existe)
                                          if (widget.showCategory && event.categoryName != null)
                                            Container(
                                              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 1),
                                              decoration: BoxDecoration(
                                                color: _getChipColor(context, event, categoryColor.withOpacity(0.12)),
                                                borderRadius: BorderRadius.circular(12),
                                              ),
                                              child: Text(
                                                event.categoryName!,
                                                style: TextStyle(
                                                  color: _getChipTextColor(context, event, _darkenColor(categoryColor, 0.3)),
                                                  fontSize: 9,
                                                  fontWeight: FontWeight.w600,
                                                  letterSpacing: 0.1,
                                                ),
                                                maxLines: 1,
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                            ),
                                          // Espacio entre primera y segunda categoría
                                          const SizedBox(height: 4), // Espacio entre categorías
                                          // Segunda categoría (placeholder para futura implementación)
                                          // Aquí se mostrará la segunda categoría cuando se implemente múltiples categorías
                                          const SizedBox(height: 4), // Espacio visual adicional para mantener distancia
                                        ],
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
