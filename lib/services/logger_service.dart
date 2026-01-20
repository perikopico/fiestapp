import 'package:logger/logger.dart';
import 'package:flutter/foundation.dart' show kDebugMode;

/// Servicio de logging estructurado
class LoggerService {
  LoggerService._();
  static final instance = LoggerService._();

  late final Logger _logger = Logger(
    printer: PrettyPrinter(
      methodCount: 2,
      errorMethodCount: 8,
      lineLength: 120,
      colors: true,
      printEmojis: true,
      printTime: true,
    ),
    level: kDebugMode ? Level.debug : Level.warning,
  );

  void debug(String message, {Map<String, dynamic>? data}) {
    _logger.d(message, error: data);
  }

  void info(String message, {Map<String, dynamic>? data}) {
    _logger.i(message, error: data);
  }

  void warning(String message, {Map<String, dynamic>? data}) {
    _logger.w(message, error: data);
  }

  void error(String message, {dynamic error, StackTrace? stackTrace}) {
    _logger.e(message, error: error, stackTrace: stackTrace);
  }

  void fatal(String message, {dynamic error, StackTrace? stackTrace}) {
    _logger.f(message, error: error, stackTrace: stackTrace);
  }
}
