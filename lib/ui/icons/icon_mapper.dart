import 'package:flutter/material.dart';

/// Mapea el nombre que guardamos en BBDD a un IconData de Material Icons.
/// Si no encuentra el nombre, devuelve un icono genérico.
/// 
/// Iconos correspondientes a las 7 categorías finales:
/// - musica: music_note
/// - gastronomia: restaurant
/// - deportes: sports_soccer
/// - arte-y-cultura: palette
/// - aire-libre: hiking
/// - tradiciones: festival
/// - mercadillos: storefront
IconData iconFromName(String? name) {
  if (name == null) return Icons.event;
  
  switch (name.toLowerCase()) {
    // Categorías principales
    case 'music_note':
    case 'music':
    case 'musica':
      return Icons.music_note;
    
    case 'restaurant':
    case 'gastronomia':
    case 'gastronomía':
      return Icons.restaurant;
    
    case 'sports_soccer':
    case 'sports':
    case 'deportes':
    case 'deporte':
      return Icons.sports_soccer;
    
    case 'palette':
    case 'arte':
    case 'cultura':
    case 'arte-y-cultura':
      return Icons.palette;
    
    case 'hiking':
    case 'aire-libre':
    case 'aire libre':
    case 'naturaleza':
      return Icons.hiking;
    
    case 'festival':
    case 'tradiciones':
    case 'tradicion':
    case 'tradición':
      return Icons.festival;
    
    case 'storefront':
    case 'store':
    case 'mercadillos':
    case 'mercados':
    case 'mercadillo':
    case 'mercado':
      return Icons.storefront;
    
    // Iconos legados (mantener compatibilidad)
    case 'celebration':
      return Icons.celebration;
    case 'directions_run':
      return Icons.directions_run;
    case 'local_bar':
      return Icons.local_bar;
    case 'theater_comedy':
      return Icons.theater_comedy;
    case 'motor':
      return Icons.directions_car;
    
    default:
      return Icons.event; // fallback genérico
  }
}
