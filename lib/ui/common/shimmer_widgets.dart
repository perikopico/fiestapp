import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class ShimmerBlock extends StatelessWidget {
  final double height;
  final double width;
  final EdgeInsetsGeometry margin;
  final BorderRadiusGeometry borderRadius;

  const ShimmerBlock({
    super.key,
    this.height = 16,
    this.width = double.infinity,
    this.margin = const EdgeInsets.symmetric(vertical: 8),
    this.borderRadius = const BorderRadius.all(Radius.circular(12)),
  });

  @override
  Widget build(BuildContext context) {
    final base = Theme.of(context).colorScheme.surfaceVariant.withOpacity(0.6);
    final high = Theme.of(context).colorScheme.surface.withOpacity(0.9);

    return Shimmer.fromColors(
      baseColor: base,
      highlightColor: high,
      child: Container(
        height: height,
        width: width,
        margin: margin,
        decoration: BoxDecoration(
          color: base,
          borderRadius: borderRadius,
        ),
      ),
    );
  }
}

/// Carrusel horizontal de placeholders (para “Populares”)
class ShimmerHorizontalCards extends StatelessWidget {
  final int count;
  const ShimmerHorizontalCards({super.key, this.count = 5});

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: SizedBox(
        height: 210,
        child: ListView.separated(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          scrollDirection: Axis.horizontal,
          itemCount: count,
          separatorBuilder: (BuildContext context, int index) =>
              const SizedBox(width: 12),
          itemBuilder: (BuildContext context, int index) {
            return const SizedBox(
              width: 280,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ShimmerBlock(height: 150), // imagen
                  ShimmerBlock(height: 16, width: 160),
                  ShimmerBlock(height: 14, width: 120),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}

/// Lista vertical de placeholders (para "Próximos")
class ShimmerVerticalList extends StatelessWidget {
  final int count;
  const ShimmerVerticalList({super.key, this.count = 4});

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: ListView.separated(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        physics: const NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        itemCount: count,
        separatorBuilder: (BuildContext context, int index) =>
            const SizedBox(height: 12),
        itemBuilder: (BuildContext context, int index) {
          return const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ShimmerBlock(height: 180), // imagen
              ShimmerBlock(height: 16, width: 180), // título
              ShimmerBlock(height: 14, width: 120), // subtítulo
            ],
          );
        },
      ),
    );
  }
}
