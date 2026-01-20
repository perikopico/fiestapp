import 'package:flutter/material.dart';
import '../../../models/category.dart';
import '../../icons/icon_mapper.dart';
import '../../../utils/accessibility_utils.dart';

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
    if (categoryName.isEmpty) return Colors.grey;
    
    final name = categoryName.toLowerCase();
    
    // Música
    if (name.contains('música') || name.contains('musica') || name.contains('music')) {
      return const Color(0xFF9C27B0); // Purple
    }
    // Gastronomía
    else if (name.contains('gastronomía') || name.contains('gastronomia') || name.contains('gastronomy')) {
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

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 50, // Altura compacta reducida de ~150px a 50px
      child: ListView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 4),
        children: [
          // Chip "Todas" estilo Pill compacto
          Padding(
            padding: const EdgeInsets.only(right: 8),
            child: _buildPillChip(
              context: context,
              label: 'Todas',
              icon: Icons.grid_view,
              isSelected: selectedCategoryId == null,
              categoryColor: Colors.grey,
              onTap: () => onCategoryTap(null),
            ),
          ),
          // Categorías estilo Pills compactos
          ...categories.where((c) => c.id != null).map((category) {
            final categoryColor = _getColorForCategory(category.name);
            final isSelected = category.id == selectedCategoryId;
            return Padding(
              padding: const EdgeInsets.only(right: 8),
              child: _buildPillChip(
                context: context,
                label: category.name,
                icon: iconFromName(category.icon),
                isSelected: isSelected,
                categoryColor: categoryColor,
                onTap: () => onCategoryTap(category.id),
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildPillChip({
    required BuildContext context,
    required String label,
    required IconData icon,
    required bool isSelected,
    required Color categoryColor,
    required VoidCallback onTap,
  }) {
    return AccessibilityUtils.buttonSemantics(
      label: isSelected ? '$label (seleccionado)' : label,
      hint: 'Toca para filtrar eventos por la categoría $label',
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16), // Pill shape más compacto
      child: Container(
        constraints: const BoxConstraints(
          minHeight: 36,
          maxHeight: 36, // Altura fija compacta de 36px
        ),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected
              ? categoryColor.withOpacity(0.15)
              : Theme.of(context).colorScheme.surfaceVariant.withOpacity(0.5),
          borderRadius: BorderRadius.circular(16),
          border: isSelected
              ? Border.all(color: categoryColor, width: 1.5)
              : Border.all(
                  color: Theme.of(context).colorScheme.outline.withOpacity(0.1),
                  width: 1,
                ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 16, // Icono más pequeño para chip compacto
              color: isSelected
                  ? categoryColor
                  : Theme.of(context).colorScheme.onSurfaceVariant,
            ),
            const SizedBox(width: 6),
            Text(
              label,
              style: TextStyle(
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                fontSize: 13,
                color: isSelected
                    ? categoryColor
                    : Theme.of(context).colorScheme.onSurface,
              ),
            ),
          ],
        ),
      ),
      ),
    );
  }
}
