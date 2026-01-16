import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';

import 'package:url_launcher/url_launcher.dart';
import 'package:share_plus/share_plus.dart';
import 'package:add_2_calendar/add_2_calendar.dart' as add2cal;
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../models/event.dart';
import '../icons/icon_mapper.dart';
import 'fullscreen_image_screen.dart';
import '../../services/favorites_local_service.dart';
import '../../services/event_service.dart';
import '../../services/report_service.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class EventDetailScreen extends StatefulWidget {
  final Event event;

  const EventDetailScreen({super.key, required this.event});

  @override
  State<EventDetailScreen> createState() => _EventDetailScreenState();
}

class _EventDetailScreenState extends State<EventDetailScreen> {
  bool _isFavorite = false;

  @override
  void initState() {
    super.initState();
    _loadFavoriteStatus();
    // Incrementar contador de vistas al abrir el evento
    EventService.instance.incrementEventView(widget.event.id);
    // Debug: verificar si el evento tiene infoUrl
    debugPrint('🔍 Evento ${widget.event.id} - infoUrl: ${widget.event.infoUrl}');
  }

  Future<void> _loadFavoriteStatus() async {
    final isFav = await FavoritesLocalService.instance.isFavorite(widget.event.id);
    if (mounted) {
      setState(() {
        _isFavorite = isFav;
      });
    }
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

  /// Extrae las coordenadas lat/lng del mapsUrl del evento
  LatLng? _extractCoordinatesFromMapsUrl(String? mapsUrl) {
    if (mapsUrl == null || mapsUrl.isEmpty) return null;
    
    try {
      final uri = Uri.parse(mapsUrl);
      final query = uri.queryParameters;
      if (query.containsKey('query')) {
        final coords = query['query']!.split(',');
        if (coords.length == 2) {
          final lat = double.tryParse(coords[0]);
          final lng = double.tryParse(coords[1]);
          if (lat != null && lng != null) {
            return LatLng(lat, lng);
          }
        }
      }
    } catch (e) {
      debugPrint('Error al extraer coordenadas del mapsUrl: $e');
    }
    return null;
  }

  /// Abre Google Maps con direcciones al evento
  Future<void> _openDirections() async {
    final coordinates = _extractCoordinatesFromMapsUrl(widget.event.mapsUrl);
    if (coordinates == null) {
      // Si no hay coordenadas, usar el mapsUrl normal
      if (widget.event.mapsUrl != null && widget.event.mapsUrl!.isNotEmpty) {
        final uri = Uri.parse(widget.event.mapsUrl!);
        if (await canLaunchUrl(uri)) {
          await launchUrl(uri, mode: LaunchMode.externalApplication);
        }
      }
      return;
    }

    // Construir URL de Google Maps con direcciones
    final directionsUrl = 'https://www.google.com/maps/dir/?api=1&destination=${coordinates.latitude},${coordinates.longitude}';
    final uri = Uri.parse(directionsUrl);
    
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  /// Verifica si el evento tiene fecha/hora válida
  /// TODO: Reemplazar con flag real del modelo cuando se implemente
  bool get _hasValidDateTime {
    // Por ahora, asumimos que todos los eventos tienen fecha
    // En el futuro, esto debería verificar un flag como event.hasDate o similar
    return true; // TODO: Implementar lógica real cuando se agregue el flag al modelo
  }

  /// Verifica si el precio indica que el evento es gratis
  bool _isPriceFree(String price) {
    final priceLower = price.toLowerCase().trim();
    return priceLower == 'gratis' || 
           priceLower == 'gratuito' ||
           priceLower == 'libre' ||
           priceLower.startsWith('gratis');
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final hasMapsUrl = widget.event.mapsUrl != null && widget.event.mapsUrl!.isNotEmpty;
    final shareText = [
      '${widget.event.title} - ${widget.event.cityName ?? ''}'.trim(),
      (widget.event.place ?? '').trim(),
      '${widget.event.formattedDate} ${widget.event.formattedTime}'.trim(),
      (widget.event.mapsUrl ?? '').trim(),
    ].where((s) => s.isNotEmpty).join('\n');

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        title: const Text('Detalle del evento'),
        centerTitle: true,
        elevation: 0,
        backgroundColor: theme.colorScheme.surface,
        actions: [
          IconButton(
            icon: Icon(
              _isFavorite ? Icons.favorite : Icons.favorite_border,
              color: _isFavorite
                  ? theme.colorScheme.error
                  : theme.colorScheme.onSurface,
            ),
            onPressed: () async {
              await FavoritesLocalService.instance.toggleFavorite(widget.event.id);
              if (mounted) {
                setState(() {
                  _isFavorite = !_isFavorite;
                });
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      _isFavorite
                          ? 'Añadido a favoritos'
                          : 'Eliminado de favoritos',
                    ),
                    duration: const Duration(seconds: 2),
                  ),
                );
              }
            },
            tooltip: _isFavorite ? 'Quitar de favoritos' : 'Añadir a favoritos',
          ),
          PopupMenuButton<String>(
            icon: const Icon(Icons.more_vert),
            onSelected: (value) {
              if (value == 'report') {
                _showReportDialog();
              }
            },
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: 'report',
                child: Row(
                  children: [
                    Icon(Icons.flag, color: Colors.red, size: 20),
                    SizedBox(width: 8),
                    Text('Reportar evento'),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 32),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 1. Hero image
            _buildHeroImage(context, theme),
            const SizedBox(height: 16),

            // 2. Title + chips
            Text(
              widget.event.title,
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: 8),

            // Chips o pill para eventos sin fecha
            if (_hasValidDateTime) ...[
              _buildChipsRow(context, theme),
            ] else ...[
              _buildNoDatePill(context, theme),
            ],
            const SizedBox(height: 16),

            // 3. Description block
            _buildDescriptionSection(context, widget.event),

            // 3.5. Info URL block (si existe) - justo después de la descripción
            if (widget.event.infoUrl != null && widget.event.infoUrl!.isNotEmpty) ...[
              const SizedBox(height: 16),
              _buildInfoUrlSection(context, theme),
            ],

            const SizedBox(height: 16),

            // 4. Location / Map block
            _buildLocationSection(context, theme, hasMapsUrl),

            const SizedBox(height: 16),

            // 5. Compartir y añadir al calendario
            _buildActionButtons(context, theme, shareText),
          ],
        ),
      ),
    );
  }

  Widget _buildHeroImage(BuildContext context, ThemeData theme) {
    if (widget.event.imageUrl != null && widget.event.imageUrl!.isNotEmpty) {
      return Builder(
        builder: (context) {
          final size = MediaQuery.of(context).size;
          final isMobile = size.width < 600;
          final headerHeight = isMobile ? 320.0 : 260.0;
          
          return GestureDetector(
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => FullscreenImageScreen(imageUrl: widget.event.imageUrl!),
                ),
              );
            },
            child: SizedBox(
              height: headerHeight,
              width: double.infinity,
              child: Stack(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(0),
                    child: Hero(
                      tag: 'event-img-${widget.event.id}',
                      child: Image.network(
                        widget.event.imageUrl!,
                        width: double.infinity,
                        height: double.infinity,
                        fit: BoxFit.cover,
                        alignment: _alignmentFromString(widget.event.imageAlignment),
                        errorBuilder: (context, error, stackTrace) {
                          return Container(
                            color: theme.colorScheme.surfaceVariant,
                            alignment: Alignment.center,
                            child: Icon(
                              Icons.event,
                              size: 56,
                              color: theme.colorScheme.onSurfaceVariant,
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                  // Banner "Ampliar" encima de la imagen
                  Positioned(
                    top: 8,
                    right: 8,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.6),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(
                            Icons.fullscreen,
                            color: Colors.white,
                            size: 16,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            'Ampliar',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 12,
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
          );
        },
      );
    } else {
      return Builder(
        builder: (context) {
          final size = MediaQuery.of(context).size;
          final isMobile = size.width < 600;
          final headerHeight = isMobile ? 320.0 : 260.0;
          
          return SizedBox(
            height: headerHeight,
            width: double.infinity,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(0),
              child: Container(
                color: theme.colorScheme.surfaceVariant,
                alignment: Alignment.center,
                child: Icon(
                  Icons.event,
                  size: 56,
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
            ),
          );
        },
      );
    }
  }

  Widget _buildChipsRow(BuildContext context, ThemeData theme) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: [
        if (widget.event.cityName != null)
          Chip(
            label: Text(
              widget.event.cityName!,
              style: theme.textTheme.bodySmall,
            ),
            avatar: const Icon(Icons.place, size: 18),
            backgroundColor: theme.colorScheme.surfaceVariant,
            visualDensity: VisualDensity.compact,
          ),
        if (widget.event.categoryName != null)
          Chip(
            label: Text(
              widget.event.categoryName!,
              style: theme.textTheme.bodySmall,
            ),
            avatar: Icon(iconFromName(widget.event.categoryIcon), size: 18),
            backgroundColor: theme.colorScheme.surfaceVariant,
            visualDensity: VisualDensity.compact,
          ),
        Chip(
          label: Text(
            widget.event.formattedDateTime,
            style: theme.textTheme.bodySmall,
          ),
          avatar: const Icon(Icons.calendar_today, size: 18),
          backgroundColor: theme.colorScheme.surfaceVariant,
          visualDensity: VisualDensity.compact,
        ),
        // Precio - siempre mostrarlo si existe
        if (widget.event.price != null && widget.event.price!.isNotEmpty)
          Chip(
            label: Text(
              widget.event.price!,
              style: theme.textTheme.bodySmall?.copyWith(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: _isPriceFree(widget.event.price!)
                    ? theme.colorScheme.primary
                    : theme.colorScheme.onSurfaceVariant,
              ),
            ),
            avatar: Icon(
              _isPriceFree(widget.event.price!)
                  ? Icons.check_circle
                  : Icons.euro,
              size: 18,
              color: _isPriceFree(widget.event.price!)
                  ? theme.colorScheme.primary
                  : theme.colorScheme.onSurfaceVariant,
            ),
            backgroundColor: _isPriceFree(widget.event.price!)
                ? theme.colorScheme.primary.withOpacity(0.12)
                : theme.colorScheme.surfaceVariant,
            visualDensity: VisualDensity.compact,
          ),
      ],
    );
  }

  Widget _buildNoDatePill(BuildContext context, ThemeData theme) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: theme.colorScheme.primaryContainer.withOpacity(0.3),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: theme.colorScheme.primary.withOpacity(0.3),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.calendar_today,
            size: 16,
            color: theme.colorScheme.primary,
          ),
          const SizedBox(width: 6),
          Text(
            'Disponible todo el año',
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.primary,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLocationSection(BuildContext context, ThemeData theme, bool hasMapsUrl) {
    final coordinates = _extractCoordinatesFromMapsUrl(widget.event.mapsUrl);
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Título de la sección
        Text(
          'Ubicación',
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 12),

        // Mapa embebido (si hay coordenadas)
        if (coordinates != null) ...[
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Container(
              height: 180,
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: theme.colorScheme.outline.withOpacity(0.2),
                ),
              ),
              child: GoogleMap(
                initialCameraPosition: CameraPosition(
                  target: coordinates,
                  zoom: 15.0,
                ),
                markers: {
                  Marker(
                    markerId: MarkerId(widget.event.id),
                    position: coordinates,
                  ),
                },
                zoomControlsEnabled: false,
                myLocationButtonEnabled: false,
                mapToolbarEnabled: false,
                scrollGesturesEnabled: false,
                zoomGesturesEnabled: false,
                tiltGesturesEnabled: false,
                rotateGesturesEnabled: false,
              ),
            ),
          ),
          const SizedBox(height: 12),
        ],

        // Información del lugar
        if (widget.event.place != null && widget.event.place!.isNotEmpty) ...[
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            decoration: BoxDecoration(
              color: theme.colorScheme.surfaceVariant,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.location_on,
                  size: 20,
                  color: theme.colorScheme.onSurfaceVariant,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Lugar',
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant.withOpacity(0.7),
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        widget.event.place!,
                        style: theme.textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      if (widget.event.cityName != null) ...[
                        const SizedBox(height: 2),
                        Text(
                          widget.event.cityName!,
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: theme.colorScheme.onSurfaceVariant.withOpacity(0.7),
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
        ],

        // Botones de acción de mapa
        if (hasMapsUrl) ...[
          Row(
            children: [
              Expanded(
                child: FilledButton.icon(
                  onPressed: () async {
                    final uri = Uri.parse(widget.event.mapsUrl!);
                    if (await canLaunchUrl(uri)) {
                      await launchUrl(uri, mode: LaunchMode.externalApplication);
                    }
                  },
                  icon: const Icon(Icons.map, size: 20),
                  label: const Text('Ver en mapa'),
                  style: FilledButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: _openDirections,
                  icon: const Icon(Icons.directions, size: 20),
                  label: const Text('Cómo llegar'),
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ],
    );
  }

  Widget _buildActionButtons(BuildContext context, ThemeData theme, String shareText) {
    return Column(
      children: [
        // Botón compartir
        SizedBox(
          width: double.infinity,
          child: OutlinedButton.icon(
            onPressed: () {
              if (shareText.isNotEmpty) {
                // Obtener sharePositionOrigin para iOS
                Rect sharePositionOrigin = Rect.zero;
                try {
                  final RenderBox? box = context.findRenderObject() as RenderBox?;
                  if (box != null && box.hasSize) {
                    final position = box.localToGlobal(Offset.zero);
                    sharePositionOrigin = Rect.fromLTWH(
                      position.dx,
                      position.dy,
                      box.size.width,
                      box.size.height,
                    );
                  } else {
                    // Fallback: usar el centro de la pantalla
                    final screenSize = MediaQuery.of(context).size;
                    sharePositionOrigin = Rect.fromLTWH(
                      screenSize.width / 2,
                      screenSize.height / 2,
                      0,
                      0,
                    );
                  }
                } catch (e) {
                  debugPrint('Error al obtener sharePositionOrigin: $e');
                  // Fallback: usar el centro de la pantalla
                  final screenSize = MediaQuery.of(context).size;
                  sharePositionOrigin = Rect.fromLTWH(
                    screenSize.width / 2,
                    screenSize.height / 2,
                    0,
                    0,
                  );
                }
                Share.share(
                  shareText,
                  sharePositionOrigin: sharePositionOrigin,
                );
              }
            },
            icon: const Icon(Icons.ios_share),
            label: const Text('Compartir'),
            style: OutlinedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
        ),
        const SizedBox(height: 12),
        // Botón añadir al calendario
        SizedBox(
          width: double.infinity,
          child: TextButton.icon(
            onPressed: () async {
              final location = [
                widget.event.place,
                widget.event.cityName,
              ].where((s) => s != null && s.isNotEmpty).cast<String>().join(' · ');

              final calEvent = add2cal.Event(
                title: widget.event.title,
                description: widget.event.description ?? '',
                location: location,
                startDate: widget.event.startsAt,
                endDate: widget.event.startsAt.add(const Duration(hours: 2)),
              );

              await add2cal.Add2Calendar.addEvent2Cal(calEvent);
            },
            icon: const Icon(Icons.calendar_today),
            label: const Text('Añadir al calendario'),
          ),
        ),
      ],
    );
  }

  Widget _buildDescriptionSection(BuildContext context, Event event) {
    final theme = Theme.of(context);
    final desc = event.description ?? '';

    if (desc.isEmpty) {
      return const SizedBox.shrink();
    }

    // Separar descripción base de programación diaria
    String? mainDesc;
    String? programBlock;

    const marker = '\n\nProgramación:\n';
    if (desc.contains(marker)) {
      final parts = desc.split(marker);
      mainDesc = parts.first.trim();
      programBlock = parts.sublist(1).join(marker).trim();
    } else {
      mainDesc = desc.trim().isEmpty ? null : desc.trim();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (mainDesc != null && mainDesc.isNotEmpty) ...[
          const SizedBox(height: 8),
          Text(
            'Descripción',
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
            decoration: BoxDecoration(
              color: theme.colorScheme.surfaceVariant,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              mainDesc,
              style: theme.textTheme.bodyLarge?.copyWith(height: 1.5),
              softWrap: true,
              textAlign: TextAlign.start,
            ),
          ),
          const SizedBox(height: 16),
        ],
        if (programBlock != null && programBlock.isNotEmpty) ...[
          Text(
            'Programación',
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
            decoration: BoxDecoration(
              color: theme.colorScheme.surfaceVariant,
              borderRadius: BorderRadius.circular(12),
            ),
            child: _buildProgrammingItems(theme, programBlock),
          ),
          const SizedBox(height: 16),
        ],
      ],
    );
  }

  Widget _buildProgrammingItems(ThemeData theme, String programBlock) {
    final items = programBlock.split('\n').where((item) => item.trim().isNotEmpty).toList();
    
    if (items.isEmpty) {
      return const SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: items.asMap().entries.map((entry) {
        final index = entry.key;
        final item = entry.value.trim();
        return Padding(
          padding: EdgeInsets.only(bottom: index < items.length - 1 ? 8 : 0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 2, right: 8),
                child: Icon(
                  Icons.schedule,
                  size: 16,
                  color: theme.colorScheme.onSurfaceVariant.withOpacity(0.7),
                ),
              ),
              Expanded(
                child: Text(
                  item,
                  style: theme.textTheme.bodyMedium?.copyWith(height: 1.4),
                  softWrap: true,
                  textAlign: TextAlign.start,
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }

  Widget _buildInfoUrlSection(BuildContext context, ThemeData theme) {
    final infoUrl = widget.event.infoUrl;
    
    // Debug detallado
    debugPrint('🔍 _buildInfoUrlSection llamado');
    debugPrint('   Event ID: ${widget.event.id}');
    debugPrint('   infoUrl value: $infoUrl');
    debugPrint('   infoUrl is null: ${infoUrl == null}');
    debugPrint('   infoUrl isEmpty: ${infoUrl?.isEmpty ?? true}');
    
    if (infoUrl == null || infoUrl.isEmpty) {
      debugPrint('⚠️ infoUrl es null o vacío, no se muestra el enlace');
      return const SizedBox.shrink();
    }

    debugPrint('✅ Mostrando enlace: $infoUrl');

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Enlace de interés',
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 12),
        InkWell(
          onTap: () async {
            try {
              debugPrint('🔗 Abriendo enlace: $infoUrl');
              final uri = Uri.parse(infoUrl);
              if (await canLaunchUrl(uri)) {
                await launchUrl(uri, mode: LaunchMode.externalApplication);
              } else {
                if (!mounted) return;
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('No se pudo abrir el enlace: $infoUrl'),
                    backgroundColor: Colors.orange,
                  ),
                );
              }
            } catch (e) {
              debugPrint('❌ Error al abrir enlace: $e');
              if (!mounted) return;
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Error al abrir el enlace'),
                  backgroundColor: Colors.red,
                ),
              );
            }
          },
          borderRadius: BorderRadius.circular(12),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            decoration: BoxDecoration(
              color: theme.colorScheme.primaryContainer,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: theme.colorScheme.primary.withOpacity(0.3),
                width: 1.5,
              ),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.link,
                  color: theme.colorScheme.onPrimaryContainer,
                  size: 24,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Más información',
                        style: theme.textTheme.bodyLarge?.copyWith(
                          fontWeight: FontWeight.w600,
                          color: theme.colorScheme.onPrimaryContainer,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        _getDomainFromUrl(infoUrl),
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.onPrimaryContainer.withOpacity(0.7),
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                Icon(
                  Icons.open_in_new,
                  color: theme.colorScheme.onPrimaryContainer.withOpacity(0.7),
                  size: 20,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  String _getDomainFromUrl(String url) {
    try {
      final uri = Uri.parse(url);
      return uri.host;
    } catch (e) {
      return url;
    }
  }

  Future<void> _showReportDialog() async {
    final user = Supabase.instance.client.auth.currentUser;
    if (user == null) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Debes iniciar sesión para reportar contenido'),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    ReportReason? selectedReason;
    final descriptionController = TextEditingController();

    final result = await showDialog<bool>(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          title: const Text('Reportar evento'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('¿Por qué quieres reportar este evento?'),
                const SizedBox(height: 16),
                ...ReportReason.values.map((reason) => RadioListTile<ReportReason>(
                  title: Text(ReportService.getReasonText(reason)),
                  value: reason,
                  groupValue: selectedReason,
                  onChanged: (value) => setState(() => selectedReason = value),
                )),
                if (selectedReason == ReportReason.other || selectedReason != null) ...[
                  const SizedBox(height: 8),
                  TextField(
                    controller: descriptionController,
                    decoration: InputDecoration(
                      labelText: selectedReason == ReportReason.other
                          ? 'Describe el problema'
                          : 'Información adicional (opcional)',
                      hintText: 'Explica por qué reportas este evento...',
                      border: const OutlineInputBorder(),
                    ),
                    maxLines: 3,
                  ),
                ],
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text('Cancelar'),
            ),
            TextButton(
              onPressed: selectedReason == null
                  ? null
                  : () => Navigator.of(context).pop(true),
              child: const Text('Reportar'),
            ),
          ],
        ),
      ),
    );

    if (result == true && selectedReason != null) {
      try {
        await ReportService.instance.reportContent(
          contentType: 'event',
          contentId: widget.event.id,
          reason: selectedReason!,
          description: descriptionController.text.trim().isEmpty
              ? null
              : descriptionController.text.trim(),
        );

        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Evento reportado. Gracias por tu ayuda.'),
            backgroundColor: Colors.green,
            duration: Duration(seconds: 3),
          ),
        );
      } catch (e) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error al reportar: $e'),
            backgroundColor: Theme.of(context).colorScheme.error,
          ),
        );
      }
    }
  }
}
