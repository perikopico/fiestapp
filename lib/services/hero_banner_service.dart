import 'dart:math';
import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class SeasonalHeroBanner {
  final String imageUrl;
  final String tagline;

  SeasonalHeroBanner({
    required this.imageUrl,
    required this.tagline,
  });
}

class HeroBannerService {
  HeroBannerService._();

  static final HeroBannerService instance = HeroBannerService._();
  final _random = Random();

  /// Obtiene el nombre de la carpeta del mes actual
  String _currentMonthFolder() {
    final now = DateTime.now();
    switch (now.month) {
      case 1:
        return 'january';
      case 2:
        return 'february';
      case 3:
        return 'march';
      case 4:
        return 'april';
      case 5:
        return 'may';
      case 6:
        return 'june';
      case 7:
        return 'july';
      case 8:
        return 'august';
      case 9:
        return 'september';
      case 10:
        return 'october';
      case 11:
        return 'november';
      case 12:
        return 'december';
      default:
        return 'november';
    }
  }

  /// Obtiene una frase aleatoria para el mes actual
  String _getRandomTaglineForMonth() {
    final now = DateTime.now();
    final month = now.month;

    // Frases por mes (puedes personalizar estas)
    final taglinesByMonth = {
      1: [
        '¡Año nuevo, nuevas aventuras!',
        'Empieza el año con planes increíbles',
        'Enero lleno de eventos especiales',
      ],
      2: [
        'Febrero, mes de celebraciones',
        'Disfruta de los mejores eventos',
        'El amor está en el aire',
      ],
      3: [
        'Marzo trae primavera y diversión',
        'Eventos para todos los gustos',
        'La primavera está aquí',
      ],
      4: [
        'Abril, mes de fiestas',
        'Disfruta de la primavera',
        'Eventos únicos te esperan',
      ],
      5: [
        'Mayo florece con eventos',
        'Disfruta del buen tiempo',
        'La diversión no para',
      ],
      6: [
        'Junio, comienza el verano',
        'Eventos para disfrutar al aire libre',
        'El verano está aquí',
      ],
      7: [
        'Julio, mes de verano',
        'Disfruta del calor y los eventos',
        'El verano en su máximo esplendor',
      ],
      8: [
        'Agosto, disfruta del verano',
        'Eventos para toda la familia',
        'Últimos días de verano',
      ],
      9: [
        'Septiembre, vuelta a la rutina con estilo',
        'Eventos para empezar el otoño',
        'El otoño trae nuevos planes',
      ],
      10: [
        'Octubre, mes de tradiciones',
        'Disfruta de eventos únicos',
        'El otoño está en su apogeo',
      ],
      11: [
        'Noviembre, mes especial',
        'Eventos para disfrutar',
        'Prepárate para el invierno',
      ],
      12: [
        'Diciembre, mes mágico',
        'Navidad y eventos especiales',
        'Cierra el año con estilo',
      ],
    };

    final taglines = taglinesByMonth[month] ?? [
      'Disfruta de los mejores eventos',
      'Eventos únicos te esperan',
      'La diversión no para',
    ];

    taglines.shuffle(_random);
    return taglines.first;
  }

  /// Obtiene una imagen aleatoria del mes actual desde Supabase Storage
  Future<SeasonalHeroBanner?> getRandomSeasonalBanner() async {
    try {
      final supa = Supabase.instance.client;
      final monthFolder = _currentMonthFolder();
      final tagline = _getRandomTaglineForMonth();

      // Listar archivos en la carpeta del mes
      final files = await supa.storage
          .from('hero_banners')
          .list(path: monthFolder);

      if (files.isEmpty) {
        return null;
      }

      // Filtrar solo imágenes (jpg, jpeg, png)
      final imageFiles = files.where((file) {
        final name = file.name.toLowerCase();
        return name.endsWith('.jpg') ||
            name.endsWith('.jpeg') ||
            name.endsWith('.png');
      }).toList();

      if (imageFiles.isEmpty) {
        return null;
      }

      // Seleccionar una imagen aleatoria
      imageFiles.shuffle(_random);
      final selectedFile = imageFiles.first;

      // Obtener la URL pública de la imagen
      final imageUrl = supa.storage
          .from('hero_banners')
          .getPublicUrl('$monthFolder/${selectedFile.name}');

      return SeasonalHeroBanner(
        imageUrl: imageUrl,
        tagline: tagline,
      );
    } catch (e) {
      debugPrint('Error al obtener banner estacional: $e');
      return null;
    }
  }
}
