import 'dart:math' show sin, cos, sqrt, asin, pi;

import 'validation_utils.dart';

/// Utilidades para cálculo de distancias geodésicas (Haversine) y formato de visualización.
///
/// Estrategia híbrida:
/// - Lista/EventCard: solo Haversine × factor tortuosidad (1.5), sin APIs externas.
/// - EventDetailScreen: reservado para `fetchPreciseDistance` (Google Distance Matrix) en el futuro.
class DistanceUtils {
  DistanceUtils._();

  /// Radio terrestre medio en km (WGS84 aproximado).
  static const double earthRadiusKm = 6371.0;

  /// Factor de tortuosidad: orografía montaña/costa (~50% mayor que línea recta).
  static const double tortuosityFactor = 1.5;

  /// Distancia geodésica en km entre dos puntos (fórmula de Haversine).
  /// Retorna `null` si alguna coordenada es inválida.
  static double? haversineKm(
    double? lat1,
    double? lng1,
    double? lat2,
    double? lng2,
  ) {
    if (!ValidationUtils.isValidCoordinates(lat1, lng1) ||
        !ValidationUtils.isValidCoordinates(lat2, lng2)) {
      return null;
    }
    final phi1 = _rad(lat1!);
    final phi2 = _rad(lat2!);
    final deltaPhi = _rad(lat2 - lat1);
    final deltaLambda = _rad(lng2! - lng1!);
    final a = sin(deltaPhi / 2) * sin(deltaPhi / 2) +
        cos(phi1) * cos(phi2) * sin(deltaLambda / 2) * sin(deltaLambda / 2);
    final c = 2 * asin(sqrt(a));
    return earthRadiusKm * c;
  }

  static double _rad(double deg) => deg * (pi / 180.0);

  /// Distancia estimada en carretera: Haversine × factor de tortuosidad (1.5).
  /// Redondeada a 1 decimal. Retorna `null` si las coordenadas son inválidas.
  static double? estimatedRoadDistanceKm(
    double? userLat,
    double? userLng,
    double? venueLat,
    double? venueLng,
  ) {
    final d = haversineKm(userLat, userLng, venueLat, venueLng);
    if (d == null) return null;
    final adjusted = d * tortuosityFactor;
    return (adjusted * 10).round() / 10.0;
  }

  /// Formato para mostrar en UI: "~ 12.5 km" si ≤100 km, "~ 120 km" si >100 km (sin decimales).
  /// El "~" denota que es una estimación.
  static String formatDistanceDisplay(double km) {
    if (km > 100) {
      return '~ ${km.round()} km';
    }
    return '~ ${km.toStringAsFixed(1)} km';
  }
}
