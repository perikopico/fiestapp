import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../../models/event.dart';
import '../../icons/icon_mapper.dart';
import '../../event/event_detail_screen.dart';
import '../../../services/favorites_service.dart';
import '../../../services/notification_alerts_service.dart';
import '../../../utils/accessibility_utils.dart';
import '../dashboard_screen.dart'; // Para CityEventGroup
import 'package:flutter/services.dart';

class UpcomingList extends StatefulWidget {
  final List<CityEventGroup>? eventsByCity;
  final List<Event>? events; // Mantener por compatibilidad temporal
  final int? selectedCategoryId;
  final VoidCallback? onClearFilters;
  final bool showCategory;
  // Texto del filtro de fecha activo
  final String? dateFilterText;
  // Información de búsqueda activa
  final bool hasActiveSearch;
  final String? searchTerm;

  const UpcomingList({
    super.key,
    this.eventsByCity,
    this.events,
    this.selectedCategoryId,
    this.onClearFilters,
    this.showCategory = true,
    this.dateFilterText,
    this.hasActiveSearch = false,
    this.searchTerm,
  });

  @override
  State<UpcomingList> createState() => _UpcomingListState();
}

class _UpcomingListState extends State<UpcomingList> {
  final NotificationAlertsService _alertsService = NotificationAlertsService.instance;

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

  /// Construye chips de categorías (soporta múltiples categorías)
  List<Widget> _buildCategoryChips(BuildContext context, Event event, Color defaultColor) {
    final List<Widget> chips = [];
    
    // Obtener todas las categorías del evento
    final allCategories = event.allCategories;
    
    if (allCategories.isEmpty) {
      // Fallback a categoría principal si no hay categorías múltiples
      if (event.categoryName != null) {
        final categoryColor = event.categoryColor != null && event.categoryColor!.isNotEmpty
            ? (() {
                try {
                  return Color(int.parse(event.categoryColor!.replaceFirst('#', '0xFF')));
                } catch (e) {
                  return _getColorForCategory(event.categoryName!);
                }
              })()
            : _getColorForCategory(event.categoryName!);
        
        chips.add(
          const SizedBox(width: 6),
        );
        chips.add(
          Flexible(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(
                color: _getChipColor(context, event, categoryColor).withOpacity(0.2),
                borderRadius: BorderRadius.circular(4),
              ),
              child: Text(
                event.categoryName!,
                style: Theme.of(context).textTheme.labelSmall?.copyWith(
                  color: _getChipTextColor(context, event, categoryColor),
                  fontSize: 9,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ),
        );
      }
      return chips;
    }
    
    // Mostrar todas las categorías (máximo 2)
    for (int i = 0; i < allCategories.length && i < 2; i++) {
      final category = allCategories[i];
      final categoryName = category['name'] as String?;
      final categoryColorStr = category['color'] as String?;
      
      if (categoryName == null) continue;
      
      final categoryColor = categoryColorStr != null && categoryColorStr.isNotEmpty
          ? (() {
              try {
                return Color(int.parse(categoryColorStr.replaceFirst('#', '0xFF')));
              } catch (e) {
                return _getColorForCategory(categoryName);
              }
            })()
          : _getColorForCategory(categoryName);
      
      if (i > 0) {
        chips.add(const SizedBox(width: 4));
      } else {
        chips.add(const SizedBox(width: 6));
      }
      
      chips.add(
        Flexible(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
            decoration: BoxDecoration(
              color: _getChipColor(context, event, categoryColor).withOpacity(0.2),
              borderRadius: BorderRadius.circular(4),
            ),
            child: Text(
              categoryName,
              style: Theme.of(context).textTheme.labelSmall?.copyWith(
                color: _getChipTextColor(context, event, categoryColor),
                fontSize: 9,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ),
      );
    }
    
    return chips;
  }

  /// Construye chips de categorías para usar en Wrap (sin Flexible, para que se vean completos)
  List<Widget> _buildCategoryChipsForWrap(BuildContext context, Event event, Color defaultColor) {
    final List<Widget> chips = [];
    
    // Obtener todas las categorías del evento
    final allCategories = event.allCategories;
    
    if (allCategories.isEmpty) {
      // Fallback a categoría principal si no hay categorías múltiples
      if (event.categoryName != null) {
        final categoryColor = event.categoryColor != null && event.categoryColor!.isNotEmpty
            ? (() {
                try {
                  return Color(int.parse(event.categoryColor!.replaceFirst('#', '0xFF')));
                } catch (e) {
                  return _getColorForCategory(event.categoryName!);
                }
              })()
            : _getColorForCategory(event.categoryName!);
        
        chips.add(
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
            decoration: BoxDecoration(
              color: _getChipColor(context, event, categoryColor).withOpacity(0.2),
              borderRadius: BorderRadius.circular(4),
            ),
            child: Text(
              event.categoryName!,
              style: Theme.of(context).textTheme.labelSmall?.copyWith(
                color: _getChipTextColor(context, event, categoryColor),
                fontSize: 9,
              ),
            ),
          ),
        );
      }
      return chips;
    }
    
    // Mostrar todas las categorías (máximo 2)
    for (int i = 0; i < allCategories.length && i < 2; i++) {
      final category = allCategories[i];
      final categoryName = category['name'] as String?;
      final categoryColorStr = category['color'] as String?;
      
      if (categoryName == null) continue;
      
      final categoryColor = categoryColorStr != null && categoryColorStr.isNotEmpty
          ? (() {
              try {
                return Color(int.parse(categoryColorStr.replaceFirst('#', '0xFF')));
              } catch (e) {
                return _getColorForCategory(categoryName);
              }
            })()
          : _getColorForCategory(categoryName);
      
      chips.add(
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
          decoration: BoxDecoration(
            color: _getChipColor(context, event, categoryColor).withOpacity(0.2),
            borderRadius: BorderRadius.circular(4),
          ),
          child: Text(
            categoryName,
            style: Theme.of(context).textTheme.labelSmall?.copyWith(
              color: _getChipTextColor(context, event, categoryColor),
              fontSize: 9,
            ),
          ),
        ),
      );
    }
    
    return chips;
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

  /// Construye el header de sección para una ciudad con icono de campana
  Widget _buildCityHeader(BuildContext context, CityEventGroup group) {
    String headerText = group.cityName;
    if (group.isUserLocation) {
      headerText = '${group.cityName} · Tu ubicación';
    } else if (group.distanceKm != null) {
      headerText = '${group.cityName} · ${group.distanceKm!.round()} km';
    }
    
    // Solo mostrar campana si hay cityId
    if (group.cityId == null) {
      return Padding(
        padding: const EdgeInsets.fromLTRB(16, 20, 16, 12),
        child: Text(
          headerText,
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
            color: Theme.of(context).colorScheme.onSurface,
          ),
        ),
      );
    }
    
    return FutureBuilder<bool>(
      future: _alertsService.isCityFollowed(group.cityId!),
      builder: (context, snapshot) {
        final isFollowing = snapshot.data ?? false;
        
        return Padding(
          padding: const EdgeInsets.fromLTRB(16, 20, 16, 12),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  headerText,
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
                ),
              ),
              IconButton(
                icon: Icon(
                  isFollowing ? Icons.notifications : Icons.notifications_outlined,
                  color: isFollowing
                      ? Theme.of(context).colorScheme.primary
                      : Theme.of(context).colorScheme.onSurfaceVariant,
                ),
                onPressed: () => _toggleCityFollowing(context, group.cityId!, !isFollowing),
                tooltip: isFollowing ? 'Dejar de seguir ciudad' : 'Seguir ciudad',
              ),
            ],
          ),
        );
      },
    );
  }
  
  Future<void> _toggleCityFollowing(BuildContext context, int cityId, bool newValue) async {
    // Feedback háptico
    HapticFeedback.lightImpact();
    
    // Guardar en persistencia
    await _alertsService.setCityFollowed(cityId, newValue);
    
    // Actualizar UI
    setState(() {});
    
    // Mostrar feedback visual
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            newValue
                ? '¡Listo! Te avisaremos de eventos en esta ciudad'
                : 'Has dejado de seguir esta ciudad',
          ),
          duration: const Duration(seconds: 2),
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    // Usar eventos agrupados por ciudad si están disponibles
    final eventsByCity = widget.eventsByCity;
    final events = widget.events ?? [];
    
    // Si hay eventos agrupados por ciudad, usar esa estructura
    if (eventsByCity != null) {
      // Filtrar grupos que tengan eventos (no mostrar ciudades vacías)
      final nonEmptyGroups = eventsByCity.where((group) => group.events.isNotEmpty).toList();
      
      if (nonEmptyGroups.isEmpty) {
        return _buildEmptyState(context);
      }
      
      return Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Cabecera con filtro de fecha y botón "Borrar filtros"
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
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
          // Lista de eventos agrupados por ciudad
          ...nonEmptyGroups.expand((group) {
            // Filtrar eventos por categoría si hay filtro activo
            final filteredEvents = widget.selectedCategoryId == null
                ? group.events
                : group.events.where((e) => e.categoryId == widget.selectedCategoryId).toList();
            
            if (filteredEvents.isEmpty) return <Widget>[];
            
            return [
              _buildCityHeader(context, group),
              _buildEventsGrid(context, filteredEvents),
            ];
          }),
        ],
      );
    }
    
    // Fallback: usar lista plana de eventos (compatibilidad temporal)
    if (events.isEmpty) {
      return _buildEmptyState(context);
    }
    
    // Mantener lógica original para eventos planos (compatibilidad)
    return _buildLegacyEventsList(context, events);
  }
  
  /// Construye el estado vacío
  Widget _buildEmptyState(BuildContext context) {
    if (!widget.hasActiveSearch) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 48, horizontal: 24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.search_off,
                size: 64,
                color: Theme.of(context).colorScheme.onSurfaceVariant.withOpacity(0.5),
              ),
              const SizedBox(height: 16),
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
    
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 32, horizontal: 24),
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
                'Prueba cambiando de ciudad o categoría.',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
                textAlign: TextAlign.center,
              ),
            ],
            const SizedBox(height: 16),
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
  
  /// Construye el grid de eventos para una sección
  Widget _buildEventsGrid(BuildContext context, List<Event> events) {
    return ValueListenableBuilder<Set<String>>(
      valueListenable: FavoritesService.instance.favoritesNotifier,
      builder: (context, favorites, _) {
        return GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 16),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 12,
            mainAxisSpacing: 8,
            childAspectRatio: 0.72, // Reducido aún más para dar espacio extra al título
          ),
          itemCount: events.length,
          itemBuilder: (context, index) {
            return _buildEventCard(context, events[index]);
          },
        );
      },
    );
  }
  
  /// Construye una tarjeta de evento (extraído de la lógica original)
  Widget _buildEventCard(BuildContext context, Event event) {
    final isFavorite = FavoritesService.instance.isFavorite(event.id);
    
    // Obtener color de categoría
    Color categoryColor = Colors.grey;
    if (event.categoryColor != null && event.categoryColor!.isNotEmpty) {
      try {
        categoryColor = Color(int.parse(event.categoryColor!.replaceFirst('#', '0xFF')));
      } catch (e) {
        if (event.categoryName != null) {
          categoryColor = _getColorForCategory(event.categoryName!);
        }
      }
    } else if (event.categoryName != null) {
      categoryColor = _getColorForCategory(event.categoryName!);
    }
    
    final isPast = event.isPast;
    
    return Card(
      margin: EdgeInsets.zero,
      elevation: 2,
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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Imagen del evento
            Expanded(
              flex: 5,
              child: Stack(
                children: [
                  _buildEventImage(context, event, double.infinity, double.infinity),
                  // Botón de favorito en la esquina superior izquierda
                  Positioned(
                    top: 8,
                    left: 8,
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
                          padding: const EdgeInsets.all(4),
                          decoration: BoxDecoration(
                            color: Colors.black.withOpacity(0.5),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            isFavorite ? Icons.favorite : Icons.favorite_border,
                            size: 16,
                            color: isFavorite ? Colors.red : Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ),
                  // Badge de kilómetros en la esquina superior derecha
                  if (event.distanceKm != null)
                    Positioned(
                      top: 8,
                      right: 8,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.7),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.location_on,
                              size: 14,
                              color: Colors.white,
                            ),
                            const SizedBox(width: 2),
                            Text(
                              '${event.distanceKm!.round()} km',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 11,
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
            // Información del evento
            Expanded(
              flex: 3,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Título - doble espacio para el nombre (más líneas permitidas)
                    Expanded(
                      flex: 4,
                      child: Text(
                        event.title,
                        style: Theme.of(context).textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.w600,
                          fontSize: 14,
                          height: 1.4, // Aumentado para mejor espaciado entre líneas
                          color: isPast
                              ? Theme.of(context).disabledColor
                              : Theme.of(context).colorScheme.onSurface,
                        ),
                        maxLines: 3, // Aumentado a 3 líneas para evitar cortes
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const SizedBox(height: 3),
                    // Fecha en una línea
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.calendar_today,
                          size: 11,
                          color: isPast
                              ? Theme.of(context).disabledColor
                              : Theme.of(context).colorScheme.onSurfaceVariant,
                        ),
                        const SizedBox(width: 4),
                        Flexible(
                          child: Text(
                            DateFormat('d MMM', 'es').format(event.startsAt),
                            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: isPast
                                  ? Theme.of(context).disabledColor
                                  : Theme.of(context).colorScheme.onSurfaceVariant,
                              fontSize: 10,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                    // Categorías en una línea separada debajo
                    if (widget.showCategory) ...[
                      const SizedBox(height: 2),
                      Wrap(
                        spacing: 4,
                        runSpacing: 2,
                        children: _buildCategoryChipsForWrap(context, event, categoryColor),
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
  
  /// Construye la lista legacy de eventos (compatibilidad)
  Widget _buildLegacyEventsList(BuildContext context, List<Event> events) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Cabecera con filtro de fecha y botón "Borrar filtros"
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
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
        _buildEventsGrid(context, events),
      ],
    );
  }
}
