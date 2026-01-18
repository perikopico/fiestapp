import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../../models/event.dart';
import '../../event/event_detail_screen.dart';
import 'package:flutter/painting.dart';

/// Carrusel de eventos destacados estilo Netflix/Spotlight
class FeaturedEventsCarousel extends StatefulWidget {
  final List<Event> events;

  const FeaturedEventsCarousel({
    super.key,
    required this.events,
  });

  @override
  State<FeaturedEventsCarousel> createState() => _FeaturedEventsCarouselState();
}

class _FeaturedEventsCarouselState extends State<FeaturedEventsCarousel> {
  final PageController _pageController = PageController();
  int _currentPage = 0;
  final Set<String> _precachedImages = {};

  @override
  void initState() {
    super.initState();
    // Pre-cargar imágenes de todos los eventos para transición suave
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _precacheAllImages();
    });
  }

  /// Pre-carga todas las imágenes del carrusel para transición suave
  Future<void> _precacheAllImages() async {
    for (final event in widget.events) {
      if (event.imageUrl != null && 
          event.imageUrl!.isNotEmpty && 
          !_precachedImages.contains(event.imageUrl)) {
        try {
          final imageProvider = NetworkImage(event.imageUrl!);
          await precacheImage(imageProvider, context);
          _precachedImages.add(event.imageUrl!);
        } catch (e) {
          // Silenciar errores de precarga
        }
      }
    }
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.events.isEmpty) {
      return const SizedBox.shrink();
    }

    return SizedBox(
      height: 235, // Altura aproximada de 220px - 250px
      child: Stack(
        children: [
          // PageView con paginación
          PageView.builder(
            controller: _pageController,
            onPageChanged: (index) {
              setState(() {
                _currentPage = index;
              });
            },
            itemCount: widget.events.length,
            itemBuilder: (context, index) {
              final event = widget.events[index];
              return _buildFeaturedCard(event);
            },
          ),
          // Indicadores de página en la parte inferior
          if (widget.events.length > 1)
            Positioned(
              bottom: 12,
              left: 0,
              right: 0,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(
                  widget.events.length,
                  (index) => _buildPageIndicator(index == _currentPage),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildFeaturedCard(Event event) {
    final isPast = event.isPast;

    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => EventDetailScreen(event: event),
          ),
        );
      },
      child: Container(
        width: double.infinity,
        margin: const EdgeInsets.symmetric(horizontal: 0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(0),
        ),
        child: Stack(
          fit: StackFit.expand,
          children: [
            // Imagen de fondo que ocupa toda la tarjeta
            _buildEventImage(event),
            // Overlay degradado negro de abajo hacia arriba
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                  colors: [
                    Colors.black.withOpacity(0.8), // Opaco abajo
                    Colors.black.withOpacity(0.4), // Medio
                    Colors.black.withOpacity(0.0), // Transparente arriba
                  ],
                  stops: const [0.0, 0.5, 1.0],
                ),
              ),
            ),
            // Texto en la parte inferior izquierda (Título y Fecha) en color BLANCO
            Positioned(
              left: 16,
              bottom: 40,
              right: 16,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Título del evento
                  Text(
                    event.title,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      height: 1.2,
                      shadows: [
                        Shadow(
                          color: Colors.black54,
                          blurRadius: 8,
                          offset: Offset(0, 2),
                        ),
                      ],
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 8),
                  // Fecha del evento
                  Text(
                    () {
                      final dateFormat = DateFormat('EEEE, d MMMM', 'es');
                      final timeFormat = DateFormat('HH:mm', 'es');
                      final formattedDate = dateFormat.format(event.startsAt);
                      final formattedTime = timeFormat.format(event.startsAt);
                      return "$formattedDate · $formattedTime";
                    }(),
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.95),
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      shadows: const [
                        Shadow(
                          color: Colors.black54,
                          blurRadius: 6,
                          offset: Offset(0, 2),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            // Etiqueta FINALIZADO en rojo (si es pasado) - esquina superior derecha
            if (isPast)
              Positioned(
                top: 12,
                right: 12,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.red,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Text(
                    'FINALIZADO',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 0.5,
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildEventImage(Event event) {
    if (event.imageUrl != null && event.imageUrl!.isNotEmpty) {
      return CachedNetworkImage(
        imageUrl: event.imageUrl!,
        fit: BoxFit.cover,
        width: double.infinity,
        height: double.infinity,
        memCacheWidth: 800, // Optimizar tamaño en memoria
        memCacheHeight: 450,
        fadeInDuration: const Duration(milliseconds: 300),
        fadeOutDuration: const Duration(milliseconds: 100),
        placeholder: (context, url) => Container(
          width: double.infinity,
          height: double.infinity,
          color: Colors.grey.shade900,
          child: Center(
            child: CircularProgressIndicator(
              strokeWidth: 2,
              valueColor: AlwaysStoppedAnimation<Color>(Colors.white.withOpacity(0.3)),
            ),
          ),
        ),
        placeholderFadeInDuration: const Duration(milliseconds: 200),
        errorWidget: (context, url, error) => Container(
          width: double.infinity,
          height: double.infinity,
          color: Colors.grey.shade900,
          child: Center(
            child: Icon(
              Icons.event,
              size: 64,
              color: Colors.grey.shade600,
            ),
          ),
        ),
      );
    }

    // Si no hay imagen, mostrar placeholder
    return Container(
      width: double.infinity,
      height: double.infinity,
      color: Colors.grey.shade900,
      child: Center(
        child: Icon(
          Icons.event,
          size: 64,
          color: Colors.grey.shade600,
        ),
      ),
    );
  }

  Widget _buildPageIndicator(bool isActive) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      margin: const EdgeInsets.symmetric(horizontal: 4),
      width: isActive ? 24 : 8,
      height: 8,
      decoration: BoxDecoration(
        color: isActive ? Colors.white : Colors.white.withOpacity(0.4),
        borderRadius: BorderRadius.circular(4),
      ),
    );
  }
}
