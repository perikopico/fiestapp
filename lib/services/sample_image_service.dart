import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter/foundation.dart' show debugPrint;
import '../models/category.dart';

/// Servicio para obtener imágenes de muestra desde Supabase Storage
/// Las imágenes están organizadas en: sample-images/{province_id}/{category_number}/
/// Ejemplo: sample-images/1/1/ (Cádiz, Categoría 1: Música)
class SampleImageService {
  SampleImageService._();
  
  static final SampleImageService instance = SampleImageService._();
  final supa = Supabase.instance.client;

  /// Mapea el slug de la categoría al número de carpeta (1-7)
  /// Este número corresponde al orden lógico de las categorías:
  /// 1. Música (musica)
  /// 2. Gastronomía (gastronomia)
  /// 3. Deportes (deportes)
  /// 4. Arte y Cultura (arte-y-cultura)
  /// 5. Aire Libre (aire-libre)
  /// 6. Tradiciones (tradiciones)
  /// 7. Mercadillos (mercadillos)
  int? getCategoryFolderNumber(String? categorySlug) {
    if (categorySlug == null) return null;
    
    final slug = categorySlug.toLowerCase();
    switch (slug) {
      case 'musica':
        return 1;
      case 'gastronomia':
        return 2;
      case 'deportes':
        return 3;
      case 'arte-y-cultura':
        return 4;
      case 'aire-libre':
        return 5;
      case 'tradiciones':
        return 6;
      case 'mercadillos':
        return 7;
      default:
        return null;
    }
  }

  /// Mapea el ID numérico de la categoría al número de carpeta (1-7)
  /// Necesita obtener el slug de la categoría desde la BD
  Future<int?> getCategoryFolderNumberById(int? categoryId) async {
    if (categoryId == null) return null;
    
    try {
      final result = await supa
          .from('categories')
          .select('slug')
          .eq('id', categoryId)
          .maybeSingle();
      
      if (result != null && result['slug'] != null) {
        return getCategoryFolderNumber(result['slug'] as String);
      }
    } catch (e) {
      debugPrint('Error al obtener categoría por ID: $e');
    }
    
    return null;
  }

  /// Obtiene las URLs públicas de las imágenes de muestra para una categoría
  /// 
  /// [categorySlug] El slug de la categoría (ej: 'musica', 'gastronomia')
  /// [provinceId] El ID de la provincia (por defecto 1 para Cádiz)
  /// 
  /// Retorna una lista de URLs públicas de las imágenes
  Future<List<String>> getSampleImagesForCategory({
    String? categorySlug,
    int? categoryId,
    int provinceId = 1, // Por defecto Cádiz
  }) async {
    try {
      // Determinar el número de carpeta de la categoría
      int? categoryNumber;
      
      if (categorySlug != null) {
        categoryNumber = getCategoryFolderNumber(categorySlug);
      } else if (categoryId != null) {
        categoryNumber = await getCategoryFolderNumberById(categoryId);
      }
      
      if (categoryNumber == null) {
        debugPrint('⚠️ No se pudo determinar el número de carpeta para la categoría');
        return [];
      }

      // Construir la ruta: sample-images/{province_id}/{category_number}/
      final path = 'sample-images/$provinceId/$categoryNumber/';
      
      debugPrint('📸 Buscando imágenes de muestra en: $path');
      
      // Listar archivos en la carpeta
      final files = await supa.storage
          .from('sample-images')
          .list(path: path);

      if (files.isEmpty) {
        debugPrint('⚠️ No se encontraron imágenes en: $path');
        return [];
      }

      // Filtrar solo imágenes
      final imageFiles = files.where((file) {
        final name = file.name.toLowerCase();
        return name.endsWith('.jpg') ||
            name.endsWith('.jpeg') ||
            name.endsWith('.png') ||
            name.endsWith('.webp');
      }).toList();

      if (imageFiles.isEmpty) {
        debugPrint('⚠️ No se encontraron archivos de imagen en: $path');
        return [];
      }

      // Construir las URLs públicas
      final imageUrls = imageFiles.map((file) {
        return supa.storage
            .from('sample-images')
            .getPublicUrl('$path${file.name}');
      }).toList();

      debugPrint('✅ Encontradas ${imageUrls.length} imágenes de muestra');
      
      return imageUrls;
    } catch (e, stackTrace) {
      debugPrint('❌ Error al obtener imágenes de muestra: $e');
      debugPrint('Stack trace: $stackTrace');
      return [];
    }
  }

  /// Obtiene todas las imágenes de muestra para todas las categorías
  /// Útil para mostrar un grid general de imágenes disponibles
  Future<Map<int, List<String>>> getAllSampleImages({int provinceId = 1}) async {
    final Map<int, List<String>> imagesByCategory = {};
    
    // Obtener imágenes para cada categoría (1-7)
    for (int categoryNumber = 1; categoryNumber <= 7; categoryNumber++) {
      try {
        final path = 'sample-images/$provinceId/$categoryNumber/';
        final files = await supa.storage
            .from('sample-images')
            .list(path: path);

        final imageFiles = files.where((file) {
          final name = file.name.toLowerCase();
          return name.endsWith('.jpg') ||
              name.endsWith('.jpeg') ||
              name.endsWith('.png') ||
              name.endsWith('.webp');
        }).toList();

        if (imageFiles.isNotEmpty) {
          final imageUrls = imageFiles.map((file) {
            return supa.storage
                .from('sample-images')
                .getPublicUrl('$path${file.name}');
          }).toList();
          
          imagesByCategory[categoryNumber] = imageUrls;
        }
      } catch (e) {
        debugPrint('⚠️ Error al obtener imágenes para categoría $categoryNumber: $e');
      }
    }
    
    return imagesByCategory;
  }
}
