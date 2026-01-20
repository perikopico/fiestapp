/// Utilidades de validación para la aplicación
class ValidationUtils {
  ValidationUtils._();

  /// Valida si una URL es válida
  static bool isValidUrl(String? url) {
    if (url == null || url.isEmpty) return false;
    
    try {
      final uri = Uri.parse(url);
      return uri.hasScheme && (uri.scheme == 'http' || uri.scheme == 'https');
    } catch (e) {
      return false;
    }
  }

  /// Valida si un email es válido (formato básico)
  static bool isValidEmail(String? email) {
    if (email == null || email.isEmpty) return false;
    
    final emailRegex = RegExp(
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
    );
    return emailRegex.hasMatch(email);
  }

  /// Valida si una coordenada de latitud es válida
  static bool isValidLatitude(double? lat) {
    if (lat == null) return false;
    return lat >= -90.0 && lat <= 90.0;
  }

  /// Valida si una coordenada de longitud es válida
  static bool isValidLongitude(double? lng) {
    if (lng == null) return false;
    return lng >= -180.0 && lng <= 180.0;
  }

  /// Valida si un par de coordenadas (lat, lng) es válido
  static bool isValidCoordinates(double? lat, double? lng) {
    return isValidLatitude(lat) && isValidLongitude(lng);
  }

  /// Valida si un string no está vacío o solo contiene espacios
  static bool isNotEmpty(String? text) {
    return text != null && text.trim().isNotEmpty;
  }

  /// Valida si un número está en un rango
  static bool isInRange(num value, num min, num max) {
    return value >= min && value <= max;
  }

  /// Sanitiza un string removiendo caracteres peligrosos
  static String sanitizeString(String input) {
    // Remover caracteres de control y normalizar espacios
    return input
        .replaceAll(RegExp(r'[\x00-\x1F\x7F]'), '')
        .trim()
        .replaceAll(RegExp(r'\s+'), ' ');
  }

  /// Valida formato de fecha ISO 8601
  static bool isValidIso8601Date(String? dateString) {
    if (dateString == null || dateString.isEmpty) return false;
    
    try {
      DateTime.parse(dateString);
      return true;
    } catch (e) {
      return false;
    }
  }

  /// Normaliza un número de teléfono básico (remueve espacios y caracteres especiales)
  static String? normalizePhoneNumber(String? phone) {
    if (phone == null || phone.isEmpty) return null;
    
    // Remover espacios, guiones y paréntesis
    final normalized = phone.replaceAll(RegExp(r'[\s\-\(\)]'), '');
    
    // Debe empezar con + o ser solo números
    if (normalized.startsWith('+') || RegExp(r'^\d+$').hasMatch(normalized)) {
      return normalized;
    }
    
    return null;
  }
}
