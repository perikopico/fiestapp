// lib/ui/common/venue_search_field.dart
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show debugPrint;
import '../../models/venue.dart';
import '../../services/venue_service.dart';
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

    _debouncer = Timer(const Duration(milliseconds: 400), () async {
      setState(() => _isSearching = true);
      try {
        debugPrint('🔍 Buscando lugares: "${value.trim()}" en ${widget.cityName}');
        
        // Primero buscar en la base de datos
        final venues = await _venueService.searchVenues(
          query: value.trim(),
          cityId: widget.cityId,
          limit: 5,
        );
        
        debugPrint('📊 Resultados en BD: ${venues.length}');

        // Si no hay resultados en la BD, buscar en Google Places
        List<GooglePlace> googlePlaces = [];
        if (venues.isEmpty && value.trim().length >= 3) {
          debugPrint('🌐 Buscando en Google Places...');
          googlePlaces = await _placesService.searchPlaces(
            query: value.trim(),
            cityName: widget.cityName,
            limit: 5,
          );
          debugPrint('📊 Resultados en Google Places: ${googlePlaces.length}');
        }

        if (!mounted) return;
        setState(() {
          _suggestions = venues;
          _googlePlacesSuggestions = googlePlaces;
          _isSearching = false;
          // Si no hay sugerencias de ningún tipo y hay texto, es un lugar nuevo
          _isNewVenue = venues.isEmpty && googlePlaces.isEmpty && value.trim().isNotEmpty;
        });
        
        debugPrint('✅ Búsqueda completada. Sugerencias: ${venues.length + googlePlaces.length}');
        debugPrint('   Lugares BD: ${venues.length}, Google Places: ${googlePlaces.length}');
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

  void _selectVenue(Venue venue) {
    _controller.text = venue.name;
    setState(() {
      _selectedVenue = venue;
      _suggestions = [];
      _googlePlacesSuggestions = [];
      _query = venue.name;
      _isNewVenue = false;
    });
    widget.onVenueSelected(venue);
  }

  Future<void> _createNewVenue() async {
    if (widget.cityId == null) return;
    
    final venueName = _controller.text.trim();
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

      // Intentar buscar el lugar en Google Places para obtener coordenadas
      double? lat;
      double? lng;
      String? address;
      
      try {
        final searchQuery = '$venueName, ${widget.cityName}';
        debugPrint('🔍 Buscando coordenadas para: $searchQuery');
        
        final googlePlaces = await _placesService.searchPlaces(
          query: venueName,
          cityName: widget.cityName,
          limit: 1,
        );
        
        if (googlePlaces.isNotEmpty) {
          final place = googlePlaces.first;
          lat = place.lat;
          lng = place.lng;
          address = place.address;
          debugPrint('✅ Coordenadas encontradas: $lat, $lng');
        } else {
          debugPrint('⚠️ No se encontraron coordenadas en Google Places');
        }
      } catch (e) {
        debugPrint('⚠️ Error al buscar coordenadas: $e');
        // Continuar sin coordenadas
      }

      // Crear el venue (con o sin coordenadas) - SIEMPRE con status='pending'
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
      
      widget.onVenueSelected(newVenue);
      
      ScaffoldMessenger.of(context).hideCurrentSnackBar();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            lat != null && lng != null
                ? 'Lugar creado con ubicación. Está pendiente de aprobación.'
                : 'Lugar creado. Está pendiente de aprobación. Puedes marcar la ubicación en el mapa.',
          ),
          duration: const Duration(seconds: 3),
        ),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).hideCurrentSnackBar();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error al crear lugar: ${e.toString()}'),
          backgroundColor: Theme.of(context).colorScheme.error,
        ),
      );
    }
  }

  /// Crea un venue desde un lugar de Google Places
  Future<void> _createVenueFromGooglePlace(GooglePlace place) async {
    if (widget.cityId == null) return;

    try {
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
              Text('Creando lugar...'),
            ],
          ),
          duration: Duration(seconds: 2),
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
      
      widget.onVenueSelected(newVenue);
      
      ScaffoldMessenger.of(context).hideCurrentSnackBar();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Lugar creado con coordenadas. Está pendiente de aprobación.'),
          duration: Duration(seconds: 3),
        ),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).hideCurrentSnackBar();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error al crear lugar: ${e.toString()}'),
          backgroundColor: Theme.of(context).colorScheme.error,
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
                
                // Opción de crear nuevo lugar al final
                if (showNewVenueOption) {
                  return ListTile(
                    dense: true,
                    leading: const Icon(Icons.add_circle_outline, size: 20),
                    title: Text('Crear nuevo lugar: "${_query.trim()}"'),
                    subtitle: const Text(
                      'Este lugar quedará pendiente de aprobación',
                      style: TextStyle(fontSize: 11),
                    ),
                    onTap: _createNewVenue,
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
}
