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
  bool _listenerSetup = false;
  
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
      // Solo consultar estado; no pedir permiso (evita diálogo al arranque)
      final settings = await _messaging!.getNotificationSettings();
      
      if (settings.authorizationStatus == AuthorizationStatus.authorized) {
        await _fetchTokenAndSetupListener();
      }
      _isInitialized = true;
    } catch (e) {
      debugPrint('❌ Error al inicializar FCMTokenService: $e');
      _isInitialized = true;
    }
  }

  /// Solicita permiso de notificaciones cuando la app ya mostró video/onboarding (p. ej. al entrar en el Dashboard).
  Future<void> requestPermissionIfNeeded() async {
    if (!_isInitialized) await initialize();
    if (_messaging == null) return;
    final settings = await _messaging!.getNotificationSettings();
    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      await _fetchTokenAndSetupListener();
      return;
    }
    try {
      final newSettings = await _messaging!.requestPermission(
        alert: true,
        badge: true,
        sound: true,
      );
      if (newSettings.authorizationStatus == AuthorizationStatus.authorized) {
        await _fetchTokenAndSetupListener();
      } else {
        debugPrint("⚠️ Permisos de notificación: ${newSettings.authorizationStatus}");
      }
    } catch (e) {
      debugPrint('❌ Error al solicitar permiso FCM: $e');
    }
  }

  Future<void> _fetchTokenAndSetupListener() async {
    if (_messaging == null) return;
    if (Platform.isIOS) {
      for (int attempt = 0; attempt < 5; attempt++) {
        try {
          final apnsToken = await _messaging!.getAPNSToken();
          if (apnsToken != null) break;
          if (attempt < 4) await Future.delayed(Duration(seconds: (attempt + 1) * 2));
        } catch (e) {
          if (attempt < 4) await Future.delayed(Duration(seconds: (attempt + 1) * 2));
        }
      }
    }
    try {
      final token = await _messaging!.getToken();
      if (token != null && token.isNotEmpty) {
        _currentToken = token;
        if (_authService.isAuthenticated) await saveTokenToSupabase(token);
      }
    } catch (e) {
      debugPrint("⚠️ No se pudo obtener token FCM: $e");
    }
    if (!_listenerSetup) {
      _listenerSetup = true;
      _messaging!.onTokenRefresh.listen((newToken) {
        _currentToken = newToken;
        if (_authService.isAuthenticated) {
          saveTokenToSupabase(newToken).catchError((e) {
            debugPrint('❌ Error al guardar token actualizado: $e');
          });
        }
      });
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
      }
      // No pedir permiso aquí; usar requestPermissionIfNeeded() desde el Dashboard
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
