import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'logger_service.dart';

/// Tipos de errores comunes
enum ErrorType {
  network,
  permission,
  authentication,
  database,
  unknown,
}

/// Servicio centralizado para manejo de errores
class ErrorHandlerService {
  ErrorHandlerService._();
  static final instance = ErrorHandlerService._();

  /// Maneja un error y muestra el mensaje apropiado al usuario
  void handleError(
    BuildContext context,
    dynamic error, {
    String? customMessage,
    VoidCallback? onRetry,
  }) {
    // Log del error
    LoggerService.instance.error('Error en la aplicación', error: error);

    // Determinar tipo de error
    final errorType = _getErrorType(error);
    final message = customMessage ?? _getErrorMessage(errorType, error);

    // Mostrar snackbar o diálogo según el tipo de error
    if (errorType == ErrorType.network) {
      _showNetworkError(context, message, onRetry);
    } else if (errorType == ErrorType.permission) {
      _showPermissionError(context, message);
    } else if (errorType == ErrorType.authentication) {
      _showAuthError(context, message);
    } else {
      _showGenericError(context, message, onRetry);
    }
  }

  /// Determina el tipo de error basándose en la excepción
  ErrorType _getErrorType(dynamic error) {
    final errorString = error.toString().toLowerCase();
    
    if (errorString.contains('network') ||
        errorString.contains('connection') ||
        errorString.contains('timeout') ||
        errorString.contains('socket')) {
      return ErrorType.network;
    }
    
    if (errorString.contains('permission') ||
        errorString.contains('denied') ||
        errorString.contains('location')) {
      return ErrorType.permission;
    }
    
    if (errorString.contains('auth') ||
        errorString.contains('unauthorized') ||
        errorString.contains('login')) {
      return ErrorType.authentication;
    }
    
    if (errorString.contains('database') ||
        errorString.contains('supabase') ||
        errorString.contains('sql')) {
      return ErrorType.database;
    }
    
    return ErrorType.unknown;
  }

  /// Obtiene el mensaje de error amigable para el usuario
  String _getErrorMessage(ErrorType type, dynamic error) {
    switch (type) {
      case ErrorType.network:
        return 'Error de conexión. Por favor, verifica tu conexión a internet.';
      case ErrorType.permission:
        return 'Se necesitan permisos para continuar. Por favor, verifica los permisos en la configuración.';
      case ErrorType.authentication:
        return 'Error de autenticación. Por favor, inicia sesión nuevamente.';
      case ErrorType.database:
        return 'Error al cargar los datos. Por favor, intenta de nuevo más tarde.';
      case ErrorType.unknown:
        return 'Ha ocurrido un error inesperado. Por favor, intenta de nuevo.';
    }
  }

  /// Muestra error de red con opción de reintentar
  void _showNetworkError(BuildContext context, String message, VoidCallback? onRetry) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: const Duration(seconds: 4),
        action: onRetry != null
            ? SnackBarAction(
                label: 'Reintentar',
                onPressed: onRetry,
              )
            : null,
      ),
    );
  }

  /// Muestra error de permisos
  void _showPermissionError(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: const Duration(seconds: 5),
        backgroundColor: Colors.orange,
      ),
    );
  }

  /// Muestra error de autenticación
  void _showAuthError(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: const Duration(seconds: 4),
        backgroundColor: Colors.red,
      ),
    );
  }

  /// Muestra error genérico
  void _showGenericError(BuildContext context, String message, VoidCallback? onRetry) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: const Duration(seconds: 3),
        action: onRetry != null
            ? SnackBarAction(
                label: 'Reintentar',
                onPressed: onRetry,
              )
            : null,
      ),
    );
  }
}
