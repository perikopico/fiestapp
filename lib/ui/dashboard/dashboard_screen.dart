import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' hide Category;
import 'package:geolocator/geolocator.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:video_player/video_player.dart';
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
import 'widgets/featured_events_carousel.dart';
import 'widgets/unified_search_bar.dart';
import '../icons/icon_mapper.dart';
import 'package:fiestapp/ui/common/shimmer_widgets.dart';
import '../../utils/date_ranges.dart';
import 'package:intl/intl.dart';

import '../../utils/dashboard_utils.dart';
import '../../services/favorites_service.dart';
import '../../services/auth_service.dart';
import '../../services/logger_service.dart';
import '../../providers/dashboard_provider.dart';
import '../../l10n/app_localizations.dart';
import 'package:provider/provider.dart';
import '../auth/login_screen.dart';
import '../auth/profile_screen.dart';
import 'widgets/bottom_nav_bar.dart';
import 'widgets/auth_banner.dart';
import '../event/event_detail_screen.dart';

// ==== Búsqueda unificada ====
enum SearchMode { city, event }

/// Logo de la barra superior. Guarda tu PNG en: assets/logo/queplan_logo.png
const String _kQuePlanLogoAsset = 'assets/logo/queplan_logo.png';

// ==== Estructura para eventos agrupados por ciudad ====
class CityEventGroup {
  final String cityName;
  final int? cityId;
  final double? distanceKm; // Distancia desde el usuario a la ciudad
  final List<Event> events;
  final bool isUserLocation; // true si es la ciudad donde está el usuario

  CityEventGroup({
    required this.cityName,
    this.cityId,
    this.distanceKm,
    required this.events,
    this.isUserLocation = false,
  });
}

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
  final Map<String, dynamic>? preloadedData;
  
  const DashboardScreen({super.key, this.preloadedData});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();

  /// Pre-carga los datos del dashboard para mejorar la transición desde el splash
  static Future<Map<String, dynamic>> preloadData() async {
    try {
      final eventService = EventService.instance;
      final categoryService = CategoryService();
      
      // Establecer filtro por defecto a "1 Mes" (30 días)
      final r = next30DaysRange();
      
      // Cargar datos en paralelo
      final results = await Future.wait([
        eventService.fetchEvents(
          cityIds: null,
          categoryId: null,
          from: r.from,
          to: r.to,
          radiusKm: 15.0, // Radio por defecto
          center: {'lat': 36.1927, 'lng': -5.9219}, // Ubicación por defecto
          searchTerm: null,
        ),
        eventService.fetchPopularEvents(
          provinceId: null,
          limit: 7,
        ),
        categoryService.fetchAll(),
      ]);

      final upcoming = results[0] as List<Event>;
      final featured = results[1] as List<Event>;
      final categories = results[2] as List<Category>;

      // Pre-cargar imágenes del carrusel destacado usando precacheImage de Flutter
      // Las imágenes se cargarán en caché para acceso rápido
      if (featured.isNotEmpty) {
        final imagePrecacheFutures = featured
            .where((e) => e.imageUrl != null && e.imageUrl!.isNotEmpty)
            .take(5) // Pre-cargar las primeras 5 para tener más imágenes listas
            .map((e) async {
          try {
            final imageProvider = NetworkImage(e.imageUrl!);
            await imageProvider.resolve(const ImageConfiguration());
          } catch (e) {
            // Silenciar errores de precarga
          }
        });
        // No esperar todas, cargar en paralelo y continuar
        Future.wait(imagePrecacheFutures, eagerError: false);
      }

      // Pre-cargar imágenes de los primeros eventos de la lista
      if (upcoming.isNotEmpty) {
        final imagePrecacheFutures = upcoming
            .where((e) => e.imageUrl != null && e.imageUrl!.isNotEmpty)
            .take(8) // Pre-cargar las primeras 8 para la primera vista
            .map((e) async {
          try {
            final imageProvider = NetworkImage(e.imageUrl!);
            await imageProvider.resolve(const ImageConfiguration());
          } catch (e) {
            // Silenciar errores de precarga
          }
        });
        // No esperar todas, cargar en paralelo y continuar
        Future.wait(imagePrecacheFutures, eagerError: false);
      }

      return {
        'upcomingEvents': upcoming,
        'featuredEvents': featured,
        'categories': categories,
      };
    } catch (e) {
      LoggerService.instance.error('Error al pre-cargar datos del dashboard', error: e);
      return {
        'upcomingEvents': <Event>[],
        'featuredEvents': <Event>[],
        'categories': <Category>[],
      };
    }
  }
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
  // Eventos agrupados por ciudad con distancias
  List<CityEventGroup> _eventsByCity = [];
  bool _isLoading = true;
  String? _error;
  int? _selectedCategoryId;
  int? _selectedCityId;
  Set<int> _selectedCityIds = {};
  String? _selectedCityName;
  List<City> _cities = [];
  int? _currentProvinceId; // Province ID para filtrar eventos populares
  DateTime? _fromDate;
  DateTime? _toDate;
  String? _selectedDatePreset;
  bool _isToday = false;
  bool _isNextWeekend = false; // Próximo fin de semana
  bool _isNext7Days = false; // Próximos 7 días
  bool _isNext30Days = false; // Próximos 30 días

  // Nearby events state
  double _radiusKm = 15; // Radio por defecto aumentado a 15km
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


  // Estado del desplegable de filtros
  bool _isFilterPanelExpanded = false;
  Timer? _filterPanelAutoCloseTimer;

  // Hero banner state
  List<String> _heroImageUrls = [];
  int _heroIndex = 0;
  Timer? _heroTimer;
  List<String> _heroTaglines = [];
  bool _isHeroLoading = false;
  bool _textVisible = true; // Control de visibilidad del texto para fade

  // Video splash overlay state
  VideoPlayerController? _videoController;
  bool _showIntro = true;
  bool _isVideoInitialized = false; // Estado para saber si el video está listo
  double _videoOpacity = 1.0;
  bool _videoFinished = false; // Estado para saber si el video terminó
  bool _isVideoInitializing = false; // Protección para evitar inicialización múltiple

  @override
  void initState() {
    super.initState();
    // Inicializar Provider con datos pre-cargados si existen
    // Solo intentar acceder al provider si está disponible
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      try {
        final provider = context.read<DashboardProvider>();
        provider.initialize(preloadedData: widget.preloadedData);
      } catch (e) {
        // Si el provider no está disponible, continuar sin él
        LoggerService.instance.debug('DashboardProvider no disponible aún', data: {'error': e.toString()});
      }
    });
    
    // IMPORTANTE: Verificar permisos PRIMERO para establecer el modo correcto
    // Si no hay permisos, cambiar a modo Ciudad ANTES de cargar datos
    _checkLocationPermissionAndSetMode().then((_) {
      if (!mounted) return;
      // Después de verificar permisos, establecer el filtro por defecto
      // (7 días si hay permisos, 30 días si no)
      _setDefaultWeekFilter();
      // IMPORTANTE: Cargar TODOS los datos PRIMERO, luego reproducir el video
      // Esto asegura que cuando el video termine, la app ya esté completamente cargada
      _loadAllDataFirst().then((_) {
        if (!mounted) return;
        // Sincronizar estado con Provider después de cargar
        _syncStateWithProvider();
        
        // Solo después de cargar todos los datos, inicializar el video
        if (mounted) {
          _initializeIntroVideo();
        }
      });
    });
  }
  
  /// Sincroniza el estado local con el Provider
  void _syncStateWithProvider() {
    if (!mounted) return;
    
    try {
      final provider = context.read<DashboardProvider>();
      setState(() {
        // Sincronizar eventos del Provider con estado local
        if (provider.upcomingEvents.isNotEmpty) {
          _upcomingEvents = provider.upcomingEvents;
        }
        if (provider.featuredEvents.isNotEmpty) {
          _featuredEvents = provider.featuredEvents;
          _featuredEvent = _featuredEvents.isNotEmpty ? _featuredEvents.first : null;
        }
        if (provider.categories.isNotEmpty) {
          _categories = provider.categories;
        }
      });
    } catch (e) {
      // Si el provider no está disponible, continuar sin sincronizar
      LoggerService.instance.debug('No se pudo sincronizar con DashboardProvider', data: {'error': e.toString()});
    }
  }
  
  /// Verifica los permisos de ubicación y establece el modo correcto antes de cargar datos
  Future<void> _checkLocationPermissionAndSetMode() async {
    var permission = await Geolocator.checkPermission();
    
    // Si el permiso está denegado, solicitar permisos solo una vez
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }
    
    final hasPermission = permission == LocationPermission.whileInUse ||
        permission == LocationPermission.always;
    
    setState(() {
      _hasLocationPermission = hasPermission;
      // Si no hay permisos, establecer modo Ciudad automáticamente
      if (!hasPermission) {
        _mode = LocationMode.city;
        // Limpiar ciudad seleccionada para mostrar eventos de toda la provincia
        _selectedCityId = null;
        _selectedCityIds = {};
        _selectedCityName = null;
      }
    });
    
    // Si tenemos permisos, obtener la ubicación (ya no usamos modo Radio con slider)
    if (hasPermission) {
      await _getUserLocation();
    }
  }
  
  /// Carga todos los datos del dashboard ANTES de mostrar el video
  Future<void> _loadAllDataFirst() async {
    try {
      // Si hay datos pre-cargados, usarlos primero
      if (widget.preloadedData != null) {
        setState(() {
          _upcomingEvents = widget.preloadedData!['upcomingEvents'] as List<Event>? ?? [];
          _featuredEvents = widget.preloadedData!['featuredEvents'] as List<Event>? ?? [];
          _categories = widget.preloadedData!['categories'] as List<Category>? ?? [];
          _featuredEvent = _featuredEvents.isNotEmpty ? _featuredEvents.first : null;
        });
      }
      
      // Cargar el resto de datos en paralelo y esperar a que terminen
      await Future.wait([
        widget.preloadedData == null ? _reloadEvents() : Future.value(), // Solo recargar si no hay preloaded
        _loadCities(),
        _loadNearbyCities(),
        _loadHeroBanner(),
      ], eagerError: false); // No fallar si uno falla
      
      // Si había preloaded data, recargar eventos después
      if (widget.preloadedData != null) {
        await _reloadEvents();
      }
      
      // Cargar eventos cercanos después de recargar eventos
      await _loadNearby();
      
      // Marcar como cargado
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    } catch (e) {
      LoggerService.instance.error('Error al cargar datos del dashboard', error: e);
      // Incluso si hay error, marcar como cargado para que el video se muestre
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  /// Inicializa el video de introducción como overlay
  /// IMPORTANTE: Este método solo se llama DESPUÉS de que todos los datos estén cargados
  Future<void> _initializeIntroVideo() async {
    // Protección: evitar inicialización múltiple
    if (_isVideoInitializing || _isVideoInitialized || _videoController != null) {
      LoggerService.instance.debug('Video ya está inicializado o en proceso, ignorando llamada duplicada');
      return;
    }
    
    _isVideoInitializing = true;
    
    try {
      // Crear el controlador
      _videoController = VideoPlayerController.asset('assets/videos/splash.mp4');
      
      // Pre-inicializar el controlador (esto precarga el video)
      // Usar un timeout para evitar que se quede colgado
      await _videoController!.initialize().timeout(
        const Duration(seconds: 5),
        onTimeout: () {
          throw TimeoutException('Video initialization timeout');
        },
      );
      
      if (mounted && _videoController != null) {
        // Configurar video para mejor rendimiento
        _videoController!.setLooping(false);
        _videoController!.setVolume(0.0);
        
        // Añadir listener para detectar cuando termine (solo una vez)
        _videoController!.addListener(_videoListener);
        
        // Marcar video como inicializado ANTES de reproducir
        setState(() {
          _isVideoInitialized = true;
          _isVideoInitializing = false;
        });
        
        // Pequeño delay para asegurar que el widget esté completamente renderizado
        // Esto ayuda a que el video se reproduzca sin lag
        await Future.delayed(const Duration(milliseconds: 100));
        
        if (mounted && _videoController != null && _videoController!.value.isInitialized) {
          // Verificar que el video no esté ya reproduciéndose antes de llamar a play()
          if (!_videoController!.value.isPlaying) {
            // Reproducir automáticamente (solo una vez)
            await _videoController!.play();
            
            // Timeout de seguridad: si el video no termina en 30 segundos, forzar el cierre
            // Esto previene que el video se quede pillado
            final duration = _videoController!.value.duration;
            final maxDuration = duration > Duration.zero 
                ? duration + const Duration(seconds: 2) // 2 segundos después del final
                : const Duration(seconds: 30); // 30 segundos máximo si no se conoce la duración
            
            Future.delayed(maxDuration, () {
              if (mounted && _videoController != null && !_videoFinished) {
                LoggerService.instance.warning('Timeout de seguridad: forzando cierre del video');
                _videoFinished = true;
                _videoController!.removeListener(_videoListener);
                _fadeOutVideo();
              }
            });
          }
        }
      }
    } catch (e) {
      _isVideoInitializing = false;
      LoggerService.instance.error('Error al inicializar video de introducción', error: e);
      // Si hay error, ocultar el overlay inmediatamente y mostrar diálogo
      if (mounted) {
        setState(() {
          _showIntro = false;
          _isVideoInitialized = false;
          _videoFinished = true;
        });
        // Mostrar diálogo de autenticación si el video falla
        _showAuthDialogAfterVideo();
      }
    }
  }

  /// Listener para detectar cuando el video termine
  void _videoListener() {
    if (_videoController == null || !mounted) return;
    
    // Si ya se procesó el final del video, no hacer nada más
    if (_videoFinished) return;
    
    final position = _videoController!.value.position;
    final duration = _videoController!.value.duration;
    
    // Si el video terminó, iniciar fade out (solo una vez)
    // Usar una tolerancia de 100ms para asegurar que se detecte el final
    if (duration > Duration.zero) {
      final difference = duration - position;
      // Si la diferencia es menor a 100ms, considerar que el video terminó
      if (difference <= const Duration(milliseconds: 100)) {
        LoggerService.instance.debug('Video terminado detectado', data: {
          'position': position.inMilliseconds,
          'duration': duration.inMilliseconds,
          'difference': difference.inMilliseconds,
        });
        
        // Marcar como terminado ANTES de remover listener y llamar a fade out
        _videoFinished = true;
        
        // Pausar el video inmediatamente (sin await, ya que es un listener síncrono)
        _videoController!.pause().catchError((e) {
          LoggerService.instance.warning('Error al pausar video al finalizar', data: {'error': e.toString()});
        });
        
        // Remover listener inmediatamente para evitar llamadas múltiples
        _videoController!.removeListener(_videoListener);
        
        // Iniciar fade out
        _fadeOutVideo();
      }
    }
  }

  /// Inicia la animación de desvanecimiento del video
  void _fadeOutVideo() {
    if (!mounted) return;
    
    // Si ya se completó el fade out, no hacer nada
    if (_videoFinished && _videoOpacity == 0.0 && !_showIntro) {
      LoggerService.instance.debug('Fade out ya completado, ignorando llamada');
      return;
    }
    
    // Marcar que el video terminó
    if (!_videoFinished) {
      setState(() {
        _videoFinished = true;
      });
    }
    
    LoggerService.instance.debug('Iniciando fade out del video');
    
    // Animar opacidad de 1.0 a 0.0 en 500ms
    setState(() {
      _videoOpacity = 0.0;
    });
    
    // Después de la animación, eliminar el widget del video
    Future.delayed(const Duration(milliseconds: 500), () async {
      if (!mounted) return;
      
      LoggerService.instance.debug('Completando fade out: ocultando video y haciendo dispose');
      
      setState(() {
        _showIntro = false;
      });
      
        // Pausar el video antes de hacer dispose
        if (_videoController != null) {
          try {
            if (_videoController!.value.isPlaying) {
              await _videoController!.pause();
            }
          } catch (e) {
            LoggerService.instance.warning('Error al pausar video antes de dispose', data: {'error': e.toString()});
          }
          
          // Hacer dispose del controlador
          try {
            _videoController!.removeListener(_videoListener);
            await _videoController!.dispose();
          } catch (e) {
            LoggerService.instance.warning('Error al hacer dispose del video', data: {'error': e.toString()});
          }
          _videoController = null;
        }
      
      // Mostrar diálogo de autenticación después de que el video termine
      _showAuthDialogAfterVideo();
    });
  }
  
  /// Muestra el diálogo de autenticación después de que el video termine
  void _showAuthDialogAfterVideo() {
    if (!mounted) return;
    
    // Pequeño delay para asegurar que la UI esté lista
    Future.delayed(const Duration(milliseconds: 300), () {
      if (mounted && !AuthService.instance.isAuthenticated) {
        AuthBanner.showAuthDialog(context);
      }
    });
  }

  /// Establece el filtro por defecto a "7 Días" (próximos 7 días)
  void _setDefaultWeekFilter() {
    // Establecer filtro por defecto a "7 días" (próximos 7 días)
    final r = next7DaysRange();
    setState(() {
      _isToday = false;
      _isNextWeekend = false;
      _isNext7Days = true; // Activar el filtro de 7 días
      _isNext30Days = false;
      _fromDate = r.from;
      _toDate = r.to;
    });
  }

  @override
  void dispose() {
    _searchDebouncer?.cancel();
    _searchCtrl.dispose();
    _citySearchDebouncer?.cancel();
    _citySearchCtrl.dispose();
    _filterPanelAutoCloseTimer?.cancel();
    _heroTimer?.cancel();
    _videoController?.removeListener(_videoListener);
    _videoController?.dispose();
    super.dispose();
  }

  Future<void> _switchMode(LocationMode mode) async {
    if (_mode == mode) return;
    
    // Si se está cambiando a modo Radio, verificar y solicitar permisos si es necesario
    if (mode == LocationMode.radius) {
      // Verificar servicios de ubicación
      final serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(AppLocalizations.of(context)?.enableLocationServices ?? 'Por favor, activa los servicios de ubicación en Configuración para usar el modo Radio.'),
              duration: const Duration(seconds: 3),
            ),
          );
        }
        return;
      }
      
      // Verificar permisos actuales
      var permission = await Geolocator.checkPermission();
      
      // Si no hay permisos, solicitarlos
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }
      
      // Si el permiso fue denegado permanentemente, mostrar mensaje
      if (permission == LocationPermission.deniedForever) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(AppLocalizations.of(context)?.locationPermissionsDisabled ?? 'Los permisos de ubicación están deshabilitados. Por favor, habilítalos en Configuración para usar el modo Radio.'),
              duration: const Duration(seconds: 4),
              action: SnackBarAction(
                label: AppLocalizations.of(context)?.settings ?? 'Configuración',
                onPressed: () => Geolocator.openLocationSettings(),
              ),
            ),
          );
        }
        await _checkLocationPermission();
        return;
      }
      
      // Si el permiso fue denegado (pero no permanentemente), no cambiar de modo
      if (permission == LocationPermission.denied) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(AppLocalizations.of(context)?.locationPermissionRequired ?? 'Se necesitan permisos de ubicación para usar el modo Radio.'),
              duration: const Duration(seconds: 3),
            ),
          );
        }
        await _checkLocationPermission();
        return;
      }
      
      // Si tenemos permisos, obtener la ubicación actual
      if (permission == LocationPermission.whileInUse || permission == LocationPermission.always) {
        await _getUserLocation();
      }
    }
    
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
        _currentProvinceId = null; // Limpiar provinceId en modo Radio
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
    return _isToday || _isNextWeekend || _isNext7Days || _isNext30Days || 
           (_fromDate != null || _toDate != null);
  }

  /// Obtiene el valor de 'from' a usar en las consultas
  /// Si no hay filtro manual, devuelve hoy a las 00:00 para filtrar eventos pasados
  DateTime _getEffectiveFromDate() {
    if (_fromDate != null) {
      return _fromDate!; // Si hay fecha establecida, usar el valor establecido
    }
    // Si no hay fecha establecida, usar hoy a las 00:00 para filtrar eventos pasados
    // Esto asegura que solo se muestren eventos futuros o del día actual
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

  /// Precarga la siguiente imagen del hero banner
  Future<void> _preloadNextImage() async {
    if (_heroImageUrls.isEmpty || _heroImageUrls.length <= 1) return;
    if (!mounted) return;
    
    final nextIndex = (_heroIndex + 1) % _heroImageUrls.length;
    final nextImageUrl = _heroImageUrls[nextIndex];
    
    try {
      await precacheImage(NetworkImage(nextImageUrl), context);
      LoggerService.instance.debug('Imagen precargada para hero banner', data: {'url': nextImageUrl.substring(0, 50)});
    } catch (e) {
      LoggerService.instance.warning('Error al precargar imagen del hero', data: {'url': nextImageUrl.substring(0, 100), 'error': e.toString()});
      // No hacer nada más, la imagen se cargará cuando se muestre
    }
  }

  /// Imágenes de fallback si Supabase Storage no tiene imágenes
  List<String> _getFallbackHeroImages() {
    return [
      'https://images.unsplash.com/photo-1514525253161-7a46d19cd819?w=800&q=80',
      'https://images.unsplash.com/photo-1482517967863-00e15c9b44be?w=800&q=80',
      'https://images.unsplash.com/photo-1511795409834-ef04bbd61622?w=800&q=80',
      'https://images.unsplash.com/photo-1511578314322-379afb476865?w=800&q=80',
    ];
  }

  /// Carga el hero banner desde Supabase Storage con fallback
  Future<void> _loadHeroBanner() async {
    setState(() {
      _isHeroLoading = true;
    });

    try {
      // Verificar si Supabase está inicializado - esperar un poco si no está listo
      SupabaseClient? client;
      int attempts = 0;
      while (attempts < 5 && client == null) {
        try {
          client = Supabase.instance.client;
        } catch (e) {
          attempts++;
          if (attempts < 5) {
            LoggerService.instance.debug('Supabase no inicializado, esperando', data: {'intento': attempts, 'max': 5});
            await Future.delayed(Duration(milliseconds: 500));
          } else {
            LoggerService.instance.warning('Supabase no inicializado después de 5 intentos, usando imágenes de fallback');
            setState(() {
              _heroImageUrls = _getFallbackHeroImages();
              _isHeroLoading = false;
            });
            return;
          }
        }
      }
      
      if (client == null) {
        setState(() {
          _heroImageUrls = _getFallbackHeroImages();
          _isHeroLoading = false;
        });
        return;
      }
      
      final monthFolder = _currentMonthFolder();
      LoggerService.instance.debug('Buscando imágenes en hero_banners', data: {'folder': monthFolder});
      final storage = client.storage.from('hero_banners');
      final result = await storage.list(path: monthFolder);

      // Filtrar solo imágenes (jpg, jpeg, png, webp)
      final imageFiles = result.where((file) {
        final name = file.name.toLowerCase();
        return name.endsWith('.jpg') ||
            name.endsWith('.jpeg') ||
            name.endsWith('.png') ||
            name.endsWith('.webp');
      }).toList();

      List<String> imageUrls;

      if (imageFiles.isEmpty) {
        // Si no hay imágenes en Supabase para este mes, intentar cargar desde la raíz
        LoggerService.instance.debug('No se encontraron imágenes en carpeta mensual, buscando en raíz', data: {'folder': monthFolder});
        try {
          final rootFiles = await storage.list(path: '');
          final rootImageFiles = rootFiles.where((file) {
            final name = file.name.toLowerCase();
            return name.endsWith('.jpg') || 
                name.endsWith('.jpeg') || 
                name.endsWith('.png') || 
                name.endsWith('.webp');
          }).toList();
          
          if (rootImageFiles.isNotEmpty) {
            LoggerService.instance.info('Imágenes encontradas en raíz de hero_banners', data: {'count': rootImageFiles.length});
            imageUrls = rootImageFiles.map((file) {
              return storage.getPublicUrl(file.name);
            }).toList();
          } else {
            LoggerService.instance.warning('No se encontraron imágenes en Supabase Storage, usando fallback');
            imageUrls = _getFallbackHeroImages();
          }
        } catch (e) {
          LoggerService.instance.error('Error al buscar imágenes en la raíz de hero_banners', error: e);
          LoggerService.instance.info('Usando imágenes de fallback');
          imageUrls = _getFallbackHeroImages();
        }
      } else {
        // Construir todas las URLs públicas
        imageUrls = imageFiles.map((file) {
          return storage.getPublicUrl('$monthFolder/${file.name}');
        }).toList();
        LoggerService.instance.info('Imágenes encontradas en carpeta mensual', data: {'count': imageUrls.length, 'folder': monthFolder});
      }

      // Mezclar las URLs para tener un orden aleatorio
      imageUrls.shuffle(Random());

      setState(() {
        _heroImageUrls = imageUrls;
        _heroTaglines = _getMonthlyTaglines(DateTime.now());
        _heroIndex = 0;
        _isHeroLoading = false;
        _textVisible = true; // Asegurar que el texto esté visible inicialmente
      });

      // Cancelar timer anterior si lo hubiera
      _heroTimer?.cancel();

      // Inicializar timer solo si hay más de una imagen
      if (_heroImageUrls.length > 1) {
        // Precargar la primera imagen siguiente
        _preloadNextImage();
        
        _heroTimer = Timer.periodic(const Duration(seconds: 7), (_) async {
          if (!mounted || _heroImageUrls.isEmpty) return;
          
          // Precargar la siguiente imagen antes de cambiar
          await _preloadNextImage();
          
          // Cambiar el índice solo después de precargar
          if (mounted) {
            // Ocultar texto y cambiar imagen simultáneamente
            // Ambos tendrán su fade respectivo (AnimatedSwitcher para imagen, AnimatedOpacity para texto)
            setState(() {
              _textVisible = false;
              _heroIndex = (_heroIndex + 1) % _heroImageUrls.length;
            });
            
            // Esperar a que termine el fade para mostrar el texto de nuevo
            await Future.delayed(const Duration(milliseconds: 600));
            
            if (mounted) {
              setState(() {
                _textVisible = true;
              });
            }
          }
        });
      }
    } catch (e) {
      LoggerService.instance.error('Error al cargar hero banner desde Supabase', error: e);
      LoggerService.instance.info('Usando imágenes de fallback');
      
      // En caso de error, usar imágenes de fallback
      final fallbackImages = _getFallbackHeroImages();
      fallbackImages.shuffle(Random());
      
      setState(() {
        _heroImageUrls = fallbackImages;
        _heroTaglines = _getMonthlyTaglines(DateTime.now());
        _heroIndex = 0;
        _isHeroLoading = false;
        _textVisible = true;
      });
      _heroTimer?.cancel();
      
      // Inicializar timer con imágenes de fallback
      if (_heroImageUrls.length > 1) {
        _preloadNextImage();
        _heroTimer = Timer.periodic(const Duration(seconds: 7), (_) async {
          if (!mounted || _heroImageUrls.isEmpty) return;
          await _preloadNextImage();
          if (mounted) {
            setState(() {
              _textVisible = false;
              _heroIndex = (_heroIndex + 1) % _heroImageUrls.length;
            });
            await Future.delayed(const Duration(milliseconds: 600));
            if (mounted) {
              setState(() {
                _textVisible = true;
              });
            }
          }
        });
      }
    }
  }

  /// Calcula el provinceId para filtrar eventos populares
  int? _getProvinceIdForPopular() {
    // 1) Si estamos en modo ciudad y hay ciudad seleccionada → usar provincia de esa ciudad
    if (_mode == LocationMode.city && _selectedCityId != null && _cities.isNotEmpty) {
      try {
        final city = _cities.firstWhere(
          (c) => c.id == _selectedCityId,
          orElse: () => _cities.first,
        );
        return city.provinceId; // asumiendo que City tiene provinceId
      } catch (_) {}
    }

    // 2) Si estamos en modo radio y tenemos ciudades cercanas → usar provincia de la primera
    if (_mode == LocationMode.radius && _nearbyCities.isNotEmpty) {
      return _nearbyCities.first.provinceId;
    }

    // 3) Sin ubicación ni ciudad → null (populares de toda la app)
    return null;
  }

  Future<void> _reloadEvents() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      // Si hay una ciudad seleccionada, usar su ID para filtrar eventos
      // Independientemente del modo de ubicación
      final List<int>? cityIds = _selectedCityIds.isNotEmpty
          ? _selectedCityIds.toList()
          : (_selectedCityId != null ? <int>[_selectedCityId!] : null);

      // Determinar si usar radio y centro de ubicación para ordenar por distancia
      // Si hay un searchTerm, no usar radiusKm y center para permitir búsqueda global
      // Si hay cityIds seleccionados, tampoco usar radiusKm y center
      final double? radius;
      dynamic center;
      
      if (_searchEventTerm != null && _searchEventTerm!.trim().isNotEmpty) {
        // Si hay búsqueda de texto, no usar radio para permitir búsqueda global
        radius = null;
        center = null;
      } else if (cityIds != null && cityIds.isNotEmpty) {
        // Si hay ciudades seleccionadas, no usar radio
        radius = null;
        center = null;
      } else if (_hasLocationPermission && _userLat != null && _userLng != null) {
        // Si hay permisos de ubicación y ubicación del usuario, usar un radio amplio para ordenar por distancia
        // Usar un radio grande (100km) para obtener todos los eventos pero ordenados por distancia
        radius = 100.0; // Radio amplio para ordenar por distancia sin limitar resultados
        center = {'lat': _userLat, 'lng': _userLng};
      } else {
        // Si no hay ubicación, no usar radio
        radius = null;
        center = null;
      }

      // Obtener la fecha 'from' efectiva (hoy a las 00:00 por defecto para filtrar eventos pasados)
      final effectiveFrom = _getEffectiveFromDate();
      // Si no hay filtro de fecha, usar null para mostrar todos los eventos futuros
      final effectiveTo = _toDate;

      // Calcular provinceId para eventos populares
      final provinceIdForPopular = _getProvinceIdForPopular();
      
      final results = await Future.wait([
        EventService.instance.fetchEvents(
          cityIds: cityIds,
          categoryId: _selectedCategoryId,
          from: effectiveFrom,
          to: effectiveTo,
          radiusKm: radius,
          center: center,
          searchTerm: _searchEventTerm,
          limit: 200, // Aumentar límite para mostrar eventos de toda la provincia
        ),
        // Popular esta semana: eventos más vistos de esta semana (usando RPC)
        _eventService.fetchPopularEvents(
          provinceId: provinceIdForPopular,
          limit: 7, // por ejemplo, 7 eventos populares
        ),
        _categoryService.fetchAll(),
      ]);

      final upcoming = results[0] as List<Event>;
      final featured = results[1] as List<Event>;
      final categories = results[2] as List<Category>;
      
      // Agrupar eventos por ciudad y calcular distancias
      final eventsByCity = await _groupEventsByCity(upcoming);
      
      setState(() {
        _upcomingEvents = upcoming;
        _featuredEvents = featured;
        _featuredEvent = featured.isNotEmpty ? featured.first : null;
        _categories = categories;
        _eventsByCity = eventsByCity;
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
            content: Text(AppLocalizations.of(context)?.errorLoadingData(e.toString()) ?? 'Error al cargar datos: ${e.toString()}'),
            action: SnackBarAction(
              label: AppLocalizations.of(context)?.retry ?? 'Reintentar',
              onPressed: _reloadEvents,
            ),
            duration: const Duration(seconds: 5),
          ),
        );
      }
    }
  }

  /// Agrupa eventos por ciudad y calcula distancias desde el usuario
  Future<List<CityEventGroup>> _groupEventsByCity(List<Event> events) async {
    if (events.isEmpty) return [];
    
    // Agrupar eventos por cityName
    final Map<String, List<Event>> eventsByCityName = {};
    for (final event in events) {
      final cityName = event.cityName ?? 'Sin ciudad';
      if (!eventsByCityName.containsKey(cityName)) {
        eventsByCityName[cityName] = [];
      }
      eventsByCityName[cityName]!.add(event);
    }
    
    // Obtener todas las ciudades para tener sus coordenadas
    final allCities = await _cityService.fetchCities(provinceId: _currentProvinceId);
    
    // Crear mapa de nombres de ciudad a coordenadas
    final Map<String, City> cityMap = {};
    for (final city in allCities) {
      cityMap[city.name] = city;
    }
    
    // Crear grupos con distancias
    final List<CityEventGroup> groups = [];
    
    for (final entry in eventsByCityName.entries) {
      final cityName = entry.key;
      final cityEvents = entry.value;
      
      // Ordenar eventos dentro de la ciudad con jerarquía estricta:
      // PRIORIDAD 1: Fecha y Hora (ascendente)
      // PRIORIDAD 2: Distancia (ascendente, solo si misma fecha)
      cityEvents.sort((a, b) {
        // CRITERIO PRINCIPAL: Fecha y hora
        final dateCompare = a.startsAt.compareTo(b.startsAt);
        if (dateCompare != 0) return dateCompare;
        
        // CRITERIO SECUNDARIO: Distancia (solo si misma fecha)
        final aDistance = a.distanceKm;
        final bDistance = b.distanceKm;
        
        if (aDistance != null && bDistance != null) {
          return aDistance.compareTo(bDistance);
        }
        
        if (aDistance != null && bDistance == null) return -1;
        if (aDistance == null && bDistance != null) return 1;
        
        return 0;
      });
      
      // Obtener coordenadas de la ciudad
      final city = cityMap[cityName];
      double? distanceKm;
      bool isUserLocation = false;
      
      if (_hasLocationPermission && _userLat != null && _userLng != null) {
        if (city?.lat != null && city?.lng != null) {
          // Calcular distancia desde el usuario a la ciudad
          distanceKm = Geolocator.distanceBetween(
            _userLat!,
            _userLng!,
            city!.lat!,
            city.lng!,
          ) / 1000; // Convertir metros a kilómetros
          
          // Si la distancia es muy pequeña (< 1 km), considerar que es la ciudad del usuario
          if (distanceKm < 1.0) {
            isUserLocation = true;
            distanceKm = 0.0;
          }
        }
      }
      
      groups.add(CityEventGroup(
        cityName: cityName,
        cityId: city?.id,
        distanceKm: distanceKm,
        events: cityEvents,
        isUserLocation: isUserLocation,
      ));
    }
    
    // Ordenar grupos por distancia (de menor a mayor)
    // La ciudad del usuario (distancia ~0) siempre va primero
    groups.sort((a, b) {
      // Si una es la ciudad del usuario, va primero
      if (a.isUserLocation && !b.isUserLocation) return -1;
      if (!a.isUserLocation && b.isUserLocation) return 1;
      
      // Si ambas tienen distancia, ordenar por distancia
      if (a.distanceKm != null && b.distanceKm != null) {
        return a.distanceKm!.compareTo(b.distanceKm!);
      }
      
      // Si solo una tiene distancia, la que tiene distancia va primero
      if (a.distanceKm != null && b.distanceKm == null) return -1;
      if (a.distanceKm == null && b.distanceKm != null) return 1;
      
      // Si ninguna tiene distancia, ordenar alfabéticamente
      return a.cityName.compareTo(b.cityName);
    });
    
    return groups;
  }

  /// Obtiene el título para la sección de eventos populares
  String _popularTitle() {
    final provinceId = _getProvinceIdForPopular();
    if (provinceId == null) {
      return 'Popular esta semana';
    }
    return 'Popular esta semana en tu provincia';
  }

  /// Actualiza el provinceId actual basado en la ciudad seleccionada
  void _updateCurrentProvinceId() {
    if (_selectedCityId != null) {
      // Buscar en la lista de ciudades principales primero
      try {
        final cityInMainList = _cities.firstWhere((c) => c.id == _selectedCityId);
        _currentProvinceId = cityInMainList.provinceId;
        return;
      } catch (e) {
        // Ciudad no encontrada en la lista principal
      }
      
      // Si no está en la lista principal, buscar en ciudades cercanas
      try {
        final cityInNearbyList = _nearbyCities.firstWhere((c) => c.id == _selectedCityId);
        _currentProvinceId = cityInNearbyList.provinceId;
        return;
      } catch (e) {
        // Ciudad no encontrada en la lista cercana
      }
      
      // Si no se encuentra, establecer a null
      _currentProvinceId = null;
    } else {
      _currentProvinceId = null;
    }
  }

  Future<void> _loadCities() async {
    // por ahora usamos Cádiz por slug (para producción usaremos selector)
    final provId = await _cityService.getProvinceIdBySlug('cadiz');
    final cities = await _cityService.fetchCities(provinceId: provId);
    if (!mounted) return;
    setState(() {
      _cities = cities;
      // Establecer el provinceId inicial
      _currentProvinceId = provId;
      // NO seleccionar ninguna ciudad por defecto
      // Dejar _selectedCityId, _selectedCityName y _selectedCityIds en null/vacío
      // para mostrar todos los eventos sin filtrar por ciudad
    });
  }

  /// Expande el radio de búsqueda a 50km y recarga los eventos
  Future<void> _expandRadiusTo50km() async {
    setState(() {
      _radiusKm = 50;
    });
    // Recargar eventos con el nuevo radio
    await _reloadEvents();
    // Si hay ubicación del usuario, también recargar eventos cercanos
    if (_userLat != null && _userLng != null) {
      await _loadNearby();
      await _loadNearbyCities();
    }
  }

  void _clearFilters() {
    setState(() {
      // Ciudad
      _selectedCityId = null;
      _selectedCityIds.clear();
      _selectedCityName = null;
      _currentProvinceId = null;

      // Categoría
      _selectedCategoryId = null;

      // Fechas
      _fromDate = null;
      _toDate = null;
      _isToday = false;
      _isNextWeekend = false;
      _isNext7Days = false;
      _isNext30Days = false;
      _selectedDatePreset = null;

      // Búsqueda de eventos
      _searchEventTerm = null;
      _searchCtrl.clear();
    });

    // Recargar eventos con el estado limpio
    _reloadEvents();
  }

  Future<void> _reloadWithDateRange({DateTime? from, DateTime? to}) async {
    // Actualizar el estado de los flags de fecha según los parámetros recibidos
    if (from != null && to != null) {
      final today = todayRange();
      final next7 = next7DaysRange();
      final next30 = next30DaysRange();
      
      // Comparar fechas para determinar qué filtro se está aplicando
      // Normalizar fechas a solo día (sin hora) para comparación más robusta
      final fromDay = DateTime(from.year, from.month, from.day);
      final toDay = DateTime(to.year, to.month, to.day);
      final todayFromDay = DateTime(today.from.year, today.from.month, today.from.day);
      final todayToDay = DateTime(today.to.year, today.to.month, today.to.day);
      final next7FromDay = DateTime(next7.from.year, next7.from.month, next7.from.day);
      final next7ToDay = DateTime(next7.to.year, next7.to.month, next7.to.day);
      final next30FromDay = DateTime(next30.from.year, next30.from.month, next30.from.day);
      final next30ToDay = DateTime(next30.to.year, next30.to.month, next30.to.day);
      
      final isTodayRange = fromDay == todayFromDay && toDay == todayToDay;
      final is7DaysRange = fromDay == next7FromDay && toDay == next7ToDay;
      final is30DaysRange = fromDay == next30FromDay && toDay == next30ToDay;
      
      setState(() {
        _fromDate = from;
        _toDate = to;
        _isToday = isTodayRange;
        _isNext7Days = is7DaysRange;
        _isNext30Days = is30DaysRange;
        _isNextWeekend = false; // Por ahora, solo manejar los tres principales
        _isLoading = true;
      });
    } else {
      setState(() {
        if (from != null) _fromDate = from;
        if (to != null) _toDate = to;
        _isLoading = true;
      });
    }
    
    try {
      // Si hay una ciudad seleccionada, usar su ID para filtrar eventos
      // Independientemente del modo de ubicación
      final List<int>? cityIds = _selectedCityIds.isNotEmpty
          ? _selectedCityIds.toList()
          : (_selectedCityId != null ? <int>[_selectedCityId!] : null);

      // Si hay un searchTerm, no usar radiusKm y center para permitir búsqueda global
      // Si hay cityIds seleccionados, tampoco usar radiusKm y center
      final double? radius;
      dynamic center;
      
      if (_searchEventTerm != null && _searchEventTerm!.trim().isNotEmpty) {
        // Si hay búsqueda de texto, no usar radio para permitir búsqueda global
        radius = null;
        center = null;
      } else if (cityIds != null && cityIds.isNotEmpty) {
        // Si hay ciudades seleccionadas, no usar radio
        radius = null;
        center = null;
      } else if (_hasLocationPermission && _userLat != null && _userLng != null) {
        // Si hay permisos de ubicación y ubicación del usuario, usar un radio amplio para ordenar por distancia
        // Usar un radio grande (100km) para obtener todos los eventos pero ordenados por distancia
        radius = 100.0; // Radio amplio para ordenar por distancia sin limitar resultados
        center = {'lat': _userLat, 'lng': _userLng};
      } else {
        radius = null;
        center = null;
      }

      // Obtener la fecha 'from' efectiva
      // Si se pasa 'from' explícitamente, usarlo; si no, usar _fromDate o hoy por defecto
      // IMPORTANTE: Cuando se pasa 'from' explícitamente, usarlo directamente sin fallback
      final effectiveFrom = from != null ? from : (_fromDate ?? _getTodayStart());
      // Si se pasa 'to' explícitamente, usarlo; si no, usar _toDate
      final effectiveTo = to != null ? to : _toDate;

      LoggerService.instance.debug(
        '_reloadWithDateRange llamado',
        data: {
          'fromParam': from?.toIso8601String(),
          'toParam': to?.toIso8601String(),
          '_fromDate': _fromDate?.toIso8601String(),
          '_toDate': _toDate?.toIso8601String(),
          'effectiveFrom': effectiveFrom.toIso8601String(),
          'effectiveTo': effectiveTo?.toIso8601String(),
          'cityIds': cityIds?.toString(),
          'searchTerm': _searchEventTerm,
        },
      );

      final events = await EventService.instance.fetchEvents(
        cityIds: cityIds,
        categoryId: _selectedCategoryId,
        from: effectiveFrom,
        to: effectiveTo,
        radiusKm: radius,
        center: center,
        searchTerm: _searchEventTerm,
        limit: 200, // Aumentar límite para mostrar eventos de toda la provincia
      );
      if (!mounted) return;
      
      // Agrupar eventos por ciudad y calcular distancias
      final eventsByCity = await _groupEventsByCity(events);
      
      setState(() {
        _upcomingEvents = events; // nunca null
        _eventsByCity = eventsByCity;
      });
    } catch (e, stackTrace) {
      if (!mounted) return;
      LoggerService.instance.error(
        'Error al recargar eventos con rango de fecha',
        error: e,
        stackTrace: stackTrace,
      );
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Row(
              children: [
                Icon(Icons.warning_amber_rounded, color: Colors.white),
                SizedBox(width: 12),
                Expanded(
                  child: Text('No se pudieron cargar eventos del rango seleccionado'),
                ),
              ],
            ),
            backgroundColor: Theme.of(context).colorScheme.error,
            action: SnackBarAction(
              label: 'Reintentar',
              textColor: Colors.white,
              onPressed: () => _reloadWithDateRange(from: _fromDate, to: _toDate),
            ),
            duration: const Duration(seconds: 4),
          ),
        );
      }
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
                _updateCurrentProvinceId();
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
          label: Text(AppLocalizations.of(context)?.allCategories ?? 'Todas', style: Theme.of(context).textTheme.labelLarge),
          selected: _selectedCityId == null,
            onSelected: (_) {
              setState(() {
                _selectedCityId = null; // todas las ciudades del radio
                _selectedCityName = null;
                _selectedCityIds.clear();
              });
              _updateCurrentProvinceId();
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
              _updateCurrentProvinceId();
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
    if (_selectedCategoryId == null) return AppLocalizations.of(context)?.allCategoriesLabel ?? 'Todas las categorías';
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

  /// Genera el texto informativo según el filtro de fecha seleccionado
  /// Muestra el rango completo de fechas cuando está disponible
  String? _getDateFilterInfoText() {
    final hasDateFilter = _fromDate != null || _toDate != null;
    
    // Si no hay filtro activo, mostrar "1 Mes" por defecto
    if (!hasDateFilter) {
      return 'Mostrando planes: Próximos 30 días';
    }

    // Dynamic label según el filtro activo
    if (_isToday) {
      return 'Mostrando planes: Hoy';
    } else if (_isNext7Days) {
      return 'Mostrando planes: Próximos 7 días';
    } else if (_isNext30Days) {
      return 'Mostrando planes: Próximos 30 días';
    } else if (_fromDate != null && _toDate != null) {
      // Rango personalizado (Calendario)
      final dateFormat = DateFormat('d MMM', 'es');
      return 'Mostrando planes: ${dateFormat.format(_fromDate!)} - ${dateFormat.format(_toDate!)}';
    }

    return null;
  }

  /// Obtiene el texto de la etiqueta del filtro de fecha para mostrar debajo de las categorías
  String _getDateFilterLabelText() {
    // Si no hay filtro activo, mostrar "1 Mes" por defecto
    if (!_isToday && !_isNext7Days && !_isNext30Days && _fromDate == null && _toDate == null) {
      return 'Mostrando planes: Próximo mes';
    }

    // Dynamic label según el filtro activo
    if (_isToday) {
      return 'Mostrando planes: Hoy';
    } else if (_isNext7Days) {
      return 'Mostrando planes: Próximos 7 días';
    } else if (_isNext30Days) {
      return 'Mostrando planes: Próximo mes';
    } else if (_fromDate != null && _toDate != null) {
      // Rango personalizado (Calendario)
      final dateFormat = DateFormat('d MMM', 'es');
      return 'Mostrando planes: ${dateFormat.format(_fromDate!)} - ${dateFormat.format(_toDate!)}';
    }

    return 'Mostrando planes: Próximo mes';
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
      } else if (_isNextWeekend) {
        dateLabel = 'Próximo fin de semana';
      } else if (_isNext7Days) {
        dateLabel = '7 días';
      } else if (_isNext30Days) {
        dateLabel = '30 días';
      } else if (_fromDate != null && _toDate != null) {
        // Rango personalizado (Calendario)
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
              final provider = context.read<DashboardProvider>();
              provider.setSelectedCategory(null);
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
                final provider = context.read<DashboardProvider>();
                final newCategoryId = isSelected ? null : category.id;
                provider.setSelectedCategory(newCategoryId);
                setState(() {
                  _selectedCategoryId = newCategoryId;
                });
                _reloadEvents();
              },
            );
          }),
        ],
      ),
    );
  }

  /// Logo para AppBar/SliverAppBar. Si no existe assets/logo/queplan_logo.png, se muestra "QuePlan".
  /// Escala y recorta el PNG para reducir el padding transparente y que el icono visible llene el espacio.
  Widget _buildAppBarLogo() {
    const double logoHeight = 64;
    const double scale = 2.2;
    return Center(
      child: SizedBox(
        height: logoHeight,
        width: 220,
        child: ClipRect(
          child: Center(
            child: Transform.scale(
              scale: scale,
              child: Image.asset(
                _kQuePlanLogoAsset,
                height: logoHeight,
                fit: BoxFit.contain,
                errorBuilder: (_, __, ___) => const Text('QuePlan'),
              ),
            ),
          ),
        ),
      ),
    );
  }

  /// Construye la barra de búsqueda estilo "Fake Search Bar"
  Widget _buildFakeSearchBar() {
    return InkWell(
      onTap: _openSearchBottomSheet,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: Colors.grey.shade300,
            width: 1.5,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.08),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            Icon(
              Icons.search,
              size: 20,
              color: Colors.grey.shade600,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                'Buscar ciudad, artista o evento...',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Colors.grey.shade700,
                ),
              ),
            ),
          ],
        ),
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
    var permission = await Geolocator.checkPermission();
    
    // Si estamos en modo Radio y no hay permisos, intentar solicitarlos
    if (_mode == LocationMode.radius && permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }
    
    final hasPermission = permission == LocationPermission.whileInUse ||
        permission == LocationPermission.always;
    setState(() {
      _hasLocationPermission = hasPermission;
    });
    
    // Si no hay permisos y estamos en modo Radio, cambiar a modo Ciudad
    if (!hasPermission && _mode == LocationMode.radius) {
      // Solo cambiar si el permiso fue denegado permanentemente o después de solicitarlo
      if (permission == LocationPermission.deniedForever || permission == LocationPermission.denied) {
        setState(() {
          _mode = LocationMode.city;
          // Limpiar ciudad seleccionada para mostrar eventos de toda la provincia
          _selectedCityId = null;
          _selectedCityIds = {};
          _selectedCityName = null;
        });
        // Recargar eventos con el nuevo modo
        await _reloadEvents();
      }
    } else if (hasPermission && _mode == LocationMode.radius) {
      // Si tenemos permisos y estamos en modo Radio, obtener la ubicación
      await _getUserLocation();
    }
  }

  Future<void> _getUserLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      LoggerService.instance.warning('Servicios de ubicación desactivados');
      setState(() {
        _hasLocationPermission = false;
      });
      return;
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        LoggerService.instance.warning('Permiso de ubicación denegado');
        setState(() {
          _hasLocationPermission = false;
        });
        // Si estamos en modo Radio, cambiar a modo Ciudad
        if (_mode == LocationMode.radius) {
          await _switchMode(LocationMode.city);
        }
        return;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      LoggerService.instance.warning('Permiso de ubicación denegado permanentemente');
      setState(() {
        _hasLocationPermission = false;
      });
      // Si estamos en modo Radio, cambiar a modo Ciudad
      if (_mode == LocationMode.radius) {
        await _switchMode(LocationMode.city);
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
    // Recargar eventos para aplicar ordenamiento por distancia
    await _reloadEvents();
    // Solo cargar eventos cercanos si estamos en modo Ciudad
    if (_mode == LocationMode.city) {
      await _loadNearby();
    }
    await _loadNearbyCities();
  }


  void _openSearchBottomSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Theme.of(context).colorScheme.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => _SearchSuggestionsBottomSheet(
        initialQuery: _searchEventTerm ?? _selectedCityName ?? '',
        selectedCityId: _selectedCityId,
        onCitySelected: (city) {
          setState(() {
            _selectedCityId = city.id;
            _selectedCityIds = {city.id};
            _selectedCityName = city.name;
            _searchEventTerm = null; // Limpiar búsqueda de texto cuando se selecciona ciudad
          });
          _updateCurrentProvinceId();
          _reloadEvents();
          Navigator.pop(context);
        },
        onSearchSubmitted: (query) {
          // Cuando se busca texto, limpiar selección de ciudad y usar búsqueda de texto
          setState(() {
            _searchEventTerm = query;
            _selectedCityId = null;
            _selectedCityIds = {};
            _selectedCityName = null;
          });
          _reloadEvents();
          Navigator.pop(context);
        },
        onClear: () {
          setState(() {
            _searchEventTerm = null;
            _selectedCityId = null;
            _selectedCityIds = {};
            _selectedCityName = null;
          });
          _reloadEvents();
          Navigator.pop(context);
        },
      ),
    );
  }

  Widget _buildFilterPanel() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Contenido de filtros siempre visible y compacto
          _buildExpandedFilterContent(),
        ],
      ),
    );
  }

  Widget _buildExpandedFilterContent() {
    return Padding(
      padding: const EdgeInsets.only(top: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Contenido según el modo - Compacto
          // Categorías en slide horizontal compacto (sin slider de distancia)
          SizedBox(
            height: 50,
            child: _buildHorizontalCategoriesList(),
          ),
          if (_mode == LocationMode.city) ...[
            // Modo Ciudad: Búsqueda de ciudad
            UnifiedSearchBar(
              selectedCityId: _selectedCityId,
              onCitySelected: (city) {
                _onFilterInteraction();
                if (mounted) {
                  setState(() {
                    _selectedCityId = city.id;
                    _selectedCityIds = {city.id};
                    _selectedCityName = city.name;
                    // Limpiar searchTerm cuando se selecciona una ciudad
                    // para evitar conflictos entre cityIds y searchTerm
                    _searchEventTerm = null;
                  });
                  _updateCurrentProvinceId();
                  _reloadEvents();
                }
              },
              onSearchChanged: null,
            ),
            const SizedBox(height: 12),
          ],
          const SizedBox(height: 12),
          // Chips de fecha: Hoy, 7 Días, 1 Mes (por defecto), Calendario - Compacto
          Wrap(
            spacing: 6,
            runSpacing: 6,
            children: [
              FilterChip(
                label: const Text('Hoy'),
                selected: _isToday,
                visualDensity: VisualDensity.compact,
                onSelected: (_) {
                  _onFilterInteraction();
                  // Calcular el rango de "Hoy" en el momento del clic para asegurar precisión
                  final r = todayRange();
                  // Recargar inmediatamente con el rango calculado (esto actualizará el estado internamente)
                  _reloadWithDateRange(from: r.from, to: r.to);
                },
              ),
              FilterChip(
                label: const Text('7 Días'),
                selected: _isNext7Days,
                visualDensity: VisualDensity.compact,
                onSelected: (_) {
                  _onFilterInteraction();
                  final r = next7DaysRange();
                  setState(() {
                    _isToday = false;
                    _isNextWeekend = false;
                    _isNext7Days = true;
                    _isNext30Days = false;
                  });
                  _reloadWithDateRange(from: r.from, to: r.to);
                },
              ),
              FilterChip(
                label: const Text('1 Mes'),
                selected: _isNext30Days,
                visualDensity: VisualDensity.compact,
                onSelected: (_) {
                  _onFilterInteraction();
                  final r = next30DaysRange();
                  setState(() {
                    _isToday = false;
                    _isNextWeekend = false;
                    _isNext7Days = false;
                    _isNext30Days = true;
                  });
                  _reloadWithDateRange(from: r.from, to: r.to);
                },
              ),
              OutlinedButton.icon(
                icon: const Icon(Icons.calendar_today, size: 14),
                label: const Text('Calendario'),
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                  minimumSize: const Size(0, 32),
                  visualDensity: VisualDensity.compact,
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
    );
  }

  Widget _buildHorizontalCategoriesList() {
    if (_categories.isEmpty) {
      return const Center(child: Text('No hay categorías disponibles'));
    }

    return ListView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 4),
      children: [
        // Chip "Todas" estilo Pill compacto
        Padding(
          padding: const EdgeInsets.only(right: 8),
          child: _buildCompactCategoryChip(
            label: AppLocalizations.of(context)?.allCategories ?? 'Todas',
            icon: Icons.grid_view,
            isSelected: _selectedCategoryId == null,
            categoryColor: Colors.grey,
            onTap: () {
              final provider = context.read<DashboardProvider>();
              provider.setSelectedCategory(null);
              _onFilterInteraction();
              setState(() {
                _selectedCategoryId = null;
              });
              _reloadEvents();
            },
          ),
        ),
        // Categorías estilo Pills compactos
        ..._categories.where((c) => c.id != null).map((category) {
          final categoryColor = _getColorForCategory(category.name);
          final isSelected = category.id == _selectedCategoryId;
          return Padding(
            padding: const EdgeInsets.only(right: 8),
            child: _buildCompactCategoryChip(
              label: category.name,
              icon: iconFromName(category.icon),
              isSelected: isSelected,
              categoryColor: categoryColor,
              onTap: () {
                final provider = context.read<DashboardProvider>();
                final newCategoryId = isSelected ? null : category.id;
                provider.setSelectedCategory(newCategoryId);
                _onFilterInteraction();
                setState(() {
                  _selectedCategoryId = newCategoryId;
                });
                _reloadEvents();
              },
            ),
          );
        }),
      ],
    );
  }

  /// Construye un chip compacto de categoría (estilo horizontal)
  Widget _buildCompactCategoryChip({
    required String label,
    required IconData icon,
    required bool isSelected,
    required Color categoryColor,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        constraints: const BoxConstraints(
          minHeight: 36,
          maxHeight: 36, // Altura fija compacta de 36px
        ),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected
              ? categoryColor.withOpacity(0.15)
              : Theme.of(context).colorScheme.surfaceVariant.withOpacity(0.5),
          borderRadius: BorderRadius.circular(16),
          border: isSelected
              ? Border.all(color: categoryColor, width: 1.5)
              : Border.all(
                  color: Theme.of(context).colorScheme.outline.withOpacity(0.1),
                  width: 1,
                ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 16, // Icono pequeño
              color: isSelected
                  ? categoryColor
                  : Theme.of(context).colorScheme.onSurfaceVariant,
            ),
            const SizedBox(width: 6),
            Text(
              label,
              style: TextStyle(
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                fontSize: 13,
                color: isSelected
                    ? categoryColor
                    : Theme.of(context).colorScheme.onSurface,
              ),
            ),
          ],
        ),
      ),
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
        _isNextWeekend = false;
        _isNext7Days = false;
        _isNext30Days = false;
      });
      _reloadWithDateRange(from: picked.start, to: picked.end);
    }
  }

  Color _getColorForCategory(String categoryName) {
    if (categoryName.isEmpty) return Colors.grey;
    
    final name = categoryName.toLowerCase();
    
    // Música
    if (name.contains('música') || name.contains('musica') || name.contains('music')) {
      return const Color(0xFF9C27B0); // Purple
    }
    // Gastronomía
    else if (name.contains('gastronomía') || name.contains('gastronomia') || name.contains('gastronomy') || name.contains('comida')) {
      return const Color(0xFFFF6F00); // Amber
    }
    // Deportes
    else if (name.contains('deporte') || name.contains('deportes') || name.contains('sport')) {
      return const Color(0xFF4CAF50); // Green
    }
    // Arte y Cultura
    else if (name.contains('arte') || name.contains('cultura') || name.contains('culture') || name.contains('art')) {
      return const Color(0xFF2196F3); // Blue
    }
    // Aire Libre
    else if (name.contains('aire libre') || name.contains('aire-libre') || name.contains('naturaleza') || name.contains('nature')) {
      return const Color(0xFF00BCD4); // Cyan/Teal
    }
    // Tradiciones
    else if (name.contains('tradición') || name.contains('tradiciones') || name.contains('tradicion') || name.contains('tradition')) {
      return const Color(0xFFE91E63); // Pink/Red
    }
    // Mercadillos
    else if (name.contains('mercadillo') || name.contains('mercadillos') || name.contains('mercado') || name.contains('mercados') || name.contains('market')) {
      return const Color(0xFFFF9800); // Orange
    }
    
    return Colors.grey;
  }

  Widget _buildCategoriesGrid() {
    // Intentar usar Provider si está disponible, sino usar estado local
    final provider = context.watch<DashboardProvider>();
    final categories = provider.categories.isNotEmpty ? provider.categories : _categories;
    final selectedCategoryId = provider.selectedCategoryId ?? _selectedCategoryId;
    
    if (categories.isEmpty) {
      return const Text('No hay categorías disponibles');
    }

    final screenWidth = MediaQuery.of(context).size.width;
    final isNarrow = screenWidth < 600;
    final crossAxisCount = isNarrow ? 3 : 4;

    final List<Widget> categoryWidgets = [];

    // Cuadro "Todas"
    final isAllSelected = selectedCategoryId == null;
    categoryWidgets.add(
      InkWell(
        onTap: () {
          // Usar Provider si está disponible
          final provider = context.read<DashboardProvider>();
          provider.setSelectedCategory(null);
          // También actualizar estado local para compatibilidad
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
                AppLocalizations.of(context)?.allCategories ?? 'Todas',
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
                // Usar Provider si está disponible
                final provider = context.read<DashboardProvider>();
                final newCategoryId = isSelected ? null : category.id;
                provider.setSelectedCategory(newCategoryId);
                // También actualizar estado local para compatibilidad
                setState(() {
                  _selectedCategoryId = newCategoryId;
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
    // Calcular altura responsive - reducida en un 20%
    final size = MediaQuery.of(context).size;
    final isMobile = size.width < 600;
    final bannerHeight = isMobile ? 384.0 : 320.0; // Reducido 20% (480*0.8=384, 400*0.8=320)

    if (_isHeroLoading) {
      return SizedBox(
        width: double.infinity,
        height: bannerHeight,
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
        height: bannerHeight,
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
      height: bannerHeight,
      width: double.infinity,
      child: Stack(
        fit: StackFit.expand,
        children: [
          // Imagen con AnimatedSwitcher para fade suave
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 600),
            child: ClipRRect(
              key: ValueKey<String>(imageUrl), // Key único para cada imagen
              borderRadius: BorderRadius.circular(0),
              child: Image.network(
                imageUrl,
                fit: BoxFit.cover,
                width: double.infinity,
                height: bannerHeight,
                errorBuilder: (_, __, ___) => Container(
                  width: double.infinity,
                  height: bannerHeight,
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
                    height: bannerHeight,
                    color: Theme.of(context).colorScheme.surfaceVariant,
                    child: const Center(
                      child: CircularProgressIndicator(),
                    ),
                  );
                },
              ),
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
          // Texto con AnimatedOpacity para fade suave
          if (tagline != null)
            Positioned(
              left: 16,
              right: 16,
              bottom: 16,
              child: AnimatedOpacity(
                opacity: _textVisible ? 1.0 : 0.0,
                duration: const Duration(milliseconds: 600),
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
            ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_error != null && !_isLoading) {
      return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          toolbarHeight: 64,
          title: _buildAppBarLogo(),
        ),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.error_outline,
                  size: 64,
                  color: Theme.of(context).colorScheme.error,
                ),
                const SizedBox(height: 16),
                Text(
                  'Error al cargar eventos',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Text(
                    _error!,
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                ElevatedButton.icon(
                  onPressed: () {
                    setState(() {
                      _error = null;
                    });
                    _reloadEvents();
                  },
                  icon: const Icon(Icons.refresh),
                  label: const Text('Reintentar'),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 12,
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                TextButton.icon(
                  onPressed: () {
                    setState(() {
                      _error = null;
                      _clearFilters();
                    });
                  },
                  icon: const Icon(Icons.clear_all),
                  label: const Text('Limpiar filtros y reintentar'),
                ),
              ],
            ),
          ),
        ),
      );
    }

    // Envolver el Scaffold en un Stack para añadir el overlay del video
    // IMPORTANTE: El Scaffold (Dashboard) se carga INMEDIATAMENTE en segundo plano
    // mientras se muestra el overlay blanco/video. Cuando el video termina,
    // la app ya está lista y cargada.
    return Stack(
      children: [
        // Capa 1 (Fondo): El Scaffold con toda la UI de la app
        // Esta capa se carga y renderiza desde el inicio, aunque esté tapada por el overlay
        Scaffold(
          extendBody: true, // Permite que el body se extienda detrás del bottom navigation bar
          backgroundColor: Colors.transparent, // Fondo transparente del Scaffold
          body: Container(
        // Fondo con efecto espejo y diferentes transparencias
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            stops: const [0.0, 0.25, 0.5, 0.75, 1.0],
            colors: [
              Theme.of(context).scaffoldBackgroundColor,
              Theme.of(context).scaffoldBackgroundColor.withOpacity(0.98),
              Theme.of(context).scaffoldBackgroundColor.withOpacity(0.95),
              Theme.of(context).scaffoldBackgroundColor.withOpacity(0.92),
              Theme.of(context).scaffoldBackgroundColor.withOpacity(0.88),
            ],
          ),
        ),
        child: Stack(
          children: [
            // Capas de espejo con diferentes opacidades
            Positioned(
              top: -50,
              right: -50,
              child: Container(
                width: 200,
                height: 200,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(
                    colors: [
                      Colors.white.withOpacity(0.1),
                      Colors.white.withOpacity(0.05),
                      Colors.transparent,
                    ],
                  ),
                ),
              ),
            ),
            Positioned(
              bottom: -100,
              left: -100,
              child: Container(
                width: 300,
                height: 300,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(
                    colors: [
                      Colors.white.withOpacity(0.08),
                      Colors.white.withOpacity(0.03),
                      Colors.transparent,
                    ],
                  ),
                ),
              ),
            ),
            Positioned(
              top: MediaQuery.of(context).size.height * 0.3,
              left: MediaQuery.of(context).size.width * 0.5,
              child: Container(
                width: 150,
                height: 150,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(
                    colors: [
                      Colors.white.withOpacity(0.06),
                      Colors.white.withOpacity(0.02),
                      Colors.transparent,
                    ],
                  ),
                ),
              ),
            ),
            SafeArea(
              child: RefreshIndicator(
                onRefresh: () {
                  // Si hay un filtro de fecha activo, usar _reloadWithDateRange
                  if (_fromDate != null || _toDate != null) {
                    return _reloadWithDateRange(from: _fromDate, to: _toDate);
                  }
                  // Si no hay filtro de fecha, usar _reloadEvents
                  return _reloadEvents();
                },
                child: CustomScrollView(
                  slivers: [
              SliverAppBar(
                title: _buildAppBarLogo(),
                centerTitle: true,
                floating: true,
                snap: true,
                elevation: 0,
                toolbarHeight: 64,
                collapsedHeight: 64,
                expandedHeight: 64,
                actions: const [],
              ),
              // Barra de búsqueda visible estilo "Fake Search Bar"
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
                  child: _buildFakeSearchBar(),
                ),
              ),
              SliverToBoxAdapter(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Carrusel de eventos destacados estilo Netflix
                    if (!_isLoading && _featuredEvents.isNotEmpty) ...[
                      FeaturedEventsCarousel(events: _featuredEvents),
                      const SizedBox(height: 8),
                    ] else if (_isLoading) ...[
                      // Placeholder sutil mientras carga (sin ruleta visible)
                      AnimatedOpacity(
                        opacity: 0.3,
                        duration: const Duration(milliseconds: 300),
                        child: SizedBox(
                          height: 235,
                          child: Container(
                            color: Colors.grey.shade900,
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),
                    ],
                    if (!_isLoading) ...[_buildFilterPanel()],
                    // Etiqueta dinámica del filtro de fecha
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
                        padding: const EdgeInsets.fromLTRB(16, 12, 16, 20),
                        child: UpcomingEventsSection(
                          eventsByCity: _eventsByCity,
                          selectedCategoryId: _selectedCategoryId,
                          onClearFilters: _clearFilters,
                          showCategory: true,
                          dateFilterText: _getDateFilterInfoText(),
                          // Información de búsqueda activa (búsqueda de texto o filtros aplicados)
                          hasActiveSearch: (_searchEventTerm != null && _searchEventTerm!.isNotEmpty) ||
                              _selectedCategoryId != null ||
                              _selectedCityId != null ||
                              _fromDate != null ||
                              _toDate != null,
                          searchTerm: _searchEventTerm,
                        ),
                      ),
                    // Sección "Cerca de ti" (solo en modo Ciudad, mostrando eventos cercanos a tu ubicación real)
                    // En modo Radio no se muestra porque "Próximos eventos" ya muestra los eventos del radio
                    // Solo mostrar si hay permisos de ubicación y ubicación real del usuario
                    if (_isNearbyLoading)
                      Padding(
                        padding: const EdgeInsets.fromLTRB(8, 8, 8, 16),
                        child: ShimmerBlock(height: 80),
                      )
                    else if (_mode == LocationMode.city && 
                             _hasLocationPermission && 
                             _userLat != null && 
                             _userLng != null &&
                             _nearbyEvents.isNotEmpty)
                      Padding(
                        padding: const EdgeInsets.fromLTRB(8, 8, 8, 16),
                        child: NearbyEventsSection(events: _nearbyEvents),
                      )
                    else
                      const SizedBox.shrink(),
                    const SizedBox(height: 100), // Espacio para la barra de navegación flotante
                  ],
                ), // Cierra Column
              ), // Cierra SliverToBoxAdapter
            ], // Cierra slivers del CustomScrollView
                ), // Cierra CustomScrollView
              ), // Cierra RefreshIndicator
            ), // Cierra SafeArea
            // Barra de navegación flotante - sin fondo del Scaffold
            const Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              child: BottomNavBar(),
            ),
          ], // Cierra children del Stack interno
        ), // Cierra Stack interno
        ), // Cierra Container (body del Scaffold)
        ), // Cierra Scaffold
        // Capa 2 (Frente - MÁS ALTA): Video overlay (solo si _showIntro es true)
        // Ignora SafeArea para cubrir toda la pantalla (notch, barra inferior, etc.)
        // Esta capa debe estar por encima de TODO, incluyendo diálogos
        if (_showIntro)
          Positioned.fill(
            child: MediaQuery.removePadding(
              context: context,
              removeTop: true,
              removeBottom: true,
              removeLeft: true,
              removeRight: true,
              child: IgnorePointer(
                // Ignorar eventos de puntero para que no interfiera con la UI debajo
                ignoring: true, // El video no necesita recibir eventos táctiles
                child: RepaintBoundary(
                  // RepaintBoundary optimiza el renderizado del video reduciendo repaints innecesarios
                  child: _isVideoInitialized && _videoController != null && _videoController!.value.isInitialized
                      ? AnimatedOpacity(
                          opacity: _videoOpacity,
                          duration: const Duration(milliseconds: 500),
                          curve: Curves.easeOut,
                          child: Container(
                            color: Colors.black,
                            width: double.infinity,
                            height: double.infinity,
                            // Usar FittedBox con BoxFit.cover para llenar toda la pantalla sin distorsión
                            // Esto es más eficiente que usar LayoutBuilder + Transform
                            child: FittedBox(
                              fit: BoxFit.cover,
                              alignment: Alignment.center,
                              child: SizedBox(
                                width: _videoController!.value.size.width,
                                height: _videoController!.value.size.height,
                                child: VideoPlayer(_videoController!),
                              ),
                            ),
                          ),
                        )
                      : Container(
                          // Fondo blanco sólido mientras el video se inicializa
                          color: Colors.white,
                          width: double.infinity,
                          height: double.infinity,
                        ),
                ),
              ),
            ),
          ),
      ],
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
  final List<CityEventGroup> eventsByCity;
  final int? selectedCategoryId;
  final VoidCallback? onClearFilters;
  final bool showCategory;
  final String? dateFilterText;
  // Información de búsqueda activa
  final bool hasActiveSearch;
  final String? searchTerm;

  const UpcomingEventsSection({
    super.key,
    required this.eventsByCity,
    this.selectedCategoryId,
    this.onClearFilters,
    this.showCategory = true,
    this.dateFilterText,
    this.hasActiveSearch = false,
    this.searchTerm,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 20),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: Theme.of(context).colorScheme.outline.withOpacity(0.08),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Theme.of(context).colorScheme.shadow.withOpacity(0.06),
            blurRadius: 12,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Lista de eventos agrupados por ciudad
          UpcomingList(
            eventsByCity: eventsByCity,
            selectedCategoryId: selectedCategoryId,
            onClearFilters: onClearFilters,
            showCategory: showCategory,
            // Texto del filtro de fecha activo
            dateFilterText: dateFilterText,
            // Información de búsqueda activa
            hasActiveSearch: hasActiveSearch,
            searchTerm: searchTerm,
          ),
        ],
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
      padding: const EdgeInsets.symmetric(vertical: 4),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceVariant,
        borderRadius: BorderRadius.circular(16),
      ),
      child: CategoriesGrid(
        categories: categories,
        selectedCategoryId: selectedCategoryId,
        onCategoryTap: (categoryId) {
          // Usar Provider si está disponible
          final provider = Provider.of<DashboardProvider>(context, listen: false);
          provider.setSelectedCategory(categoryId);
          // Llamar callback original también
          onCategoryTap(categoryId);
        },
      ),
    );
  }
}

class PopularThisWeekSection extends StatelessWidget {
  final List<Event> events;
  final VoidCallback? onClearFilters;
  final String title;

  const PopularThisWeekSection({
    super.key,
    required this.events,
    this.onClearFilters,
    this.title = 'Popular esta semana',
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 20),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: Theme.of(context).colorScheme.outline.withOpacity(0.08),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Theme.of(context).colorScheme.shadow.withOpacity(0.06),
            blurRadius: 12,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: PopularCarousel(
        events: events,
        onClearFilters: onClearFilters,
        title: title,
      ),
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
                  'No hay eventos cerca de ti.',
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
                            price: e.price,
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
    return Padding(
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

// ==== Widget de búsqueda con sugerencias ====
class _SearchSuggestionsBottomSheet extends StatefulWidget {
  final String initialQuery;
  final int? selectedCityId;
  final ValueChanged<City> onCitySelected;
  final ValueChanged<String> onSearchSubmitted;
  final VoidCallback onClear;

  const _SearchSuggestionsBottomSheet({
    required this.initialQuery,
    this.selectedCityId,
    required this.onCitySelected,
    required this.onSearchSubmitted,
    required this.onClear,
  });

  @override
  State<_SearchSuggestionsBottomSheet> createState() => _SearchSuggestionsBottomSheetState();
}

class _SearchSuggestionsBottomSheetState extends State<_SearchSuggestionsBottomSheet> {
  final TextEditingController _searchController = TextEditingController();
  final CityService _cityService = CityService.instance;
  final EventService _eventService = EventService.instance;

  Timer? _searchDebouncer;
  String _searchQuery = '';
  bool _isSearching = false;
  List<City> _cityResults = [];
  List<Event> _eventResults = [];
  List<String> _placeResults = []; // Lugares únicos

  @override
  void initState() {
    super.initState();
    _searchController.text = widget.initialQuery;
    _searchQuery = widget.initialQuery;
    if (widget.initialQuery.isNotEmpty) {
      _performSearch(widget.initialQuery);
    }
  }

  @override
  void dispose() {
    _searchDebouncer?.cancel();
    _searchController.dispose();
    super.dispose();
  }

  void _performSearch(String query) async {
    if (query.trim().isEmpty) {
      setState(() {
        _cityResults.clear();
        _eventResults.clear();
        _placeResults.clear();
        _isSearching = false;
      });
      return;
    }

    setState(() {
      _isSearching = true;
    });

    try {
      // Buscar ciudades, eventos y lugares en paralelo
      final results = await Future.wait([
        _cityService.searchCities(query),
        _eventService.searchEvents(query: query, cityId: widget.selectedCityId),
      ]);

      if (!mounted) return;

      final cities = results[0] as List<City>;
      final events = results[1] as List<Event>;

      // Extraer lugares únicos de los eventos
      final places = <String>{};
      for (final event in events) {
        if (event.place != null && event.place!.trim().isNotEmpty) {
          final placeLower = event.place!.toLowerCase();
          final queryLower = query.toLowerCase();
          // Solo incluir lugares que contengan el término de búsqueda
          if (placeLower.contains(queryLower)) {
            places.add(event.place!);
          }
        }
      }

      setState(() {
        _cityResults = cities;
        _eventResults = events;
        _placeResults = places.toList()..sort();
        _isSearching = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _isSearching = false;
      });
    }
  }

  void _onSearchChanged(String value) {
    setState(() {
      _searchQuery = value;
    });

    _searchDebouncer?.cancel();
    if (value.trim().isNotEmpty) {
      _searchDebouncer = Timer(const Duration(milliseconds: 400), () {
        _performSearch(value);
      });
    } else {
      setState(() {
        _cityResults.clear();
        _eventResults.clear();
        _placeResults.clear();
      });
    }
  }

  void _handleCitySelected(City city) {
    widget.onCitySelected(city);
  }

  void _handleEventSelected(Event event) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => EventDetailScreen(event: event),
      ),
    );
  }

  void _handlePlaceSelected(String place) {
    // Cuando se selecciona un lugar, buscar eventos en ese lugar
    widget.onSearchSubmitted(place);
  }

  void _handleSearchSubmitted(String query) {
    if (query.trim().isEmpty) {
      widget.onClear();
      return;
    }

    // Si hay una sola ciudad y no hay eventos ni lugares, seleccionarla
    if (_cityResults.length == 1 && _eventResults.isEmpty && _placeResults.isEmpty) {
      _handleCitySelected(_cityResults.first);
      return;
    }

    // Si hay un solo evento y no hay ciudades ni lugares, navegar a él
    if (_eventResults.length == 1 && _cityResults.isEmpty && _placeResults.isEmpty) {
      _handleEventSelected(_eventResults.first);
      return;
    }

    // Si hay un solo lugar y no hay ciudades ni eventos, buscar por ese lugar
    if (_placeResults.length == 1 && _cityResults.isEmpty && _eventResults.isEmpty) {
      _handlePlaceSelected(_placeResults.first);
      return;
    }

    // En otros casos, hacer búsqueda de texto
    widget.onSearchSubmitted(query);
  }

  @override
  Widget build(BuildContext context) {
    final hasResults = _cityResults.isNotEmpty || _eventResults.isNotEmpty || _placeResults.isNotEmpty;
    final hasQuery = _searchQuery.trim().isNotEmpty;

    return Padding(
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
            'Buscar ciudad, artista o evento...',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              color: Theme.of(context).colorScheme.onSurface,
            ),
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _searchController,
            autofocus: true,
            textInputAction: TextInputAction.search,
            style: TextStyle(color: Theme.of(context).colorScheme.onSurface),
            decoration: InputDecoration(
              hintText: 'Buscar ciudad, artista o evento...',
              prefixIcon: Icon(
                Icons.search,
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
              suffixIcon: hasQuery
                  ? IconButton(
                      icon: _isSearching
                          ? const SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            )
                          : const Icon(Icons.clear),
                      onPressed: () {
                        _searchController.clear();
                        _onSearchChanged('');
                        widget.onClear();
                      },
                    )
                  : null,
            ),
            onChanged: _onSearchChanged,
            onSubmitted: _handleSearchSubmitted,
          ),
          const SizedBox(height: 8),
          // Mostrar resultados de búsqueda
          if (hasResults)
            Flexible(
              child: Container(
                constraints: const BoxConstraints(maxHeight: 400),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surface,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: Theme.of(context).colorScheme.outline.withOpacity(0.2),
                  ),
                ),
                child: ListView(
                  shrinkWrap: true,
                  padding: EdgeInsets.zero,
                  children: [
                    // Resultados de ciudades
                    if (_cityResults.isNotEmpty) ...[
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 8,
                        ),
                        child: Text(
                          'Ciudades',
                          style: Theme.of(context).textTheme.labelSmall?.copyWith(
                            color: Theme.of(context).colorScheme.onSurfaceVariant,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      ..._cityResults.map((city) {
                        return ListTile(
                          dense: true,
                          leading: Icon(
                            Icons.location_city,
                            size: 20,
                            color: Theme.of(context).colorScheme.onSurfaceVariant,
                          ),
                          title: Text(city.name),
                          onTap: () => _handleCitySelected(city),
                        );
                      }),
                      if (_eventResults.isNotEmpty || _placeResults.isNotEmpty)
                        const Divider(height: 1),
                    ],
                    // Resultados de lugares
                    if (_placeResults.isNotEmpty) ...[
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 8,
                        ),
                        child: Text(
                          'Lugares',
                          style: Theme.of(context).textTheme.labelSmall?.copyWith(
                            color: Theme.of(context).colorScheme.onSurfaceVariant,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      ..._placeResults.map((place) {
                        return ListTile(
                          dense: true,
                          leading: Icon(
                            Icons.place,
                            size: 20,
                            color: Theme.of(context).colorScheme.onSurfaceVariant,
                          ),
                          title: Text(place),
                          onTap: () => _handlePlaceSelected(place),
                        );
                      }),
                      if (_eventResults.isNotEmpty) const Divider(height: 1),
                    ],
                    // Resultados de eventos
                    if (_eventResults.isNotEmpty) ...[
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 8,
                        ),
                        child: Text(
                          'Eventos',
                          style: Theme.of(context).textTheme.labelSmall?.copyWith(
                            color: Theme.of(context).colorScheme.onSurfaceVariant,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      ..._eventResults.take(10).map((event) {
                        return ListTile(
                          dense: true,
                          leading: Icon(
                            Icons.event,
                            size: 20,
                            color: Theme.of(context).colorScheme.onSurfaceVariant,
                          ),
                          title: Text(
                            event.title,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          subtitle: event.cityName != null || event.place != null
                              ? Text(
                                  [
                                    if (event.cityName != null) event.cityName!,
                                    if (event.place != null) event.place!,
                                  ].join(' · '),
                                  style: Theme.of(context).textTheme.bodySmall,
                                )
                              : null,
                          onTap: () => _handleEventSelected(event),
                        );
                      }),
                    ],
                  ],
                ),
              ),
            ),
          const SizedBox(height: 8),
        ],
      ),
    );
  }
}
