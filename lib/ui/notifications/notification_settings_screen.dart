// lib/ui/notifications/notification_settings_screen.dart
import 'package:flutter/material.dart';
import '../../models/notification_rule.dart';
import '../../models/category.dart';
import '../../services/notification_preferences_service.dart';
import '../../services/category_service.dart';
import '../../services/city_service.dart';
import '../common/app_bar_logo.dart';
import '../dashboard/widgets/bottom_nav_bar.dart';
import 'widgets/notification_rule_card.dart';

class NotificationSettingsScreen extends StatefulWidget {
  const NotificationSettingsScreen({super.key});

  @override
  State<NotificationSettingsScreen> createState() =>
      _NotificationSettingsScreenState();
}

class _NotificationSettingsScreenState
    extends State<NotificationSettingsScreen> {
  final _prefsService = NotificationPreferencesService.instance;
  final _categoryService = CategoryService();
  final _cityService = CityService.instance;

  bool _notificationsEnabled = true;
  bool _notifyForFavorites = true;
  List<NotificationRule> _rules = [];
  List<Category> _categories = [];
  List<City> _allCities = [];
  bool _isLoading = true;
  bool _isSaving = false;

  // Default province (Cádiz)
  static const int _defaultProvinceId = 1;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    setState(() => _isLoading = true);

    try {
      // Cargar preferencias
      final prefs = await _prefsService.loadPreferences();
      _notificationsEnabled = prefs['notificationsEnabled'] as bool;
      _notifyForFavorites = prefs['notifyForFavorites'] as bool;

      // Cargar categorías
      _categories = await _categoryService.fetchAll();

      // Cargar ciudades
      _allCities = await _cityService.fetchCities();

      // Cargar reglas
      _rules = await _prefsService.loadNotificationRules();

      // Si no hay reglas, crear una por defecto
      if (_rules.isEmpty) {
        final allCityIds = _allCities
            .where((c) => c.provinceId == _defaultProvinceId)
            .map((c) => c.id)
            .toList();
        final allCategoryIds = _categories
            .where((c) => c.id != null)
            .map((c) => c.id!)
            .toList();

        final defaultRule = await _prefsService.createDefaultRule(
          provinceId: _defaultProvinceId,
          allCityIds: allCityIds,
          allCategoryIds: allCategoryIds,
        );
        _rules = [defaultRule];
      }
    } catch (e) {
      debugPrint('Error al cargar datos: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error al cargar configuración: $e'),
        ),
      );
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  Future<void> _savePreferences() async {
    // Validar reglas activas
    final invalidRules = _rules
        .where((r) => r.isActive && !r.isValid)
        .toList();

    if (invalidRules.isNotEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Hay reglas activas sin ciudades o categorías seleccionadas. Corrígelas antes de guardar.',
          ),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    setState(() => _isSaving = true);

    try {
      // Guardar preferencias
      await _prefsService.savePreferences(
        notificationsEnabled: _notificationsEnabled,
        notifyForFavorites: _notifyForFavorites,
      );

      // Guardar reglas
      await _prefsService.saveNotificationRules(_rules);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Preferencias guardadas correctamente'),
            backgroundColor: Colors.green,
          ),
        );
        Navigator.of(context).pop();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error al guardar: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isSaving = false);
      }
    }
  }

  void _addRule() {
    final newRule = NotificationRule(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      provinceId: _defaultProvinceId,
      cityIds: [],
      categoryIds: [],
      isActive: true,
    );
    setState(() {
      _rules.add(newRule);
    });
  }

  void _updateRule(NotificationRule updatedRule) {
    setState(() {
      final index = _rules.indexWhere((r) => r.id == updatedRule.id);
      if (index != -1) {
        _rules[index] = updatedRule;
      }
    });
  }

  void _deleteRule(String ruleId) {
    setState(() {
      _rules.removeWhere((r) => r.id == ruleId);
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Scaffold(
        appBar: AppBar(
          title: const AppBarLogo(),
          centerTitle: true,
          elevation: 0,
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        ),
        body: const Center(child: CircularProgressIndicator()),
        bottomNavigationBar: const BottomNavBar(activeRoute: 'notifications'),
      );
    }

    final theme = Theme.of(context);

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
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // A) Global switch block
            _buildGlobalSwitchBlock(theme),

            const SizedBox(height: 32),

            // B) Rules block
            _buildRulesBlock(theme),

            const SizedBox(height: 32),

            // C) Favorites notifications block
            _buildFavoritesBlock(theme),

            const SizedBox(height: 32),

            // Info text
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: theme.colorScheme.surfaceVariant.withOpacity(0.3),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                'Te avisaremos cuando se publiquen eventos que coincidan con al menos una de tus reglas (provincia, ciudades y categorías seleccionadas) y cuando haya novedades en tus eventos favoritos si tienes la opción activada.',
                style: theme.textTheme.bodySmall,
              ),
            ),

            const SizedBox(height: 24),

            // Botón Guardar
            SizedBox(
              width: double.infinity,
              child: FilledButton(
                onPressed: _isSaving ? null : _savePreferences,
                style: FilledButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
                child: _isSaving
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Text(
                        'Guardar preferencias',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
              ),
            ),

            const SizedBox(height: 32),
          ],
        ),
      ),
      bottomNavigationBar: const BottomNavBar(activeRoute: 'notifications'),
    );
  }

  Widget _buildGlobalSwitchBlock(ThemeData theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Notificaciones',
          style: theme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: Text(
                'Recibir notificaciones',
                style: theme.textTheme.bodyLarge,
              ),
            ),
            Switch(
              value: _notificationsEnabled,
              onChanged: (value) {
                setState(() {
                  _notificationsEnabled = value;
                });
              },
            ),
          ],
        ),
        const SizedBox(height: 8),
        Text(
          'Si desactivas esta opción, no te avisaremos de nuevos eventos.',
          style: theme.textTheme.bodySmall?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
          ),
        ),
      ],
    );
  }

  Widget _buildRulesBlock(ThemeData theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Reglas de notificación',
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w700,
              ),
            ),
            if (!_notificationsEnabled)
              Text(
                'Desactivadas',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
          ],
        ),
        const SizedBox(height: 8),
        Text(
          'Crea reglas para elegir de qué provincias, ciudades y categorías quieres recibir avisos.',
          style: theme.textTheme.bodyMedium?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
          ),
        ),
        const SizedBox(height: 16),
        ..._rules.asMap().entries.map((entry) {
          return NotificationRuleCard(
            key: ValueKey(entry.value.id),
            rule: entry.value,
            ruleIndex: entry.key,
            allCities: _allCities,
            allCategories: _categories,
            onChanged: _updateRule,
            onDelete: _deleteRule,
            isDisabled: !_notificationsEnabled,
          );
        }),
        if (_notificationsEnabled) ...[
          const SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              onPressed: _addRule,
              icon: const Icon(Icons.add),
              label: const Text('Agregar regla'),
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildFavoritesBlock(ThemeData theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Eventos favoritos',
          style: theme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: Text(
                'Recibir recordatorios de mis eventos favoritos',
                style: theme.textTheme.bodyLarge,
              ),
            ),
            Switch(
              value: _notifyForFavorites,
              onChanged: (value) {
                setState(() {
                  _notifyForFavorites = value;
                });
              },
            ),
          ],
        ),
        const SizedBox(height: 8),
        Text(
          'Te avisaremos cuando se acerque la fecha o haya cambios importantes en los eventos que has marcado como favoritos.',
          style: theme.textTheme.bodySmall?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
          ),
        ),
      ],
    );
  }
}

