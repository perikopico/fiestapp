import 'dart:io' show File;
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show debugPrint;
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../../services/city_service.dart';
import '../../models/category.dart';
import '../../models/venue.dart';
import 'wizard_steps/step1_basic_info.dart';
import 'wizard_steps/step2_date_time.dart';
import 'wizard_steps/step3_location.dart';
import 'wizard_steps/step4_category.dart';
import 'wizard_steps/step5_image.dart';
import 'wizard_steps/step6_summary.dart';

/// Datos del evento que se van recopilando en el wizard
class EventWizardData {
  // Paso 1: Información básica
  String? title;
  String? description;
  
  // Paso 2: Fecha y horario
  DateTime? startDate;
  DateTime? endDate;
  TimeOfDay? time;
  bool hasDailyProgram = false;
  Map<DateTime, String> dailyPrograms = {};
  
  // Paso 3: Lugar y ubicación
  City? city;
  int? cityId;
  Venue? venue;
  String? placeText;
  double? lat;
  double? lng;
  
  // Paso 4: Categoría y tipo
  Category? category;
  bool isFree = true;
  
  // Paso 5: Imagen
  File? imageFile;
  String? imageUrl;
  String imageAlignment = 'center';
  
  // Paso 6: Confirmación
  bool captchaValidated = false;
  
  // Validación de pasos
  Map<int, bool> stepValidated = {};
  
  // Helper para obtener el nombre del lugar
  String getPlaceName() {
    if (venue != null) {
      return venue!.name;
    } else if (placeText != null && placeText!.trim().isNotEmpty) {
      return placeText!.trim();
    } else if (city != null) {
      return city!.name;
    }
    return '';
  }
  
  // Helper para obtener coordenadas finales
  double? getFinalLat() => lat ?? city?.lat;
  double? getFinalLng() => lng ?? city?.lng;
}

class EventWizardScreen extends StatefulWidget {
  const EventWizardScreen({super.key});

  @override
  State<EventWizardScreen> createState() => _EventWizardScreenState();
}

class _EventWizardScreenState extends State<EventWizardScreen> {
  int _currentStep = 0;
  final EventWizardData _wizardData = EventWizardData();
  final PageController _pageController = PageController();

  final List<Widget> _steps = [];

  @override
  void initState() {
    super.initState();
    _initializeSteps();
  }

  void _initializeSteps() {
    _steps.addAll([
      // Paso 1: Ciudad y Lugar (ahora es el primero)
      Step3Location(
        wizardData: _wizardData,
        onNext: _goToNextStep,
        onBack: _goToPreviousStep,
      ),
      // Paso 2: Información básica
      Step1BasicInfo(
        wizardData: _wizardData,
        onNext: _goToNextStep,
        onBack: _goToPreviousStep,
      ),
      // Paso 3: Fecha y hora
      Step2DateTime(
        wizardData: _wizardData,
        onNext: _goToNextStep,
        onBack: _goToPreviousStep,
      ),
      // Paso 4: Categoría
      Step4Category(
        wizardData: _wizardData,
        onNext: _goToNextStep,
        onBack: _goToPreviousStep,
      ),
      // Paso 5: Imagen
      Step5Image(
        wizardData: _wizardData,
        onNext: _goToNextStep,
        onBack: _goToPreviousStep,
      ),
      // Paso 6: Resumen
      Step6Summary(
        wizardData: _wizardData,
        onBack: _goToPreviousStep,
        onEditStep: _goToStep,
        onSubmit: _submitEvent,
      ),
    ]);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _goToNextStep() {
    if (_currentStep < _steps.length - 1) {
      setState(() {
        _currentStep++;
      });
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  void _goToPreviousStep() {
    if (_currentStep > 0) {
      setState(() {
        _currentStep--;
      });
      _pageController.previousPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      Navigator.of(context).pop();
    }
  }

  void _goToStep(int stepIndex) {
    if (stepIndex >= 0 && stepIndex < _steps.length) {
      setState(() {
        _currentStep = stepIndex;
      });
      _pageController.animateToPage(
        stepIndex,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  Future<void> _submitEvent() async {
    // La lógica de envío está en Step6Summary
    // Este método se llama desde allí
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Crear Evento'),
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () {
            // Mostrar diálogo de confirmación si hay datos
            final hasData = _wizardData.title != null ||
                _wizardData.startDate != null ||
                _wizardData.city != null;
            
            if (hasData) {
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text('¿Descartar cambios?'),
                  content: const Text(
                    'Si sales ahora, perderás todos los datos ingresados.',
                  ),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.of(context).pop(),
                      child: const Text('Cancelar'),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                        Navigator.of(context).pop();
                      },
                      child: const Text('Descartar'),
                    ),
                  ],
                ),
              );
            } else {
              Navigator.of(context).pop();
            }
          },
        ),
      ),
      body: Column(
        children: [
          // Indicador de progreso
          _buildProgressIndicator(),
          
          // Contenido del paso actual
          Expanded(
            child: PageView(
              controller: _pageController,
              physics: const NeverScrollableScrollPhysics(), // Deshabilitar swipe
              children: _steps,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProgressIndicator() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          // Texto de progreso
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Paso ${_currentStep + 1} de ${_steps.length}',
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                '${((_currentStep + 1) / _steps.length * 100).toInt()}%',
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                  color: Theme.of(context).colorScheme.primary,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          // Indicador visual de pasos
          Row(
            children: List.generate(
              _steps.length,
              (index) => Expanded(
                child: Container(
                  margin: EdgeInsets.only(
                    right: index < _steps.length - 1 ? 4 : 0,
                  ),
                  height: 4,
                  decoration: BoxDecoration(
                    color: index <= _currentStep
                        ? Theme.of(context).colorScheme.primary
                        : Theme.of(context).colorScheme.surfaceContainerHighest,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

