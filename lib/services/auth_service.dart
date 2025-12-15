import 'dart:async';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter/foundation.dart' show debugPrint, kIsWeb;

/// Servicio de autenticación usando Supabase Auth
/// Soporta login con Google OAuth y email/password
class AuthService {
  AuthService._();
  
  static final AuthService instance = AuthService._();
  
  SupabaseClient? get _client {
    try {
      return Supabase.instance.client;
    } catch (e) {
      debugPrint('⚠️ Supabase no está inicializado: $e');
      return null;
    }
  }
  
  /// Obtiene el usuario actual (null si no está autenticado)
  User? get currentUser {
    try {
      return _client?.auth.currentUser;
    } catch (e) {
      debugPrint('⚠️ Error al obtener usuario actual: $e');
      return null;
    }
  }
  
  /// Stream que emite cambios en el estado de autenticación
  Stream<AuthState> get authStateChanges {
    final client = _client;
    if (client == null) {
      // Si Supabase no está disponible, retornar un stream que emite
      // un evento inicial indicando que no hay sesión
      return Stream.value(
        AuthState(
          AuthChangeEvent.signedOut,
          null,
        ),
      );
    }
    return client.auth.onAuthStateChange;
  }
  
  /// Verifica si hay un usuario autenticado
  bool get isAuthenticated {
    try {
      return currentUser != null;
    } catch (e) {
      debugPrint('⚠️ Error al verificar autenticación: $e');
      return false;
    }
  }
  
  /// Obtiene el email del usuario actual
  String? get currentUserEmail => currentUser?.email;
  
  /// Obtiene el ID del usuario actual
  String? get currentUserId => currentUser?.id;
  
  /// Inicia sesión con email y contraseña
  /// Verifica que el usuario no esté marcado como eliminado
  Future<void> signInWithEmail({
    required String email,
    required String password,
  }) async {
    final client = _client;
    if (client == null) {
      throw Exception('Supabase no está inicializado. Verifica tu conexión.');
    }
    
    try {
      final response = await client.auth.signInWithPassword(
        email: email,
        password: password,
      );
      
      if (response.user == null) {
        throw Exception('Error al iniciar sesión: usuario no encontrado');
      }
      
      // Verificar si el usuario está marcado como eliminado
      // IMPORTANTE: Hacer esto ANTES de que el listener de authStateChange procese el login
      try {
        final deletedCheck = await client
            .from('deleted_users')
            .select('user_id, deleted_at')
            .eq('user_id', response.user!.id)
            .maybeSingle();
        
        if (deletedCheck != null) {
          // Usuario está marcado como eliminado, cerrar sesión inmediatamente
          debugPrint('⚠️ Usuario marcado como eliminado, cerrando sesión: ${response.user!.email}');
          // Cerrar sesión ANTES de lanzar el error
          await client.auth.signOut();
          // Lanzar error con mensaje claro
          throw Exception('Esta cuenta ha sido eliminada. No puedes iniciar sesión.');
        }
      } catch (e) {
        // Si hay error al verificar (tabla no existe, etc.), continuar normalmente
        // pero loggear el error
        final errorStr = e.toString();
        if (errorStr.contains('eliminada') || errorStr.contains('eliminado')) {
          // Re-lanzar si es nuestro error de cuenta eliminada
          rethrow;
        }
        debugPrint('⚠️ No se pudo verificar si el usuario está eliminado: $e');
        // Continuar con el login si no es nuestro error
      }
      
      debugPrint('✅ Usuario autenticado: ${response.user!.email}');
    } catch (e) {
      debugPrint('❌ Error al iniciar sesión: $e');
      rethrow;
    }
  }
  
  /// Registra un nuevo usuario con email y contraseña
  Future<void> signUpWithEmail({
    required String email,
    required String password,
  }) async {
    final client = _client;
    if (client == null) {
      throw Exception('Supabase no está inicializado. Verifica tu conexión.');
    }
    
    try {
      // URL a la que se redirige después de confirmar el email.
      // En móvil usamos un deep link que abre la app directamente.
      // En web usamos una página HTML que muestra un mensaje de confirmación.
      // Asegúrate de que estas URLs estén añadidas en
      // Supabase → Authentication → URL configuration → Redirect URLs.
      const redirectUrl = kIsWeb
          ? 'https://queplan-app.com/auth/confirmed'
          : 'io.supabase.fiestapp://auth/confirmed';
      
      final response = await client.auth.signUp(
        email: email,
        password: password,
        emailRedirectTo: redirectUrl,
      );
      
      if (response.user == null) {
        throw Exception('Error al registrarse: no se pudo crear el usuario');
      }
      
      debugPrint('✅ Usuario registrado: ${response.user!.email}');
      debugPrint('📍 URL de redirección para confirmación: $redirectUrl');
    } catch (e) {
      debugPrint('❌ Error al registrarse: $e');
      rethrow;
    }
  }
  
  /// Inicia sesión con Google OAuth
  Future<void> signInWithGoogle() async {
    final client = _client;
    if (client == null) {
      throw Exception('Supabase no está inicializado. Verifica tu conexión.');
    }
    
    try {
      // Especificar el deep link explícitamente para Android/iOS
      const deepLinkUrl = 'io.supabase.fiestapp://login-callback';
      
      if (kIsWeb) {
        await client.auth.signInWithOAuth(
          OAuthProvider.google,
          redirectTo: '${Uri.base.origin}/auth/callback',
        );
      } else {
        // En móvil, especificamos explícitamente el deep link
        await client.auth.signInWithOAuth(
          OAuthProvider.google,
          redirectTo: deepLinkUrl,
        );
      }
      
      debugPrint('✅ Redirigiendo a Google OAuth');
      debugPrint('📍 Deep link: $deepLinkUrl');
    } catch (e) {
      debugPrint('❌ Error al iniciar sesión con Google: $e');
      rethrow;
    }
  }
  
  /// Cierra sesión
  Future<void> signOut() async {
    final client = _client;
    if (client == null) {
      debugPrint('⚠️ Supabase no está inicializado, no hay sesión que cerrar');
      return;
    }
    
    try {
      await client.auth.signOut();
      debugPrint('✅ Sesión cerrada');
    } catch (e) {
      debugPrint('❌ Error al cerrar sesión: $e');
      // No relanzar, solo loggear
    }
  }
  
  /// Envía un email para restablecer la contraseña
  Future<void> resetPassword(String email) async {
    final client = _client;
    if (client == null) {
      throw Exception('Supabase no está inicializado. Verifica tu conexión.');
    }
    
    try {
      await client.auth.resetPasswordForEmail(
        email,
        redirectTo: kIsWeb
            ? 'io.supabase.fiestapp://reset-password'
            : 'io.supabase.fiestapp://reset-password',
      );
      debugPrint('✅ Email de restablecimiento enviado a $email');
    } catch (e) {
      debugPrint('❌ Error al enviar email de restablecimiento: $e');
      rethrow;
    }
  }
  
  /// Verifica si el usuario actual es administrador
  /// Esto requiere que haya una tabla 'admins' en Supabase
  Future<bool> isAdmin() async {
    if (!isAuthenticated) return false;
    
    final client = _client;
    if (client == null) return false;
    
    try {
      final userId = currentUserId;
      if (userId == null) return false;
      
      final response = await client
          .from('admins')
          .select('user_id')
          .eq('user_id', userId)
          .maybeSingle();
      
      return response != null;
    } catch (e) {
      debugPrint('❌ Error al verificar si es admin: $e');
      return false;
    }
  }
  
  /// Actualiza el perfil del usuario
  /// Nota: Esta funcionalidad está deshabilitada temporalmente
  /// Se puede implementar más adelante cuando sea necesario
  Future<void> updateProfile({
    String? displayName,
    String? avatarUrl,
  }) async {
    if (!isAuthenticated) {
      throw Exception('Usuario no autenticado');
    }
    
    // Funcionalidad deshabilitada temporalmente
    // TODO: Implementar actualización de perfil cuando sea necesario
    debugPrint('⚠️ Actualización de perfil no implementada aún');
    
    // Código comentado para referencia futura:
    // try {
    //   final updates = <String, dynamic>{};
    //   if (displayName != null) updates['display_name'] = displayName;
    //   if (avatarUrl != null) updates['avatar_url'] = avatarUrl;
    //   
    //   if (updates.isEmpty) return;
    //   
    //   await _client.auth.updateUser(
    //     UserAttributes(data: updates),
    //   );
    //   
    //   debugPrint('✅ Perfil actualizado');
    // } catch (e) {
    //   debugPrint('❌ Error al actualizar perfil: $e');
    // }
  }
}

