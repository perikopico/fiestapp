// lib/services/fcm_token_service.dart
import 'dart:io' show Platform;
import 'package:flutter/foundation.dart' show debugPrint, kIsWeb;
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
// device_info_plus es opcional - si no está instalado, simplemente no usaremos info del dispositivo
import 'auth_service.dart';

/// Servicio para gestionar tokens FCM y guardarlos en Supabase
class FCMTokenService {
  FCMTokenService._();
  
  static final FCMTokenService instance = FCMTokenService._();
  
  final _authService = AuthService.instance;
  FirebaseMessaging? _messaging;
  String? _currentToken;
  bool _isInitialized = false;
  
  SupabaseClient? get _client {
    try {
      return Supabase.instance.client;
    } catch (e) {
      debugPrint('⚠️ Supabase no está inicializado en FCMTokenService: $e');
      return null;
    }
  }
  
  /// Inicializa el servicio de tokens FCM
  Future<void> initialize() async {
    if (_isInitialized) return;
    
    try {
      _messaging = FirebaseMessaging.instance;
      
      // Solicitar permisos de notificación
      final settings = await _messaging!.requestPermission(
        alert: true,
        badge: true,
        sound: true,
      );
      
      if (settings.authorizationStatus == AuthorizationStatus.authorized) {
        debugPrint("✅ Permisos de notificación concedidos");
        
        // En iOS, primero debemos obtener el token APNS antes del token FCM
        if (Platform.isIOS) {
          bool apnsTokenObtained = false;
          // Intentar obtener el token APNS con múltiples reintentos
          for (int attempt = 0; attempt < 5; attempt++) {
            try {
              final apnsToken = await _messaging!.getAPNSToken();
              if (apnsToken != null) {
                debugPrint("✅ Token APNS obtenido: ${apnsToken.substring(0, 20)}...");
                apnsTokenObtained = true;
                break;
              } else {
                if (attempt < 4) {
                  debugPrint("⚠️ Token APNS es null, reintentando en ${(attempt + 1) * 2} segundos... (intento ${attempt + 1}/5)");
                  await Future.delayed(Duration(seconds: (attempt + 1) * 2));
                }
              }
            } catch (e) {
              debugPrint("⚠️ Error al obtener token APNS (intento ${attempt + 1}/5): $e");
              if (attempt < 4) {
                await Future.delayed(Duration(seconds: (attempt + 1) * 2));
              }
            }
          }
          
          if (!apnsTokenObtained) {
            debugPrint("⚠️ No se pudo obtener token APNS después de 5 intentos");
            debugPrint("⚠️ El token FCM puede no estar disponible hasta que el token APNS esté listo");
            debugPrint("⚠️ Esto es normal en iOS - el token se obtendrá automáticamente cuando esté disponible");
            // No lanzar error, simplemente continuar - el token se obtendrá más tarde
          }
        }
        
        // Obtener token inicial (puede fallar en iOS si APNS no está listo, pero no es crítico)
        String? token;
        try {
          token = await _messaging!.getToken();
        } catch (e) {
          debugPrint("⚠️ No se pudo obtener token FCM inicialmente: $e");
          if (Platform.isIOS) {
            debugPrint("⚠️ Esto es normal en iOS si el token APNS aún no está disponible");
            debugPrint("⚠️ El token se obtendrá automáticamente cuando el token APNS esté listo");
          }
          // No lanzar error, el token se obtendrá más tarde cuando esté disponible
        }
        if (token != null && token.isNotEmpty) {
          _currentToken = token;
          debugPrint("🔑 FCM TOKEN obtenido: ${token.substring(0, 20)}...");
          
          // Guardar token si el usuario está autenticado
          if (_authService.isAuthenticated) {
            await saveTokenToSupabase(token);
          }
        } else {
          debugPrint("⚠️ Token FCM no disponible aún - se obtendrá cuando esté listo");
        }
        
        // Escuchar cambios en el token
        _messaging!.onTokenRefresh.listen((newToken) {
          debugPrint("🔄 FCM TOKEN ACTUALIZADO");
          _currentToken = newToken;
          if (_authService.isAuthenticated) {
            saveTokenToSupabase(newToken).catchError((e) {
              debugPrint('❌ Error al guardar token actualizado: $e');
            });
          }
        });
      } else {
        debugPrint("⚠️ Permisos de notificación: ${settings.authorizationStatus}");
      }
      
      _isInitialized = true;
    } catch (e) {
      debugPrint('❌ Error al inicializar FCMTokenService: $e');
    }
  }
  
  /// Guarda el token FCM en Supabase
  Future<void> saveTokenToSupabase(String? token) async {
    if (token == null || token.isEmpty) {
      debugPrint('⚠️ Token FCM es nulo o vacío');
      return;
    }
    
    final client = _client;
    if (client == null) {
      debugPrint('⚠️ No se puede guardar token: Supabase no inicializado');
      return;
    }
    
    if (!_authService.isAuthenticated) {
      debugPrint('⚠️ No se puede guardar token: usuario no autenticado');
      return;
    }
    
    final userId = _authService.currentUserId;
    if (userId == null) {
      debugPrint('⚠️ No se puede guardar token: userId es nulo');
      return;
    }
    
    try {
      // Obtener información del dispositivo
      final deviceType = _getDeviceType();
      final deviceInfo = await _getDeviceInfo();
      
      // Insertar o actualizar token (usando upsert)
      await client.from('user_fcm_tokens').upsert(
        {
          'user_id': userId,
          'token': token,
          'device_type': deviceType,
          'device_info': deviceInfo,
          'updated_at': DateTime.now().toIso8601String(),
        },
        onConflict: 'user_id,token',
      );
      
      _currentToken = token;
      debugPrint('✅ Token FCM guardado en Supabase');
    } catch (e) {
      debugPrint('❌ Error al guardar token FCM en Supabase: $e');
      rethrow;
    }
  }
  
  /// Elimina el token FCM de Supabase (cuando el usuario cierra sesión)
  Future<void> deleteTokenFromSupabase(String? token) async {
    if (token == null || token.isEmpty) return;
    
    final client = _client;
    if (client == null) return;
    
    final userId = _authService.currentUserId;
    if (userId == null) return;
    
    try {
      await client
          .from('user_fcm_tokens')
          .delete()
          .eq('user_id', userId)
          .eq('token', token);
      
      debugPrint('✅ Token FCM eliminado de Supabase');
    } catch (e) {
      debugPrint('❌ Error al eliminar token FCM: $e');
    }
  }
  
  /// Obtiene el token FCM actual
  Future<String?> getCurrentToken() async {
    if (!_isInitialized) {
      await initialize();
    }
    
    // Si ya tenemos un token guardado, retornarlo
    if (_currentToken != null) {
      return _currentToken;
    }
    
    try {
      // Verificar permisos primero
      final messaging = FirebaseMessaging.instance;
      final settings = await messaging.getNotificationSettings();
      
      if (settings.authorizationStatus == AuthorizationStatus.authorized) {
        // En iOS, primero debemos obtener el token APNS antes del token FCM
        if (Platform.isIOS) {
          try {
            final apnsToken = await messaging.getAPNSToken();
            if (apnsToken == null) {
              debugPrint("⚠️ Token APNS es null, esperando...");
              await Future.delayed(const Duration(seconds: 1));
              await messaging.getAPNSToken();
            }
          } catch (e) {
            debugPrint("⚠️ Error al obtener token APNS: $e");
          }
        }
        
        _currentToken = await messaging.getToken();
        if (_currentToken != null) {
          debugPrint("🔑 FCM TOKEN obtenido: ${_currentToken!.substring(0, 20)}...");
        }
        return _currentToken;
      } else {
        debugPrint('⚠️ Permisos de notificación no concedidos: ${settings.authorizationStatus}');
        // Intentar solicitar permisos de nuevo
        final newSettings = await messaging.requestPermission(
          alert: true,
          badge: true,
          sound: true,
        );
        
        if (newSettings.authorizationStatus == AuthorizationStatus.authorized) {
          // En iOS, primero debemos obtener el token APNS antes del token FCM
          if (Platform.isIOS) {
            try {
              final apnsToken = await messaging.getAPNSToken();
              if (apnsToken == null) {
                debugPrint("⚠️ Token APNS es null, esperando...");
                await Future.delayed(const Duration(seconds: 1));
                await messaging.getAPNSToken();
              }
            } catch (e) {
              debugPrint("⚠️ Error al obtener token APNS: $e");
            }
          }
          
          _currentToken = await messaging.getToken();
          if (_currentToken != null) {
            debugPrint("🔑 FCM TOKEN obtenido después de conceder permisos: ${_currentToken!.substring(0, 20)}...");
          }
          return _currentToken;
        }
      }
      
      return null;
    } catch (e) {
      debugPrint('❌ Error al obtener token FCM: $e');
      return null;
    }
  }
  
  /// Obtiene todos los tokens de un usuario (útil para enviar notificaciones)
  Future<List<String>> getUserTokens(String userId) async {
    final client = _client;
    if (client == null) return [];
    
    try {
      final response = await client
          .from('user_fcm_tokens')
          .select('token')
          .eq('user_id', userId);
      
      return (response as List)
          .map((row) => row['token'] as String)
          .toList();
    } catch (e) {
      debugPrint('❌ Error al obtener tokens del usuario: $e');
      return [];
    }
  }
  
  /// Obtiene el tipo de dispositivo
  String _getDeviceType() {
    if (kIsWeb) return 'web';
    if (Platform.isAndroid) return 'android';
    if (Platform.isIOS) return 'ios';
    return 'unknown';
  }
  
  /// Obtiene información del dispositivo (opcional)
  Future<String?> _getDeviceInfo() async {
    try {
      if (kIsWeb) {
        return 'web';
      }
      
      // Información básica sin necesidad de device_info_plus
      if (Platform.isAndroid) {
        return 'Android';
      } else if (Platform.isIOS) {
        return 'iOS';
      }
      
      return null;
    } catch (e) {
      debugPrint('⚠️ Error al obtener info del dispositivo: $e');
      return null;
    }
  }
}
