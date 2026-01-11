#!/usr/bin/env python3
"""
Script para analizar y normalizar eventos JSON
Valida categorías, ciudades y formatea datos para el script de generación SQL

Uso:
    python3 analizar_y_normalizar_json_eventos.py < eventos_raw.json > eventos_normalizados.json
"""

import json
import sys
import re
from datetime import datetime
from typing import Dict, List, Any, Optional, Tuple

# Categorías válidas en la BD (nombre -> slug)
CATEGORIAS_VALIDAS = {
    'Música': 'musica',
    'Gastronomía': 'gastronomia',
    'Deportes': 'deportes',
    'Arte y Cultura': 'arte-y-cultura',
    'Aire Libre': 'aire-libre',
    'Tradiciones': 'tradiciones',
    'Mercadillos': 'mercadillos',
}

# Mapeo de nombres de ciudades del JSON a nombres en BD
# Si no está en el mapeo, se intenta usar el nombre tal cual
CIUDADES_BD = {
    # Nombres exactos en BD (extraídos de la migración)
    'Cádiz': 'Cádiz',
    'Jerez de la Frontera': 'Jerez de la Frontera',
    'San Fernando': 'San Fernando',
    'El Puerto de Santa María': 'El Puerto de Santa María',
    'Chiclana de la Frontera': 'Chiclana de la Frontera',
    'Puerto Real': 'Puerto Real',
    'Sanlúcar de Barrameda': 'Sanlúcar de Barrameda',
    'Chipiona': 'Chipiona',
    'Rota': 'Rota',
    'Trebujena': 'Trebujena',
    'Arcos de la Frontera': 'Arcos de la Frontera',
    'Ubrique': 'Ubrique',
    'Olvera': 'Olvera',
    'Villamartín': 'Villamartín',
    'Algeciras': 'Algeciras',
    'La Línea de la Concepción': 'La Línea de la Concepción',
    'San Roque': 'San Roque',
    'Los Barrios': 'Los Barrios',
    'Tarifa': 'Tarifa',
    'Jimena de la Frontera': 'Jimena de la Frontera',
    'Castellar de la Frontera': 'Castellar de la Frontera',
    'San Martín del Tesorillo': 'San Martín del Tesorillo',
    'Villaluenga del Rosario': 'Villaluenga del Rosario',
    'Benalup-Casas Viejas': 'Benalup-Casas Viejas',
    'El Bosque': 'El Bosque',
    'Conil de la Frontera': 'Conil de la Frontera',
    'Conil': 'Conil de la Frontera',  # Abreviación común
    'Chiclana': 'Chiclana de la Frontera',  # Abreviación común
    'Barbate': 'Barbate',
    'Zahara de los Atunes': 'Zahara de los Atunes',
    'Vejer de la Frontera': 'Vejer de la Frontera',
    'Medina Sidonia': 'Medina Sidonia',
    'Alcalá de los Gazules': 'Alcalá de los Gazules',
    'Paterna de Rivera': 'Paterna de Rivera',
    'Algodonales': 'Algodonales',
    'Bornos': 'Bornos',
    'Prado del Rey': 'Prado del Rey',
    'Puerto Serrano': 'Puerto Serrano',
    'Alcalá del Valle': 'Alcalá del Valle',
    'San José del Valle': 'San José del Valle',
    'Espera': 'Espera',
    'Grazalema': 'Grazalema',
    'Setenil de las Bodegas': 'Setenil de las Bodegas',
    'Benaocaz': 'Benaocaz',
    'El Gastor': 'El Gastor',
    'Zahara de la Sierra': 'Zahara de la Sierra',
    'Algar': 'Algar',
    'Torre Alháquime': 'Torre Alháquime',
}

# Patrones para extraer ciudad del location_name
CIUDAD_PATTERNS = [
    # Formato: "Lugar, Ciudad"
    r',\s*([^,]+)$',
    # Formato: "Lugar en Ciudad"
    r'\s+en\s+([^,]+)$',
    # Formato: "Lugar (Ciudad)"
    r'\s*\(([^)]+)\)$',
]


def extraer_ciudad_de_location(location_name: str) -> Tuple[str, str]:
    """
    Extrae la ciudad y el lugar del location_name
    
    Returns:
        (ciudad, lugar) - ciudad normalizada y lugar
    """
    location = location_name.strip()
    
    # Casos especiales conocidos
    if location == "Provincia de Cádiz":
        return ("Cádiz", "Provincia de Cádiz")
    
    if location == "Benalup-Casas Viejas":
        return ("Benalup-Casas Viejas", "Benalup-Casas Viejas")
    
    # Normalizar abreviaciones comunes antes de procesar
    location_normalizado = location
    location_normalizado = re.sub(r'\bChiclana\b(?!\s+de\s+la\s+Frontera)', 'Chiclana de la Frontera', location_normalizado, flags=re.IGNORECASE)
    location_normalizado = re.sub(r'\bConil\b(?!\s+de\s+la\s+Frontera)', 'Conil de la Frontera', location_normalizado, flags=re.IGNORECASE)
    
    # Casos especiales adicionales ANTES de buscar por patrones
    # "Guadiaro (San Roque)" -> usar "San Roque" como ciudad
    if 'Guadiaro' in location_normalizado and 'San Roque' in location_normalizado:
        # Extraer el lugar antes de Guadiaro
        lugar = location_normalizado.split('Guadiaro')[0].strip().rstrip(',').strip()
        return ('San Roque', lugar or 'Guadiaro')
    
    # "El Bosque, Cádiz" -> "El Bosque" es la ciudad, no Cádiz
    if 'El Bosque' in location_normalizado and ', Cádiz' in location_normalizado:
        lugar = location_normalizado.replace(', Cádiz', '').strip()
        return ('El Bosque', lugar)
    
    # Casos con "Salida" u otras palabras clave
    if "Salida" in location_normalizado:
        # Extraer ciudad después de "Salida"
        match = re.search(r'Salida\s+([^,\(]+)', location_normalizado, re.IGNORECASE)
        if match:
            ciudad_candidata = match.group(1).strip()
            # Normalizar abreviaciones comunes
            if ciudad_candidata == "Rota":
                return ("Rota", location_normalizado)
        
        # Si contiene paréntesis con ciudad, usar esa
        match = re.search(r'\([^)]*(Rota|Cádiz|Jerez)[^)]*\)', location_normalizado, re.IGNORECASE)
        if match:
            ciudad_en_parentesis = match.group(1).strip()
            if ciudad_en_parentesis.lower() == "rota":
                return ("Rota", location_normalizado)
            elif ciudad_en_parentesis.lower() == "cádiz" or ciudad_en_parentesis.lower() == "cadiz":
                return ("Cádiz", location_normalizado)
    
    # Buscar ciudad por patrones
    for pattern in CIUDAD_PATTERNS:
        match = re.search(pattern, location_normalizado, re.IGNORECASE)
        if match:
            ciudad = match.group(1).strip()
            lugar = location_normalizado[:match.start()].strip()
            # Normalizar ciudad si es abreviación
            if ciudad == "Chiclana" or ciudad == "Chiclana de la Frontera":
                ciudad = "Chiclana de la Frontera"
            elif ciudad == "Conil" or ciudad == "Conil de la Frontera":
                ciudad = "Conil de la Frontera"
            return (ciudad, lugar or ciudad)
    
    # Buscar si alguna ciudad de la BD está en el location_name
    for ciudad_bd in CIUDADES_BD.keys():
        # Buscar ciudad completa al final
        if location_normalizado.endswith(ciudad_bd):
            lugar = location_normalizado[:-len(ciudad_bd)].rstrip(', ').strip()
            return (ciudad_bd, lugar or ciudad_bd)
        
        # Buscar ciudad en cualquier parte (para casos como "Guadiaro (San Roque)")
        if ciudad_bd in location_normalizado:
            # Si contiene "(", probablemente la ciudad está entre paréntesis
            if '(' in location_normalizado and ciudad_bd in location_normalizado.split('(')[1]:
                lugar = location_normalizado.split('(')[0].strip()
                return (ciudad_bd, lugar or ciudad_bd)
    
    # Si no se encuentra, asumir que todo es lugar y usar la primera palabra como ciudad aproximada
    palabras = location.split(',')
    if len(palabras) > 1:
        ciudad_candidata = palabras[-1].strip()
        lugar = ','.join(palabras[:-1]).strip()
        return (ciudad_candidata, lugar or ciudad_candidata)
    
    # Último recurso: devolver todo como lugar y ciudad
    return (location, location)


def normalizar_categoria(categoria: str) -> Optional[str]:
    """Normaliza el nombre de categoría al slug correcto"""
    categoria_clean = categoria.strip()
    
    # Búsqueda exacta
    if categoria_clean in CATEGORIAS_VALIDAS:
        return CATEGORIAS_VALIDAS[categoria_clean]
    
    # Búsqueda case-insensitive
    for nombre, slug in CATEGORIAS_VALIDAS.items():
        if categoria_clean.lower() == nombre.lower():
            return slug
    
    return None


def determinar_is_free(price: str) -> bool:
    """Determina si el evento es gratis basándose en el campo price"""
    if not price:
        return True  # Por defecto, asumir gratis si no hay precio
    
    price_lower = price.lower()
    
    # PRIMERO: Comprobar indicadores claros de GRATIS (alta prioridad)
    # Si contiene claramente "gratis", "gratuito", "libre acceso", "entrada libre"
    if 'gratis' in price_lower or 'gratuito' in price_lower or 'libre acceso' in price_lower or 'entrada libre' in price_lower or 'hasta completar aforo' in price_lower:
        return True
    
    # Si dice "invitación" o "entrada gratuita", es gratis
    if 'invitación' in price_lower or 'invitacion' in price_lower or 'entrada gratuita' in price_lower:
        return True
    
    # SEGUNDO: Comprobar indicadores claros de PAGO (alta prioridad)
    # Si contiene "€" o "euros" (excepto si dice "Gratis" explícitamente arriba)
    if '€' in price or 'euros' in price_lower:
        return False
    
    # Si contiene "pago" explícito (sin "donativo" antes)
    if 'pago' in price_lower and 'donativo' not in price_lower:
        return False
    
    # Si contiene "precio", "inscripción", "dorsal", "entrada" con número/precio
    if 'precio' in price_lower or 'inscripción' in price_lower or 'dorsal' in price_lower or 'inscripcion' in price_lower:
        return False
    
    # Si contiene "entrada" con indicador de precio (número, ~, "desde")
    if 'entrada' in price_lower:
        if any(char.isdigit() for char in price) or '~' in price or 'desde' in price_lower:
            return False
    
    # TERCERO: Casos especiales
    # "Donativo/Entrada ~8€" o similar → de pago (tiene precio)
    if 'donativo' in price_lower:
        if 'entrada' in price_lower and ('€' in price or '~' in price or any(char.isdigit() for char in price)):
            return False
        # "Donativo" solo sin precio → gratis
        if '€' not in price and not any(char.isdigit() for char in price) and '~' not in price:
            return True
    
    # Por defecto, si no hay indicación clara, asumir gratis
    return True


def combinar_fecha_hora(date: str, time: Optional[str]) -> str:
    """Combina date y time en formato ISO 8601 para starts_at"""
    if not date:
        raise ValueError("La fecha es requerida")
    
    if time:
        datetime_str = f"{date} {time}"
    else:
        # Si no hay hora, usar mediodía por defecto (12:00:00)
        datetime_str = f"{date} 12:00:00"
    
    # Intentar parsear y formatear
    try:
        dt = datetime.strptime(datetime_str, "%Y-%m-%d %H:%M:%S")
        # Retornar en formato ISO 8601 con timezone UTC
        return dt.strftime("%Y-%m-%dT%H:%M:%SZ")
    except ValueError as e:
        raise ValueError(f"Error al parsear fecha/hora '{datetime_str}': {e}")


def normalizar_evento(evento_raw: Dict[str, Any]) -> Dict[str, Any]:
    """Normaliza un evento del formato raw al formato esperado"""
    errores = []
    advertencias = []
    
    # Validar categoría
    categoria_raw = evento_raw.get('category', '').strip()
    categoria_slug = normalizar_categoria(categoria_raw)
    if not categoria_slug:
        errores.append(f"Categoría '{categoria_raw}' no reconocida")
        categoria_slug = 'arte-y-cultura'  # Por defecto
    
    # Extraer ciudad y lugar del location_name
    location_name = evento_raw.get('location_name', '').strip()
    if not location_name:
        errores.append("location_name es requerido")
        location_name = "Sin especificar"
    
    ciudad, lugar = extraer_ciudad_de_location(location_name)
    
    # Validar ciudad (advertencia si no está en el mapeo)
    if ciudad not in CIUDADES_BD.values():
        advertencias.append(f"Ciudad '{ciudad}' no está en el mapeo de BD - se usará tal cual")
    
    # Combinar fecha y hora
    date = evento_raw.get('date', '').strip()
    time = evento_raw.get('time')
    if time:
        time = time.strip()
    
    try:
        starts_at = combinar_fecha_hora(date, time)
    except ValueError as e:
        errores.append(str(e))
        starts_at = None
    
    # Determinar si es gratis
    price = evento_raw.get('price', '').strip()
    is_free = determinar_is_free(price)
    
    # Construir evento normalizado
    evento_normalizado = {
        'title': evento_raw.get('title', '').strip(),
        'city': ciudad,
        'category': categoria_raw,  # Mantener nombre original para el script SQL
        'place': lugar if lugar != ciudad else None,
        'starts_at': starts_at,
        'is_free': is_free,
        'is_featured': False,  # Por defecto no destacado
        'description': evento_raw.get('description', '').strip() or None,
        'maps_url': evento_raw.get('gmaps_link', '').strip() or None,
        'status': 'published',
        'image_alignment': 'center',
    }
    
    # Agregar metadatos de validación
    if errores or advertencias:
        evento_normalizado['_validation'] = {
            'errors': errores,
            'warnings': advertencias,
            'original_location': location_name,
        }
    
    return evento_normalizado


def analizar_json(eventos_raw: List[Dict[str, Any]]) -> Tuple[List[Dict[str, Any]], Dict[str, Any]]:
    """Analiza y normaliza una lista de eventos"""
    eventos_normalizados = []
    estadisticas = {
        'total': len(eventos_raw),
        'categorias': {},
        'ciudades': {},
        'errores': [],
        'advertencias': [],
    }
    
    for i, evento_raw in enumerate(eventos_raw, 1):
        evento_normalizado = normalizar_evento(evento_raw)
        
        # Estadísticas de categorías
        categoria = evento_normalizado['category']
        estadisticas['categorias'][categoria] = estadisticas['categorias'].get(categoria, 0) + 1
        
        # Estadísticas de ciudades
        ciudad = evento_normalizado['city']
        estadisticas['ciudades'][ciudad] = estadisticas['ciudades'].get(ciudad, 0) + 1
        
        # Recopilar errores y advertencias
        if '_validation' in evento_normalizado:
            validation = evento_normalizado['_validation']
            if validation['errors']:
                estadisticas['errores'].append({
                    'evento': i,
                    'titulo': evento_normalizado['title'],
                    'errores': validation['errors'],
                })
            if validation['warnings']:
                estadisticas['advertencias'].append({
                    'evento': i,
                    'titulo': evento_normalizado['title'],
                    'advertencias': validation['warnings'],
                })
        
        eventos_normalizados.append(evento_normalizado)
    
    return eventos_normalizados, estadisticas


if __name__ == "__main__":
    print("=" * 80, file=sys.stderr)
    print("ANALIZADOR Y NORMALIZADOR DE EVENTOS JSON", file=sys.stderr)
    print("=" * 80, file=sys.stderr)
    print("", file=sys.stderr)
    
    # Leer JSON de entrada
    try:
        json_text = sys.stdin.read()
        eventos_raw = json.loads(json_text)
        
        if not isinstance(eventos_raw, list):
            print("Error: El JSON debe ser un array de eventos", file=sys.stderr)
            sys.exit(1)
        
        print(f"✅ JSON parseado correctamente: {len(eventos_raw)} eventos encontrados", file=sys.stderr)
        print("", file=sys.stderr)
        
        # Analizar y normalizar
        eventos_normalizados, estadisticas = analizar_json(eventos_raw)
        
        # Mostrar estadísticas
        print("=" * 80, file=sys.stderr)
        print("ESTADÍSTICAS", file=sys.stderr)
        print("=" * 80, file=sys.stderr)
        print(f"Total de eventos: {estadisticas['total']}", file=sys.stderr)
        print("", file=sys.stderr)
        
        print("Categorías encontradas:", file=sys.stderr)
        for categoria, count in sorted(estadisticas['categorias'].items()):
            slug = normalizar_categoria(categoria)
            status = "✅" if slug else "❌ NO RECONOCIDA"
            print(f"  {status} {categoria} ({slug or 'N/A'}): {count} eventos", file=sys.stderr)
        print("", file=sys.stderr)
        
        print(f"Ciudades encontradas ({len(estadisticas['ciudades'])}):", file=sys.stderr)
        for ciudad, count in sorted(estadisticas['ciudades'].items(), key=lambda x: -x[1]):
            status = "✅" if ciudad in CIUDADES_BD.values() else "⚠️  NO EN MAPEO"
            print(f"  {status} {ciudad}: {count} eventos", file=sys.stderr)
        print("", file=sys.stderr)
        
        # Mostrar errores y advertencias
        if estadisticas['errores']:
            print("❌ ERRORES ENCONTRADOS:", file=sys.stderr)
            for error_info in estadisticas['errores']:
                print(f"  Evento #{error_info['evento']}: {error_info['titulo']}", file=sys.stderr)
                for error in error_info['errores']:
                    print(f"    - {error}", file=sys.stderr)
            print("", file=sys.stderr)
        
        if estadisticas['advertencias']:
            print("⚠️  ADVERTENCIAS:", file=sys.stderr)
            for warn_info in estadisticas['advertencias']:
                print(f"  Evento #{warn_info['evento']}: {warn_info['titulo']}", file=sys.stderr)
                for warning in warn_info['advertencias']:
                    print(f"    - {warning}", file=sys.stderr)
            print("", file=sys.stderr)
        
        # Validar que todas las categorías son reconocidas
        categorias_no_reconocidas = [cat for cat in estadisticas['categorias'].keys() 
                                      if not normalizar_categoria(cat)]
        if categorias_no_reconocidas:
            print(f"❌ ERROR: Categorías no reconocidas: {', '.join(categorias_no_reconocidas)}", file=sys.stderr)
            print("   Categorías válidas:", file=sys.stderr)
            for cat in CATEGORIAS_VALIDAS.keys():
                print(f"     - {cat}", file=sys.stderr)
            print("", file=sys.stderr)
            sys.exit(1)
        
        # Mostrar resumen de is_free
        eventos_gratis = sum(1 for e in eventos_normalizados if e.get('is_free'))
        eventos_pago = len(eventos_normalizados) - eventos_gratis
        print(f"Eventos gratis: {eventos_gratis}", file=sys.stderr)
        print(f"Eventos de pago: {eventos_pago}", file=sys.stderr)
        print("", file=sys.stderr)
        
        # Guardar JSON normalizado
        # Eliminar metadatos de validación antes de guardar
        eventos_limpios = []
        for evento in eventos_normalizados:
            evento_limpio = {k: v for k, v in evento.items() if not k.startswith('_')}
            eventos_limpios.append(evento_limpio)
        
        print("✅ Eventos normalizados correctamente", file=sys.stderr)
        print("", file=sys.stderr)
        print("=" * 80, file=sys.stderr)
        
        # Escribir JSON normalizado a stdout
        json.dump(eventos_limpios, sys.stdout, indent=2, ensure_ascii=False)
        
    except json.JSONDecodeError as e:
        print(f"❌ Error al parsear JSON: {e}", file=sys.stderr)
        sys.exit(1)
    except Exception as e:
        print(f"❌ Error: {e}", file=sys.stderr)
        import traceback
        traceback.print_exc(file=sys.stderr)
        sys.exit(1)
