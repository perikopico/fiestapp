import 'dart:io';
import 'dart:async';
import 'dart:typed_data';
import 'package:flutter/material.dart';
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
      final bytes = await widget.imageFile.readAsBytes();
      setState(() {
        _imageBytes = bytes;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      if (mounted) {
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
    if (_imageBytes == null || _isCropping) return;
    
    setState(() {
      _isCropping = true;
      // Crear un nuevo Completer para este crop
      _cropCompleter = Completer<Uint8List>();
    });
    
    try {
      // Iniciar el crop
      _cropController.crop();
      
      // Esperar a que el crop termine (el callback onCropped completará el Future)
      final croppedBytes = await _cropCompleter!.future;
      
      // Hacer pop después de un pequeño delay para asegurar que el Navigator no esté bloqueado
      await Future.delayed(const Duration(milliseconds: 100));
      
      if (mounted) {
        Navigator.of(context).pop(croppedBytes);
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isCropping = false;
          _cropCompleter = null;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('No se pudo procesar la imagen. Inténtalo de nuevo.'),
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
                  onCropped: (image) {
                    // Completar el Future con el resultado del crop
                    // CropResult es una clase sealed con CropSuccess y CropFailure
                    if (_cropCompleter != null && !_cropCompleter!.isCompleted) {
                      if (image is CropSuccess) {
                        _cropCompleter!.complete(image.croppedImage);
                      } else if (image is CropFailure) {
                        _cropCompleter!.completeError(image.cause, image.stackTrace);
                      }
                    }
                  },
                ),
    );
  }
}

