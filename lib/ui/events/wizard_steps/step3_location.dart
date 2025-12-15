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

  void _openMapPicker() {
    if (widget.wizardData.city == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Primero debes seleccionar una ciudad'),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    final cityLocation = LatLng(
      widget.wizardData.city!.lat ?? 36.1927,
      widget.wizardData.city!.lng ?? -5.9219,
    );

    final initialLocation = widget.wizardData.lat != null && widget.wizardData.lng != null
        ? LatLng(widget.wizardData.lat!, widget.wizardData.lng!)
        : cityLocation;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Theme.of(context).colorScheme.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => _buildMapBottomSheet(initialLocation: initialLocation),
    );
  }

  Widget _buildMapBottomSheet({required LatLng initialLocation}) {
    LatLng currentMarkerPosition = widget.wizardData.lat != null && widget.wizardData.lng != null
        ? LatLng(widget.wizardData.lat!, widget.wizardData.lng!)
        : initialLocation;

    return StatefulBuilder(
      builder: (context, setModalState) {
        return SizedBox(
          height: MediaQuery.of(context).size.height * 0.9,
          child: Column(
            children: [
              AppBar(
                title: const Text('Seleccionar ubicación'),
                leading: IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () => Navigator.of(context).pop(),
                ),
                elevation: 0,
              ),
              Expanded(
                child: GoogleMap(
                  initialCameraPosition: CameraPosition(
                    target: currentMarkerPosition,
                    zoom: 14.0,
                  ),
                  onTap: (LatLng position) {
                    setModalState(() {
                      currentMarkerPosition = position;
                    });
                  },
                  markers: {
                    Marker(
                      markerId: const MarkerId('picked'),
                      position: currentMarkerPosition,
                      draggable: true,
                      onDragEnd: (LatLng newPosition) {
                        setModalState(() {
                          currentMarkerPosition = newPosition;
                        });
                      },
                    ),
                  },
                  myLocationButtonEnabled: false,
                  zoomControlsEnabled: true,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    Text(
                      'Toca el mapa o arrastra el marcador rojo para seleccionar la ubicación.',
                      style: Theme.of(context).textTheme.bodyMedium,
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Lat: ${currentMarkerPosition.latitude.toStringAsFixed(4)}, Lng: ${currentMarkerPosition.longitude.toStringAsFixed(4)}',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () {
                        setState(() {
                          widget.wizardData.lat = currentMarkerPosition.latitude;
                          widget.wizardData.lng = currentMarkerPosition.longitude;
                        });
                        Navigator.of(context).pop();
                      },
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        minimumSize: const Size(double.infinity, 48),
                      ),
                      child: const Text('Usar esta ubicación'),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
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

