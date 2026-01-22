import 'package:url_launcher/url_launcher.dart';
import 'package:flutter/material.dart';
import 'validation_utils.dart';
import '../services/logger_service.dart';
import '../services/error_handler_service.dart';

/// Helper para manejar apertura de URLs de forma segura
class UrlHelper {
  UrlHelper._();

  /// Abre una URL de forma segura con validación previa
  static Future<bool> launchUrlSafely(
    BuildContext context,
    String? url, {
    LaunchMode mode = LaunchMode.externalApplication,
    String? errorMessage,
  }) async {
    // Validar que la URL no sea null o vacía
    if (!ValidationUtils.isNotEmpty(url)) {
      if (context.mounted) {
        ErrorHandlerService.instance.handleError(
          context,
          Exception('URL no válida'),
          customMessage: errorMessage ?? 'La URL proporcionada no es válida',
        );
      }
      return false;
    }

    // Validar formato de URL
    if (!ValidationUtils.isValidUrl(url!)) {
      LoggerService.instance.warning('Intento de abrir URL inválida', data: {'url': url});
      if (context.mounted) {
        ErrorHandlerService.instance.handleError(
          context,
          Exception('URL inválida'),
          customMessage: errorMessage ?? 'La URL proporcionada no tiene un formato válido',
        );
      }
      return false;
    }

    try {
      final uri = Uri.parse(url);
      
      // Verificar que se puede lanzar la URL
      if (!await canLaunchUrl(uri)) {
        LoggerService.instance.warning('No se puede lanzar URL', data: {'url': url});
        if (context.mounted) {
          ErrorHandlerService.instance.handleError(
            context,
            Exception('No se puede abrir la URL'),
            customMessage: errorMessage ?? 'No se puede abrir esta URL. Por favor, verifica tu conexión.',
          );
        }
        return false;
      }

      // Lanzar la URL
      final launched = await launchUrl(uri, mode: mode);
      
      if (launched) {
        LoggerService.instance.info('URL abierta exitosamente', data: {'url': url});
      } else {
        LoggerService.instance.warning('Fallo al abrir URL', data: {'url': url});
      }
      
      return launched;
    } catch (e) {
      LoggerService.instance.error('Error al abrir URL', error: e);
      if (context.mounted) {
        ErrorHandlerService.instance.handleError(
          context,
          e,
          customMessage: errorMessage ?? 'Error al abrir la URL. Por favor, intenta de nuevo.',
        );
      }
      return false;
    }
  }

  /// Abre Google Maps con direcciones a coordenadas
  static Future<bool> openGoogleMapsDirections(
    BuildContext context,
    double lat,
    double lng, {
    String? errorMessage,
  }) async {
    // Validar coordenadas
    if (!ValidationUtils.isValidCoordinates(lat, lng)) {
      LoggerService.instance.warning('Coordenadas inválidas para Google Maps', data: {'lat': lat, 'lng': lng});
      if (context.mounted) {
        ErrorHandlerService.instance.handleError(
          context,
          Exception('Coordenadas inválidas'),
          customMessage: errorMessage ?? 'Las coordenadas proporcionadas no son válidas',
        );
      }
      return false;
    }

    final directionsUrl = 'https://www.google.com/maps/dir/?api=1&destination=$lat,$lng';
    return launchUrlSafely(
      context,
      directionsUrl,
      errorMessage: errorMessage ?? 'No se puede abrir Google Maps. Por favor, verifica que tengas la app instalada.',
    );
  }

  /// Abre Google Maps con una URL de mapa
  static Future<bool> openGoogleMapsUrl(
    BuildContext context,
    String? mapsUrl, {
    String? errorMessage,
  }) async {
    return launchUrlSafely(
      context,
      mapsUrl,
      errorMessage: errorMessage ?? 'No se puede abrir Google Maps',
    );
  }
}
