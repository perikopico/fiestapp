import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' hide Category;
import 'package:intl/intl.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../../services/event_service.dart';
import '../../services/city_service.dart';
import '../../services/category_service.dart';
import '../../models/category.dart';

class EventSubmitScreen extends StatelessWidget {
  const EventSubmitScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const _EventSubmitScreenContent();
  }
}

class _EventSubmitScreenContent extends StatefulWidget {
  const _EventSubmitScreenContent();

  @override
  State<_EventSubmitScreenContent> createState() => _EventSubmitScreenContentState();
}

class _EventSubmitScreenContentState extends State<_EventSubmitScreenContent> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _placeController = TextEditingController();

  final EventService _eventService = EventService.instance;
  final CityService _cityService = CityService.instance;
  final CategoryService _categoryService = CategoryService();

  List<City> _cities = [];
  List<Category> _categories = [];
  bool _isLoadingData = true;
  bool _isSubmitting = false;

  City? _selectedCity;
  Category? _selectedCategory;
  DateTime? _selectedDateTime;
  bool _isFree = true;
  double? _lat;
  double? _lng;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _placeController.dispose();
    super.dispose();
  }

  Future<void> _loadData() async {
    try {
      final provId = await _cityService.getProvinceIdBySlug('cadiz');
      final cities = await _cityService.fetchCities(provinceId: provId);
      final categories = await _categoryService.fetchAll();

      if (mounted) {
        setState(() {
          _cities = cities;
          _categories = categories;
          _isLoadingData = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoadingData = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error al cargar datos: ${e.toString()}'),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoadingData) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Publicar evento'),
        ),
        body: const Center(
          child: CircularProgressIndicator(),
        ),
      );
    }
    return Scaffold(
      appBar: AppBar(
        title: const Text('Publicar evento'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Título del evento (obligatorio)
              TextFormField(
                controller: _titleController,
                decoration: InputDecoration(
                  labelText: 'Título del evento',
                  hintText: 'Ej: Festival de Verano',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'El título es obligatorio';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Descripción (multilínea)
              TextFormField(
                controller: _descriptionController,
                decoration: InputDecoration(
                  labelText: 'Descripción',
                  hintText: 'Describe tu evento...',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  alignLabelWithHint: true,
                ),
                maxLines: 4,
                minLines: 3,
              ),
              const SizedBox(height: 16),

              // Lugar
              TextFormField(
                controller: _placeController,
                decoration: InputDecoration(
                  labelText: 'Lugar',
                  hintText: 'Ej: Plaza del Ayuntamiento',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Selector de fecha y hora
              OutlinedButton.icon(
                onPressed: () async {
                  final date = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime.now(),
                    lastDate: DateTime.now().add(const Duration(days: 365)),
                  );

                  if (date != null) {
                    final time = await showTimePicker(
                      context: context,
                      initialTime: TimeOfDay.now(),
                    );

                    if (time != null) {
                      setState(() {
                        _selectedDateTime = DateTime(
                          date.year,
                          date.month,
                          date.day,
                          time.hour,
                          time.minute,
                        );
                      });
                    }
                  }
                },
                icon: const Icon(Icons.calendar_today),
                label: const Text('Seleccionar fecha y hora'),
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
              ),
              if (_selectedDateTime != null) ...[
                const SizedBox(height: 8),
                Text(
                  'Fecha seleccionada: ${DateFormat('dd/MM/yyyy HH:mm').format(_selectedDateTime!)}',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Theme.of(context).colorScheme.primary,
                      ),
                ),
              ],
              const SizedBox(height: 16),

              // Selector de ciudad
              DropdownButtonFormField<City>(
                decoration: InputDecoration(
                  labelText: 'Ciudad',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                value: _selectedCity,
                items: _cities.map((city) {
                  return DropdownMenuItem<City>(
                    value: city,
                    child: Text(city.name),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedCity = value;
                  });
                },
                validator: (value) {
                  if (value == null) {
                    return 'Por favor, selecciona una ciudad';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Selector de categoría
              DropdownButtonFormField<Category>(
                decoration: InputDecoration(
                  labelText: 'Categoría',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                value: _selectedCategory,
                items: _categories.where((Category c) => c.id != null).map((Category category) {
                  return DropdownMenuItem<Category>(
                    value: category,
                    child: Text(category.name),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedCategory = value;
                  });
                },
                validator: (value) {
                  if (value == null) {
                    return 'Por favor, selecciona una categoría';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Switch para evento gratuito
              Card(
                child: SwitchListTile(
                  title: const Text('Evento gratuito'),
                  value: _isFree,
                  onChanged: (value) {
                    setState(() {
                      _isFree = value;
                    });
                  },
                ),
              ),
              const SizedBox(height: 16),

              // Selector de ubicación en el mapa
              Text(
                'Ubicación en el mapa',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 8),
              OutlinedButton.icon(
                onPressed: _openMapPicker,
                icon: const Icon(Icons.map),
                label: const Text('Elegir en el mapa'),
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
              ),
              const SizedBox(height: 8),
              Text(
                _lat != null && _lng != null
                    ? 'Lat: ${_lat!.toStringAsFixed(4)}, Lng: ${_lng!.toStringAsFixed(4)}'
                    : 'Ninguna ubicación seleccionada',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: _lat != null && _lng != null
                          ? Theme.of(context).colorScheme.primary
                          : Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
              ),
              const SizedBox(height: 32),

              // Botón de enviar
              ElevatedButton(
                onPressed: _isSubmitting
                    ? null
                    : () async {
                        if (!_formKey.currentState!.validate()) {
                          return;
                        }

                        if (_selectedDateTime == null) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Por favor, selecciona una fecha y hora'),
                            ),
                          );
                          return;
                        }

                        if (_selectedCity == null) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Por favor, selecciona una ciudad'),
                            ),
                          );
                          return;
                        }

                        if (_selectedCategory == null || _selectedCategory!.id == null) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Por favor, selecciona una categoría'),
                            ),
                          );
                          return;
                        }

                        try {
                          setState(() {
                            _isSubmitting = true;
                          });

                          await _eventService.submitEvent(
                            title: _titleController.text,
                            town: _selectedCity!.name,
                            place: _placeController.text.trim().isEmpty
                                ? _selectedCity!.name
                                : _placeController.text,
                            startsAt: _selectedDateTime!,
                            cityId: _selectedCity!.id,
                            categoryId: _selectedCategory!.id!,
                            description: _descriptionController.text.trim().isEmpty
                                ? null
                                : _descriptionController.text.trim(),
                            mapsUrl: (_lat != null && _lng != null)
                                ? 'https://www.google.com/maps/search/?api=1&query=$_lat,$_lng'
                                : null,
                            lat: _lat,
                            lng: _lng,
                            isFree: _isFree,
                          );

                          if (context.mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Tu evento se ha enviado y quedará pendiente de revisión.'),
                                duration: Duration(seconds: 2),
                              ),
                            );

                            // Esperar un poco antes de hacer pop para que el usuario vea el mensaje
                            Future.delayed(const Duration(milliseconds: 500), () {
                              if (context.mounted) {
                                Navigator.of(context).pop();
                              }
                            });
                          }
                        } catch (e) {
                          if (context.mounted) {
                            setState(() {
                              _isSubmitting = false;
                            });
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('Error al enviar el evento: ${e.toString()}'),
                                duration: const Duration(seconds: 3),
                              ),
                            );
                          }
                        }
                      },
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: _isSubmitting
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Text('Enviar evento'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Abre el bottom sheet con el selector de mapa
  void _openMapPicker() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Theme.of(context).colorScheme.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => _buildMapBottomSheet(),
    );
  }

  /// Construye el bottom sheet con el mapa interactivo
  Widget _buildMapBottomSheet() {
    // Determinar el centro inicial del mapa y la posición inicial del marcador
    LatLng initialCenter;
    LatLng? initialMarkerPosition;
    
    if (_lat != null && _lng != null) {
      // Si ya hay coordenadas seleccionadas, usar esas
      initialCenter = LatLng(_lat!, _lng!);
      initialMarkerPosition = initialCenter;
    } else if (_selectedCity?.lat != null && _selectedCity?.lng != null) {
      // Si hay ciudad seleccionada con coordenadas, usar esas
      initialCenter = LatLng(_selectedCity!.lat!, _selectedCity!.lng!);
      initialMarkerPosition = initialCenter;
    } else {
      // Por defecto, usar Barbate
      initialCenter = const LatLng(36.1927, -5.9219);
      initialMarkerPosition = initialCenter;
    }

    return StatefulBuilder(
      builder: (context, setModalState) {
        // Estado local del marcador en el mapa (inicializado con la posición existente si hay)
        LatLng? pickedLatLng = initialMarkerPosition;

        return SizedBox(
          height: MediaQuery.of(context).size.height * 0.9,
          child: Column(
            children: [
              // AppBar del bottom sheet
              AppBar(
                title: const Text('Seleccionar ubicación'),
                leading: IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () => Navigator.of(context).pop(),
                ),
                elevation: 0,
              ),
              // Mapa interactivo o mensaje para web
              Expanded(
                child: kIsWeb
                    ? Center(
                        child: Padding(
                          padding: const EdgeInsets.all(24.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.map_outlined,
                                size: 64,
                                color: Theme.of(context).colorScheme.onSurfaceVariant,
                              ),
                              const SizedBox(height: 16),
                              Text(
                                'La selección en el mapa solo está disponible en la app móvil',
                                style: Theme.of(context).textTheme.titleMedium,
                                textAlign: TextAlign.center,
                              ),
                              const SizedBox(height: 8),
                              Text(
                                'Usa la app en Android o iOS para seleccionar una ubicación en el mapa.',
                                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                                    ),
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        ),
                      )
                    : GoogleMap(
                        initialCameraPosition: CameraPosition(
                          target: initialCenter,
                          zoom: 14.0,
                        ),
                        onTap: (LatLng position) {
                          // Al hacer tap, actualizar la posición del marcador
                          setModalState(() {
                            pickedLatLng = position;
                          });
                        },
                        markers: pickedLatLng != null
                            ? {
                                Marker(
                                  markerId: const MarkerId('picked'),
                                  position: pickedLatLng!,
                                ),
                              }
                            : {},
                        myLocationButtonEnabled: false,
                        zoomControlsEnabled: true,
                      ),
              ),
              // Botón de confirmar
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: ElevatedButton(
                  onPressed: () {
                    // Usar las coordenadas seleccionadas o las actuales/existentes
                    final finalLatLng = pickedLatLng ?? initialMarkerPosition;
                    if (finalLatLng != null) {
                      setState(() {
                        _lat = finalLatLng.latitude;
                        _lng = finalLatLng.longitude;
                      });
                    }
                    Navigator.of(context).pop();
                  },
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    minimumSize: const Size(double.infinity, 48),
                  ),
                  child: const Text('Usar esta ubicación'),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
