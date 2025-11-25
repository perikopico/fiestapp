// lib/ui/notifications/widgets/notification_rule_card.dart
import 'package:flutter/material.dart';
import '../../../models/notification_rule.dart';
import '../../../models/category.dart';
import '../../../services/city_service.dart';

class NotificationRuleCard extends StatefulWidget {
  final NotificationRule rule;
  final int ruleIndex;
  final List<City> allCities;
  final List<Category> allCategories;
  final Function(NotificationRule) onChanged;
  final Function(String) onDelete;
  final bool isDisabled;

  const NotificationRuleCard({
    super.key,
    required this.rule,
    required this.ruleIndex,
    required this.allCities,
    required this.allCategories,
    required this.onChanged,
    required this.onDelete,
    this.isDisabled = false,
  });

  @override
  State<NotificationRuleCard> createState() => _NotificationRuleCardState();
}

class _NotificationRuleCardState extends State<NotificationRuleCard> {
  late NotificationRule _currentRule;
  List<City> _availableCities = [];

  @override
  void initState() {
    super.initState();
    _currentRule = widget.rule;
    _loadCitiesForProvince();
  }

  @override
  void didUpdateWidget(NotificationRuleCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.rule.provinceId != widget.rule.provinceId) {
      _currentRule = widget.rule;
      _loadCitiesForProvince();
    } else {
      _currentRule = widget.rule;
    }
  }

  Future<void> _loadCitiesForProvince() async {
    final cities = await CityService.instance
        .fetchCities(provinceId: _currentRule.provinceId);
    setState(() {
      _availableCities = cities;
    });
  }

  void _updateRule(NotificationRule updatedRule) {
    setState(() {
      _currentRule = updatedRule;
    });
    widget.onChanged(updatedRule);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final opacity = widget.isDisabled ? 0.5 : 1.0;

    return Opacity(
      opacity: opacity,
      child: Card(
        margin: const EdgeInsets.only(bottom: 16),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header con título, switch y botón eliminar
              Row(
                children: [
                  Expanded(
                    child: Text(
                      'Regla ${widget.ruleIndex + 1}',
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  Row(
                    children: [
                      Text(
                        'Activa',
                        style: theme.textTheme.bodySmall,
                      ),
                      const SizedBox(width: 8),
                      Switch(
                        value: _currentRule.isActive,
                        onChanged: widget.isDisabled
                            ? null
                            : (value) {
                                _updateRule(
                                  _currentRule.copyWith(isActive: value),
                                );
                              },
                      ),
                    ],
                  ),
                  IconButton(
                    icon: const Icon(Icons.delete_outline),
                    color: theme.colorScheme.error,
                    onPressed: widget.isDisabled
                        ? null
                        : () {
                            _confirmDelete();
                          },
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Selector de provincia
              Text(
                'Provincia',
                style: theme.textTheme.labelLarge,
              ),
              const SizedBox(height: 8),
              DropdownButtonFormField<int>(
                value: _currentRule.provinceId,
                decoration: InputDecoration(
                  hintText: 'Selecciona una provincia',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                items: const [
                  DropdownMenuItem(
                    value: 1,
                    child: Text('Cádiz'),
                  ),
                  // Agregar más provincias aquí cuando estén disponibles
                ],
                onChanged: widget.isDisabled
                    ? null
                    : (value) {
                        if (value != null) {
                          _updateRule(
                            _currentRule.copyWith(
                              provinceId: value,
                              cityIds: [], // Limpiar ciudades al cambiar provincia
                            ),
                          );
                          _loadCitiesForProvince();
                        }
                      },
              ),
              const SizedBox(height: 16),

              // Selector de ciudades (ListTile)
              InkWell(
                onTap: widget.isDisabled ? null : () => _showCitySelector(),
                borderRadius: BorderRadius.circular(8),
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 4),
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Ciudades',
                              style: theme.textTheme.labelLarge,
                            ),
                            const SizedBox(height: 4),
                            Text(
                              _getCitySummary(),
                              style: theme.textTheme.bodySmall?.copyWith(
                                color: theme.colorScheme.onSurfaceVariant,
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),
                      if (!widget.isDisabled)
                        Icon(
                          Icons.chevron_right,
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Selector de categorías (ListTile)
              InkWell(
                onTap: widget.isDisabled ? null : () => _showCategorySelector(),
                borderRadius: BorderRadius.circular(8),
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 4),
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Categorías',
                              style: theme.textTheme.labelLarge,
                            ),
                            const SizedBox(height: 4),
                            Text(
                              _getCategorySummary(),
                              style: theme.textTheme.bodySmall?.copyWith(
                                color: theme.colorScheme.onSurfaceVariant,
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),
                      if (!widget.isDisabled)
                        Icon(
                          Icons.chevron_right,
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                    ],
                  ),
                ),
              ),

              // Mensaje de error si la regla no es válida
              if (!_currentRule.isValid && _currentRule.isActive) ...[
                const SizedBox(height: 12),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.errorContainer,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(
                            Icons.error_outline,
                            size: 20,
                            color: theme.colorScheme.onErrorContainer,
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              _currentRule.cityIds.isEmpty && _currentRule.categoryIds.isEmpty
                                  ? 'Selecciona al menos una ciudad y una categoría para que esta regla tenga efecto.'
                                  : _currentRule.cityIds.isEmpty
                                      ? 'Selecciona al menos una ciudad para que esta regla tenga efecto.'
                                      : 'Selecciona al menos una categoría para que esta regla tenga efecto.',
                              style: theme.textTheme.bodySmall?.copyWith(
                                color: theme.colorScheme.onErrorContainer,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  String _getCitySummary() {
    if (_currentRule.cityIds.isEmpty) {
      return 'Ninguna ciudad seleccionada';
    }
    if (_currentRule.cityIds.length == _availableCities.length) {
      return 'Todas las ciudades seleccionadas';
    }
    final selectedCities = _availableCities
        .where((c) => _currentRule.cityIds.contains(c.id))
        .map((c) => c.name)
        .toList();
    if (selectedCities.length <= 3) {
      return selectedCities.join(', ');
    }
    return '${selectedCities.take(3).join(', ')} y ${selectedCities.length - 3} más';
  }

  String _getCategorySummary() {
    if (_currentRule.categoryIds.isEmpty) {
      return 'Ninguna categoría seleccionada';
    }
    final validCategories = widget.allCategories.where((c) => c.id != null).toList();
    if (_currentRule.categoryIds.length == validCategories.length) {
      return 'Todas las categorías seleccionadas';
    }
    final selectedCategories = validCategories
        .where((c) => c.id != null && _currentRule.categoryIds.contains(c.id))
        .map((c) => c.name)
        .toList();
    if (selectedCategories.length <= 3) {
      return selectedCategories.join(', ');
    }
    return '${selectedCategories.take(3).join(', ')} y ${selectedCategories.length - 3} más';
  }

  void _showCitySelector() {
    final selectedCityIds = Set<int>.from(_currentRule.cityIds);
    
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => StatefulBuilder(
        builder: (context, setModalState) {
          return Container(
            padding: const EdgeInsets.all(16),
            constraints: BoxConstraints(
              maxHeight: MediaQuery.of(context).size.height * 0.8,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Seleccionar ciudades',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close),
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    TextButton(
                      onPressed: () {
                        setModalState(() {
                          selectedCityIds.clear();
                          selectedCityIds.addAll(_availableCities.map((c) => c.id));
                        });
                      },
                      child: const Text('Seleccionar todas'),
                    ),
                    const SizedBox(width: 8),
                    TextButton(
                      onPressed: () {
                        setModalState(() {
                          selectedCityIds.clear();
                        });
                      },
                      child: const Text('Limpiar'),
                    ),
                  ],
                ),
                const Divider(),
                Flexible(
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: _availableCities.length,
                    itemBuilder: (context, index) {
                      final city = _availableCities[index];
                      final isSelected = selectedCityIds.contains(city.id);
                      return CheckboxListTile(
                        title: Text(city.name),
                        value: isSelected,
                        onChanged: (value) {
                          setModalState(() {
                            if (value == true) {
                              selectedCityIds.add(city.id);
                            } else {
                              selectedCityIds.remove(city.id);
                            }
                          });
                        },
                      );
                    },
                  ),
                ),
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      _updateRule(
                        _currentRule.copyWith(
                          cityIds: selectedCityIds.toList(),
                        ),
                      );
                      Navigator.of(context).pop();
                    },
                    child: const Text('Confirmar'),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  void _showCategorySelector() {
    final selectedCategoryIds = Set<int>.from(_currentRule.categoryIds);
    final validCategories = widget.allCategories.where((c) => c.id != null).toList();
    
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => StatefulBuilder(
        builder: (context, setModalState) {
          return Container(
            padding: const EdgeInsets.all(16),
            constraints: BoxConstraints(
              maxHeight: MediaQuery.of(context).size.height * 0.8,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Seleccionar categorías',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close),
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    TextButton(
                      onPressed: () {
                        setModalState(() {
                          selectedCategoryIds.clear();
                          selectedCategoryIds.addAll(
                            validCategories.map((c) => c.id!),
                          );
                        });
                      },
                      child: const Text('Seleccionar todas'),
                    ),
                    const SizedBox(width: 8),
                    TextButton(
                      onPressed: () {
                        setModalState(() {
                          selectedCategoryIds.clear();
                        });
                      },
                      child: const Text('Limpiar'),
                    ),
                  ],
                ),
                const Divider(),
                Flexible(
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: validCategories.length,
                    itemBuilder: (context, index) {
                      final category = validCategories[index];
                      final isSelected = selectedCategoryIds.contains(category.id);
                      return CheckboxListTile(
                        title: Text(category.name),
                        value: isSelected,
                        onChanged: (value) {
                          setModalState(() {
                            if (value == true) {
                              selectedCategoryIds.add(category.id!);
                            } else {
                              selectedCategoryIds.remove(category.id);
                            }
                          });
                        },
                      );
                    },
                  ),
                ),
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      _updateRule(
                        _currentRule.copyWith(
                          categoryIds: selectedCategoryIds.toList(),
                        ),
                      );
                      Navigator.of(context).pop();
                    },
                    child: const Text('Confirmar'),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  void _selectAllCities() {
    final allCityIds = _availableCities.map((c) => c.id).toList();
    _updateRule(_currentRule.copyWith(cityIds: allCityIds));
  }

  void _clearCities() {
    _updateRule(_currentRule.copyWith(cityIds: []));
  }

  void _selectAllCategories() {
    final allCategoryIds = widget.allCategories
        .where((c) => c.id != null)
        .map((c) => c.id!)
        .toList();
    _updateRule(_currentRule.copyWith(categoryIds: allCategoryIds));
  }

  void _clearCategories() {
    _updateRule(_currentRule.copyWith(categoryIds: []));
  }

  void _confirmDelete() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Eliminar regla'),
        content: const Text(
          '¿Estás seguro de que quieres eliminar esta regla?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              widget.onDelete(_currentRule.id);
            },
            style: TextButton.styleFrom(
              foregroundColor: Theme.of(context).colorScheme.error,
            ),
            child: const Text('Eliminar'),
          ),
        ],
      ),
    );
  }
}

