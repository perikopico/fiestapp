#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""Script para generar la migración 029: Actualizar info_url y description desde JSON (versión flexible)"""

import json
import sys
import os

def main():
    # Ruta del archivo JSON
    json_path = '/home/perikopico/Documentos/QuePlan-eventos/enero/final/final-definitivo2.txt'
    
    # Leer el archivo JSON
    with open(json_path, 'r', encoding='utf-8') as f:
        events = json.load(f)
    
    sql_updates = []
    sql_updates.append("-- ============================================")
    sql_updates.append("-- Migración 029: Actualizar info_url y description desde JSON (Versión Flexible)")
    sql_updates.append("-- ============================================")
    sql_updates.append("-- Este script actualiza los campos info_url y description de los eventos")
    sql_updates.append("-- basándose en el JSON final-definitivo2.txt")
    sql_updates.append("-- Usa coincidencias flexibles con LIKE para tolerar diferencias en títulos")
    sql_updates.append("-- ============================================\n")
    
    for event in events:
        title = event.get('title', '').strip()
        date = event.get('date', '').strip()
        description = event.get('description', '').strip().replace("'", "''")  # Escapar comillas simples
        info_url = event.get('info_url', '').strip().replace("'", "''")  # Escapar comillas simples
        
        if not title or not date:
            continue
        
        # Construir la fecha completa para la comparación
        date_condition = f"starts_at::date = '{date}'::date"
        
        # Extraer una parte única del título para coincidencia flexible
        # Usaremos los primeros caracteres significativos del título
        # Para "VI Ruta MTB Barbate: Los Alcornocales" -> buscamos "VI Ruta MTB Barbate"
        title_parts = title.split(':')
        title_search = title_parts[0].strip()
        
        # Escapar comillas y caracteres especiales para LIKE
        title_search_escaped = title_search.replace("'", "''").replace("%", "\\%").replace("_", "\\_")
        
        # Construir el UPDATE con LIKE para coincidencia flexible
        update_parts = []
        if description:
            update_parts.append(f"description = '{description}'")
        if info_url:
            update_parts.append(f"info_url = '{info_url}'")
        
        if update_parts:
            # Usar LIKE para permitir que el título en la BD pueda tener texto adicional
            update_sql = f"-- {title}"
            update_sql += f"\nUPDATE public.events"
            update_sql += f"\nSET {', '.join(update_parts)}"
            # LIKE permite coincidencias parciales: "VI Ruta MTB Barbate" coincidirá con "VI Ruta MTB Barbate: Los Alcornocales" y viceversa
            update_sql += f"\nWHERE title LIKE '{title_search_escaped}%' AND {date_condition};"
            update_sql += "\n"
            sql_updates.append(update_sql)
    
    # Agregar verificación final
    sql_updates.append("\n-- Verificar resultados")
    sql_updates.append("DO $$")
    sql_updates.append("DECLARE")
    sql_updates.append("  total_events integer;")
    sql_updates.append("  events_with_info_url integer;")
    sql_updates.append("  events_with_description integer;")
    sql_updates.append("  percentage_info_url numeric;")
    sql_updates.append("  percentage_description numeric;")
    sql_updates.append("BEGIN")
    sql_updates.append("  SELECT COUNT(*) INTO total_events FROM public.events;")
    sql_updates.append("  SELECT COUNT(*) INTO events_with_info_url FROM public.events WHERE info_url IS NOT NULL AND info_url != '';")
    sql_updates.append("  SELECT COUNT(*) INTO events_with_description FROM public.events WHERE description IS NOT NULL AND description != '';")
    sql_updates.append("  ")
    sql_updates.append("  IF total_events > 0 THEN")
    sql_updates.append("    percentage_info_url := ROUND((events_with_info_url::numeric / total_events::numeric) * 100, 2);")
    sql_updates.append("    percentage_description := ROUND((events_with_description::numeric / total_events::numeric) * 100, 2);")
    sql_updates.append("  ELSE")
    sql_updates.append("    percentage_info_url := 0;")
    sql_updates.append("    percentage_description := 0;")
    sql_updates.append("  END IF;")
    sql_updates.append("  ")
    sql_updates.append("  RAISE NOTICE '📊 Resumen de actualización:';")
    sql_updates.append("  RAISE NOTICE '   Total de eventos: %', total_events;")
    sql_updates.append("  RAISE NOTICE '   Eventos con info_url: % (% %%)', events_with_info_url, percentage_info_url;")
    sql_updates.append("  RAISE NOTICE '   Eventos con description: % (% %%)', events_with_description, percentage_description;")
    sql_updates.append("END $$;")
    
    # Escribir el archivo SQL
    output_path = 'docs/migrations/029_update_info_url_and_description_from_json.sql'
    with open(output_path, 'w', encoding='utf-8') as f:
        f.write('\n'.join(sql_updates))
    
    print(f"✅ Script SQL generado (versión flexible): {output_path}")
    print(f"   Total de eventos procesados: {len(events)}")
    total_updates = len([e for e in events if e.get('title') and e.get('date')])
    print(f"   Total de UPDATE statements: {total_updates}")
    print(f"   🔍 Usando LIKE para coincidencias flexibles (tolerante a diferencias en títulos)")
    
    return 0

if __name__ == '__main__':
    sys.exit(main())
