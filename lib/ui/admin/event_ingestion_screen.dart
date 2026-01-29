import 'dart:io';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import '../../services/event_ingestion_service.dart';
import '../../services/city_service.dart';
import '../common/app_bar_logo.dart';

class EventIngestionScreen extends StatefulWidget {
  const EventIngestionScreen({super.key});

  @override
  State<EventIngestionScreen> createState() => _EventIngestionScreenState();
}

class _EventIngestionScreenState extends State<EventIngestionScreen> {
  final _ingestionService = EventIngestionService.instance;
  final _cityService = CityService.instance;
  
  String? _selectedFilePath;
  String? _jsonContent;
  final TextEditingController _jsonTextController = TextEditingController();
  bool _isProcessing = false;
  String? _error;
  IngestionSummary? _summary;
  List<City> _cities = [];
  String? _selectedCityName;
  bool _isLoadingCities = false;
  bool _useFileUpload = true; // true = archivo, false = texto pegado

  @override
  void initState() {
    super.initState();
    _loadCities();
    _jsonTextController.addListener(() {
      if (_jsonTextController.text.isNotEmpty) {
        setState(() {
          _jsonContent = _jsonTextController.text;
          _selectedFilePath = null; // Limpiar archivo si se pega texto
        });
      }
    });
  }

  @override
  void dispose() {
    _jsonTextController.dispose();
    super.dispose();
  }

  Future<void> _loadCities() async {
    setState(() => _isLoadingCities = true);
    try {
      final cities = await _cityService.fetchCities();
      if (mounted) {
        setState(() {
          _cities = cities;
          _isLoadingCities = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _error = 'Error al cargar ciudades: $e';
          _isLoadingCities = false;
        });
      }
    }
  }

  Future<void> _pickJsonFile() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['json'],
        withData: true,
      );

      if (result != null && result.files.single.path != null) {
        final file = result.files.single;
        
        String? fileContent = file.bytes != null 
            ? String.fromCharCodes(file.bytes!)
            : null;

        // Si no hay contenido pero hay path, intentar leerlo
        if (fileContent == null && file.path != null && !kIsWeb) {
          final fileData = File(file.path!);
          fileContent = await fileData.readAsString();
        }

        if (mounted) {
          setState(() {
            _selectedFilePath = file.path ?? file.name;
            _jsonContent = fileContent;
            _jsonTextController.clear(); // Limpiar texto pegado si se carga archivo
            _error = null;
            _summary = null;
            _useFileUpload = true;
          });
        }
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _error = 'Error al seleccionar archivo: $e';
        });
      }
    }
  }

  void _onJsonTextChanged(String text) {
    setState(() {
      if (text.isNotEmpty) {
        _jsonContent = text;
        _selectedFilePath = null; // Limpiar archivo si se pega texto
        _useFileUpload = false;
        _error = null;
        _summary = null;
      } else {
        _jsonContent = null;
      }
    });
  }

  Future<void> _processJson() async {
    if (_jsonContent == null || _jsonContent!.isEmpty) {
      setState(() {
        _error = 'Por favor, selecciona un archivo JSON primero';
      });
      return;
    }

    setState(() {
      _isProcessing = true;
      _error = null;
      _summary = null;
    });

    try {
      final summary = await _ingestionService.processEventsJson(
        _jsonContent!,
        defaultCityName: _selectedCityName,
      );

      if (mounted) {
        setState(() {
          _summary = summary;
          _isProcessing = false;
        });

        // Mostrar diálogo con resultados
        _showResultsDialog(summary);
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _error = e.toString();
          _isProcessing = false;
        });
      }
    }
  }

  void _showResultsDialog(IngestionSummary summary) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Resultado del Procesamiento'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Total de eventos: ${summary.total}'),
              const SizedBox(height: 8),
              Text(
                'Exitosos: ${summary.success}',
                style: TextStyle(color: Colors.green[700]),
              ),
              const SizedBox(height: 4),
              Text(
                'Fallidos: ${summary.failed}',
                style: TextStyle(color: Colors.red[700]),
              ),
              if (summary.failed > 0) ...[
                const SizedBox(height: 16),
                const Text(
                  'Errores:',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                ...summary.results
                    .where((r) => !r.success)
                    .take(10)
                    .map((r) => Padding(
                          padding: const EdgeInsets.only(bottom: 4),
                          child: Text(
                            'ID ${r.eventId}: ${r.error ?? "Error desconocido"}',
                            style: const TextStyle(fontSize: 12),
                          ),
                        )),
              ],
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cerrar'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const AppBarLogo(),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Instrucciones',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      '1. Selecciona un archivo JSON con eventos en el formato correcto\n'
                      '2. (Opcional) Selecciona una ciudad por defecto\n'
                      '3. Procesa el archivo para insertar/actualizar eventos en la base de datos',
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            
            // Selector de ciudad
            if (_isLoadingCities)
              const Center(child: CircularProgressIndicator())
            else if (_cities.isNotEmpty)
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Ciudad por defecto (Opcional)',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        'Si no se puede determinar la ciudad automáticamente, se usará esta:',
                        style: TextStyle(fontSize: 12),
                      ),
                      const SizedBox(height: 8),
                      DropdownButtonFormField<String>(
                        value: _selectedCityName,
                        decoration: const InputDecoration(
                          labelText: 'Seleccionar ciudad',
                          border: OutlineInputBorder(),
                        ),
                        items: [
                          const DropdownMenuItem<String>(
                            value: null,
                            child: Text('Ninguna (detección automática)'),
                          ),
                          ..._cities.map((city) => DropdownMenuItem<String>(
                                value: city.name,
                                child: Text(city.name),
                              )),
                        ],
                        onChanged: (value) {
                          setState(() {
                            _selectedCityName = value;
                          });
                        },
                      ),
                    ],
                  ),
                ),
              ),
            
            const SizedBox(height: 16),
            
            // Selector de archivo o texto JSON
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'JSON de Eventos',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    
                    // Tabs para alternar entre archivo y texto
                    Row(
                      children: [
                        Expanded(
                          child: ChoiceChip(
                            label: const Text('Cargar archivo'),
                            selected: _useFileUpload,
                            onSelected: (selected) {
                              if (selected) {
                                setState(() {
                                  _useFileUpload = true;
                                  _jsonTextController.clear();
                                  _jsonContent = null;
                                  _selectedFilePath = null;
                                });
                              }
                            },
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: ChoiceChip(
                            label: const Text('Pegar JSON'),
                            selected: !_useFileUpload,
                            onSelected: (selected) {
                              if (selected) {
                                setState(() {
                                  _useFileUpload = false;
                                  _selectedFilePath = null;
                                  _jsonContent = _jsonTextController.text.isNotEmpty 
                                      ? _jsonTextController.text 
                                      : null;
                                });
                              }
                            },
                          ),
                        ),
                      ],
                    ),
                    
                    const SizedBox(height: 16),
                    
                    // Contenido según el modo seleccionado
                    if (_useFileUpload) ...[
                      OutlinedButton.icon(
                        onPressed: _isProcessing ? null : _pickJsonFile,
                        icon: const Icon(Icons.upload_file),
                        label: const Text('Seleccionar archivo JSON'),
                      ),
                      if (_selectedFilePath != null) ...[
                        const SizedBox(height: 8),
                        Text(
                          'Archivo seleccionado: ${_selectedFilePath!.split('/').last}',
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                        if (_jsonContent != null) ...[
                          const SizedBox(height: 4),
                          Text(
                            'Tamaño: ${_jsonContent!.length} caracteres',
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                        ],
                      ],
                    ] else ...[
                      TextField(
                        controller: _jsonTextController,
                        decoration: InputDecoration(
                          labelText: 'Pega aquí el contenido JSON',
                          hintText: 'Ejemplo: [{"id": 1, "status": "new", ...}]',
                          border: const OutlineInputBorder(),
                          helperText: 'Pega el JSON completo aquí',
                        ),
                        maxLines: 15,
                        minLines: 10,
                        onChanged: _onJsonTextChanged,
                        enabled: !_isProcessing,
                        style: const TextStyle(
                          fontFamily: 'monospace',
                          fontSize: 12,
                        ),
                      ),
                      if (_jsonTextController.text.isNotEmpty) ...[
                        const SizedBox(height: 8),
                        Text(
                          'Tamaño: ${_jsonTextController.text.length} caracteres',
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                      ],
                    ],
                  ],
                ),
              ),
            ),
            
            const SizedBox(height: 16),
            
            // Botón de procesar
            ElevatedButton.icon(
              onPressed: _isProcessing || _jsonContent == null
                  ? null
                  : _processJson,
              icon: _isProcessing
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Icon(Icons.play_arrow),
              label: Text(_isProcessing ? 'Procesando...' : 'Procesar JSON'),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
            ),
            
            // Error
            if (_error != null) ...[
              const SizedBox(height: 16),
              Card(
                color: Theme.of(context).colorScheme.errorContainer,
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    children: [
                      Icon(
                        Icons.error_outline,
                        color: Theme.of(context).colorScheme.onErrorContainer,
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          _error!,
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.onErrorContainer,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
            
            // Resumen (si existe)
            if (_summary != null) ...[
              const SizedBox(height: 16),
              Card(
                color: _summary!.failed == 0
                    ? Colors.green.shade50
                    : Colors.orange.shade50,
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Resumen',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: _summary!.failed == 0
                              ? Colors.green.shade900
                              : Colors.orange.shade900,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text('Total: ${_summary!.total}'),
                      Text(
                        'Exitosos: ${_summary!.success}',
                        style: TextStyle(color: Colors.green[700]),
                      ),
                      if (_summary!.failed > 0)
                        Text(
                          'Fallidos: ${_summary!.failed}',
                          style: TextStyle(color: Colors.red[700]),
                        ),
                    ],
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
