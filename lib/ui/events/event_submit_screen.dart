import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' hide Category;
import 'package:intl/intl.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../../services/event_service.dart';
import '../../services/city_service.dart';
import '../../services/category_service.dart';
import '../../models/category.dart';
import '../common/city_search_field.dart';

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
  State<_EventSubmitScreenContent> createState() =>
      _EventSubmitScreenContentState();
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
  int? _selectedCityId;
  Category? _selectedCategory;
  DateTime? _startDate;
  DateTime? _endDate;
  TimeOfDay? _selectedTime;
  bool _isFree = true;
  bool _hasDailyProgram = false;
  double? _lat;
  double? _lng;

  // Programación diaria
  List<DateTime> _eventDays = [];
  final Map<DateTime, TextEditingController> _dailyProgramControllers = {};

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
    // Limpiar controladores de programación diaria
    for (final controller in _dailyProgramControllers.values) {
      controller.dispose();
    }
    _dailyProgramControllers.clear();
    super.dispose();
  }

  void _updateEventDays() {
    // Limpiar controladores anteriores
    for (final controller in _dailyProgramControllers.values) {
      controller.dispose();
    }
    _dailyProgramControllers.clear();
    _eventDays.clear();

    if (_startDate != null &&
        _endDate != null &&
        !_endDate!.isBefore(_startDate!)) {
      // Generar lista de días del rango
      DateTime currentDate = DateTime(
        _startDate!.year,
        _startDate!.month,
        _startDate!.day,
      );
      final finalDate = DateTime(
        _endDate!.year,
        _endDate!.month,
        _endDate!.day,
      );

      while (currentDate.isBefore(finalDate) ||
          currentDate.isAtSameMomentAs(finalDate)) {
        final dayKey = DateTime(
          currentDate.year,
          currentDate.month,
          currentDate.day,
        );
        _eventDays.add(dayKey);
        // Crear controlador para este día
        _dailyProgramControllers[dayKey] = TextEditingController();
        currentDate = currentDate.add(const Duration(days: 1));
      }
    }
  }

  String? _buildDescriptionForDay(DateTime day) {
    final baseDescription = _descriptionController.text.trim();

    if (!_hasDailyProgram) {
      return baseDescription.isEmpty ? null : baseDescription;
    }

    final dayKey = DateTime(day.year, day.month, day.day);
    final controller = _dailyProgramControllers[dayKey];
    final dayProgram = controller?.text.trim() ?? '';

    if (dayProgram.isEmpty) {
      return baseDescription.isEmpty ? null : baseDescription;
    }

    // Combinar descripción base con programación del día
    if (baseDescription.isEmpty) {
      return 'Programación:\n$dayProgram';
    }

    return '''$baseDescription



Programación:

$dayProgram''';
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
          SnackBar(content: Text('Error al cargar datos: ${e.toString()}')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoadingData) {
      return Scaffold(
        appBar: AppBar(title: const Text('Publicar evento')),
        body: const Center(child: CircularProgressIndicator()),
      );
    }
    return Scaffold(
      appBar: AppBar(title: const Text('Publicar evento')),
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

              // Switch de programación diaria
              Card(
                child: SwitchListTile(
                  title: const Text('Programación diaria'),
                  subtitle: const Text(
                    'Añade contenido específico para cada día del evento (opcional)',
                  ),
                  value: _hasDailyProgram,
                  onChanged: (value) {
                    setState(() {
                      _hasDailyProgram = value;
                      if (value) {
                        _updateEventDays();
                      } else {
                        // Limpiar controladores si se desactiva
                        for (final controller
                            in _dailyProgramControllers.values) {
                          controller.dispose();
                        }
                        _dailyProgramControllers.clear();
                        _eventDays.clear();
                      }
                    });
                  },
                ),
              ),

              // Campos de programación diaria
              if (_hasDailyProgram) ...[
                const SizedBox(height: 16),
                if (_startDate != null &&
                    _endDate != null &&
                    !_endDate!.isBefore(_startDate!) &&
                    _eventDays.isNotEmpty)
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Programación por día',
                        style: Theme.of(context).textTheme.titleMedium
                            ?.copyWith(fontWeight: FontWeight.w600),
                      ),
                      const SizedBox(height: 12),
                      ..._eventDays.map((day) {
                        final controller = _dailyProgramControllers[day];
                        if (controller == null) return const SizedBox.shrink();

                        return Padding(
                          padding: const EdgeInsets.only(bottom: 16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                DateFormat('EEE d MMM', 'es').format(day),
                                style: Theme.of(context).textTheme.titleSmall
                                    ?.copyWith(
                                      fontWeight: FontWeight.w600,
                                      color: Theme.of(
                                        context,
                                      ).colorScheme.primary,
                                    ),
                              ),
                              const SizedBox(height: 8),
                              TextField(
                                controller: controller,
                                decoration: InputDecoration(
                                  labelText: 'Programación de este día',
                                  hintText:
                                      'Ej: 10:00 - Apertura\n12:00 - Actuación principal...',
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  alignLabelWithHint: true,
                                ),
                                maxLines: 4,
                                minLines: 3,
                              ),
                            ],
                          ),
                        );
                      }).toList(),
                    ],
                  )
                else
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    child: Text(
                      'Selecciona primero un rango de fechas para añadir programación diaria.',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
              ],
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

              // Selector de fecha de inicio
              OutlinedButton.icon(
                onPressed: () async {
                  final date = await showDatePicker(
                    context: context,
                    initialDate: _startDate ?? DateTime.now(),
                    firstDate: DateTime.now(),
                    lastDate: DateTime.now().add(const Duration(days: 365)),
                  );

                  if (date != null) {
                    setState(() {
                      _startDate = DateTime(date.year, date.month, date.day);
                      // Si la fecha fin es anterior a la nueva fecha inicio, resetearla
                      if (_endDate != null && _endDate!.isBefore(_startDate!)) {
                        _endDate = null;
                      }
                      _updateEventDays();
                    });
                  }
                },
                icon: const Icon(Icons.calendar_today),
                label: Text(
                  _startDate != null
                      ? 'Fecha inicio: ${DateFormat('dd/MM/yyyy').format(_startDate!)}'
                      : 'Seleccionar fecha de inicio',
                ),
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
              ),
              const SizedBox(height: 12),

              // Selector de fecha de fin (opcional)
              OutlinedButton.icon(
                onPressed: () async {
                  final date = await showDatePicker(
                    context: context,
                    initialDate: _endDate ?? _startDate ?? DateTime.now(),
                    firstDate: _startDate ?? DateTime.now(),
                    lastDate: DateTime.now().add(const Duration(days: 365)),
                  );

                  if (date != null) {
                    setState(() {
                      _endDate = DateTime(date.year, date.month, date.day);
                      _updateEventDays();
                    });
                  }
                },
                icon: const Icon(Icons.event),
                label: Text(
                  _endDate != null
                      ? 'Fecha fin: ${DateFormat('dd/MM/yyyy').format(_endDate!)}'
                      : 'Seleccionar fecha de fin (opcional)',
                ),
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
              ),
              if (_endDate != null) ...[
                const SizedBox(height: 8),
                TextButton.icon(
                  onPressed: () {
                    setState(() {
                      _endDate = null;
                      _updateEventDays();
                    });
                  },
                  icon: const Icon(Icons.clear, size: 16),
                  label: const Text('Quitar fecha fin'),
                ),
              ],
              const SizedBox(height: 12),

              // Selector de hora (opcional)
              OutlinedButton.icon(
                onPressed: () async {
                  final time = await showTimePicker(
                    context: context,
                    initialTime: _selectedTime ?? TimeOfDay.now(),
                  );

                  if (time != null) {
                    setState(() {
                      _selectedTime = time;
                    });
                  }
                },
                icon: const Icon(Icons.access_time),
                label: Text(
                  _selectedTime != null
                      ? 'Hora: ${_selectedTime!.format(context)}'
                      : 'Seleccionar hora (opcional)',
                ),
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
              ),
              if (_selectedTime != null) ...[
                const SizedBox(height: 8),
                TextButton.icon(
                  onPressed: () {
                    setState(() {
                      _selectedTime = null;
                    });
                  },
                  icon: const Icon(Icons.clear, size: 16),
                  label: const Text('Quitar hora'),
                ),
              ],
              const SizedBox(height: 16),

              // Selector de ciudad con búsqueda
              CitySearchField(
                initialCity: _selectedCity,
                onCitySelected: (city) {
                  setState(() {
                    _selectedCity = city;
                    _selectedCityId = city.id;
                  });
                },
                labelText: 'Ciudad',
              ),
              if (_selectedCity == null)
                Padding(
                  padding: const EdgeInsets.only(top: 8, left: 12),
                  child: Text(
                    'Por favor, selecciona una ciudad',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Theme.of(context).colorScheme.error,
                    ),
                  ),
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
                items: _categories.where((Category c) => c.id != null).map((
                  Category category,
                ) {
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

                        if (_startDate == null) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text(
                                'Por favor, selecciona una fecha de inicio',
                              ),
                            ),
                          );
                          return;
                        }

                        if (_selectedCity == null || _selectedCityId == null) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Por favor, selecciona una ciudad'),
                            ),
                          );
                          return;
                        }

                        if (_selectedCategory == null ||
                            _selectedCategory!.id == null) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text(
                                'Por favor, selecciona una categoría',
                              ),
                            ),
                          );
                          return;
                        }

                        try {
                          setState(() {
                            _isSubmitting = true;
                          });

                          // Determinar el rango de fechas
                          final startDate = _startDate!;
                          final endDate = _endDate;

                          // Si no hay fecha fin o es igual a la inicio, crear un solo evento
                          final isSingleEvent =
                              endDate == null ||
                              (endDate.year == startDate.year &&
                                  endDate.month == startDate.month &&
                                  endDate.day == startDate.day);

                          int eventsCreated = 0;
                          String? errorMessage;

                          if (isSingleEvent) {
                            // Crear un solo evento
                            final hour = _selectedTime?.hour ?? 0;
                            final minute = _selectedTime?.minute ?? 0;
                            final startsAt = DateTime(
                              startDate.year,
                              startDate.month,
                              startDate.day,
                              hour,
                              minute,
                            );

                            final description = _buildDescriptionForDay(
                              startDate,
                            );

                            await _eventService.submitEvent(
                              title: _titleController.text,
                              town: _selectedCity!.name,
                              place: _placeController.text.trim().isEmpty
                                  ? _selectedCity!.name
                                  : _placeController.text,
                              startsAt: startsAt,
                              cityId: _selectedCityId!,
                              categoryId: _selectedCategory!.id!,
                              description: description,
                              mapsUrl: (_lat != null && _lng != null)
                                  ? 'https://www.google.com/maps/search/?api=1&query=$_lat,$_lng'
                                  : null,
                              lat: _lat,
                              lng: _lng,
                              isFree: _isFree,
                            );
                            eventsCreated = 1;
                          } else {
                            // Crear un evento por cada día del rango
                            final hour = _selectedTime?.hour ?? 0;
                            final minute = _selectedTime?.minute ?? 0;

                            // Iterar por cada día del rango (inclusive)
                            DateTime currentDate = DateTime(
                              startDate.year,
                              startDate.month,
                              startDate.day,
                            );
                            final finalDate = DateTime(
                              endDate.year,
                              endDate.month,
                              endDate.day,
                            );

                            while (currentDate.isBefore(finalDate) ||
                                currentDate.isAtSameMomentAs(finalDate)) {
                              try {
                                final dayKey = DateTime(
                                  currentDate.year,
                                  currentDate.month,
                                  currentDate.day,
                                );
                                final startsAt = DateTime(
                                  currentDate.year,
                                  currentDate.month,
                                  currentDate.day,
                                  hour,
                                  minute,
                                );

                                final description = _buildDescriptionForDay(
                                  dayKey,
                                );

                                await _eventService.submitEvent(
                                  title: _titleController.text,
                                  town: _selectedCity!.name,
                                  place: _placeController.text.trim().isEmpty
                                      ? _selectedCity!.name
                                      : _placeController.text,
                                  startsAt: startsAt,
                                  cityId: _selectedCityId!,
                                  categoryId: _selectedCategory!.id!,
                                  description: description,
                                  mapsUrl: (_lat != null && _lng != null)
                                      ? 'https://www.google.com/maps/search/?api=1&query=$_lat,$_lng'
                                      : null,
                                  lat: _lat,
                                  lng: _lng,
                                  isFree: _isFree,
                                );
                                eventsCreated++;
                              } catch (e) {
                                errorMessage =
                                    'Error al crear evento para ${DateFormat('dd/MM/yyyy').format(currentDate)}: $e';
                                break; // Detener si hay un error
                              }

                              // Avanzar al siguiente día
                              currentDate = currentDate.add(
                                const Duration(days: 1),
                              );
                            }
                          }

                          if (context.mounted) {
                            setState(() {
                              _isSubmitting = false;
                            });

                            if (errorMessage != null) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(errorMessage),
                                  backgroundColor: Theme.of(context).colorScheme.error,
                                  duration: const Duration(seconds: 4),
                                ),
                              );
                            } else {
                              final message = eventsCreated == 1
                                  ? 'Tu evento se ha enviado y quedará pendiente de revisión.'
                                  : 'Se han creado $eventsCreated días de evento pendientes de revisión.';

                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(message),
                                  duration: const Duration(seconds: 3),
                                ),
                              );

                              // Esperar un poco antes de hacer pop para que el usuario vea el mensaje
                              Future.delayed(
                                const Duration(milliseconds: 500),
                                () {
                                  if (context.mounted) {
                                    Navigator.of(context).pop();
                                  }
                                },
                              );
                            }
                          }
                        } catch (e) {
                          if (context.mounted) {
                            setState(() {
                              _isSubmitting = false;
                            });
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  'Error al enviar el evento. Por favor, inténtalo de nuevo.',
                                ),
                                backgroundColor: Theme.of(
                                  context,
                                ).colorScheme.error,
                                duration: const Duration(seconds: 4),
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
                    ? Row(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          ),
                          const SizedBox(width: 12),
                          const Text('Enviando...'),
                        ],
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
                                color: Theme.of(
                                  context,
                                ).colorScheme.onSurfaceVariant,
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
                                style: Theme.of(context).textTheme.bodyMedium
                                    ?.copyWith(
                                      color: Theme.of(
                                        context,
                                      ).colorScheme.onSurfaceVariant,
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
