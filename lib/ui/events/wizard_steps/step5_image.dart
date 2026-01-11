import 'dart:io' show File, Directory, Platform;
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show debugPrint, kIsWeb;
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import '../image_crop_screen.dart';
import '../event_wizard_screen.dart';
import '../../../services/sample_image_service.dart';

class Step5Image extends StatefulWidget {
  final EventWizardData wizardData;
  final VoidCallback onNext;
  final VoidCallback onBack;

  const Step5Image({
    super.key,
    required this.wizardData,
    required this.onNext,
    required this.onBack,
  });

  @override
  State<Step5Image> createState() => _Step5ImageState();
}

class _Step5ImageState extends State<Step5Image> {
  File? _croppedImageFile;
  bool _isUploadingImage = false;

  @override
  void initState() {
    super.initState();
    _croppedImageFile = widget.wizardData.imageFile;
  }

  Future<void> _pickImage() async {
    try {
      debugPrint('📸 Iniciando selección de imagen...');
      setState(() {
        _isUploadingImage = true;
      });

      final ImagePicker picker = ImagePicker();
      
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
                  widget.wizardData.category != null
                      ? 'Ver imágenes de ${widget.wizardData.category!.name}'
                      : 'Selecciona primero una categoría',
                ),
                enabled: widget.wizardData.category != null,
                onTap: widget.wizardData.category != null
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

      // Para galería y cámara, usar ImageSource
      // Sabemos que option no es null ni sample en este punto, así que source no será null
      final ImageSource source = option == ImageSelectionOption.gallery
          ? ImageSource.gallery
          : ImageSource.camera;

      debugPrint('📸 Fuente seleccionada: ${source == ImageSource.gallery ? "galería" : "cámara"}');

      // Verificar permisos en iOS
      if (!kIsWeb && Platform.isIOS) {
        if (source == ImageSource.camera) {
          // Verificar permiso de cámara
          final cameraStatus = await Permission.camera.status;
          debugPrint('📸 Estado del permiso de cámara: $cameraStatus');
          
          if (!cameraStatus.isGranted) {
            debugPrint('📸 Solicitando permiso de cámara...');
            final result = await Permission.camera.request();
            debugPrint('📸 Resultado de la solicitud de permiso: $result');
            
            if (result.isPermanentlyDenied) {
              debugPrint('❌ Permiso de cámara denegado permanentemente');
              if (mounted) {
                setState(() {
                  _isUploadingImage = false;
                });
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: const Text('El permiso de cámara está deshabilitado. Por favor, habilítalo en Configuración > QuePlan > Cámara'),
                    duration: const Duration(seconds: 5),
                    action: SnackBarAction(
                      label: 'Abrir Configuración',
                      onPressed: () => openAppSettings(),
                    ),
                  ),
                );
              }
              return;
            } else if (result.isDenied) {
              debugPrint('❌ Permiso de cámara denegado (puede solicitarse de nuevo)');
              if (mounted) {
                setState(() {
                  _isUploadingImage = false;
                });
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Se necesita permiso de cámara para tomar fotos. Intenta de nuevo.'),
                    duration: Duration(seconds: 3),
                  ),
                );
              }
              return;
            }
          }
        } else {
          // Verificar permiso de galería
          final photosStatus = await Permission.photos.status;
          debugPrint('📸 Estado del permiso de galería: $photosStatus');
          
          if (!photosStatus.isGranted) {
            debugPrint('📸 Solicitando permiso de galería...');
            final result = await Permission.photos.request();
            debugPrint('📸 Resultado de la solicitud de permiso: $result');
            
            if (result.isPermanentlyDenied) {
              debugPrint('❌ Permiso de galería denegado permanentemente');
              if (mounted) {
                setState(() {
                  _isUploadingImage = false;
                });
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: const Text('El permiso de galería está deshabilitado. Por favor, habilítalo en Configuración > QuePlan > Fotos'),
                    duration: const Duration(seconds: 5),
                    action: SnackBarAction(
                      label: 'Abrir Configuración',
                      onPressed: () => openAppSettings(),
                    ),
                  ),
                );
              }
              return;
            } else if (result.isDenied) {
              debugPrint('❌ Permiso de galería denegado (puede solicitarse de nuevo)');
              if (mounted) {
                setState(() {
                  _isUploadingImage = false;
                });
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Se necesita permiso de galería para seleccionar imágenes. Intenta de nuevo.'),
                    duration: Duration(seconds: 3),
                  ),
                );
              }
              return;
            }
          }
        }
      }

      // Seleccionar imagen
      XFile? pickedFile;
      try {
        pickedFile = await picker.pickImage(
          source: source,
          imageQuality: 90, // Calidad alta para luego comprimir a WebP
        );
      } catch (e, stackTrace) {
        debugPrint('❌ Error al seleccionar imagen con ImagePicker: $e');
        debugPrint('Stack trace: $stackTrace');
        if (mounted) {
          setState(() {
            _isUploadingImage = false;
          });
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Error al ${source == ImageSource.camera ? "tomar la foto" : "seleccionar la imagen"}: ${e.toString()}'),
              backgroundColor: Theme.of(context).colorScheme.error,
            ),
          );
        }
        return;
      }

      debugPrint('📸 Resultado del ImagePicker: ${pickedFile != null ? "archivo seleccionado" : "cancelado"}');

      if (pickedFile == null) {
        debugPrint('📸 No se seleccionó ningún archivo');
        if (mounted) {
          setState(() {
            _isUploadingImage = false;
          });
        }
        return;
      }

      debugPrint('📸 Archivo seleccionado: ${pickedFile.path}');

      // Verificar que el archivo existe
      final file = File(pickedFile.path);
      if (!await file.exists()) {
        debugPrint('❌ El archivo no existe: ${pickedFile.path}');
        if (mounted) {
          setState(() {
            _isUploadingImage = false;
          });
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('El archivo seleccionado no existe'),
              backgroundColor: Colors.orange,
            ),
          );
        }
        return;
      }

      debugPrint('📸 Archivo existe, navegando a pantalla de recorte...');

      // Navegar a la pantalla de recorte
      if (!mounted) {
        debugPrint('❌ Widget no está montado, cancelando navegación');
        return;
      }

      final croppedBytes = await Navigator.of(context).push<Uint8List>(
        MaterialPageRoute(
          builder: (context) => ImageCropScreen(imageFile: file),
        ),
      );

      debugPrint('📸 Regresó de pantalla de recorte: ${croppedBytes != null ? "imagen recortada" : "cancelado"}');

      if (croppedBytes != null && mounted) {
        // Guardar la imagen recortada en un archivo temporal
        try {
          debugPrint('📸 Guardando imagen recortada en archivo temporal...');
          final tempDir = await Directory.systemTemp.createTemp('fiestapp_images');
          final tempFile = File('${tempDir.path}/cropped_${DateTime.now().millisecondsSinceEpoch}.jpg');
          await tempFile.writeAsBytes(croppedBytes);
          
          debugPrint('✅ Imagen guardada en: ${tempFile.path}');
          
          setState(() {
            _croppedImageFile = tempFile;
            widget.wizardData.imageFile = tempFile;
          });
        } catch (e, stackTrace) {
          debugPrint('❌ Error al guardar imagen recortada: $e');
          debugPrint('Stack trace: $stackTrace');
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Error al guardar la imagen: ${e.toString()}'),
                backgroundColor: Theme.of(context).colorScheme.error,
              ),
            );
          }
        }
      }
    } catch (e, stackTrace) {
      debugPrint('❌ Error al seleccionar imagen: $e');
      debugPrint('Stack trace: $stackTrace');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error al seleccionar imagen: ${e.toString()}'),
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

  /// Abre el selector de imágenes de muestra
  Future<void> _pickSampleImage() async {
    if (widget.wizardData.category == null) {
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
        categorySlug: widget.wizardData.category!.slug,
        categoryId: widget.wizardData.category!.id,
      );

      if (!mounted) return;

      if (sampleImages.isEmpty) {
        setState(() {
          _isUploadingImage = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'No hay imágenes de muestra disponibles para ${widget.wizardData.category!.name}',
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
          categoryName: widget.wizardData.category!.name ?? 'categoría',
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
      if (path.isEmpty) return 'webp'; // Por defecto WebP si no se puede determinar
      
      final lastDot = path.lastIndexOf('.');
      if (lastDot == -1 || lastDot == path.length - 1) {
        return 'webp'; // Por defecto WebP
      }
      
      final extension = path.substring(lastDot + 1).toLowerCase();
      // Validar que sea una extensión de imagen válida
      if (['jpg', 'jpeg', 'png', 'webp'].contains(extension)) {
        return extension;
      }
      return 'webp'; // Por defecto WebP si la extensión no es reconocida
    } catch (e) {
      debugPrint('⚠️ Error al extraer extensión de URL: $e');
      return 'webp'; // Por defecto WebP
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
      // ImageCropScreen funciona con bytes, por lo que puede manejar WebP sin problemas
      final croppedBytes = await Navigator.of(context).push<Uint8List>(
        MaterialPageRoute(
          builder: (context) => ImageCropScreen(imageFile: tempFile),
        ),
      );

      if (croppedBytes != null && mounted) {
        // Guardar la imagen recortada
        // Después del recorte, siempre guardamos como JPG para consistencia
        // (crop_your_image devuelve bytes que se pueden guardar en cualquier formato)
        final croppedDir = await Directory.systemTemp.createTemp('fiestapp_images');
        final croppedFile = File('${croppedDir.path}/cropped_${DateTime.now().millisecondsSinceEpoch}.jpg');
        await croppedFile.writeAsBytes(croppedBytes);
        
        debugPrint('✅ Imagen recortada guardada en: ${croppedFile.path}');
        
        setState(() {
          _croppedImageFile = croppedFile;
          widget.wizardData.imageFile = croppedFile;
        });
      }
    } catch (e, stackTrace) {
      debugPrint('❌ Error al descargar imagen de muestra: $e');
      debugPrint('Stack trace: $stackTrace');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error al descargar la imagen: ${e.toString()}'),
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

  void _handleNext() {
    // Guardar datos
    widget.wizardData.stepValidated[4] = true;
    
    widget.onNext();
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
                      'Imagen del Evento',
                      style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Añade una imagen atractiva para tu evento (opcional)',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                    ),
                    const SizedBox(height: 32),

                    // Botón de seleccionar imagen
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        onPressed: _isUploadingImage ? null : _pickImage,
                        icon: const Icon(Icons.photo),
                        label: const Text('Seleccionar imagen'),
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Preview de imagen
                    if (_croppedImageFile != null) ...[
                      ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Image.file(
                          _croppedImageFile!,
                          height: 200,
                          width: double.infinity,
                          fit: BoxFit.cover,
                        ),
                      ),
                      const SizedBox(height: 16),
                      TextButton.icon(
                        onPressed: () {
                          setState(() {
                            _croppedImageFile = null;
                            widget.wizardData.imageFile = null;
                          });
                        },
                        icon: const Icon(Icons.delete_outline),
                        label: const Text('Eliminar imagen'),
                      ),
                      const SizedBox(height: 24),
                    ],

                    // Información
                    if (_croppedImageFile == null)
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
                                  'Puedes saltar este paso y añadir una imagen más tarde',
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

/// Enum para las opciones de selección de imagen
enum ImageSelectionOption {
  gallery,
  camera,
  sample,
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
