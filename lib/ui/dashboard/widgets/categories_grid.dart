import 'package:flutter/material.dart';
import '../../../models/category.dart';
import '../../icons/icon_mapper.dart';

class CategoriesGrid extends StatelessWidget {
  final List<Category> categories;
  final int? selectedCategoryId;
  final ValueChanged<int?> onCategoryTap;

  const CategoriesGrid({
    super.key,
    required this.categories,
    this.selectedCategoryId,
    required this.onCategoryTap,
  });

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

            // Crear lista de widgets para el grid, empezando con "Todas"
            final List<Widget> categoryWidgets = [];
            
            // Chip "Todas"
            final isAllSelected = selectedCategoryId == null;
            categoryWidgets.add(
              InkWell(
                onTap: () {
                  onCategoryTap(null);
                },
                borderRadius: BorderRadius.circular(16),
                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: isAllSelected
                        ? Theme.of(context).colorScheme.primaryContainer.withOpacity(0.5)
                        : Theme.of(context).colorScheme.surfaceVariant.withOpacity(0.5),
                    borderRadius: BorderRadius.circular(16),
                    border: isAllSelected
                        ? Border.all(
                            color: Theme.of(context).colorScheme.primary,
                            width: 2,
                          )
                        : null,
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.grid_view,
                        size: 28,
                        color: isAllSelected
                            ? Theme.of(context).colorScheme.onPrimaryContainer
                            : Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                      const SizedBox(height: 6),
                      Flexible(
                        child: Text(
                          'Todas',
                          style: TextStyle(
                            fontWeight: isAllSelected ? FontWeight.bold : FontWeight.w500,
                            fontSize: 12,
                            color: isAllSelected
                                ? Theme.of(context).colorScheme.onPrimaryContainer
                                : Theme.of(context).colorScheme.onSurface,
                          ),
                          textAlign: TextAlign.center,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );

            // Agregar las categorías
            categoryWidgets.addAll(
              categories.map((category) {
                final categoryColor = _getColorForCategory(category.name);
                final isSelected = category.id != null && category.id == selectedCategoryId;
                
                return InkWell(
                  onTap: () {
                    onCategoryTap(category.id);
                  },
                  borderRadius: BorderRadius.circular(16),
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? categoryColor.withOpacity(0.3)
                          : categoryColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(16),
                      border: isSelected
                          ? Border.all(color: categoryColor, width: 2)
                          : null,
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          iconFromName(category.icon),
                          size: 28,
                          color: isSelected
                              ? categoryColor
                              : Theme.of(context).colorScheme.onSurfaceVariant,
                        ),
                        const SizedBox(height: 6),
                        Flexible(
                          child: Text(
                            category.name,
                            style: TextStyle(
                              fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                              fontSize: 12,
                              color: isSelected
                                  ? categoryColor
                                  : Theme.of(context).colorScheme.onSurface,
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
              }),
            );

            return GridView.count(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: crossAxisCount,
              mainAxisSpacing: 12,
              crossAxisSpacing: 12,
              padding: EdgeInsets.zero,
              childAspectRatio: 0.9,
              children: categoryWidgets,
            );
          },
        ),
      ],
    );
  }
}

