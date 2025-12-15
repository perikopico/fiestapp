/// Excepciones personalizadas para el servicio de venues
enum VenueErrorType {
  network,
  duplicate,
  validation,
  permission,
  notFound,
  unknown,
}

class VenueException implements Exception {
  final VenueErrorType type;
  final String message;
  final dynamic originalError;
  
  VenueException(this.type, this.message, [this.originalError]);
  
  @override
  String toString() => message;
  
  /// Crea una excepción de tipo duplicate
  factory VenueException.duplicate(String message, [dynamic originalError]) {
    return VenueException(VenueErrorType.duplicate, message, originalError);
  }
  
  /// Crea una excepción de tipo validation
  factory VenueException.validation(String message) {
    return VenueException(VenueErrorType.validation, message);
  }
  
  /// Crea una excepción de tipo network
  factory VenueException.network(String message, [dynamic originalError]) {
    return VenueException(VenueErrorType.network, message, originalError);
  }
  
  /// Crea una excepción de tipo permission
  factory VenueException.permission(String message) {
    return VenueException(VenueErrorType.permission, message);
  }
  
  /// Crea una excepción de tipo notFound
  factory VenueException.notFound(String message) {
    return VenueException(VenueErrorType.notFound, message);
  }
}

