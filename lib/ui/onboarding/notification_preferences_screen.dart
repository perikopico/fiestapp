// lib/ui/onboarding/notification_preferences_screen.dart
// Pantalla de configuración de preferencias de notificaciones

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../services/city_service.dart';
import '../../services/category_service.dart';
import '../../services/fcm_topic_service.dart';
import '../../services/onboarding_service.dart';
import '../../services/fcm_token_service.dart';
import '../dashboard/dashboard_screen.dart';
import '../common/app_bar_logo.dart';
import '../../models/category.dart';

class NotificationPreferencesScreen extends StatefulWidget {
  const NotificationPreferencesScreen({super.key});

  @override
  State<NotificationPreferencesScreen> createState() =>
      _NotificationPreferencesScreenState();
}

class _NotificationPreferencesScreenState
    extends State<NotificationPreferencesScreen> {
  final CityService _cityService = CityService.instance;
  final CategoryService _categoryService = CategoryService();
  final FCMTopicService _topicService = FCMTopicService.instance;
  
  List<City> _cities = [];
  List<Category> _categories = [];
  Set<String> _selectedCities = {};
  Set<String> _selectedCategories = {};
  bool _isLoading = true;
  bool _isSaving = false;
  bool _showCategories = false; // Toggle para mostrar/ocultar categorías
  Map<String, List<City>> _citiesByRegion = {}; // Ciudades agrupadas por región
  String _searchQuery = ''; // Búsqueda de ciudades
  List<String> _searchSuggestions = []; // Sugerencias de búsqueda
  final FocusNode _searchFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _loadData();
    _searchFocusNode.addListener(_onSearchFocusChange);
  }

  @override
  void dispose() {
    _searchFocusNode.removeListener(_onSearchFocusChange);
    _searchFocusNode.dispose();
    super.dispose();
  }

  void _onSearchFocusChange() {
    if (!_searchFocusNode.hasFocus && _searchQuery.isEmpty) {
      setState(() {
        _searchSuggestions = [];
      });
    }
  }

  void _updateSearchSuggestions(String query) {
    if (query.isEmpty) {
      setState(() {
        _searchSuggestions = [];
      });
      return;
    }

    final queryLower = query.toLowerCase();
    final suggestions = <String>[];
    
    // Buscar ciudades que coincidan (búsqueda fuzzy)
    for (final city in _cities) {
      final cityLower = city.name.toLowerCase();
      
      // Coincidencia exacta o que empiece con la búsqueda
      if (cityLower.startsWith(queryLower)) {
        suggestions.add(city.name);
      }
      // Coincidencia parcial (contiene)
      else if (cityLower.contains(queryLower)) {
        suggestions.add(city.name);
      }
      // Búsqueda fuzzy: calcular similitud para errores tipográficos comunes
      else if (_calculateSimilarity(cityLower, queryLower) > 0.6) {
        suggestions.add(city.name);
      }
    }
    
    // Limitar a 5 sugerencias y ordenar por relevancia
    suggestions.sort((a, b) {
      final aLower = a.toLowerCase();
      final bLower = b.toLowerCase();
      final aStarts = aLower.startsWith(queryLower) ? 1 : 0;
      final bStarts = bLower.startsWith(queryLower) ? 1 : 0;
      if (aStarts != bStarts) return bStarts.compareTo(aStarts);
      return aLower.compareTo(bLower);
    });
    
    setState(() {
      _searchSuggestions = suggestions.take(5).toList();
    });
  }

  /// Calcula similitud entre dos strings (Levenshtein simplificado)
  double _calculateSimilarity(String s1, String s2) {
    if (s1 == s2) return 1.0;
    if (s1.isEmpty || s2.isEmpty) return 0.0;
    
    // Distancia de Levenshtein simplificada
    final maxLen = s1.length > s2.length ? s1.length : s2.length;
    final distance = _levenshteinDistance(s1, s2);
    return 1.0 - (distance / maxLen);
  }

  /// Calcula la distancia de Levenshtein entre dos strings
  int _levenshteinDistance(String s1, String s2) {
    if (s1.isEmpty) return s2.length;
    if (s2.isEmpty) return s1.length;
    
    final matrix = List.generate(
      s1.length + 1,
      (i) => List.generate(s2.length + 1, (j) => 0),
    );
    
    for (int i = 0; i <= s1.length; i++) {
      matrix[i][0] = i;
    }
    for (int j = 0; j <= s2.length; j++) {
      matrix[0][j] = j;
    }
    
    for (int i = 1; i <= s1.length; i++) {
      for (int j = 1; j <= s2.length; j++) {
        final cost = s1[i - 1] == s2[j - 1] ? 0 : 1;
        matrix[i][j] = [
          matrix[i - 1][j] + 1,      // deletion
          matrix[i][j - 1] + 1,      // insertion
          matrix[i - 1][j - 1] + cost, // substitution
        ].reduce((a, b) => a < b ? a : b);
      }
    }
    
    return matrix[s1.length][s2.length];
  }

  Future<void> _loadData() async {
    try {
      // Obtener todas las ciudades (pasar null para obtener todas, no solo Cádiz)
      final cities = await _cityService.fetchCities(provinceId: null);
      final categories = await _categoryService.fetchAll();
      
      // Por defecto, seleccionar solo ciudades principales (primeras 10-15 más populares)
      // Esto es más manejable que seleccionar las 56 ciudades
      final mainCities = [
        'Barbate', 'Vejer de la Frontera', 'Conil de la Frontera', 
        'Cádiz', 'Jerez de la Frontera', 'El Puerto de Santa María',
        'Chiclana de la Frontera', 'San Fernando', 'Algeciras',
        'Tarifa', 'Rota', 'Sanlúcar de Barrameda'
      ];
      final defaultCities = cities
          .where((c) => mainCities.contains(c.name))
          .map((c) => c.name)
          .toSet();
      
      // Agrupar ciudades por región
      final citiesByRegion = <String, List<City>>{};
      for (final city in cities) {
        final region = city.region ?? 'Sin región';
        citiesByRegion.putIfAbsent(region, () => []).add(city);
      }
      
      setState(() {
        _cities = cities;
        _categories = categories;
        _selectedCities = defaultCities;
        _citiesByRegion = citiesByRegion;
        _isLoading = false;
      });
    } catch (e) {
      debugPrint('Error al cargar datos: $e');
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _savePreferences() async {
    if (_selectedCities.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Selecciona al menos una ciudad para recibir notificaciones'),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    setState(() {
      _isSaving = true;
    });

    try {
      // Solicitar permisos de notificaciones si no están concedidos
      await FCMTokenService.instance.requestPermissionIfNeeded();
      
      // Suscribirse a las ciudades seleccionadas
      await _topicService.updateCitySubscriptions(_selectedCities.toList());
      
      // Si hay categorías seleccionadas, suscribirse también
      if (_selectedCategories.isNotEmpty) {
        await _topicService.updateCategorySubscriptions(_selectedCategories.toList());
      }
      
      // Marcar que el usuario ha completado la configuración de notificaciones
      await OnboardingService.instance.markNotificationPreferencesSeen();
      
      if (!mounted) return;
      
      // Navegar al dashboard
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => const DashboardScreen()),
      );
    } catch (e) {
      debugPrint('Error al guardar preferencias: $e');
      if (!mounted) return;
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error al guardar preferencias: $e'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          _isSaving = false;
        });
      }
    }
  }

  void _toggleCity(String cityName) {
    setState(() {
      if (_selectedCities.contains(cityName)) {
        _selectedCities.remove(cityName);
      } else {
        _selectedCities.add(cityName);
      }
    });
  }

  void _toggleCategory(String categoryName) {
    setState(() {
      if (_selectedCategories.contains(categoryName)) {
        _selectedCategories.remove(categoryName);
      } else {
        _selectedCategories.add(categoryName);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) {
          SystemNavigator.pop();
        }
      },
      child: Scaffold(
        backgroundColor: theme.scaffoldBackgroundColor,
        body: SafeArea(
          child: _isLoading
              ? const Center(child: CircularProgressIndicator())
              : Column(
                  children: [
                    // Logo
                    Padding(
                      padding: const EdgeInsets.only(top: 8, bottom: 8),
                      child: const AppBarLogo(),
                    ),
                    
                    // Contenido scrollable
                    Expanded(
                      child: SingleChildScrollView(
                        padding: const EdgeInsets.symmetric(horizontal: 24),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: 16),
                            
                            // Título
                            Text(
                              'Configura tus notificaciones',
                              style: theme.textTheme.headlineSmall?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 8),
                            
                            // Explicación simple
                            Container(
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                color: theme.colorScheme.primaryContainer.withOpacity(0.3),
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  color: theme.colorScheme.primary.withOpacity(0.2),
                                ),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Icon(
                                        Icons.info_outline,
                                        color: theme.colorScheme.primary,
                                        size: 20,
                                      ),
                                      const SizedBox(width: 8),
                                      Text(
                                        '¿Cuándo recibirás notificaciones?',
                                        style: theme.textTheme.titleSmall?.copyWith(
                                          fontWeight: FontWeight.bold,
                                          color: theme.colorScheme.primary,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 12),
                                  _buildNotificationInfoItem(
                                    theme,
                                    Icons.favorite,
                                    'Recordatorios de favoritos',
                                    'Te avisamos 24 horas antes de tus eventos favoritos',
                                  ),
                                  const SizedBox(height: 8),
                                  _buildNotificationInfoItem(
                                    theme,
                                    Icons.location_city,
                                    'Nuevos eventos en tus ciudades',
                                    'Te notificamos cuando se publique un evento en las ciudades que selecciones',
                                  ),
                                  const SizedBox(height: 8),
                                  _buildNotificationInfoItem(
                                    theme,
                                    Icons.warning_amber,
                                    'Cambios importantes',
                                    'Te avisamos si cambia la fecha, hora o lugar de tus eventos favoritos',
                                  ),
                                ],
                              ),
                            ),
                            
                            const SizedBox(height: 32),
                            
                            // Sección de ciudades
                            Text(
                              'Ciudades',
                              style: theme.textTheme.titleLarge?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'Selecciona las ciudades de las que quieres recibir notificaciones',
                              style: theme.textTheme.bodyMedium?.copyWith(
                                color: theme.colorScheme.onSurfaceVariant,
                              ),
                            ),
                            const SizedBox(height: 12),
                            
                            // Contador de selección
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                              decoration: BoxDecoration(
                                color: theme.colorScheme.primaryContainer.withOpacity(0.2),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.location_city,
                                    size: 16,
                                    color: theme.colorScheme.primary,
                                  ),
                                  const SizedBox(width: 8),
                                  Text(
                                    '${_selectedCities.length} de ${_cities.length} ciudades seleccionadas',
                                    style: theme.textTheme.bodySmall?.copyWith(
                                      fontWeight: FontWeight.w600,
                                      color: theme.colorScheme.primary,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 12),
                            
                            // Búsqueda de ciudades con sugerencias
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                TextField(
                                  focusNode: _searchFocusNode,
                                  decoration: InputDecoration(
                                    hintText: 'Buscar ciudad...',
                                    prefixIcon: const Icon(Icons.search),
                                    suffixIcon: _searchQuery.isNotEmpty
                                        ? IconButton(
                                            icon: const Icon(Icons.clear),
                                            onPressed: () {
                                              setState(() {
                                                _searchQuery = '';
                                                _searchSuggestions = [];
                                              });
                                              _searchFocusNode.unfocus();
                                            },
                                          )
                                        : null,
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    filled: true,
                                    fillColor: theme.colorScheme.surface,
                                  ),
                                  onChanged: (value) {
                                    setState(() {
                                      _searchQuery = value.toLowerCase();
                                    });
                                    _updateSearchSuggestions(value);
                                  },
                                  onSubmitted: (value) {
                                    if (_searchSuggestions.isNotEmpty) {
                                      // Seleccionar la primera sugerencia
                                      setState(() {
                                        _searchQuery = _searchSuggestions.first.toLowerCase();
                                        _searchSuggestions = [];
                                      });
                                      _searchFocusNode.unfocus();
                                    }
                                  },
                                ),
                                
                                // Mostrar sugerencias
                                if (_searchSuggestions.isNotEmpty && _searchFocusNode.hasFocus)
                                  Container(
                                    margin: const EdgeInsets.only(top: 4),
                                    decoration: BoxDecoration(
                                      color: theme.colorScheme.surface,
                                      borderRadius: BorderRadius.circular(12),
                                      border: Border.all(
                                        color: theme.colorScheme.outline.withOpacity(0.2),
                                      ),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.black.withOpacity(0.1),
                                          blurRadius: 8,
                                          offset: const Offset(0, 4),
                                        ),
                                      ],
                                    ),
                                    constraints: const BoxConstraints(maxHeight: 200),
                                    child: ListView.builder(
                                      shrinkWrap: true,
                                      itemCount: _searchSuggestions.length,
                                      itemBuilder: (context, index) {
                                        final suggestion = _searchSuggestions[index];
                                        final isSelected = _selectedCities.contains(suggestion);
                                        
                                        return InkWell(
                                          onTap: () {
                                            setState(() {
                                              _searchQuery = suggestion.toLowerCase();
                                              _searchSuggestions = [];
                                            });
                                            _searchFocusNode.unfocus();
                                          },
                                          child: Padding(
                                            padding: const EdgeInsets.symmetric(
                                              horizontal: 16,
                                              vertical: 12,
                                            ),
                                            child: Row(
                                              children: [
                                                Icon(
                                                  Icons.location_city,
                                                  size: 18,
                                                  color: theme.colorScheme.primary,
                                                ),
                                                const SizedBox(width: 12),
                                                Expanded(
                                                  child: Text(
                                                    suggestion,
                                                    style: theme.textTheme.bodyMedium,
                                                  ),
                                                ),
                                                if (isSelected)
                                                  Icon(
                                                    Icons.check_circle,
                                                    size: 18,
                                                    color: theme.colorScheme.primary,
                                                  ),
                                              ],
                                            ),
                                          ),
                                        );
                                      },
                                    ),
                                  ),
                              ],
                            ),
                            const SizedBox(height: 12),
                            
                            // Botones de selección rápida
                            Row(
                              children: [
                                Expanded(
                                  child: OutlinedButton.icon(
                                    onPressed: () {
                                      setState(() {
                                        _selectedCities = _cities.map((c) => c.name).toSet();
                                      });
                                    },
                                    icon: const Icon(Icons.select_all, size: 18),
                                    label: const Text('Seleccionar todo'),
                                    style: OutlinedButton.styleFrom(
                                      padding: const EdgeInsets.symmetric(vertical: 8),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: OutlinedButton.icon(
                                    onPressed: () {
                                      setState(() {
                                        _selectedCities.clear();
                                      });
                                    },
                                    icon: const Icon(Icons.deselect, size: 18),
                                    label: const Text('Deseleccionar todo'),
                                    style: OutlinedButton.styleFrom(
                                      padding: const EdgeInsets.symmetric(vertical: 8),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 16),
                            
                            // Lista de ciudades agrupadas por región (filtradas por búsqueda)
                            ..._citiesByRegion.entries.map((entry) {
                              final region = entry.key;
                              var citiesInRegion = entry.value;
                              
                              // Filtrar por búsqueda si hay query
                              if (_searchQuery.isNotEmpty) {
                                citiesInRegion = citiesInRegion
                                    .where((city) => city.name.toLowerCase().contains(_searchQuery))
                                    .toList();
                                if (citiesInRegion.isEmpty) {
                                  return const SizedBox.shrink();
                                }
                              }
                              
                              final allSelectedInRegion = citiesInRegion.every(
                                (city) => _selectedCities.contains(city.name),
                              );
                              final someSelectedInRegion = citiesInRegion.any(
                                (city) => _selectedCities.contains(city.name),
                              );
                              
                              // Colapsar por defecto, excepto si tiene selecciones
                              final initiallyExpanded = someSelectedInRegion || _searchQuery.isNotEmpty;
                              
                              return _buildRegionSection(
                                theme,
                                region: region,
                                cities: citiesInRegion,
                                allSelected: allSelectedInRegion,
                                someSelected: someSelectedInRegion,
                                initiallyExpanded: initiallyExpanded,
                              );
                            }),
                            
                            const SizedBox(height: 32),
                            
                            // Toggle para mostrar categorías (opcional)
                            InkWell(
                              onTap: () {
                                setState(() {
                                  _showCategories = !_showCategories;
                                });
                              },
                              borderRadius: BorderRadius.circular(12),
                              child: Container(
                                padding: const EdgeInsets.all(16),
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    color: theme.colorScheme.outline.withOpacity(0.2),
                                  ),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Row(
                                  children: [
                                    Icon(
                                      _showCategories
                                          ? Icons.expand_less
                                          : Icons.expand_more,
                                      color: theme.colorScheme.primary,
                                    ),
                                    const SizedBox(width: 12),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            'Filtrar por categorías (opcional)',
                                            style: theme.textTheme.titleMedium?.copyWith(
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                          const SizedBox(height: 4),
                                          Text(
                                            'Recibe notificaciones solo de eventos de categorías específicas',
                                            style: theme.textTheme.bodySmall?.copyWith(
                                              color: theme.colorScheme.onSurfaceVariant,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            
                            // Lista de categorías (si está expandida)
                            if (_showCategories) ...[
                              const SizedBox(height: 16),
                              
                              // Botones de selección rápida para categorías
                              Row(
                                children: [
                                  Expanded(
                                    child: OutlinedButton.icon(
                                      onPressed: () {
                                        setState(() {
                                          _selectedCategories = _categories.map((c) => c.name).toSet();
                                        });
                                      },
                                      icon: const Icon(Icons.select_all, size: 18),
                                      label: const Text('Seleccionar todo'),
                                      style: OutlinedButton.styleFrom(
                                        padding: const EdgeInsets.symmetric(vertical: 8),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  Expanded(
                                    child: OutlinedButton.icon(
                                      onPressed: () {
                                        setState(() {
                                          _selectedCategories.clear();
                                        });
                                      },
                                      icon: const Icon(Icons.deselect, size: 18),
                                      label: const Text('Deseleccionar todo'),
                                      style: OutlinedButton.styleFrom(
                                        padding: const EdgeInsets.symmetric(vertical: 8),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 16),
                              
                              ..._categories.map((category) => _buildSelectionTile(
                                theme,
                                title: category.name,
                                isSelected: _selectedCategories.contains(category.name),
                                onTap: () => _toggleCategory(category.name),
                                leading: category.icon != null
                                    ? Text(
                                        category.icon!,
                                        style: const TextStyle(fontSize: 24),
                                      )
                                    : null,
                              )),
                              if (_selectedCategories.isEmpty)
                                Padding(
                                  padding: const EdgeInsets.only(top: 8, bottom: 16),
                                  child: Text(
                                    'Si no seleccionas ninguna categoría, recibirás notificaciones de todas',
                                    style: theme.textTheme.bodySmall?.copyWith(
                                      color: theme.colorScheme.onSurfaceVariant,
                                      fontStyle: FontStyle.italic,
                                    ),
                                  ),
                                ),
                            ],
                            
                            const SizedBox(height: 24),
                          ],
                        ),
                      ),
                    ),
                    
                    // Botones de acción
                    Padding(
                      padding: const EdgeInsets.fromLTRB(24, 16, 24, 24),
                      child: Column(
                        children: [
                          // Botón secundario: Configurar más tarde
                          OutlinedButton(
                            onPressed: _isSaving ? null : () async {
                              // Seleccionar solo ciudad principal (Barbate) y continuar
                              setState(() {
                                _selectedCities = {'Barbate'};
                              });
                              await _savePreferences();
                            },
                            style: OutlinedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(vertical: 12),
                              minimumSize: const Size(double.infinity, 48),
                            ),
                            child: const Text('Configurar más tarde'),
                          ),
                          const SizedBox(height: 12),
                          // Botón principal: Continuar
                          SizedBox(
                            width: double.infinity,
                            child: FilledButton(
                              onPressed: _isSaving ? null : _savePreferences,
                              style: FilledButton.styleFrom(
                                padding: const EdgeInsets.symmetric(vertical: 16),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(14),
                                ),
                              ),
                              child: _isSaving
                                  ? const SizedBox(
                                      height: 20,
                                      width: 20,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2,
                                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                                      ),
                                    )
                                  : Text(
                                      'Continuar',
                                      style: theme.textTheme.labelLarge,
                                    ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
        ),
      ),
    );
  }

  Widget _buildNotificationInfoItem(
    ThemeData theme,
    IconData icon,
    String title,
    String description,
  ) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(
          icon,
          size: 18,
          color: theme.colorScheme.primary,
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: theme.textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                description,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildRegionSection(
    ThemeData theme, {
    required String region,
    required List<City> cities,
    required bool allSelected,
    required bool someSelected,
    bool initiallyExpanded = false,
  }) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(
          color: theme.colorScheme.outline.withOpacity(0.2),
        ),
      ),
      child: ExpansionTile(
        initiallyExpanded: initiallyExpanded,
        tilePadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        childrenPadding: const EdgeInsets.only(bottom: 8),
        title: Row(
          children: [
            Expanded(
              child: Text(
                region,
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Text(
              '${cities.length} ciudades',
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 4),
          child: Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () {
                    setState(() {
                      if (allSelected) {
                        // Deseleccionar todas de la región
                        for (final city in cities) {
                          _selectedCities.remove(city.name);
                        }
                      } else {
                        // Seleccionar todas de la región
                        for (final city in cities) {
                          _selectedCities.add(city.name);
                        }
                      }
                    });
                  },
                  icon: Icon(
                    allSelected ? Icons.deselect : Icons.select_all,
                    size: 16,
                  ),
                  label: Text(
                    allSelected ? 'Deseleccionar región' : 'Seleccionar región',
                    style: const TextStyle(fontSize: 12),
                  ),
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    minimumSize: const Size(0, 32),
                  ),
                ),
              ),
            ],
          ),
        ),
        trailing: Icon(
          allSelected
              ? Icons.check_circle
              : someSelected
                  ? Icons.indeterminate_check_box
                  : Icons.circle_outlined,
          color: allSelected
              ? theme.colorScheme.primary
              : someSelected
                  ? theme.colorScheme.primary.withOpacity(0.6)
                  : theme.colorScheme.outline,
        ),
        children: [
          ...cities.map((city) => Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: _buildSelectionTile(
                  theme,
                  title: city.name,
                  isSelected: _selectedCities.contains(city.name),
                  onTap: () => _toggleCity(city.name),
                ),
              )),
        ],
      ),
    );
  }

  Widget _buildSelectionTile(
    ThemeData theme, {
    required String title,
    required bool isSelected,
    required VoidCallback onTap,
    Widget? leading,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        margin: const EdgeInsets.only(bottom: 8),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: isSelected
              ? theme.colorScheme.primaryContainer.withOpacity(0.3)
              : theme.colorScheme.surface,
          border: Border.all(
            color: isSelected
                ? theme.colorScheme.primary
                : theme.colorScheme.outline.withOpacity(0.2),
            width: isSelected ? 2 : 1,
          ),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            if (leading != null) ...[
              leading,
              const SizedBox(width: 12),
            ],
            Expanded(
              child: Text(
                title,
                style: theme.textTheme.bodyLarge?.copyWith(
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                ),
              ),
            ),
            Icon(
              isSelected ? Icons.check_circle : Icons.circle_outlined,
              color: isSelected
                  ? theme.colorScheme.primary
                  : theme.colorScheme.outline,
            ),
          ],
        ),
      ),
    );
  }
}
