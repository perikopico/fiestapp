import 'package:supabase_flutter/supabase_flutter.dart';

class AdminModerationService {
  AdminModerationService._();

  static final AdminModerationService instance = AdminModerationService._();

  SupabaseClient get _client => Supabase.instance.client;

  Future<void> approveEvent(String eventId) async {
    await _client
        .from('events')
        .update({'status': 'published'})
        .eq('id', eventId);
    // Si algo sale mal, Supabase lanzará una excepción automáticamente
  }

  Future<void> rejectEvent(String eventId) async {
    await _client
        .from('events')
        .update({'status': 'rejected'})
        .eq('id', eventId);
    // Si algo sale mal, Supabase lanzará una excepción automáticamente
  }
}
