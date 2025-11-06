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
      colorScheme: ColorScheme.fromSeed(
        seedColor: const Color(0xFFF28C28), // naranja cálido
      ),
      scaffoldBackgroundColor: const Color(0xFFF9F4EF),
      appBarTheme: AppBarTheme(
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.transparent,
        titleTextStyle: const TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 24,
        ),
      ),
      textTheme: TextTheme(
        titleLarge: const TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 20,
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

