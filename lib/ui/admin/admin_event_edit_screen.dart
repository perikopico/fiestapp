// lib/ui/admin/admin_event_edit_screen.dart
import 'dart:io' show File, Directory, Platform;
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' hide Category;
import 'package:intl/intl.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:file_picker/file_picker.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import '../../models/event.dart';
import '../../models/category.dart';
import '../../services/event_service.dart';
import '../../services/city_service.dart' show City;
import '../../services/category_service.dart';
import '../../services/admin_moderation_service.dart';
import '../../services/sample_image_service.dart';
import '../common/city_search_field.dart';
import '../events/image_crop_screen.dart';
import '../events/wizard_steps/step5_image.dart'; // Para ImageSelectionOption y _SampleImagePickerDialog
import 'widgets/possible_duplicates_section.dart';
import 'package:http/http.dart' as http;
import 'dart:typed_data';

class AdminEventEditScreen extends StatefulWidget {
  final Event event;
  final bool isPublished;

  const AdminEventEditScreen({
    super.key,
    required this.event,
    this.isPublished = false,
  });

  @override
  State<AdminEventEditScreen> createState() => _AdminEventEditScreenState();
}

class _AdminEventEditScreenState extends State<AdminEventEditScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _placeController = TextEditingController();

  final EventService _eventService = EventService.instance;
  final CategoryService _categoryService = CategoryService();
  final AdminModerationService _adminService = AdminModerationService.instance;

  List<Category> _categories = [];
  bool _isLoadingData = true;
  bool _isSaving = false;

  City? _selectedCity;
  int? _selectedCityId;
  int? _initialCategoryId; // Guardar el ID inicial para buscar después de cargar
  Category? _selectedCategory;
  DateTime? _startDate;
  DateTime? _endDate;
  TimeOfDay? _selectedTime;
  String _price = 'Gratis'; // Precio del evento (ej: "Gratis", "18€", "Desde 10€")
  bool _hasDailyProgram = false;
  double? _lat;
  double? _lng;

  // Imagen del evento
  PlatformFile? _selectedImage;
  File? _croppedImageFile;
  String? _uploadedImageUrl;
  bool _isUploadingImage = false;
  String _imageAlignment = 'center';

  // Estados de validación
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
    _initializeFromEvent();
    _loadData();
  }

  void _initializeFromEvent() {
    final event = widget.event;
    
    _titleController.text = event.title;
    _descriptionController.text = event.description ?? '';
    _placeController.text = event.place ?? '';
    _selectedCityId = event.cityId;
    _initialCategoryId = event.categoryId; // Guardar el ID para buscar después
    _startDate = event.startsAt;
    _selectedTime = TimeOfDay.fromDateTime(event.startsAt);
    _price = event.price ?? 'Gratis';
    _imageAlignment = event.imageAlignment ?? 'center';
    _uploadedImageUrl = event.imageUrl;

    // Extraer coordenadas del mapsUrl si está disponible
    if (event.mapsUrl != null && event.mapsUrl!.isNotEmpty) {
      try {
        final uri = Uri.parse(event.mapsUrl!);
        final query = uri.queryParameters;
        if (query.containsKey('query')) {
          final coords = query['query']!.split(',');
          if (coords.length == 2) {
            _lat = double.tryParse(coords[0]);
            _lng = double.tryParse(coords[1]);
          }
        }
      } catch (e) {
        debugPrint('Error al parsear mapsUrl: $e');
      }
    }

    // Cargar ciudad si tenemos cityId
    if (event.cityId != null) {
      _loadCityById(event.cityId!);
    }
  }

  Future<void> _loadCityById(int cityId) async {
    try {
      final supa = Supabase.instance.client;
      final res = await supa
          .from('cities')
          .select('id, name, slug, province_id, lat, lng')
          .eq('id', cityId)
          .maybeSingle();

      if (res != null) {
        setState(() {
          _selectedCity = City.fromMap(res as Map<String, dynamic>);
        });
      }
    } catch (e) {
      debugPrint('Error al cargar ciudad: $e');
    }
  }

  Future<void> _loadData() async {
    try {
      final categories = await _categoryService.fetchAll();

      if (mounted) {
        setState(() {
          _categories = categories;
          // Buscar la categoría correcta de la lista cargada
          if (_initialCategoryId != null && categories.isNotEmpty) {
            try {
              _selectedCategory = categories.firstWhere(
                (c) => c.id == _initialCategoryId,
              );
            } catch (e) {
              // Si no se encuentra, usar la primera categoría con ID válido
              _selectedCategory = categories.firstWhere(
                (c) => c.id != null,
                orElse: () => categories.first,
              );
            }
          } else if (categories.isNotEmpty) {
            // Si no hay categoría inicial, usar la primera con ID válido
            _selectedCategory = categories.firstWhere(
              (c) => c.id != null,
              orElse: () => categories.first,
            );
          }
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
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _placeController.dispose();
    for (final controller in _dailyProgramControllers.values) {
      controller.dispose();
    }
    _dailyProgramControllers.clear();
    super.dispose();
  }

  void _updateEventDays() {
    for (final controller in _dailyProgramControllers.values) {
      controller.dispose();
    }
    _dailyProgramControllers.clear();
    _eventDays.clear();

    if (_startDate != null &&
        _endDate != null &&
        !_endDate!.isBefore(_startDate!)) {
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

    if (baseDescription.isEmpty) {
      return 'Programación:\n$dayProgram';
    }

    return '''$baseDescription



Programación:

$dayProgram''';
  }

  bool _validateAllFields() {
    bool isValid = true;

    if (_titleController.text.trim().isEmpty) {
      _titleError = 'El título es obligatorio';
      isValid = false;
    } else {
      _titleError = null;
    }

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

    if (_placeController.text.trim().isEmpty) {
      _placeError = 'El lugar es obligatorio';
      isValid = false;
    } else {
      _placeError = null;
    }

    if (_selectedCity == null || _selectedCityId == null) {
      _cityError = 'Por favor, selecciona una ciudad';
      isValid = false;
    } else {
      _cityError = null;
    }

    if (_selectedCategory == null || _selectedCategory!.id == null) {
      _categoryError = 'Por favor, selecciona una categoría';
      isValid = false;
    } else {
      _categoryError = null;
    }

    if (_startDate == null) {
      _startDateError = 'La fecha de inicio es obligatoria';
      isValid = false;
    } else {
      _startDateError = null;
    }

    return isValid;
  }

  Future<void> _pickImage() async {
    try {
      debugPrint('📸 Iniciando selección de imagen...');
      
      // Mostrar diálogo para elegir entre galería, cámara e imágenes de muestra
      if (!mounted) return;
      final ImageSelectionOption? option = await showDialog<ImageSelectionOption>(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Seleccionar imagen'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.photo_library),
                title: const Text('Galería'),
                onTap: () => Navigator.of(context).pop(ImageSelectionOption.gallery),
              ),
              ListTile(
                leading: const Icon(Icons.camera_alt),
                title: const Text('Cámara'),
                onTap: () => Navigator.of(context).pop(ImageSelectionOption.camera),
              ),
              ListTile(
                leading: const Icon(Icons.collections),
                title: const Text('Imágenes de muestra'),
                subtitle: Text(
                  _selectedCategory != null
                      ? 'Ver imágenes de ${_selectedCategory!.name}'
                      : 'Selecciona primero una categoría',
                ),
                enabled: _selectedCategory != null,
                onTap: _selectedCategory != null
                    ? () => Navigator.of(context).pop(ImageSelectionOption.sample)
                    : null,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancelar'),
            ),
          ],
        ),
      );

      if (option == null) {
        debugPrint('📸 Selección cancelada por el usuario');
        return;
      }

      // Si se selecciona imágenes de muestra, mostrar el selector
      if (option == ImageSelectionOption.sample) {
        await _pickSampleImage();
        return;
      }

      // Para galería y cámara, usar FilePicker (galería) o ImagePicker (cámara)
      if (option == ImageSelectionOption.gallery) {
        await _pickImageFromGallery();
      } else if (option == ImageSelectionOption.camera) {
        await _pickImageFromCamera();
      }
    } catch (e) {
      debugPrint('❌ Error al seleccionar imagen: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error al seleccionar imagen: ${e.toString()}'),
            backgroundColor: Theme.of(context).colorScheme.error,
          ),
        );
      }
    }
  }

  Future<void> _pickImageFromGallery() async {
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

    final result = await FilePicker.platform.pickFiles(
      type: FileType.image,
      allowMultiple: false,
      withData: true,
      allowCompression: false,
    );

    if (result != null && result.files.isNotEmpty) {
      final pickedFile = result.files.first;

      if (pickedFile.bytes != null) {
        setState(() {
          _selectedImage = pickedFile;
        });
        await _openCropScreenForWeb(pickedFile.bytes!);
      } else if (pickedFile.path != null) {
        final file = File(pickedFile.path!);
        setState(() {
          _selectedImage = pickedFile;
        });
        await _openCropScreen(file);
      }
    }
  }

  Future<void> _pickImageFromCamera() async {
    // Para cámara, usar FilePicker también (no hay ImagePicker disponible directamente aquí)
    // Pero mejor usar un FilePicker que permita cámara
    final result = await FilePicker.platform.pickFiles(
      type: FileType.image,
      allowMultiple: false,
      withData: true,
      allowCompression: false,
    );

    if (result != null && result.files.isNotEmpty) {
      final pickedFile = result.files.first;

      if (pickedFile.bytes != null) {
        setState(() {
          _selectedImage = pickedFile;
        });
        await _openCropScreenForWeb(pickedFile.bytes!);
      } else if (pickedFile.path != null) {
        final file = File(pickedFile.path!);
        setState(() {
          _selectedImage = pickedFile;
        });
        await _openCropScreen(file);
      }
    }
  }

  Future<void> _pickSampleImage() async {
    if (_selectedCategory == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Primero debes seleccionar una categoría'),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    try {
      setState(() {
        _isUploadingImage = true;
      });

      // Obtener las imágenes de muestra para la categoría seleccionada
      final sampleImages = await SampleImageService.instance.getSampleImagesForCategory(
        categorySlug: _selectedCategory!.slug,
        categoryId: _selectedCategory!.id,
      );

      if (!mounted) return;

      if (sampleImages.isEmpty) {
        setState(() {
          _isUploadingImage = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'No hay imágenes de muestra disponibles para ${_selectedCategory!.name}',
            ),
            backgroundColor: Colors.orange,
          ),
        );
        return;
      }

      // Mostrar diálogo para seleccionar una imagen
      final selectedImageUrl = await showDialog<String>(
        context: context,
        builder: (context) => _SampleImagePickerDialog(
          imageUrls: sampleImages,
          categoryName: _selectedCategory!.name ?? 'categoría',
        ),
      );

      if (selectedImageUrl != null && mounted) {
        // Descargar la imagen y guardarla como archivo local
        await _downloadAndSaveSampleImage(selectedImageUrl);
      }
    } catch (e, stackTrace) {
      debugPrint('❌ Error al obtener imágenes de muestra: $e');
      debugPrint('Stack trace: $stackTrace');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error al cargar imágenes de muestra: ${e.toString()}'),
            backgroundColor: Theme.of(context).colorScheme.error,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isUploadingImage = false;
        });
      }
    }
  }

  /// Extrae la extensión del archivo desde una URL
  String _getFileExtensionFromUrl(String url) {
    try {
      final uri = Uri.parse(url);
      final path = uri.path;
      if (path.isEmpty) return 'webp';
      
      final lastDot = path.lastIndexOf('.');
      if (lastDot == -1 || lastDot == path.length - 1) {
        return 'webp';
      }
      
      final extension = path.substring(lastDot + 1).toLowerCase();
      if (['jpg', 'jpeg', 'png', 'webp'].contains(extension)) {
        return extension;
      }
      return 'webp';
    } catch (e) {
      debugPrint('⚠️ Error al extraer extensión de URL: $e');
      return 'webp';
    }
  }

  /// Descarga una imagen de muestra y la guarda como archivo local
  Future<void> _downloadAndSaveSampleImage(String imageUrl) async {
    try {
      setState(() {
        _isUploadingImage = true;
      });

      debugPrint('📥 Descargando imagen de muestra: $imageUrl');

      // Descargar la imagen
      final response = await http.get(Uri.parse(imageUrl));
      
      if (response.statusCode != 200) {
        throw Exception('Error al descargar la imagen: ${response.statusCode}');
      }

      // Detectar la extensión del archivo desde la URL
      final extension = _getFileExtensionFromUrl(imageUrl);
      debugPrint('📸 Extensión detectada: $extension');

      // Guardar en un archivo temporal con la extensión correcta
      final tempDir = await getTemporaryDirectory();
      final tempFile = File('${tempDir.path}/sample_${DateTime.now().millisecondsSinceEpoch}.$extension');
      await tempFile.writeAsBytes(response.bodyBytes);

      debugPrint('✅ Imagen descargada en: ${tempFile.path} (formato: $extension)');

      if (!mounted) return;

      // Navegar a la pantalla de recorte
      final croppedBytes = await Navigator.of(context).push<Uint8List>(
        MaterialPageRoute(
          builder: (context) => ImageCropScreen(
            imageFile: tempFile,
            aspectRatio: 16 / 9,
          ),
        ),
      );

      if (croppedBytes != null && mounted) {
        // Guardar la imagen recortada
        final croppedDir = await Directory.systemTemp.createTemp('fiestapp_images');
        final croppedFile = File('${croppedDir.path}/cropped_${DateTime.now().millisecondsSinceEpoch}.jpg');
        await croppedFile.writeAsBytes(croppedBytes);
        
        debugPrint('✅ Imagen recortada guardada en: ${croppedFile.path}');
        
        setState(() {
          _croppedImageFile = croppedFile;
          _selectedImage = PlatformFile(
            name: 'sample_cropped_${DateTime.now().millisecondsSinceEpoch}.jpg',
            size: croppedBytes.length,
            path: croppedFile.path,
            bytes: null,
          );
        });
      }
    } catch (e, stackTrace) {
      debugPrint('❌ Error al descargar imagen de muestra: $e');
      debugPrint('Stack trace: $stackTrace');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error al descargar imagen de muestra: ${e.toString()}'),
            backgroundColor: Theme.of(context).colorScheme.error,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isUploadingImage = false;
        });
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
        final tempDir = await getTemporaryDirectory();
        final croppedFile = File(
          '${tempDir.path}/cropped_event_${DateTime.now().millisecondsSinceEpoch}.jpg',
        );
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
    try {
      File? tempFile;
      if (!kIsWeb) {
        final tempDir = await getTemporaryDirectory();
        tempFile = File(
          '${tempDir.path}/temp_image_${DateTime.now().millisecondsSinceEpoch}.jpg',
        );
        await tempFile.writeAsBytes(imageBytes);
      } else {
        final tempDir = await getTemporaryDirectory();
        tempFile = File(
          '${tempDir.path}/temp_image_${DateTime.now().millisecondsSinceEpoch}.jpg',
        );
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
        if (!kIsWeb) {
          final tempDir = await getTemporaryDirectory();
          final croppedFile = File(
            '${tempDir.path}/cropped_event_${DateTime.now().millisecondsSinceEpoch}.jpg',
          );
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
          final tempDir = await getTemporaryDirectory();
          final croppedFile = File(
            '${tempDir.path}/cropped_event_${DateTime.now().millisecondsSinceEpoch}.jpg',
          );
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
    if (_croppedImageFile == null && _selectedImage == null) {
      return _uploadedImageUrl; // Mantener la imagen existente
    }

    try {
      setState(() {
        _isUploadingImage = true;
      });

      final supa = Supabase.instance.client;
      final fileName =
          'event_${DateTime.now().millisecondsSinceEpoch}_${_selectedImage?.name ?? 'image.jpg'}';

      if (_croppedImageFile != null) {
        if (kIsWeb) {
          final bytes = await _croppedImageFile!.readAsBytes();
          await supa.storage.from('event-images').uploadBinary(
                fileName,
                bytes,
                fileOptions:
                    const FileOptions(cacheControl: '3600', upsert: false),
              );
        } else {
          await supa.storage.from('event-images').upload(
                fileName,
                _croppedImageFile!,
                fileOptions:
                    const FileOptions(cacheControl: '3600', upsert: false),
              );
        }
      } else if (_selectedImage != null) {
        final file = _selectedImage!;
        if (kIsWeb) {
          if (file.bytes == null) return _uploadedImageUrl;
          await supa.storage.from('event-images').uploadBinary(
                fileName,
                file.bytes!,
                fileOptions:
                    const FileOptions(cacheControl: '3600', upsert: false),
              );
        } else {
          final path = file.path;
          if (path == null) return _uploadedImageUrl;
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
      debugPrint('Error subiendo imagen: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error al subir la imagen: ${e.toString()}'),
            backgroundColor: Theme.of(context).colorScheme.error,
          ),
        );
      }
      return _uploadedImageUrl; // Retornar la imagen existente si falla
    } finally {
      if (mounted) {
        setState(() {
          _isUploadingImage = false;
        });
      }
    }
  }

  Future<void> _saveEvent({required bool approve}) async {
    if (!_validateAllFields()) {
      setState(() {});
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Por favor, completa todos los campos obligatorios'),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    try {
      setState(() {
        _isSaving = true;
      });

      // Subir imagen si hay una nueva seleccionada
      final imageUrl = await _uploadImageIfNeeded();

      // Calcular fecha/hora
      final hour = _selectedTime?.hour ?? 0;
      final minute = _selectedTime?.minute ?? 0;
      final startsAt = DateTime(
        _startDate!.year,
        _startDate!.month,
        _startDate!.day,
        hour,
        minute,
      );

      // Calcular coordenadas
      final double? latToSave = _lat ?? _selectedCity?.lat;
      final double? lngToSave = _lng ?? _selectedCity?.lng;
      final mapsUrl = (latToSave != null && lngToSave != null)
          ? 'https://www.google.com/maps/search/?api=1&query=$latToSave,$lngToSave'
          : null;

      // Actualizar el evento
      await _eventService.updateEvent(
        eventId: widget.event.id,
        title: _titleController.text,
        town: _selectedCity!.name,
        place: _placeController.text.trim().isEmpty
            ? _selectedCity!.name
            : _placeController.text,
        startsAt: startsAt,
        cityId: _selectedCityId!,
        categoryId: _selectedCategory!.id!,
        description: _descriptionController.text.trim(),
        mapsUrl: mapsUrl,
        lat: latToSave,
        lng: lngToSave,
        price: _price.isNotEmpty ? _price : 'Gratis',
        imageUrl: imageUrl,
        imageAlignment: _imageAlignment,
      );

      // Si se debe aprobar, cambiar el estado
      if (approve) {
        await _adminService.approveEvent(widget.event.id);
      }

      if (!mounted) return;

      setState(() {
        _isSaving = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            approve
                ? 'Evento guardado y aprobado'
                : 'Cambios guardados (evento sigue pendiente)',
          ),
          backgroundColor: Colors.green,
        ),
      );

      // Si se aprobó, volver a la lista
      if (approve) {
        Future.delayed(const Duration(milliseconds: 500), () {
          if (mounted) {
            Navigator.of(context).pop(true); // true indica que se debe refrescar
          }
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isSaving = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error al guardar: ${e.toString()}'),
            backgroundColor: Theme.of(context).colorScheme.error,
          ),
        );
      }
    }
  }

  Future<void> _rejectEvent() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Rechazar evento'),
        content: const Text('¿Estás seguro de que deseas rechazar este evento?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.of(context).pop(true),
            style: ElevatedButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.error,
            ),
            child: const Text('Rechazar'),
          ),
        ],
      ),
    );

    if (confirmed != true) return;

    try {
      await _adminService.rejectEvent(widget.event.id);

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Evento rechazado'),
        ),
      );

      Future.delayed(const Duration(milliseconds: 500), () {
        if (mounted) {
          Navigator.of(context).pop(true); // true indica que se debe refrescar
        }
      });
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error al rechazar: ${e.toString()}'),
            backgroundColor: Theme.of(context).colorScheme.error,
          ),
        );
      }
    }
  }

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

  Widget _buildMapBottomSheet() {
    LatLng initialCenter;
    LatLng? initialMarkerPosition;

    if (_lat != null && _lng != null) {
      initialCenter = LatLng(_lat!, _lng!);
      initialMarkerPosition = initialCenter;
    } else if (_selectedCity?.lat != null && _selectedCity?.lng != null) {
      initialCenter = LatLng(_selectedCity!.lat!, _selectedCity!.lng!);
      initialMarkerPosition = initialCenter;
    } else {
      initialCenter = const LatLng(36.1927, -5.9219);
      initialMarkerPosition = initialCenter;
    }

    return StatefulBuilder(
      builder: (context, setModalState) {
        LatLng? pickedLatLng = initialMarkerPosition;

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
                                color: Theme.of(context)
                                    .colorScheme
                                    .onSurfaceVariant,
                              ),
                              const SizedBox(height: 16),
                              Text(
                                'La selección en el mapa solo está disponible en la app móvil',
                                style: Theme.of(context).textTheme.titleMedium,
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
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: ElevatedButton(
                  onPressed: () {
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

  String _getCategoryDescription(String categoryName) {
    final lowerName = categoryName.toLowerCase();

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
      return 'Eventos de $categoryName';
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoadingData) {
      return Scaffold(
        appBar: AppBar(title: const Text('Editar evento')),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Editar evento')),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Sección de posibles duplicados
            PossibleDuplicatesSection(event: widget.event),
            
            // Formulario editable
            Padding(
              padding: const EdgeInsets.all(20),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // === SECCIÓN: Información básica ===
                    _buildSectionTitle('Información básica'),
                    const SizedBox(height: 12),
                    
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
                    ),
                    const SizedBox(height: 16),

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
                              style: Theme.of(context)
                                  .textTheme
                                  .titleMedium
                                  ?.copyWith(fontWeight: FontWeight.w600),
                            ),
                            const SizedBox(height: 12),
                            ..._eventDays.map((day) {
                              final controller = _dailyProgramControllers[day];
                              if (controller == null) {
                                return const SizedBox.shrink();
                              }

                              return Padding(
                                padding: const EdgeInsets.only(bottom: 16),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      DateFormat('EEE d MMM', 'es').format(day),
                                      style: Theme.of(context)
                                          .textTheme
                                          .titleSmall
                                          ?.copyWith(
                                            fontWeight: FontWeight.w600,
                                            color: Theme.of(context)
                                                .colorScheme
                                                .primary,
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
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium
                                ?.copyWith(
                                  color: Theme.of(context)
                                      .colorScheme
                                      .onSurfaceVariant,
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
                          style: Theme.of(context)
                              .textTheme
                              .bodySmall
                              ?.copyWith(
                                color: Theme.of(context).colorScheme.error,
                              ),
                        ),
                      ),
                    const SizedBox(height: 32),

                    // === SECCIÓN: Imagen del evento ===
                    _buildSectionTitle('Imagen del evento'),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        ElevatedButton.icon(
                          onPressed: _isSaving || _isUploadingImage
                              ? null
                              : _pickImage,
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
                          )
                        else if (_uploadedImageUrl != null)
                          Expanded(
                            child: Text(
                              'Imagen actual',
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                color: Theme.of(context)
                                    .colorScheme
                                    .onSurfaceVariant,
                              ),
                            ),
                          ),
                      ],
                    ),
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
                    ] else if (_uploadedImageUrl != null) ...[
                      const SizedBox(height: 8),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Image.network(
                          _uploadedImageUrl!,
                          height: 150,
                          width: double.infinity,
                          fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) => Container(
                            height: 150,
                            color: Theme.of(context).colorScheme.surfaceVariant,
                            child: Icon(
                              Icons.image_not_supported,
                              color: Theme.of(context).colorScheme.onSurfaceVariant,
                            ),
                          ),
                        ),
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
                          style: Theme.of(context)
                              .textTheme
                              .bodySmall
                              ?.copyWith(
                                color: Theme.of(context).colorScheme.error,
                              ),
                        ),
                      ),
                    const SizedBox(height: 32),

                    // === SECCIÓN: Categoría ===
                    _buildSectionTitle('Categoría'),
                    const SizedBox(height: 12),
                    
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
                            .fold<Map<int, Category>>({}, (map, category) {
                              if (category.id != null && !map.containsKey(category.id)) {
                                map[category.id!] = category;
                              }
                              return map;
                            })
                            .values
                            .toList()
                            .map<Widget>((Category category) {
                              return Text(
                                category.name,
                                overflow: TextOverflow.ellipsis,
                              );
                            }).toList();
                      },
                      // En el menú desplegable, mostrar nombre + descripción
                      items: _categories
                          .where((Category c) => c.id != null)
                          .fold<Map<int, Category>>({}, (map, category) {
                            // Eliminar duplicados por ID, manteniendo el primero encontrado
                            if (category.id != null && !map.containsKey(category.id)) {
                              map[category.id!] = category;
                            }
                            return map;
                          })
                          .values
                          .toList()
                          .map((Category category) {
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

                    // === SECCIÓN: Acciones ===
                    _buildSectionTitle('Acciones'),
                    const SizedBox(height: 12),
                    
                    if (widget.isPublished) ...[
                      // Para eventos publicados: solo botón de guardar
                      ElevatedButton.icon(
                        onPressed: _isSaving
                            ? null
                            : () => _saveEvent(approve: false),
                        icon: const Icon(Icons.save),
                        label: const Text('Guardar cambios'),
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          backgroundColor: Theme.of(context).colorScheme.primary,
                          foregroundColor: Theme.of(context).colorScheme.onPrimary,
                        ),
                      ),
                    ] else ...[
                      // Para eventos pendientes: botones de aprobar/rechazar
                      // Botón principal: Guardar y aprobar
                      ElevatedButton.icon(
                        onPressed: _isSaving
                            ? null
                            : () => _saveEvent(approve: true),
                        icon: const Icon(Icons.check),
                        label: const Text('Guardar y aprobar'),
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          backgroundColor: Theme.of(context).colorScheme.primary,
                          foregroundColor: Theme.of(context).colorScheme.onPrimary,
                        ),
                      ),
                      const SizedBox(height: 12),

                      // Botón secundario: Guardar sin aprobar
                      OutlinedButton.icon(
                        onPressed: _isSaving
                            ? null
                            : () => _saveEvent(approve: false),
                        icon: const Icon(Icons.save),
                        label: const Text('Guardar cambios sin aprobar'),
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                        ),
                      ),
                      const SizedBox(height: 12),

                      // Botón destructivo: Rechazar
                      OutlinedButton.icon(
                        onPressed: _isSaving ? null : _rejectEvent,
                        icon: const Icon(Icons.close),
                        label: const Text('Rechazar evento'),
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          foregroundColor: Theme.of(context).colorScheme.error,
                          side: BorderSide(
                            color: Theme.of(context).colorScheme.error,
                          ),
                        ),
                      ),
                    ],
                    if (_isSaving)
                      const Padding(
                        padding: EdgeInsets.all(16),
                        child: Center(
                          child: CircularProgressIndicator(),
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

// Widget del mapa (reutilizado del formulario de creación)
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
                draggable: true,
                onDragEnd: (LatLng newPosition) {
                  widget.onMarkerUpdated(newPosition);
                },
              ),
            }
          : {},
      myLocationButtonEnabled: false,
      zoomControlsEnabled: true,
      scrollGesturesEnabled: true,
      zoomGesturesEnabled: true,
      tiltGesturesEnabled: false,
      rotateGesturesEnabled: true,
      onMapCreated: (GoogleMapController controller) {
        _mapController = controller;
      },
    );
  }
}

/// Diálogo para seleccionar una imagen de muestra
class _SampleImagePickerDialog extends StatelessWidget {
  final List<String> imageUrls;
  final String categoryName;

  const _SampleImagePickerDialog({
    required this.imageUrls,
    required this.categoryName,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Container(
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.9,
          maxHeight: MediaQuery.of(context).size.height * 0.8,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Header
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      'Imágenes de muestra - $categoryName',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                ],
              ),
            ),
            const Divider(height: 1),
            // Grid de imágenes
            Flexible(
              child: GridView.builder(
                padding: const EdgeInsets.all(16.0),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 16.0,
                  mainAxisSpacing: 16.0,
                  childAspectRatio: 1.0,
                ),
                itemCount: imageUrls.length,
                itemBuilder: (context, index) {
                  final imageUrl = imageUrls[index];
                  return GestureDetector(
                    onTap: () => Navigator.of(context).pop(imageUrl),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(8.0),
                      child: Image.network(
                        imageUrl,
                        fit: BoxFit.cover,
                        loadingBuilder: (context, child, loadingProgress) {
                          if (loadingProgress == null) return child;
                          return Center(
                            child: CircularProgressIndicator(
                              value: loadingProgress.expectedTotalBytes != null
                                  ? loadingProgress.cumulativeBytesLoaded /
                                      loadingProgress.expectedTotalBytes!
                                  : null,
                            ),
                          );
                        },
                        errorBuilder: (context, error, stackTrace) {
                          return Container(
                            color: Theme.of(context).colorScheme.surfaceContainerHighest,
                            child: Icon(
                              Icons.broken_image,
                              color: Theme.of(context).colorScheme.onSurfaceVariant,
                            ),
                          );
                        },
                      ),
                    ),
                  );
                },
              ),
            ),
            const Divider(height: 1),
            // Footer
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('Cancelar'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
