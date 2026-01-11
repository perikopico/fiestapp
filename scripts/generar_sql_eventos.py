#!/usr/bin/env python3
"""
Script para generar SQL INSERT de eventos desde JSON
Asigna automáticamente imágenes aleatorias de sample-images según la categoría

Formato de imágenes: 01.webp, 02.webp, 03.webp, etc.
Rangos por categoría (confirmados):
  - Categoría 1 (Música): 01-10 (10 imágenes)
  - Categoría 2 (Gastronomía): 01-14 (14 imágenes)
  - Categoría 3 (Deportes): 01-16 (16 imágenes)
  - Categoría 4 (Arte y Cultura): 01-09 (9 imágenes)
  - Categoría 5 (Aire Libre): 01-10 (10 imágenes)
  - Categoría 6 (Tradiciones): 01-09 (9 imágenes)
  - Categoría 7 (Mercadillos): 01-10 (10 imágenes)

Uso:
    python3 generar_sql_eventos.py
    Luego pega el JSON cuando se solicite
"""

import json
import sys
import uuid
import random
from datetime import datetime
from typing import List, Dict, Any, Optional

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

def get_random_image_url(category_number: int, supabase_storage_url: str, province_id: int = 1) -> str:
    """
    Genera una URL aleatoria para una imagen de muestra
    
    Args:
        category_number: Número de categoría (1-7)
        supabase_storage_url: URL base de Supabase Storage
        province_id: ID de provincia (default: 1 para Cádiz)
    
    Returns:
        URL completa de la imagen aleatoria
    """
    if category_number not in [1, 2, 3, 4, 5, 6, 7]:
        return "NULL"
    
    # Determinar máximo de imágenes según categoría
    max_images = CATEGORY_INFO.get(list(CATEGORY_INFO.keys())[category_number * 4 - 4] if category_number <= 7 else 'musica', {}).get('max_images', 10)
    
    # Obtener max_images del mapeo correcto
    for info in CATEGORY_INFO.values():
        if info['number'] == category_number:
            max_images = info['max_images']
            break
    
    # Seleccionar número aleatorio entre 1 y max_images
    random_num = random.randint(1, max_images)
    
    # Formatear con padding (01, 02, 03, etc.)
    image_filename = f"{random_num:02d}.webp"
    
    # Construir URL completa
    image_url = f"{supabase_storage_url}/sample-images/{province_id}/{category_number}/{image_filename}"
    
    return image_url

def generate_sql_inserts(events_json: List[Dict[str, Any]], supabase_storage_url: str) -> str:
    """
    Genera sentencias SQL INSERT para eventos
    
    Args:
        events_json: Lista de eventos en formato JSON
        supabase_storage_url: URL base de Supabase Storage
    
    Returns:
        String con las sentencias SQL
    """
    
    sql_lines = [
        "-- ============================================",
        "-- SQL generado automáticamente para insertar eventos desde JSON",
        "-- Fecha de generación: " + datetime.now().isoformat(),
        "-- Total de eventos: " + str(len(events_json)),
        "-- ============================================",
        "",
        "-- IMPORTANTE: Reemplaza {SUPABASE_STORAGE_URL} con tu URL real",
        "-- Ejemplo: https://xxxxx.supabase.co/storage/v1/object/public",
        "",
        "DO $$",
        "DECLARE",
        "  v_city_id INT;",
        "  v_category_id INT;",
        "  v_category_slug TEXT;",
        "  v_category_number INT;",
        "  v_max_images INT;",
        "  v_random_num INT;",
        "  v_image_filename TEXT;",
        "  v_image_url TEXT;",
        "  v_supabase_url TEXT := '{SUPABASE_STORAGE_URL}';  -- REEMPLAZAR con tu URL",
        "BEGIN",
        "",
    ]
    
    # Generar INSERTs para cada evento
    for i, event in enumerate(events_json, 1):
        event_id = str(uuid.uuid4())
        title = event.get('title', '').replace("'", "''")
        city_name = event.get('city', '').strip().replace("'", "''")
        category_name = event.get('category', '').strip()
        place = event.get('place', '').replace("'", "''") if event.get('place') else None
        starts_at = event.get('starts_at', '').strip()
        is_free = event.get('is_free', True)
        is_featured = event.get('is_featured', False)
        description = event.get('description', '').replace("'", "''") if event.get('description') else None
        maps_url = event.get('maps_url', '').strip().replace("'", "''") if event.get('maps_url') else None
        status = event.get('status', 'published')
        image_alignment = event.get('image_alignment', 'center')
        
        # Obtener información de la categoría
        category_info = normalize_category(category_name)
        if not category_info:
            print(f"⚠️  Advertencia: Categoría '{category_name}' no reconocida para evento '{title}' - usando NULL para imagen", file=sys.stderr)
            category_info = {'number': None, 'slug': None, 'name': category_name, 'max_images': 0}
        
        category_number = category_info['number']
        category_slug = category_info['slug'] or category_name.lower().replace(' ', '-')
        
        sql_lines.append(f"  -- =========================================")
        sql_lines.append(f"  -- Evento {i}: {title[:50]}...")
        sql_lines.append(f"  -- =========================================")
        sql_lines.append("  BEGIN")
        sql_lines.append(f"    -- Buscar ID de ciudad: {city_name}")
        sql_lines.append(f"    SELECT id INTO v_city_id FROM public.cities WHERE LOWER(name) = LOWER('{city_name}') LIMIT 1;")
        sql_lines.append(f"    IF v_city_id IS NULL THEN")
        sql_lines.append(f"      RAISE WARNING 'Ciudad no encontrada: %', '{city_name}';")
        sql_lines.append(f"    END IF;")
        sql_lines.append("    ")
        sql_lines.append(f"    -- Buscar ID de categoría: {category_name} (slug: {category_slug})")
        category_name_escaped = category_name.replace("'", "''")
        sql_lines.append(f"    SELECT id INTO v_category_id FROM public.categories WHERE LOWER(slug) = LOWER('{category_slug}') OR LOWER(name) = LOWER('{category_name_escaped}') LIMIT 1;")
        sql_lines.append(f"    IF v_category_id IS NULL THEN")
        sql_lines.append(f"      RAISE WARNING 'Categoría no encontrada: % (slug: %)', '{category_name}', '{category_slug}';")
        sql_lines.append(f"    END IF;")
        sql_lines.append("    ")
        
        if category_number:
            sql_lines.append(f"    -- Generar imagen aleatoria para categoría {category_number} ({category_info['name']})")
            sql_lines.append(f"    -- Rango de imágenes: 01.webp - {category_info['max_images']:02d}.webp")
            sql_lines.append(f"    v_category_number := {category_number};")
            sql_lines.append(f"    v_max_images := {category_info['max_images']};")
            sql_lines.append(f"    v_random_num := 1 + floor(random() * v_max_images)::INT;")
            sql_lines.append(f"    v_image_filename := LPAD(v_random_num::TEXT, 2, '0') || '.webp';")
            sql_lines.append(f"    v_image_url := v_supabase_url || '/sample-images/1/' || v_category_number::TEXT || '/' || v_image_filename;")
        else:
            sql_lines.append(f"    -- No se pudo determinar categoría, imagen será NULL")
            sql_lines.append(f"    v_image_url := NULL;")
        
        sql_lines.append("    ")
        sql_lines.append("    -- Insertar evento")
        sql_lines.append("    INSERT INTO public.events (")
        sql_lines.append("      id, title, place, maps_url, image_url, is_featured, is_free, ")
        sql_lines.append("      starts_at, city_id, category_id, status, description, image_alignment")
        sql_lines.append("    ) VALUES (")
        sql_lines.append(f"      '{event_id}',")
        sql_lines.append(f"      '{title}',")
        sql_lines.append(f"      {f"'{place}'" if place else 'NULL'},")
        sql_lines.append(f"      {f"'{maps_url}'" if maps_url else 'NULL'},")
        sql_lines.append("      v_image_url,")
        sql_lines.append(f"      {str(is_featured).upper()},")
        sql_lines.append(f"      {str(is_free).upper()},")
        sql_lines.append(f"      '{starts_at}'::timestamptz,")
        sql_lines.append("      v_city_id,")
        sql_lines.append("      v_category_id,")
        sql_lines.append(f"      '{status}',")
        sql_lines.append(f"      {f"'{description}'" if description else 'NULL'},")
        sql_lines.append(f"      '{image_alignment}'")
        sql_lines.append("    );")
        sql_lines.append("  EXCEPTION")
        sql_lines.append("    WHEN OTHERS THEN")
        sql_lines.append(f"      RAISE WARNING 'Error al insertar evento {i} (%): %', '{title[:30]}...', SQLERRM;")
        sql_lines.append("  END;")
        sql_lines.append("")
    
    sql_lines.extend([
        "END $$;",
        "",
        "-- ============================================",
        "-- Verificación",
        "-- ============================================",
        "SELECT COUNT(*) as total_eventos_insertados FROM public.events;",
        "",
        "-- Ver algunos eventos insertados",
        "SELECT ",
        "  e.id,",
        "  e.title,",
        "  c.name as ciudad,",
        "  cat.name as categoria,",
        "  e.starts_at,",
        "  e.image_url",
        "FROM public.events e",
        "LEFT JOIN public.cities c ON e.city_id = c.id",
        "LEFT JOIN public.categories cat ON e.category_id = cat.id",
        "ORDER BY e.starts_at DESC",
        "LIMIT 10;",
        "",
    ])
    
    return "\n".join(sql_lines)

if __name__ == "__main__":
    print("="*80)
    print("Generador de SQL para Eventos desde JSON")
    print("="*80)
    print("\nPor favor, pega el JSON con los eventos a continuación.")
    print("Presiona Enter dos veces después de pegar todo el JSON.\n")
    
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
        
        print(f"\n✅ JSON parseado correctamente: {len(events)} eventos encontrados\n")
        
        # Solicitar URL de Supabase Storage
        print("Por favor, introduce la URL base de tu Supabase Storage:")
        print("Ejemplo: https://xxxxx.supabase.co/storage/v1/object/public")
        print("(O presiona Enter para usar placeholder {SUPABASE_STORAGE_URL})")
        supabase_url = input().strip()
        
        if not supabase_url:
            supabase_url = "{SUPABASE_STORAGE_URL}"
        
        sql = generate_sql_inserts(events, supabase_url)
        
        # Generar nombre de archivo con timestamp
        timestamp = datetime.now().strftime('%Y%m%d_%H%M%S')
        output_file = f"docs/migrations/016_insertar_eventos_{timestamp}.sql"
        
        with open(output_file, 'w', encoding='utf-8') as f:
            f.write(sql)
        
        print(f"\n{'='*80}")
        print(f"✅ SQL generado correctamente: {output_file}")
        print(f"{'='*80}\n")
        print(f"Total de eventos: {len(events)}")
        print(f"\n📋 Resumen:")
        print(f"  - Las imágenes se asignarán aleatoriamente desde:")
        print(f"    sample-images/1/{{categoria}}/{{01-XX}}.webp")
        print(f"  - Rangos por categoría:")
        print(f"    • Música (1): 01-10.webp")
        print(f"    • Gastronomía (2): 01-14.webp")
        print(f"    • Deportes (3): 01-16.webp")
        print(f"    • Arte y Cultura (4): 01-09.webp")
        print(f"    • Aire Libre (5): 01-10.webp")
        print(f"    • Tradiciones (6): 01-09.webp")
        print(f"    • Mercadillos (7): 01-10.webp")
        print(f"\n⚠️  IMPORTANTE: Revisa el archivo y reemplaza {{SUPABASE_STORAGE_URL}}")
        print(f"    con tu URL real si no la proporcionaste.\n")
        
    except json.JSONDecodeError as e:
        print(f"\n❌ Error al parsear JSON: {e}", file=sys.stderr)
        print(f"   Posición: línea {e.lineno}, columna {e.colno}" if hasattr(e, 'lineno') else "", file=sys.stderr)
        sys.exit(1)
    except Exception as e:
        print(f"\n❌ Error: {e}", file=sys.stderr)
        import traceback
        traceback.print_exc()
        sys.exit(1)
