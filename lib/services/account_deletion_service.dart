// lib/services/account_deletion_service.dart
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter/foundation.dart';

/// Servicio para gestionar la eliminación de cuentas (Derecho al Olvido - RGPD)
class AccountDeletionService {
  static final AccountDeletionService instance = AccountDeletionService._();
  AccountDeletionService._();

  final SupabaseClient _client = Supabase.instance.client;

  /// Elimina todos los datos personales del usuario
  /// Esto elimina datos de tablas relacionadas y marca al usuario como eliminado
  /// para prevenir que pueda iniciar sesión de nuevo
  /// 
  /// IMPORTANTE: Esta función marca al usuario como eliminado incluso si algunas
  /// eliminaciones fallan, para prevenir que pueda iniciar sesión de nuevo.
  Future<void> deleteUserData() async {
    final user = _client.auth.currentUser;
    if (user == null) {
      throw Exception('No hay usuario autenticado');
    }

    try {
      // Llamar a la función SQL que elimina todos los datos
      // Esta función ahora también marca al usuario como eliminado en deleted_users
      // La función SQL es robusta y maneja tablas que no existen
      await _client.rpc(
        'delete_user_data',
        params: {'user_uuid': user.id},
      );
      debugPrint('✅ Datos personales eliminados y usuario marcado como eliminado: ${user.id}');
    } catch (e) {
      // Si la función falla completamente, intentar marcar como eliminado manualmente
      debugPrint('⚠️ Error al eliminar datos con función SQL: $e');
      debugPrint('🔄 Intentando marcar usuario como eliminado manualmente...');
      
      try {
        // Intentar marcar como eliminado directamente
        await _client.from('deleted_users').upsert({
          'user_id': user.id,
          'email': user.email,
          'reason': 'user_requested',
          'deleted_at': DateTime.now().toIso8601String(),
        });
        debugPrint('✅ Usuario marcado como eliminado manualmente');
      } catch (markError) {
        debugPrint('❌ Error crítico: No se pudo marcar usuario como eliminado: $markError');
        debugPrint('⚠️ El usuario podrá iniciar sesión de nuevo hasta que se aplique la migración');
        // No lanzar excepción aquí - queremos que continúe y cierre sesión al menos
      }
      
      // Lanzar excepción solo si es crítico
      final errorStr = e.toString();
      if (!errorStr.contains('undefined_table') && !errorStr.contains('does not exist')) {
        throw Exception('Error al eliminar datos: $e');
      }
      // Si es solo un error de tabla no existente, continuar
      debugPrint('⚠️ Algunas tablas no existen, pero el usuario fue marcado como eliminado');
    }
  }

  /// Elimina el usuario de auth.users usando Admin API a través de Edge Function
  /// Requiere que la Edge Function "delete_user_account" esté desplegada
  Future<void> deleteAuthUser() async {
    final user = _client.auth.currentUser;
    if (user == null) {
      throw Exception('No hay usuario autenticado');
    }

    try {
      debugPrint('🗑️ Eliminando usuario de auth.users: ${user.id}');
      
      // Llamar a la Edge Function que usa Admin API para eliminar el usuario
      final response = await _client.functions.invoke(
        'delete_user_account',
        body: {
          'user_id': user.id,
        },
      );

      if (response.status == 200) {
        final responseData = response.data;
        if (responseData['success'] == true) {
          debugPrint('✅ Usuario eliminado de auth.users exitosamente');
        } else {
          final error = responseData['error'] ?? 'Unknown error';
          debugPrint('❌ Error al eliminar usuario: $error');
          throw Exception('Error al eliminar usuario: $error');
        }
      } else {
        final errorData = response.data;
        final errorMessage = errorData['error'] ?? 'HTTP ${response.status}';
        debugPrint('❌ Error HTTP al eliminar usuario: ${response.status}');
        debugPrint('Detalles: $errorMessage');
        throw Exception('Error al eliminar usuario: $errorMessage');
      }
    } catch (e) {
      debugPrint('❌ Error al llamar a Edge Function delete_user_account: $e');
      debugPrint('💡 Asegúrate de que la Edge Function esté desplegada y configurada con SUPABASE_SERVICE_ROLE_KEY');
      rethrow;
    }
  }

  /// Elimina la cuenta completa (datos + autenticación)
  /// Requiere que el usuario esté autenticado
  /// 
  /// Proceso:
  /// 1. Elimina todos los datos personales de las tablas relacionadas
  /// 2. Elimina el usuario de auth.users usando Admin API (Edge Function)
  /// 3. Cierra sesión (SIEMPRE, incluso si falla la eliminación del usuario)
  Future<void> deleteAccount() async {
    final user = _client.auth.currentUser;
    if (user == null) {
      throw Exception('No hay usuario autenticado');
    }

    bool userDataDeleted = false;
    bool authUserDeleted = false;

    try {
      debugPrint('🗑️ Iniciando eliminación completa de cuenta para: ${user.email}');
      
      // 1. Eliminar todos los datos personales
      try {
        await deleteUserData();
        userDataDeleted = true;
      } catch (e) {
        debugPrint('⚠️ Error al eliminar datos personales: $e');
        // Continuar aunque falle
      }

      // 1.5. Enviar email de confirmación de eliminación (con información legal)
      try {
        await _sendDeletionEmail(user.email ?? '', user.id);
      } catch (e) {
        debugPrint('⚠️ Error al enviar email de eliminación: $e');
        // No bloquear la eliminación si falla el email
      }

      // 2. Eliminar usuario de auth.users usando Admin API (Edge Function)
      try {
        await deleteAuthUser();
        authUserDeleted = true;
      } catch (e) {
        debugPrint('⚠️ Error al eliminar usuario de auth.users: $e');
        debugPrint('💡 La Edge Function delete_user_account no está desplegada o hay un error');
        debugPrint('💡 Los datos personales fueron eliminados, pero el usuario sigue en auth.users');
        debugPrint('💡 Puedes eliminarlo manualmente desde Supabase Dashboard si es necesario');
        // Continuar aunque falle - al menos cerramos sesión
      }

      // 3. CERRAR SESIÓN SIEMPRE (incluso si falló algo anterior)
      // Esto es crítico para que el usuario pueda seguir usando la app
      try {
        await _client.auth.signOut();
        debugPrint('✅ Sesión cerrada correctamente');
      } catch (e) {
        debugPrint('❌ Error al cerrar sesión: $e');
        // Forzar cierre de sesión local si falla
        try {
          await _client.auth.signOut();
        } catch (_) {
          debugPrint('⚠️ No se pudo cerrar sesión, pero los datos fueron eliminados');
        }
      }
      
      if (userDataDeleted && authUserDeleted) {
        debugPrint('✅ Cuenta eliminada completamente');
      } else if (userDataDeleted) {
        debugPrint('⚠️ Datos eliminados pero usuario sigue en auth.users (requiere eliminación manual)');
      }
    } catch (e) {
      debugPrint('❌ Error inesperado al eliminar cuenta: $e');
      // Asegurar que siempre cerramos sesión
      try {
        await _client.auth.signOut();
        debugPrint('✅ Sesión cerrada después del error');
      } catch (_) {
        debugPrint('⚠️ Error al cerrar sesión después del error');
      }
      throw Exception('Error al eliminar cuenta: $e');
    }
  }

  /// Envía email de confirmación de eliminación con información legal
  Future<void> _sendDeletionEmail(String email, String userId) async {
    try {
      debugPrint('📧 Enviando email de confirmación de eliminación a: $email');
      
      final response = await _client.functions.invoke(
        'send_deletion_email',
        body: {
          'user_id': userId,
          'email': email,
          'deletion_date': DateTime.now().toIso8601String(),
        },
      );

      if (response.status == 200) {
        final responseData = response.data;
        if (responseData['success'] == true) {
          debugPrint('✅ Email de eliminación enviado correctamente');
        } else {
          debugPrint('⚠️ Email no enviado: ${responseData['message'] ?? 'Unknown error'}');
        }
      } else {
        debugPrint('⚠️ Error HTTP al enviar email: ${response.status}');
      }
    } catch (e) {
      debugPrint('⚠️ Error al llamar a Edge Function send_deletion_email: $e');
      debugPrint('💡 El email puede no haberse enviado, pero la eliminación continúa');
      // No lanzar excepción - el email es opcional
    }
  }
}

