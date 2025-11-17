import 'package:flutter/material.dart';

/// Mapea el nombre que guardamos en BBDD a un IconData de Material Icons.
/// Si no encuentra el nombre, devuelve un icono genérico.
IconData iconFromName(String? name) {
  switch (name) {
    case 'celebration':
      return Icons.celebration;
    case 'storefront':
      return Icons.storefront;
    case 'directions_run':
      return Icons.directions_run;
    case 'music_note':
      return Icons.music_note;
    // Puedes ir añadiendo más aquí a medida que incorpores categorías:
    case 'hiking':
      return Icons.hiking;
    case 'local_bar':
      return Icons.local_bar;
    case 'festival':
      return Icons.festival;
    case 'theater_comedy':
      return Icons.theater_comedy;
    case 'palette':
      return Icons.palette;
    default:
      return Icons.event; // fallback
  }
}
