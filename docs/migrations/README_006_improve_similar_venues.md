# Migración: Mejorar detección de lugares similares

## Problema
La función `find_similar_venues` marcaba como similares todos los lugares que compartían palabras comunes como "restaurante", "pub", "bar", etc., incluso cuando los nombres reales eran completamente diferentes.

## Solución
Se ha mejorado la función para:

1. **Eliminar palabras comunes**: Antes de comparar, se eliminan palabras como:
   - restaurante, restaurantes
   - pub, pubs
   - bar, bars
   - café, cafe, cafetería
   - taberna, mesón, bodega
   - artículos: el, la, los, las, de, del, y, e

2. **Normalizar textos**: 
   - Convertir a minúsculas
   - Eliminar acentos
   - Eliminar signos de puntuación
   - Normalizar espacios

3. **Comparación inteligente**:
   - Primero compara los nombres normalizados (sin palabras comunes)
   - También compara los nombres originales para detectar typos (ej: "essencia" vs "esencia")
   - Toma el mayor valor de similitud entre ambas comparaciones

## Ejemplos

### Antes (problema):
- "Restaurante El Boquerón" vs "Restaurante El Timón" → Similar (por "Restaurante")
- "Restaurante El Boquerón" vs "Restaurante El Campero" → Similar (por "Restaurante")

### Después (solucionado):
- "Restaurante El Boquerón" vs "Restaurante El Timón" → No similar (comparando "boqueron" vs "timon")
- "pub essencia cafe y copas" vs "pab esencia cafe y copas" → Similar (detecta typo: "essencia" vs "esencia")

## Cómo aplicar

1. Abre Supabase Dashboard
2. Ve a SQL Editor
3. Copia y pega el contenido de `006_improve_similar_venues_function.sql`
4. Ejecuta el script

## Notas
- La función es retrocompatible, no requiere cambios en el código Dart
- Los umbrales de similitud se ajustaron para ser más precisos:
  - Normalizada: >= 0.4 (más estricta porque ignora palabras comunes)
  - Original: >= 0.5 (para detectar typos)

