import 'dart:io' show File, Directory, Platform;
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show debugPrint, kIsWeb;
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import '../image_crop_screen.dart';
import '../event_wizard_screen.dart';

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
      
      // Mostrar diálogo para elegir entre galería y cámara
      if (!mounted) return;
      final ImageSource? source = await showDialog<ImageSource>(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Seleccionar imagen'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.photo_library),
                title: const Text('Galería'),
                onTap: () => Navigator.of(context).pop(ImageSource.gallery),
              ),
              ListTile(
                leading: const Icon(Icons.camera_alt),
                title: const Text('Cámara'),
                onTap: () => Navigator.of(context).pop(ImageSource.camera),
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

      if (source == null) {
        debugPrint('📸 Selección cancelada por el usuario');
        return;
      }

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

