// lib/services/report_service.dart
import 'package:supabase_flutter/supabase_flutter.dart';

/// Razones para reportar contenido
enum ReportReason {
  inappropriate,
  spam,
  falseInfo,
  copyright,
  other,
}

/// Servicio para reportar contenido inapropiado
class ReportService {
  static final ReportService instance = ReportService._();
  ReportService._();

  /// Reporta un contenido (evento o lugar)
  Future<void> reportContent({
    required String contentType, // 'event' o 'venue'
    required String contentId,
    required ReportReason reason,
    String? description,
  }) async {
    final user = Supabase.instance.client.auth.currentUser;
    if (user == null) {
      throw Exception('Debes estar autenticado para reportar contenido');
    }

    try {
      await Supabase.instance.client.from('content_reports').insert({
        'reported_by': user.id,
        'content_type': contentType,
        'content_id': contentId,
        'reason': reason.name,
        'description': description?.trim().isEmpty == true ? null : description?.trim(),
      });
    } catch (e) {
      throw Exception('Error al reportar contenido: $e');
    }
  }

  /// Obtiene los reportes realizados por el usuario actual
  Future<List<Map<String, dynamic>>> getMyReports() async {
    final user = Supabase.instance.client.auth.currentUser;
    if (user == null) {
      return [];
    }

    try {
      final response = await Supabase.instance.client
          .from('content_reports')
          .select()
          .eq('reported_by', user.id)
          .order('created_at', ascending: false);

      return (response as List).cast<Map<String, dynamic>>();
    } catch (e) {
      return [];
    }
  }

  /// Convierte el enum ReportReason a texto legible
  static String getReasonText(ReportReason reason) {
    switch (reason) {
      case ReportReason.inappropriate:
        return 'Contenido inapropiado';
      case ReportReason.spam:
        return 'Spam';
      case ReportReason.falseInfo:
        return 'Información falsa';
      case ReportReason.copyright:
        return 'Violación de derechos';
      case ReportReason.other:
        return 'Otro';
    }
  }
}

