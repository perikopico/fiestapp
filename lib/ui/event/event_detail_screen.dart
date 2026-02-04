import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

import 'package:share_plus/share_plus.dart';
import 'package:add_2_calendar/add_2_calendar.dart' as add2cal;
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../models/event.dart';
import '../icons/icon_mapper.dart';
import 'fullscreen_image_screen.dart';
import '../../services/favorites_local_service.dart';
import '../../services/event_service.dart';
import '../../services/report_service.dart';
import '../../services/analytics_service.dart';
import '../../utils/url_helper.dart';
import '../../utils/validation_utils.dart';
import '../../utils/snackbar_utils.dart';
import '../../services/logger_service.dart';
import '../../services/notification_alerts_service.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class EventDetailScreen extends StatefulWidget {
  final Event event;

  const EventDetailScreen({super.key, required this.event});

  @override
  State<EventDetailScreen> createState() => _EventDetailScreenState();
}

class _EventDetailScreenState extends State<EventDetailScreen> {
  bool _isFavorite = false;
  bool _isFollowing = false;
  final NotificationAlertsService _alertsService = NotificationAlertsService.instance;

  @override
  void initState() {
    super.initState();
    _loadFavoriteStatus();
    _loadFollowingStatus();
    // Incrementar contador de vistas al abrir el evento
    EventService.instance.incrementEventView(widget.event.id);
    // Trackear visualización de evento
    AnalyticsService.instance.logEventView(
      widget.event.id,
      eventTitle: widget.event.title,
    );
  }

  Future<void> _loadFavoriteStatus() async {
    final isFav = await FavoritesLocalService.instance.isFavorite(widget.event.id);
    if (mounted) {
      setState(() {
        _isFavorite = isFav;
      });
    }
  }

  Future<void> _loadFollowingStatus() async {
    final isFollowed = await _alertsService.isEventFollowed(widget.event.id);
    if (mounted) {
      setState(() {
        _isFollowing = isFollowed;
      });
    }
  }

  Future<void> _toggleFollowing() async {
    HapticFeedback.lightImpact();
    final newValue = !_isFollowing;
    setState(() => _isFollowing = newValue);
    await _alertsService.setEventFollowed(widget.event.id, newValue);
    if (mounted) {
      showTopSnackBar(
        context,
        message: newValue
            ? '¡Listo! Te avisaremos de eventos similares'
            : 'Has dejado de seguir este evento',
      );
    }
  }

  Future<void> _toggleFavorite() async {
    HapticFeedback.lightImpact();
    final newValue = !_isFavorite;
    setState(() => _isFavorite = newValue);
    await FavoritesLocalService.instance.toggleFavorite(widget.event.id);
    if (mounted) {
      showTopSnackBar(
        context,
        message: newValue ? 'Añadido a favoritos' : 'Eliminado de favoritos',
      );
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
      LoggerService.instance.error('Error al extraer coordenadas del mapsUrl', error: e);
    }
    return null;
  }

  /// Abre Google Maps con direcciones al evento
  Future<void> _openDirections() async {
    final coordinates = _extractCoordinatesFromMapsUrl(widget.event.mapsUrl);
    if (coordinates == null) {
      await UrlHelper.openGoogleMapsUrl(
        context,
        widget.event.mapsUrl,
        errorMessage: 'No se puede abrir la ubicación del evento',
      );
      return;
    }
    await UrlHelper.openGoogleMapsDirections(
      context,
      coordinates.latitude,
      coordinates.longitude,
      errorMessage: 'No se puede abrir Google Maps con direcciones',
    );
  }

  /// Distancia precisa por carretera (Google Distance Matrix o similar).
  /// SOLO en EventDetailScreen: el usuario ya mostró interés explícito.
  /// TODO: Implementar llamada a API de Google (Distance Matrix) o enlace a mapas.
  /// Obtener ubicación actual (Geolocator), origen = user, destino = event.venueCoordinates.
  /// Retornar km reales para mostrar en la pantalla de detalle (ej. "A 14.2 km").
  /// Ubicación sugerida de uso: al construir el widget de "Cómo llegar" / botón de direcciones.
  static Future<double?> fetchPreciseDistance(
    double userLat,
    double userLng,
    double venueLat,
    double venueLng,
  ) async {
    // TODO: Integrar Google Distance Matrix API (origen/destino) y devolver distancia en km.
    // Evitar usar en listas; solo aquí en detalle.
    return null;
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

  String get _shareText => [
        '${widget.event.title} - ${widget.event.cityName ?? ''}'.trim(),
        (widget.event.place ?? '').trim(),
        '${DateFormat('EEE, d MMM • HH:mm', 'es').format(widget.event.startsAt)}'.trim(),
        (widget.event.mapsUrl ?? '').trim(),
      ].where((s) => s.isNotEmpty).join('\n');

  void _share() {
    final text = _shareText;
    if (text.isEmpty) return;
    Rect sharePositionOrigin = Rect.zero;
    try {
      final box = context.findRenderObject() as RenderBox?;
      if (box != null && box.hasSize) {
        final pos = box.localToGlobal(Offset.zero);
        sharePositionOrigin = Rect.fromLTWH(pos.dx, pos.dy, box.size.width, box.size.height);
      } else {
        final size = MediaQuery.sizeOf(context);
        sharePositionOrigin = Rect.fromLTWH(size.width / 2, size.height / 2, 0, 0);
      }
    } catch (_) {
      final size = MediaQuery.sizeOf(context);
      sharePositionOrigin = Rect.fromLTWH(size.width / 2, size.height / 2, 0, 0);
    }
    Share.share(text, sharePositionOrigin: sharePositionOrigin);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final hasMapsUrl = widget.event.mapsUrl != null && widget.event.mapsUrl!.isNotEmpty;
    final hasInfoUrl = widget.event.infoUrl != null &&
        widget.event.infoUrl!.isNotEmpty &&
        ValidationUtils.isValidUrl(widget.event.infoUrl!);
    final showStickyFooter = hasInfoUrl || hasMapsUrl;
    final topPadding = MediaQuery.viewPaddingOf(context).top;

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
        statusBarBrightness: Brightness.dark,
        systemNavigationBarColor: theme.scaffoldBackgroundColor,
        systemNavigationBarIconBrightness: theme.brightness == Brightness.dark ? Brightness.light : Brightness.dark,
      ),
      child: Scaffold(
        extendBodyBehindAppBar: true,
        backgroundColor: theme.scaffoldBackgroundColor,
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: CustomScrollView(
                slivers: [
                  _buildSliverAppBar(context, theme, topPadding),
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(16, 20, 16, 24),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.event.title,
                            style: theme.textTheme.titleLarge?.copyWith(
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                          const SizedBox(height: 10),
                          _buildBlockA(context, theme),
                          const SizedBox(height: 16),
                          _buildBlockB(context, theme),
                          const SizedBox(height: 20),
                          _buildDescriptionSection(context, widget.event),
                          const SizedBox(height: 24),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            if (showStickyFooter) _buildStickyFooter(context, theme, hasInfoUrl, hasMapsUrl),
          ],
        ),
      ),
    );
  }

  static const double _heroHeight = 320;

  Widget _buildSliverAppBar(BuildContext context, ThemeData theme, double topPadding) {
    final hasImage = widget.event.imageUrl != null && widget.event.imageUrl!.isNotEmpty;

    return SliverAppBar(
      expandedHeight: _heroHeight,
      pinned: false,
      stretch: true,
      backgroundColor: Colors.transparent,
      elevation: 0,
      automaticallyImplyLeading: false,
      leadingWidth: 56,
      leading: Padding(
        padding: EdgeInsets.only(left: 12, top: topPadding + 8),
        child: _FloatingGlassButton(
          icon: Icons.arrow_back,
          onTap: () => Navigator.of(context).pop(),
        ),
      ),
      actions: [
        Padding(
          padding: EdgeInsets.only(right: 8, top: topPadding + 8),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              _FloatingGlassButton(icon: Icons.share, onTap: _share),
              const SizedBox(width: 8),
              _FloatingFavoriteButton(
                isFavorite: _isFavorite,
                onTap: _toggleFavorite,
              ),
              const SizedBox(width: 8),
              _FloatingGlassButton(
                icon: Icons.more_vert,
                onTap: () => _showOverlayMenu(context, theme),
              ),
            ],
          ),
        ),
      ],
      flexibleSpace: FlexibleSpaceBar(
        background: Stack(
          fit: StackFit.expand,
          children: [
            if (hasImage)
              GestureDetector(
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => FullscreenImageScreen(imageUrl: widget.event.imageUrl!),
                    ),
                  );
                },
                child: Hero(
                  tag: 'event-img-${widget.event.id}',
                  child: Image.network(
                    widget.event.imageUrl!,
                    fit: BoxFit.cover,
                    alignment: _alignmentFromString(widget.event.imageAlignment),
                    errorBuilder: (_, __, ___) => _heroPlaceholder(theme),
                  ),
                ),
              )
            else
              _heroPlaceholder(theme),
            DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.transparent,
                    Colors.black.withOpacity(0.3),
                  ],
                ),
              ),
            ),
          ],
        ),
        collapseMode: CollapseMode.parallax,
      ),
    );
  }

  Widget _heroPlaceholder(ThemeData theme) {
    return Container(
      color: theme.colorScheme.surfaceContainerLowest,
      alignment: Alignment.center,
      child: Icon(Icons.event, size: 56, color: theme.colorScheme.onSurfaceVariant),
    );
  }

  void _showOverlayMenu(BuildContext context, ThemeData theme) {
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (ctx) => SafeArea(
        child: Container(
          decoration: BoxDecoration(
            color: theme.colorScheme.surface,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: Icon(
                  _isFollowing ? Icons.notifications : Icons.notifications_outlined,
                  color: _isFollowing ? theme.colorScheme.primary : null,
                ),
                title: Text(_isFollowing ? 'Dejar de seguir' : 'Seguir evento'),
                onTap: () async {
                  Navigator.pop(ctx);
                  await _toggleFollowing();
                },
              ),
              ListTile(
                leading: const Icon(Icons.flag_outlined, color: Colors.red),
                title: const Text('Reportar evento'),
                onTap: () {
                  Navigator.pop(ctx);
                  _showReportDialog();
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Bloque A: chips pequeños – solo Categoría y Estado/Precio (text-xs, bg-gray-100).
  Widget _buildBlockA(BuildContext context, ThemeData theme) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: [
        if (widget.event.categoryName != null)
          _smallChip(
            theme,
            icon: iconFromName(widget.event.categoryIcon),
            label: widget.event.categoryName!,
          ),
        if (widget.event.price != null && widget.event.price!.isNotEmpty)
          _smallChip(
            theme,
            icon: _isPriceFree(widget.event.price!)
                ? Icons.check_circle_outline
                : Icons.euro,
            label: widget.event.price!,
          ),
      ],
    );
  }

  Widget _smallChip(ThemeData theme, {required IconData icon, required String label}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: const Color(0xFFF3F4F6),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: const Color(0xFF4B5563)),
          const SizedBox(width: 6),
          Text(
            label,
            style: theme.textTheme.labelMedium?.copyWith(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: const Color(0xFF4B5563),
            ),
          ),
        ],
      ),
    );
  }

  /// Bloque B: filas Fecha y Ubicación con iconos bg-blue-50 / bg-red-50.
  Widget _buildBlockB(BuildContext context, ThemeData theme) {
    const bgBlue = Color(0xFFEFF6FF);
    const bgRed = Color(0xFFFEF2F2);
    const gray500 = Color(0xFF6B7280);
    const gray900 = Color(0xFF111827);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (_hasValidDateTime) ...[
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: bgBlue,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(Icons.calendar_today, size: 24, color: theme.colorScheme.primary),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Fecha', style: theme.textTheme.labelMedium?.copyWith(color: gray500, fontSize: 12)),
                    const SizedBox(height: 2),
                    Text(
                      DateFormat('EEE, d MMM • HH:mm', 'es').format(widget.event.startsAt),
                      style: theme.textTheme.titleMedium?.copyWith(
                        color: gray900,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          GestureDetector(
            onTap: _addToCalendar,
            child: Padding(
              padding: const EdgeInsets.only(left: 2),
              child: Text(
                'Añadir al calendario',
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.primary,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),
        ] else
          _buildNoDatePill(context, theme),
        if (widget.event.place != null && widget.event.place!.isNotEmpty) ...[
          if (_hasValidDateTime) const SizedBox(height: 4) else const SizedBox(height: 12),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: bgRed,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(Icons.location_on, size: 24, color: theme.colorScheme.error),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Ubicación', style: theme.textTheme.labelMedium?.copyWith(color: gray500, fontSize: 12)),
                    const SizedBox(height: 2),
                    Text(
                      [widget.event.place, widget.event.cityName]
                          .whereType<String>()
                          .where((s) => s.isNotEmpty)
                          .join(', '),
                      style: theme.textTheme.titleMedium?.copyWith(
                        color: gray900,
                        fontWeight: FontWeight.bold,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ],
    );
  }

  Future<void> _addToCalendar() async {
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
  }

  /// Sticky footer: botón principal fijo, fondo blanco, sombra superior.
  Widget _buildStickyFooter(
    BuildContext context,
    ThemeData theme,
    bool hasInfoUrl,
    bool hasMapsUrl,
  ) {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 14),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 16,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: Row(
          children: [
            if (hasInfoUrl) ...[
              Expanded(
                child: FilledButton.icon(
                  onPressed: () => UrlHelper.launchUrlSafely(
                    context,
                    widget.event.infoUrl!,
                    errorMessage: 'No se puede abrir el enlace',
                  ),
                  icon: const Icon(Icons.link, size: 20),
                  label: const Text('Más información'),
                  style: FilledButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                ),
              ),
              if (hasMapsUrl) const SizedBox(width: 12),
            ],
            if (hasMapsUrl)
              Expanded(
                child: FilledButton.icon(
                  onPressed: _openDirections,
                  icon: const Icon(Icons.directions, size: 20),
                  label: const Text('Cómo llegar'),
                  style: FilledButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                ),
              ),
          ],
        ),
      ),
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
          Text(
            'Descripción',
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            mainDesc,
            style: theme.textTheme.bodyLarge?.copyWith(height: 1.5),
            softWrap: true,
            textAlign: TextAlign.start,
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
          _buildProgrammingItems(theme, programBlock),
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

class _FloatingGlassButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;

  const _FloatingGlassButton({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(28),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(28),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
            child: Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                shape: BoxShape.rectangle,
                borderRadius: BorderRadius.circular(28),
                color: Colors.white.withOpacity(0.3),
                border: Border.all(color: Colors.white.withOpacity(0.5), width: 1),
              ),
              child: Icon(icon, color: Colors.white, size: 22),
            ),
          ),
        ),
      ),
    );
  }
}

class _FloatingFavoriteButton extends StatefulWidget {
  final bool isFavorite;
  final VoidCallback onTap;

  const _FloatingFavoriteButton({
    required this.isFavorite,
    required this.onTap,
  });

  @override
  State<_FloatingFavoriteButton> createState() => _FloatingFavoriteButtonState();
}

class _FloatingFavoriteButtonState extends State<_FloatingFavoriteButton>
    with SingleTickerProviderStateMixin {
  static const _duration = Duration(milliseconds: 320);

  late final AnimationController _controller;
  late final Animation<double> _scale;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: _duration);
    _scale = TweenSequence<double>([
      TweenSequenceItem(
        tween: Tween(begin: 1.0, end: 1.25).chain(
          CurveTween(curve: Curves.easeOut),
        ),
        weight: 45,
      ),
      TweenSequenceItem(
        tween: Tween(begin: 1.25, end: 1.0).chain(
          CurveTween(curve: Curves.elasticOut),
        ),
        weight: 55,
      ),
    ]).animate(
      CurvedAnimation(parent: _controller, curve: Curves.linear),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _handleTap() {
    widget.onTap();
    _controller.forward(from: 0);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final icon = widget.isFavorite ? Icons.favorite : Icons.favorite_border;
    final color = widget.isFavorite ? theme.colorScheme.error : Colors.white;

    return ScaleTransition(
      scale: _scale,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: _handleTap,
          borderRadius: BorderRadius.circular(29),
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                Transform.translate(
                  offset: const Offset(1, 1),
                  child: Icon(icon, color: Colors.black.withOpacity(0.4), size: 29),
                ),
                Icon(icon, color: color, size: 29),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
