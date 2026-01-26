import 'package:logger/logger.dart';
import 'package:flutter/foundation.dart' show kDebugMode;

/// Servicio de logging estructurado con niveles condicionales
class LoggerService {
  LoggerService._();
  static final instance = LoggerService._();

  /// Flag para habilitar logs detallados (solo en desarrollo)
  static const bool _enableVerboseLogs = kDebugMode;

  late final Logger _logger = Logger(
    printer: PrettyPrinter(
      methodCount: _enableVerboseLogs ? 2 : 0,
      errorMethodCount: _enableVerboseLogs ? 8 : 3,
      lineLength: 120,
      colors: true,
      printEmojis: true,
      printTime: _enableVerboseLogs,
    ),
    level: kDebugMode ? Level.debug : Level.warning,
  );

  /// Log de debug (solo en modo debug)
  void debug(String message, {Map<String, dynamic>? data}) {
    if (_enableVerboseLogs) {
      _logger.d(message, error: data);
    }
  }

  /// Log informativo (siempre visible)
  void info(String message, {Map<String, dynamic>? data}) {
    _logger.i(message, error: data);
  }

  /// Log de advertencia (siempre visible)
  void warning(String message, {Map<String, dynamic>? data}) {
    _logger.w(message, error: data);
  }

  /// Log de error (siempre visible)
  void error(String message, {dynamic error, StackTrace? stackTrace}) {
    _logger.e(message, error: error, stackTrace: stackTrace);
  }

  /// Log fatal (siempre visible)
  void fatal(String message, {dynamic error, StackTrace? stackTrace}) {
    _logger.f(message, error: error, stackTrace: stackTrace);
  }
}
