import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show debugPrint;
import 'package:intl/intl.dart';
import '../event_wizard_screen.dart';

class Step2DateTime extends StatefulWidget {
  final EventWizardData wizardData;
  final VoidCallback onNext;
  final VoidCallback onBack;

  const Step2DateTime({
    super.key,
    required this.wizardData,
    required this.onNext,
    required this.onBack,
  });

  @override
  State<Step2DateTime> createState() => _Step2DateTimeState();
}

class _Step2DateTimeState extends State<Step2DateTime> {
  DateTime? _startDate;
  DateTime? _endDate;
  TimeOfDay? _selectedTime;
  bool _hasDailyProgram = false;
  List<DateTime> _eventDays = [];
  final Map<DateTime, TextEditingController> _dailyProgramControllers = {};

  @override
  void initState() {
    super.initState();
    // Cargar datos existentes
    _startDate = widget.wizardData.startDate;
    _endDate = widget.wizardData.endDate;
    _selectedTime = widget.wizardData.time;
    _hasDailyProgram = widget.wizardData.hasDailyProgram;
    _dailyProgramControllers.addAll(widget.wizardData.dailyPrograms.map(
      (date, program) => MapEntry(date, TextEditingController(text: program)),
    ));
    _updateEventDays();
  }

  @override
  void dispose() {
    for (var controller in _dailyProgramControllers.values) {
      controller.dispose();
    }
    _dailyProgramControllers.clear();
    super.dispose();
  }

  void _updateEventDays() {
    if (_startDate == null) {
      _eventDays = [];
      return;
    }

    if (_endDate == null || _endDate == _startDate) {
      _eventDays = [_startDate!];
    } else {
      _eventDays = [];
      DateTime current = DateTime(
        _startDate!.year,
        _startDate!.month,
        _startDate!.day,
      );
      final finalDate = DateTime(
        _endDate!.year,
        _endDate!.month,
        _endDate!.day,
      );

      while (!current.isAfter(finalDate)) {
        _eventDays.add(DateTime(current.year, current.month, current.day));
        current = current.add(const Duration(days: 1));
      }
    }

    // Asegurar que todos los días tengan un controlador
    for (var day in _eventDays) {
      if (!_dailyProgramControllers.containsKey(day)) {
        _dailyProgramControllers[day] = TextEditingController();
      }
    }

    // Eliminar controladores de días que ya no están
    final daysToRemove = _dailyProgramControllers.keys
        .where((day) => !_eventDays.contains(day))
        .toList();
    for (var day in daysToRemove) {
      _dailyProgramControllers[day]?.dispose();
      _dailyProgramControllers.remove(day);
    }

    setState(() {});
  }

  bool _validate() {
    if (_startDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Por favor, selecciona una fecha de inicio'),
          backgroundColor: Colors.orange,
        ),
      );
      return false;
    }
    return true;
  }

  void _handleNext() {
    if (_validate()) {
      // Guardar datos
      widget.wizardData.startDate = _startDate;
      widget.wizardData.endDate = _endDate;
      widget.wizardData.time = _selectedTime;
      widget.wizardData.hasDailyProgram = _hasDailyProgram;
      widget.wizardData.dailyPrograms = _dailyProgramControllers.map(
        (date, controller) => MapEntry(
          date,
          controller.text.trim(),
        ),
      );
      widget.wizardData.stepValidated[1] = true;
      
      widget.onNext();
    }
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
                      'Fecha y Horario',
                      style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '¿Cuándo se realizará tu evento?',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                    ),
                    const SizedBox(height: 32),

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
                            : 'Seleccionar fecha de inicio *',
                      ),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        minimumSize: const Size(double.infinity, 56),
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Selector de fecha de fin
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
                        minimumSize: const Size(double.infinity, 56),
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
                    const SizedBox(height: 16),

                    // Selector de hora
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
                        minimumSize: const Size(double.infinity, 56),
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
                    const SizedBox(height: 24),

                    // Programación diaria
                    if (_startDate != null && _endDate != null && _eventDays.length > 1)
                      Card(
                        child: SwitchListTile(
                          title: const Text('Programación diaria'),
                          subtitle: const Text(
                            'Añade contenido específico para cada día del evento',
                          ),
                          value: _hasDailyProgram,
                          onChanged: (value) {
                            setState(() {
                              _hasDailyProgram = value;
                            });
                          },
                        ),
                      ),

                    // Campos de programación diaria
                    if (_hasDailyProgram && _eventDays.length > 1) ...[
                      const SizedBox(height: 16),
                      Text(
                        'Programación por día',
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 12),
                      ..._eventDays.map((day) {
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                DateFormat('EEEE, d MMMM yyyy', 'es').format(day),
                                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 8),
                              TextField(
                                controller: _dailyProgramControllers[day],
                                decoration: InputDecoration(
                                  hintText: 'Describe lo que pasará este día...',
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                ),
                                maxLines: 3,
                              ),
                            ],
                          ),
                        );
                      }).toList(),
                    ],
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

