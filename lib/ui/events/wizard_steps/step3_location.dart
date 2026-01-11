import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show debugPrint;
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../../common/city_search_field.dart';
import '../../common/venue_search_field.dart';
import '../event_wizard_screen.dart';

class Step3Location extends StatefulWidget {
  final EventWizardData wizardData;
  final VoidCallback onNext;
  final VoidCallback onBack;

  const Step3Location({
    super.key,
    required this.wizardData,
    required this.onNext,
    required this.onBack,
  });

  @override
  State<Step3Location> createState() => _Step3LocationState();
}

class _Step3LocationState extends State<Step3Location> {
  final _placeController = TextEditingController();
  bool _showMapPicker = false;

  @override
  void initState() {
    super.initState();
    if (widget.wizardData.placeText != null) {
      _placeController.text = widget.wizardData.placeText!;
    }
  }

  @override
  void dispose() {
    _placeController.dispose();
    super.dispose();
  }

  bool _validate() {
    if (widget.wizardData.city == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Por favor, selecciona una ciudad'),
          backgroundColor: Colors.orange,
        ),
      );
      return false;
    }
    return true;
  }

  void _handleNext() {
    if (_validate()) {
      // Guardar datos
      widget.wizardData.placeText = _placeController.text.trim();
      widget.wizardData.stepValidated[2] = true;
      
      widget.onNext();
    }
  }

  Future<void> _openMapPicker() async {
    if (widget.wizardData.city == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Primero debes seleccionar una ciudad'),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    if (!mounted) return;

    try {
      final cityLocation = LatLng(
        widget.wizardData.city!.lat ?? 36.1927,
        widget.wizardData.city!.lng ?? -5.9219,
      );

      final initialLocation = widget.wizardData.lat != null && widget.wizardData.lng != null
          ? LatLng(widget.wizardData.lat!, widget.wizardData.lng!)
          : cityLocation;

      // Permitir que el framework procese antes de abrir el modal
      // Esperar varios frames para asegurar que el UI esté listo
      await Future.delayed(const Duration(milliseconds: 200));

      if (!mounted) return;

      // Usar uncompleter y esperar al siguiente frame antes de construir el mapa
      await Future.delayed(const Duration(milliseconds: 100));

      if (!mounted) return;

      // Pasar los límites geográficos de la ciudad al mapa
      final cityBounds = widget.wizardData.city != null
          ? _CityBounds(
              latMin: widget.wizardData.city!.latMin,
              latMax: widget.wizardData.city!.latMax,
              lngMin: widget.wizardData.city!.lngMin,
              lngMax: widget.wizardData.city!.lngMax,
            )
          : null;

      // Usar Navigator.push con una ruta que no bloquea
      final result = await Navigator.of(context).push<Map<String, double>?>(
        PageRouteBuilder(
          pageBuilder: (context, animation, secondaryAnimation) => _MapPickerScreen(
            initialLocation: initialLocation,
            currentLocation: widget.wizardData.lat != null && widget.wizardData.lng != null
                ? LatLng(widget.wizardData.lat!, widget.wizardData.lng!)
                : initialLocation,
            cityBounds: cityBounds,
            cityName: widget.wizardData.city?.name,
          ),
          transitionDuration: const Duration(milliseconds: 200),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return FadeTransition(opacity: animation, child: child);
          },
        ),
      );

      if (result != null && mounted) {
        final selectedLat = result['lat'] as double?;
        final selectedLng = result['lng'] as double?;
        
        // Validar que la ubicación seleccionada esté dentro de los límites de la ciudad
        if (widget.wizardData.city != null && 
            selectedLat != null && 
            selectedLng != null &&
            widget.wizardData.city!.isWithinBounds(selectedLat, selectedLng)) {
          setState(() {
            widget.wizardData.lat = selectedLat;
            widget.wizardData.lng = selectedLng;
          });
        } else if (widget.wizardData.city != null && selectedLat != null && selectedLng != null) {
          // Mostrar advertencia si está fuera de los límites
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                'La ubicación seleccionada está fuera de los límites de ${widget.wizardData.city!.name}. '
                'Por favor, selecciona una ubicación dentro del municipio.',
              ),
              backgroundColor: Colors.orange,
              duration: const Duration(seconds: 4),
            ),
          );
        } else {
          setState(() {
            widget.wizardData.lat = selectedLat;
            widget.wizardData.lng = selectedLng;
          });
        }
      }
    } catch (e, stackTrace) {
      debugPrint('❌ Error al abrir el selector de mapa: $e');
      debugPrint('Stack trace: $stackTrace');
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error al abrir el mapa: ${e.toString()}'),
            backgroundColor: Colors.red,
            duration: const Duration(seconds: 3),
          ),
        );
      }
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // Contenido
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Título de la sección
                    Text(
                      'Ciudad y Lugar',
                      style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Primero selecciona la ciudad donde se realizará el evento',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                    ),
                    const SizedBox(height: 32),

                    // Búsqueda de ciudad
                    CitySearchField(
                      initialCity: widget.wizardData.city,
                      onCitySelected: (city) {
                        setState(() {
                          widget.wizardData.city = city;
                          widget.wizardData.cityId = city.id;
                          // Limpiar lugar si cambia la ciudad
                          if (widget.wizardData.venue != null) {
                            widget.wizardData.venue = null;
                            widget.wizardData.placeText = null;
                            _placeController.clear();
                          }
                        });
                      },
                      labelText: 'Ciudad *',
                    ),
                    const SizedBox(height: 24),

                    // Búsqueda de lugar/venue (solo si hay ciudad seleccionada)
                    if (widget.wizardData.cityId != null && widget.wizardData.city != null) ...[
                      Text(
                        'Lugar específico (opcional)',
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Busca un lugar existente o crea uno nuevo. Si no especificas un lugar, se usará la ciudad.',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Theme.of(context).colorScheme.onSurfaceVariant,
                        ),
                      ),
                      const SizedBox(height: 12),
                      VenueSearchField(
                        initialVenue: widget.wizardData.venue,
                        cityId: widget.wizardData.cityId,
                        cityName: widget.wizardData.city!.name,
                        onVenueSelected: (venue) {
                          setState(() {
                            widget.wizardData.venue = venue;
                            if (venue?.lat != null && venue?.lng != null) {
                              widget.wizardData.lat = venue!.lat;
                              widget.wizardData.lng = venue.lng;
                            }
                            // Si se selecciona un venue, limpiar el campo de texto libre
                            if (venue != null) {
                              _placeController.clear();
                              widget.wizardData.placeText = null;
                            }
                          });
                        },
                        labelText: 'Buscar lugar',
                      ),
                    ] else ...[
                      Card(
                        color: Theme.of(context).colorScheme.surfaceContainerHighest,
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Row(
                            children: [
                              Icon(
                                Icons.info_outline,
                                color: Theme.of(context).colorScheme.primary,
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Text(
                                  'Selecciona primero una ciudad para poder buscar o añadir un lugar específico',
                                  style: Theme.of(context).textTheme.bodySmall,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                    const SizedBox(height: 24),

                    // Selector de ubicación en el mapa
                    if (widget.wizardData.city != null) ...[
                      OutlinedButton.icon(
                        onPressed: _openMapPicker,
                        icon: Icon(
                          widget.wizardData.lat != null && widget.wizardData.lng != null
                              ? Icons.edit_location
                              : Icons.map,
                        ),
                        label: Text(
                          widget.wizardData.lat != null && widget.wizardData.lng != null
                              ? 'Cambiar ubicación en el mapa'
                              : 'Elegir ubicación en el mapa (opcional)',
                        ),
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          minimumSize: const Size(double.infinity, 56),
                        ),
                      ),
                      if (widget.wizardData.lat != null && widget.wizardData.lng != null) ...[
                        const SizedBox(height: 8),
                        Text(
                          'Ubicación seleccionada: Lat: ${widget.wizardData.lat!.toStringAsFixed(4)}, Lng: ${widget.wizardData.lng!.toStringAsFixed(4)}',
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: Theme.of(context).colorScheme.primary,
                          ),
                        ),
                      ],
                    ] else
                      Card(
                        color: Theme.of(context).colorScheme.surfaceContainerHighest,
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Row(
                            children: [
                              Icon(
                                Icons.info_outline,
                                color: Theme.of(context).colorScheme.primary,
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Text(
                                  'Selecciona primero una ciudad para poder elegir la ubicación en el mapa',
                                  style: Theme.of(context).textTheme.bodySmall,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),

            // Botones de navegación
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surface,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 4,
                    offset: const Offset(0, -2),
                  ),
                ],
              ),
              child: SafeArea(
                child: Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: widget.onBack,
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                        ),
                        child: const Text('Atrás'),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      flex: 2,
                      child: ElevatedButton(
                        onPressed: _handleNext,
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                        ),
                        child: const Text('Siguiente'),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Clase helper para almacenar límites geográficos de la ciudad
class _CityBounds {
  final double? latMin;
  final double? latMax;
  final double? lngMin;
  final double? lngMax;

  _CityBounds({
    this.latMin,
    this.latMax,
    this.lngMin,
    this.lngMax,
  });

  bool get hasBounds => latMin != null && latMax != null && lngMin != null && lngMax != null;

  bool isWithinBounds(double lat, double lng) {
    if (!hasBounds) return true;
    return lat >= latMin! && lat <= latMax! && lng >= lngMin! && lng <= lngMax!;
  }
}

/// Pantalla completa para el selector de mapa (carga diferida para evitar bloqueos)
class _MapPickerScreen extends StatefulWidget {
  final LatLng initialLocation;
  final LatLng currentLocation;
  final _CityBounds? cityBounds;
  final String? cityName;

  const _MapPickerScreen({
    required this.initialLocation,
    required this.currentLocation,
    this.cityBounds,
    this.cityName,
  });

  @override
  State<_MapPickerScreen> createState() => _MapPickerScreenState();
}

class _MapPickerScreenState extends State<_MapPickerScreen> {
  late LatLng _currentMarkerPosition;
  bool _isOutOfBounds = false;

  @override
  void initState() {
    super.initState();
    _currentMarkerPosition = widget.currentLocation;
    _checkBounds();
  }

  void _updateMarkerPosition(LatLng position) {
    if (mounted) {
      setState(() {
        _currentMarkerPosition = position;
        _checkBounds();
      });
    }
  }

  void _checkBounds() {
    if (widget.cityBounds != null && widget.cityBounds!.hasBounds) {
      _isOutOfBounds = !widget.cityBounds!.isWithinBounds(
        _currentMarkerPosition.latitude,
        _currentMarkerPosition.longitude,
      );
    } else {
      _isOutOfBounds = false;
    }
  }

  void _handleConfirm() {
    if (_isOutOfBounds && widget.cityName != null) {
      // Mostrar advertencia antes de confirmar
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Ubicación fuera de límites'),
          content: Text(
            'La ubicación seleccionada está fuera de los límites de ${widget.cityName}.\n\n'
            '¿Deseas continuar de todas formas?',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancelar'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.of(context).pop({
                  'lat': _currentMarkerPosition.latitude,
                  'lng': _currentMarkerPosition.longitude,
                });
              },
              child: const Text('Continuar'),
            ),
          ],
        ),
      );
    } else {
      Navigator.of(context).pop({
        'lat': _currentMarkerPosition.latitude,
        'lng': _currentMarkerPosition.longitude,
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Seleccionar ubicación'),
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: _MapPickerWidget(
              key: const ValueKey('map_picker_screen'), // Key estable para evitar rebuilds
              initialCenter: widget.initialLocation,
              initialMarkerPosition: widget.currentLocation,
              onMarkerUpdated: _updateMarkerPosition,
              cityBounds: widget.cityBounds,
            ),
          ),
          Container(
            padding: const EdgeInsets.all(16.0),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surface,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 4,
                  offset: const Offset(0, -2),
                ),
              ],
            ),
            child: SafeArea(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (widget.cityName != null) ...[
                    Text(
                      'Seleccionando ubicación en ${widget.cityName}',
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 8),
                  ],
                  Text(
                    'Toca el mapa o arrastra el marcador rojo para seleccionar la ubicación.',
                    style: Theme.of(context).textTheme.bodyMedium,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Lat: ${_currentMarkerPosition.latitude.toStringAsFixed(4)}, Lng: ${_currentMarkerPosition.longitude.toStringAsFixed(4)}',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: _isOutOfBounds
                          ? Theme.of(context).colorScheme.error
                          : Theme.of(context).colorScheme.primary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  if (_isOutOfBounds && widget.cityName != null) ...[
                    const SizedBox(height: 8),
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.errorContainer,
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            Icons.warning_amber_rounded,
                            size: 20,
                            color: Theme.of(context).colorScheme.onErrorContainer,
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              'Ubicación fuera de los límites de ${widget.cityName}',
                              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                color: Theme.of(context).colorScheme.onErrorContainer,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                  const SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _handleConfirm,
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        backgroundColor: _isOutOfBounds
                            ? Theme.of(context).colorScheme.error
                            : null,
                      ),
                      child: Text(_isOutOfBounds ? 'Usar de todas formas' : 'Usar esta ubicación'),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Widget simplificado para el mapa (carga asíncrona para evitar bloqueos)
class _MapPickerWidget extends StatefulWidget {
  final LatLng initialCenter;
  final LatLng initialMarkerPosition;
  final Function(LatLng) onMarkerUpdated;
  final _CityBounds? cityBounds;

  const _MapPickerWidget({
    super.key,
    required this.initialCenter,
    required this.initialMarkerPosition,
    required this.onMarkerUpdated,
    this.cityBounds,
  });

  @override
  State<_MapPickerWidget> createState() => _MapPickerWidgetState();
}

class _MapPickerWidgetState extends State<_MapPickerWidget> {
  GoogleMapController? _mapController;
  late LatLng _currentMarkerPosition;
  bool _mapInitialized = false;
  bool _hasError = false;
  String? _errorMessage;
  DateTime? _loadStartTime;
  GoogleMapController? _lastController; // Para verificar que no se use un controller desmontado

  @override
  void initState() {
    super.initState();
    _currentMarkerPosition = widget.initialMarkerPosition;
    _loadStartTime = DateTime.now();
    
    // Configurar timeout una sola vez
    Future.delayed(const Duration(seconds: 8), () {
      if (mounted && !_mapInitialized && !_hasError) {
        setState(() {
          _hasError = true;
          _errorMessage = 'El mapa está tardando demasiado en cargar.\n\n'
              'Posibles causas:\n'
              '• API key de Google Maps no configurada correctamente\n'
              '• Maps SDK for iOS no habilitada en Google Cloud Console\n'
              '• Problema de conexión a internet\n\n'
              'Verifica la configuración en: docs/VERIFICAR_GOOGLE_MAPS_IOS.md';
        });
      }
    });
  }

  @override
  void dispose() {
    // Solo disponer si es el controller actual
    if (_mapController == _lastController) {
      _mapController?.dispose();
    }
    _mapController = null;
    _lastController = null;
    super.dispose();
  }

  void _updateMarkerPosition(LatLng position) {
    if (mounted) {
      setState(() {
        _currentMarkerPosition = position;
      });
      widget.onMarkerUpdated(position);
    }
  }

  void _handleMapCreated(GoogleMapController controller) {
    debugPrint('✅ GoogleMap onMapCreated llamado');
    
    if (!mounted) {
      controller.dispose();
      return;
    }
    
    // Guardar referencia al controller
    _mapController = controller;
    _lastController = controller;
    
    if (mounted) {
      setState(() {
        _mapInitialized = true;
      });
      
      if (_loadStartTime != null) {
        final loadTime = DateTime.now().difference(_loadStartTime!);
        debugPrint('⏱️ Mapa cargado en ${loadTime.inMilliseconds}ms');
      }
      
      // Mover la cámara después de un breve delay, pero verificar que el controller sigue siendo válido
      Future.delayed(const Duration(milliseconds: 200), () {
        // Verificar que el widget sigue montado y el controller sigue siendo el mismo
        if (mounted && 
            _mapController != null && 
            _mapController == _lastController &&
            _mapController == controller) {
          try {
            // Si hay límites de la ciudad, ajustar la cámara a esos límites
            if (widget.cityBounds != null && widget.cityBounds!.hasBounds) {
              final bounds = LatLngBounds(
                southwest: LatLng(
                  widget.cityBounds!.latMin!,
                  widget.cityBounds!.lngMin!,
                ),
                northeast: LatLng(
                  widget.cityBounds!.latMax!,
                  widget.cityBounds!.lngMax!,
                ),
              );
              
              // Ajustar la cámara para mostrar los límites de la ciudad con padding
              _mapController!.animateCamera(
                CameraUpdate.newLatLngBounds(
                  bounds,
                  80.0, // padding en píxeles
                ),
              );
              debugPrint('✅ Cámara ajustada a límites de la ciudad');
            } else {
              // Si no hay límites, usar la posición inicial
              _mapController!.animateCamera(
                CameraUpdate.newLatLngZoom(
                  widget.initialMarkerPosition,
                  14.0,
                ),
              );
              debugPrint('✅ Cámara movida a posición inicial');
            }
          } catch (e) {
            // Solo loggear si el widget sigue montado
            if (mounted) {
              debugPrint('⚠️ Error al mover la cámara (ignorado): $e');
              // Fallback: intentar mover a la posición inicial sin límites
              try {
                _mapController!.animateCamera(
                  CameraUpdate.newLatLngZoom(
                    widget.initialMarkerPosition,
                    14.0,
                  ),
                );
              } catch (e2) {
                debugPrint('⚠️ Error en fallback: $e2');
              }
            }
          }
        } else {
          debugPrint('⚠️ Controller ya no es válido, no se mueve la cámara');
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // Si hay error, mostrar mensaje de error
    if (_hasError) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.error_outline,
                size: 48,
                color: Theme.of(context).colorScheme.error,
              ),
              const SizedBox(height: 16),
              Text(
                'Error al cargar el mapa',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 8),
              if (_errorMessage != null)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Text(
                    _errorMessage!,
                    style: Theme.of(context).textTheme.bodySmall,
                    textAlign: TextAlign.center,
                  ),
                ),
              const SizedBox(height: 24),
              ElevatedButton.icon(
                onPressed: () {
                  setState(() {
                    _hasError = false;
                    _mapInitialized = false;
                    _errorMessage = null;
                    _loadStartTime = DateTime.now();
                    _mapController?.dispose();
                    _mapController = null;
                  });
                },
                icon: const Icon(Icons.refresh),
                label: const Text('Reintentar'),
              ),
            ],
          ),
        ),
      );
    }

    // Configurar timeout una sola vez en initState, no en build

    // Construir el mapa directamente sin FutureBuilder para evitar rebuilds
    try {
      return Stack(
        children: [
          GoogleMap(
            key: const ValueKey('map_picker'), // Key estable para evitar rebuilds
            initialCameraPosition: CameraPosition(
              target: widget.initialCenter,
              zoom: 14.0,
            ),
            onTap: (LatLng position) {
              debugPrint('📍 Mapa tocado: ${position.latitude}, ${position.longitude}');
              _updateMarkerPosition(position);
            },
            markers: {
              Marker(
                markerId: const MarkerId('picked'),
                position: _currentMarkerPosition,
                draggable: true,
                icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
                onDragEnd: (LatLng newPosition) {
                  debugPrint('📍 Marcador arrastrado: ${newPosition.latitude}, ${newPosition.longitude}');
                  _updateMarkerPosition(newPosition);
                },
              ),
            },
            myLocationButtonEnabled: false,
            zoomControlsEnabled: true,
            scrollGesturesEnabled: true,
            zoomGesturesEnabled: true,
            tiltGesturesEnabled: false,
            rotateGesturesEnabled: true,
            onMapCreated: _handleMapCreated,
            onCameraMoveStarted: () {
              debugPrint('📍 Usuario moviendo el mapa');
            },
          ),
          // Mostrar indicador mientras el mapa se inicializa
          if (!_mapInitialized)
            Container(
              color: Theme.of(context).scaffoldBackgroundColor.withOpacity(0.9),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const CircularProgressIndicator(),
                    const SizedBox(height: 16),
                    Text(
                      'Inicializando mapa...',
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                    if (_loadStartTime != null) ...[
                      const SizedBox(height: 8),
                      Text(
                        'Tiempo: ${DateTime.now().difference(_loadStartTime!).inSeconds}s',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Theme.of(context).colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),
        ],
      );
    } catch (e, stackTrace) {
      debugPrint('❌ Error al construir GoogleMap: $e');
      debugPrint('Stack trace: $stackTrace');
      
      // Actualizar estado de error de forma segura
      if (mounted) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (mounted) {
            setState(() {
              _hasError = true;
              _errorMessage = 'Error al inicializar el mapa:\n$e\n\n'
                  'Posibles causas:\n'
                  '- API key de Google Maps no configurada o inválida\n'
                  '- Problema de conexión a internet\n'
                  '- APIs de Google Maps no habilitadas en Google Cloud Console';
            });
          }
        });
      }
      
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.error_outline,
                size: 48,
                color: Theme.of(context).colorScheme.error,
              ),
              const SizedBox(height: 16),
              Text(
                'Error al inicializar el mapa',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 8),
              Text(
                e.toString(),
                style: Theme.of(context).textTheme.bodySmall,
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      );
    }
  }
}

