import 'dart:io' show File;
import 'dart:math';
import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' hide Category;
import 'dart:io' show Platform;
import 'package:intl/intl.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:file_picker/file_picker.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import '../../services/event_service.dart';
import '../../services/city_service.dart';
import '../../services/category_service.dart';
import '../../models/category.dart';
import '../../models/venue.dart';
import '../../models/event.dart';
import '../common/city_search_field.dart';
import '../common/venue_search_field.dart';
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
  Venue? _selectedVenue; // Lugar seleccionado (opcional)
  DateTime? _startDate;
  DateTime? _endDate;
  TimeOfDay? _selectedTime;
  String _price = 'Gratis'; // Precio del evento (ej: "Gratis", "18€", "Desde 10€")
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

    // Validar lugar - debe haber un lugar seleccionado o texto escrito
    if (_selectedVenue == null && _placeController.text.trim().isEmpty) {
      _placeError = 'Por favor, selecciona o escribe un lugar';
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
  /// Usa las descripciones finales de las categorías para guiar al usuario
  String _getCategoryDescription(String categoryName) {
    // Descripciones finales de las categorías
    final descriptions = {
      'Música': 'Conciertos, festivales, flamenco, sesiones DJ y vida nocturna.',
      'Gastronomía': 'Rutas de tapas, catas de vino, mostos, ventas y jornadas del atún.',
      'Deportes': 'Motor (Jerez), surf/kite (Tarifa), polo, hípica y competiciones.',
      'Arte y Cultura': 'Teatro, exposiciones, museos, cine y visitas históricas.',
      'Aire Libre': 'Senderismo, rutas en kayak, playas y naturaleza activa.',
      'Tradiciones': 'Carnaval, Semana Santa, Ferias, Zambombas y Romerías.',
      'Mercadillos': 'Artesanía, antigüedades, rastros y moda (no alimentación).',
      // Compatibilidad con variaciones de nombres
      'Mercados': 'Artesanía, antigüedades, rastros y moda (no alimentación).',
      'Cultura': 'Teatro, exposiciones, museos, cine y visitas históricas.',
      'Arte': 'Teatro, exposiciones, museos, cine y visitas históricas.',
      'Tradición': 'Carnaval, Semana Santa, Ferias, Zambombas y Romerías.',
    };
    
    // Buscar coincidencia exacta primero
    if (descriptions.containsKey(categoryName)) {
      return descriptions[categoryName]!;
    }
    
    // Buscar coincidencia parcial (case insensitive)
    final lowerName = categoryName.toLowerCase();
    for (final entry in descriptions.entries) {
      final entryLower = entry.key.toLowerCase();
      if (entryLower == lowerName ||
          lowerName.contains(entryLower) ||
          entryLower.contains(lowerName)) {
        return entry.value;
      }
    }
    
    // Fallback para búsquedas por palabras clave (compatibilidad con código antiguo)
    if (lowerName.contains('música') || lowerName.contains('musica') || lowerName.contains('music')) {
      return 'Conciertos, festivales, flamenco, sesiones DJ y vida nocturna.';
    } else if (lowerName.contains('gastronomía') || lowerName.contains('gastronomia') || lowerName.contains('gastronomy')) {
      return 'Rutas de tapas, catas de vino, mostos, ventas y jornadas del atún.';
    } else if (lowerName.contains('deporte') || lowerName.contains('deportes') || lowerName.contains('sport')) {
      return 'Motor (Jerez), surf/kite (Tarifa), polo, hípica y competiciones.';
    } else if (lowerName.contains('arte') || lowerName.contains('cultura') || lowerName.contains('culture')) {
      return 'Teatro, exposiciones, museos, cine y visitas históricas.';
    } else if (lowerName.contains('aire libre') || lowerName.contains('aire-libre') || lowerName.contains('naturaleza') || lowerName.contains('nature')) {
      return 'Senderismo, rutas en kayak, playas y naturaleza activa.';
    } else if (lowerName.contains('tradición') || lowerName.contains('tradiciones') || lowerName.contains('tradicion') || lowerName.contains('tradition')) {
      return 'Carnaval, Semana Santa, Ferias, Zambombas y Romerías.';
    } else if (lowerName.contains('mercadillo') || lowerName.contains('mercadillos') || lowerName.contains('mercado') || lowerName.contains('mercados') || lowerName.contains('market')) {
      return 'Artesanía, antigüedades, rastros y moda (no alimentación).';
    }
    
    // Descripción genérica para categorías no mapeadas
    return 'Eventos de $categoryName';
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
              
              // Campo de búsqueda de lugares con autocompletado
              if (_selectedCityId != null && _selectedCity != null)
                VenueSearchField(
                  initialVenue: _selectedVenue,
                  cityId: _selectedCityId,
                  cityName: _selectedCity!.name,
                  labelText: 'Lugar',
                  errorText: _placeError,
                  onVenueSelected: (venue) {
                    setState(() {
                      _selectedVenue = venue;
                      if (venue != null) {
                        // Si hay un lugar seleccionado, actualizar el controller con su nombre
                        _placeController.text = venue.name;
                        // Si el venue tiene coordenadas, actualizarlas también
                        if (venue.lat != null && venue.lng != null) {
                          _lat = venue.lat;
                          _lng = venue.lng;
                          debugPrint('📍 Coordenadas del lugar "${venue.name}": Lat: ${venue.lat}, Lng: ${venue.lng}');
                          debugPrint('   Dirección: ${venue.address ?? "No disponible"}');
                        } else {
                          debugPrint('⚠️ El lugar "${venue.name}" no tiene coordenadas. Debes marcarlo en el mapa.');
                        }
                      } else {
                        // Si se deselecciona el venue, limpiar coordenadas también
                        _lat = null;
                        _lng = null;
                      }
                      _placeError = null;
                    });
                  },
                )
              else
                // Si no hay ciudad seleccionada, mostrar campo de texto normal
                TextFormField(
                  controller: _placeController,
                  decoration: InputDecoration(
                    labelText: 'Lugar',
                    hintText: 'Primero selecciona una ciudad',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    errorText: _placeError,
                    enabled: false,
                  ),
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
              
              // Campo de precio
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Precio',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 8),
                      TextField(
                        decoration: InputDecoration(
                          hintText: 'Ej: Gratis, 18€, Desde 10€, De pago...',
                          border: const OutlineInputBorder(),
                          helperText: 'Ingresa el precio del evento. Usa "Gratis" si no tiene costo.',
                        ),
                        controller: TextEditingController(text: _price)
                          ..selection = TextSelection.collapsed(offset: _price.length),
                        onChanged: (value) {
                          setState(() {
                            _price = value.trim();
                          });
                        },
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 32),

              // === SECCIÓN: Ubicación en el mapa ===
              _buildSectionTitle('Ubicación en el mapa'),
              const SizedBox(height: 12),
              
              // Preview del mapa si hay coordenadas
              if (_lat != null && _lng != null) ...[
                Container(
                  height: 180,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: Theme.of(context).colorScheme.outline.withOpacity(0.2),
                    ),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: GoogleMap(
                      initialCameraPosition: CameraPosition(
                        target: LatLng(_lat!, _lng!),
                        zoom: 15.0,
                      ),
                      markers: {
                        Marker(
                          markerId: const MarkerId('selected_location'),
                          position: LatLng(_lat!, _lng!),
                          infoWindow: InfoWindow(
                            title: _selectedVenue?.name ?? 
                                (_placeController.text.trim().isNotEmpty
                                    ? _placeController.text.trim()
                                    : 'Ubicación seleccionada'),
                          ),
                        ),
                      },
                      zoomControlsEnabled: false,
                      myLocationButtonEnabled: false,
                      mapToolbarEnabled: false,
                      scrollGesturesEnabled: false,
                      zoomGesturesEnabled: false,
                      tiltGesturesEnabled: false,
                      rotateGesturesEnabled: false,
                      onMapCreated: (GoogleMapController controller) {
                        debugPrint('✅ Preview del mapa creado');
                      },
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Icon(
                      Icons.check_circle,
                      size: 16,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        _selectedVenue != null
                            ? 'Ubicación del lugar "${_selectedVenue!.name}" marcada en el mapa'
                            : 'Ubicación marcada en el mapa',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Theme.of(context).colorScheme.primary,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
              ],
              
              OutlinedButton.icon(
                onPressed: _canOpenMapPicker() ? _openMapPicker : null,
                icon: Icon(_lat != null && _lng != null ? Icons.edit_location : Icons.map),
                label: Text(_lat != null && _lng != null ? 'Cambiar ubicación' : 'Elegir en el mapa'),
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
              ),
              if (!_canOpenMapPicker())
                Padding(
                  padding: const EdgeInsets.only(top: 8, left: 12),
                  child: Text(
                    'Primero debes seleccionar una ciudad y un lugar',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
                  ),
                ),
              if (_lat == null || _lng == null) ...[
                const SizedBox(height: 8),
                Row(
                  children: [
                    Icon(
                      Icons.info_outline,
                      size: 16,
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'Ninguna ubicación seleccionada',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Theme.of(context).colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
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

                            // VALIDACIÓN DE DUPLICADOS: Verificar si hay eventos similares antes de crear
                            final placeName = _selectedVenue != null
                                ? _selectedVenue!.name
                                : (_placeController.text.trim().isEmpty
                                    ? _selectedCity!.name
                                    : _placeController.text);
                            
                            final tempEvent = Event(
                              id: 'temp-${DateTime.now().millisecondsSinceEpoch}', // ID temporal
                              title: _titleController.text.trim(),
                              startsAt: startsAt,
                              cityId: _selectedCityId,
                              categoryId: _selectedCategory!.id,
                              place: placeName,
                              description: description,
                              cityName: _selectedCity!.name,
                              categoryName: _selectedCategory?.name,
                            );
                            
                            final duplicateEvents = await _eventService.getPotentialDuplicateEvents(tempEvent);
                            
                            // Si hay duplicados, mostrar diálogo
                            if (duplicateEvents.isNotEmpty && mounted) {
                              final shouldContinue = await showDialog<bool>(
                                context: context,
                                builder: (context) => AlertDialog(
                                  title: const Text('Eventos similares encontrados'),
                                  content: SizedBox(
                                    width: double.maxFinite,
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        const Text(
                                          'Se encontraron eventos similares en esta ciudad. ¿Quieres crear este evento de todas formas?',
                                          style: TextStyle(fontSize: 14),
                                        ),
                                        const SizedBox(height: 16),
                                        Flexible(
                                          child: ListView.builder(
                                            shrinkWrap: true,
                                            itemCount: duplicateEvents.length,
                                            itemBuilder: (context, index) {
                                              final duplicate = duplicateEvents[index];
                                              final dateFormat = DateFormat('d MMM yyyy, HH:mm');
                                              return Card(
                                                margin: const EdgeInsets.only(bottom: 8),
                                                child: ListTile(
                                                  leading: Icon(
                                                    duplicate.status == 'published' 
                                                        ? Icons.check_circle 
                                                        : duplicate.status == 'rejected'
                                                            ? Icons.cancel
                                                            : Icons.pending,
                                                    color: duplicate.status == 'published' 
                                                        ? Colors.green 
                                                        : duplicate.status == 'rejected'
                                                            ? Colors.red
                                                            : Colors.orange,
                                                  ),
                                                  title: Text(duplicate.title),
                                                  subtitle: Column(
                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                    children: [
                                                      Text(
                                                        dateFormat.format(duplicate.startsAt),
                                                        style: const TextStyle(fontSize: 12),
                                                      ),
                                                      if (duplicate.place != null)
                                                        Text(
                                                          duplicate.place!,
                                                          style: const TextStyle(fontSize: 11),
                                                        ),
                                                      const SizedBox(height: 4),
                                                      Chip(
                                                        label: Text(
                                                          duplicate.status == 'published' 
                                                              ? 'Publicado' 
                                                              : duplicate.status == 'rejected'
                                                                  ? 'Rechazado'
                                                                  : 'Pendiente',
                                                          style: const TextStyle(fontSize: 11),
                                                        ),
                                                        padding: EdgeInsets.zero,
                                                        visualDensity: VisualDensity.compact,
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
                                  ),
                                  actions: [
                                    TextButton(
                                      onPressed: () => Navigator.of(context).pop(false),
                                      child: const Text('Cancelar'),
                                    ),
                                    TextButton(
                                      onPressed: () => Navigator.of(context).pop(true),
                                      child: const Text('Crear de todas formas'),
                                    ),
                                  ],
                                ),
                              );
                              
                              if (shouldContinue == null || !shouldContinue) {
                                return; // El usuario canceló
                              }
                            }

                            try {
                              await _eventService.submitEvent(
                                title: _titleController.text,
                                town: _selectedCity!.name,
                                place: _selectedVenue != null
                                    ? _selectedVenue!.name
                                    : (_placeController.text.trim().isEmpty
                                        ? _selectedCity!.name
                                        : _placeController.text),
                                startsAt: startsAt,
                                cityId: _selectedCityId!,
                                categoryId: _selectedCategory!.id!,
                                description: description,
                                mapsUrl: (latToSave != null && lngToSave != null)
                                    ? 'https://www.google.com/maps/search/?api=1&query=$latToSave,$lngToSave'
                                    : null,
                                lat: latToSave,
                                lng: lngToSave,
                                price: _price.isNotEmpty ? _price : 'Gratis',
                                imageUrl: imageUrl,
                                imageAlignment: _imageAlignment,
                                venueId: _selectedVenue?.id, // Pasar venue_id si hay un lugar seleccionado
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

                            // VALIDACIÓN DE DUPLICADOS: Verificar una vez antes de crear múltiples eventos
                            final placeName = _selectedVenue != null
                                ? _selectedVenue!.name
                                : (_placeController.text.trim().isEmpty
                                    ? _selectedCity!.name
                                    : _placeController.text);
                            
                            final firstDayStartsAt = DateTime(
                              startDate.year,
                              startDate.month,
                              startDate.day,
                              _selectedTime?.hour ?? 0,
                              _selectedTime?.minute ?? 0,
                            );
                            
                            final firstDayDescription = _buildDescriptionForDay(startDate);
                            
                            final tempEvent = Event(
                              id: 'temp-${DateTime.now().millisecondsSinceEpoch}',
                              title: _titleController.text.trim(),
                              startsAt: firstDayStartsAt,
                              cityId: _selectedCityId,
                              categoryId: _selectedCategory!.id,
                              place: placeName,
                              description: firstDayDescription,
                              cityName: _selectedCity!.name,
                              categoryName: _selectedCategory?.name,
                            );
                            
                            final duplicateEvents = await _eventService.getPotentialDuplicateEvents(tempEvent);
                            
                            // Si hay duplicados, mostrar diálogo
                            if (duplicateEvents.isNotEmpty && mounted) {
                              final daysCount = endDate.difference(startDate).inDays + 1;
                              final shouldContinue = await showDialog<bool>(
                                context: context,
                                builder: (context) => AlertDialog(
                                  title: const Text('Eventos similares encontrados'),
                                  content: SizedBox(
                                    width: double.maxFinite,
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'Se encontraron ${duplicateEvents.length} evento(s) similar(es) en esta ciudad. ¿Quieres crear $daysCount evento(s) de todas formas?',
                                          style: const TextStyle(fontSize: 14),
                                        ),
                                        const SizedBox(height: 16),
                                        Flexible(
                                          child: ListView.builder(
                                            shrinkWrap: true,
                                            itemCount: duplicateEvents.length,
                                            itemBuilder: (context, index) {
                                              final duplicate = duplicateEvents[index];
                                              final dateFormat = DateFormat('d MMM yyyy, HH:mm');
                                              return Card(
                                                margin: const EdgeInsets.only(bottom: 8),
                                                child: ListTile(
                                                  leading: Icon(
                                                    duplicate.status == 'published' 
                                                        ? Icons.check_circle 
                                                        : duplicate.status == 'rejected'
                                                            ? Icons.cancel
                                                            : Icons.pending,
                                                    color: duplicate.status == 'published' 
                                                        ? Colors.green 
                                                        : duplicate.status == 'rejected'
                                                            ? Colors.red
                                                            : Colors.orange,
                                                  ),
                                                  title: Text(duplicate.title),
                                                  subtitle: Column(
                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                    children: [
                                                      Text(
                                                        dateFormat.format(duplicate.startsAt),
                                                        style: const TextStyle(fontSize: 12),
                                                      ),
                                                      if (duplicate.place != null)
                                                        Text(
                                                          duplicate.place!,
                                                          style: const TextStyle(fontSize: 11),
                                                        ),
                                                      const SizedBox(height: 4),
                                                      Chip(
                                                        label: Text(
                                                          duplicate.status == 'published' 
                                                              ? 'Publicado' 
                                                              : duplicate.status == 'rejected'
                                                                  ? 'Rechazado'
                                                                  : 'Pendiente',
                                                          style: const TextStyle(fontSize: 11),
                                                        ),
                                                        padding: EdgeInsets.zero,
                                                        visualDensity: VisualDensity.compact,
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
                                  ),
                                  actions: [
                                    TextButton(
                                      onPressed: () => Navigator.of(context).pop(false),
                                      child: const Text('Cancelar'),
                                    ),
                                    TextButton(
                                      onPressed: () => Navigator.of(context).pop(true),
                                      child: const Text('Crear de todas formas'),
                                    ),
                                  ],
                                ),
                              );
                              
                              if (shouldContinue == null || !shouldContinue) {
                                return; // El usuario canceló
                              }
                            }

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
                                  place: _selectedVenue != null
                                      ? _selectedVenue!.name
                                      : (_placeController.text.trim().isEmpty
                                          ? _selectedCity!.name
                                          : _placeController.text),
                                  startsAt: startsAt,
                                  cityId: _selectedCityId!,
                                  categoryId: _selectedCategory!.id!,
                                  description: description,
                                  mapsUrl: (latToSave != null && lngToSave != null)
                                      ? 'https://www.google.com/maps/search/?api=1&query=$latToSave,$lngToSave'
                                      : null,
                                  lat: latToSave,
                                  lng: lngToSave,
                                  price: _price.isNotEmpty ? _price : 'Gratis',
                                  imageUrl: imageUrl,
                                  imageAlignment: _imageAlignment,
                                  venueId: _selectedVenue?.id, // Pasar venue_id si hay un lugar seleccionado
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

  /// Verifica si se puede abrir el selector de mapa
  bool _canOpenMapPicker() {
    // Requiere ciudad y lugar (venue o texto del lugar)
    if (_selectedCity == null || _selectedCityId == null) {
      return false;
    }
    // Debe haber un lugar seleccionado (venue) o texto en el campo de lugar
    if (_selectedVenue == null && _placeController.text.trim().isEmpty) {
      return false;
    }
    return true;
  }

  /// Busca las coordenadas de un lugar usando geocoding
  Future<LatLng?> _geocodeLocation(String address) async {
    try {
      // Usar la API de Geocoding de Google Maps
      // Nota: En producción, deberías usar una API key de servidor para geocoding
      // Por ahora usamos la misma key, pero idealmente debería estar en el backend
      final apiKey = dotenv.env['GOOGLE_MAPS_API_KEY'];
      if (apiKey == null || apiKey.isEmpty) {
        debugPrint('❌ GOOGLE_MAPS_API_KEY no configurada en .env');
        return null;
      }
      final encodedAddress = Uri.encodeComponent(address);
      final url = 'https://maps.googleapis.com/maps/api/geocode/json?address=$encodedAddress&key=$apiKey';
      
      final response = await http.get(Uri.parse(url));
      
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['status'] == 'OK' && data['results'].isNotEmpty) {
          final location = data['results'][0]['geometry']['location'];
          return LatLng(
            location['lat'] as double,
            location['lng'] as double,
          );
        }
      }
      return null;
    } catch (e) {
      debugPrint('Error en geocoding: $e');
      return null;
    }
  }

  /// Abre el bottom sheet con el selector de mapa
  Future<void> _openMapPicker() async {
    // Mostrar diálogo de carga mientras se busca la ubicación
    if (!mounted) return;
    
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(
        child: Card(
          child: Padding(
            padding: EdgeInsets.all(24.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                CircularProgressIndicator(),
                SizedBox(height: 16),
                Text('Buscando ubicación...'),
              ],
            ),
          ),
        ),
      ),
    );
    
    // Buscar la ubicación del lugar/ciudad antes de abrir el mapa
    LatLng? initialLocation;
    
    // PRIORIDAD 1: Si ya hay coordenadas seleccionadas (_lat y _lng), usarlas directamente
    if (_lat != null && _lng != null) {
      initialLocation = LatLng(_lat!, _lng!);
      debugPrint('📍 Usando coordenadas ya seleccionadas: $_lat, $_lng');
    }
    // PRIORIDAD 2: Si hay un venue seleccionado con coordenadas, usarlas
    else if (_selectedVenue != null && _selectedVenue!.lat != null && _selectedVenue!.lng != null) {
      initialLocation = LatLng(_selectedVenue!.lat!, _selectedVenue!.lng!);
      debugPrint('📍 Usando coordenadas del venue: ${_selectedVenue!.name}');
    } 
    // PRIORIDAD 3: Si hay un venue pero sin coordenadas, buscar por nombre + ciudad
    else if (_selectedVenue != null) {
      final searchQuery = '${_selectedVenue!.name}, ${_selectedCity!.name}';
      debugPrint('🔍 Buscando coordenadas para venue: $searchQuery');
      initialLocation = await _geocodeLocation(searchQuery);
    }
    // PRIORIDAD 4: Si no hay venue pero hay texto en el campo de lugar, buscar por lugar + ciudad
    else if (_placeController.text.trim().isNotEmpty) {
      final searchQuery = '${_placeController.text.trim()}, ${_selectedCity!.name}';
      debugPrint('🔍 Buscando coordenadas para lugar: $searchQuery');
      initialLocation = await _geocodeLocation(searchQuery);
    }
    
    // PRIORIDAD 5: Si no se encontró el lugar, usar las coordenadas de la ciudad
    if (initialLocation == null && _selectedCity != null) {
      if (_selectedCity!.lat != null && _selectedCity!.lng != null) {
        initialLocation = LatLng(_selectedCity!.lat!, _selectedCity!.lng!);
        debugPrint('📍 Usando coordenadas de la ciudad: ${_selectedCity!.name}');
      } else {
        // Si la ciudad no tiene coordenadas, buscar por nombre
        debugPrint('🔍 Buscando coordenadas de la ciudad: ${_selectedCity!.name}');
        initialLocation = await _geocodeLocation(_selectedCity!.name);
      }
    }
    
    // PRIORIDAD 6: Si aún no hay ubicación, usar Barbate por defecto
    final finalLocation = initialLocation ?? const LatLng(36.1927, -5.9219);
    debugPrint('📍 Ubicación final para el mapa: ${finalLocation.latitude}, ${finalLocation.longitude}');
    
    // Cerrar el diálogo de carga
    if (mounted) {
      Navigator.of(context).pop();
    }
    
    if (!mounted) return;
    
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Theme.of(context).colorScheme.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => _buildMapBottomSheet(initialLocation: finalLocation),
    );
  }

  /// Construye el bottom sheet con el mapa interactivo
  Widget _buildMapBottomSheet({required LatLng initialLocation}) {
    // Determinar el centro inicial del mapa y la posición inicial del marcador
    LatLng initialCenter;
    LatLng? initialMarkerPosition;

    if (_lat != null && _lng != null) {
      // Si ya hay coordenadas seleccionadas, usar esas
      initialCenter = LatLng(_lat!, _lng!);
      initialMarkerPosition = initialCenter;
    } else {
      // Usar la ubicación encontrada por geocoding
      initialCenter = initialLocation;
      initialMarkerPosition = initialLocation;
    }

    return StatefulBuilder(
      builder: (context, setModalState) {
        // Estado local del marcador en el mapa
        // SIEMPRE inicializar con una posición (initialMarkerPosition o initialCenter)
        // Esto asegura que siempre haya un marcador visible
        LatLng currentMarkerPosition = initialMarkerPosition ?? initialCenter;

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
              // Instrucciones
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  children: [
                    Icon(
                      Icons.info_outline,
                      size: 20,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'Toca el mapa o arrastra el marcador rojo para seleccionar la ubicación',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Theme.of(context).colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ),
                  ],
                ),
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
                        initialMarkerPosition: currentMarkerPosition,
                        onMarkerUpdated: (LatLng position) {
                          debugPrint('📍 Marcador actualizado a: ${position.latitude}, ${position.longitude}');
                          setModalState(() {
                            currentMarkerPosition = position;
                          });
                        },
                        pickedLatLng: currentMarkerPosition,
                      ),
              ),
              // Mostrar coordenadas actuales
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Card(
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Row(
                      children: [
                        Icon(
                          Icons.location_on,
                          size: 20,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            'Lat: ${currentMarkerPosition.latitude.toStringAsFixed(6)}, '
                            'Lng: ${currentMarkerPosition.longitude.toStringAsFixed(6)}',
                            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              fontFamily: 'monospace',
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 8),
              // Botón de confirmar
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: ElevatedButton(
                  onPressed: () {
                    // Usar las coordenadas del marcador actual
                    setState(() {
                      _lat = currentMarkerPosition.latitude;
                      _lng = currentMarkerPosition.longitude;
                    });
                    debugPrint('✅ Ubicación confirmada: $_lat, $_lng');
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
  GoogleMapController? _mapController;

  @override
  void dispose() {
    _mapController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Asegurar que siempre haya un marcador visible
    // Si no hay pickedLatLng, usar initialCenter o initialMarkerPosition
    final markerPosition = widget.pickedLatLng ?? 
                          widget.initialMarkerPosition ?? 
                          widget.initialCenter;
    
    return GoogleMap(
      initialCameraPosition: CameraPosition(
        target: widget.initialCenter,
        zoom: 14.0,
      ),
      onTap: (LatLng position) {
        debugPrint('📍 Mapa tocado en: ${position.latitude}, ${position.longitude}');
        widget.onMarkerUpdated(position);
      },
      markers: {
        Marker(
          markerId: const MarkerId('picked'),
          position: markerPosition,
          draggable: true,
          icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
          onDragEnd: (LatLng newPosition) {
            debugPrint('📍 Marcador arrastrado a: ${newPosition.latitude}, ${newPosition.longitude}');
            widget.onMarkerUpdated(newPosition);
          },
          onDragStart: (LatLng position) {
            debugPrint('📍 Iniciando arrastre del marcador');
          },
        ),
      },
      myLocationButtonEnabled: false,
      zoomControlsEnabled: true,
      scrollGesturesEnabled: true,
      zoomGesturesEnabled: true,
      tiltGesturesEnabled: false,
      rotateGesturesEnabled: true,
      onMapCreated: (GoogleMapController controller) {
        debugPrint('✅ Mapa creado correctamente');
        _mapController = controller;
      },
      // Manejo de errores mejorado
      onCameraMoveStarted: () {
        debugPrint('📍 Usuario moviendo el mapa');
      },
      // Si hay error, se mostrará en los logs pero el mapa seguirá funcionando
    );
  }
}
