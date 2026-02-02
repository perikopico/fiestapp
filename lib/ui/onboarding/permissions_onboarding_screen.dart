// lib/ui/onboarding/permissions_onboarding_screen.dart
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter/services.dart';
import '../../services/onboarding_service.dart';
import '../dashboard/dashboard_screen.dart';
import '../common/app_bar_logo.dart';
import 'notification_preferences_screen.dart';

class PermissionsOnboardingScreen extends StatefulWidget {
  const PermissionsOnboardingScreen({super.key});

  @override
  State<PermissionsOnboardingScreen> createState() =>
      _PermissionsOnboardingScreenState();
}

class _PermissionsOnboardingScreenState
    extends State<PermissionsOnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  // Datos de los slides
  final List<_OnboardingSlide> _slides = [
    _OnboardingSlide(
      title: 'Tu ubicación',
      text:
          'Usamos tu ubicación para mostrarte los eventos que tienes cerca y ordenar los resultados por distancia.',
      icon: Icons.location_on,
    ),
    _OnboardingSlide(
      title: 'Tus fotos',
      text:
          'Necesitamos acceso a tus imágenes para que puedas subir una portada a tus eventos.',
      icon: Icons.photo_library,
    ),
  ];

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  Future<void> _requestPermissions() async {
    bool locationGranted = false;
    bool photosGranted = false;

    // Solicitar permiso de ubicación
    try {
      final locationStatus = await Permission.location.request();
      locationGranted = locationStatus.isGranted;
    } catch (e) {
      debugPrint('Error al solicitar permiso de ubicación: $e');
    }

    // Solicitar permiso de fotos
    try {
      // Intentar primero con Permission.photos (Android 13+)
      // Si falla, intentar con Permission.storage (versiones anteriores)
      PermissionStatus photosStatus;
      try {
        photosStatus = await Permission.photos.request();
      } catch (e) {
        // Si Permission.photos no está disponible, usar Permission.storage
        debugPrint('Permission.photos no disponible, usando Permission.storage: $e');
        photosStatus = await Permission.storage.request();
      }
      photosGranted = photosStatus.isGranted;
    } catch (e) {
      debugPrint('Error al solicitar permiso de fotos: $e');
    }

    // Marcar onboarding como visto
    await OnboardingService.instance.markPermissionOnboardingSeen();

    if (!mounted) return;

    // Mostrar mensaje si algún permiso fue denegado
    if (!locationGranted || !photosGranted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Algunos permisos no fueron concedidos. Puedes activarlos más tarde en la configuración.',
          ),
          duration: Duration(seconds: 4),
        ),
      );
    }

    // Verificar si necesita configurar notificaciones
    final hasSeenNotifications = await OnboardingService.instance.hasSeenNotificationPreferences();
    
    if (!hasSeenNotifications) {
      // Navegar a la pantalla de configuración de notificaciones
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => const NotificationPreferencesScreen()),
      );
    } else {
      // Navegar directamente al dashboard
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => const DashboardScreen()),
      );
    }
  }

  void _onPageChanged(int index) {
    setState(() {
      _currentPage = index;
    });
  }

  void _nextPage() {
    if (_currentPage < _slides.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      _requestPermissions();
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isLastPage = _currentPage == _slides.length - 1;

    return PopScope(
      canPop: false, // Prevenir que se cierre con el botón atrás
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) {
          // Si se intenta cerrar, salir de la app
          SystemNavigator.pop();
        }
      },
      child: Scaffold(
        backgroundColor: theme.scaffoldBackgroundColor,
        body: SafeArea(
          child: Column(
            children: [
              // Logo (misma identidad que el resto de la app)
              Padding(
                padding: const EdgeInsets.only(top: 8, bottom: 8),
                child: const AppBarLogo(),
              ),
              // Indicadores de página
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(
                    _slides.length,
                    (index) => Container(
                      width: 8,
                      height: 8,
                      margin: const EdgeInsets.symmetric(horizontal: 4),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: _currentPage == index
                            ? theme.colorScheme.primary
                            : theme.colorScheme.outline.withOpacity(0.3),
                      ),
                    ),
                  ),
                ),
              ),

              // Carousel de páginas
              Expanded(
                child: PageView.builder(
                  controller: _pageController,
                  onPageChanged: _onPageChanged,
                  itemCount: _slides.length,
                  itemBuilder: (context, index) {
                    final slide = _slides[index];
                    return _OnboardingPage(slide: slide);
                  },
                ),
              ),

              // Botón de acción (FilledButton y radio 14 como en la app)
              Padding(
                padding: const EdgeInsets.fromLTRB(24, 16, 24, 24),
                child: SizedBox(
                  width: double.infinity,
                  child: FilledButton(
                    onPressed: _nextPage,
                    style: FilledButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                    child: Text(
                      isLastPage ? 'Activar permisos' : 'Continuar',
                      style: theme.textTheme.labelLarge,
                    ),
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

class _OnboardingSlide {
  final String title;
  final String text;
  final IconData icon;

  const _OnboardingSlide({
    required this.title,
    required this.text,
    required this.icon,
  });
}

class _OnboardingPage extends StatelessWidget {
  final _OnboardingSlide slide;

  const _OnboardingPage({required this.slide});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Icono en contenedor redondeado (estilo Profile/Dashboard)
          Container(
            width: 120,
            height: 120,
            decoration: BoxDecoration(
              color: theme.colorScheme.primaryContainer.withOpacity(0.4),
              borderRadius: BorderRadius.circular(24),
              boxShadow: [
                BoxShadow(
                  color: theme.colorScheme.primary.withOpacity(0.08),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Icon(
              slide.icon,
              size: 64,
              color: theme.colorScheme.primary,
            ),
          ),
          const SizedBox(height: 40),

          // Título
          Text(
            slide.title,
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.w700,
              fontSize: 26,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),

          // Texto descriptivo
          Text(
            slide.text,
            style: theme.textTheme.bodyLarge?.copyWith(
              height: 1.5,
              color: theme.colorScheme.onSurfaceVariant,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

