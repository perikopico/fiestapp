import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show debugPrint;
import '../../../services/category_service.dart';
import '../../../models/category.dart';
import '../event_wizard_screen.dart';

class Step4Category extends StatefulWidget {
  final EventWizardData wizardData;
  final VoidCallback onNext;
  final VoidCallback onBack;

  const Step4Category({
    super.key,
    required this.wizardData,
    required this.onNext,
    required this.onBack,
  });

  @override
  State<Step4Category> createState() => _Step4CategoryState();
}

class _Step4CategoryState extends State<Step4Category> {
  final CategoryService _categoryService = CategoryService();
  List<Category> _categories = [];
  bool _isLoading = true;
  Category? _selectedCategory;
  bool _isFree = true;

  @override
  void initState() {
    super.initState();
    _loadCategories();
    _selectedCategory = widget.wizardData.category;
    _isFree = widget.wizardData.isFree;
  }

  Future<void> _loadCategories() async {
    try {
      final categories = await _categoryService.getCategories();
      setState(() {
        _categories = categories;
        _isLoading = false;
      });
    } catch (e) {
      debugPrint('Error al cargar categorías: $e');
      setState(() {
        _isLoading = false;
      });
    }
  }

  String _getCategoryDescription(String categoryName) {
    final descriptions = {
      'Música': 'Conciertos, festivales, DJs, música en vivo',
      'Deportes': 'Partidos, competiciones, eventos deportivos',
      'Cultura': 'Teatro, exposiciones, conferencias, arte',
      'Gastronomía': 'Ferias gastronómicas, degustaciones, eventos culinarios',
      'Fiesta': 'Fiestas populares, celebraciones, eventos festivos',
      'Otros': 'Otros tipos de eventos',
    };
    return descriptions[categoryName] ?? 'Eventos de $categoryName';
  }

  bool _validate() {
    if (_selectedCategory == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Por favor, selecciona una categoría'),
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
      widget.wizardData.category = _selectedCategory;
      widget.wizardData.isFree = _isFree;
      widget.wizardData.stepValidated[3] = true;
      
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
                      'Categoría y Tipo',
                      style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Clasifica tu evento',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                    ),
                    const SizedBox(height: 32),

                    // Selector de categoría
                    if (_isLoading)
                      const Center(child: CircularProgressIndicator())
                    else
                      DropdownButtonFormField<Category>(
                        decoration: InputDecoration(
                          labelText: 'Categoría *',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          prefixIcon: const Icon(Icons.category),
                        ),
                        value: _selectedCategory,
                        selectedItemBuilder: (BuildContext context) {
                          return _categories
                              .where((Category c) => c.id != null)
                              .map<Widget>((Category category) {
                            return Text(
                              category.name,
                              overflow: TextOverflow.ellipsis,
                            );
                          }).toList();
                        },
                        items: _categories
                            .where((Category c) => c.id != null)
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
                          });
                        },
                      ),
                    const SizedBox(height: 24),

                    // Tipo de evento
                    Card(
                      child: SwitchListTile(
                        title: const Text('Evento gratuito'),
                        subtitle: const Text(
                          'Marca si el evento es de acceso libre',
                        ),
                        value: _isFree,
                        onChanged: (value) {
                          setState(() {
                            _isFree = value;
                          });
                        },
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

