import 'dart:ui' show PlatformDispatcher;
import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:firebase_core/firebase_core.dart';
import 'ui/dashboard/dashboard_screen.dart';
import 'ui/onboarding/permissions_onboarding_screen.dart';
import 'services/favorites_service.dart';
import 'services/onboarding_service.dart';
import 'services/fcm_token_service.dart';
import 'services/notification_handler.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Configurar manejo de errores no capturados
  FlutterError.onError = (FlutterErrorDetails details) {
    FlutterError.presentError(details);
    debugPrint("❌ ERROR NO CAPTURADO: ${details.exception}");
    debugPrint("Stack trace: ${details.stack}");
  };
  
  // Manejar errores de plataforma
  PlatformDispatcher.instance.onError = (error, stack) {
    debugPrint("❌ ERROR DE PLATAFORMA: $error");
    debugPrint("Stack trace: $stack");
    return true;
  };
  
  try {
    await initializeDateFormatting('es');
    debugPrint("✅ Formato de fecha inicializado");
  } catch (e) {
    debugPrint("⚠️ Error al inicializar formato de fecha: $e");
  }
  
  // Inicializar Firebase
  try {
    await Firebase.initializeApp();
    debugPrint("✅ Firebase inicializado con éxito");
    
    // Inicializar servicio de tokens FCM y handlers de notificaciones
    await FCMTokenService.instance.initialize();
    await NotificationHandler.instance.initialize();
  } catch (e) {
    debugPrint("⚠️ Error al inicializar Firebase: $e");
  }
  
  // Inicializar servicio de favoritos
  try {
    await FavoritesService.instance.init();
    debugPrint("✅ FavoritesService inicializado");
  } catch (e) {
    debugPrint("⚠️ Error al inicializar FavoritesService: $e");
  }

  // Cargar .env
  bool dotenvLoaded = false;
  try {
    await dotenv.load(fileName: ".env");
    dotenvLoaded = true;
    debugPrint("✅ Archivo .env cargado correctamente");
  } catch (e) {
    debugPrint("⚠️ Error al cargar .env: $e");
    debugPrint("⚠️ La app funcionará sin Supabase (solo modo local)");
  }

  // Inicializar Supabase si hay credenciales
  if (dotenvLoaded) {
    try {
      final url = dotenv.env['SUPABASE_URL'];
      final key = dotenv.env['SUPABASE_ANON_KEY'];

      if (url == null || key == null || url.isEmpty || key.isEmpty) {
        debugPrint("❌ Variables de entorno no encontradas o vacías");
        debugPrint("⚠️ La app funcionará sin Supabase (solo modo local)");
      } else {
        await Supabase.initialize(url: url, anonKey: key);
        debugPrint("✅ Supabase inicializado con éxito");
        
        // Configurar listener para cambios de autenticación
        Supabase.instance.client.auth.onAuthStateChange.listen((data) async {
          final event = data.event;
          final session = data.session;
          
          if (event == AuthChangeEvent.signedIn && session != null) {
            debugPrint("✅ Usuario autenticado: ${session.user.email}");
            
            // Sincronizar favoritos locales con Supabase cuando el usuario inicia sesión
            FavoritesService.instance.syncLocalToSupabase().then((_) {
              debugPrint("✅ Favoritos sincronizados");
            }).catchError((e) {
              debugPrint("⚠️ Error al sincronizar favoritos: $e");
            });
            
            // Guardar token FCM cuando el usuario inicia sesión
            final token = await FCMTokenService.instance.getCurrentToken();
            if (token != null) {
              FCMTokenService.instance.saveTokenToSupabase(token).then((_) {
                debugPrint("✅ Token FCM guardado después de login");
              }).catchError((e) {
                debugPrint("⚠️ Error al guardar token FCM: $e");
              });
            }
          } else if (event == AuthChangeEvent.signedOut) {
            debugPrint("👋 Usuario cerró sesión");
            
            // Eliminar token FCM cuando el usuario cierra sesión
            final token = await FCMTokenService.instance.getCurrentToken();
            if (token != null) {
              FCMTokenService.instance.deleteTokenFromSupabase(token).catchError((e) {
                debugPrint("⚠️ Error al eliminar token FCM: $e");
              });
            }
            
            // Recargar favoritos desde local
            FavoritesService.instance.init();
          }
        });
      }
    } catch (e, stackTrace) {
      debugPrint("❌ Error al inicializar Supabase: $e");
      debugPrint("Stack trace: $stackTrace");
      debugPrint("⚠️ La app funcionará sin Supabase (solo modo local)");
    }
  } else {
    debugPrint("⚠️ Supabase no inicializado (archivo .env no encontrado)");
    debugPrint("⚠️ La app funcionará sin Supabase (solo modo local)");
  }

  runApp(const QuePlan());
}

// La función _initializeFCMToken() ha sido reemplazada por FCMTokenService
// que gestiona todo el ciclo de vida de los tokens FCM de forma más completa

final ValueNotifier<ThemeMode> appThemeMode = ValueNotifier(ThemeMode.system);

class QuePlan extends StatefulWidget {
  const QuePlan({super.key});

  @override
  State<QuePlan> createState() => _QuePlanState();
}

class _QuePlanState extends State<QuePlan> {
  bool _isCheckingOnboarding = true;
  bool _showOnboarding = false;

  @override
  void initState() {
    super.initState();
    _checkOnboardingStatus();
  }

  Future<void> _checkOnboardingStatus() async {
    final hasSeen = await OnboardingService.instance.hasSeenPermissionOnboarding();
    if (mounted) {
      setState(() {
        _showOnboarding = !hasSeen;
        _isCheckingOnboarding = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isCheckingOnboarding) {
      // Mostrar splash mientras se verifica
      return MaterialApp(
        home: Scaffold(
          backgroundColor: const Color(0xFFF8FBFF),
          body: const Center(
            child: CircularProgressIndicator(),
          ),
        ),
      );
    }

    return ValueListenableBuilder<ThemeMode>(
      valueListenable: appThemeMode,
      builder: (context, mode, _) {
        return MaterialApp(
          title: 'QuePlan',
          navigatorKey: navigatorKey,
          debugShowCheckedModeBanner: false,
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

          home: _showOnboarding
              ? const PermissionsOnboardingScreen()
              : const DashboardScreen(),
        );
      },
    );
  }
}
