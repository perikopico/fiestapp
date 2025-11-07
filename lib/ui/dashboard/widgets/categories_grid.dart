import 'package:flutter/material.dart';
import '../../../models/category.dart';
import '../../icons/icon_mapper.dart';

class CategoriesGrid extends StatelessWidget {
  final List<Category> categories;

  const CategoriesGrid({super.key, required this.categories});

  Color _getColorForCategory(String categoryName) {
    final name = categoryName.toLowerCase();
    if (name.contains('música') || name.contains('music')) {
      return Colors.purple;
    } else if (name.contains('mercados') || name.contains('market')) {
      return Colors.orange;
    } else if (name.contains('deporte') || name.contains('sport')) {
      return Colors.green;
    } else if (name.contains('tradición') || name.contains('tradition')) {
      return Colors.redAccent;
    }
    return Colors.grey;
  }

  @override
  Widget build(BuildContext context) {
    if (categories.isEmpty) {
      return const SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Categorías',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),
        const SizedBox(height: 12),
        LayoutBuilder(
          builder: (context, constraints) {
            final screenWidth = MediaQuery.of(context).size.width;
            final isNarrow = screenWidth < 600;
            final crossAxisCount = isNarrow ? 4 : 6;

            return GridView.count(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: crossAxisCount,
              mainAxisSpacing: 12,
              crossAxisSpacing: 12,
              padding: EdgeInsets.zero,
              childAspectRatio: 0.9,
              children: categories.map((category) {
                final categoryColor = _getColorForCategory(category.name);
                
                return InkWell(
                  onTap: () {
                    // TODO: Navegar a categoría
                  },
                  borderRadius: BorderRadius.circular(16),
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: categoryColor.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            iconFromName(category.icon),
                            size: 28,
                            color: Colors.black54,
                          ),
                          const SizedBox(height: 6),
                          Flexible(
                            child: Text(
                              category.name,
                              style: const TextStyle(
                                fontWeight: FontWeight.w500,
                                fontSize: 12,
                              ),
                              textAlign: TextAlign.center,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ),
                );
              }).toList(),
            );
          },
        ),
      ],
    );
  }
}

