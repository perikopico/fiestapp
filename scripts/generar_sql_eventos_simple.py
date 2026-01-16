#!/usr/bin/env python3
"""
Script para generar SQL INSERT de eventos desde JSON
Asigna imágenes secuencialmente por categoría (primera vez = 01, segunda = 02, etc.)

Formato: INSERTs directos (sin DO $$ blocks)

Uso:
    python3 generar_sql_eventos_simple.py < events.json > output.sql
    O pega el JSON cuando se solicite
"""

import json
import sys
import uuid
from datetime import datetime
from typing import List, Dict, Any, Optional
from collections import defaultdict

# URL de Supabase Storage
SUPABASE_STORAGE_URL = 'https://oudofaiekedtaovrdqeo.supabase.co/storage/v1/object/public'

# Mapeo de nombres de categorías a números de carpeta, slugs y máximo de imágenes
CATEGORY_INFO = {
    # Música (1) - 10 imágenes (01-10)
    'musica': {'number': 1, 'slug': 'musica', 'name': 'Música', 'max_images': 10},
    'música': {'number': 1, 'slug': 'musica', 'name': 'Música', 'max_images': 10},
    'music': {'number': 1, 'slug': 'musica', 'name': 'Música', 'max_images': 10},
    
    # Gastronomía (2) - 14 imágenes (01-14)
    'gastronomia': {'number': 2, 'slug': 'gastronomia', 'name': 'Gastronomía', 'max_images': 14},
    'gastronomía': {'number': 2, 'slug': 'gastronomia', 'name': 'Gastronomía', 'max_images': 14},
    'gastronomy': {'number': 2, 'slug': 'gastronomia', 'name': 'Gastronomía', 'max_images': 14},
    
    # Deportes (3) - 16 imágenes (01-16)
    'deportes': {'number': 3, 'slug': 'deportes', 'name': 'Deportes', 'max_images': 16},
    'deporte': {'number': 3, 'slug': 'deportes', 'name': 'Deportes', 'max_images': 16},
    'sport': {'number': 3, 'slug': 'deportes', 'name': 'Deportes', 'max_images': 16},
    'sports': {'number': 3, 'slug': 'deportes', 'name': 'Deportes', 'max_images': 16},
    
    # Arte y Cultura (4) - 9 imágenes (01-09)
    'arte-y-cultura': {'number': 4, 'slug': 'arte-y-cultura', 'name': 'Arte y Cultura', 'max_images': 9},
    'arte y cultura': {'number': 4, 'slug': 'arte-y-cultura', 'name': 'Arte y Cultura', 'max_images': 9},
    'arte': {'number': 4, 'slug': 'arte-y-cultura', 'name': 'Arte y Cultura', 'max_images': 9},
    'cultura': {'number': 4, 'slug': 'arte-y-cultura', 'name': 'Arte y Cultura', 'max_images': 9},
    'culture': {'number': 4, 'slug': 'arte-y-cultura', 'name': 'Arte y Cultura', 'max_images': 9},
    
    # Aire Libre (5) - 10 imágenes (01-10)
    'aire-libre': {'number': 5, 'slug': 'aire-libre', 'name': 'Aire Libre', 'max_images': 10},
    'aire libre': {'number': 5, 'slug': 'aire-libre', 'name': 'Aire Libre', 'max_images': 10},
    'naturaleza': {'number': 5, 'slug': 'aire-libre', 'name': 'Aire Libre', 'max_images': 10},
    'nature': {'number': 5, 'slug': 'aire-libre', 'name': 'Aire Libre', 'max_images': 10},
    
    # Tradiciones (6) - 9 imágenes (01-09)
    'tradiciones': {'number': 6, 'slug': 'tradiciones', 'name': 'Tradiciones', 'max_images': 9},
    'tradición': {'number': 6, 'slug': 'tradiciones', 'name': 'Tradiciones', 'max_images': 9},
    'tradicion': {'number': 6, 'slug': 'tradiciones', 'name': 'Tradiciones', 'max_images': 9},
    'tradition': {'number': 6, 'slug': 'tradiciones', 'name': 'Tradiciones', 'max_images': 9},
    
    # Mercadillos (7) - 10 imágenes (01-10)
    'mercadillos': {'number': 7, 'slug': 'mercadillos', 'name': 'Mercadillos', 'max_images': 10},
    'mercadillo': {'number': 7, 'slug': 'mercadillos', 'name': 'Mercadillos', 'max_images': 10},
    'mercados': {'number': 7, 'slug': 'mercadillos', 'name': 'Mercadillos', 'max_images': 10},
    'mercado': {'number': 7, 'slug': 'mercadillos', 'name': 'Mercadillos', 'max_images': 10},
    'market': {'number': 7, 'slug': 'mercadillos', 'name': 'Mercadillos', 'max_images': 10},
}

def normalize_category(category_name: str) -> Optional[Dict[str, Any]]:
    """Normaliza el nombre de categoría y devuelve su información"""
    category_lower = category_name.lower().strip()
    
    # Búsqueda exacta
    if category_lower in CATEGORY_INFO:
        return CATEGORY_INFO[category_lower]
    
    # Búsqueda parcial
    for key, value in CATEGORY_INFO.items():
        if key in category_lower or category_lower in key:
            return value
    
    return None

def is_free_price(price: str) -> bool:
    """Determina si un evento es gratis basándose en el campo price"""
    if not price:
        return False
    price_lower = price.lower()
    free_keywords = ['gratis', 'entrada libre', 'donativo', 'libre']
    return any(keyword in price_lower for keyword in free_keywords)

def generate_sql_inserts(events_json: List[Dict[str, Any]], supabase_storage_url: str) -> str:
    """
    Genera sentencias SQL INSERT directas para eventos
    
    Args:
        events_json: Lista de eventos en formato JSON
        supabase_storage_url: URL base de Supabase Storage
    
    Returns:
        String con las sentencias SQL
    """
    
    # Contador por categoría para imágenes secuenciales
    category_counters = defaultdict(int)
    
    sql_lines = [
        "-- ============================================",
        "-- SQL generado automáticamente para insertar eventos desde JSON",
        f"-- Fecha de generación: {datetime.now().isoformat()}",
        f"-- Total de eventos: {len(events_json)}",
        "-- Formato: INSERTs directos con imágenes secuenciales por categoría",
        "-- ============================================",
        "",
    ]
    
    # Generar INSERTs para cada evento
    for event in events_json:
        event_id = str(uuid.uuid4())
        title_raw = event.get('title', '')
        city_name = event.get('city', '').strip()
        if not city_name:
            # Primero, intentar extraer ciudad del título si está entre paréntesis
            import re
            title_match = re.search(r'\(([^)]+)\)', title_raw)
            if title_match:
                city_from_title = title_match.group(1).strip()
                # Mapear nombres comunes del título a nombres completos
                title_city_map = {
                    'Chiclana': 'Chiclana de la Frontera',
                    'Arcos': 'Arcos de la Frontera',
                }
                if city_from_title in title_city_map:
                    city_name = title_city_map[city_from_title]
                elif city_from_title in ['Chiclana', 'Arcos']:
                    # Ya mapeado arriba
                    pass
            
            # Si aún no hay ciudad, intentar extraer de location_name
            if not city_name:
                location = event.get('location_name', '')
                if location:
                    # Buscar nombres de ciudades conocidas (orden importante: más específicas primero)
                    city_mappings = [
                        ('Villaluenga del Rosario', 'Villaluenga del Rosario'),
                        ('Villaluenga', 'Villaluenga del Rosario'),
                        ('Jerez de la Frontera', 'Jerez de la Frontera'),
                        ('Jerez', 'Jerez de la Frontera'),
                        ('El Puerto de Santa María', 'El Puerto de Santa María'),
                        ('El Puerto', 'El Puerto de Santa María'),
                        ('Sanlúcar de Barrameda', 'Sanlúcar de Barrameda'),
                        ('Sanlúcar', 'Sanlúcar de Barrameda'),
                        ('San Fernando', 'San Fernando'),
                        ('Puerto Real', 'Puerto Real'),
                        ('Vejer de la Frontera', 'Vejer de la Frontera'),
                        ('Vejer', 'Vejer de la Frontera'),
                        ('Sotogrande', 'Sotogrande'),
                        ('Cádiz', 'Cádiz'),
                        ('Algeciras', 'Algeciras'),
                        ('Barbate', 'Barbate'),
                        ('La Línea', 'La Línea de la Concepción'),
                        ('Conil', 'Conil de la Frontera'),
                        ('Chiclana', 'Chiclana de la Frontera'),
                        ('Arcos de la Frontera', 'Arcos de la Frontera'),
                        ('Arcos', 'Arcos de la Frontera'),
                        ('Algodonales', 'Algodonales'),
                        ('San Roque', 'San Roque'),
                        ('Rota', 'Rota'),
                        ('Benalup-Casas Viejas', 'Benalup-Casas Viejas'),
                        ('Benalup', 'Benalup-Casas Viejas'),
                        # Detecciones adicionales por contexto
                        ('El Palmar', 'Sanlúcar de Barrameda'),  # Estadio El Palmar está en Sanlúcar
                        ('El Rosal', 'Puerto Real'),  # Ciudad Deportiva El Rosal está en Puerto Real
                        ('Montenmedio', 'Vejer de la Frontera'),  # Dehesa Montenmedio está en Vejer
                        ('Parque Los Toruños', 'El Puerto de Santa María'),  # Los Toruños está en El Puerto
                        ('Teatro Villamarta', 'Jerez de la Frontera'),  # Villamarta está en Jerez
                        ('Teatro Juan Luis Galiardo', 'San Roque'),  # Galiardo está en San Roque
                        ('Bodegas Los Apóstoles', 'Jerez de la Frontera'),  # Bodegas en Jerez
                        ('Teatro Olivares Veas', 'Arcos de la Frontera'),  # Olivares Veas está en Arcos
                        ('El Picacho', 'Alcalá de los Gazules'),  # El Picacho está en Alcalá de los Gazules
                        ('Peña Carnavalesca Perico Alcántara', 'Chiclana de la Frontera'),  # Peña en Chiclana
                    ]
                    for search_term, mapped_city in city_mappings:
                        if search_term in location:
                            city_name = mapped_city
                            break
                    # Si no se encuentra, usar "Cádiz" como fallback para "Provincia de Cádiz"
                    if not city_name and 'Provincia de Cádiz' in location:
                        city_name = 'Cádiz'
        
        # Escapar comillas simples en el título para SQL
        title = title_raw.replace("'", "''")
        
        category_name = event.get('category', '').strip()
        place = event.get('place', event.get('location_name', '')).replace("'", "''") if event.get('place') or event.get('location_name') else None
        
        # Formatear fecha/hora
        date = event.get('date', '').strip()
        time = event.get('time', '').strip()
        if date and time:
            # Formato: 2026-01-16T22:30:00Z
            starts_at = f"{date}T{time}Z"
        else:
            starts_at = event.get('starts_at', '').strip()
        
        # Determinar is_free
        price = event.get('price', '')
        is_free = is_free_price(price) if price else False
        
        description = event.get('description', '').replace("'", "''") if event.get('description') else None
        maps_url = event.get('gmaps_link', event.get('maps_url', '')).strip() if event.get('gmaps_link') or event.get('maps_url') else None
        if maps_url:
            maps_url = maps_url.replace("'", "''")
        
        # Obtener información de la categoría
        category_info = normalize_category(category_name)
        if not category_info:
            print(f"⚠️  Advertencia: Categoría '{category_name}' no reconocida para evento '{title}' - usando NULL para imagen", file=sys.stderr)
            category_slug = category_name.lower().replace(' ', '-')
            image_url = 'NULL'
        else:
            category_number = category_info['number']
            category_slug = category_info['slug']
            max_images = category_info['max_images']
            
            # Asignar imagen secuencial
            category_counters[category_number] += 1
            image_num = category_counters[category_number]
            
            # Si se excede el máximo, volver a empezar
            if image_num > max_images:
                image_num = ((image_num - 1) % max_images) + 1
            
            image_filename = f"{image_num:02d}.webp"
            image_url = f"'{supabase_storage_url}/sample-images/1/{category_number}/{image_filename}'"
        
        # Escapar comillas en city_name para SQL
        city_name_escaped = city_name.replace("'", "''")
        
        # Generar INSERT
        sql_lines.append("INSERT INTO public.events (id, title, place, maps_url, image_url, is_featured, is_free, starts_at, city_id, category_id, status, description, image_alignment, town) VALUES (")
        sql_lines.append(f"      '{event_id}',")
        sql_lines.append(f"      '{title}',")
        sql_lines.append(f"      {f"'{place}'" if place else 'NULL'},")
        sql_lines.append(f"      {f"'{maps_url}'" if maps_url else 'NULL'},")
        sql_lines.append(f"      {image_url},")
        sql_lines.append("      FALSE,")
        sql_lines.append(f"      {str(is_free).upper()},")
        sql_lines.append(f"      '{starts_at}'::timestamptz,")
        sql_lines.append(f"      (SELECT id FROM public.cities WHERE LOWER(name) = LOWER('{city_name_escaped}') LIMIT 1),")
        sql_lines.append(f"      (SELECT id FROM public.categories WHERE LOWER(slug) = '{category_slug}' LIMIT 1),")
        sql_lines.append("      'published',")
        sql_lines.append(f"      {f"'{description}'" if description else 'NULL'},")
        sql_lines.append("      'center',")
        sql_lines.append(f"      '{city_name_escaped}');")
        sql_lines.append("")
    
    return "\n".join(sql_lines)

if __name__ == "__main__":
    print("="*80, file=sys.stderr)
    print("Generador de SQL para Eventos desde JSON (Formato Simplificado)", file=sys.stderr)
    print("="*80, file=sys.stderr)
    print("\nPor favor, pega el JSON con los eventos a continuación.", file=sys.stderr)
    print("Presiona Enter dos veces después de pegar todo el JSON.\n", file=sys.stderr)
    
    lines = []
    empty_count = 0
    
    while True:
        try:
            line = input()
            if line == "":
                empty_count += 1
                if empty_count >= 2:
                    break
            else:
                empty_count = 0
                lines.append(line)
        except EOFError:
            break
    
    json_text = "\n".join(lines)
    
    if not json_text.strip():
        print("Error: No se proporcionó ningún JSON", file=sys.stderr)
        sys.exit(1)
    
    try:
        events = json.loads(json_text)
        if not isinstance(events, list):
            print("Error: El JSON debe ser un array de eventos", file=sys.stderr)
            sys.exit(1)
        
        print(f"\n✅ JSON parseado correctamente: {len(events)} eventos encontrados\n", file=sys.stderr)
        
        sql = generate_sql_inserts(events, SUPABASE_STORAGE_URL)
        
        # Generar nombre de archivo con timestamp
        timestamp = datetime.now().strftime('%Y%m%d_%H%M%S')
        output_file = f"docs/migrations/023_insertar_eventos_{timestamp}.sql"
        
        with open(output_file, 'w', encoding='utf-8') as f:
            f.write(sql)
        
        print(f"\n{'='*80}", file=sys.stderr)
        print(f"✅ SQL generado correctamente: {output_file}", file=sys.stderr)
        print(f"{'='*80}\n", file=sys.stderr)
        print(f"Total de eventos: {len(events)}", file=sys.stderr)
        print(f"\n📋 Las imágenes se asignan secuencialmente por categoría:", file=sys.stderr)
        print(f"  - Primera vez que aparece una categoría: 01.webp", file=sys.stderr)
        print(f"  - Segunda vez: 02.webp, tercera: 03.webp, etc.", file=sys.stderr)
        print(f"  - Si se excede el máximo, se vuelve a empezar\n", file=sys.stderr)
        
    except json.JSONDecodeError as e:
        print(f"\n❌ Error al parsear JSON: {e}", file=sys.stderr)
        print(f"   Posición: línea {e.lineno}, columna {e.colno}" if hasattr(e, 'lineno') else "", file=sys.stderr)
        sys.exit(1)
    except Exception as e:
        print(f"\n❌ Error: {e}", file=sys.stderr)
        import traceback
        traceback.print_exc()
        sys.exit(1)
