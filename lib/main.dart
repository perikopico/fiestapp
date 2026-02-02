import 'dart:ui' show PlatformDispatcher, Locale;
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:fiestapp/l10n/app_localizations.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:firebase_core/firebase_core.dart';
import 'ui/dashboard/dashboard_screen.dart';
import 'ui/onboarding/permissions_onboarding_screen.dart';
import 'ui/onboarding/splash_video_screen.dart';
import 'services/favorites_service.dart';
import 'services/onboarding_service.dart';
import 'services/fcm_token_service.dart';
import 'services/notification_handler.dart';
import 'services/notifications_count_service.dart';
import 'services/logger_service.dart';
import 'package:provider/provider.dart';
import 'providers/dashboard_provider.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Configurar manejo de errores no capturados
  FlutterError.onError = (FlutterErrorDetails details) {
    FlutterError.presentError(details);
    LoggerService.instance.fatal(
      'Error no capturado',
      error: details.exception,
      stackTrace: details.stack,
    );
  };
  
  // Manejar errores de plataforma
  PlatformDispatcher.instance.onError = (error, stack) {
    LoggerService.instance.fatal(
      'Error de plataforma',
      error: error,
      stackTrace: stack,
    );
    return true;
  };
  
  // Inicializar lo mínimo necesario antes de mostrar la UI
  // El resto se inicializa en background después de que la app arranque
  
  // 1. Formato de fecha (rápido, necesario para la UI)
  // Detectar idioma del sistema para inicializar formato de fecha
  try {
    final systemLocale = PlatformDispatcher.instance.locale;
    final languageCode = systemLocale.languageCode;
    // Soporte español, inglés, alemán y chino, por defecto español
    String dateLocale;
    if (languageCode == 'en') {
      dateLocale = 'en';
    } else if (languageCode == 'de') {
      dateLocale = 'de';
    } else if (languageCode == 'zh') {
      dateLocale = 'zh';
    } else {
      dateLocale = 'es'; // Por defecto español
    }
    await initializeDateFormatting(dateLocale, null);
    LoggerService.instance.info('Formato de fecha inicializado', data: {'locale': dateLocale});
  } catch (e) {
    // Si falla, intentar con español
    try {
      await initializeDateFormatting('es', null);
      LoggerService.instance.info('Formato de fecha inicializado (fallback a español)');
    } catch (e2) {
      LoggerService.instance.error('Error al inicializar formato de fecha', error: e2);
    }
  }
  
  // 2. Cargar .env (necesario para Supabase, pero rápido)
  bool dotenvLoaded = false;
  try {
    await dotenv.load(fileName: ".env");
    dotenvLoaded = true;
    LoggerService.instance.info('Archivo .env cargado correctamente');
  } catch (e) {
    LoggerService.instance.warning('Error al cargar .env', data: {'error': e.toString()});
    LoggerService.instance.info('La app funcionará sin Supabase (solo modo local)');
  }

  // 3. Inicializar Supabase (necesario para la UI, pero puede ser rápido)
  if (dotenvLoaded) {
    try {
      final url = dotenv.env['SUPABASE_URL'];
      final key = dotenv.env['SUPABASE_ANON_KEY'];

      if (url != null && key != null && url.isNotEmpty && key.isNotEmpty) {
        await Supabase.initialize(url: url, anonKey: key);
        LoggerService.instance.info('Supabase inicializado con éxito');
      }
    } catch (e) {
      LoggerService.instance.warning('Error al inicializar Supabase', data: {'error': e.toString()});
      LoggerService.instance.info('La app funcionará sin Supabase (solo modo local)');
    }
  }

  // 4. Inicializar servicio de favoritos (rápido, necesario para la UI)
  try {
    await FavoritesService.instance.init();
    LoggerService.instance.info('FavoritesService inicializado');
  } catch (e) {
    LoggerService.instance.error('Error al inicializar FavoritesService', error: e);
  }

  // Ejecutar la app inmediatamente - el resto se inicializa en background
  runApp(const QuePlan());
  
  // Inicializar servicios pesados en background después de que la app arranque
  _initializeBackgroundServices();
}

/// Inicializa servicios pesados en background para no bloquear el arranque
Future<void> _initializeBackgroundServices() async {
  // Firebase y FCM (pueden tardar, no son críticos para mostrar la UI)
  try {
    await Firebase.initializeApp();
    LoggerService.instance.info('Firebase inicializado con éxito');
    
    // Inicializar FCM de forma asíncrona (puede tardar en iOS)
    FCMTokenService.instance.initialize().then((_) {
      LoggerService.instance.info('FCMTokenService inicializado');
    }).catchError((e) {
      LoggerService.instance.error('Error al inicializar FCMTokenService', error: e);
    });
    
    NotificationHandler.instance.initialize().then((_) {
      LoggerService.instance.info('NotificationHandler inicializado');
    }).catchError((e) {
      LoggerService.instance.error('Error al inicializar NotificationHandler', error: e);
    });
  } catch (e) {
    LoggerService.instance.error('Error al inicializar Firebase', error: e);
    LoggerService.instance.warning('La app funcionará sin notificaciones push');
  }
  
  // Configurar listener de autenticación de Supabase (si está inicializado)
  try {
    if (Supabase.instance.client != null) {
      Supabase.instance.client.auth.onAuthStateChange.listen((data) async {
        final event = data.event;
        final session = data.session;
        
        if (event == AuthChangeEvent.signedIn && session != null) {
          LoggerService.instance.info('Usuario autenticado', data: {'email': session.user.email});
          
          // Sincronizar favoritos locales con Supabase cuando el usuario inicia sesión
          FavoritesService.instance.syncLocalToSupabase().then((_) {
            LoggerService.instance.info('Favoritos sincronizados');
          }).catchError((e) {
            LoggerService.instance.error('Error al sincronizar favoritos', error: e);
          });
          
          // Guardar token FCM cuando el usuario inicia sesión
          try {
            final token = await FCMTokenService.instance.getCurrentToken();
            if (token != null) {
              FCMTokenService.instance.saveTokenToSupabase(token).then((_) {
                LoggerService.instance.info('Token FCM guardado después de login');
              }).catchError((e) {
                LoggerService.instance.error('Error al guardar token FCM', error: e);
              });
            }
          } catch (e) {
            LoggerService.instance.error('Error al obtener token FCM', error: e);
          }
          
          // Inicializar conteo de notificaciones y empezar polling
          NotificationsCountService.instance.getUnreadCount().then((_) {
            NotificationsCountService.instance.startPolling();
            LoggerService.instance.info('Servicio de conteo de notificaciones iniciado');
          }).catchError((e) {
            LoggerService.instance.error('Error al inicializar conteo de notificaciones', error: e);
          });
        } else if (event == AuthChangeEvent.signedOut) {
          LoggerService.instance.info('Usuario cerró sesión');
          
          // Eliminar token FCM cuando el usuario cierra sesión
          try {
            final token = await FCMTokenService.instance.getCurrentToken();
            if (token != null) {
              FCMTokenService.instance.deleteTokenFromSupabase(token).catchError((e) {
                LoggerService.instance.error('Error al eliminar token FCM', error: e);
              });
            }
          } catch (e) {
            LoggerService.instance.error('Error al obtener token FCM para eliminar', error: e);
          }
          
          // Detener polling de notificaciones y resetear conteo
          NotificationsCountService.instance.stopPolling();
          NotificationsCountService.instance.unreadCount.value = 0;
          
          // Recargar favoritos desde local
          FavoritesService.instance.init();
        }
      });
    }
  } catch (e) {
    LoggerService.instance.error('Error al configurar listener de autenticación', error: e);
  }
}

// La función _initializeFCMToken() ha sido reemplazada por FCMTokenService
// que gestiona todo el ciclo de vida de los tokens FCM de forma más completa

// Inicializar el tema en modo system para que siga el brightness del sistema
// ThemeMode.system detecta automáticamente si el sistema está en modo claro u oscuro
// y cambia según la hora del día si el sistema tiene esa configuración
final ValueNotifier<ThemeMode> appThemeMode = ValueNotifier(ThemeMode.system);

class QuePlan extends StatefulWidget {
  const QuePlan({super.key});

  @override
  State<QuePlan> createState() => _QuePlanState();
}

class _QuePlanState extends State<QuePlan> {
  bool _isCheckingOnboarding = true;
  bool _showOnboarding = false;
  // Usar una key única para el splash para evitar que se recree múltiples veces
  final GlobalKey _splashKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    _checkOnboardingStatus();
  }

  Future<void> _checkOnboardingStatus() async {
    final hasSeen = await OnboardingService.instance.hasSeenPermissionOnboarding();
    // No comprobar permisos aquí: evitar cualquier diálogo de permisos antes del video.
    // El video SIEMPRE es lo primero. Tras el video, se muestra onboarding de permisos
    // (si !hasSeen) o el Dashboard. Los permisos se piden solo en PermissionsOnboardingScreen.
    final shouldShowOnboarding = !hasSeen;

    if (mounted) {
      setState(() {
        _showOnboarding = shouldShowOnboarding;
        _isCheckingOnboarding = false;
      });
    }
  }

  Widget _buildHomeScreen() {
    // Primero el video; después del video ir a permisos (si no los ha visto) o al Dashboard.
    final nextAfterVideo = _showOnboarding
        ? const PermissionsOnboardingScreen()
        : const DashboardScreen();
    return ChangeNotifierProvider(
      create: (_) => DashboardProvider(),
      child: SplashVideoScreen(
        key: _splashKey,
        nextScreen: nextAfterVideo,
        isDashboard: !_showOnboarding,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_isCheckingOnboarding) {
      // Mostrar fondo negro mientras se verifica (sin ruleta de carga)
      return MaterialApp(
        home: Scaffold(
          backgroundColor: Colors.black,
          body: Container(),
        ),
      );
    }

    return ValueListenableBuilder<ThemeMode>(
      valueListenable: appThemeMode,
      builder: (context, mode, _) {
        // Detectar idioma del sistema
        final systemLocale = PlatformDispatcher.instance.locale;
        
        return MaterialApp(
          title: 'QuePlan',
          navigatorKey: navigatorKey,
          debugShowCheckedModeBanner: false,
          // Configuración de localización
          locale: systemLocale, // Usa el idioma del sistema
          supportedLocales: const [
            Locale('es', ''), // Español
            Locale('en', ''), // Inglés
            Locale('de', ''), // Alemán
            Locale('zh', ''), // Chino
          ],
          localizationsDelegates: const [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          // Fallback a español si el idioma del sistema no está soportado
          localeResolutionCallback: (locale, supportedLocales) {
            // Si el idioma del sistema está soportado, usarlo
            for (var supportedLocale in supportedLocales) {
              if (supportedLocale.languageCode == locale?.languageCode) {
                return supportedLocale;
              }
            }
            // Si no, usar español por defecto
            return const Locale('es', '');
          },
          themeMode: mode, // 👈 aquí usamos el modo dinámico
          // 🌞 Tema claro
          theme: ThemeData(
            useMaterial3: true,
            brightness: Brightness.light,
            colorScheme: const ColorScheme.light(
              primary: Color(0xFF2196F3), // Azul vibrante y moderno
              secondary: Color(0xFF03A9F4), // Cyan complementario
              surface: Color(0xFFFFFFFF),
              surfaceVariant: Color(0xFFF5F9FF), // Azul muy claro
              background: Color(0xFFF8FBFF), // Fondo azul muy suave
              onSurface: Color(0xFF1A1A1A), // Casi negro para mejor contraste
              onSurfaceVariant: Color(0xFF5A6C7D), // Gris azulado
              outline: Color(0xFFB0C4DE), // Azul claro para bordes
              outlineVariant: Color(0xFFD6E4F0), // Azul muy claro
            ),
            scaffoldBackgroundColor: const Color(0xFFF8FBFF),
            textTheme:
                const TextTheme(
                  titleLarge: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w700,
                  ),
                  titleMedium: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                  bodyLarge: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                  bodyMedium: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                  labelLarge: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                  labelMedium: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                  ),
                ).apply(
                  bodyColor: Color(0xFF1A1A1A),
                  displayColor: Color(0xFF1A1A1A),
                ),
            inputDecorationTheme: InputDecorationTheme(
              isDense: true,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 14,
                vertical: 12,
              ),
              filled: true,
              fillColor: const Color(0xFFFFFFFF),
              hintStyle: TextStyle(
                color: const Color(0xFF7A8A9A).withOpacity(0.7),
              ),
              border: OutlineInputBorder(
                borderRadius: const BorderRadius.all(Radius.circular(14)),
                borderSide: BorderSide(color: const Color(0xFFB0C4DE)),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: const BorderRadius.all(Radius.circular(14)),
                borderSide: BorderSide(color: const Color(0xFFB0C4DE)),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: const BorderRadius.all(Radius.circular(14)),
                borderSide: const BorderSide(
                  color: Color(0xFF2196F3),
                  width: 1.6,
                ),
              ),
            ),
            chipTheme: ChipThemeData(
              labelStyle: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: Color(0xFF1A1A1A),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(14)),
              ),
              backgroundColor: const Color(0xFFE3F2FD), // Azul muy claro
              selectedColor: const Color(0xFFBBDEFB), // Azul claro
              side: const BorderSide(color: Color(0xFFD6E4F0)),
            ),
            cardTheme: CardThemeData(
              clipBehavior: Clip.antiAlias,
              elevation: 0,
              margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 12),
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(16)),
              ),
              color: const Color(0xFFFFFFFF),
            ),
          ),

          // 🌙 Tema oscuro (paleta fría / neutral)
          darkTheme: ThemeData(
            useMaterial3: true,
            brightness: Brightness.dark,
            colorScheme: const ColorScheme.dark(
              primary: Color(0xFF5ED1B7), // acento verdoso/azulado
              secondary: Color(0xFF3FA38A),
              surface: Color(0xFF191C20), // tarjetas / bloques
              background: Color(0xFF101215), // fondo general
              onSurface: Color(0xFFECEFF4), // texto principal
            ),
            scaffoldBackgroundColor: const Color(0xFF101215),
            appBarTheme: const AppBarTheme(
              backgroundColor: Color(0xFF101215),
              foregroundColor: Color(0xFFECEFF4),
              elevation: 0,
            ),
            textTheme:
                const TextTheme(
                  titleLarge: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w700,
                  ),
                  titleMedium: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                  bodyLarge: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                  bodyMedium: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                  labelLarge: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                  labelMedium: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                  ),
                ).apply(
                  bodyColor: const Color(0xFFECEFF4),
                  displayColor: const Color(0xFFECEFF4),
                ),
            cardTheme: const CardThemeData(
              color: Color(0xFF191C20),
              clipBehavior: Clip.antiAlias,
              elevation: 0,
              margin: EdgeInsets.symmetric(vertical: 6, horizontal: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(16)),
              ),
            ),
            chipTheme: const ChipThemeData(
              labelStyle: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: Color(0xFFECEFF4),
              ),
              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 8),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(14)),
              ),
              backgroundColor: Color(0xFF23272F),
              selectedColor: Color(0xFF2C323B),
              side: BorderSide(color: Color(0xFF39414D)),
            ),
            inputDecorationTheme: const InputDecorationTheme(
              isDense: true,
              filled: true,
              fillColor: Color(0xFF191C20),
              contentPadding: EdgeInsets.symmetric(
                horizontal: 14,
                vertical: 12,
              ),
              hintStyle: TextStyle(color: Color(0xFF9CA3AF)),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(14)),
                borderSide: BorderSide(color: Color(0xFF39414D)),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(14)),
                borderSide: BorderSide(color: Color(0xFF39414D)),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(14)),
                borderSide: BorderSide(color: Color(0xFF5ED1B7), width: 1.6),
              ),
            ),
          ),

          home: _buildHomeScreen(),
        );
      },
    );
  }
}
