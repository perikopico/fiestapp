import 'dart:io';
import 'dart:async';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show debugPrint;
import 'package:crop_your_image/crop_your_image.dart';

class ImageCropScreen extends StatefulWidget {
  final File imageFile;
  final double aspectRatio;

  const ImageCropScreen({
    super.key,
    required this.imageFile,
    this.aspectRatio = 16 / 9,
  });

  @override
  State<ImageCropScreen> createState() => _ImageCropScreenState();
}

class _ImageCropScreenState extends State<ImageCropScreen> {
  final _cropController = CropController();
  Uint8List? _imageBytes;
  bool _isLoading = true;
  bool _isCropping = false;
  Completer<Uint8List>? _cropCompleter;

  @override
  void initState() {
    super.initState();
    _loadImage();
  }

  Future<void> _loadImage() async {
    try {
      debugPrint('📸 Cargando imagen desde: ${widget.imageFile.path}');
      
      // Verificar que el archivo existe
      if (!await widget.imageFile.exists()) {
        throw Exception('El archivo de imagen no existe');
      }

      // Verificar el tamaño del archivo (evitar cargar archivos muy grandes)
      final fileSize = await widget.imageFile.length();
      debugPrint('📸 Tamaño del archivo: ${fileSize} bytes (${(fileSize / 1024 / 1024).toStringAsFixed(2)} MB)');
      
      if (fileSize > 50 * 1024 * 1024) { // 50 MB
        throw Exception('La imagen es demasiado grande (máximo 50 MB)');
      }

      final bytes = await widget.imageFile.readAsBytes();
      debugPrint('✅ Imagen cargada: ${bytes.length} bytes');
      
      if (mounted) {
        setState(() {
          _imageBytes = bytes;
          _isLoading = false;
        });
      }
    } catch (e, stackTrace) {
      debugPrint('❌ Error al cargar la imagen: $e');
      debugPrint('Stack trace: $stackTrace');
      
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error al cargar la imagen: ${e.toString()}'),
            backgroundColor: Theme.of(context).colorScheme.error,
          ),
        );
      }
    }
  }

  Future<void> _confirmCrop() async {
    if (_imageBytes == null || _isCropping) {
      debugPrint('⚠️ No se puede recortar: imagen nula o ya recortando');
      return;
    }
    
    debugPrint('✂️ Iniciando recorte de imagen...');
    
    setState(() {
      _isCropping = true;
      // Crear un nuevo Completer para este crop
      _cropCompleter = Completer<Uint8List>();
    });
    
    try {
      // Iniciar el crop
      _cropController.crop();
      debugPrint('✂️ Crop iniciado, esperando resultado...');
      
      // Esperar a que el crop termine (el callback onCropped completará el Future)
      // Agregar timeout para evitar que se quede colgado
      final croppedBytes = await _cropCompleter!.future.timeout(
        const Duration(seconds: 10),
        onTimeout: () {
          debugPrint('❌ Timeout al recortar imagen');
          throw TimeoutException('El recorte de imagen tardó demasiado');
        },
      );
      
      debugPrint('✅ Imagen recortada: ${croppedBytes.length} bytes');
      
      // Hacer pop después de un pequeño delay para asegurar que el Navigator no esté bloqueado
      await Future.delayed(const Duration(milliseconds: 100));
      
      if (mounted) {
        Navigator.of(context).pop(croppedBytes);
      }
    } catch (e, stackTrace) {
      debugPrint('❌ Error al recortar imagen: $e');
      debugPrint('Stack trace: $stackTrace');
      if (mounted) {
        setState(() {
          _isCropping = false;
          _cropCompleter = null;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('No se pudo procesar la imagen: ${e.toString()}'),
            backgroundColor: Theme.of(context).colorScheme.error,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Recortar imagen'),
        actions: [
          TextButton(
            onPressed: _isLoading ? null : () {
              // Cancelar: volver sin imagen recortada
              Navigator.of(context).pop();
            },
            child: const Text('Cancelar'),
          ),
          const SizedBox(width: 8),
          TextButton(
            onPressed: (_isLoading || _isCropping) ? null : _confirmCrop,
            child: _isCropping
                ? const SizedBox(
                    width: 16,
                    height: 16,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Text('Aceptar'),
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _imageBytes == null
              ? Center(
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
                        'No se pudo cargar la imagen',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                    ],
                  ),
                )
              : Crop(
                  image: _imageBytes!,
                  controller: _cropController,
                  aspectRatio: widget.aspectRatio,
                  onCropped: (result) {
                    debugPrint('📸 Callback onCropped llamado con resultado: ${result.runtimeType}');
                    // En crop_your_image 2.0.0, onCropped devuelve CropResult
                    if (_cropCompleter != null && !_cropCompleter!.isCompleted) {
                      // Usar pattern matching para manejar CropResult
                      switch (result) {
                        case CropSuccess(:final croppedImage):
                          debugPrint('✅ Crop exitoso: ${croppedImage.length} bytes');
                          _cropCompleter!.complete(croppedImage);
                        case CropFailure(:final cause, :final stackTrace):
                          debugPrint('❌ Crop falló: $cause');
                          _cropCompleter!.completeError(
                            cause,
                            stackTrace ?? StackTrace.current,
                          );
                      }
                    } else {
                      debugPrint('⚠️ Completer no disponible o ya completado');
                    }
                  },
                ),
    );
  }
}

