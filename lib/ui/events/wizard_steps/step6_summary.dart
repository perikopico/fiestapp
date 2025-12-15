import 'dart:io' show File;
import 'dart:math';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show debugPrint, kIsWeb;
import 'package:intl/intl.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:path_provider/path_provider.dart';
import 'package:cross_file/cross_file.dart';
import '../../../services/event_service.dart';
import '../../../models/event.dart';
import '../event_wizard_screen.dart';

class Step6Summary extends StatefulWidget {
  final EventWizardData wizardData;
  final VoidCallback onBack;
  final Function(int) onEditStep;
  final VoidCallback onSubmit;

  const Step6Summary({
    super.key,
    required this.wizardData,
    required this.onBack,
    required this.onEditStep,
    required this.onSubmit,
  });

  @override
  State<Step6Summary> createState() => _Step6SummaryState();
}

class _Step6SummaryState extends State<Step6Summary> {
  final EventService _eventService = EventService.instance;
  bool _isSubmitting = false;
  bool _isUploadingImage = false;
  bool _captchaValidated = false;

  Future<void> _showCaptchaDialog() async {
    final rnd = Random();
    final numA = rnd.nextInt(10) + 1;
    final numB = rnd.nextInt(10) + 1;
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
                  ScaffoldMessenger.of(dialogContext).showSnackBar(
                    const SnackBar(
                      content: Text('Respuesta incorrecta. Inténtalo de nuevo.'),
                      backgroundColor: Colors.red,
                    ),
                  );
                }
              },
              child: const Text('Verificar'),
            ),
          ],
        );
      },
    );

    if (result == true && mounted) {
      setState(() {
        _captchaValidated = true;
      });
    }
  }

  String _buildDescriptionForDay(DateTime day) {
    if (widget.wizardData.hasDailyProgram &&
        widget.wizardData.dailyPrograms.containsKey(day)) {
      final dailyProgram = widget.wizardData.dailyPrograms[day] ?? '';
      if (dailyProgram.trim().isNotEmpty) {
        return '${widget.wizardData.description}\n\n**${DateFormat('EEEE, d MMMM', 'es').format(day)}:**\n$dailyProgram';
      }
    }
    return widget.wizardData.description ?? '';
  }

  Future<String?> _uploadImageIfNeeded() async {
    if (widget.wizardData.imageFile == null) {
      return widget.wizardData.imageUrl;
    }

    try {
      setState(() {
        _isUploadingImage = true;
      });

      debugPrint('📸 Comprimiendo imagen a WebP para optimizar tamaño...');
      
      // Comprimir imagen a WebP antes de subir
      Uint8List? compressedBytes;
      File? compressedFile;
      
      try {
        if (kIsWeb) {
          // En web, leer bytes y comprimir
          final originalBytes = await widget.wizardData.imageFile!.readAsBytes();
          compressedBytes = await FlutterImageCompress.compressWithList(
            originalBytes,
            minHeight: 1920, // Redimensionar si la imagen es más grande (máximo 1920px altura)
            minWidth: 1920,  // Redimensionar si la imagen es más grande (máximo 1920px ancho)
            quality: 85,     // Calidad 85% (balance entre calidad y tamaño)
            format: CompressFormat.webp, // Formato WebP (30-50% más pequeño que JPEG)
          );
          debugPrint('✅ Imagen comprimida: ${originalBytes.length} bytes -> ${compressedBytes.length} bytes (${((1 - compressedBytes.length / originalBytes.length) * 100).toStringAsFixed(1)}% reducción)');
        } else {
          // En móvil, comprimir desde archivo
          final tempDir = await getTemporaryDirectory();
          final targetPath = '${tempDir.path}/compressed_${DateTime.now().millisecondsSinceEpoch}.webp';
          
          final xFile = await FlutterImageCompress.compressAndGetFile(
            widget.wizardData.imageFile!.absolute.path,
            targetPath,
            minHeight: 1920, // Redimensionar si la imagen es más grande (máximo 1920px altura)
            minWidth: 1920,  // Redimensionar si la imagen es más grande (máximo 1920px ancho)
            quality: 85,     // Calidad 85% (balance entre calidad y tamaño)
            format: CompressFormat.webp, // Formato WebP (30-50% más pequeño que JPEG)
          );
          
          // Convertir XFile a File
          if (xFile != null) {
            compressedFile = File(xFile.path);
            final originalSize = await widget.wizardData.imageFile!.length();
            final compressedSize = await compressedFile.length();
            debugPrint('✅ Imagen comprimida: ${originalSize} bytes -> ${compressedSize} bytes (${((1 - compressedSize / originalSize) * 100).toStringAsFixed(1)}% reducción)');
          }
        }
      } catch (e) {
        debugPrint('⚠️ Error al comprimir imagen, subiendo original: $e');
        // Si falla la compresión, usar la imagen original
        compressedFile = widget.wizardData.imageFile;
        compressedBytes = null;
      }

      final supa = Supabase.instance.client;
      final fileName = 'event_${DateTime.now().millisecondsSinceEpoch}.webp';

      if (kIsWeb) {
        if (compressedBytes == null) {
          // Fallback: leer bytes originales si no se comprimió
          compressedBytes = await widget.wizardData.imageFile!.readAsBytes();
        }
        await supa.storage.from('event-images').uploadBinary(
          fileName,
          compressedBytes,
          fileOptions: const FileOptions(cacheControl: '3600', upsert: false),
        );
      } else {
        final fileToUpload = compressedFile ?? widget.wizardData.imageFile!;
        await supa.storage.from('event-images').upload(
          fileName,
          fileToUpload,
          fileOptions: const FileOptions(cacheControl: '3600', upsert: false),
        );
      }

      final publicUrl = supa.storage.from('event-images').getPublicUrl(fileName);
      debugPrint('✅ Imagen subida exitosamente: $fileName');
      return publicUrl;
    } catch (e) {
      debugPrint('❌ Error subiendo imagen: $e');
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

  Future<void> _handleSubmit() async {
    if (!_captchaValidated) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Debes verificar que no eres un robot'),
          backgroundColor: Colors.orange,
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
      final startDate = widget.wizardData.startDate!;
      final endDate = widget.wizardData.endDate;

      // Si no hay fecha fin o es igual a la inicio, crear un solo evento
      final isSingleEvent = endDate == null ||
          (endDate.year == startDate.year &&
              endDate.month == startDate.month &&
              endDate.day == startDate.day);

      int eventsCreated = 0;
      String? errorMessage;

      if (isSingleEvent) {
        // Crear un solo evento
        final hour = widget.wizardData.time?.hour ?? 0;
        final minute = widget.wizardData.time?.minute ?? 0;
        final startsAt = DateTime(
          startDate.year,
          startDate.month,
          startDate.day,
          hour,
          minute,
        );

        final description = _buildDescriptionForDay(startDate);
        final latToSave = widget.wizardData.getFinalLat();
        final lngToSave = widget.wizardData.getFinalLng();
        final placeName = widget.wizardData.getPlaceName();

        // Validación de duplicados
        final tempEvent = Event(
          id: 'temp-${DateTime.now().millisecondsSinceEpoch}',
          title: widget.wizardData.title!,
          startsAt: startsAt,
          cityId: widget.wizardData.cityId,
          categoryId: widget.wizardData.category!.id,
          place: placeName,
          description: description,
          cityName: widget.wizardData.city!.name,
          categoryName: widget.wizardData.category?.name,
        );

        final duplicateEvents = await _eventService.getPotentialDuplicateEvents(tempEvent);

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
            setState(() {
              _isSubmitting = false;
            });
            return;
          }
        }

        try {
          await _eventService.submitEvent(
            title: widget.wizardData.title!,
            town: widget.wizardData.city!.name,
            place: placeName,
            startsAt: startsAt,
            cityId: widget.wizardData.cityId!,
            categoryId: widget.wizardData.category!.id!,
            description: description,
            mapsUrl: (latToSave != null && lngToSave != null)
                ? 'https://www.google.com/maps/search/?api=1&query=$latToSave,$lngToSave'
                : null,
            lat: latToSave,
            lng: lngToSave,
            isFree: widget.wizardData.isFree,
            imageUrl: imageUrl,
            imageAlignment: widget.wizardData.imageAlignment,
            venueId: widget.wizardData.venue?.id,
          );
          eventsCreated = 1;
        } catch (e) {
          debugPrint('Error al crear evento: $e');
          errorMessage = 'Error al crear el evento: ${e.toString()}';
        }
      } else {
        // Crear múltiples eventos (uno por día)
        final hour = widget.wizardData.time?.hour ?? 0;
        final minute = widget.wizardData.time?.minute ?? 0;

        DateTime currentDate = DateTime(
          startDate.year,
          startDate.month,
          startDate.day,
        );
        final finalDate = DateTime(
          endDate!.year,
          endDate.month,
          endDate.day,
        );

        while (!currentDate.isAfter(finalDate)) {
          try {
            final startsAt = DateTime(
              currentDate.year,
              currentDate.month,
              currentDate.day,
              hour,
              minute,
            );

            final description = _buildDescriptionForDay(currentDate);
            final latToSave = widget.wizardData.getFinalLat();
            final lngToSave = widget.wizardData.getFinalLng();
            final placeName = widget.wizardData.getPlaceName();

            await _eventService.submitEvent(
              title: widget.wizardData.title!,
              town: widget.wizardData.city!.name,
              place: placeName,
              startsAt: startsAt,
              cityId: widget.wizardData.cityId!,
              categoryId: widget.wizardData.category!.id!,
              description: description,
              mapsUrl: (latToSave != null && lngToSave != null)
                  ? 'https://www.google.com/maps/search/?api=1&query=$latToSave,$lngToSave'
                  : null,
              lat: latToSave,
              lng: lngToSave,
              isFree: widget.wizardData.isFree,
              imageUrl: imageUrl,
              imageAlignment: widget.wizardData.imageAlignment,
              venueId: widget.wizardData.venue?.id,
            );
            eventsCreated++;
          } catch (e) {
            debugPrint('Error al crear evento para ${currentDate}: $e');
            errorMessage = 'Error al crear algunos eventos: ${e.toString()}';
          }

          currentDate = currentDate.add(const Duration(days: 1));
        }
      }

      if (mounted) {
        setState(() {
          _isSubmitting = false;
        });

        if (errorMessage != null) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(errorMessage),
              backgroundColor: Theme.of(context).colorScheme.error,
            ),
          );
        } else {
          // Éxito
          showDialog(
            context: context,
            barrierDismissible: false,
            builder: (context) => AlertDialog(
              title: const Row(
                children: [
                  Icon(Icons.check_circle, color: Colors.green),
                  SizedBox(width: 12),
                  Expanded(child: Text('¡Evento creado!')),
                ],
              ),
              content: Text(
                eventsCreated == 1
                    ? 'Tu evento ha sido creado exitosamente y está pendiente de aprobación.'
                    : 'Se han creado $eventsCreated eventos exitosamente. Están pendientes de aprobación.',
              ),
              actions: [
                ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop(); // Cerrar diálogo
                    Navigator.of(context).pop(); // Volver a la pantalla anterior
                  },
                  child: const Text('Aceptar'),
                ),
              ],
            ),
          );
        }
      }
    } catch (e) {
      debugPrint('Error en _handleSubmit: $e');
      if (mounted) {
        setState(() {
          _isSubmitting = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error inesperado: ${e.toString()}'),
            backgroundColor: Theme.of(context).colorScheme.error,
          ),
        );
      }
    }
  }

  Widget _buildSummarySection({
    required String title,
    required IconData icon,
    required Widget content,
    required VoidCallback onEdit,
  }) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, color: Theme.of(context).colorScheme.primary),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    title,
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.edit),
                  onPressed: onEdit,
                  tooltip: 'Editar',
                ),
              ],
            ),
            const SizedBox(height: 12),
            content,
          ],
        ),
      ),
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
                    // Título
                    Text(
                      'Resumen del Evento',
                      style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Revisa todos los datos antes de crear el evento',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                    ),
                    const SizedBox(height: 32),

                    // Ciudad y Lugar (ahora es el paso 0)
                    _buildSummarySection(
                      title: 'Ciudad y Lugar',
                      icon: Icons.place,
                      content: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildInfoRow('Ciudad', widget.wizardData.city?.name ?? 'No especificada'),
                          const SizedBox(height: 8),
                          _buildInfoRow('Lugar', widget.wizardData.getPlaceName()),
                          if (widget.wizardData.lat != null && widget.wizardData.lng != null) ...[
                            const SizedBox(height: 8),
                            _buildInfoRow(
                              'Coordenadas',
                              'Lat: ${widget.wizardData.lat!.toStringAsFixed(4)}, Lng: ${widget.wizardData.lng!.toStringAsFixed(4)}',
                            ),
                          ],
                        ],
                      ),
                      onEdit: () => widget.onEditStep(0),
                    ),

                    // Información básica (ahora es el paso 1)
                    _buildSummarySection(
                      title: 'Información Básica',
                      icon: Icons.description,
                      content: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildInfoRow('Título', widget.wizardData.title ?? 'No especificado'),
                          const SizedBox(height: 8),
                          _buildInfoRow(
                            'Descripción',
                            widget.wizardData.description ?? 'No especificada',
                            maxLines: 3,
                          ),
                        ],
                      ),
                      onEdit: () => widget.onEditStep(1),
                    ),

                    // Fecha y horario (ahora es el paso 2)
                    _buildSummarySection(
                      title: 'Fecha y Horario',
                      icon: Icons.calendar_today,
                      content: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildInfoRow(
                            'Fecha inicio',
                            widget.wizardData.startDate != null
                                ? DateFormat('EEEE, d MMMM yyyy', 'es')
                                    .format(widget.wizardData.startDate!)
                                : 'No especificada',
                          ),
                          if (widget.wizardData.endDate != null) ...[
                            const SizedBox(height: 8),
                            _buildInfoRow(
                              'Fecha fin',
                              DateFormat('EEEE, d MMMM yyyy', 'es')
                                  .format(widget.wizardData.endDate!),
                            ),
                          ],
                          if (widget.wizardData.time != null) ...[
                            const SizedBox(height: 8),
                            _buildInfoRow(
                              'Hora',
                              widget.wizardData.time!.format(context),
                            ),
                          ],
                        ],
                      ),
                      onEdit: () => widget.onEditStep(2),
                    ),

                    // Categoría
                    _buildSummarySection(
                      title: 'Categoría y Tipo',
                      icon: Icons.category,
                      content: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildInfoRow(
                            'Categoría',
                            widget.wizardData.category?.name ?? 'No especificada',
                          ),
                          const SizedBox(height: 8),
                          _buildInfoRow(
                            'Tipo',
                            widget.wizardData.isFree ? 'Gratuito' : 'De pago',
                          ),
                        ],
                      ),
                      onEdit: () => widget.onEditStep(3),
                    ),

                    // Imagen
                    if (widget.wizardData.imageFile != null)
                      _buildSummarySection(
                        title: 'Imagen',
                        icon: Icons.image,
                        content: ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Image.file(
                            widget.wizardData.imageFile!,
                            height: 150,
                            width: double.infinity,
                            fit: BoxFit.cover,
                          ),
                        ),
                        onEdit: () => widget.onEditStep(4),
                      ),

                    const SizedBox(height: 24),

                    // Captcha
                    Card(
                      child: CheckboxListTile(
                        title: const Text('No soy un robot'),
                        value: _captchaValidated,
                        onChanged: (bool? value) {
                          if (value == true && !_captchaValidated) {
                            _showCaptchaDialog();
                          } else if (value == false) {
                            setState(() {
                              _captchaValidated = false;
                            });
                          }
                        },
                        controlAffinity: ListTileControlAffinity.leading,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Botones
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
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton(
                            onPressed: _isSubmitting ? null : widget.onBack,
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
                            onPressed: (_isSubmitting || _isUploadingImage || !_captchaValidated)
                                ? null
                                : _handleSubmit,
                            style: ElevatedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(vertical: 16),
                            ),
                            child: _isSubmitting || _isUploadingImage
                                ? const SizedBox(
                                    width: 20,
                                    height: 20,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                                    ),
                                  )
                                : const Text('Crear Evento'),
                          ),
                        ),
                      ],
                    ),
                    if (_isUploadingImage)
                      Padding(
                        padding: const EdgeInsets.only(top: 8),
                        child: Text(
                          'Subiendo imagen...',
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
    );
  }

  Widget _buildInfoRow(String label, String value, {int? maxLines}) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 100,
          child: Text(
            '$label:',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: Theme.of(context).textTheme.bodyMedium,
            maxLines: maxLines,
            overflow: maxLines != null ? TextOverflow.ellipsis : null,
          ),
        ),
      ],
    );
  }
}

