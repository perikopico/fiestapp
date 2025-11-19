import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FavoritesService {
  FavoritesService._();
  
  static final FavoritesService instance = FavoritesService._();
  
  static const String _favoritesKey = 'favorite_event_ids';
  
  final ValueNotifier<Set<String>> _favoritesNotifier = ValueNotifier<Set<String>>({});
  Set<String> _favorites = {};
  bool _initialized = false;
  
  /// Stream para escuchar cambios en los favoritos
  ValueNotifier<Set<String>> get favoritesNotifier => _favoritesNotifier;
  
  /// Obtiene el conjunto actual de IDs favoritos
  Set<String> get favorites => Set<String>.unmodifiable(_favorites);
  
  /// Inicializa el servicio cargando favoritos desde SharedPreferences
  Future<void> init() async {
    if (_initialized) return;
    
    try {
      final prefs = await SharedPreferences.getInstance();
      final favoritesList = prefs.getStringList(_favoritesKey) ?? [];
      _favorites = favoritesList.toSet();
      _favoritesNotifier.value = _favorites;
      _initialized = true;
    } catch (e) {
      debugPrint('Error al inicializar FavoritesService: $e');
      _favorites = {};
      _favoritesNotifier.value = _favorites;
      _initialized = true;
    }
  }
  
  /// Verifica si un evento es favorito
  bool isFavorite(String eventId) {
    return _favorites.contains(eventId);
  }
  
  /// Alterna el estado de favorito de un evento
  Future<void> toggleFavorite(String eventId) async {
    if (_favorites.contains(eventId)) {
      _favorites.remove(eventId);
    } else {
      _favorites.add(eventId);
    }
    
    _favoritesNotifier.value = Set<String>.from(_favorites);
    
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setStringList(_favoritesKey, _favorites.toList());
    } catch (e) {
      debugPrint('Error al guardar favoritos: $e');
    }
  }
  
  /// Añade un evento a favoritos
  Future<void> addFavorite(String eventId) async {
    if (_favorites.contains(eventId)) return;
    
    _favorites.add(eventId);
    _favoritesNotifier.value = Set<String>.from(_favorites);
    
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setStringList(_favoritesKey, _favorites.toList());
    } catch (e) {
      debugPrint('Error al guardar favoritos: $e');
    }
  }
  
  /// Elimina un evento de favoritos
  Future<void> removeFavorite(String eventId) async {
    if (!_favorites.contains(eventId)) return;
    
    _favorites.remove(eventId);
    _favoritesNotifier.value = Set<String>.from(_favorites);
    
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setStringList(_favoritesKey, _favorites.toList());
    } catch (e) {
      debugPrint('Error al guardar favoritos: $e');
    }
  }
}

