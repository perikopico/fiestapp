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
    return Shimmer.fromColors(
      baseColor:
          Theme.of(context).colorScheme.onSurface.withOpacity(0.04),
      highlightColor:
          Theme.of(context).colorScheme.onSurface.withOpacity(0.12),
      child: Container(
        height: height,
        width: width,
        margin: margin,
        decoration: BoxDecoration(
          color:
              Theme.of(context).colorScheme.onSurface.withOpacity(0.04),
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
                  ShimmerBlock(
                    height: 150,
                    borderRadius: BorderRadius.all(Radius.circular(16)),
                  ), // imagen
                  ShimmerBlock(
                    height: 16,
                    width: 160,
                    borderRadius: BorderRadius.all(Radius.circular(12)),
                  ),
                  ShimmerBlock(
                    height: 14,
                    width: 120,
                    borderRadius: BorderRadius.all(Radius.circular(12)),
                  ),
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
              ShimmerBlock(
                height: 180,
                borderRadius: BorderRadius.all(Radius.circular(16)),
              ), // imagen
              ShimmerBlock(
                height: 16,
                width: 180,
                borderRadius: BorderRadius.all(Radius.circular(12)),
              ), // título
              ShimmerBlock(
                height: 14,
                width: 120,
                borderRadius: BorderRadius.all(Radius.circular(12)),
              ), // subtítulo
            ],
          );
        },
      ),
    );
  }
}
