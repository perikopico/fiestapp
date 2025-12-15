/// Configuración centralizada para el sistema de venues
class VenueConfig {
  VenueConfig._();

  // ============================================
  // Búsqueda
  // ============================================
  /// Longitud mínima de texto para buscar en Google Places
  static const int minSearchLength = 3;
  
  /// Debounce para búsquedas cortas (1-2 caracteres)
  static const Duration debounceShort = Duration(milliseconds: 800);
  
  /// Debounce para búsquedas normales (3+ caracteres)
  static const Duration debounceNormal = Duration(milliseconds: 400);
  
  /// Número máximo de resultados en búsqueda
  static const int maxSearchResults = 5;
  
  /// Número máximo de lugares similares a mostrar
  static const int maxSimilarVenues = 5;

  // ============================================
  // Similitud
  // ============================================
  /// Umbral de similitud para nombres normalizados (ignorando palabras comunes)
  static const double similarityThresholdNormalized = 0.4;
  
  /// Umbral de similitud para nombres originales (para detectar typos)
  static const double similarityThresholdOriginal = 0.5;
  
  /// Umbral de similitud para considerar un lugar como duplicado
  static const double similarityThresholdDuplicate = 0.9;

  // ============================================
  // Cache
  // ============================================
  /// Tiempo de expiración del cache de búsquedas
  static const Duration cacheExpiration = Duration(minutes: 5);
  
  /// Tamaño máximo del cache de búsquedas
  static const int maxCacheSize = 50;
  
  /// Intervalo de limpieza del cache
  static const Duration cacheCleanupInterval = Duration(minutes: 2);

  // ============================================
  // Validación
  // ============================================
  /// Longitud máxima de query de búsqueda
  static const int maxQueryLength = 100;
  
  /// Distancia máxima desde la ciudad para validar coordenadas (en km)
  static const double maxDistanceFromCityKm = 50.0;
  
  /// Longitud mínima del nombre de un lugar
  static const int minVenueNameLength = 2;
  
  /// Longitud máxima del nombre de un lugar
  static const int maxVenueNameLength = 200;
}

