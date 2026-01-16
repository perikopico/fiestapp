import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/category.dart';

class CategoryService {
  // Categorías oficiales válidas (7 principales)
  static const List<String> _validCategoryNames = [
    'Música',
    'Gastronomía',
    'Deportes',
    'Arte y Cultura',
    'Aire Libre',
    'Tradiciones',
    'Mercadillos',
  ];

  // Slugs oficiales válidos
  static const List<String> _validCategorySlugs = [
    'musica',
    'gastronomia',
    'deportes',
    'arte-y-cultura',
    'aire-libre',
    'tradiciones',
    'mercadillos',
  ];

  // Mapeo de categorías antiguas/no válidas a categorías oficiales
  static const Map<String, String> _categoryMapping = {
    // Deportes
    'deporte': 'Deportes',
    'sport': 'Deportes',
    'motor': 'Deportes',
    // Mercadillos
    'mercados': 'Mercadillos',
    'market': 'Mercadillos',
    // Arte y Cultura
    'cultura': 'Arte y Cultura',
    'arte': 'Arte y Cultura',
    // Aire Libre
    'naturaleza': 'Aire Libre',
    'nature': 'Aire Libre',
    // Tradiciones
    'tradicion': 'Tradiciones',
    'fiestas locales': 'Tradiciones',
    'ferias': 'Tradiciones',
    // Música
    'musica': 'Música', // sin tilde
    'music': 'Música',
    // Gastronomía
    'gastronomia': 'Gastronomía', // sin tilde
    'gastronomy': 'Gastronomía',
  };

  Future<List<Category>> fetchAll() async {
    try {
      final rows = await Supabase.instance.client
          .from('categories')
          .select('id, name, slug, icon, color')
          .order('name', ascending: true);

      final categories = (rows as List)
          .map((e) => Category.fromMap(e as Map<String, dynamic>))
          .toList();

      // Paso 1: Mapear categorías antiguas/no válidas a oficiales
      final mappedCategories = <Category>[];
      for (final category in categories) {
        final normalizedName = _normalizeString(category.name);
        final normalizedSlug = category.slug?.toLowerCase() ?? '';
        
        // Verificar si la categoría es oficial (por nombre o slug)
        final isOfficial = _validCategoryNames.contains(category.name) ||
            _validCategorySlugs.contains(normalizedSlug);
        
        if (isOfficial) {
          // Es una categoría oficial, mantenerla
          mappedCategories.add(category);
        } else {
          // Buscar si hay un mapeo disponible
          final mappedName = _categoryMapping[normalizedName] ?? 
                           _categoryMapping[normalizedSlug];
          
          if (mappedName != null) {
            // Buscar la categoría oficial correspondiente
            final officialCategory = categories.firstWhere(
              (c) => c.name == mappedName,
              orElse: () => category,
            );
            // Solo añadir si no está ya en la lista
            if (!mappedCategories.any((c) => c.name == officialCategory.name)) {
              mappedCategories.add(officialCategory);
            }
          }
          // Si no hay mapeo y no es oficial, se omite (eliminar categorías no válidas)
        }
      }

      // Paso 2: Eliminar duplicados definitivos
      final seenSlugs = <String>{};
      final seenNames = <String>{};  
      final uniqueCategories = <Category>[];

      for (final category in mappedCategories) {
        // Normalizar nombre para comparación
        final normalizedName = _normalizeString(category.name);
        
        // Si tiene slug, usar slug para deduplicar
        if (category.slug != null && category.slug!.isNotEmpty) {
          final normalizedSlug = category.slug!.toLowerCase();
          if (!seenSlugs.contains(normalizedSlug)) {
            seenSlugs.add(normalizedSlug);
            uniqueCategories.add(category);
          }
        } 
        // Si no tiene slug, usar nombre normalizado
        else if (!seenNames.contains(normalizedName)) {
          seenNames.add(normalizedName);
          uniqueCategories.add(category);
        }
      }

      // Paso 3: Filtrar solo las 7 categorías oficiales (por nombre exacto)
      final finalCategories = uniqueCategories.where((category) {
        return _validCategoryNames.contains(category.name);
      }).toList();

      // Ordenar según el orden oficial
      finalCategories.sort((a, b) {
        final indexA = _validCategoryNames.indexOf(a.name);
        final indexB = _validCategoryNames.indexOf(b.name);
        // Si no se encuentra en la lista, ponerlo al final
        if (indexA == -1) return 1;
        if (indexB == -1) return -1;
        return indexA.compareTo(indexB);
      });

      return finalCategories;
    } catch (e) {
      throw Exception('Error al obtener categorías: ${e.toString()}');
    }
  }

  /// Normaliza un string para comparación (sin acentos, minúsculas, sin espacios extra)
  String _normalizeString(String input) {
    return input
        .toLowerCase()
        .trim()
        .replaceAll(RegExp(r'[áàäâ]'), 'a')
        .replaceAll(RegExp(r'[éèëê]'), 'e')
        .replaceAll(RegExp(r'[íìïî]'), 'i')
        .replaceAll(RegExp(r'[óòöô]'), 'o')
        .replaceAll(RegExp(r'[úùüû]'), 'u')
        .replaceAll(RegExp(r'[ñ]'), 'n')
        .replaceAll(RegExp(r'\s+'), ' ');
  }

  Future<List<Category>> getCategories() async {
    return await fetchAll();
  }
}
