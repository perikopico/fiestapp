#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""Script para generar migración 031: Asignar external_id a eventos usando título y fecha"""

import json
import sys

def main():
    # Ruta del archivo JSON
    json_path = '/home/perikopico/Documentos/QuePlan-eventos/enero/final/final-definitivo2.txt'
    
    # Leer el archivo JSON
    with open(json_path, 'r', encoding='utf-8') as f:
        events = json.load(f)
    
    sql_updates = []
    sql_updates.append("-- ============================================")
    sql_updates.append("-- Migración 031: Asignar external_id a eventos desde JSON")
    sql_updates.append("-- ============================================")
    sql_updates.append("-- Este script asigna el external_id (ID del JSON) a los eventos existentes")
    sql_updates.append("-- usando coincidencia flexible de título y fecha")
    sql_updates.append("-- Requiere que la migración 030_add_external_id_to_events.sql ya se haya ejecutado")
    sql_updates.append("-- Usa una estrategia segura para evitar duplicados: solo actualiza un evento por external_id")
    sql_updates.append("-- ============================================\n")
    
    sql_updates.append("-- Paso 1: Limpiar external_id duplicados (si los hay)")
    sql_updates.append("-- Establecer NULL en eventos donde el external_id ya está asignado a otro evento")
    sql_updates.append("UPDATE public.events e1")
    sql_updates.append("SET external_id = NULL")
    sql_updates.append("WHERE e1.external_id IS NOT NULL")
    sql_updates.append("  AND EXISTS (")
    sql_updates.append("    SELECT 1")
    sql_updates.append("    FROM public.events e2")
    sql_updates.append("    WHERE e2.external_id = e1.external_id")
    sql_updates.append("      AND e2.id != e1.id")
    sql_updates.append("  );")
    sql_updates.append("\n")
    sql_updates.append("-- Paso 2: Asignar external_id a los eventos")
    sql_updates.append("-- IMPORTANTE: Usamos subconsulta con LIMIT 1 para asignar solo UN evento por external_id")
    sql_updates.append("-- Esto evita duplicados cuando múltiples eventos coinciden con la misma condición\n")
    
    for event in events:
        external_id = event.get('id')  # ID del JSON
        title = event.get('title', '').strip()
        date = event.get('date', '').strip()
        
        if not external_id or not title or not date:
            continue
        
        # Construir la fecha completa para la comparación
        date_condition = f"starts_at::date = '{date}'::date"
        
        # Extraer la primera parte del título (antes de ':')
        title_parts = title.split(':')
        title_search = title_parts[0].strip()
        
        # Escapar comillas y caracteres especiales para LIKE
        title_search_escaped = title_search.replace("'", "''").replace("%", "\\%").replace("_", "\\_")
        
        # Construir el UPDATE usando una subconsulta con LIMIT 1
        # Esto asegura que solo se actualice UN evento incluso si hay múltiples coincidencias
        update_sql = f"-- {title} -> external_id: {external_id}"
        update_sql += f"\nUPDATE public.events"
        update_sql += f"\nSET external_id = {external_id}"
        # Usar una subconsulta para seleccionar solo el primer evento que coincida
        # Ordenamos por id para tener resultados consistentes
        update_sql += f"\nWHERE id IN ("
        update_sql += f"\n  SELECT e.id"
        update_sql += f"\n  FROM public.events e"
        update_sql += f"\n  WHERE e.title LIKE '{title_search_escaped}%'"
        update_sql += f"\n    AND e.{date_condition}"
        update_sql += f"\n    AND e.external_id IS NULL"
        update_sql += f"\n    AND NOT EXISTS ("
        update_sql += f"\n      SELECT 1 FROM public.events e2"
        update_sql += f"\n      WHERE e2.external_id = {external_id}"
        update_sql += f"\n        AND e2.id != e.id"
        update_sql += f"\n    )"
        update_sql += f"\n  ORDER BY e.id"
        update_sql += f"\n  LIMIT 1"
        update_sql += f"\n);"
        update_sql += "\n"
        sql_updates.append(update_sql)
    
    # Agregar verificación final
    sql_updates.append("\n-- Verificar resultados")
    sql_updates.append("DO $$")
    sql_updates.append("DECLARE")
    sql_updates.append("  total_events integer;")
    sql_updates.append("  events_with_external_id integer;")
    sql_updates.append("  duplicate_external_ids integer;")
    sql_updates.append("  percentage_assigned numeric;")
    sql_updates.append("BEGIN")
    sql_updates.append("  SELECT COUNT(*) INTO total_events FROM public.events;")
    sql_updates.append("  SELECT COUNT(*) INTO events_with_external_id FROM public.events WHERE external_id IS NOT NULL;")
    sql_updates.append("  -- Verificar si hay external_id duplicados")
    sql_updates.append("  SELECT COUNT(*) INTO duplicate_external_ids")
    sql_updates.append("  FROM (")
    sql_updates.append("    SELECT external_id")
    sql_updates.append("    FROM public.events")
    sql_updates.append("    WHERE external_id IS NOT NULL")
    sql_updates.append("    GROUP BY external_id")
    sql_updates.append("    HAVING COUNT(*) > 1")
    sql_updates.append("  ) duplicados;")
    sql_updates.append("  ")
    sql_updates.append("  IF total_events > 0 THEN")
    sql_updates.append("    percentage_assigned := ROUND((events_with_external_id::numeric / total_events::numeric) * 100, 2);")
    sql_updates.append("  ELSE")
    sql_updates.append("    percentage_assigned := 0;")
    sql_updates.append("  END IF;")
    sql_updates.append("  ")
    sql_updates.append("  RAISE NOTICE '📊 Resumen de asignación de external_id:';")
    sql_updates.append("  RAISE NOTICE '   Total de eventos: %', total_events;")
    sql_updates.append("  RAISE NOTICE '   Eventos con external_id asignado: % (% %%)', events_with_external_id, percentage_assigned;")
    sql_updates.append("  IF duplicate_external_ids > 0 THEN")
    sql_updates.append("    RAISE WARNING '⚠️  Se encontraron % external_id duplicados. Revisar manualmente.', duplicate_external_ids;")
    sql_updates.append("  ELSE")
    sql_updates.append("    RAISE NOTICE '✅ No hay external_id duplicados.';")
    sql_updates.append("  END IF;")
    sql_updates.append("END $$;")
    
    # Escribir el archivo SQL
    output_path = 'docs/migrations/031_assign_external_id_from_json.sql'
    with open(output_path, 'w', encoding='utf-8') as f:
        f.write('\n'.join(sql_updates))
    
    print(f"✅ Script SQL generado: {output_path}")
    print(f"   Total de eventos procesados: {len(events)}")
    total_updates = len([e for e in events if e.get('id') and e.get('title') and e.get('date')])
    print(f"   Total de UPDATE statements: {total_updates}")
    print(f"   🔒 Usa subconsulta con LIMIT 1 para evitar duplicados")
    
    return 0

if __name__ == '__main__':
    sys.exit(main())
