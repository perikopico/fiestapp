import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../services/notification_alerts_service.dart';
import '../../services/category_service.dart';
import '../../models/category.dart' as models;
import '../../services/logger_service.dart';
import '../../l10n/app_localizations.dart';
import '../common/app_bar_logo.dart';

/// Pantalla de "Mis Alertas" para gestionar notificaciones por categoría
class AlertsScreen extends StatefulWidget {
  const AlertsScreen({super.key});

  @override
  State<AlertsScreen> createState() => _AlertsScreenState();
}

class _AlertsScreenState extends State<AlertsScreen> {
  final NotificationAlertsService _alertsService = NotificationAlertsService.instance;
  final CategoryService _categoryService = CategoryService();
  
  List<models.Category> _categories = [];
  Map<int, bool> _categoryStates = {};
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadCategoriesAndStates();
  }

  Future<void> _loadCategoriesAndStates() async {
    setState(() => _isLoading = true);
    
    try {
      // Cargar categorías
      final categories = await _categoryService.fetchAll();
      
      // Cargar estados de alertas para cada categoría
      final states = <int, bool>{};
      for (final category in categories) {
        if (category.id != null) {
          final isEnabled = await _alertsService.isCategoryAlertEnabled(category.id!);
          states[category.id!] = isEnabled;
        }
      }
      
      if (mounted) {
        setState(() {
          _categories = categories;
          _categoryStates = states;
          _isLoading = false;
        });
      }
    } catch (e) {
      LoggerService.instance.error('Error al cargar categorías y estados', error: e);
      if (mounted) {
        setState(() => _isLoading = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error al cargar las alertas: $e'),
            backgroundColor: Theme.of(context).colorScheme.error,
          ),
        );
      }
    }
  }

  Future<void> _toggleCategoryAlert(int categoryId, bool newValue) async {
    // Feedback háptico
    HapticFeedback.lightImpact();
    
    // Actualizar estado local inmediatamente
    setState(() {
      _categoryStates[categoryId] = newValue;
    });
    
    // Guardar en persistencia
    await _alertsService.setCategoryAlertEnabled(categoryId, newValue);
    
    // Mostrar feedback visual
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            newValue
                ? 'Te avisaremos de eventos de esta categoría'
                : 'Has dejado de recibir alertas de esta categoría',
          ),
          duration: const Duration(seconds: 2),
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        title: const AppBarLogo(),
        centerTitle: true,
        elevation: 0,
        backgroundColor: theme.scaffoldBackgroundColor,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _categories.isEmpty
              ? Center(
                  child: Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.notifications_off,
                          size: 64,
                          color: Theme.of(context).colorScheme.onSurfaceVariant.withOpacity(0.5),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'No hay categorías disponibles',
                          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            color: Theme.of(context).colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              : ListView(
                  padding: const EdgeInsets.all(16),
                  children: [
                    // Descripción
                    Card(
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
                                'Activa las alertas para recibir notificaciones sobre eventos de las categorías que te interesan.',
                                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    // Lista de categorías
                    ..._categories.where((c) => c.id != null).map((category) {
                      final categoryId = category.id!;
                      final isEnabled = _categoryStates[categoryId] ?? false;
                      
                      return Card(
                        margin: const EdgeInsets.only(bottom: 8),
                        child: SwitchListTile(
                          title: Text(
                            category.name,
                            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          subtitle: Text(
                            'Recibir notificaciones de eventos de ${category.name.toLowerCase()}',
                            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: Theme.of(context).colorScheme.onSurfaceVariant,
                            ),
                          ),
                          value: isEnabled,
                          onChanged: (value) => _toggleCategoryAlert(categoryId, value),
                          secondary: Icon(
                            Icons.category,
                            color: isEnabled
                                ? Theme.of(context).colorScheme.primary
                                : Theme.of(context).colorScheme.onSurfaceVariant,
                          ),
                        ),
                      );
                    }),
                  ],
                ),
    );
  }
}
