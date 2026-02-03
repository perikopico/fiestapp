#!/usr/bin/env python3
"""
Script para geocodificar eventos sin coordenadas usando Google Maps Geocoding API.

Este script:
1. Obtiene eventos sin coordenadas (lat/lng NULL)
2. Usa Google Maps Geocoding API para obtener coordenadas basándose en place + ciudad
3. Actualiza los eventos en Supabase con las coordenadas obtenidas

Requisitos:
- pip install supabase python-dotenv requests
- Archivo .env con SUPABASE_URL, SUPABASE_SERVICE_ROLE_KEY y GOOGLE_MAPS_API_KEY
"""

import os
import sys
import time
from typing import Optional, Tuple
from dotenv import load_dotenv
import requests
from supabase import create_client, Client

# Cargar variables de entorno desde la raíz del proyecto
# Buscar .env en el directorio padre (raíz del proyecto)
script_dir = os.path.dirname(os.path.abspath(__file__))
project_root = os.path.dirname(script_dir)
env_path = os.path.join(project_root, '.env')
load_dotenv(env_path)

# Configuración
SUPABASE_URL = os.getenv('SUPABASE_URL')
SUPABASE_KEY = os.getenv('SUPABASE_SERVICE_ROLE_KEY')  # Necesita service_role para actualizar
# Intentar usar GOOGLE_MAPS_API_KEY_SERVER primero (para Supabase/servidor), 
# si no existe, usar GOOGLE_MAPS_API_KEY (para Android/Apple)
GOOGLE_MAPS_API_KEY = os.getenv('GOOGLE_MAPS_API_KEY_SERVER') or os.getenv('GOOGLE_MAPS_API_KEY')
DELAY_BETWEEN_REQUESTS = 0.1  # Segundos entre requests (para no exceder límites de API)

# Validar y limpiar variables
if not SUPABASE_URL:
    print("❌ Error: SUPABASE_URL no está definida en .env")
    sys.exit(1)

if not SUPABASE_KEY:
    print("❌ Error: SUPABASE_SERVICE_ROLE_KEY no está definida en .env")
    sys.exit(1)

if not GOOGLE_MAPS_API_KEY:
    print("❌ Error: GOOGLE_MAPS_API_KEY o GOOGLE_MAPS_API_KEY_SERVER no está definida en .env")
    print("   Agrega GOOGLE_MAPS_API_KEY_SERVER=tu_key_de_supabase en .env")
    sys.exit(1)

# Limpiar espacios en blanco y comillas
SUPABASE_URL = SUPABASE_URL.strip().strip('"').strip("'")
SUPABASE_KEY = SUPABASE_KEY.strip().strip('"').strip("'")
GOOGLE_MAPS_API_KEY = GOOGLE_MAPS_API_KEY.strip().strip('"').strip("'")

# Validar formato de URL
if not SUPABASE_URL.startswith('http'):
    print(f"❌ Error: SUPABASE_URL tiene formato inválido")
    print(f"   Valor actual: {SUPABASE_URL[:50]}...")
    print("   Debe ser una URL válida (ej: https://xxxxx.supabase.co)")
    sys.exit(1)

# Inicializar cliente de Supabase
try:
    supabase: Client = create_client(SUPABASE_URL, SUPABASE_KEY)
except Exception as e:
    print(f"❌ Error al crear cliente de Supabase: {e}")
    print(f"   URL: {SUPABASE_URL[:50]}...")
    print(f"   Key (primeros 10 chars): {SUPABASE_KEY[:10]}...")
    sys.exit(1)


def extract_place_from_maps_url(maps_url: str) -> Optional[str]:
    """
    Intenta extraer el nombre del lugar desde una URL de Google Maps.
    
    Soporta formatos:
    - https://www.google.com/maps/place/NOMBRE+DEL+LUGAR
    - https://www.google.com/maps/search/?api=1&query=NOMBRE+DEL+LUGAR
    
    Args:
        maps_url: URL de Google Maps
        
    Returns:
        Nombre del lugar si se puede extraer, None si no
    """
    if not maps_url:
        return None
    
    import urllib.parse
    
    # Formato 1: /place/NOMBRE
    if '/place/' in maps_url:
        try:
            # Extraer la parte después de /place/
            place_part = maps_url.split('/place/')[1].split('/')[0].split('?')[0]
            # Decodificar URL encoding
            place_name = urllib.parse.unquote(place_part).replace('+', ' ')
            return place_name if place_name else None
        except:
            pass
    
    # Formato 2: query=NOMBRE (pero no coordenadas)
    if 'query=' in maps_url and not maps_url.replace('query=', '').replace(',', '').replace('.', '').replace('-', '').strip().isdigit():
        try:
            query_part = maps_url.split('query=')[1].split('&')[0]
            # Si no son números, es un nombre de lugar
            if not query_part.replace(',', '').replace('.', '').replace('-', '').strip().replace(' ', '').isdigit():
                place_name = urllib.parse.unquote(query_part).replace('+', ' ')
                return place_name if place_name else None
        except:
            pass
    
    return None


def geocode_address(address: str, city_name: str) -> Optional[Tuple[float, float]]:
    """
    Geocodifica una dirección usando Google Maps Geocoding API.
    
    Args:
        address: Dirección o nombre del lugar
        city_name: Nombre de la ciudad
        
    Returns:
        Tupla (lat, lng) si se encuentra, None si no
    """
    # Construir query de búsqueda: "lugar, ciudad"
    query = f"{address}, {city_name}" if address else city_name
    encoded_query = requests.utils.quote(query)
    
    url = f"https://maps.googleapis.com/maps/api/geocode/json?address={encoded_query}&key={GOOGLE_MAPS_API_KEY}"
    
    try:
        response = requests.get(url, timeout=10)
        response.raise_for_status()
        data = response.json()
        
        # Debug: mostrar el estado completo si hay error
        if data.get('status') != 'OK':
            error_message = data.get('error_message', 'Sin mensaje de error')
            print(f"  ⚠️  Estado de API: {data['status']}")
            if error_message:
                print(f"  📝 Mensaje: {error_message}")
            # Si es REQUEST_DENIED, mostrar más información de debug
            if data['status'] == 'REQUEST_DENIED':
                print(f"  🔍 URL usada: {url[:100]}...")
                print(f"  💡 Verifica:")
                print(f"     - Que la API key tenga Geocoding API habilitada")
                print(f"     - Que no haya restricciones de IP/dominio en la key")
                print(f"     - Que la key no esté bloqueada")
            return None
        
        if data['status'] == 'OK' and data['results']:
            location = data['results'][0]['geometry']['location']
            lat = location['lat']
            lng = location['lng']
            print(f"  ✅ Encontrado: {lat}, {lng}")
            return (lat, lng)
        elif data['status'] == 'ZERO_RESULTS':
            print(f"  ⚠️  No se encontraron resultados")
            return None
        elif data['status'] == 'OVER_QUERY_LIMIT':
            print(f"  ❌ Límite de queries excedido. Espera antes de continuar.")
            return None
        else:
            print(f"  ⚠️  Estado de API: {data['status']}")
            return None
            
    except requests.exceptions.RequestException as e:
        print(f"  ❌ Error en request: {e}")
        return None
    except Exception as e:
        print(f"  ❌ Error inesperado: {e}")
        return None


def update_event_coordinates(event_id: str, lat: float, lng: float) -> bool:
    """
    Actualiza las coordenadas de un evento en Supabase.
    
    Args:
        event_id: ID del evento
        lat: Latitud
        lng: Longitud
        
    Returns:
        True si se actualizó correctamente, False si no
    """
    try:
        result = supabase.table('events').update({
            'lat': lat,
            'lng': lng
        }).eq('id', event_id).execute()
        
        if result.data:
            return True
        else:
            print(f"  ⚠️  No se pudo actualizar el evento")
            return False
    except Exception as e:
        print(f"  ❌ Error al actualizar: {e}")
        return False


def test_geocoding_api():
    """Prueba la API de geocoding con una dirección simple."""
    print("🧪 Probando API de Geocoding...")
    test_address = "Cádiz, España"
    encoded = requests.utils.quote(test_address)
    url = f"https://maps.googleapis.com/maps/api/geocode/json?address={encoded}&key={GOOGLE_MAPS_API_KEY}"
    
    try:
        response = requests.get(url, timeout=10)
        data = response.json()
        
        print(f"   Estado: {data.get('status')}")
        if data.get('error_message'):
            print(f"   Error: {data.get('error_message')}")
        if data.get('status') == 'OK':
            location = data['results'][0]['geometry']['location']
            print(f"   ✅ API funcionando: {location['lat']}, {location['lng']}")
            return True
        else:
            print(f"   ❌ API no funciona. Revisa la configuración.")
            return False
    except Exception as e:
        print(f"   ❌ Error en prueba: {e}")
        return False


def main():
    """Función principal."""
    print("🚀 Iniciando geocodificación de eventos...")
    print(f"📡 Conectado a Supabase: {SUPABASE_URL}")
    # Detectar qué key se está usando
    key_source = "GOOGLE_MAPS_API_KEY_SERVER" if os.getenv('GOOGLE_MAPS_API_KEY_SERVER') else "GOOGLE_MAPS_API_KEY"
    print(f"🔑 API Key configurada: {'✅' if GOOGLE_MAPS_API_KEY else '❌'} (usando {key_source})")
    print()
    
    # Probar la API primero
    if not test_geocoding_api():
        print()
        print("⚠️  La API de Geocoding no está funcionando correctamente.")
        print("   El script se detendrá para evitar hacer requests innecesarios.")
        print()
        print("💡 Verifica en Google Cloud Console:")
        print("   1. APIs & Services → Credentials → Tu API Key")
        print("   2. Application restrictions → Debe estar en 'None' (sin restricciones)")
        print("   3. API restrictions → Debe incluir 'Geocoding API'")
        print("   4. Si cambiaste las restricciones, espera 1-2 minutos para que se propaguen")
        print()
        # Permitir continuar automáticamente si se pasa --force como argumento
        force_mode = '--force' in sys.argv
        if not force_mode:
            respuesta = input("¿Quieres continuar de todas formas? (s/n): ")
            if respuesta.lower() != 's':
                sys.exit(1)
        else:
            print("⚠️  Modo --force: Continuando automáticamente (muchos eventos pueden fallar)...")
        print()
    
    print()
    
    # Obtener eventos sin coordenadas
    print("📋 Obteniendo eventos sin coordenadas...")
    try:
        # Obtener eventos que no tienen lat o lng
        # Usar query directa con filtros
        events_response = supabase.table('events').select(
            'id, title, place, city_id, maps_url'
        ).or_('lat.is.null,lng.is.null').limit(500).execute()
        
        events = events_response.data if events_response.data else []
        
        # Obtener nombres de ciudades
        cities_response = supabase.table('cities').select('id, name').execute()
        cities = {c['id']: c['name'] for c in (cities_response.data or [])}
        
        print(f"📊 Encontrados {len(events)} eventos sin coordenadas")
        print()
        
        if not events:
            print("✅ No hay eventos sin coordenadas. ¡Todo está actualizado!")
            return
        
        # Procesar cada evento
        success_count = 0
        error_count = 0
        skipped_count = 0
        
        for i, event in enumerate(events, 1):
            event_id = event['id']
            title = event.get('title', 'Sin título')
            place = event.get('place')
            city_id = event.get('city_id')
            city_name = cities.get(city_id, 'Cádiz')  # Fallback a Cádiz
            
            print(f"[{i}/{len(events)}] {title}")
            print(f"  📍 Lugar: {place or 'No especificado'}")
            print(f"  🏙️  Ciudad: {city_name}")
            
            # Intentar obtener lugar desde maps_url si no hay place
            maps_url = event.get('maps_url')
            address = place
            
            if not address or address.strip() == '':
                # Intentar extraer desde maps_url
                if maps_url:
                    extracted_place = extract_place_from_maps_url(maps_url)
                    if extracted_place:
                        print(f"  🔍 Lugar extraído de maps_url: {extracted_place}")
                        address = extracted_place
                    else:
                        print(f"  ⚠️  Sin lugar específico, usando solo ciudad")
                        address = city_name
                else:
                    print(f"  ⚠️  Sin lugar específico, usando solo ciudad")
                    address = city_name
            
            # Geocodificar
            coords = geocode_address(address, city_name)
            
            if coords:
                lat, lng = coords
                # Validar coordenadas
                if -90 <= lat <= 90 and -180 <= lng <= 180:
                    # Actualizar en BD
                    if update_event_coordinates(event_id, lat, lng):
                        success_count += 1
                        print(f"  ✅ Actualizado correctamente")
                    else:
                        error_count += 1
                else:
                    print(f"  ⚠️  Coordenadas inválidas, saltando")
                    skipped_count += 1
            else:
                error_count += 1
            
            print()
            
            # Delay para no exceder límites de API
            if i < len(events):
                time.sleep(DELAY_BETWEEN_REQUESTS)
        
        # Resumen
        print("=" * 60)
        print("📊 RESUMEN")
        print("=" * 60)
        print(f"✅ Eventos actualizados: {success_count}")
        print(f"❌ Eventos con error: {error_count}")
        print(f"⚠️  Eventos saltados: {skipped_count}")
        print(f"📋 Total procesados: {len(events)}")
        print()
        
        if success_count > 0:
            print(f"🎉 ¡{success_count} eventos ahora tienen coordenadas!")
        
    except Exception as e:
        print(f"❌ Error al obtener eventos: {e}")
        import traceback
        traceback.print_exc()
        sys.exit(1)


if __name__ == '__main__':
    main()
