import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:convert';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'ui/dashboard/dashboard_screen.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeDateFormatting('es');

  // Cargar .env
  bool dotenvLoaded = false;
  try {
    await dotenv.load(fileName: ".env");
    dotenvLoaded = true;
    debugPrint("✅ Archivo .env cargado correctamente");
  } catch (e) {
    debugPrint("⚠️ Error al cargar .env: $e");
  }

  // Inicializar Supabase si hay credenciales
  if (dotenvLoaded) {
    final url = dotenv.env['SUPABASE_URL'];
    final key = dotenv.env['SUPABASE_ANON_KEY'];

    if (url == null || key == null || url.isEmpty || key.isEmpty) {
      debugPrint("❌ Variables de entorno no encontradas");
    } else {
      await Supabase.initialize(url: url, anonKey: key);
      debugPrint("✅ Supabase inicializado con éxito");
    }
  } else {
    debugPrint("⚠️ Supabase no inicializado (archivo .env no encontrado)");
  }

  runApp(const Fiestapp());

  // Prueba de conexión a Supabase después de montar la app
  WidgetsBinding.instance.addPostFrameCallback((_) {
    testSupabase();
  });
}

Future<void> testSupabase() async {
  try {
    final client = Supabase.instance.client;
    final data = await client.from('events').select().limit(3);
    debugPrint('SUPABASE TEST: ' + jsonEncode(data));

    final ctx = navigatorKey.currentContext;
    if (ctx != null) {
      final int count = (data is List) ? data.length : 0;
      ScaffoldMessenger.of(ctx).showSnackBar(
        SnackBar(content: Text('Eventos cargados: ' + count.toString())),
      );
    } else {
      debugPrint('SUPABASE TEST: Contexto no disponible para SnackBar');
    }
  } catch (e) {
    debugPrint('SUPABASE TEST ERROR: ' + e.toString());
  }
}

final ValueNotifier<ThemeMode> appThemeMode = ValueNotifier(ThemeMode.system);

class Fiestapp extends StatelessWidget {
  const Fiestapp({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<ThemeMode>(
      valueListenable: appThemeMode,
      builder: (context, mode, _) {
        return MaterialApp(
          title: 'Fiestapp',
          navigatorKey: navigatorKey,
          debugShowCheckedModeBanner: false,
          themeMode: mode, // 👈 aquí usamos el modo dinámico

      // 🌞 Tema claro
      theme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.light,
        colorScheme: const ColorScheme.light(
          primary: Color(0xFFB0907B),
          secondary: Color(0xFFDCC4B5),
          surface: Color(0xFFFFFFFF),
          surfaceVariant: Color(0xFFFCF8F5),
          background: Color(0xFFFCF8F5),
          onSurface: Color(0xFF3A2B22),
          onSurfaceVariant: Color(0xFF6B5A4F),
          outline: Color(0xFFD9C8BC),
          outlineVariant: Color(0xFFE6D6CC),
        ),
        scaffoldBackgroundColor: const Color(0xFFFCF8F5),
        textTheme: const TextTheme(
          titleLarge: TextStyle(fontSize: 22, fontWeight: FontWeight.w700),
          titleMedium: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
          bodyLarge: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
          bodyMedium: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
          labelLarge: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
          labelMedium: TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
        ).apply(
          bodyColor: Color(0xFF3A2B22),
          displayColor: Color(0xFF3A2B22),
        ),
        inputDecorationTheme: InputDecorationTheme(
          isDense: true,
          contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          filled: true,
          fillColor: const Color(0xFFFFFFFF),
          hintStyle: TextStyle(color: const Color(0xFF8A6D5A).withOpacity(0.7)),
          border: OutlineInputBorder(
            borderRadius: const BorderRadius.all(Radius.circular(14)),
            borderSide: BorderSide(color: const Color(0xFFD9C8BC)),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: const BorderRadius.all(Radius.circular(14)),
            borderSide: BorderSide(color: const Color(0xFFD9C8BC)),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: const BorderRadius.all(Radius.circular(14)),
            borderSide: const BorderSide(color: Color(0xFFB0907B), width: 1.6),
          ),
        ),
        chipTheme: ChipThemeData(
          labelStyle: const TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: Color(0xFF3A2B22),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(14)),
          ),
          backgroundColor: const Color(0xFFF3EAE4),
          selectedColor: const Color(0xFFEAD7CC),
          side: const BorderSide(color: Color(0xFFE6D6CC)),
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
        textTheme: const TextTheme(
          titleLarge: TextStyle(fontSize: 22, fontWeight: FontWeight.w700),
          titleMedium: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
          bodyLarge: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
          bodyMedium: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
          labelLarge: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
          labelMedium: TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
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
          contentPadding: EdgeInsets.symmetric(horizontal: 14, vertical: 12),
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

      home: const DashboardScreen(),
        );
      },
    );
  }
}
