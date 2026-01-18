import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'particle_effects.dart';

class HeroSlider extends StatefulWidget {
  const HeroSlider({super.key});

  @override
  State<HeroSlider> createState() => _HeroSliderState();
}

class _HeroSliderState extends State<HeroSlider> {
  Timer? _timer;
  int _currentPage = 0;
  ParticleType? _winterParticleType; // Tipo de partícula para invierno (aleatorio)

  // Imágenes temáticas de eventos típicos con efectos de partículas (solo nieve y lluvia)
  final List<Map<String, String>> _heroImages = [
    {
      'url': 'https://images.unsplash.com/photo-1514525253161-7a46d19cd819?w=800&q=80',
      'title': 'Zambomba Flamenca',
      'effect': 'snow', // Nieve
    },
    {
      'url': 'https://images.unsplash.com/photo-1482517967863-00e15c9b44be?w=800&q=80',
      'title': 'Fiestas Navideñas',
      'effect': 'snow', // Nieve
    },
    {
      'url': 'https://images.unsplash.com/photo-1511795409834-ef04bbd61622?w=800&q=80',
      'title': 'Carnavales',
      'effect': 'snow', // Nieve
    },
    {
      'url': 'https://images.unsplash.com/photo-1511578314322-379afb476865?w=800&q=80',
      'title': 'Fiestas de Verano',
      'effect': 'rain', // Lluvia
    },
    {
      'url': 'https://images.unsplash.com/photo-1516450360452-9312f5e86fc7?w=800&q=80',
      'title': 'Festivales',
      'effect': 'rain', // Lluvia
    },
    {
      'url': 'https://images.unsplash.com/photo-1519681393784-d120267933ba?w=800&q=80',
      'title': 'Lluvia',
      'effect': 'rain', // Lluvia
    },
  ];

  ParticleType _getParticleTypeForImage(int index) {
    final effect = _heroImages[index]['effect'] ?? 'snow';
    final month = DateTime.now().month;
    
    // Para imágenes de invierno en noviembre, diciembre y enero, usar el tipo aleatorio
    if ((effect == 'snow' || effect == 'winter') && 
        (month == 11 || month == 12 || month == 1) &&
        _winterParticleType != null) {
      return _winterParticleType!;
    }
    
    // Solo nieve y lluvia
    switch (effect) {
      case 'snow':
        return ParticleType.snow;
      case 'rain':
        return ParticleType.rain;
      default:
        return ParticleType.snow;
    }
  }

  @override
  void initState() {
    super.initState();
    _initializeWinterParticleType();
    _startAutoPlay();
  }

  void _initializeWinterParticleType() {
    final month = DateTime.now().month;
    // Para noviembre, diciembre y enero, elegir aleatoriamente entre nieve y lluvia
    if (month == 11 || month == 12 || month == 1) {
      _winterParticleType = Random().nextBool() 
          ? ParticleType.snow 
          : ParticleType.rain;
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _startAutoPlay() {
    _timer = Timer.periodic(const Duration(seconds: 4), (timer) {
      if (mounted) {
        setState(() {
          if (_currentPage < _heroImages.length - 1) {
            _currentPage++;
          } else {
            _currentPage = 0;
          }
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 144, // Reducido 20% (180*0.8=144)
      width: double.infinity,
      child: Stack(
        fit: StackFit.expand,
        children: [
          // Transición de imágenes con degradado (crossfade) - sin slide
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 1500),
            transitionBuilder: (Widget child, Animation<double> animation) {
              return FadeTransition(
                opacity: animation,
                child: child,
              );
            },
            // Partículas deshabilitadas
            // child: ParticleEffects(
            //   key: ValueKey<int>(_currentPage),
            //   type: _getParticleTypeForImage(_currentPage),
            //   child: _buildSlide(_heroImages[_currentPage]),
            // ),
            child: _buildSlide(_heroImages[_currentPage]),
          ),
          // Sin indicadores - solo transición automática
        ],
      ),
    );
  }

  Widget _buildSlide(Map<String, String> imageData) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(8),
      child: Stack(
        fit: StackFit.expand,
        children: [
          Image.network(
            imageData['url']!,
            fit: BoxFit.cover,
            width: double.infinity,
            height: double.infinity,
            errorBuilder: (_, __, ___) => Container(
              width: double.infinity,
              height: double.infinity,
              color: Theme.of(context).colorScheme.surfaceVariant,
              child: Icon(
                Icons.image_not_supported,
                size: 48,
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ),
            loadingBuilder: (context, child, loadingProgress) {
              if (loadingProgress == null) return child;
              return Container(
                width: double.infinity,
                height: double.infinity,
                color: Theme.of(context).colorScheme.surfaceVariant,
                child: Center(
                  child: CircularProgressIndicator(
                    value: loadingProgress.expectedTotalBytes != null
                        ? loadingProgress.cumulativeBytesLoaded /
                            loadingProgress.expectedTotalBytes!
                        : null,
                  ),
                ),
              );
            },
          ),
          // Degradado sutil
          Positioned.fill(
            child: DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                  colors: [
                    Colors.black.withOpacity(0.2),
                    Colors.transparent,
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

}

