// lib/ui/common/venue_search_field.dart
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show debugPrint;
import '../../models/venue.dart';
import '../../config/venue_config.dart';
import '../../services/venue_service.dart';
import '../../services/venue_exceptions.dart';
import '../../services/google_places_service.dart';

class VenueSearchField extends StatefulWidget {
  const VenueSearchField({
    super.key,
    this.initialVenue,
    required this.onVenueSelected,
    required this.cityId,
    required this.cityName,
    this.labelText = 'Lugar',
    this.errorText,
  });

  final Venue? initialVenue;
  final ValueChanged<Venue?> onVenueSelected;
  final int? cityId;
  final String cityName;
  final String labelText;
  final String? errorText;

  @override
  State<VenueSearchField> createState() => _VenueSearchFieldState();
}

class _VenueSearchFieldState extends State<VenueSearchField> {
  final TextEditingController _controller = TextEditingController();
  final VenueService _venueService = VenueService.instance;
  final GooglePlacesService _placesService = GooglePlacesService.instance;

  String _query = '';
  Timer? _debouncer;
  bool _isSearching = false;
  List<Venue> _suggestions = [];
  List<GooglePlace> _googlePlacesSuggestions = [];
  Venue? _selectedVenue;
  bool _isNewVenue = false;

  @override
  void initState() {
    super.initState();
    if (widget.initialVenue != null) {
      _selectedVenue = widget.initialVenue;
      _controller.text = widget.initialVenue!.name;
    }
  }

  @override
  void dispose() {
    _debouncer?.cancel();
    _controller.dispose();
    super.dispose();
  }

  void _onChanged(String value) {
    setState(() {
      _query = value;
      _isNewVenue = false;
      _selectedVenue = null;
      _googlePlacesSuggestions = [];
    });

    _debouncer?.cancel();
    
    if (value.trim().isEmpty) {
      setState(() {
        _suggestions = [];
        _googlePlacesSuggestions = [];
        _isSearching = false;
      });
      widget.onVenueSelected(null);
      return;
    }

    // Si no hay cityId, no podemos buscar
    if (widget.cityId == null) {
      setState(() {
        _suggestions = [];
        _googlePlacesSuggestions = [];
        _isSearching = false;
      });
      return;
    }

    // Debounce inteligente: más tiempo para búsquedas cortas
    final debounceDuration = value.trim().length <= 2
        ? VenueConfig.debounceShort
        : VenueConfig.debounceNormal;
    
    _debouncer = Timer(debounceDuration, () async {
      setState(() => _isSearching = true);
      try {
        debugPrint('🔍 Buscando lugares: "${value.trim()}" en ${widget.cityName}');
        
        // Buscar primero en la base de datos (más rápido)
        final venues = await _venueService.searchVenues(
          query: value.trim(),
          cityId: widget.cityId,
          limit: 5,
        );
        
        // Optimización: Si ya encontramos resultados en BD, solo buscar en Google Places
        // si realmente lo necesitamos (para evitar búsquedas innecesarias)
        Future<List<GooglePlace>> googlePlacesFuture = Future.value([]);
        final trimmedValue = value.trim();
        
        // Buscar en Google Places si hay al menos 3 caracteres
        // Solo buscamos si no hay suficientes resultados en BD o para dar más opciones
        if (trimmedValue.length >= VenueConfig.minSearchLength) {
          final exactQuery = trimmedValue;
          final selectedCity = widget.cityName;
          debugPrint('🌐 Buscando en Google Places: "$exactQuery" en "$selectedCity"');
          googlePlacesFuture = _placesService.searchPlaces(
            query: exactQuery,
            cityName: selectedCity,
            limit: VenueConfig.maxSearchResults,
          );
        }
        
        // Esperar la búsqueda de Google Places (si se inició)
        final allGooglePlaces = await googlePlacesFuture;
        
        // Filtrar lugares de Google Maps que ya existen en la BD (para evitar duplicados)
        // Normalizar nombres y comparar para detectar lugares similares/iguales
        final filteredGooglePlaces = allGooglePlaces.where((googlePlace) {
          final googleNameNormalized = _normalizeVenueName(googlePlace.name);
          
          // Si hay algún lugar en la BD con nombre muy similar, filtrarlo
          for (final venue in venues) {
            final venueNameNormalized = _normalizeVenueName(venue.name);
            
            // Si los nombres normalizados son idénticos o muy similares, filtrar
            if (googleNameNormalized == venueNameNormalized ||
                _areNamesSimilar(googleNameNormalized, venueNameNormalized)) {
              debugPrint('🔍 Filtrando lugar de Google Maps "${googlePlace.name}" (ya existe en BD como "${venue.name}")');
              return false;
            }
          }
          
          return true;
        }).toList();
        
        debugPrint('📊 Resultados en BD: ${venues.length}');
        debugPrint('📊 Resultados en Google Places: ${allGooglePlaces.length} (${filteredGooglePlaces.length} después de filtrar duplicados)');

        if (!mounted) return;
        setState(() {
          _suggestions = venues;
          _googlePlacesSuggestions = filteredGooglePlaces;
          _isSearching = false;
          // Si no hay sugerencias de ningún tipo y hay texto, es un lugar nuevo
          _isNewVenue = venues.isEmpty && filteredGooglePlaces.isEmpty && value.trim().isNotEmpty;
        });
        
        debugPrint('✅ Búsqueda completada. Sugerencias: ${venues.length + filteredGooglePlaces.length}');
        debugPrint('   Lugares BD: ${venues.length}, Google Places: ${filteredGooglePlaces.length}');
        debugPrint('   ¿Es lugar nuevo?: $_isNewVenue (query: "${value.trim()}")');
        debugPrint('   ¿Mostrar opción crear nuevo?: $_isNewVenue');
      } catch (e) {
        debugPrint('❌ Error en búsqueda: $e');
        if (!mounted) return;
        setState(() {
          _suggestions = [];
          _googlePlacesSuggestions = [];
          _isSearching = false;
          // Si hay texto y no hay sugerencias, permitir crear lugar nuevo
          _isNewVenue = value.trim().isNotEmpty && widget.cityId != null;
        });
        debugPrint('   ¿Mostrar opción crear nuevo (después de error)?: $_isNewVenue');
      }
    });
  }

  /// Normaliza un nombre de lugar para comparación (similar a la función SQL)
  String _normalizeVenueName(String name) {
    // Eliminar palabras comunes
    final commonWords = ['restaurante', 'restaurantes', 'bar', 'bars', 'pub', 'pubs', 
                         'café', 'cafe', 'cafetería', 'cafeteria', 'taberna', 'mesón', 
                         'el', 'la', 'los', 'las', 'de', 'del', 'y', 'e'];
    
    var normalized = name.toLowerCase().trim();
    
    // Eliminar acentos
    normalized = normalized
        .replaceAll('á', 'a')
        .replaceAll('é', 'e')
        .replaceAll('í', 'i')
        .replaceAll('ó', 'o')
        .replaceAll('ú', 'u')
        .replaceAll('ñ', 'n');
    
    // Eliminar signos de puntuación
    normalized = normalized.replaceAll(RegExp(r'[.,;:!?\-()\[\]{}"]'), ' ');
    
    // Normalizar espacios
    normalized = normalized.replaceAll(RegExp(r'\s+'), ' ').trim();
    
    // Eliminar palabras comunes
    for (final word in commonWords) {
      // Al inicio
      normalized = normalized.replaceAll(RegExp('^$word\\s+', caseSensitive: false), '');
      // En el medio
      normalized = normalized.replaceAll(RegExp('\\s+$word\\s+', caseSensitive: false), ' ');
      // Al final
      normalized = normalized.replaceAll(RegExp('\\s+$word\$', caseSensitive: false), '');
    }
    
    // Normalizar espacios de nuevo
    normalized = normalized.replaceAll(RegExp(r'\s+'), ' ').trim();
    
    return normalized;
  }
  
  /// Verifica si dos nombres normalizados son similares (detecta variaciones como "essencia" vs "esencia")
  bool _areNamesSimilar(String name1, String name2) {
    if (name1.isEmpty || name2.isEmpty) return false;
    
    // Si son iguales, son similares
    if (name1 == name2) return true;
    
    // Si uno contiene al otro (o viceversa), son similares
    if (name1.contains(name2) || name2.contains(name1)) {
      // Pero deben tener al menos 4 caracteres para evitar coincidencias muy cortas
      if (name1.length >= 4 && name2.length >= 4) {
        return true;
      }
    }
    
    // Calcular similitud simple (Levenshtein básico para strings cortos)
    // Si la diferencia es muy pequeña (1-2 caracteres), son similares
    if ((name1.length - name2.length).abs() <= 2) {
      final longer = name1.length > name2.length ? name1 : name2;
      final shorter = name1.length > name2.length ? name2 : name1;
      
      // Contar caracteres en común
      int matches = 0;
      for (int i = 0; i < shorter.length; i++) {
        if (i < longer.length && longer[i] == shorter[i]) {
          matches++;
        }
      }
      
      // Si más del 80% de los caracteres coinciden, son similares
      final similarity = matches / longer.length;
      if (similarity > 0.8) {
        return true;
      }
    }
    
    return false;
  }

  void _selectVenue(Venue venue) {
    _controller.text = venue.name;
    setState(() {
      _selectedVenue = venue;
      _suggestions = [];
      _googlePlacesSuggestions = [];
      _query = venue.name;
      _isNewVenue = false;
    });
    
    // Notificar al callback que se seleccionó un venue (esto actualizará las coordenadas en el formulario)
    widget.onVenueSelected(venue);
    
    // Mostrar feedback visual si el venue tiene coordenadas
    if (venue.lat != null && venue.lng != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              Icon(
                Icons.location_on,
                color: Colors.white,
                size: 20,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  'Lugar "${venue.name}" seleccionado. Ubicación marcada en el mapa.',
                  style: const TextStyle(fontSize: 13),
                ),
              ),
            ],
          ),
          backgroundColor: Theme.of(context).colorScheme.primary,
          duration: const Duration(seconds: 2),
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  Future<void> _createNewVenue() async {
    if (widget.cityId == null) return;
    
    var venueName = _controller.text.trim(); // Puede cambiar si se encuentra en Google Maps
    if (venueName.isEmpty) return;

    try {
      // PRIMERO: Verificar si hay lugares similares
      debugPrint('🔍 Verificando lugares similares para: $venueName');
      final similarVenues = await _venueService.findSimilarVenues(
        name: venueName,
        cityId: widget.cityId!,
      );
      
      if (similarVenues.isNotEmpty && mounted) {
        // Mostrar diálogo con lugares similares
        final shouldContinue = await showDialog<bool>(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Lugares similares encontrados'),
            content: SizedBox(
              width: double.maxFinite,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Se encontraron lugares similares en esta ciudad. ¿Quieres usar uno de estos o crear uno nuevo?',
                    style: TextStyle(fontSize: 14),
                  ),
                  const SizedBox(height: 16),
                  Flexible(
                    child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: similarVenues.length,
                      itemBuilder: (context, index) {
                        final venue = similarVenues[index];
                        return Card(
                          margin: const EdgeInsets.only(bottom: 8),
                          child: ListTile(
                            leading: Icon(
                              venue.isApproved ? Icons.check_circle : Icons.pending,
                              color: venue.isApproved 
                                  ? Colors.green 
                                  : Colors.orange,
                            ),
                            title: Text(venue.name),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                if (venue.address != null && venue.address!.isNotEmpty)
                                  Text(venue.address!, style: const TextStyle(fontSize: 12)),
                                const SizedBox(height: 4),
                                Chip(
                                  label: Text(
                                    venue.isApproved 
                                        ? 'Aprobado' 
                                        : venue.isPending 
                                            ? 'Pendiente' 
                                            : 'Rechazado',
                                    style: const TextStyle(fontSize: 11),
                                  ),
                                  padding: EdgeInsets.zero,
                                  visualDensity: VisualDensity.compact,
                                ),
                              ],
                            ),
                            onTap: () {
                              Navigator.of(context).pop(true);
                              _selectVenue(venue);
                            },
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: const Text('Cancelar'),
              ),
              TextButton(
                onPressed: () => Navigator.of(context).pop(true),
                child: const Text('Crear nuevo lugar'),
              ),
            ],
          ),
        );
        
        if (shouldContinue == null || !shouldContinue) {
          return; // El usuario canceló o seleccionó un lugar similar
        }
      }

      // Mostrar indicador de carga
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Row(
            children: [
              SizedBox(
                width: 16,
                height: 16,
                child: CircularProgressIndicator(strokeWidth: 2),
              ),
              SizedBox(width: 12),
              Text('Buscando ubicación y creando lugar...'),
            ],
          ),
          duration: Duration(seconds: 5),
        ),
      );

      // PASO 1: Intentar buscar el lugar en Google Places para obtener coordenadas
      double? lat;
      double? lng;
      String? address;
      bool foundInGoogleMaps = false;
      
      try {
        // Buscar en Google Maps - el servicio probará múltiples variaciones automáticamente
        final exactQuery = venueName.trim(); // Lo que el usuario escribió
        final selectedCity = widget.cityName; // La ciudad seleccionada
        debugPrint('🔍 Buscando en Google Maps: "$exactQuery" en "$selectedCity"');
        debugPrint('   El servicio probará múltiples variaciones automáticamente...');
        
        final googlePlaces = await _placesService.searchPlaces(
          query: exactQuery, // El servicio añadirá términos comunes automáticamente
          cityName: selectedCity,
          limit: 5, // Buscar más resultados para tener mejor opción
        );
        
        if (googlePlaces.isNotEmpty) {
          // Usar el primer resultado encontrado (el más relevante)
          final place = googlePlaces.first;
          lat = place.lat;
          lng = place.lng;
          address = place.address;
          foundInGoogleMaps = true;
          
          // IMPORTANTE: Usar el nombre exacto que devuelve Google Maps
          // en lugar del que escribió el usuario
          final googleMapsName = place.name;
          debugPrint('✅ Lugar encontrado en Google Maps: $lat, $lng');
          debugPrint('   Nombre en Google Maps: "$googleMapsName"');
          debugPrint('   Nombre que escribió el usuario: "$venueName"');
          debugPrint('   Dirección: $address');
          
          // Actualizar el nombre del venue con el nombre exacto de Google Maps
          // para que sea más preciso
          if (googleMapsName.isNotEmpty && googleMapsName != venueName) {
            debugPrint('   📝 Usando nombre de Google Maps: "$googleMapsName"');
            // Actualizar el controlador con el nombre de Google Maps
            _controller.text = googleMapsName;
            // Usar el nombre de Google Maps para crear el venue
            venueName = googleMapsName;
          }
        } else {
          debugPrint('⚠️ Lugar NO encontrado en Google Maps después de probar todas las variaciones');
        }
      } catch (e) {
        debugPrint('⚠️ Error al buscar en Google Maps: $e');
      }

      // Si NO se encontró en Google Maps, crear sin coordenadas
      // El admin podrá añadir las coordenadas más tarde
      if (!foundInGoogleMaps && mounted) {
        ScaffoldMessenger.of(context).hideCurrentSnackBar();
        debugPrint('⚠️ Lugar no encontrado en Google Maps. Se creará sin coordenadas.');
      }

      // PASO 3: Crear el venue (con o sin coordenadas) - SIEMPRE con status='pending'
      final newVenue = await _venueService.createVenue(
        name: venueName,
        cityId: widget.cityId!,
        address: address,
        lat: lat,
        lng: lng,
      );

      if (!mounted) return;

      setState(() {
        _selectedVenue = newVenue;
        _suggestions = [];
        _googlePlacesSuggestions = [];
        _isNewVenue = false;
      });
      
      // Notificar al callback que se seleccionó un venue (esto actualizará las coordenadas en el formulario)
      widget.onVenueSelected(newVenue);
      
      ScaffoldMessenger.of(context).hideCurrentSnackBar();
      
      // Mostrar mensaje de éxito con más información
      final hasCoordinates = lat != null && lng != null;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              Icon(
                Icons.check_circle,
                color: Colors.white,
                size: 20,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text(
                      'Lugar creado exitosamente',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    if (hasCoordinates)
                      const Text(
                        'Ubicación encontrada en Google Maps y marcada automáticamente',
                        style: TextStyle(fontSize: 12),
                      )
                    else
                      const Text(
                        'No encontrado en Google Maps. El admin añadirá las coordenadas.',
                        style: TextStyle(fontSize: 12),
                      ),
                    const SizedBox(height: 4),
                    Text(
                      'Estado: Pendiente de aprobación',
                      style: TextStyle(
                        fontSize: 11,
                        fontStyle: FontStyle.italic,
                        color: Colors.white.withOpacity(0.9),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          backgroundColor: Theme.of(context).colorScheme.primary,
          duration: const Duration(seconds: 4),
          behavior: SnackBarBehavior.floating,
        ),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).hideCurrentSnackBar();
      
      String errorMessage = 'Error al crear lugar';
      if (e is VenueException) {
        errorMessage = e.message;
      } else {
        errorMessage = 'Error al crear lugar: ${e.toString()}';
      }
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              Icon(Icons.error_outline, color: Colors.white, size: 20),
              const SizedBox(width: 12),
              Expanded(child: Text(errorMessage)),
            ],
          ),
          backgroundColor: Theme.of(context).colorScheme.error,
          duration: const Duration(seconds: 4),
        ),
      );
    }
  }

  /// Muestra diálogo de confirmación antes de crear lugar desde Google Maps
  Future<bool?> _confirmCreateFromGooglePlace(GooglePlace place) async {
    if (!mounted) return false;
    
    return await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            Icon(Icons.map, color: Theme.of(context).colorScheme.primary),
            const SizedBox(width: 8),
            const Expanded(child: Text('Crear lugar desde Google Maps')),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildDetailRow(Icons.business, 'Nombre', place.name),
            if (place.address != null && place.address!.isNotEmpty) ...[
              const SizedBox(height: 8),
              _buildDetailRow(Icons.location_on, 'Dirección', place.address!),
            ],
            if (place.lat != null && place.lng != null) ...[
              const SizedBox(height: 8),
              _buildDetailRow(
                Icons.gps_fixed,
                'Ubicación',
                '${place.lat!.toStringAsFixed(6)}, ${place.lng!.toStringAsFixed(6)}',
              ),
            ],
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primaryContainer.withOpacity(0.3),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.info_outline,
                    size: 16,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'El lugar se creará como "Pendiente" y será revisado por un administrador.',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancelar'),
          ),
          ElevatedButton.icon(
            onPressed: () => Navigator.of(context).pop(true),
            icon: const Icon(Icons.add_location),
            label: const Text('Crear lugar'),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailRow(IconData icon, String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 18, color: Theme.of(context).colorScheme.onSurfaceVariant),
        const SizedBox(width: 8),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: Theme.of(context).textTheme.labelSmall?.copyWith(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                value,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  /// Crea un venue desde un lugar de Google Places
  Future<void> _createVenueFromGooglePlace(GooglePlace place) async {
    if (widget.cityId == null) return;

    // Confirmar antes de crear
    final confirmed = await _confirmCreateFromGooglePlace(place);
    if (confirmed != true) return;

    try {
      // Mostrar indicador de carga
      if (!mounted) return;
      final loadingSnackBar = ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Row(
            children: [
              SizedBox(
                width: 16,
                height: 16,
                child: CircularProgressIndicator(strokeWidth: 2),
              ),
              SizedBox(width: 12),
              Expanded(
                child: Text('Buscando en Google Maps y creando lugar...'),
              ),
            ],
          ),
          duration: const Duration(seconds: 5),
        ),
      );

      // Crear el venue con las coordenadas de Google Places
      final newVenue = await _venueService.createVenue(
        name: place.name,
        cityId: widget.cityId!,
        address: place.address,
        lat: place.lat,
        lng: place.lng,
      );

      if (!mounted) return;

      setState(() {
        _selectedVenue = newVenue;
        _suggestions = [];
        _googlePlacesSuggestions = [];
        _isNewVenue = false;
        _controller.text = newVenue.name;
      });
      
      // Notificar al callback que se seleccionó un venue (esto actualizará las coordenadas en el formulario)
      widget.onVenueSelected(newVenue);
      
      ScaffoldMessenger.of(context).hideCurrentSnackBar();
      
      // Mostrar mensaje de éxito con más información
      final hasCoordinates = place.lat != null && place.lng != null;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              Icon(
                Icons.check_circle,
                color: Colors.white,
                size: 20,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text(
                      'Lugar creado desde Google Maps',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    if (hasCoordinates)
                      const Text(
                        'Ubicación marcada automáticamente en el mapa',
                        style: TextStyle(fontSize: 12),
                      )
                    else
                      const Text(
                        'Puedes marcar la ubicación en el mapa',
                        style: TextStyle(fontSize: 12),
                      ),
                    const SizedBox(height: 4),
                    Text(
                      'Estado: Pendiente de aprobación',
                      style: TextStyle(
                        fontSize: 11,
                        fontStyle: FontStyle.italic,
                        color: Colors.white.withOpacity(0.9),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          backgroundColor: Theme.of(context).colorScheme.primary,
          duration: const Duration(seconds: 4),
          behavior: SnackBarBehavior.floating,
        ),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).hideCurrentSnackBar();
      
      String errorMessage = 'Error al crear lugar';
      if (e is VenueException) {
        errorMessage = e.message;
      } else {
        errorMessage = 'Error al crear lugar: ${e.toString()}';
      }
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              Icon(
                Icons.error_outline,
                color: Colors.white,
                size: 20,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(errorMessage),
              ),
            ],
          ),
          backgroundColor: Theme.of(context).colorScheme.error,
          duration: const Duration(seconds: 4),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final hasSuggestions = _suggestions.isNotEmpty || _googlePlacesSuggestions.isNotEmpty;
    final showNewVenueOption = _isNewVenue && _query.trim().isNotEmpty && widget.cityId != null;
    final totalItems = _suggestions.length + _googlePlacesSuggestions.length + (showNewVenueOption ? 1 : 0);
    
    // Debug logs
    if (_query.trim().isNotEmpty) {
      debugPrint('🔍 UI State - Query: "${_query.trim()}"');
      debugPrint('   Sugerencias BD: ${_suggestions.length}');
      debugPrint('   Sugerencias Google: ${_googlePlacesSuggestions.length}');
      debugPrint('   _isNewVenue: $_isNewVenue');
      debugPrint('   showNewVenueOption: $showNewVenueOption');
      debugPrint('   hasSuggestions: $hasSuggestions');
      debugPrint('   totalItems: $totalItems');
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextField(
          controller: _controller,
          decoration: InputDecoration(
            labelText: widget.labelText,
            hintText: 'Escribe el nombre del lugar',
            prefixIcon: const Icon(Icons.place),
            suffixIcon: _isSearching
                ? const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: SizedBox(
                      width: 18,
                      height: 18,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    ),
                  )
                : (_query.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () {
                          setState(() {
                            _controller.clear();
                            _query = '';
                            _suggestions = [];
                            _googlePlacesSuggestions = [];
                            _selectedVenue = null;
                            _isNewVenue = false;
                          });
                          widget.onVenueSelected(null);
                        },
                      )
                    : null),
            errorText: widget.errorText,
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
          ),
          onChanged: _onChanged,
        ),
        if (hasSuggestions || showNewVenueOption)
          Container(
            margin: const EdgeInsets.only(top: 8),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surface,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: Theme.of(context).colorScheme.outline.withOpacity(0.2),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            constraints: const BoxConstraints(maxHeight: 300),
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: totalItems,
              itemBuilder: (context, index) {
                // Primero mostrar lugares de la BD
                if (index < _suggestions.length) {
                  final venue = _suggestions[index];
                  return ListTile(
                    dense: true,
                    leading: const Icon(Icons.place, size: 20),
                    title: Text(venue.name),
                    subtitle: venue.address != null && venue.address!.isNotEmpty
                        ? Text(
                            venue.address!,
                            style: const TextStyle(fontSize: 11),
                          )
                        : null,
                    onTap: () => _selectVenue(venue),
                  );
                }
                
                // Luego mostrar lugares de Google Places
                final googleIndex = index - _suggestions.length;
                if (googleIndex < _googlePlacesSuggestions.length) {
                  final place = _googlePlacesSuggestions[googleIndex];
                  return ListTile(
                    dense: true,
                    leading: const Icon(Icons.map, size: 20, color: Colors.blue),
                    title: Text(place.name),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (place.address != null && place.address!.isNotEmpty)
                          Text(
                            place.address!,
                            style: const TextStyle(fontSize: 11),
                          ),
                        const Text(
                          'Crear desde Google Maps',
                          style: TextStyle(fontSize: 10, fontStyle: FontStyle.italic),
                        ),
                      ],
                    ),
                    onTap: () => _createVenueFromGooglePlace(place),
                  );
                }
                
                // Opción de crear nuevo lugar al final (cuando no se encuentra en BD ni Google Maps)
                if (showNewVenueOption) {
                  return Card(
                    margin: const EdgeInsets.all(8),
                    color: Theme.of(context).colorScheme.surfaceContainerHighest,
                    child: ExpansionTile(
                      leading: Icon(
                        Icons.help_outline,
                        size: 20,
                        color: Colors.orange,
                      ),
                      title: Text(
                        'Lugar desconocido: "${_query.trim()}"',
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          color: Colors.orange,
                        ),
                      ),
                      subtitle: const Text(
                        'No encontrado en nuestros locales ni en Google Maps',
                        style: TextStyle(fontSize: 12),
                      ),
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '¿Qué pasará?',
                                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              const SizedBox(height: 12),
                              _buildInfoRow(
                                Icons.schedule,
                                'Se creará el lugar con estado "Pendiente"',
                              ),
                              const SizedBox(height: 8),
                              _buildInfoRow(
                                Icons.admin_panel_settings,
                                'Un administrador lo revisará y aprobará',
                              ),
                              const SizedBox(height: 8),
                              _buildInfoRow(
                                Icons.notifications,
                                'Recibirás una notificación cuando sea aprobado',
                              ),
                              const SizedBox(height: 16),
                              SizedBox(
                                width: double.infinity,
                                child: ElevatedButton.icon(
                                  onPressed: _createNewVenue,
                                  icon: const Icon(Icons.add_location),
                                  label: const Text('Crear lugar y continuar'),
                                  style: ElevatedButton.styleFrom(
                                    padding: const EdgeInsets.symmetric(vertical: 12),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                }
                
                return const SizedBox.shrink();
              },
            ),
          ),
        if (_selectedVenue != null && _selectedVenue!.isPending) ...[
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primaryContainer.withOpacity(0.3),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.schedule,
                  size: 16,
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Este lugar está pendiente de aprobación',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Theme.of(context).colorScheme.onSurfaceVariant,
                        ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildInfoRow(IconData icon, String text) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 16, color: Theme.of(context).colorScheme.onSurfaceVariant),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            text,
            style: Theme.of(context).textTheme.bodySmall,
          ),
        ),
      ],
    );
  }
}


