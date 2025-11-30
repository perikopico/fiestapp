// scripts/populate_barbate_venues.dart
// Script para poblar la base de datos con lugares de interés de Barbate
// 
// Uso: dart scripts/populate_barbate_venues.dart

import 'dart:io';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

/// Lugares de interés en Barbate con coordenadas
/// Coordenadas aproximadas basadas en ubicación de Barbate, Cádiz
/// Centro de Barbate: 36.1927, -5.9219
const List<Map<String, dynamic>> barbateVenues = [
  // Restaurantes famosos
  {
    'name': 'El Campero',
    'address': 'Calle Trafalgar, 11160 Barbate, Cádiz',
    'lat': 36.1927,
    'lng': -5.9219,
  },
  {
    'name': 'Restaurante El Embarcadero',
    'address': 'Paseo Marítimo, 11160 Barbate, Cádiz',
    'lat': 36.1915,
    'lng': -5.9200,
  },
  {
    'name': 'Restaurante La Cofradía',
    'address': 'Calle Trafalgar, 11160 Barbate, Cádiz',
    'lat': 36.1935,
    'lng': -5.9225,
  },
  {
    'name': 'Restaurante El Faro',
    'address': 'Paseo Marítimo, 11160 Barbate, Cádiz',
    'lat': 36.1910,
    'lng': -5.9195,
  },
  {
    'name': 'Restaurante La Lonja',
    'address': 'Calle Puerto, 11160 Barbate, Cádiz',
    'lat': 36.1945,
    'lng': -5.9235,
  },
  {
    'name': 'Restaurante El Atún',
    'address': 'Calle Trafalgar, 11160 Barbate, Cádiz',
    'lat': 36.1936,
    'lng': -5.9226,
  },
  {
    'name': 'Restaurante La Bahía',
    'address': 'Paseo Marítimo, 11160 Barbate, Cádiz',
    'lat': 36.1913,
    'lng': -5.9199,
  },
  // Bares y pubs
  {
    'name': 'Pub Esencia Café y Copas',
    'address': 'Calle Trafalgar, 11160 Barbate, Cádiz',
    'lat': 36.1930,
    'lng': -5.9220,
  },
  {
    'name': 'Bar Habana',
    'address': 'Calle Trafalgar, 11160 Barbate, Cádiz',
    'lat': 36.1932,
    'lng': -5.9222,
  },
  {
    'name': 'Bar El Puerto',
    'address': 'Calle Puerto, 11160 Barbate, Cádiz',
    'lat': 36.1940,
    'lng': -5.9230,
  },
  {
    'name': 'Bar El Chiringuito',
    'address': 'Paseo Marítimo, 11160 Barbate, Cádiz',
    'lat': 36.1915,
    'lng': -5.9200,
  },
  {
    'name': 'Pub La Terraza',
    'address': 'Calle Trafalgar, 11160 Barbate, Cádiz',
    'lat': 36.1933,
    'lng': -5.9223,
  },
  {
    'name': 'Bar El Mirador',
    'address': 'Paseo Marítimo, 11160 Barbate, Cádiz',
    'lat': 36.1918,
    'lng': -5.9203,
  },
  // Lugares turísticos y culturales
  {
    'name': 'Plaza de la Constitución',
    'address': 'Plaza de la Constitución, 11160 Barbate, Cádiz',
    'lat': 36.1938,
    'lng': -5.9228,
  },
  {
    'name': 'Paseo Marítimo de Barbate',
    'address': 'Paseo Marítimo, 11160 Barbate, Cádiz',
    'lat': 36.1912,
    'lng': -5.9198,
  },
  {
    'name': 'Playa de la Hierbabuena',
    'address': 'Playa de la Hierbabuena, 11160 Barbate, Cádiz',
    'lat': 36.1880,
    'lng': -5.9150,
  },
  {
    'name': 'Playa del Carmen',
    'address': 'Playa del Carmen, 11160 Barbate, Cádiz',
    'lat': 36.1900,
    'lng': -5.9180,
  },
  {
    'name': 'Museo del Atún',
    'address': 'Calle Trafalgar, 11160 Barbate, Cádiz',
    'lat': 36.1930,
    'lng': -5.9220,
  },
  {
    'name': 'Iglesia de San Paulino',
    'address': 'Plaza de la Constitución, 11160 Barbate, Cádiz',
    'lat': 36.1938,
    'lng': -5.9228,
  },
  {
    'name': 'Puerto Pesquero de Barbate',
    'address': 'Puerto Pesquero, 11160 Barbate, Cádiz',
    'lat': 36.1942,
    'lng': -5.9232,
  },
  {
    'name': 'Playa de Caños de Meca',
    'address': 'Playa de Caños de Meca, 11160 Barbate, Cádiz',
    'lat': 36.1850,
    'lng': -5.9100,
  },
];

Future<void> main() async {
  print('🚀 Iniciando script de población de lugares de Barbate...\n');

  // Cargar variables de entorno
  try {
    await dotenv.load(fileName: '.env');
    print('✅ Archivo .env cargado');
  } catch (e) {
    print('❌ Error al cargar .env: $e');
    print('⚠️  Asegúrate de tener el archivo .env en la raíz del proyecto');
    exit(1);
  }

  final supabaseUrl = dotenv.env['SUPABASE_URL'];
  final supabaseKey = dotenv.env['SUPABASE_ANON_KEY'];

  if (supabaseUrl == null || supabaseKey == null) {
    print('❌ SUPABASE_URL o SUPABASE_ANON_KEY no encontrados en .env');
    exit(1);
  }

  // Inicializar Supabase
  try {
    await Supabase.initialize(url: supabaseUrl, anonKey: supabaseKey);
    print('✅ Supabase inicializado\n');
  } catch (e) {
    print('❌ Error al inicializar Supabase: $e');
    exit(1);
  }

  final client = Supabase.instance.client;

  // Paso 1: Obtener el ID de Barbate
  print('📍 Buscando ID de la ciudad de Barbate...');
  final cityResponse = await client
      .from('cities')
      .select('id, name')
      .ilike('name', '%Barbate%')
      .limit(1)
      .maybeSingle();

  if (cityResponse == null) {
    print('❌ No se encontró la ciudad de Barbate en la base de datos');
    print('   Por favor, crea la ciudad primero o verifica el nombre');
    exit(1);
  }

  final cityId = cityResponse['id'] as int;
  final cityName = cityResponse['name'] as String;
  print('✅ Ciudad encontrada: $cityName (ID: $cityId)\n');

  // Paso 2: Eliminar todos los lugares existentes
  print('🗑️  Eliminando todos los lugares existentes...');
  try {
    await client
        .from('venues')
        .delete()
        .eq('city_id', cityId);
    
    print('✅ Lugares eliminados correctamente\n');
  } catch (e) {
    print('⚠️  Error al eliminar lugares (puede que no haya lugares): $e');
    print('   Continuando con la inserción...\n');
  }

  // Paso 3: Insertar lugares de interés
  print('📝 Insertando ${barbateVenues.length} lugares de interés...\n');
  
  int successCount = 0;
  int errorCount = 0;

  for (var venue in barbateVenues) {
    try {
      await client.from('venues').insert({
        'name': venue['name'],
        'city_id': cityId,
        'address': venue['address'],
        'lat': venue['lat'],
        'lng': venue['lng'],
        'status': 'approved', // Aprobados directamente ya que son lugares conocidos
      });

      print('✅ ${venue['name']}');
      successCount++;
    } catch (e) {
      print('❌ ${venue['name']}: $e');
      errorCount++;
    }
  }

  print('\n📊 Resumen:');
  print('   ✅ Insertados: $successCount');
  print('   ❌ Errores: $errorCount');
  print('   📍 Total: ${barbateVenues.length}');

  if (successCount > 0) {
    print('\n✅ Script completado exitosamente!');
  } else {
    print('\n⚠️  No se insertó ningún lugar. Revisa los errores.');
  }
}

