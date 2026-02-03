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


def parse_external_id(id_val: Any) -> Optional[int]:
    """
    Extrae el external_id numérico del id del JSON.
    - evt_001 -> 1, evt_042 -> 42
    - 123 (int) -> 123
    """
    if id_val is None:
        return None
    if isinstance(id_val, int):
        return id_val
    import re
    s = str(id_val).strip()
    m = re.search(r'evt_?(\d+)', s, re.I)
    if m:
        return int(m.group(1))
    try:
        return int(s)
    except ValueError:
        return None

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
        "-- SQL generado automáticamente para eventos desde JSON",
        f"-- Fecha de generación: {datetime.now().isoformat()}",
        f"-- Total de eventos: {len(events_json)}",
        "-- Soporta: new (INSERT/UPSERT), modified (UPDATE), cancelled (soft delete)",
        "-- Venues: Se crean automáticamente desde 'place' si no existen (status=approved)",
        "-- Requiere: migración 030 (external_id), 044 (event_translations), 005 (venues), 026 (price), 028 (info_url), image_alignment",
        "-- Ejecutar en Supabase SQL Editor (bypass RLS para crear venues approved)",
        "-- ============================================",
        "",
    ]
    
    # Generar SQL para cada evento
    for event in events_json:
        json_id = event.get('id')
        external_id = parse_external_id(json_id)
        status = (event.get('status') or 'new').lower().strip()
        
        # status "cancelled": solo UPDATE para marcar como rechazado
        if status == 'cancelled':
            if external_id is None:
                print(f"⚠️  Advertencia: Evento sin id válido para cancelled - ignorado", file=sys.stderr)
                continue
            sql_lines.append(f"-- Cancelled: {json_id} (external_id={external_id})")
            sql_lines.append(f"UPDATE public.events SET status = 'rejected' WHERE external_id = {external_id};")
            sql_lines.append("")
            continue
        
        # Para new/modified: UPSERT
        event_uuid = str(uuid.uuid4())
        
        # Soportar formato nuevo (translations) y legacy (title/description directos)
        translations = event.get('translations', {})
        if translations:
            # Formato nuevo: translations.es.title, translations.es.description
            es_block = translations.get('es', {})
            title_raw = es_block.get('title', '') or event.get('title', '')
            description = es_block.get('description', '') or event.get('description', '')
        else:
            # Formato legacy
            title_raw = event.get('title', '')
            description = event.get('description', '')
        
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
        
        # Precio (texto: "Gratis", "18€", "Desde 10€", etc.) - la BD tiene columna price, no is_free
        price = (event.get('price') or '').strip()
        price_escaped = price.replace("'", "''") if price else None  # NULL si vacío
        
        # description ya extraída arriba (formato translations o legacy)
        description = description.replace("'", "''") if description else None
        maps_url = event.get('gmaps_link', event.get('maps_url', '')).strip() if event.get('gmaps_link') or event.get('maps_url') else None
        if maps_url:
            maps_url = maps_url.replace("'", "''")
        info_url = (event.get('info_url') or '').strip()
        if info_url:
            info_url = info_url.replace("'", "''")
        else:
            info_url = None
        image_alignment = (event.get('image_alignment') or 'center').strip()
        if image_alignment not in ('top', 'center', 'bottom'):
            image_alignment = 'center'
        image_alignment_escaped = image_alignment.replace("'", "''")
        
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
        
        # external_id para UPSERT (si no se pudo parsear, usar 0 y advertir - no recomendado)
        if external_id is None:
            external_id = 0
            print(f"⚠️  Advertencia: Evento '{title[:40]}...' sin id válido - usando external_id=0. Añade 'id': 'evt_XXX' al JSON.", file=sys.stderr)
        
        # Extraer lat/lng de gmaps_link si existe (?query=lat,lng)
        venue_lat = venue_lng = None
        if maps_url:
            import re
            qmatch = re.search(r'[?&]query=([^&]+)', maps_url)
            if qmatch:
                parts = qmatch.group(1).split(',')
                if len(parts) >= 2:
                    try:
                        venue_lat = float(parts[0].strip())
                        venue_lng = float(parts[1].strip())
                    except ValueError:
                        pass
        
        # Bloques para event_translations (se usan dentro del DO)
        trans_inserts = []
        trans_obj = event.get('translations', {}) or {}
        for lang_code, lang_label in [('en', 'English'), ('de', 'German'), ('zh', 'Chinese')]:
            lang_block = trans_obj.get(lang_code, {}) if isinstance(trans_obj, dict) else {}
            if not lang_block:
                lang_block = {
                    'title': event.get(f'title_{lang_code}', ''),
                    'description': event.get(f'description_{lang_code}', ''),
                }
            trans_title = (lang_block.get('title') or '').strip().replace("'", "''")
            trans_desc = (lang_block.get('description') or '').strip().replace("'", "''")
            if trans_title:
                trans_inserts.append((lang_code, trans_title, trans_desc))
        
        # UPSERT con DO block (permite new y modified)
        # Crea venue si place existe y no está creado; sin venue aprobado el evento no puede aceptarse
        place_escaped = place.replace("'", "''") if place else None
        sql_lines.append(f"-- {status.upper()}: {json_id or 'sin id'} | {title[:50]}...")
        sql_lines.append("DO $$")
        sql_lines.append("DECLARE")
        sql_lines.append("  v_event_id uuid;")
        sql_lines.append("  v_venue_id uuid;")
        sql_lines.append("  v_city_id int8;")
        sql_lines.append("BEGIN")
        sql_lines.append(f"  SELECT id INTO v_city_id FROM public.cities WHERE LOWER(name) = LOWER('{city_name_escaped}') LIMIT 1;")
        sql_lines.append("")
        # Crear o obtener venue si hay place (evento solo se acepta si venue existe y está aprobado)
        if place_escaped:
            lat_sql = str(venue_lat) if venue_lat is not None else 'NULL'
            lng_sql = str(venue_lng) if venue_lng is not None else 'NULL'
            sql_lines.append("  IF v_city_id IS NOT NULL THEN")
            sql_lines.append("    INSERT INTO public.venues (name, city_id, address, lat, lng, status)")
            sql_lines.append(f"    VALUES ('{place_escaped}', v_city_id, NULL, {lat_sql}, {lng_sql}, 'approved')")
            sql_lines.append("    ON CONFLICT (name, city_id) DO UPDATE SET status = 'approved', updated_at = now()")
            sql_lines.append("    RETURNING id INTO v_venue_id;")
            sql_lines.append("  ELSE")
            sql_lines.append("    v_venue_id := NULL;")
            sql_lines.append("  END IF;")
            sql_lines.append("")
        else:
            sql_lines.append("  v_venue_id := NULL;")
            sql_lines.append("")
        sql_lines.append("  INSERT INTO public.events (id, external_id, title, place, maps_url, image_url, is_featured, price, starts_at, city_id, category_id, status, description, image_alignment, town, venue_id, info_url)")
        sql_lines.append("  VALUES (")
        sql_lines.append(f"    gen_random_uuid(),")
        sql_lines.append(f"    {external_id}::bigint,")
        sql_lines.append(f"    '{title}',")
        sql_lines.append(f"    {f"'{place}'" if place else 'NULL'},")
        sql_lines.append(f"    {f"'{maps_url}'" if maps_url else 'NULL'},")
        sql_lines.append(f"    {image_url},")
        sql_lines.append("    FALSE,")
        sql_lines.append(f"    {f"'{price_escaped}'" if price_escaped else 'NULL'},")
        sql_lines.append(f"    '{starts_at}'::timestamptz,")
        sql_lines.append(f"    v_city_id,")
        sql_lines.append(f"    (SELECT id FROM public.categories WHERE LOWER(slug) = '{category_slug}' LIMIT 1),")
        sql_lines.append("    'published',")
        sql_lines.append(f"    {f"'{description}'" if description else 'NULL'},")
        sql_lines.append(f"    '{image_alignment_escaped}',")
        sql_lines.append(f"    '{city_name_escaped}',")
        sql_lines.append("    v_venue_id,")
        sql_lines.append(f"    {f"'{info_url}'" if info_url else 'NULL'}")
        sql_lines.append("  )")
        sql_lines.append("  ON CONFLICT (external_id) WHERE (external_id IS NOT NULL) DO UPDATE SET")
        sql_lines.append("    title = EXCLUDED.title,")
        sql_lines.append("    description = EXCLUDED.description,")
        sql_lines.append("    place = EXCLUDED.place,")
        sql_lines.append("    maps_url = EXCLUDED.maps_url,")
        sql_lines.append("    image_url = EXCLUDED.image_url,")
        sql_lines.append("    price = EXCLUDED.price,")
        sql_lines.append("    starts_at = EXCLUDED.starts_at,")
        sql_lines.append("    city_id = EXCLUDED.city_id,")
        sql_lines.append("    category_id = EXCLUDED.category_id,")
        sql_lines.append("    town = EXCLUDED.town,")
        sql_lines.append("    venue_id = EXCLUDED.venue_id,")
        sql_lines.append("    info_url = EXCLUDED.info_url,")
        sql_lines.append("    image_alignment = EXCLUDED.image_alignment")
        sql_lines.append("  RETURNING id INTO v_event_id;")
        sql_lines.append("")
        
        for lang_code, trans_title, trans_desc in trans_inserts:
            sql_lines.append(f"  INSERT INTO public.event_translations (event_id, language_code, title, description)")
            sql_lines.append(f"  VALUES (v_event_id, '{lang_code}', '{trans_title}', {f"'{trans_desc}'" if trans_desc else 'NULL'})")
            sql_lines.append(f"  ON CONFLICT (event_id, language_code) DO UPDATE SET title = EXCLUDED.title, description = EXCLUDED.description;")
            sql_lines.append("")
        
        sql_lines.append("END $$;")
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
