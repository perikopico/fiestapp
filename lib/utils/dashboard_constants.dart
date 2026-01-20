/// Constantes del dashboard para evitar números mágicos
class DashboardConstants {
  DashboardConstants._();

  // Radio por defecto
  static const double defaultRadiusKm = 15.0;
  static const double maxRadiusKm = 100.0;
  static const double expandedRadiusKm = 50.0;

  // Límites de eventos
  static const int featuredEventsLimit = 7;
  static const int upcomingEventsLimit = 50;
  static const int popularEventsLimit = 10;

  // Duración del hero slider
  static const Duration heroSlideDuration = Duration(seconds: 7);

  // TTL de caché
  static const Duration categoriesCacheTTL = Duration(minutes: 30);
  static const Duration citiesCacheTTL = Duration(minutes: 30);

  // Tamaños de batch para consultas
  static const int queryBatchSize = 50;

  // Ubicación por defecto (Barbate)
  static const double defaultLat = 36.1927;
  static const double defaultLng = -5.9219;
}
