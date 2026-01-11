#!/usr/bin/env python3
"""
Script wrapper para generar SQL directamente desde archivo JSON
Uso: python3 generar_sql_directo.py <json_file> [supabase_url]
"""

import sys
import json
from generar_sql_eventos import generate_sql_inserts
from datetime import datetime

if __name__ == "__main__":
    if len(sys.argv) < 2:
        print("Uso: python3 generar_sql_directo.py <json_file> [supabase_url]")
        print("Ejemplo: python3 generar_sql_directo.py eventos.json https://xxxxx.supabase.co/storage/v1/object/public")
        sys.exit(1)
    
    json_file = sys.argv[1]
    supabase_url = sys.argv[2] if len(sys.argv) > 2 else "{SUPABASE_STORAGE_URL}"
    
    print(f"📖 Leyendo JSON desde: {json_file}")
    
    try:
        with open(json_file, 'r', encoding='utf-8') as f:
            events = json.load(f)
        
        if not isinstance(events, list):
            print("❌ Error: El JSON debe ser un array de eventos", file=sys.stderr)
            sys.exit(1)
        
        print(f"✅ JSON parseado correctamente: {len(events)} eventos encontrados\n")
        print(f"📝 Generando SQL con URL: {supabase_url}\n")
        
        sql = generate_sql_inserts(events, supabase_url)
        
        # Generar nombre de archivo con timestamp
        timestamp = datetime.now().strftime('%Y%m%d_%H%M%S')
        output_file = f"docs/migrations/016_insertar_eventos_{timestamp}.sql"
        
        with open(output_file, 'w', encoding='utf-8') as f:
            f.write(sql)
        
        print(f"{'='*80}")
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
        
        if supabase_url == "{SUPABASE_STORAGE_URL}":
            print(f"\n⚠️  IMPORTANTE: Revisa el archivo y reemplaza {{SUPABASE_STORAGE_URL}}")
            print(f"    con tu URL real antes de ejecutar en Supabase.\n")
        else:
            print(f"\n✅ La URL de Supabase Storage está configurada.\n")
        
    except FileNotFoundError:
        print(f"❌ Error: Archivo no encontrado: {json_file}", file=sys.stderr)
        sys.exit(1)
    except json.JSONDecodeError as e:
        print(f"❌ Error al parsear JSON: {e}", file=sys.stderr)
        print(f"   Posición: línea {e.lineno}, columna {e.colno}" if hasattr(e, 'lineno') else "", file=sys.stderr)
        sys.exit(1)
    except Exception as e:
        print(f"❌ Error: {e}", file=sys.stderr)
        import traceback
        traceback.print_exc()
        sys.exit(1)
