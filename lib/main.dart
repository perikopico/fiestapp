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

Future<void> _testSupabaseConnection() async {
  try {
    final client = Supabase.instance.client;
    final data = await client.from('events').select().limit(3);
    debugPrint('🔌 Supabase conectado. Primeras 3 filas: ' + jsonEncode(data));
  } catch (e) {
    debugPrint('❌ Error probando Supabase: ' + e.toString());
  }
}

class Fiestapp extends StatelessWidget {
  const Fiestapp({super.key});

  @override
  Widget build(BuildContext context) {
    final themeData = ThemeData(
      useMaterial3: true,
      visualDensity: VisualDensity.adaptivePlatformDensity,
      fontFamily: 'Inter',
      colorScheme: ColorScheme.fromSeed(
        seedColor: const Color(0xFFF28C28), // naranja cálido
      ),
      scaffoldBackgroundColor: const Color(0xFFF9F4EF),
      textTheme: const TextTheme(
        headlineSmall: TextStyle(fontWeight: FontWeight.w700, fontSize: 20),
        titleMedium: TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
        bodyMedium: TextStyle(fontWeight: FontWeight.w500, fontSize: 14),
        bodySmall: TextStyle(fontWeight: FontWeight.w400, fontSize: 12),
      ),
      appBarTheme: AppBarTheme(
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.transparent,
        titleTextStyle: const TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: Colors.black87,
        ),
      ),
      chipTheme: const ChipThemeData(
        labelStyle: TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
        padding: EdgeInsets.symmetric(horizontal: 10, vertical: 8),
        side: BorderSide(width: .6, color: Color(0x22000000)),
        shape: StadiumBorder(),
        selectedColor: Color(0xFFFFE9DC),
        secondarySelectedColor: Color(0xFFFFE9DC),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          minimumSize: const Size(0, 40),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
          elevation: 2,
        ),
      ),
      cardTheme: const CardThemeData(
        margin: EdgeInsets.zero,
        elevation: 1.5,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(16)),
        ),
      ),
      inputDecorationTheme: const InputDecorationTheme(
        filled: true,
        fillColor: Color(0xFFFAF6F2),
        contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 12),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(14)),
          borderSide: BorderSide(color: Color(0x22000000), width: .7),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(14)),
          borderSide: BorderSide(color: Color(0x22000000), width: .7),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(14)),
          borderSide: BorderSide(color: Color(0xFFd9a17e), width: 1.2),
        ),
      ),
    );

    return MaterialApp(
      title: 'Fiestapp',
      navigatorKey: navigatorKey,
      theme: themeData,
      darkTheme: ThemeData.dark(useMaterial3: true),
      home: const DashboardScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}

