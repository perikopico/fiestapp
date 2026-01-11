// lib/ui/events/widgets/category_selector.dart
import 'package:flutter/material.dart';
import '../../../models/category.dart';

/// Información de categorías con subtítulos descriptivos
class CategoryInfo {
  final String name;
  final String subtitle;
  final String? iconName;

  const CategoryInfo({
    required this.name,
    required this.subtitle,
    this.iconName,
  });
}

/// Mapeo de nombres de categorías a su información
/// Categorías finales de la aplicación (7 categorías principales)
const Map<String, CategoryInfo> _categoryInfoMap = {
  'Música': CategoryInfo(
    name: 'Música',
    subtitle: 'Conciertos, festivales, flamenco, sesiones DJ y vida nocturna.',
    iconName: 'music_note',
  ),
  'Gastronomía': CategoryInfo(
    name: 'Gastronomía',
    subtitle: 'Rutas de tapas, catas de vino, mostos, ventas y jornadas del atún.',
    iconName: 'restaurant',
  ),
  'Deportes': CategoryInfo(
    name: 'Deportes',
    subtitle: 'Motor (Jerez), surf/kite (Tarifa), polo, hípica y competiciones.',
    iconName: 'sports_soccer',
  ),
  'Arte y Cultura': CategoryInfo(
    name: 'Arte y Cultura',
    subtitle: 'Teatro, exposiciones, museos, cine y visitas históricas.',
    iconName: 'palette',
  ),
  'Aire Libre': CategoryInfo(
    name: 'Aire Libre',
    subtitle: 'Senderismo, rutas en kayak, playas y naturaleza activa.',
    iconName: 'hiking',
  ),
  'Tradiciones': CategoryInfo(
    name: 'Tradiciones',
    subtitle: 'Carnaval, Semana Santa, Ferias, Zambombas y Romerías.',
    iconName: 'festival',
  ),
  'Mercadillos': CategoryInfo(
    name: 'Mercadillos',
    subtitle: 'Artesanía, antigüedades, rastros y moda (no alimentación).',
    iconName: 'storefront',
  ),
  // Mantener compatibilidad con nombres anteriores/variaciones
  'Mercados': CategoryInfo(
    name: 'Mercadillos',
    subtitle: 'Artesanía, antigüedades, rastros y moda (no alimentación).',
    iconName: 'storefront',
  ),
  'Cultura': CategoryInfo(
    name: 'Arte y Cultura',
    subtitle: 'Teatro, exposiciones, museos, cine y visitas históricas.',
    iconName: 'palette',
  ),
  'Arte': CategoryInfo(
    name: 'Arte y Cultura',
    subtitle: 'Teatro, exposiciones, museos, cine y visitas históricas.',
    iconName: 'palette',
  ),
  'Tradición': CategoryInfo(
    name: 'Tradiciones',
    subtitle: 'Carnaval, Semana Santa, Ferias, Zambombas y Romerías.',
    iconName: 'festival',
  ),
};

/// Widget selector de categorías con chips visuales
class CategorySelector extends StatelessWidget {
  final List<Category> categories;
  final Category? selectedCategory;
  final Function(Category?) onCategorySelected;
  final String? errorText;

  const CategorySelector({
    super.key,
    required this.categories,
    required this.selectedCategory,
    required this.onCategorySelected,
    this.errorText,
  });

  /// Obtiene la información de una categoría por su nombre
  CategoryInfo? _getCategoryInfo(String categoryName) {
    // Buscar coincidencia exacta primero
    if (_categoryInfoMap.containsKey(categoryName)) {
      return _categoryInfoMap[categoryName];
    }
    
    // Buscar coincidencia parcial (case insensitive)
    final lowerName = categoryName.toLowerCase();
    for (final entry in _categoryInfoMap.entries) {
      if (entry.key.toLowerCase() == lowerName ||
          lowerName.contains(entry.key.toLowerCase()) ||
          entry.key.toLowerCase().contains(lowerName)) {
        return entry.value;
      }
    }
    
    // Si no hay coincidencia, crear una info básica
    return CategoryInfo(
      name: categoryName,
      subtitle: 'Eventos de $categoryName',
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final filteredCategories = categories.where((c) => c.id != null).toList();

    if (filteredCategories.isEmpty) {
      return const SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Wrap(
          spacing: 12,
          runSpacing: 12,
          children: filteredCategories.map((category) {
            final isSelected = selectedCategory?.id == category.id;
            final categoryInfo = _getCategoryInfo(category.name) ?? CategoryInfo(
              name: category.name,
              subtitle: 'Eventos de ${category.name}',
            );

            return ChoiceChip(
              label: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    categoryInfo.name,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                      color: isSelected
                          ? theme.colorScheme.onPrimary
                          : theme.colorScheme.onSurface,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    categoryInfo.subtitle,
                    style: TextStyle(
                      fontSize: 11,
                      color: (isSelected
                              ? theme.colorScheme.onPrimary
                              : theme.colorScheme.onSurfaceVariant)
                          .withOpacity(0.7),
                    ),
                  ),
                ],
              ),
              selected: isSelected,
              onSelected: (selected) {
                onCategorySelected(selected ? category : null);
              },
              selectedColor: theme.colorScheme.primary,
              backgroundColor: theme.colorScheme.surfaceVariant,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              labelPadding: const EdgeInsets.symmetric(horizontal: 0, vertical: 4),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
                side: BorderSide(
                  color: isSelected
                      ? theme.colorScheme.primary
                      : theme.colorScheme.outline.withOpacity(0.2),
                  width: isSelected ? 2 : 1,
                ),
              ),
            );
          }).toList(),
        ),
        if (errorText != null) ...[
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.only(left: 12),
            child: Text(
              errorText!,
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.error,
              ),
            ),
          ),
        ],
      ],
    );
  }
}

