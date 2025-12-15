// lib/services/account_deletion_service.dart
import 'package:supabase_flutter/supabase_flutter.dart';

/// Servicio para gestionar la eliminación de cuentas (Derecho al Olvido - RGPD)
class AccountDeletionService {
  static final AccountDeletionService instance = AccountDeletionService._();
  AccountDeletionService._();

  /// Elimina todos los datos personales del usuario
  /// NOTA: Esto NO elimina la cuenta de auth.users, solo los datos asociados
  /// Para eliminar la cuenta completamente, se requiere usar Admin API
  Future<void> deleteUserData() async {
    final user = Supabase.instance.client.auth.currentUser;
    if (user == null) {
      throw Exception('No hay usuario autenticado');
    }

    try {
      // Llamar a la función SQL que elimina todos los datos
      await Supabase.instance.client.rpc(
        'delete_user_data',
        params: {'user_uuid': user.id},
      );
    } catch (e) {
      throw Exception('Error al eliminar datos: $e');
    }
  }

  /// Elimina la cuenta completa (datos + autenticación)
  /// Requiere que el usuario esté autenticado
  Future<void> deleteAccount() async {
    final user = Supabase.instance.client.auth.currentUser;
    if (user == null) {
      throw Exception('No hay usuario autenticado');
    }

    try {
      // 1. Eliminar todos los datos personales
      await deleteUserData();

      // 2. Cerrar sesión (la cuenta de auth se puede eliminar manualmente
      // desde el dashboard o usando Admin API con service role key)
      await Supabase.instance.client.auth.signOut();
    } catch (e) {
      throw Exception('Error al eliminar cuenta: $e');
    }
  }
}

