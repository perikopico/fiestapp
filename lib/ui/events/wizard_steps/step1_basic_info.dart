import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show debugPrint;
import '../event_wizard_screen.dart';

class Step1BasicInfo extends StatefulWidget {
  final EventWizardData wizardData;
  final VoidCallback onNext;
  final VoidCallback? onBack;

  const Step1BasicInfo({
    super.key,
    required this.wizardData,
    required this.onNext,
    this.onBack,
  });

  @override
  State<Step1BasicInfo> createState() => _Step1BasicInfoState();
}

class _Step1BasicInfoState extends State<Step1BasicInfo> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  String? _titleError;
  String? _descriptionError;

  @override
  void initState() {
    super.initState();
    // Cargar datos existentes si hay
    if (widget.wizardData.title != null) {
      _titleController.text = widget.wizardData.title!;
    }
    if (widget.wizardData.description != null) {
      _descriptionController.text = widget.wizardData.description!;
    }

    // Listeners para validación en tiempo real
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
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  bool _validate() {
    bool isValid = true;

    // Validar título
    if (_titleController.text.trim().isEmpty) {
      _titleError = 'El título es obligatorio';
      isValid = false;
    } else {
      _titleError = null;
    }

    // Validar descripción
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

    return isValid;
  }

  void _handleNext() {
    if (_validate()) {
      // Guardar datos
      widget.wizardData.title = _titleController.text.trim();
      widget.wizardData.description = _descriptionController.text.trim();
      widget.wizardData.stepValidated[0] = true;
      
      // Avanzar al siguiente paso
      widget.onNext();
    } else {
      setState(() {});
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Por favor, completa todos los campos obligatorios'),
          backgroundColor: Colors.orange,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Form(
          key: _formKey,
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
                        'Información Básica',
                        style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Ahora describe tu evento',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Theme.of(context).colorScheme.onSurfaceVariant,
                        ),
                      ),
                      const SizedBox(height: 32),

                      // Campo de título
                      TextFormField(
                        controller: _titleController,
                        decoration: InputDecoration(
                          labelText: 'Título del evento *',
                          hintText: 'Ej: Festival de Verano',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          errorText: _titleError,
                          prefixIcon: const Icon(Icons.title),
                        ),
                        textCapitalization: TextCapitalization.sentences,
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'El título es obligatorio';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 24),

                      // Campo de descripción
                      TextFormField(
                        controller: _descriptionController,
                        decoration: InputDecoration(
                          labelText: 'Descripción *',
                          hintText: 'Describe tu evento en detalle...',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          alignLabelWithHint: true,
                          errorText: _descriptionError,
                          helperText: _descriptionController.text.isEmpty
                              ? 'Mínimo 20 caracteres'
                              : '${_descriptionController.text.length}/20 caracteres',
                          prefixIcon: const Icon(Icons.description),
                        ),
                        maxLines: 6,
                        minLines: 4,
                        textCapitalization: TextCapitalization.sentences,
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'La descripción es obligatoria';
                          }
                          if (value.trim().length < 20) {
                            return 'La descripción debe tener al menos 20 caracteres';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 24),

                      // Información adicional
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
                                  'Una buena descripción ayuda a que más personas encuentren tu evento',
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
      ),
    );
  }
}

