import 'package:shared_preferences/shared_preferences.dart';

class FavoritesLocalService {
  FavoritesLocalService._();

  static final FavoritesLocalService instance = FavoritesLocalService._();

  static const String _key = 'favorite_event_ids';

  /// Carga los IDs de favoritos desde SharedPreferences
  Future<Set<String>> _loadIds() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final list = prefs.getStringList(_key) ?? [];
      return list.toSet();
    } catch (e) {
      return <String>{};
    }
  }

  /// Guarda los IDs de favoritos en SharedPreferences
  Future<void> _saveIds(Set<String> ids) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setStringList(_key, ids.toList());
    } catch (e) {
      // Error al guardar, pero no lanzamos excepción
    }
  }

  /// Obtiene el conjunto actual de IDs de eventos favoritos
  Future<Set<String>> getFavoriteIds() async {
    return await _loadIds();
  }

  /// Verifica si un evento es favorito
  Future<bool> isFavorite(String eventId) async {
    final ids = await _loadIds();
    return ids.contains(eventId);
  }

  /// Alterna el estado de favorito de un evento
  Future<void> toggleFavorite(String eventId) async {
    final ids = await _loadIds();
    if (ids.contains(eventId)) {
      ids.remove(eventId);
    } else {
      ids.add(eventId);
    }
    await _saveIds(ids);
  }

  /// Elimina un evento de favoritos
  Future<void> removeFavorite(String eventId) async {
    final ids = await _loadIds();
    ids.remove(eventId);
    await _saveIds(ids);
  }
}

