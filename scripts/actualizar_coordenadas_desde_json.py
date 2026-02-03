#!/usr/bin/env python3
"""
Script para actualizar coordenadas lat/lng de eventos desde un archivo JSON.

Este script:
1. Lee un archivo JSON con eventos y sus coordenadas
2. Actualiza los eventos en Supabase con las coordenadas proporcionadas

Formato esperado del JSON:
[
  {
    "id": "uuid-del-evento",
    "lat": 36.5270,
    "lng": -6.2880
  },
  ...
]

O también puede aceptar:
[
  {
    "id": "uuid-del-evento",
    "latitude": 36.5270,
    "longitude": -6.2880
  },
  ...
]

Requisitos:
- pip install supabase python-dotenv
- Archivo .env con SUPABASE_URL y SUPABASE_SERVICE_ROLE_KEY
"""

import os
import sys
import json
from typing import List, Dict, Any
from dotenv import load_dotenv
from supabase import create_client, Client

# Cargar variables de entorno desde la raíz del proyecto
script_dir = os.path.dirname(os.path.abspath(__file__))
project_root = os.path.dirname(script_dir)
env_path = os.path.join(project_root, '.env')
load_dotenv(env_path)

# Configuración
SUPABASE_URL = os.getenv('SUPABASE_URL')
SUPABASE_KEY = os.getenv('SUPABASE_SERVICE_ROLE_KEY')

# Validar variables
if not SUPABASE_URL:
    print("❌ Error: SUPABASE_URL no está definida en .env")
    sys.exit(1)

if not SUPABASE_KEY:
    print("❌ Error: SUPABASE_SERVICE_ROLE_KEY no está definida en .env")
    sys.exit(1)

# Limpiar espacios en blanco y comillas
SUPABASE_URL = SUPABASE_URL.strip().strip('"').strip("'")
SUPABASE_KEY = SUPABASE_KEY.strip().strip('"').strip("'")

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


def parse_coordinates(event: Dict[str, Any]) -> tuple[float, float] | None:
    """
    Extrae las coordenadas de un evento, soportando múltiples formatos.
    
    Formatos soportados:
    - {"lat": 36.5, "lng": -6.2}
    - {"latitude": 36.5, "longitude": -6.2}
    - {"lat": "36.5", "lng": "-6.2"} (strings convertidos a float)
    
    Returns:
        Tupla (lat, lng) si se encuentran, None si no
    """
    lat = None
    lng = None
    
    # Intentar obtener lat/lng
    if 'lat' in event:
        lat_val = event['lat']
        if lat_val is not None:
            try:
                lat = float(lat_val)
            except (ValueError, TypeError):
                pass
    
    if 'lng' in event:
        lng_val = event['lng']
        if lng_val is not None:
            try:
                lng = float(lng_val)
            except (ValueError, TypeError):
                pass
    
    # Si no se encontraron, intentar con latitude/longitude
    if lat is None and 'latitude' in event:
        lat_val = event['latitude']
        if lat_val is not None:
            try:
                lat = float(lat_val)
            except (ValueError, TypeError):
                pass
    
    if lng is None and 'longitude' in event:
        lng_val = event['longitude']
        if lng_val is not None:
            try:
                lng = float(lng_val)
            except (ValueError, TypeError):
                pass
    
    # Validar coordenadas
    if lat is not None and lng is not None:
        if -90 <= lat <= 90 and -180 <= lng <= 180:
            return (lat, lng)
    
    return None


def find_event_by_title_and_date(title: str, date_str: str) -> str | None:
    """
    Busca un evento en Supabase por título y fecha.
    
    Args:
        title: Título del evento
        date_str: Fecha en formato "YYYY-MM-DD"
        
    Returns:
        UUID del evento si se encuentra, None si no
    """
    try:
        # Construir fecha completa para buscar (asumiendo que starts_at incluye hora)
        # Buscar eventos que empiecen en ese día
        from datetime import datetime
        date_obj = datetime.strptime(date_str, '%Y-%m-%d')
        start_of_day = date_obj.strftime('%Y-%m-%dT00:00:00')
        end_of_day = date_obj.strftime('%Y-%m-%dT23:59:59')
        
        # Buscar por título y fecha
        result = supabase.table('events').select('id').eq('title', title).gte('starts_at', start_of_day).lte('starts_at', end_of_day).limit(1).execute()
        
        if result.data and len(result.data) > 0:
            return result.data[0]['id']
        return None
    except Exception as e:
        print(f"  ⚠️  Error al buscar por título/fecha: {e}")
        return None


def find_event_by_maps_url(maps_url: str) -> str | None:
    """
    Busca un evento en Supabase por maps_url.
    
    Args:
        maps_url: URL de Google Maps
        
    Returns:
        UUID del evento si se encuentra, None si no
    """
    try:
        result = supabase.table('events').select('id').eq('maps_url', maps_url).limit(1).execute()
        
        if result.data and len(result.data) > 0:
            return result.data[0]['id']
        return None
    except Exception as e:
        print(f"  ⚠️  Error al buscar por maps_url: {e}")
        return None


def update_event_coordinates(event_id: str, lat: float, lng: float) -> bool:
    """
    Actualiza las coordenadas de un evento en Supabase.
    
    Args:
        event_id: ID del evento (UUID)
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
            return False
    except Exception as e:
        print(f"  ❌ Error al actualizar: {e}")
        return False


def main():
    """Función principal."""
    print("🚀 Iniciando actualización de coordenadas desde JSON...")
    print(f"📡 Conectado a Supabase: {SUPABASE_URL}")
    print()
    
    # Leer JSON desde stdin o archivo
    json_data = None
    
    if len(sys.argv) > 1:
        # Leer desde archivo
        json_file = sys.argv[1]
        if not os.path.exists(json_file):
            print(f"❌ Error: El archivo {json_file} no existe")
            sys.exit(1)
        
        print(f"📄 Leyendo JSON desde archivo: {json_file}")
        with open(json_file, 'r', encoding='utf-8') as f:
            json_data = json.load(f)
    else:
        # Leer desde stdin
        print("📄 Leyendo JSON desde stdin...")
        print("   (Pega el JSON y presiona Ctrl+D cuando termines)")
        print()
        try:
            json_data = json.load(sys.stdin)
        except json.JSONDecodeError as e:
            print(f"❌ Error al parsear JSON: {e}")
            sys.exit(1)
    
    if not isinstance(json_data, list):
        print("❌ Error: El JSON debe ser una lista de eventos")
        sys.exit(1)
    
    print(f"📊 Encontrados {len(json_data)} eventos en el JSON")
    print()
    
    # Procesar cada evento
    success_count = 0
    error_count = 0
    skipped_count = 0
    not_found_count = 0
    
    for i, event_data in enumerate(json_data, 1):
        if not isinstance(event_data, dict):
            print(f"[{i}/{len(json_data)}] ⚠️  Evento no es un objeto, saltando...")
            skipped_count += 1
            continue
        
        # Extraer coordenadas primero
        coords = parse_coordinates(event_data)
        
        if not coords:
            title = event_data.get('title', 'Sin título')[:30]
            print(f"[{i}/{len(json_data)}] ⚠️  Evento '{title}...' sin coordenadas válidas, saltando...")
            skipped_count += 1
            continue
        
        lat, lng = coords
        
        # Intentar encontrar el evento en la BD
        event_uuid = None
        title = event_data.get('title', '')
        date_str = event_data.get('date', '')
        gmaps_link = event_data.get('gmaps_link', '')
        json_id = event_data.get('id')
        
        print(f"[{i}/{len(json_data)}] Buscando evento: '{title[:40]}...'")
        
        # Estrategia 1: Intentar por ID si parece UUID
        if json_id and isinstance(json_id, str) and len(json_id) > 30:
            try:
                check = supabase.table('events').select('id').eq('id', json_id).limit(1).execute()
                if check.data and len(check.data) > 0:
                    event_uuid = check.data[0]['id']
                    print(f"  🔍 Encontrado por ID UUID")
            except:
                pass
        
        # Estrategia 2: Buscar por maps_url (más confiable)
        if not event_uuid and gmaps_link:
            event_uuid = find_event_by_maps_url(gmaps_link)
            if event_uuid:
                print(f"  🔍 Encontrado por maps_url")
        
        # Estrategia 3: Buscar por título y fecha
        if not event_uuid and title and date_str:
            event_uuid = find_event_by_title_and_date(title, date_str)
            if event_uuid:
                print(f"  🔍 Encontrado por título y fecha")
        
        if not event_uuid:
            not_found_count += 1
            print(f"  ⚠️  Evento no encontrado en la base de datos")
            print(f"      Título: {title[:50]}")
            print(f"      Fecha: {date_str}")
            print(f"      Maps URL: {gmaps_link[:50] if gmaps_link else 'N/A'}")
            print()
            continue
        
        # Actualizar coordenadas
        print(f"  📍 Actualizando coordenadas (lat: {lat}, lng: {lng})...")
        
        if update_event_coordinates(event_uuid, lat, lng):
            success_count += 1
            print(f"  ✅ Actualizado correctamente")
        else:
            error_count += 1
            print(f"  ❌ Error al actualizar")
        
        print()
    
    # Resumen
    print("=" * 60)
    print("📊 RESUMEN")
    print("=" * 60)
    print(f"✅ Eventos actualizados: {success_count}")
    print(f"❌ Eventos con error: {error_count}")
    print(f"⚠️  Eventos saltados (sin coordenadas válidas): {skipped_count}")
    print(f"🔍 Eventos no encontrados: {not_found_count}")
    print(f"📋 Total procesados: {len(json_data)}")
    print()
    
    if success_count > 0:
        print(f"🎉 ¡{success_count} eventos ahora tienen coordenadas actualizadas!")
    
    if error_count > 0 or not_found_count > 0:
        print(f"⚠️  Revisa los eventos con errores o no encontrados")


if __name__ == '__main__':
    main()
