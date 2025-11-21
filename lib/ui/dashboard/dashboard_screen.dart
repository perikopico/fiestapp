import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' hide Category;
import 'package:geolocator/geolocator.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:fiestapp/services/event_service.dart';
import 'package:fiestapp/data/events_repository.dart';
import 'package:fiestapp/models/event.dart' as model;
import 'package:fiestapp/services/city_service.dart';
import '../../services/category_service.dart';
import '../../models/event.dart';
import '../../models/category.dart';
import 'widgets/hero_slider.dart';
import 'widgets/upcoming_list.dart';
import 'widgets/categories_grid.dart';
import 'widgets/popular_carousel.dart';
import 'widgets/unified_search_bar.dart';
import 'widgets/city_radio_toggle.dart';
import '../icons/icon_mapper.dart';
import 'package:fiestapp/ui/common/shimmer_widgets.dart';
import '../../utils/date_ranges.dart';
import 'package:intl/intl.dart';

import '../../utils/dashboard_utils.dart';
import '../admin/pending_events_screen.dart';
import '../../config/admin_config.dart';
import '../../services/favorites_service.dart';
import 'widgets/bottom_nav_bar.dart';

// ==== Búsqueda unificada ====
enum SearchMode { city, event }

// ==== Taglines por mes ====
final Map<String, List<String>> kMonthlyTaglines = {
  'january': [
    'Nuevo año, nuevos planes. Empieza fuerte con QuePlan.',
    'Enero lleno de eventos especiales',
    'Empieza el año con planes increíbles',
  ],
  'february': [
    'Febrero, mes de celebraciones',
    'Disfruta de los mejores eventos',
    'El amor está en el aire',
  ],
  'march': [
    'Marzo trae primavera y diversión',
    'Eventos para todos los gustos',
    'La primavera está aquí',
  ],
  'april': [
    'Abril, mes de fiestas',
    'Disfruta de la primavera',
    'Eventos únicos te esperan',
  ],
  'may': [
    'Mayo florece con eventos',
    'Disfruta del buen tiempo',
    'La diversión no para',
  ],
  'june': [
    'Junio, comienza el verano',
    'Eventos para disfrutar al aire libre',
    'El verano está aquí',
  ],
  'july': [
    'Julio, mes de verano',
    'Disfruta del calor y los eventos',
    'El verano en su máximo esplendor',
  ],
  'august': [
    'Agosto, disfruta del verano',
    'Eventos para toda la familia',
    'Últimos días de verano',
  ],
  'september': [
    'Septiembre, vuelta a la rutina con estilo',
    'Eventos para empezar el otoño',
    'El otoño trae nuevos planes',
  ],
  'october': [
    'Octubre, mes de tradiciones',
    'Disfruta de eventos únicos',
    'El otoño está en su apogeo',
  ],
  'november': [
    '¿Qué plan hay hoy cerca de ti?',
    'Zambombas, tapas y noches de otoño. ¿Te lo vas a perder?',
    'Descubre qué se mueve en tu zona este noviembre',
    'Encuentra tu próxima zambomba sin perder tiempo',
  ],
  'december': [
    'Navidad, mercadillos y luces. QuePlan te lo cuenta todo.',
    'Brindis, fiestas y planes de invierno cerca de ti',
    'Diciembre, mes mágico',
    'Cierra el año con estilo',
  ],
};

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  final EventService _eventService = EventService.instance;
  final CategoryService _categoryService = CategoryService();
  final CityService _cityService = CityService.instance;
  final _repo = EventsRepository();
  final _repoNearby = EventsRepository();
  final DateFormat _df = DateFormat('d MMM');

  LocationMode _mode = LocationMode.radius;
  SearchMode _searchMode = SearchMode.city;
  final TextEditingController _searchCtrl = TextEditingController();
  String? _searchEventTerm;

  Event? _featuredEvent;
  List<Event> _upcomingEvents = [];
  List<Event> _featuredEvents = [];
  List<Category> _categories = [];
  bool _isLoading = true;
  String? _error;
  int? _selectedCategoryId;
  int? _selectedCityId;
  Set<int> _selectedCityIds = {};
  String? _selectedCityName;
  List<City> _cities = [];
  DateTime? _fromDate;
  DateTime? _toDate;
  String? _selectedDatePreset;
  bool _isToday = false;
  bool _isWeekend = false;
  bool _isThisMonth = false;

  // Nearby events state
  double _radiusKm = 5;
  double? _userLat = 36.1927; // Barbate (temporal)
  double? _userLng = -5.9219; // Barbate (temporal)
  bool _isNearbyLoading = false;
  List<model.Event> _nearbyEvents = [];
  bool _hasLocationPermission = false; // Estado de permisos de ubicación
  List<City> _nearbyCities = [];

  // Legacy search state (mantener por compatibilidad)
  String _searchQuery = '';
  Timer? _searchDebouncer;
  bool _isSearching = false;
  List<Event> _searchResults = [];

  // Legacy city search state (mantener por compatibilidad)
  final _citySearchCtrl = TextEditingController();
  String _citySearchQuery = '';
  Timer? _citySearchDebouncer;
  bool _isCitySearching = false;
  List<City> _citySearchResults = [];

  // Contador de toques para acceso admin
  int _adminTapCount = 0;
  DateTime? _lastAdminTap;

  // Estado del desplegable de filtros
  bool _isFilterPanelExpanded = false;
  Timer? _filterPanelAutoCloseTimer;

  // Hero banner state
  List<String> _heroImageUrls = [];
  int _heroIndex = 0;
  Timer? _heroTimer;
  List<String> _heroTaglines = [];
  bool _isHeroLoading = false;

  @override
  void initState() {
    super.initState();
    _checkLocationPermission();
    _reloadEvents().then((_) => _loadNearby());
    _loadCities();
    _loadNearbyCities();
    _loadHeroBanner();
  }

  @override
  void dispose() {
    _searchDebouncer?.cancel();
    _searchCtrl.dispose();
    _citySearchDebouncer?.cancel();
    _citySearchCtrl.dispose();
    _filterPanelAutoCloseTimer?.cancel();
    _heroTimer?.cancel();
    super.dispose();
  }

  void _switchMode(LocationMode mode) {
    if (_mode == mode) return;
    setState(() {
      _mode = mode;
      // Abrir desplegable automáticamente al cambiar de modo
      _isFilterPanelExpanded = true;
      _resetFilterPanelTimer();
      if (_mode == LocationMode.city) {
        // Al volver a Ciudad, el radio no se aplica (pero mantenemos el valor para cuando vuelvas a Radio)
        // No hacemos nada con _radiusKm
        // Cargar eventos cercanos si hay ubicación del usuario
        if (_userLat != null && _userLng != null) {
          _loadNearby();
        }
      } else {
        // Al ir a Radio, descartamos selección de ciudad para evitar conflicto visual/lógico
        _selectedCityId = null;
        _selectedCityIds.clear();
        _selectedCityName = null;
        // Inicializar radio a un valor válido si está en 0
        if (_radiusKm == 0 || _radiusKm < 5) _radiusKm = 25;
        // Limpiar eventos cercanos porque no se muestran en modo Radio
        _nearbyEvents = [];
      }
    });
    _reloadEvents();
  }

  void _resetFilterPanelTimer() {
    _filterPanelAutoCloseTimer?.cancel();
    if (_isFilterPanelExpanded) {
      _filterPanelAutoCloseTimer = Timer(const Duration(seconds: 7), () {
        if (mounted) {
          setState(() {
            _isFilterPanelExpanded = false;
          });
        }
      });
    }
  }

  void _onFilterInteraction() {
    // Resetear el timer cuando hay interacción con los filtros
    _resetFilterPanelTimer();
  }

  /// Obtiene la fecha de hoy a las 00:00 en la zona horaria local
  DateTime _getTodayStart() {
    final now = DateTime.now();
    return DateTime(now.year, now.month, now.day);
  }

  /// Determina si hay un filtro de fecha manual activo
  bool _hasManualDateFilter() {
    return _isToday || _isWeekend || _isThisMonth || 
           (_fromDate != null || _toDate != null);
  }

  /// Obtiene el valor de 'from' a usar en las consultas
  /// Si no hay filtro manual, devuelve hoy a las 00:00
  DateTime? _getEffectiveFromDate() {
    if (_hasManualDateFilter()) {
      return _fromDate; // Si hay filtro manual, usar el valor establecido
    }
    // Si no hay filtro manual, usar hoy a las 00:00 por defecto
    return _getTodayStart();
  }

  /// Obtiene el nombre de la carpeta del mes actual
  String _currentMonthFolder() {
    final now = DateTime.now();
    switch (now.month) {
      case 1:
        return 'january';
      case 2:
        return 'february';
      case 3:
        return 'march';
      case 4:
        return 'april';
      case 5:
        return 'may';
      case 6:
        return 'june';
      case 7:
        return 'july';
      case 8:
        return 'august';
      case 9:
        return 'september';
      case 10:
        return 'october';
      case 11:
        return 'november';
      case 12:
        return 'december';
      default:
        return 'november';
    }
  }

  /// Obtiene una frase aleatoria para el mes dado
  String _getRandomTaglineForMonth(String monthKey) {
    final list = kMonthlyTaglines[monthKey];
    if (list == null || list.isEmpty) {
      return 'Encuentra tu próximo plan con QuePlan';
    }
    return list[Random().nextInt(list.length)];
  }

  /// Genera las frases (taglines) por mes
  List<String> _getMonthlyTaglines(DateTime now) {
    final month = now.month;
    switch (month) {
      case 11: // noviembre
        return [
          'Encuentra tu zambomba hoy en QuePlan',
          'Castañas, luces y buen ambiente. ¿Qué plan tienes?',
          'Zambombas, mercadillos y mucho arte en tu zona',
          'Este otoño no te quedes en casa. Mira qué planes hay cerca.',
        ];
      case 12: // diciembre
        return [
          'Navidad, amigos y planes cerca de ti',
          'Mercadillos, conciertos y fiestas de fin de año',
          'Despedimos el año con los mejores planes',
        ];
      default:
        return [
          'Descubre qué está pasando hoy cerca de ti',
          'Conciertos, mercados y fiestas en tu zona',
          'Abre QuePlan y no te pierdas nada',
        ];
    }
  }

  /// Carga el hero banner desde Supabase Storage
  Future<void> _loadHeroBanner() async {
    setState(() {
      _isHeroLoading = true;
    });

    try {
      final monthFolder = _currentMonthFolder();
      final storage = Supabase.instance.client.storage.from('hero_banners');
      final result = await storage.list(path: monthFolder);

      // Filtrar solo imágenes (jpg, jpeg, png)
      final imageFiles = result.where((file) {
        final name = file.name.toLowerCase();
        return name.endsWith('.jpg') ||
            name.endsWith('.jpeg') ||
            name.endsWith('.png');
      }).toList();

      if (imageFiles.isEmpty) {
        setState(() {
          _heroImageUrls = [];
          _heroTaglines = _getMonthlyTaglines(DateTime.now());
          _heroIndex = 0;
          _isHeroLoading = false;
        });
        _heroTimer?.cancel();
        return;
      }

      // Construir todas las URLs públicas
      final imageUrls = imageFiles.map((file) {
        return storage.getPublicUrl('$monthFolder/${file.name}');
      }).toList();

      // Mezclar las URLs para tener un orden aleatorio
      imageUrls.shuffle(Random());

      setState(() {
        _heroImageUrls = imageUrls;
        _heroTaglines = _getMonthlyTaglines(DateTime.now());
        _heroIndex = 0;
        _isHeroLoading = false;
      });

      // Cancelar timer anterior si lo hubiera
      _heroTimer?.cancel();

      // Inicializar timer solo si hay más de una imagen
      if (_heroImageUrls.length > 1) {
        _heroTimer = Timer.periodic(const Duration(seconds: 7), (_) {
          if (!mounted || _heroImageUrls.isEmpty) return;
          setState(() {
            _heroIndex = (_heroIndex + 1) % _heroImageUrls.length;
          });
        });
      }
    } catch (e) {
      debugPrint('Error al cargar hero banner: $e');
      setState(() {
        _heroImageUrls = [];
        _heroTaglines = _getMonthlyTaglines(DateTime.now());
        _heroIndex = 0;
        _isHeroLoading = false;
      });
      _heroTimer?.cancel();
    }
  }

  Future<void> _reloadEvents() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final List<int>? cityIds = _mode == LocationMode.city
          ? (_selectedCityIds.isNotEmpty
                ? _selectedCityIds.toList()
                : (_selectedCityId != null ? <int>[_selectedCityId!] : null))
          : null;

      final double? radius = _mode == LocationMode.radius && _radiusKm > 0
          ? _radiusKm
          : null;

      // Crear objeto center para el modo radio
      // Si estamos en modo radio, siempre necesitamos una ubicación (usar valores por defecto si no hay)
      dynamic center;
      if (_mode == LocationMode.radius) {
        if (_userLat != null && _userLng != null) {
          center = {'lat': _userLat, 'lng': _userLng};
        } else {
          // Si no hay ubicación del usuario pero estamos en modo radio, usar valores por defecto
          center = {'lat': 36.1927, 'lng': -5.9219}; // Barbate por defecto
        }
      }

      // Obtener la fecha 'from' efectiva (hoy a las 00:00 si no hay filtro manual)
      final effectiveFrom = _getEffectiveFromDate();

      final results = await Future.wait([
        EventService.instance.fetchEvents(
          cityIds: cityIds,
          categoryId: _selectedCategoryId,
          from: effectiveFrom,
          to: _toDate,
          radiusKm: radius,
          center: center,
          searchTerm: _searchEventTerm,
        ),
        // Popular esta semana: eventos más vistos de esta semana (usando RPC)
        _eventService.fetchFeatured(limit: 10),
        _categoryService.fetchAll(),
      ]);

      setState(() {
        final upcoming = results[0] as List<Event>;
        final featured = results[1] as List<Event>;
        _upcomingEvents = upcoming;
        _featuredEvents = featured;
        _featuredEvent = featured.isNotEmpty ? featured.first : null;
        _categories = results[2] as List<Category>;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _error = e.toString();
        _isLoading = false;
      });

      // Mostrar SnackBar con error y botón de reintentar
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error al cargar datos: ${e.toString()}'),
            action: SnackBarAction(
              label: 'Reintentar',
              onPressed: _reloadEvents,
            ),
            duration: const Duration(seconds: 5),
          ),
        );
      }
    }
  }

  Future<void> _loadCities() async {
    // por ahora usamos Cádiz por slug (para producción usaremos selector)
    final provId = await _cityService.getProvinceIdBySlug('cadiz');
    final cities = await _cityService.fetchCities(provinceId: provId);
    if (!mounted) return;
    setState(() {
      _cities = cities;
      // si no hay selección, seleccionar la primera o mantener null (tu criterio)
      _selectedCityId ??= _cities.isNotEmpty ? _cities.first.id : null;
      if (_selectedCityId != null) {
        final city = _cities.firstWhere(
          (c) => c.id == _selectedCityId,
          orElse: () => _cities.first,
        );
        _selectedCityName = city.name;
        _selectedCityIds = {city.id};
      }
    });
  }

  void _clearFilters() {
    setState(() {
      // Ciudad
      _selectedCityId = null;
      _selectedCityIds.clear();
      _selectedCityName = null;

      // Categoría
      _selectedCategoryId = null;

      // Fechas
      _fromDate = null;
      _toDate = null;
      _isToday = false;
      _isWeekend = false;
      _isThisMonth = false;
      _selectedDatePreset = null;

      // Búsqueda de eventos
      _searchEventTerm = null;
      _searchCtrl.clear();
    });

    // Recargar eventos con el estado limpio
    _reloadEvents();
  }

  Future<void> _reloadWithDateRange({DateTime? from, DateTime? to}) async {
    setState(() {
      _fromDate = from;
      _toDate = to;
      _isLoading = true;
    });
    try {
      final List<int>? cityIds = _mode == LocationMode.city
          ? (_selectedCityIds.isNotEmpty
                ? _selectedCityIds.toList()
                : (_selectedCityId != null ? <int>[_selectedCityId!] : null))
          : null;

      final double? radius = _mode == LocationMode.radius && _radiusKm > 0
          ? _radiusKm
          : null;

      // Crear objeto center para el modo radio
      // Si estamos en modo radio, siempre necesitamos una ubicación (usar valores por defecto si no hay)
      dynamic center;
      if (_mode == LocationMode.radius) {
        if (_userLat != null && _userLng != null) {
          center = {'lat': _userLat, 'lng': _userLng};
        } else {
          // Si no hay ubicación del usuario pero estamos en modo radio, usar valores por defecto
          center = {'lat': 36.1927, 'lng': -5.9219}; // Barbate por defecto
        }
      }

      // Obtener la fecha 'from' efectiva (hoy a las 00:00 si no hay filtro manual)
      // En _reloadWithDateRange, si se pasa from/to explícito, usarlo; si es null, usar hoy
      final effectiveFrom = (from != null || _hasManualDateFilter()) 
          ? _fromDate 
          : _getTodayStart();

      final events = await EventService.instance.fetchEvents(
        cityIds: cityIds,
        categoryId: _selectedCategoryId,
        from: effectiveFrom,
        to: _toDate,
        radiusKm: radius,
        center: center,
        searchTerm: _searchEventTerm,
      );
      if (!mounted) return;
      setState(() {
        _upcomingEvents = events; // nunca null
      });
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('No se pudieron cargar eventos del rango seleccionado'),
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  Widget _activeDatePill() {
    if (_fromDate == null && _toDate == null) return const SizedBox.shrink();

    final fromTxt = _fromDate != null ? _df.format(_fromDate!) : '–';
    final toTxt = _toDate != null ? _df.format(_toDate!) : '–';

    return Padding(
      padding: const EdgeInsets.only(left: 8, right: 8, bottom: 6),
      child: Row(
        children: [
          InputChip(
            label: Text('Fechas: $fromTxt → $toTxt'),
            onDeleted: () => _reloadWithDateRange(from: null, to: null),
          ),
        ],
      ),
    );
  }

  Future<void> _loadNearby() async {
    // Solo cargar eventos cercanos en modo Ciudad (para mostrar eventos cerca de tu ubicación real)
    // En modo Radio, "Próximos eventos" ya muestra los eventos del radio, así que no es necesario
    if (_userLat == null || _userLng == null || _mode != LocationMode.city) {
      setState(() => _nearbyEvents = []);
      return;
    }

    setState(() => _isNearbyLoading = true);

    try {
      // Usar un radio fijo razonable (25km) para "Cerca de ti" en modo Ciudad
      // Esto muestra eventos cercanos a tu ubicación real, independientemente de la ciudad seleccionada
      // Pasar el 'from' efectivo para filtrar eventos pasados por defecto
      final list = await _repoNearby.fetchNearby(
        lat: _userLat!,
        lng: _userLng!,
        radiusKm: 25, // Radio fijo para "Cerca de ti"
        from: _getEffectiveFromDate(),
      );
      setState(() => _nearbyEvents = list);
    } finally {
      if (mounted) setState(() => _isNearbyLoading = false);
    }
  }

  Future<void> _loadNearbyCities() async {
    if (_userLat == null || _userLng == null) return;

    final cities = await CityService.instance.fetchNearbyCities(
      lat: _userLat!,
      lng: _userLng!,
      radiusKm: _radiusKm,
    );

    if (!mounted) return;

    setState(() {
      _nearbyCities = cities;
      // Limpia selección si la ciudad elegida ya no está en el radio
      if (_selectedCityId != null &&
          !_nearbyCities.any((c) => c.id == _selectedCityId)) {
        _selectedCityId = null;
      }
    });
  }

  Widget _buildProvinceCityChips() {
    if (_cities.isEmpty) return const SizedBox.shrink();

    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: _cities
          .map(
            (city) => ChoiceChip(
              label: Text(
                city.name,
                style: Theme.of(context).textTheme.labelLarge,
              ),
              selected: _selectedCityId == city.id,
              onSelected: (_) {
                setState(() {
                  _selectedCityId = city.id;
                  _selectedCityName = city.name;
                  _selectedCityIds = {city.id};
                });
                _reloadEvents();
              },
              materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
              visualDensity: VisualDensity.compact,
            ),
          )
          .toList(),
    );
  }

  Widget _buildNearbyCityChips() {
    if (_nearbyCities.isEmpty) return const SizedBox.shrink();

    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: [
        ChoiceChip(
          label: Text('Todas', style: Theme.of(context).textTheme.labelLarge),
          selected: _selectedCityId == null,
          onSelected: (_) {
            setState(() {
              _selectedCityId = null; // todas las ciudades del radio
              _selectedCityName = null;
              _selectedCityIds.clear();
            });
            _reloadEvents();
          },
          materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
          visualDensity: VisualDensity.compact,
        ),
        ..._nearbyCities.map(
          (city) => ChoiceChip(
            label: Text(
              city.name,
              style: Theme.of(context).textTheme.labelLarge,
            ),
            selected: _selectedCityId == city.id,
            onSelected: (_) {
              setState(() {
                _selectedCityId = city.id;
                _selectedCityName = city.name;
                _selectedCityIds = {city.id};
              });
              _reloadEvents();
            },
            materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
            visualDensity: VisualDensity.compact,
          ),
        ),
      ],
    );
  }

  Widget _buildCityChips() {
    // En modo Ciudad, siempre mostramos las ciudades de la provincia, no las del radio
    return _buildProvinceCityChips();
  }

  String _getSelectedCategoryName() {
    if (_selectedCategoryId == null) return 'Todas las categorías';
    final selectedCategory = _categories.firstWhere(
      (c) => c.id == _selectedCategoryId,
      orElse: () => _categories.first,
    );
    return selectedCategory.name;
  }

  String _getSelectedDateLabel() {
    if (_fromDate == null && _toDate == null) return '';

    // Si hay un rango personalizado, mostrar formato corto
    if (_fromDate != null && _toDate != null) {
      final fromTxt = _df.format(_fromDate!);
      final toTxt = _df.format(_toDate!);
      return '$fromTxt → $toTxt';
    }

    return '';
  }

  String _getFiltersSubtitle() {
    final categoryName = _selectedCategoryId != null
        ? _getSelectedCategoryName()
        : null;
    final hasDateFilter = _fromDate != null || _toDate != null;

    // Detectar el preset de fecha usando los estados existentes o comparando fechas
    String? dateLabel;
    if (hasDateFilter) {
      if (_isToday) {
        dateLabel = 'Hoy';
      } else if (_isWeekend) {
        dateLabel = 'Fin de semana';
      } else if (_isThisMonth) {
        dateLabel = 'Este mes';
      } else if (_fromDate != null && _toDate != null) {
        // Rango personalizado
        dateLabel = _getSelectedDateLabel();
      }
    }

    // Construir el subtítulo
    if (categoryName == null && dateLabel == null) {
      return 'Categoría y fecha';
    } else if (categoryName != null && dateLabel == null) {
      return 'Categoría: $categoryName';
    } else if (categoryName == null && dateLabel != null) {
      return 'Fecha: $dateLabel';
    } else {
      return '$categoryName · $dateLabel';
    }
  }

  Widget _buildCategoryChipsContent() {
    if (_categories.isEmpty) return const SizedBox.shrink();

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Wrap(
        spacing: 8,
        runSpacing: 8,
        children: [
          // Chip "Todas"
          FilterChip(
            avatar: const Icon(Icons.grid_view, size: 16),
            label: const Text('Todas'),
            selected: _selectedCategoryId == null,
            onSelected: (_) {
              setState(() {
                _selectedCategoryId = null;
              });
              _reloadEvents();
            },
          ),
          // Chips de categorías
          ..._categories.where((Category c) => c.id != null).map((category) {
            final isSelected = category.id == _selectedCategoryId;
            final icon = iconFromName(category.icon);
            return FilterChip(
              avatar: Icon(icon, size: 16),
              label: Text(category.name),
              selected: isSelected,
              onSelected: (_) {
                setState(() {
                  _selectedCategoryId = isSelected ? null : category.id;
                });
                _reloadEvents();
              },
            );
          }),
        ],
      ),
    );
  }

  Widget _buildRadiusAndLocationContent() {
    return _NearbyControlWidget(
      radiusKm: _radiusKm,
      onRadiusChanged: (value) async {
        _onFilterInteraction();
        setState(() {
          _radiusKm = value;
        });
        // Actualizar eventos cercanos con el nuevo radio
        if (_userLat != null && _userLng != null) {
          await _loadNearby();
          await _loadNearbyCities();
        } else {
          // Si no hay ubicación del usuario, usar valores por defecto para cargar eventos cercanos
          final defaultLat = 36.1927; // Barbate
          final defaultLng = -5.9219;
          setState(() => _isNearbyLoading = true);
          try {
            // Pasar el 'from' efectivo para filtrar eventos pasados por defecto
            final list = await _repoNearby.fetchNearby(
              lat: defaultLat,
              lng: defaultLng,
              radiusKm: _radiusKm,
              from: _getEffectiveFromDate(),
            );
            setState(() => _nearbyEvents = list);
          } finally {
            if (mounted) setState(() => _isNearbyLoading = false);
          }
          // Cargar ciudades cercanas con valores por defecto
          final cities = await CityService.instance.fetchNearbyCities(
            lat: defaultLat,
            lng: defaultLng,
            radiusKm: _radiusKm,
          );
          if (mounted) {
            setState(() => _nearbyCities = cities);
          }
        }
        // Recargar eventos principales con el nuevo radio
        _reloadEvents();
      },
    );
  }

  Widget _buildDisabledRadiusContent() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceVariant.withOpacity(0.3),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Theme.of(context).colorScheme.outline.withOpacity(0.2),
        ),
      ),
      child: Row(
        children: [
          Icon(
            Icons.location_off,
            size: 20,
            color: Theme.of(context).colorScheme.onSurfaceVariant.withOpacity(0.6),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              'Permisos de ubicación requeridos para usar el selector de radio',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Theme.of(context).colorScheme.onSurfaceVariant.withOpacity(0.6),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _runSearch(String q) async {
    setState(() {
      _isSearching = true;
      _searchQuery = q;
    });

    final events = await EventService.instance.searchEvents(
      query: q,
      cityId: _selectedCityId, // respeta filtro si hay
      // provinceId: ... (si lo tienes en estado)
      // lat/lng/radius si quieres mezclar con "cerca de ti" más adelante
    );

    if (!mounted) return;

    setState(() {
      _searchResults = events;
      _isSearching = false;
    });
  }

  Future<void> _runCitySearch(String q) async {
    setState(() {
      _isCitySearching = true;
      _citySearchQuery = q;
    });

    final res = await CityService.instance.searchCities(q);

    if (!mounted) return;

    setState(() {
      _citySearchResults = res;
      _isCitySearching = false;
    });
  }

  Future<void> _checkLocationPermission() async {
    final permission = await Geolocator.checkPermission();
    final hasPermission = permission == LocationPermission.whileInUse ||
        permission == LocationPermission.always;
    setState(() {
      _hasLocationPermission = hasPermission;
    });
    // Si no hay permisos y estamos en modo Radio, cambiar a modo Ciudad
    if (!hasPermission && _mode == LocationMode.radius) {
      _switchMode(LocationMode.city);
    }
  }

  Future<void> _getUserLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      debugPrint('Servicios de ubicación desactivados.');
      setState(() {
        _hasLocationPermission = false;
      });
      return;
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        debugPrint('Permiso de ubicación denegado.');
        setState(() {
          _hasLocationPermission = false;
        });
        // Si estamos en modo Radio, cambiar a modo Ciudad
        if (_mode == LocationMode.radius) {
          _switchMode(LocationMode.city);
        }
        return;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      debugPrint('Permiso de ubicación denegado permanentemente.');
      setState(() {
        _hasLocationPermission = false;
      });
      // Si estamos en modo Radio, cambiar a modo Ciudad
      if (_mode == LocationMode.radius) {
        _switchMode(LocationMode.city);
      }
      return;
    }

    setState(() {
      _hasLocationPermission = true;
    });

    final pos = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );
    setState(() {
      _userLat = pos.latitude;
      _userLng = pos.longitude;
    });
    // Solo cargar eventos cercanos si estamos en modo Ciudad
    if (_mode == LocationMode.city) {
      await _loadNearby();
    }
    await _loadNearbyCities();
  }

  Future<void> _openAdminPanel() async {
    final pinController = TextEditingController();
    final ctx = context;

    final result = await showDialog<bool>(
      context: ctx,
      barrierDismissible: false,
      builder: (dialogCtx) {
        return AlertDialog(
          title: const Text('Acceso administrador'),
          content: TextField(
            controller: pinController,
            keyboardType: TextInputType.number,
            obscureText: true,
            decoration: const InputDecoration(labelText: 'Introduce el PIN'),
            autofocus: true,
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(dialogCtx).pop(false);
              },
              child: const Text('Cancelar'),
            ),
            ElevatedButton(
              onPressed: () {
                final entered = pinController.text.trim();
                if (entered == kAdminPin) {
                  Navigator.of(dialogCtx).pop(true);
                } else {
                  ScaffoldMessenger.of(ctx).showSnackBar(
                    const SnackBar(
                      content: Text('PIN incorrecto'),
                      duration: Duration(seconds: 2),
                    ),
                  );
                }
              },
              child: const Text('Entrar'),
            ),
          ],
        );
      },
    );

    if (result == true) {
      if (!mounted) return;
      Navigator.of(
        ctx,
      ).push(MaterialPageRoute(builder: (_) => const PendingEventsScreen()));
    }
  }

  void _openSearchBottomSheet() {
    final searchController = TextEditingController(
      text: _searchEventTerm ?? '',
    );
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Theme.of(context).colorScheme.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
          left: 16,
          right: 16,
          top: 16,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Buscar eventos',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                color: Theme.of(context).colorScheme.onSurface,
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: searchController,
              autofocus: true,
              textInputAction: TextInputAction.search,
              style: TextStyle(color: Theme.of(context).colorScheme.onSurface),
              decoration: InputDecoration(
                hintText: 'Buscar eventos (ej. flamenco, mercadillo...)',
                prefixIcon: Icon(
                  Icons.search,
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
              ),
              onSubmitted: (value) {
                final query = value.trim();
                setState(() {
                  _searchEventTerm = query.isEmpty ? null : query;
                });
                _reloadEvents();
                Navigator.pop(context);
              },
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Cancelar'),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  onPressed: () {
                    final query = searchController.text.trim();
                    setState(() {
                      _searchEventTerm = query.isEmpty ? null : query;
                    });
                    _reloadEvents();
                    Navigator.pop(context);
                  },
                  child: const Text('Buscar'),
                ),
              ],
            ),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }

  Widget _buildFilterPanel() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Barra de toggle que ocupa todo el ancho con flecha
          InkWell(
            onTap: () {
              setState(() {
                _isFilterPanelExpanded = !_isFilterPanelExpanded;
                if (_isFilterPanelExpanded) {
                  _resetFilterPanelTimer();
                }
              });
            },
            borderRadius: BorderRadius.circular(12),
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: Theme.of(context).colorScheme.outline.withOpacity(0.2),
                ),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: CityRadioToggle(
                      selectedMode: _mode,
                      onModeChanged: (mode) {
                        if (mode != _mode) {
                          _switchMode(mode);
                        }
                      },
                      selectedCityName: _selectedCityName,
                      radiusKm: _radiusKm,
                      hasLocationPermission: _hasLocationPermission,
                    ),
                  ),
                  const SizedBox(width: 12),
                  AnimatedRotation(
                    turns: _isFilterPanelExpanded ? 0.5 : 0,
                    duration: const Duration(milliseconds: 300),
                    child: Icon(
                      Icons.arrow_drop_down,
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
          ),
          // Desplegable con animación
          AnimatedCrossFade(
            firstChild: const SizedBox.shrink(),
            secondChild: _buildExpandedFilterContent(),
            crossFadeState: _isFilterPanelExpanded
                ? CrossFadeState.showSecond
                : CrossFadeState.showFirst,
            duration: const Duration(milliseconds: 300),
          ),
        ],
      ),
    );
  }

  Widget _buildExpandedFilterContent() {
    return Padding(
      padding: const EdgeInsets.only(top: 12),
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        elevation: 0,
        margin: EdgeInsets.zero,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Contenido según el modo
              if (_mode == LocationMode.radius) ...[
                // Modo Radio: Categorías en slide lateral + selector de radio
                if (_hasLocationPermission) ...[
                  _buildRadiusAndLocationContent(),
                  const SizedBox(height: 16),
                ],
                // Categorías en slide horizontal
                Text(
                  'Categorías',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 12),
                SizedBox(
                  height: 120,
                  child: _buildHorizontalCategoriesList(),
                ),
              ] else ...[
                // Modo Ciudad: Búsqueda de ciudad + categorías
                UnifiedSearchBar(
                  selectedCityId: _selectedCityId,
                  onCitySelected: (city) {
                    _onFilterInteraction();
                    if (mounted) {
                      setState(() {
                        _selectedCityId = city.id;
                        _selectedCityIds = {city.id};
                        _selectedCityName = city.name;
                      });
                      _reloadEvents();
                    }
                  },
                  onSearchChanged: null,
                ),
                const SizedBox(height: 16),
                // Categorías en slide horizontal
                Text(
                  'Categorías',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 12),
                SizedBox(
                  height: 120,
                  child: _buildHorizontalCategoriesList(),
                ),
              ],
              const SizedBox(height: 16),
              // Chips de fecha (Hoy, Fin de semana, Rango)
              Text(
                'Fechas',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 12),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  ActionChip(
                    label: const Text('Hoy'),
                    onPressed: () {
                      _onFilterInteraction();
                      final r = todayRange();
                      setState(() {
                        _isToday = true;
                        _isWeekend = false;
                        _isThisMonth = false;
                      });
                      _reloadWithDateRange(from: r.from, to: r.to);
                    },
                  ),
                  ActionChip(
                    label: const Text('Fin de semana'),
                    onPressed: () {
                      _onFilterInteraction();
                      final r = weekendRange();
                      setState(() {
                        _isToday = false;
                        _isWeekend = true;
                        _isThisMonth = false;
                      });
                      _reloadWithDateRange(from: r.from, to: r.to);
                    },
                  ),
                  OutlinedButton.icon(
                    icon: const Icon(Icons.date_range, size: 16),
                    label: const Text('Rango...'),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                      minimumSize: const Size(0, 32),
                    ),
                    onPressed: () {
                      _onFilterInteraction();
                      _showDateRangePicker();
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHorizontalCategoriesList() {
    if (_categories.isEmpty) {
      return const Center(child: Text('No hay categorías disponibles'));
    }

    final List<Widget> categoryWidgets = [];

    // Cuadro "Todas"
    final isAllSelected = _selectedCategoryId == null;
    categoryWidgets.add(
      SizedBox(
        width: 100,
        child: InkWell(
          onTap: () {
            _onFilterInteraction();
            setState(() {
              _selectedCategoryId = null;
            });
            _reloadEvents();
          },
          borderRadius: BorderRadius.circular(12),
          child: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: isAllSelected
                  ? Theme.of(context).colorScheme.primaryContainer.withOpacity(0.5)
                  : Theme.of(context).colorScheme.surfaceVariant.withOpacity(0.5),
              borderRadius: BorderRadius.circular(12),
              border: isAllSelected
                  ? Border.all(
                      color: Theme.of(context).colorScheme.primary,
                      width: 2,
                    )
                  : null,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.grid_view,
                  size: 32,
                  color: isAllSelected
                      ? Theme.of(context).colorScheme.onPrimaryContainer
                      : Theme.of(context).colorScheme.onSurfaceVariant,
                ),
                const SizedBox(height: 4),
                Text(
                  'Todas',
                  style: TextStyle(
                    fontWeight: isAllSelected ? FontWeight.bold : FontWeight.w500,
                    fontSize: 12,
                    color: isAllSelected
                        ? Theme.of(context).colorScheme.onPrimaryContainer
                        : Theme.of(context).colorScheme.onSurface,
                  ),
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ),
      ),
    );

    // Agregar las categorías
    categoryWidgets.addAll(
      _categories.where((c) => c.id != null).map((category) {
        final categoryColor = _getColorForCategory(category.name);
        final isSelected = category.id == _selectedCategoryId;

        return SizedBox(
          width: 100,
          child: InkWell(
            onTap: () {
              _onFilterInteraction();
              setState(() {
                _selectedCategoryId = isSelected ? null : category.id;
              });
              _reloadEvents();
            },
            borderRadius: BorderRadius.circular(12),
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: isSelected
                    ? categoryColor.withOpacity(0.3)
                    : categoryColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
                border: isSelected
                    ? Border.all(color: categoryColor, width: 2)
                    : null,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    iconFromName(category.icon),
                    size: 32,
                    color: isSelected
                        ? categoryColor
                        : Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    category.name,
                    style: TextStyle(
                      fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                      fontSize: 12,
                      color: isSelected
                          ? categoryColor
                          : Theme.of(context).colorScheme.onSurface,
                    ),
                    textAlign: TextAlign.center,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ),
        );
      }),
    );

    return ListView(
      scrollDirection: Axis.horizontal,
      children: categoryWidgets,
    );
  }

  Future<void> _showDateRangePicker() async {
    final now = DateTime.now();
    final first = DateTime(now.year - 1, 1, 1);
    final last = DateTime(now.year + 2, 12, 31);

    final picked = await showDateRangePicker(
      context: context,
      firstDate: first,
      lastDate: last,
      initialDateRange: (_fromDate != null && _toDate != null)
          ? DateTimeRange(start: _fromDate!, end: _toDate!)
          : null,
    );
    if (picked != null) {
      setState(() {
        _selectedDatePreset = null;
        _isToday = false;
        _isWeekend = false;
        _isThisMonth = false;
      });
      _reloadWithDateRange(from: picked.start, to: picked.end);
    }
  }

  Color _getColorForCategory(String categoryName) {
    final name = categoryName.toLowerCase();
    if (name.contains('música') || name.contains('music')) {
      return Colors.purple;
    } else if (name.contains('mercados') || name.contains('market')) {
      return Colors.orange;
    } else if (name.contains('deporte') || name.contains('sport')) {
      return Colors.green;
    } else if (name.contains('tradición') || name.contains('tradition')) {
      return Colors.redAccent;
    } else if (name.contains('gastronomía') || name.contains('gastronomy') || name.contains('comida')) {
      return Colors.amber;
    } else if (name.contains('cultura') || name.contains('culture')) {
      return Colors.blue;
    } else if (name.contains('arte') || name.contains('art')) {
      return Colors.pink;
    } else if (name.contains('naturaleza') || name.contains('nature')) {
      return Colors.teal;
    }
    return Colors.grey;
  }

  Widget _buildCategoriesGrid() {
    if (_categories.isEmpty) {
      return const Text('No hay categorías disponibles');
    }

    final screenWidth = MediaQuery.of(context).size.width;
    final isNarrow = screenWidth < 600;
    final crossAxisCount = isNarrow ? 3 : 4;

    final List<Widget> categoryWidgets = [];

    // Cuadro "Todas"
    final isAllSelected = _selectedCategoryId == null;
    categoryWidgets.add(
      InkWell(
        onTap: () {
          setState(() {
            _selectedCategoryId = null;
          });
          _reloadEvents();
        },
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: isAllSelected
                ? Theme.of(context).colorScheme.primaryContainer.withOpacity(0.5)
                : Theme.of(context).colorScheme.surfaceVariant.withOpacity(0.5),
            borderRadius: BorderRadius.circular(16),
            border: isAllSelected
                ? Border.all(
                    color: Theme.of(context).colorScheme.primary,
                    width: 2,
                  )
                : null,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.grid_view,
                size: 40,
                color: isAllSelected
                    ? Theme.of(context).colorScheme.primary
                    : Theme.of(context).colorScheme.onSurfaceVariant,
              ),
              const SizedBox(height: 8),
              Text(
                'Todas',
                style: TextStyle(
                  fontWeight: isAllSelected ? FontWeight.bold : FontWeight.w600,
                  fontSize: 13,
                  color: isAllSelected
                      ? Theme.of(context).colorScheme.primary
                      : Theme.of(context).colorScheme.onSurface,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );

    // Cuadros de categorías
    categoryWidgets.addAll(
      _categories
          .where((Category c) => c.id != null)
          .map((category) {
            final categoryColor = _getColorForCategory(category.name);
            final isSelected = category.id == _selectedCategoryId;
            final icon = iconFromName(category.icon);

            return InkWell(
              onTap: () {
                setState(() {
                  _selectedCategoryId = isSelected ? null : category.id;
                });
                _reloadEvents();
              },
              borderRadius: BorderRadius.circular(16),
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: isSelected
                      ? categoryColor.withOpacity(0.2)
                      : categoryColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(16),
                  border: isSelected
                      ? Border.all(color: categoryColor, width: 2.5)
                      : Border.all(
                          color: categoryColor.withOpacity(0.3),
                          width: 1,
                        ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      icon,
                      size: 40,
                      color: isSelected
                          ? categoryColor
                          : categoryColor.withOpacity(0.8),
                    ),
                    const SizedBox(height: 8),
                    Flexible(
                      child: Text(
                        category.name,
                        style: TextStyle(
                          fontWeight: isSelected
                              ? FontWeight.bold
                              : FontWeight.w600,
                          fontSize: 13,
                          color: isSelected
                              ? categoryColor
                              : Theme.of(context).colorScheme.onSurface,
                        ),
                        textAlign: TextAlign.center,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),
            );
          }),
    );

    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: crossAxisCount,
      mainAxisSpacing: 12,
      crossAxisSpacing: 12,
      padding: EdgeInsets.zero,
      childAspectRatio: 0.85,
      children: categoryWidgets,
    );
  }

  /// Construye el widget del hero banner con rotación automática
  Widget _buildHeroBanner(BuildContext context) {
    if (_isHeroLoading) {
      return SizedBox(
        width: double.infinity,
        height: 220,
        child: Container(
          color: Theme.of(context).colorScheme.surfaceVariant,
          child: const Center(
            child: CircularProgressIndicator(),
          ),
        ),
      );
    }

    if (_heroImageUrls.isEmpty) {
      return SizedBox(
        width: double.infinity,
        height: 220,
        child: Container(
          color: Theme.of(context).colorScheme.surfaceVariant,
          child: Center(
            child: Icon(
              Icons.event,
              size: 64,
              color: Theme.of(context).colorScheme.onSurfaceVariant.withOpacity(0.5),
            ),
          ),
        ),
      );
    }

    final imageUrl = _heroImageUrls[_heroIndex];
    String? tagline;
    if (_heroTaglines.isNotEmpty) {
      tagline = _heroTaglines[_heroIndex % _heroTaglines.length];
    }

    return SizedBox(
      height: 220,
      width: double.infinity,
      child: Stack(
        fit: StackFit.expand,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(0),
            child: Image.network(
              imageUrl,
              fit: BoxFit.cover,
              width: double.infinity,
              height: 220,
              errorBuilder: (_, __, ___) => Container(
                width: double.infinity,
                height: 220,
                color: Theme.of(context).colorScheme.surfaceVariant,
                child: Icon(
                  Icons.image_not_supported,
                  size: 48,
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
              ),
              loadingBuilder: (context, child, loadingProgress) {
                if (loadingProgress == null) return child;
                return Container(
                  width: double.infinity,
                  height: 220,
                  color: Theme.of(context).colorScheme.surfaceVariant,
                  child: const Center(
                    child: CircularProgressIndicator(),
                  ),
                );
              },
            ),
          ),
          // Capa oscura suave para mejorar la lectura del texto
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.bottomCenter,
                end: Alignment.topCenter,
                colors: [
                  Colors.black.withOpacity(0.6),
                  Colors.black.withOpacity(0.0),
                ],
              ),
            ),
          ),
          if (tagline != null)
            Positioned(
              left: 16,
              right: 16,
              bottom: 16,
              child: Text(
                tagline,
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.w700,
                  shadows: [
                    Shadow(
                      blurRadius: 8,
                      color: Colors.black.withOpacity(0.6),
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.center,
              ),
            ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_error != null && !_isLoading) {
      return Scaffold(
        appBar: AppBar(title: const Text('QuePlan')),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline, size: 64, color: Colors.red),
              const SizedBox(height: 16),
              Text(
                'Error al cargar datos',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 8),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 32),
                child: Text(
                  _error!,
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: _reloadEvents,
                child: const Text('Reintentar'),
              ),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: _reloadEvents,
          child: CustomScrollView(
            slivers: [
              SliverAppBar(
                title: const Text('QuePlan'),
                floating: true,
                snap: true,
                elevation: 0,
                toolbarHeight: 48,
                collapsedHeight: 48,
                expandedHeight: 48,
                actions: [
                  // Botón de admin invisible (requiere 3 toques)
                  Opacity(
                    opacity: 0.0,
                    child: IconButton(
                      icon: const Icon(Icons.admin_panel_settings),
                      tooltip: 'Panel de administración',
                      onPressed: () {
                        final now = DateTime.now();
                        // Resetear contador si pasan más de 2 segundos entre toques
                        if (_lastAdminTap != null &&
                            now.difference(_lastAdminTap!).inSeconds > 2) {
                          _adminTapCount = 0;
                        }
                        
                        _adminTapCount++;
                        _lastAdminTap = now;
                        
                        if (_adminTapCount >= 3) {
                          _adminTapCount = 0;
                          _openAdminPanel();
                        } else {
                          // Feedback visual para indicar que se está contando
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('Toca ${3 - _adminTapCount} vez${3 - _adminTapCount > 1 ? 'es' : ''} más para acceder'),
                              duration: const Duration(milliseconds: 800),
                            ),
                          );
                        }
                      },
                    ),
                  ),
                ],
              ),
              SliverToBoxAdapter(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Área invisible para acceso admin (3 toques)
                    Stack(
                      children: [
                        Padding(
                          padding: const EdgeInsets.fromLTRB(0, 0, 0, 4),
                          child: _buildHeroBanner(context),
                        ),
                        // Detector invisible centrado arriba del banner
                        Positioned(
                          top: 4,
                          left: 0,
                          right: 0,
                          child: Center(
                            child: GestureDetector(
                              onTap: () {
                                final now = DateTime.now();
                                // Resetear contador si pasan más de 2 segundos entre toques
                                if (_lastAdminTap != null &&
                                    now.difference(_lastAdminTap!).inSeconds > 2) {
                                  _adminTapCount = 0;
                                }
                                
                                _adminTapCount++;
                                _lastAdminTap = now;
                                
                                if (_adminTapCount >= 3) {
                                  _adminTapCount = 0;
                                  _openAdminPanel();
                                }
                              },
                              child: Container(
                                width: double.infinity,
                                height: 60,
                                color: Colors.transparent,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    if (!_isLoading) ...[_buildFilterPanel()],
                    // Resultados de búsqueda
                    if (_searchEventTerm != null &&
                        _searchEventTerm!.isNotEmpty) ...[
                      const SizedBox(height: 12),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Resultados para "$_searchEventTerm"',
                              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 12),
                    ],
                    // Próximos eventos
                    if (_isLoading)
                      Padding(
                        padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          decoration: BoxDecoration(
                            color: Theme.of(context).colorScheme.surfaceVariant,
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: ListView.separated(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 8,
                            ),
                            physics: const NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            itemCount: 4,
                            separatorBuilder:
                                (BuildContext context, int index) =>
                                    const SizedBox(height: 12),
                            itemBuilder: (BuildContext context, int index) {
                              return const Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  ShimmerBlock(height: 180),
                                  ShimmerBlock(height: 16, width: 180),
                                  ShimmerBlock(height: 14, width: 120),
                                ],
                              );
                            },
                          ),
                        ),
                      )
                    else
                      Padding(
                        padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
                        child: UpcomingEventsSection(
                          events: _upcomingEvents,
                          selectedCategoryId: _selectedCategoryId,
                          // En modo Radio no aplicamos filtro por ciudad
                          selectedCityId: _mode == LocationMode.city
                              ? _selectedCityId
                              : null,
                          onClearFilters: _clearFilters,
                          showCategory: true,
                        ),
                      ),
                    // Popular esta semana
                    if (_isLoading)
                      Padding(
                        padding: const EdgeInsets.fromLTRB(8, 0, 8, 24),
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          decoration: BoxDecoration(
                            color: Theme.of(context).colorScheme.surfaceVariant,
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: SizedBox(
                            height: 230,
                            child: ListView.separated(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                              ),
                              scrollDirection: Axis.horizontal,
                              itemCount: 5,
                              separatorBuilder:
                                  (BuildContext context, int index) =>
                                      const SizedBox(width: 12),
                              itemBuilder: (BuildContext context, int index) {
                                return const SizedBox(
                                  width: 280,
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      ShimmerBlock(height: 150),
                                      ShimmerBlock(height: 16, width: 160),
                                      ShimmerBlock(height: 14, width: 120),
                                    ],
                                  ),
                                );
                              },
                            ),
                          ),
                        ),
                      )
                    else
                      Padding(
                        padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
                        child: PopularThisWeekSection(
                          events: _featuredEvents,
                          onClearFilters: _clearFilters,
                        ),
                      ),
                    // Sección "Cerca de ti" (solo en modo Ciudad, mostrando eventos cercanos a tu ubicación real)
                    // En modo Radio no se muestra porque "Próximos eventos" ya muestra los eventos del radio
                    if (_isNearbyLoading)
                      Padding(
                        padding: const EdgeInsets.fromLTRB(8, 8, 8, 16),
                        child: ShimmerBlock(height: 80),
                      )
                    else if (_mode == LocationMode.city && _userLat != null && _userLng != null)
                      Padding(
                        padding: const EdgeInsets.fromLTRB(8, 8, 8, 16),
                        child: NearbyEventsSection(events: _nearbyEvents),
                      )
                    else
                      const SizedBox.shrink(),
                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: const BottomNavBar(),
    );
  }
}

// === Section Widgets ===

class DashboardHero extends StatelessWidget {
  final Event? featured;

  const DashboardHero({super.key, this.featured});

  @override
  Widget build(BuildContext context) {
    if (featured == null) {
      return const SizedBox.shrink();
    }

    return const HeroSlider();
  }
}

class UpcomingEventsSection extends StatelessWidget {
  final List<Event> events;
  final int? selectedCategoryId;
  final int? selectedCityId;
  final VoidCallback? onClearFilters;
  final bool showCategory;

  const UpcomingEventsSection({
    super.key,
    required this.events,
    this.selectedCategoryId,
    this.selectedCityId,
    this.onClearFilters,
    this.showCategory = true,
  });

  @override
  Widget build(BuildContext context) {
    // Aplicar filtros combinados: ciudad y categoría (null-safe)
    final filtered = events
        .where(
          (e) =>
              (selectedCityId == null || e.cityId == selectedCityId) &&
              (selectedCategoryId == null ||
                  e.categoryId == selectedCategoryId),
        )
        .toList();

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceVariant,
        borderRadius: BorderRadius.circular(16),
      ),
      child: UpcomingList(
        events: filtered,
        onClearFilters: onClearFilters,
        showCategory: showCategory,
      ),
    );
  }
}

class CategoriesSection extends StatelessWidget {
  final List<Category> categories;
  final int? selectedCategoryId;
  final ValueChanged<int?> onCategoryTap;

  const CategoriesSection({
    super.key,
    required this.categories,
    this.selectedCategoryId,
    required this.onCategoryTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceVariant,
        borderRadius: BorderRadius.circular(16),
      ),
      child: CategoriesGrid(
        categories: categories,
        selectedCategoryId: selectedCategoryId,
        onCategoryTap: onCategoryTap,
      ),
    );
  }
}

class PopularThisWeekSection extends StatelessWidget {
  final List<Event> events;
  final VoidCallback? onClearFilters;

  const PopularThisWeekSection({
    super.key,
    required this.events,
    this.onClearFilters,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceVariant,
        borderRadius: BorderRadius.circular(16),
      ),
      child: PopularCarousel(events: events, onClearFilters: onClearFilters),
    );
  }
}

class FavoritesSection extends StatelessWidget {
  final List<Event> events;

  const FavoritesSection({super.key, required this.events});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceVariant,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              'Tus favoritos',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          const SizedBox(height: 12),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: UpcomingList(events: events),
          ),
        ],
      ),
    );
  }
}

class NearbyEventsSection extends StatelessWidget {
  final List<model.Event> events;

  const NearbyEventsSection({super.key, required this.events});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceVariant,
        borderRadius: BorderRadius.circular(16),
      ),
      child: events.isEmpty
          ? Padding(
              padding: const EdgeInsets.all(24),
              child: Center(
                child: Text(
                  'No hay eventos en este radio.',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            )
          : Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Text(
                    'Cerca de ti',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                ),
                const SizedBox(height: 12),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: UpcomingList(
                    events: events
                        .map(
                          (e) => Event(
                            id: e.id,
                            title: e.title,
                            startsAt: e.startsAt,
                            cityName: e.cityName,
                            categoryName: e.categoryName,
                            categoryIcon: e.categoryIcon,
                            categoryColor: e.categoryColor,
                            place: e.place,
                            imageUrl: e.imageUrl,
                            categoryId: e.categoryId,
                            cityId: e.cityId,
                            isFree: e.isFree,
                            mapsUrl: e.mapsUrl,
                            description: e.description,
                          ),
                        )
                        .toList(),
                    showCategory: true,
                  ),
                ),
              ],
            ),
    );
  }
}

// Widget para filtros de ciudad y categoría
class _FilterHeaderWidget extends StatelessWidget {
  const _FilterHeaderWidget({
    required this.cities,
    required this.categories,
    this.selectedCityId,
    this.selectedCategoryId,
    required this.onCityTap,
    required this.onCategoryTap,
    this.showCityChips = true,
  });

  final List<City> cities;
  final List<Category> categories;
  final int? selectedCityId;
  final int? selectedCategoryId;
  final ValueChanged<int?> onCityTap;
  final ValueChanged<int?> onCategoryTap;
  final bool showCityChips;

  List<Widget> buildCityChips(BuildContext context) {
    final chips = <Widget>[];

    // Chip "Todas"
    final isAllSelected = selectedCityId == null;
    chips.add(
      ChoiceChip(
        label: Text(
          'Todas',
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: isAllSelected
                ? Theme.of(context).colorScheme.onPrimaryContainer
                : Theme.of(context).colorScheme.onSurface,
          ),
        ),
        avatar: Icon(
          Icons.place_outlined,
          size: 16,
          color: isAllSelected
              ? Theme.of(context).colorScheme.onPrimaryContainer
              : Theme.of(context).colorScheme.onSurfaceVariant,
        ),
        selected: isAllSelected,
        selectedColor: Theme.of(context).colorScheme.primaryContainer,
        onSelected: (selected) {
          if (selected) {
            onCityTap(null);
          }
        },
        visualDensity: VisualDensity.compact,
        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
      ),
    );

    // Chips de ciudades (construidos dinámicamente desde cities)
    for (final city in cities) {
      final isSelected = city.id == selectedCityId;
      chips.add(
        ChoiceChip(
          label: Text(
            city.name,
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: isSelected
                  ? Theme.of(context).colorScheme.onPrimaryContainer
                  : Theme.of(context).colorScheme.onSurface,
            ),
          ),
          selected: isSelected,
          selectedColor: Theme.of(context).colorScheme.primaryContainer,
          onSelected: (selected) {
            if (selected) {
              onCityTap(city.id);
            }
          },
          visualDensity: VisualDensity.compact,
          materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
        ),
      );
    }

    return chips;
  }

  List<Widget> buildCategoryChips(BuildContext context) {
    final chips = <Widget>[];

    // Chip "Todas"
    final isAllSelected = selectedCategoryId == null;
    chips.add(
      ChoiceChip(
        label: Text(
          'Todas',
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: isAllSelected
                ? Theme.of(context).colorScheme.onPrimaryContainer
                : Theme.of(context).colorScheme.onSurface,
          ),
        ),
        selected: isAllSelected,
        selectedColor: Theme.of(context).colorScheme.primaryContainer,
        avatar: Icon(
          Icons.grid_view,
          size: 16,
          color: isAllSelected
              ? Theme.of(context).colorScheme.onPrimaryContainer
              : Theme.of(context).colorScheme.onSurfaceVariant,
        ),
        onSelected: (selected) {
          if (selected) {
            onCategoryTap(null);
          }
        },
        visualDensity: VisualDensity.compact,
        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
      ),
    );

    // Chips de categorías (solo mostrar categorías con id)
    for (final category in categories.where((Category c) => c.id != null)) {
      final isSelected = category.id == selectedCategoryId;
      final icon = iconFromName(category.icon);

      chips.add(
        ChoiceChip(
          label: Text(
            category.name,
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: isSelected
                  ? Theme.of(context).colorScheme.onPrimaryContainer
                  : Theme.of(context).colorScheme.onSurface,
            ),
          ),
          selected: isSelected,
          selectedColor: Theme.of(context).colorScheme.primaryContainer,
          avatar: Icon(
            icon,
            size: 16,
            color: isSelected
                ? Theme.of(context).colorScheme.onPrimaryContainer
                : Theme.of(context).colorScheme.onSurfaceVariant,
          ),
          onSelected: (selected) {
            if (selected) {
              onCategoryTap(category.id);
            } else if (isSelected) {
              // Toggle: si ya está seleccionado, deseleccionar
              onCategoryTap(null);
            }
          },
          visualDensity: VisualDensity.compact,
          materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
        ),
      );
    }

    return chips;
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Theme.of(context).scaffoldBackgroundColor,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Fila 1: chips de ciudades (scroll horizontal)
            if (showCityChips) ...[
              SizedBox(
                height: 40,
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Row(
                    children:
                        [...buildCityChips(context)]
                            .expand((w) => [w, const SizedBox(width: 8)])
                            .toList()
                          ..removeLast(),
                  ),
                ),
              ),
              const SizedBox(height: 8),
            ],
            // Fila 2: chips de categorías (scroll horizontal)
            SizedBox(
              height: 42,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 12),
                itemBuilder: (context, i) {
                  if (i == 0) {
                    // Chip "Todas"
                    final isAllSelected = selectedCategoryId == null;
                    return FilterChip(
                      avatar: const Icon(Icons.grid_view, size: 16),
                      label: const Text('Todas'),
                      selected: isAllSelected,
                      onSelected: (_) => onCategoryTap(null),
                    );
                  }
                  // Chips de categorías
                  final category = categories
                      .where((Category c) => c.id != null)
                      .toList()[i - 1];
                  final selected = selectedCategoryId == category.id;
                  final icon = iconFromName(category.icon);
                  return FilterChip(
                    avatar: Icon(icon, size: 16),
                    label: Text(category.name),
                    selected: selected,
                    onSelected: (_) => onCategoryTap(category.id),
                  );
                },
                separatorBuilder: (_, __) => const SizedBox(width: 8),
                itemCount:
                    categories.where((Category c) => c.id != null).length + 1,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Widget para control de eventos cercanos
class _NearbyControlWidget extends StatelessWidget {
  const _NearbyControlWidget({
    required this.radiusKm,
    required this.onRadiusChanged,
  });

  final double radiusKm;
  final ValueChanged<double> onRadiusChanged;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Theme.of(context).scaffoldBackgroundColor,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Radio',
                      style: Theme.of(context).textTheme.bodyMedium
                          ?.copyWith(fontWeight: FontWeight.w500),
                    ),
                    Text(
                      '${radiusKm.toInt()} km',
                      style: Theme.of(context).textTheme.bodyMedium
                          ?.copyWith(fontWeight: FontWeight.w600),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                SliderTheme(
                  data: SliderTheme.of(context).copyWith(
                    trackHeight: 6,
                    thumbShape: const RoundSliderThumbShape(
                      enabledThumbRadius: 9,
                    ),
                    overlayShape: const RoundSliderOverlayShape(
                      overlayRadius: 18,
                    ),
                    activeTrackColor: Theme.of(
                      context,
                    ).colorScheme.primary,
                    inactiveTrackColor: Theme.of(
                      context,
                    ).colorScheme.primary.withOpacity(0.25),
                    thumbColor: Theme.of(context).colorScheme.primary,
                    overlayColor: Theme.of(
                      context,
                    ).colorScheme.primary.withOpacity(0.16),
                  ),
                  child: Slider(
                    value: radiusKm,
                    min: 5,
                    max: 100,
                    divisions: 19,
                    label: '${radiusKm.round()} km',
                    onChanged: onRadiusChanged,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// Delegate para SliverPersistentHeader de filtros (mantenido por compatibilidad, pero ya no se usa)
class _FilterHeaderDelegate extends SliverPersistentHeaderDelegate {
  _FilterHeaderDelegate({
    required this.cities,
    required this.categories,
    this.selectedCityId,
    this.selectedCategoryId,
    required this.onCityTap,
    required this.onCategoryTap,
    this.min = 112.0,
    this.max = 112.0,
  });

  final List<City> cities;
  final List<Category> categories;
  final int? selectedCityId;
  final int? selectedCategoryId;
  final ValueChanged<int?> onCityTap;
  final ValueChanged<int?> onCategoryTap;
  final double min;
  final double max;

  @override
  double get minExtent => min;

  @override
  double get maxExtent => max;

  List<Widget> buildCityChips(BuildContext context) {
    final theme = Theme.of(context);
    final chips = <Widget>[];

    // Chip "Todas"
    chips.add(
      ChoiceChip(
        label: Text('Todas', style: theme.textTheme.labelLarge),
        selected: selectedCityId == null,
        onSelected: (selected) {
          if (selected) {
            onCityTap(null);
          }
        },
        visualDensity: VisualDensity.compact,
        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
      ),
    );

    // Nombres oficiales completos permitidos
    const officialCityNames = {
      'Barbate',
      'Vejer de la Frontera',
      'Zahara de los Atunes',
    };

    // Filtrar ciudades para mostrar solo nombres oficiales completos
    final filteredCities = cities
        .where((city) => officialCityNames.contains(city.name))
        .toList();

    // Ordenar según el orden deseado
    filteredCities.sort((a, b) {
      const order = ['Barbate', 'Vejer de la Frontera', 'Zahara de los Atunes'];
      final indexA = order.indexOf(a.name);
      final indexB = order.indexOf(b.name);
      if (indexA == -1) return 1;
      if (indexB == -1) return -1;
      return indexA.compareTo(indexB);
    });

    // Chips de ciudades (solo nombres oficiales completos)
    for (final city in filteredCities) {
      final isSelected = city.id == selectedCityId;
      chips.add(
        ChoiceChip(
          label: Text(city.name, style: theme.textTheme.labelLarge),
          selected: isSelected,
          onSelected: (selected) {
            if (selected) {
              onCityTap(city.id);
            }
          },
          visualDensity: VisualDensity.compact,
          materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
        ),
      );
    }

    return chips;
  }

  List<Widget> buildCategoryChips(BuildContext context) {
    final theme = Theme.of(context);
    final chips = <Widget>[];

    // Chip "Todas"
    chips.add(
      ChoiceChip(
        label: Text('Todas', style: theme.textTheme.labelLarge),
        selected: selectedCategoryId == null,
        avatar: const Icon(Icons.grid_view, size: 16),
        onSelected: (selected) {
          if (selected) {
            onCategoryTap(null);
          }
        },
        visualDensity: VisualDensity.compact,
        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
      ),
    );

    // Chips de categorías (solo mostrar categorías con id)
    for (final category in categories.where((Category c) => c.id != null)) {
      final isSelected = category.id == selectedCategoryId;
      final icon = iconFromName(category.icon);

      chips.add(
        ChoiceChip(
          label: Text(category.name, style: theme.textTheme.labelLarge),
          selected: isSelected,
          avatar: Icon(icon, size: 16),
          onSelected: (selected) {
            if (selected) {
              onCategoryTap(category.id);
            } else if (isSelected) {
              // Toggle: si ya está seleccionado, deseleccionar
              onCategoryTap(null);
            }
          },
          visualDensity: VisualDensity.compact,
          materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
        ),
      );
    }

    return chips;
  }

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    return Material(
      color: Theme.of(context).scaffoldBackgroundColor,
      child: SizedBox.expand(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Fila 1: chips de ciudades (scroll horizontal "ligero")
              SizedBox(
                height: 36,
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: Row(
                    children:
                        [...buildCityChips(context)]
                            .expand((w) => [w, const SizedBox(width: 8)])
                            .toList()
                          ..removeLast(),
                  ),
                ),
              ),
              const SizedBox(height: 8),
              // Fila 2: chips de categorías (scroll horizontal "ligero")
              SizedBox(
                height: 36,
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: Row(
                    children:
                        [...buildCategoryChips(context)]
                            .expand((w) => [w, const SizedBox(width: 8)])
                            .toList()
                          ..removeLast(),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  bool shouldRebuild(covariant _FilterHeaderDelegate old) {
    return old.selectedCityId != selectedCityId ||
        old.selectedCategoryId != selectedCategoryId ||
        old.cities.length != cities.length ||
        old.categories.length != categories.length;
  }
}

// Delegate para SliverPersistentHeader de control nearby
class _NearbyControlHeaderDelegate extends SliverPersistentHeaderDelegate {
  _NearbyControlHeaderDelegate({
    required this.radiusKm,
    required this.onRadiusChanged,
    this.min = 80.0,
    this.max = 80.0,
  });

  final double radiusKm;
  final ValueChanged<double> onRadiusChanged;
  final double min;
  final double max;

  @override
  double get minExtent => min;

  @override
  double get maxExtent => max;

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    return Material(
      color: Theme.of(context).scaffoldBackgroundColor,
      child: SizedBox.expand(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'A ${radiusKm.round()} km',
                    style: Theme.of(context).textTheme.bodyMedium
                        ?.copyWith(fontWeight: FontWeight.w600),
                  ),
                  Slider(
                    value: radiusKm,
                    min: 5,
                    max: 100,
                    divisions: 19,
                    label: '${radiusKm.round()} km',
                    onChanged: onRadiusChanged,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  bool shouldRebuild(covariant _NearbyControlHeaderDelegate old) {
    return old.radiusKm != radiusKm;
  }
}
