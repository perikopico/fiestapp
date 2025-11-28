import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'auth_service.dart';

class FavoritesService {
  FavoritesService._();
  
  static final FavoritesService instance = FavoritesService._();
  
  static const String _favoritesKey = 'favorite_event_ids';
  
  final ValueNotifier<Set<String>> _favoritesNotifier = ValueNotifier<Set<String>>({});
  Set<String> _favorites = {};
  bool _initialized = false;
  final _authService = AuthService.instance;
  
  SupabaseClient? get _client {
    try {
      return Supabase.instance.client;
    } catch (e) {
      debugPrint('⚠️ Supabase no está inicializado en FavoritesService: $e');
      return null;
    }
  }
  
  /// Stream para escuchar cambios en los favoritos
  ValueNotifier<Set<String>> get favoritesNotifier => _favoritesNotifier;
  
  /// Obtiene el conjunto actual de IDs favoritos
  Set<String> get favorites => Set<String>.unmodifiable(_favorites);
  
  /// Inicializa el servicio cargando favoritos desde SharedPreferences o Supabase
  Future<void> init() async {
    if (_initialized) return;
    
    try {
      // Si el usuario está autenticado, cargar desde Supabase
      if (_authService.isAuthenticated) {
        await _loadFromSupabase();
      } else {
        // Si no está autenticado, cargar desde local
        await _loadFromLocal();
      }
      
      _initialized = true;
    } catch (e) {
      debugPrint('Error al inicializar FavoritesService: $e');
      // Fallback a local
      await _loadFromLocal();
      _initialized = true;
    }
  }
  
  /// Carga favoritos desde SharedPreferences
  Future<void> _loadFromLocal() async {
    final prefs = await SharedPreferences.getInstance();
    final favoritesList = prefs.getStringList(_favoritesKey) ?? [];
    _favorites = favoritesList.toSet();
    _favoritesNotifier.value = _favorites;
  }
  
  /// Carga favoritos desde Supabase
  Future<void> _loadFromSupabase() async {
    try {
      final client = _client;
      if (client == null) {
        debugPrint('⚠️ Supabase no disponible, cargando favoritos locales');
        await _loadFromLocal();
        return;
      }
      
      final userId = _authService.currentUserId;
      if (userId == null) {
        await _loadFromLocal();
        return;
      }
      
      final response = await client
          .from('user_favorites')
          .select('event_id')
          .eq('user_id', userId);
      
      _favorites = (response as List)
          .map((item) => item['event_id'] as String)
          .toSet();
      
      _favoritesNotifier.value = _favorites;
      
      // Sincronizar también en local como backup
      final prefs = await SharedPreferences.getInstance();
      await prefs.setStringList(_favoritesKey, _favorites.toList());
    } catch (e) {
      debugPrint('Error al cargar favoritos desde Supabase: $e');
      // Fallback a local
      await _loadFromLocal();
    }
  }
  
  /// Sincroniza favoritos locales a Supabase cuando el usuario inicia sesión
  Future<void> syncLocalToSupabase() async {
    if (!_authService.isAuthenticated) return;
    
    final client = _client;
    if (client == null) {
      debugPrint('⚠️ Supabase no disponible, no se pueden sincronizar favoritos');
      return;
    }
    
    try {
      final userId = _authService.currentUserId;
      if (userId == null) return;
      
      // Obtener favoritos actuales de Supabase
      final supabaseResponse = await client
          .from('user_favorites')
          .select('event_id')
          .eq('user_id', userId);
      
      final supabaseFavorites = (supabaseResponse as List)
          .map((item) => item['event_id'] as String)
          .toSet();
      
      // Obtener favoritos locales
      final prefs = await SharedPreferences.getInstance();
      final localFavorites = (prefs.getStringList(_favoritesKey) ?? []).toSet();
      
      // Añadir favoritos locales que no están en Supabase
      final toAdd = localFavorites.difference(supabaseFavorites);
      if (toAdd.isNotEmpty) {
        await client.from('user_favorites').insert(
          toAdd.map((eventId) => {
            'user_id': userId,
            'event_id': eventId,
          }).toList(),
        );
      }
      
      // Cargar todos los favoritos (local + supabase) y actualizar estado
      _favorites = localFavorites.union(supabaseFavorites);
      _favoritesNotifier.value = _favorites;
      
      // Actualizar local con la unión
      await prefs.setStringList(_favoritesKey, _favorites.toList());
    } catch (e) {
      debugPrint('Error al sincronizar favoritos: $e');
    }
  }
  
  /// Verifica si un evento es favorito
  bool isFavorite(String eventId) {
    return _favorites.contains(eventId);
  }
  
  /// Alterna el estado de favorito de un evento
  Future<void> toggleFavorite(String eventId) async {
    final wasFavorite = _favorites.contains(eventId);
    
    if (wasFavorite) {
      _favorites.remove(eventId);
    } else {
      _favorites.add(eventId);
    }
    
    _favoritesNotifier.value = Set<String>.from(_favorites);
    
    // Guardar en local siempre
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setStringList(_favoritesKey, _favorites.toList());
    } catch (e) {
      debugPrint('Error al guardar favoritos localmente: $e');
    }
    
    // Si está autenticado, sincronizar con Supabase
    if (_authService.isAuthenticated) {
      try {
        final client = _client;
        if (client == null) {
          debugPrint('⚠️ Supabase no disponible, solo guardando localmente');
          return;
        }
        
        final userId = _authService.currentUserId;
        if (userId == null) return;
        
        if (wasFavorite) {
          // Eliminar de Supabase
          await client
              .from('user_favorites')
              .delete()
              .eq('user_id', userId)
              .eq('event_id', eventId);
        } else {
          // Añadir a Supabase
          await client.from('user_favorites').insert({
            'user_id': userId,
            'event_id': eventId,
          });
        }
      } catch (e) {
        debugPrint('Error al sincronizar favorito con Supabase: $e');
      }
    }
  }
  
  /// Añade un evento a favoritos
  Future<void> addFavorite(String eventId) async {
    if (_favorites.contains(eventId)) return;
    
    await toggleFavorite(eventId);
  }
  
  /// Elimina un evento de favoritos
  Future<void> removeFavorite(String eventId) async {
    if (!_favorites.contains(eventId)) return;
    
    await toggleFavorite(eventId);
  }
}

