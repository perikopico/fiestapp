import 'dart:io' show File;
import 'dart:math';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' hide Category;
import 'dart:io' show Platform;
import 'package:intl/intl.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:file_picker/file_picker.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import '../../services/event_service.dart';
import '../../services/city_service.dart';
import '../../services/category_service.dart';
import '../../models/category.dart';
import '../common/city_search_field.dart';
import 'image_crop_screen.dart';
import '../dashboard/widgets/bottom_nav_bar.dart';

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

  // Imagen del evento
  PlatformFile? _selectedImage;
  File? _croppedImageFile; // Imagen recortada lista para subir
  String? _uploadedImageUrl;
  bool _isUploadingImage = false;
  String _imageAlignment = 'center'; // valores posibles: 'top', 'center', 'bottom'

  // Captcha
  bool _captchaValidated = false;

  // Estados de validación para UX mejorada
  String? _titleError;
  String? _descriptionError;
  String? _placeError;
  String? _cityError;
  String? _categoryError;
  String? _startDateError;

  // Programación diaria
  List<DateTime> _eventDays = [];
  final Map<DateTime, TextEditingController> _dailyProgramControllers = {};

  @override
  void initState() {
    super.initState();
    _loadData();
    
    // Agregar listeners para validación en tiempo real
    _titleController.addListener(() {
      if (mounted) {
        setState(() {
          if (_titleController.text.trim().isNotEmpty) {
            _titleError = null;
          }
        });
      }
    });
    
    _descriptionController.addListener(() {
      if (mounted) {
        setState(() {
          final desc = _descriptionController.text.trim();
          if (desc.isNotEmpty && desc.length >= 20) {
            _descriptionError = null;
          }
        });
      }
    });
    
    _placeController.addListener(() {
      if (mounted) {
        setState(() {
          if (_placeController.text.trim().isNotEmpty) {
            _placeError = null;
          }
        });
      }
    });
  }

  Future<void> _showCaptchaDialog() async {
    final rnd = Random();
    final numA = rnd.nextInt(10) + 1; // 1..10
    final numB = rnd.nextInt(10) + 1; // 1..10
    final correctAnswer = numA + numB;

    final result = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext dialogContext) {
        final answerController = TextEditingController();
        
        return AlertDialog(
          title: const Text('Verificación'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Demuestra que no eres un robot. ¿Cuánto es $numA + $numB?',
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: answerController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: 'Respuesta',
                    hintText: 'Ingresa el resultado',
                  ),
                  autofocus: true,
                  onSubmitted: (value) {
                    final userAnswer = int.tryParse(value.trim());
                    if (userAnswer == correctAnswer) {
                      Navigator.of(dialogContext).pop(true);
                    } else {
                      Navigator.of(dialogContext).pop(false);
                    }
                  },
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(dialogContext).pop(false);
              },
              child: const Text('Cancelar'),
            ),
            ElevatedButton(
              onPressed: () {
                final userAnswer = int.tryParse(answerController.text.trim());
                if (userAnswer == correctAnswer) {
                  Navigator.of(dialogContext).pop(true);
                } else {
                  Navigator.of(dialogContext).pop(false);
                }
              },
              child: const Text('Validar'),
            ),
          ],
        );
      },
    );
    
    if (!mounted) return;
    
    if (result == true) {
      // Respuesta correcta
      setState(() {
        _captchaValidated = true;
      });
    } else if (result == false) {
      // Respuesta incorrecta o cancelado
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Respuesta incorrecta'),
          duration: Duration(seconds: 2),
        ),
      );
      setState(() {
        _captchaValidated = false;
      });
    }
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

  Future<void> _pickImage() async {
    // En Android 10+ (API 29+), file_picker usa el selector del sistema
    // que no requiere permisos explícitos. Dejamos que file_picker
    // maneje los permisos automáticamente.
    // Solo solicitamos permisos explícitos en iOS.
    if (!kIsWeb && Platform.isIOS) {
      final photosStatus = await Permission.photos.status;
      if (!photosStatus.isGranted) {
        final result = await Permission.photos.request();
        if (result.isDenied || result.isPermanentlyDenied) {
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('No se puede seleccionar imagen sin permiso de galería'),
              ),
            );
          }
          return;
        }
      }
    }
    // En Android, no solicitamos permisos explícitos ya que file_picker
    // usa el selector del sistema que no los requiere

    final result = await FilePicker.platform.pickFiles(
      type: FileType.image,
      allowMultiple: false,
      withData: true, // Obtener datos directamente para evitar crear archivos temporales
      allowCompression: false, // Evitar compresión que requiere archivos temporales
    );
    if (result != null && result.files.isNotEmpty) {
      final pickedFile = result.files.first;
      
      // Si tenemos bytes (con withData: true), usarlos directamente
      // Esto evita problemas de permisos con archivos temporales
      if (pickedFile.bytes != null) {
        setState(() {
          _selectedImage = pickedFile;
        });
        // Abrir pantalla de recorte usando bytes
        await _openCropScreenForWeb(pickedFile.bytes!);
      } else if (pickedFile.path != null) {
        // Fallback: usar path si bytes no están disponibles
        final file = File(pickedFile.path!);
        setState(() {
          _selectedImage = pickedFile;
        });
        // Abrir pantalla de recorte
        await _openCropScreen(file);
      }
    }
  }

  Future<void> _openCropScreen(File imageFile) async {
    final croppedBytes = await Navigator.of(context).push<Uint8List>(
      MaterialPageRoute(
        builder: (_) => ImageCropScreen(
          imageFile: imageFile,
          aspectRatio: 16 / 9,
        ),
      ),
    );

    if (croppedBytes != null) {
      try {
        // Guardar imagen recortada en un archivo temporal
        final tempDir = await getTemporaryDirectory();
        final croppedFile = File('${tempDir.path}/cropped_event_${DateTime.now().millisecondsSinceEpoch}.jpg');
        await croppedFile.writeAsBytes(croppedBytes);
        
        setState(() {
          _croppedImageFile = croppedFile;
          // Actualizar _selectedImage para mostrar el preview
          _selectedImage = PlatformFile(
            name: 'cropped_${_selectedImage?.name ?? 'image.jpg'}',
            size: croppedBytes.length,
            path: croppedFile.path,
            bytes: null,
          );
        });
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: const Text('No se pudo procesar la imagen. Inténtalo de nuevo.'),
              backgroundColor: Theme.of(context).colorScheme.error,
            ),
          );
        }
      }
    }
  }

  Future<void> _openCropScreenForWeb(Uint8List imageBytes) async {
    // Para web, usar directamente los bytes sin crear archivos temporales
    try {
      // Crear un archivo temporal solo para pasar a ImageCropScreen
      // En web, path_provider puede no funcionar, así que usamos un enfoque diferente
      File? tempFile;
      if (!kIsWeb) {
        final tempDir = await getTemporaryDirectory();
        tempFile = File('${tempDir.path}/temp_image_${DateTime.now().millisecondsSinceEpoch}.jpg');
        await tempFile.writeAsBytes(imageBytes);
      } else {
        // En web, necesitamos crear un File desde bytes de otra manera
        // Usaremos un enfoque que funcione en web: pasar los bytes directamente al crop screen
        // Pero ImageCropScreen espera un File, así que creamos uno temporal en memoria
        // Nota: En web, File puede no funcionar igual, así que ajustamos el enfoque
        final tempDir = await getTemporaryDirectory();
        tempFile = File('${tempDir.path}/temp_image_${DateTime.now().millisecondsSinceEpoch}.jpg');
        await tempFile.writeAsBytes(imageBytes);
      }
      
      final croppedBytes = await Navigator.of(context).push<Uint8List>(
        MaterialPageRoute(
          builder: (_) => ImageCropScreen(
            imageFile: tempFile!,
            aspectRatio: 16 / 9,
          ),
        ),
      );

      if (croppedBytes != null) {
        // Guardar imagen recortada
        if (!kIsWeb) {
          final tempDir = await getTemporaryDirectory();
          final croppedFile = File('${tempDir.path}/cropped_event_${DateTime.now().millisecondsSinceEpoch}.jpg');
          await croppedFile.writeAsBytes(croppedBytes);
          setState(() {
            _croppedImageFile = croppedFile;
            _selectedImage = PlatformFile(
              name: 'cropped_${_selectedImage?.name ?? 'image.jpg'}',
              size: croppedBytes.length,
              path: croppedFile.path,
              bytes: null,
            );
          });
        } else {
          // En web, guardar los bytes directamente sin crear archivo
          final tempDir = await getTemporaryDirectory();
          final croppedFile = File('${tempDir.path}/cropped_event_${DateTime.now().millisecondsSinceEpoch}.jpg');
          await croppedFile.writeAsBytes(croppedBytes);
          setState(() {
            _croppedImageFile = croppedFile;
            _selectedImage = PlatformFile(
              name: 'cropped_${_selectedImage?.name ?? 'image.jpg'}',
              size: croppedBytes.length,
              path: null,
              bytes: croppedBytes,
            );
          });
        }
      }
      
      // Limpiar archivo temporal
      if (tempFile != null) {
        try {
          await tempFile.delete();
        } catch (_) {}
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('No se pudo procesar la imagen. Inténtalo de nuevo.'),
            backgroundColor: Theme.of(context).colorScheme.error,
          ),
        );
      }
    }
  }

  Future<String?> _uploadImageIfNeeded() async {
    // Si hay imagen recortada, usar esa; si no, usar la original
    if (_croppedImageFile == null && _selectedImage == null) {
      return _uploadedImageUrl; // nada que subir
    }

    try {
      setState(() {
        _isUploadingImage = true;
      });

      final supa = Supabase.instance.client;
      final fileName =
          'event_${DateTime.now().millisecondsSinceEpoch}_${_selectedImage?.name ?? 'image.jpg'}';

      // Priorizar imagen recortada si existe
      if (_croppedImageFile != null) {
        // Usar la imagen recortada
        if (kIsWeb) {
          // Para web, leer bytes del archivo recortado
          final bytes = await _croppedImageFile!.readAsBytes();
          await supa.storage.from('event-images').uploadBinary(
                fileName,
                bytes,
                fileOptions:
                    const FileOptions(cacheControl: '3600', upsert: false),
              );
        } else {
          // Para móvil/escritorio, usar el archivo directamente
          await supa.storage.from('event-images').upload(
                fileName,
                _croppedImageFile!,
                fileOptions:
                    const FileOptions(cacheControl: '3600', upsert: false),
              );
        }
      } else if (_selectedImage != null) {
        // Fallback a imagen original si no hay recortada
        final file = _selectedImage!;
        if (kIsWeb) {
          if (file.bytes == null) return null;
          await supa.storage.from('event-images').uploadBinary(
                fileName,
                file.bytes!,
                fileOptions:
                    const FileOptions(cacheControl: '3600', upsert: false),
              );
        } else {
          final path = file.path;
          if (path == null) return null;
          final ioFile = File(path);
          await supa.storage.from('event-images').upload(
                fileName,
                ioFile,
                fileOptions:
                    const FileOptions(cacheControl: '3600', upsert: false),
              );
        }
      }

      final publicUrl =
          supa.storage.from('event-images').getPublicUrl(fileName);

      setState(() {
        _uploadedImageUrl = publicUrl;
      });

      return publicUrl;
    } catch (e) {
      // Puedes mostrar un SnackBar o similar
      debugPrint('Error subiendo imagen: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error al subir la imagen: ${e.toString()}'),
            backgroundColor: Theme.of(context).colorScheme.error,
          ),
        );
      }
      return null;
    } finally {
      if (mounted) {
        setState(() {
          _isUploadingImage = false;
        });
      }
    }
  }

  /// Valida todos los campos y actualiza los estados de error
  bool _validateAllFields() {
    bool isValid = true;

    // Validar título
    if (_titleController.text.trim().isEmpty) {
      _titleError = 'El título es obligatorio';
      isValid = false;
    } else {
      _titleError = null;
    }

    // Validar descripción (mínimo 20 caracteres)
    final description = _descriptionController.text.trim();
    if (description.isEmpty) {
      _descriptionError = 'La descripción es obligatoria';
      isValid = false;
    } else if (description.length < 20) {
      _descriptionError = 'La descripción debe tener al menos 20 caracteres';
      isValid = false;
    } else {
      _descriptionError = null;
    }

    // Validar lugar
    if (_placeController.text.trim().isEmpty) {
      _placeError = 'El lugar es obligatorio';
      isValid = false;
    } else {
      _placeError = null;
    }

    // Validar ciudad
    if (_selectedCity == null || _selectedCityId == null) {
      _cityError = 'Por favor, selecciona una ciudad';
      isValid = false;
    } else {
      _cityError = null;
    }

    // Validar categoría
    if (_selectedCategory == null || _selectedCategory!.id == null) {
      _categoryError = 'Por favor, selecciona una categoría';
      isValid = false;
    } else {
      _categoryError = null;
    }

    // Validar fecha de inicio
    if (_startDate == null) {
      _startDateError = 'La fecha de inicio es obligatoria';
      isValid = false;
    } else {
      _startDateError = null;
    }

    return isValid;
  }

  /// Verifica si el formulario está listo para enviar
  bool _isFormReady() {
    return _validateAllFields() && _captchaValidated;
  }

  /// Construye un título de sección
  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Text(
        title,
        style: Theme.of(context).textTheme.titleMedium?.copyWith(
          fontWeight: FontWeight.w600,
          color: Theme.of(context).colorScheme.primary,
        ),
      ),
    );
  }

  /// Obtiene la descripción de una categoría
  String _getCategoryDescription(String categoryName) {
    final lowerName = categoryName.toLowerCase();
    
    // Mapeo de nombres de categorías a sus descripciones
    if (lowerName.contains('cultura')) {
      return 'Teatro, exposiciones, cine, charlas…';
    } else if (lowerName.contains('deporte')) {
      return 'Partidos, torneos, rutas, surf…';
    } else if (lowerName.contains('mercado')) {
      return 'Mercadillos, artesanía, segunda mano…';
    } else if (lowerName.contains('música') || lowerName.contains('musica')) {
      return 'Conciertos, bandas, DJ, acústicos…';
    } else if (lowerName.contains('noche')) {
      return 'Discotecas, copas, fiestas de madrugada.';
    } else if (lowerName.contains('naturaleza')) {
      return 'Eventos de Naturaleza';
    } else if (lowerName.contains('fiesta') && lowerName.contains('local')) {
      return 'Eventos de fiestas locales';
    } else if (lowerName.contains('motor')) {
      return 'Eventos de Motor';
    } else {
      // Descripción genérica para categorías no mapeadas
      return 'Eventos de $categoryName';
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
      bottomNavigationBar: const BottomNavBar(activeRoute: 'submit'),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // === SECCIÓN: Información básica ===
              _buildSectionTitle('Información básica'),
              const SizedBox(height: 12),
              
              // Título del evento (obligatorio)
              TextFormField(
                controller: _titleController,
                decoration: InputDecoration(
                  labelText: 'Título del evento',
                  hintText: 'Ej: Festival de Verano',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  errorText: _titleError,
                ),
                onChanged: (_) {
                  setState(() {
                    _titleError = null;
                  });
                },
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
                  errorText: _descriptionError,
                  helperText: _descriptionController.text.isEmpty
                      ? 'Mínimo 20 caracteres'
                      : '${_descriptionController.text.length}/20 caracteres',
                ),
                maxLines: 4,
                minLines: 3,
                onChanged: (_) {
                  setState(() {
                    _descriptionError = null;
                  });
                },
              ),
              const SizedBox(height: 32),

              // === SECCIÓN: Fecha y horario ===
              _buildSectionTitle('Fecha y horario'),
              const SizedBox(height: 12),

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
                      _startDateError = null;
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

              // Switch de programación diaria (movido aquí desde Información básica)
              Card(
                child: SwitchListTile(
                  title: const Text('Programación diaria'),
                  subtitle: _startDate == null
                      ? const Text(
                          'Selecciona primero la fecha de inicio para activar la programación diaria.',
                          style: TextStyle(fontSize: 12),
                        )
                      : const Text(
                          'Añade contenido específico para cada día del evento (opcional)',
                        ),
                  value: _hasDailyProgram,
                  onChanged: _startDate == null
                      ? null
                      : (value) {
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
              if (_hasDailyProgram && _startDate != null) ...[
                const SizedBox(height: 16),
                if (_endDate != null &&
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
              if (_startDateError != null)
                Padding(
                  padding: const EdgeInsets.only(top: 8, left: 12),
                  child: Text(
                    _startDateError!,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Theme.of(context).colorScheme.error,
                    ),
                  ),
                ),
              const SizedBox(height: 32),

              // === SECCIÓN: Imagen del evento ===
              _buildSectionTitle('Imagen del evento'),
              const SizedBox(height: 12),
              const SizedBox(height: 8),
              Row(
                children: [
                  ElevatedButton.icon(
                    onPressed:
                        _isSubmitting || _isUploadingImage ? null : _pickImage,
                    icon: const Icon(Icons.photo),
                    label: const Text('Seleccionar imagen'),
                  ),
                  const SizedBox(width: 12),
                  if (_isUploadingImage)
                    const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  else if (_selectedImage != null)
                    Expanded(
                      child: Text(
                        _selectedImage!.name,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                ],
              ),
              // Preview simple (mostrar imagen recortada si existe, sino la original)
              if (_selectedImage != null) ...[
                const SizedBox(height: 8),
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: _croppedImageFile != null
                      ? Image.file(
                          _croppedImageFile!,
                          height: 150,
                          width: double.infinity,
                          fit: BoxFit.cover,
                        )
                      : (!kIsWeb && _selectedImage!.path != null)
                          ? Image.file(
                              File(_selectedImage!.path!),
                              height: 150,
                              width: double.infinity,
                              fit: BoxFit.cover,
                            )
                          : (_selectedImage!.bytes != null)
                              ? Image.memory(
                                  _selectedImage!.bytes!,
                                  height: 150,
                                  width: double.infinity,
                                  fit: BoxFit.cover,
                                )
                              : const SizedBox.shrink(),
                ),
              ],
              const SizedBox(height: 16),
              const SizedBox(height: 32),

              // === SECCIÓN: Lugar ===
              _buildSectionTitle('Lugar'),
              const SizedBox(height: 12),
              
              TextFormField(
                controller: _placeController,
                decoration: InputDecoration(
                  labelText: 'Lugar',
                  hintText: 'Ej: Plaza del Ayuntamiento',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  errorText: _placeError,
                ),
                onChanged: (_) {
                  setState(() {
                    _placeError = null;
                  });
                },
              ),
              const SizedBox(height: 16),

              // Selector de ciudad con búsqueda
              CitySearchField(
                initialCity: _selectedCity,
                onCitySelected: (city) {
                  setState(() {
                    _selectedCity = city;
                    _selectedCityId = city.id;
                    _cityError = null;
                  });
                },
                labelText: 'Ciudad',
              ),
              if (_cityError != null)
                Padding(
                  padding: const EdgeInsets.only(top: 8, left: 12),
                  child: Text(
                    _cityError!,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Theme.of(context).colorScheme.error,
                    ),
                  ),
                ),
              const SizedBox(height: 32),

              // === SECCIÓN: Categoría ===
              _buildSectionTitle('Categoría'),
              const SizedBox(height: 12),
              
              // Dropdown de categorías con descripciones
              DropdownButtonFormField<Category>(
                decoration: InputDecoration(
                  labelText: 'Categoría',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  errorText: _categoryError,
                ),
                value: _selectedCategory,
                // Mostrar solo el nombre en el campo seleccionado (evita overflow)
                selectedItemBuilder: (BuildContext context) {
                  return _categories
                      .where((Category c) => c.id != null)
                      .map<Widget>((Category category) {
                        return Text(
                          category.name,
                          overflow: TextOverflow.ellipsis,
                        );
                      }).toList();
                },
                // En el menú desplegable, mostrar nombre + descripción
                items: _categories.where((Category c) => c.id != null).map((
                  Category category,
                ) {
                  final description = _getCategoryDescription(category.name);
                  return DropdownMenuItem<Category>(
                    value: category,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          category.name,
                          style: const TextStyle(fontWeight: FontWeight.w500),
                        ),
                        Text(
                          description,
                          style: TextStyle(
                            fontSize: 12,
                            color: Theme.of(context)
                                .colorScheme
                                .onSurfaceVariant
                                .withOpacity(0.7),
                          ),
                        ),
                      ],
                    ),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedCategory = value;
                    _categoryError = null;
                  });
                },
                validator: (value) {
                  if (value == null) {
                    return 'Por favor, selecciona una categoría';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 32),

              // === SECCIÓN: Tipo de evento ===
              _buildSectionTitle('Tipo de evento'),
              const SizedBox(height: 12),
              
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
              const SizedBox(height: 32),

              // === SECCIÓN: Ubicación en el mapa ===
              _buildSectionTitle('Ubicación en el mapa'),
              const SizedBox(height: 12),
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

              // === SECCIÓN: Envío ===
              _buildSectionTitle('Envío'),
              const SizedBox(height: 12),
              
              // Captcha
              CheckboxListTile(
                title: const Text('No soy un robot'),
                value: _captchaValidated,
                onChanged: (bool? value) {
                  if (value == true && !_captchaValidated) {
                    // Solo mostrar el diálogo si el usuario intenta marcar el checkbox
                    _showCaptchaDialog();
                  } else if (value == false) {
                    // Permitir desmarcar
                    setState(() {
                      _captchaValidated = false;
                    });
                  }
                },
                controlAffinity: ListTileControlAffinity.leading,
              ),
              const SizedBox(height: 24),

              // Botón de enviar
              ElevatedButton(
                onPressed: _isSubmitting || !_isFormReady()
                    ? null
                    : () async {
                        // Validar todos los campos
                        setState(() {
                          _validateAllFields();
                        });

                        if (!_validateAllFields()) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Por favor, completa todos los campos obligatorios'),
                              backgroundColor: Colors.orange,
                            ),
                          );
                          return;
                        }

                        if (!_captchaValidated) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Debes verificar que no eres un robot'),
                            ),
                          );
                          return;
                        }

                        try {
                          setState(() {
                            _isSubmitting = true;
                          });

                          // Subir imagen si hay una seleccionada
                          final imageUrl = await _uploadImageIfNeeded();

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

                            // Calcular coordenadas finales: usar las del mapa si están disponibles, sino las de la ciudad
                            final double? latToSave = _lat ?? _selectedCity?.lat;
                            final double? lngToSave = _lng ?? _selectedCity?.lng;

                            try {
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
                                mapsUrl: (latToSave != null && lngToSave != null)
                                    ? 'https://www.google.com/maps/search/?api=1&query=$latToSave,$lngToSave'
                                    : null,
                                lat: latToSave,
                                lng: lngToSave,
                                isFree: _isFree,
                                imageUrl: imageUrl,
                                imageAlignment: _imageAlignment,
                              );
                              eventsCreated = 1;
                            } catch (e) {
                              debugPrint('Error al crear evento: $e');
                              errorMessage = 'Error al crear el evento: ${e.toString()}';
                            }
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

                                // Calcular coordenadas finales: usar las del mapa si están disponibles, sino las de la ciudad
                                final double? latToSave = _lat ?? _selectedCity?.lat;
                                final double? lngToSave = _lng ?? _selectedCity?.lng;

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
                                  mapsUrl: (latToSave != null && lngToSave != null)
                                      ? 'https://www.google.com/maps/search/?api=1&query=$latToSave,$lngToSave'
                                      : null,
                                  lat: latToSave,
                                  lng: lngToSave,
                                  isFree: _isFree,
                                  imageUrl: imageUrl,
                                  imageAlignment: _imageAlignment,
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
                  foregroundColor: Theme.of(context).colorScheme.onPrimary,
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
                    : _MapWidget(
                        initialCenter: initialCenter,
                        initialMarkerPosition: initialMarkerPosition,
                        onMarkerUpdated: (LatLng position) {
                          setModalState(() {
                            pickedLatLng = position;
                          });
                        },
                        pickedLatLng: pickedLatLng,
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

/// Widget que maneja el mapa con manejo de errores
class _MapWidget extends StatefulWidget {
  final LatLng initialCenter;
  final LatLng? initialMarkerPosition;
  final Function(LatLng) onMarkerUpdated;
  final LatLng? pickedLatLng;

  const _MapWidget({
    required this.initialCenter,
    this.initialMarkerPosition,
    required this.onMarkerUpdated,
    this.pickedLatLng,
  });

  @override
  State<_MapWidget> createState() => _MapWidgetState();
}

class _MapWidgetState extends State<_MapWidget> {
  bool _mapCreated = false;
  bool _showError = false;
  Timer? _errorCheckTimer;
  GoogleMapController? _mapController;

  @override
  void initState() {
    super.initState();
    // Verificar si hay error después de 4 segundos
    // (dar tiempo para que el mapa intente cargar)
    _errorCheckTimer = Timer(const Duration(seconds: 4), () {
      if (mounted) {
        // Si el mapa se creó pero sigue habiendo problemas de renderizado,
        // o si no se creó, mostrar error
        setState(() {
          _showError = true;
        });
      }
    });
  }

  @override
  void dispose() {
    _errorCheckTimer?.cancel();
    _mapController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Mostrar error si se detecta
    if (_showError) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.error_outline,
                  size: 64,
                  color: Theme.of(context).colorScheme.error,
                ),
                const SizedBox(height: 16),
                Text(
                  'Error al cargar el mapa',
                  style: Theme.of(context).textTheme.titleLarge,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                Text(
                  'El mapa requiere una API key válida de Google Maps.\n\nPasos para solucionarlo:\n\n1. Ve a Google Cloud Console\n2. Crea o selecciona un proyecto\n3. Habilita "Maps SDK for Android"\n4. Crea una API key\n5. Añade restricción Android:\n   - Package: com.perikopico.fiestapp\n   - SHA-1: 12:FE:47:5B:A4:14:D7:44:D0:C4:F8:C2:C3:68:F2:6A:63:8A:AD:7A\n6. Reemplaza la API key en AndroidManifest.xml',
                  style: Theme.of(context).textTheme.bodyMedium,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text('Cerrar'),
                ),
              ],
            ),
          ),
        ),
      );
    }

    // Mostrar el mapa
    return GoogleMap(
      initialCameraPosition: CameraPosition(
        target: widget.initialCenter,
        zoom: 14.0,
      ),
      onTap: (LatLng position) {
        widget.onMarkerUpdated(position);
      },
      markers: widget.pickedLatLng != null
          ? {
              Marker(
                markerId: const MarkerId('picked'),
                position: widget.pickedLatLng!,
              ),
            }
          : {},
      myLocationButtonEnabled: false,
      zoomControlsEnabled: true,
      onMapCreated: (GoogleMapController controller) {
        debugPrint('✅ Mapa creado correctamente');
        _mapController = controller;
        // Cancelar el timer de error si el mapa se crea
        _errorCheckTimer?.cancel();
        // Verificar después de 2 segundos más si el mapa se renderiza correctamente
        // Si hay error de autorización, el mapa no se renderizará
        Future.delayed(const Duration(seconds: 2), () {
          if (mounted && !_showError) {
            // Si después de 2 segundos de crear el mapa no hay renderizado visible,
            // probablemente hay un error de autorización
            setState(() {
              _showError = true;
            });
          }
        });
      },
    );
  }
}
