// lib/services/data_export_service.dart
import 'dart:convert';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

/// Servicio para exportar datos del usuario (Derecho de Portabilidad - RGPD)
class DataExportService {
  static final DataExportService instance = DataExportService._();
  DataExportService._();

  /// Exporta todos los datos del usuario en formato JSON
  Future<void> exportUserData() async {
    final user = Supabase.instance.client.auth.currentUser;
    if (user == null) {
      throw Exception('No hay usuario autenticado');
    }

    try {
      // Obtener datos desde Supabase usando la función SQL
      final response = await Supabase.instance.client.rpc(
        'export_user_data',
        params: {'user_uuid': user.id},
      );

      // Convertir a JSON formateado (indentado para legibilidad)
      final jsonString = const JsonEncoder.withIndent('  ').convert(response);

      // Guardar en archivo temporal
      final directory = await getTemporaryDirectory();
      final timestamp = DateTime.now().millisecondsSinceEpoch;
      final fileName = 'queplan_export_$timestamp.json';
      final file = File('${directory.path}/$fileName');
      await file.writeAsString(jsonString);

      // Compartir archivo
      await Share.shareXFiles(
        [XFile(file.path)],
        text: 'Mis datos de QuePlan - Exportación RGPD',
        subject: 'Exportación de datos personales - QuePlan',
      );
    } catch (e) {
      throw Exception('Error al exportar datos: $e');
    }
  }

  /// Obtiene los datos del usuario sin exportar (útil para preview)
  Future<Map<String, dynamic>> getUserData() async {
    final user = Supabase.instance.client.auth.currentUser;
    if (user == null) {
      throw Exception('No hay usuario autenticado');
    }

    try {
      final response = await Supabase.instance.client.rpc(
        'export_user_data',
        params: {'user_uuid': user.id},
      );
      return response as Map<String, dynamic>;
    } catch (e) {
      throw Exception('Error al obtener datos: $e');
    }
  }
}

