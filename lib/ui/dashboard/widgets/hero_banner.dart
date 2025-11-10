import 'package:flutter/material.dart';

class HeroBanner extends StatelessWidget {
  final String title;
  final String subtitle;
  final String imageUrl;
  final VoidCallback? onFeaturedTap;

  const HeroBanner({
    super.key,
    required this.title,
    required this.subtitle,
    required this.imageUrl,
    this.onFeaturedTap,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 220,
      child: Stack(
        children: [
          // Imagen de fondo
          ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: Image.network(
              imageUrl,
              width: double.infinity,
              height: double.infinity,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => Container(
                color: const Color(0xFFEDE7E3),
              ),
            ),
          ),
          // Degradado para legibilidad
          Positioned.fill(
            child: DecoratedBox(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                gradient: LinearGradient(
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                  colors: [
                    Colors.black.withOpacity(0.35),
                    Colors.transparent,
                  ],
                ),
              ),
            ),
          ),
          // Contenido
          Positioned(
            left: 16,
            right: 16,
            bottom: 16,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  subtitle,
                  style: const TextStyle(
                    color: Colors.white70,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  title,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.w800,
                    height: 1.2,
                    shadows: [
                      Shadow(blurRadius: 6, color: Colors.black26),
                    ],
                  ),
                ),
                const SizedBox(height: 10),
                ElevatedButton.icon(
                  onPressed: onFeaturedTap,
                  icon: const Icon(Icons.chevron_right, size: 18),
                  label: const Text('Ver eventos destacados'),
                  style: ElevatedButton.styleFrom(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                    foregroundColor: const Color(0xFF5b351f),
                    backgroundColor: const Color(0xFFFFE9DC),
                    textStyle: const TextStyle(
                      fontWeight: FontWeight.w700,
                    ),
                    shape: const StadiumBorder(),
                    elevation: 0,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
