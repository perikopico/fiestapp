import 'package:supabase_flutter/supabase_flutter.dart';

/// Traducción de un evento para un idioma
class EventTranslation {
  final String? id;
  final String eventId;
  final String languageCode;
  final String title;
  final String? description;

  EventTranslation({
    this.id,
    required this.eventId,
    required this.languageCode,
    required this.title,
    this.description,
  });

  factory EventTranslation.fromMap(Map<String, dynamic> m) {
    return EventTranslation(
      id: m['id'] as String?,
      eventId: m['event_id'] as String,
      languageCode: m['language_code'] as String,
      title: m['title'] as String? ?? '',
      description: m['description'] as String?,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      if (id != null) 'id': id,
      'event_id': eventId,
      'language_code': languageCode,
      'title': title,
      'description': description,
    };
  }
}

/// Servicio para gestionar traducciones de eventos (EN, DE, ZH)
class EventTranslationService {
  EventTranslationService._();
  static final instance = EventTranslationService._();

  final _client = Supabase.instance.client;
  static const _table = 'event_translations';
  static const supportedLanguages = ['en', 'de', 'zh'];

  /// Obtiene las traducciones existentes de un evento
  Future<Map<String, EventTranslation>> fetchForEvent(String eventId) async {
    try {
      final res = await _client
          .from(_table)
          .select()
          .eq('event_id', eventId);

      final map = <String, EventTranslation>{};
      for (final row in (res as List)) {
        final t = EventTranslation.fromMap(row as Map<String, dynamic>);
        map[t.languageCode] = t;
      }
      return map;
    } catch (e) {
      // Si la tabla no existe aún, retornar vacío
      return {};
    }
  }

  /// Guarda o actualiza traducciones. Solo guarda las que tienen título no vacío.
  Future<void> saveTranslations(
    String eventId,
    Map<String, ({String title, String description})> translations,
  ) async {
    for (final lang in supportedLanguages) {
      final t = translations[lang];
      if (t == null || t.title.trim().isEmpty) continue;

      final payload = {
        'event_id': eventId,
        'language_code': lang,
        'title': t.title.trim(),
        'description': t.description.trim().isEmpty ? null : t.description.trim(),
      };

      try {
        final existing = await _client
            .from(_table)
            .select('id')
            .eq('event_id', eventId)
            .eq('language_code', lang)
            .maybeSingle();

        if (existing != null) {
          await _client
              .from(_table)
              .update(payload)
              .eq('event_id', eventId)
              .eq('language_code', lang);
        } else {
          await _client.from(_table).insert(payload);
        }
      } catch (e) {
        rethrow;
      }
    }
  }
}
