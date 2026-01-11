#!/usr/bin/env python3
"""
Script para reemplazar {SUPABASE_STORAGE_URL} en el archivo SQL generado
Uso: python3 reemplazar_url_sql.py <sql_file> <supabase_storage_url>
"""

import sys
import os

if __name__ == "__main__":
    if len(sys.argv) < 3:
        print("Uso: python3 reemplazar_url_sql.py <sql_file> <supabase_storage_url>")
        print("Ejemplo: python3 reemplazar_url_sql.py docs/migrations/016_insertar_eventos_20260111_004132.sql https://xxx.supabase.co/storage/v1/object/public")
        sys.exit(1)
    
    sql_file = sys.argv[1]
    supabase_url = sys.argv[2]
    
    if not os.path.exists(sql_file):
        print(f"❌ Error: Archivo no encontrado: {sql_file}", file=sys.stderr)
        sys.exit(1)
    
    # Leer el archivo
    with open(sql_file, 'r', encoding='utf-8') as f:
        content = f.read()
    
    # Reemplazar el placeholder
    if '{SUPABASE_STORAGE_URL}' not in content:
        print(f"⚠️  Advertencia: No se encontró {{SUPABASE_STORAGE_URL}} en el archivo")
        print(f"   El archivo podría ya estar actualizado o usar otro formato")
    else:
        content = content.replace('{SUPABASE_STORAGE_URL}', supabase_url)
        
        # Guardar el archivo actualizado
        output_file = sql_file.replace('.sql', '_CON_URL.sql')
        with open(output_file, 'w', encoding='utf-8') as f:
            f.write(content)
        
        replacements = content.count(supabase_url) - content.count('{SUPABASE_STORAGE_URL}')
        print(f"✅ Archivo actualizado: {output_file}")
        print(f"   Reemplazos realizados: {replacements}")
        print(f"   URL: {supabase_url}")
