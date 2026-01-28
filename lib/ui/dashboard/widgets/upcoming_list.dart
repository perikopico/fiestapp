import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show debugPrint, kDebugMode;
import 'package:intl/intl.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:geolocator/geolocator.dart';
import '../../../models/event.dart';
import '../../icons/icon_mapper.dart';
import '../../event/event_detail_screen.dart';
import '../../../services/favorites_service.dart';
import '../../../services/notification_alerts_service.dart';
import '../../../services/category_service.dart';
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
  final CategoryService _categoryService = CategoryService();
  // Cache para distancias calculadas (evita recalcular en cada rebuild)
  final Map<String, Future<double?>> _distanceCache = {};

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
  Widget _buildCityHeader(BuildContext context, CityEventGroup group, {bool isFirst = false}) {
    // Solo mostrar el nombre de la ciudad (sin distancia)
    String headerText = group.cityName;
    
    // Margen superior reducido para el primer grupo (16px) y normal para los demás (24px)
    final topPadding = isFirst ? 16.0 : 24.0;
    
    // Solo mostrar campana si hay cityId
    if (group.cityId == null) {
      return Padding(
        padding: EdgeInsets.fromLTRB(12, topPadding, 12, 12), // Padding horizontal alineado con tarjetas
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
          padding: EdgeInsets.fromLTRB(12, topPadding, 12, 12), // Padding horizontal alineado con tarjetas
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
    
    // Si está desmarcando (newValue = false), siempre desuscribir directamente
    if (!newValue) {
      await _alertsService.setCityFollowed(cityId, false);
      // NOTA: NO desactivar la categoría automáticamente, ya que puede estar activa
      // para otras ciudades. La categoría se gestiona independientemente.
      
      if (!mounted) return;
      setState(() {});
      
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Has dejado de seguir esta ciudad'),
            duration: Duration(seconds: 2),
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
      return;
    }
    
    // Si está marcando (newValue = true):
    // CASO A: No hay filtro de categoría activo
    if (widget.selectedCategoryId == null) {
      // Suscribir directamente a la ciudad
      await _alertsService.setCityFollowed(cityId, true);
      
      if (!mounted) return;
      // Actualizar UI
      setState(() {});
      
      // Mostrar feedback visual
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('¡Listo! Te avisaremos de eventos en esta ciudad'),
            duration: Duration(seconds: 2),
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    } else {
      // CASO B: Hay filtro de categoría activo
      // Mostrar diálogo con opciones
      await _showNotificationOptionsDialog(context, cityId, newValue);
    }
  }
  
  /// Muestra un diálogo modal con opciones de suscripción cuando hay filtro de categoría
  Future<void> _showNotificationOptionsDialog(
    BuildContext context,
    int cityId,
    bool isCurrentlyFollowing,
  ) async {
    // Obtener nombre de la categoría
    String categoryName = 'esta categoría';
    try {
      final categories = await _categoryService.fetchAll();
      if (categories.isNotEmpty) {
        final selectedCategory = categories.firstWhere(
          (c) => c.id == widget.selectedCategoryId,
          orElse: () => categories.first,
        );
        categoryName = selectedCategory.name;
      }
    } catch (e) {
      // Si hay error, usar texto genérico
    }
    
    if (!context.mounted) return;
    
    final result = await showModalBottomSheet<String>(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Header
            Padding(
              padding: const EdgeInsets.all(16),
              child: Text(
                '¿Cómo quieres recibir notificaciones?',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            const Divider(height: 1),
            // Opción 1: Solo categoría actual
            ListTile(
              leading: const Icon(Icons.category),
              title: Text('Avisarme solo de eventos de $categoryName'),
              subtitle: const Text('Solo recibirás notificaciones de esta categoría en esta ciudad'),
              onTap: () => Navigator.of(context).pop('category_only'),
            ),
            const Divider(height: 1),
            // Opción 2: Todos los eventos
            ListTile(
              leading: const Icon(Icons.notifications),
              title: const Text('Avisarme de TODOS los eventos en esta ciudad'),
              subtitle: const Text('Recibirás notificaciones de todas las categorías'),
              onTap: () => Navigator.of(context).pop('all_events'),
            ),
            const Divider(height: 1),
            // Opción 3: Cancelar
            ListTile(
              leading: const Icon(Icons.cancel),
              title: const Text('Cancelar'),
              onTap: () => Navigator.of(context).pop('cancel'),
            ),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
    
    if (!context.mounted || result == null || result == 'cancel') {
      return;
    }
    
    // Procesar la opción seleccionada
    if (result == 'category_only') {
      // Suscribir a la categoría específica en esta ciudad
      await _subscribeToCategoryInCity(context, cityId, widget.selectedCategoryId!, categoryName);
    } else if (result == 'all_events') {
      // Suscribir a todos los eventos de la ciudad
      await _alertsService.setCityFollowed(cityId, true);
      if (!mounted) return;
      setState(() {});
      
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('¡Listo! Te avisaremos de todos los eventos en esta ciudad'),
            duration: Duration(seconds: 2),
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    }
  }
  
  /// Suscribe al usuario a notificaciones de una categoría específica en una ciudad
  Future<void> _subscribeToCategoryInCity(
    BuildContext context,
    int cityId,
    int categoryId,
    String categoryName,
  ) async {
    try {
      // Suscribir a la categoría
      await _alertsService.setCategoryAlertEnabled(categoryId, true);
      
      // También suscribir a la ciudad (necesario para recibir notificaciones)
      await _alertsService.setCityFollowed(cityId, true);
      
      if (!mounted) return;
      setState(() {});
      
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('¡Listo! Te avisaremos de eventos de $categoryName en esta ciudad'),
            duration: const Duration(seconds: 2),
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error al configurar notificaciones: ${e.toString()}'),
            duration: const Duration(seconds: 3),
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
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
          // Lista de eventos agrupados por ciudad (texto redundante eliminado)
          ...nonEmptyGroups.asMap().entries.expand((entry) {
            final index = entry.key;
            final group = entry.value;
            final isFirst = index == 0;
            
            // Filtrar eventos por categoría si hay filtro activo
            // Verificar tanto la categoría principal como las secundarias
            final filteredEvents = widget.selectedCategoryId == null
                ? group.events
                : group.events.where((e) {
                    // Verificar categoría principal
                    if (e.categoryId == widget.selectedCategoryId) return true;
                    // Verificar categorías secundarias
                    if (e.categoryIds != null && e.categoryIds!.contains(widget.selectedCategoryId)) return true;
                    return false;
                  }).toList();
            
            if (filteredEvents.isEmpty) return <Widget>[];
            
            return [
              _buildCityHeader(context, group, isFirst: isFirst),
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
  
  /// Construye la lista de eventos para una sección (layout horizontal)
  Widget _buildEventsGrid(BuildContext context, List<Event> events) {
    return ValueListenableBuilder<Set<String>>(
      valueListenable: FavoritesService.instance.favoritesNotifier,
      builder: (context, favorites, _) {
        return ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 12), // mx-3 (12px) para maximizar ancho
          itemCount: events.length,
          separatorBuilder: (context, index) => const SizedBox(height: 12),
          itemBuilder: (context, index) {
            return _buildEventCard(context, events[index]);
          },
        );
      },
    );
  }
  
  /// Obtiene la distancia desde el cache o la calcula si no existe
  Future<double?> _getCachedDistance(Event event) {
    // Si ya está en cache, retornar el Future existente
    if (_distanceCache.containsKey(event.id)) {
      return _distanceCache[event.id]!;
    }
    
    // Calcular y guardar en cache
    final future = _calculateEventDistance(event);
    _distanceCache[event.id] = future;
    return future;
  }
  
  /// Calcula la distancia desde el usuario al evento específico
  /// IMPORTANTE: Solo calcula usando las coordenadas del evento (event.lat, event.lng)
  /// NO usa event.distanceKm que es la distancia a la ciudad, no al evento
  Future<double?> _calculateEventDistance(Event event) async {
    // SOLO calcular si el evento tiene coordenadas específicas
    // Si no tiene coordenadas, retornar null (no mostrar distancia)
    debugPrint('🔍 Calculando distancia para evento ${event.id} - lat: ${event.lat}, lng: ${event.lng}');
    if (event.lat == null || event.lng == null) {
      debugPrint('⚠️ Evento ${event.id} (${event.title}) no tiene coordenadas (lat: ${event.lat}, lng: ${event.lng})');
      return null;
    }
    
    try {
      // Verificar permisos de ubicación
      final permission = await Geolocator.checkPermission();
      if (permission != LocationPermission.whileInUse && 
          permission != LocationPermission.always) {
        debugPrint('⚠️ Sin permisos de ubicación para calcular distancia del evento ${event.id}');
        return null;
      }
      
      // Obtener ubicación actual del usuario
      final position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.medium,
      );
      
      // Calcular distancia en metros y convertir a kilómetros
      // Usar las coordenadas específicas del evento (event.lat, event.lng)
      // Esto calcula la distancia al lugar marcado en maps del evento, no a la ciudad
      final distanceInMeters = Geolocator.distanceBetween(
        position.latitude,
        position.longitude,
        event.lat!,
        event.lng!,
      );
      
      final distanceKm = distanceInMeters / 1000; // Convertir a km
      debugPrint('✅ Distancia calculada para evento ${event.id}: ${distanceKm.toStringAsFixed(2)} km');
      return distanceKm;
    } catch (e) {
      // Si hay error al obtener ubicación, no mostrar distancia
      debugPrint('❌ Error al calcular distancia para evento ${event.id}: $e');
      return null;
    }
  }
  
  /// Construye una tarjeta de evento con layout horizontal
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
      color: Colors.white, // Fondo blanco explícito para contraste con fondo gris
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
              // IZQUIERDA: Imagen del evento (cuadrada, ratio 4:3)
              SizedBox(
                width: 100,
                height: 100,
                child: Stack(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: _buildEventImage(context, event, 100, 100),
                    ),
                    // Botón de favorito en la esquina superior izquierda
                    Positioned(
                      top: 4,
                      left: 4,
                      child: Material(
                        color: Colors.transparent,
                        child: InkWell(
                          onTap: () async {
                            final wasFavorite = FavoritesService.instance.isFavorite(event.id);
                            await FavoritesService.instance.toggleFavorite(event.id);
                            if (mounted) {
                              setState(() {});
                              // Mostrar mensaje de confirmación
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                    wasFavorite
                                        ? 'Eliminado de favoritos'
                                        : 'Guardado en favoritos. Te avisaremos antes del evento',
                                  ),
                                  duration: const Duration(seconds: 2),
                                ),
                              );
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
                              size: 14,
                              color: isFavorite ? Colors.red : Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              // DERECHA: Columna de información
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Línea 1: Título del evento (Font-bold, text-gray-900)
                    Text(
                      event.title,
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                        height: 1.3,
                        color: isPast
                            ? Theme.of(context).disabledColor
                            : const Color(0xFF111827), // text-gray-900
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 6),
                    // Línea 2: Chips de categoría (si showCategory es true)
                    if (widget.showCategory && (event.categoryName != null || event.allCategories.isNotEmpty))
                      Padding(
                        padding: const EdgeInsets.only(bottom: 6),
                        child: Wrap(
                          spacing: 4,
                          runSpacing: 4,
                          children: _buildCategoryChipsForWrap(context, event, categoryColor),
                        ),
                      ),
                    // Línea 3: Icono de Pin + Nombre del Lugar (text-gray-500, text-xs)
                    if (event.place != null && event.place!.isNotEmpty)
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.place,
                            size: 14,
                            color: const Color(0xFF6B7280).withOpacity(0.8), // text-gray-500
                          ),
                          const SizedBox(width: 4),
                          Expanded(
                            child: Text(
                              event.place!,
                              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                color: const Color(0xFF6B7280), // text-gray-500
                                fontSize: 12, // text-xs
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    const SizedBox(height: 8),
                    // Línea 3 (Footer): Fecha formateada + Distancia (chip minimalista)
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        // Fecha con día de la semana (text-gray-600, nítida)
                        Text(
                          event.formattedDateWithWeekday,
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: isPast
                                ? Theme.of(context).disabledColor
                                : const Color(0xFF4B5563), // text-gray-600
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        // Distancia (como chip/pastilla pequeña)
                        // Verificar primero si el evento tiene coordenadas antes de calcular
                        Builder(
                          builder: (context) {
                            // Si el evento no tiene coordenadas, no mostrar nada
                            if (event.lat == null || event.lng == null) {
                              if (kDebugMode) {
                                debugPrint('⚠️ Evento ${event.id} (${event.title.substring(0, event.title.length > 30 ? 30 : event.title.length)}...) no tiene coordenadas');
                              }
                              return const SizedBox.shrink();
                            }
                            
                            // Si tiene coordenadas, calcular y mostrar distancia
                            return FutureBuilder<double?>(
                              future: _getCachedDistance(event),
                              builder: (context, snapshot) {
                                // Mostrar mientras carga
                                if (snapshot.connectionState == ConnectionState.waiting) {
                                  return const SizedBox(
                                    width: 16,
                                    height: 16,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                    ),
                                  );
                                }
                                
                                // Si hay error, mostrar un indicador de debug (solo en modo debug)
                                if (snapshot.hasError) {
                                  debugPrint('❌ Error en FutureBuilder de distancia para evento ${event.id}: ${snapshot.error}');
                                  return const SizedBox.shrink();
                                }
                                
                                final distanceKm = snapshot.data;
                                if (distanceKm != null && distanceKm > 0) {
                                  if (kDebugMode) {
                                    debugPrint('✅ Mostrando chip de distancia: ${distanceKm.toStringAsFixed(2)} km para evento ${event.id}');
                                  }
                                  final chipColor = isPast
                                      ? Theme.of(context).disabledColor.withOpacity(0.15)
                                      : const Color(0xFF2563EB).withOpacity(0.15); // Azul más visible
                                  final textColor = isPast
                                      ? Theme.of(context).disabledColor
                                      : const Color(0xFF1D4ED8); // Azul un poco más intenso
                                  
                                  return Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                    decoration: BoxDecoration(
                                      color: chipColor,
                                      borderRadius: BorderRadius.circular(12),
                                      border: Border.all(
                                        color: isPast
                                            ? Theme.of(context).disabledColor.withOpacity(0.3)
                                            : const Color(0xFF2563EB).withOpacity(0.3),
                                        width: 1,
                                      ),
                                    ),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Icon(
                                          Icons.location_on,
                                          size: 13,
                                          color: textColor,
                                        ),
                                        const SizedBox(width: 4),
                                        Text(
                                          '${distanceKm.round()} km',
                                          style: TextStyle(
                                            color: textColor,
                                            fontSize: 11,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
                                }
                                // Si no hay distancia calculada (permisos denegados, error, etc.)
                                if (kDebugMode) {
                                  debugPrint('⚠️ No se pudo calcular distancia para evento ${event.id} (permisos o error)');
                                }
                                return const SizedBox.shrink();
                              },
                            );
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
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
