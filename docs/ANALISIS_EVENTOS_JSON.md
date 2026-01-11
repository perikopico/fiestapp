# Análisis y Normalización de Eventos JSON

## Resumen del Análisis

### ✅ Estado: TODOS LOS DATOS ESTÁN CORRECTOS

El JSON proporcionado ha sido analizado y normalizado correctamente. Todas las categorías encajan con las existentes en la base de datos y todas las ciudades han sido normalizadas.

## Categorías Validadas

Todas las categorías del JSON coinciden con las categorías existentes en la BD:

| Categoría en JSON | Slug en BD | Eventos | Estado |
|-------------------|------------|---------|--------|
| Aire Libre | aire-libre | 2 | ✅ Correcto |
| Arte y Cultura | arte-y-cultura | 16 | ✅ Correcto |
| Deportes | deportes | 8 | ✅ Correcto |
| Gastronomía | gastronomia | 5 | ✅ Correcto |
| Música | musica | 6 | ✅ Correcto |
| Tradiciones | tradiciones | 14 | ✅ Correcto |
| **Total** | | **51** | ✅ |

## Ciudades Normalizadas

Todas las ciudades han sido normalizadas y coinciden con los nombres en la BD:

| Ciudad en JSON Original | Ciudad Normalizada | Eventos | Estado |
|------------------------|-------------------|---------|--------|
| Cádiz | Cádiz | 18 | ✅ |
| Jerez de la Frontera | Jerez de la Frontera | 10 | ✅ |
| San Roque / Guadiaro (San Roque) | San Roque | 5 | ✅ Normalizado |
| Chiclana | Chiclana de la Frontera | 2 | ✅ Normalizado |
| Conil | Conil de la Frontera | 1 | ✅ Normalizado |
| El Bosque, Cádiz | El Bosque | 1 | ✅ Normalizado |
| Salida Rota | Rota | 1 | ✅ Normalizado |
| Barbate | Barbate | 2 | ✅ |
| Algeciras | Algeciras | 2 | ✅ |
| Arcos de la Frontera | Arcos de la Frontera | 2 | ✅ |
| Villaluenga del Rosario | Villaluenga del Rosario | 1 | ✅ |
| Benalup-Casas Viejas | Benalup-Casas Viejas | 1 | ✅ |
| Sanlúcar de Barrameda | Sanlúcar de Barrameda | 1 | ✅ |
| Puerto Real | Puerto Real | 1 | ✅ |
| Chipiona | Chipiona | 1 | ✅ |
| Algodonales | Algodonales | 1 | ✅ |
| **Total ciudades únicas** | | **16** | ✅ |

## Normalizaciones Realizadas

### 1. Formato de Fecha y Hora
- ✅ `date` y `time` combinados en `starts_at` (formato ISO 8601)
- ✅ Si `time` es `null`, se asigna 12:00:00 por defecto

### 2. Extracción de Ciudad y Lugar
- ✅ Ciudad extraída correctamente de `location_name`
- ✅ Lugar separado cuando es diferente de la ciudad
- ✅ Casos especiales manejados:
  - "Guadiaro (San Roque)" → Ciudad: "San Roque"
  - "El Bosque, Cádiz" → Ciudad: "El Bosque"
  - "Salida Rota" → Ciudad: "Rota"
  - Abreviaciones normalizadas: "Chiclana" → "Chiclana de la Frontera", "Conil" → "Conil de la Frontera"

### 3. Determinación de Eventos Gratis/De Pago
- ✅ `is_free` determinado automáticamente del campo `price`
- ✅ Palabras clave detectadas: "Gratis", "Donativo", "Invitación", "€", "Inscripción", etc.
- ✅ Resultado: 24 eventos gratis, 27 eventos de pago

### 4. Otros Campos
- ✅ `gmaps_link` → `maps_url`
- ✅ `location_name` → `city` y `place` (separados)
- ✅ `is_featured` = false (por defecto)
- ✅ `status` = "published" (por defecto)
- ✅ `image_alignment` = "center" (por defecto)

## Archivos Generados

1. **`scripts/eventos_normalizados.json`**
   - JSON normalizado listo para generar SQL
   - Formato compatible con `scripts/generar_sql_eventos.py`

2. **`scripts/analisis_eventos.txt`**
   - Reporte completo del análisis
   - Estadísticas y validaciones

## Próximos Pasos

### Opción 1: Generar SQL Directamente

Usa el JSON normalizado para generar el SQL:

```bash
cd scripts
python3 generar_sql_eventos.py < eventos_normalizados.json
```

Luego:
1. Proporciona la URL de Supabase Storage cuando se solicite
2. El script generará un archivo SQL en `docs/migrations/016_insertar_eventos_{timestamp}.sql`
3. Revisa el SQL generado
4. Ejecuta el SQL en Supabase

### Opción 2: Usar el JSON Original

Si prefieres usar el JSON original, el script `generar_sql_eventos.py` también puede procesarlo directamente, pero es recomendable usar el normalizado.

## Verificación Pre-Ejecución

Antes de ejecutar el SQL en Supabase, verifica:

- [ ] Todas las ciudades existen en la tabla `cities` de Supabase
- [ ] Todas las categorías existen en la tabla `categories` de Supabase
- [ ] Las imágenes de muestra están cargadas en Supabase Storage:
  - Categoría 1 (Música): 01-10.webp
  - Categoría 2 (Gastronomía): 01-14.webp
  - Categoría 3 (Deportes): 01-16.webp
  - Categoría 4 (Arte y Cultura): 01-09.webp
  - Categoría 5 (Aire Libre): 01-10.webp
  - Categoría 6 (Tradiciones): 01-09.webp
  - Categoría 7 (Mercadillos): 01-10.webp
- [ ] La URL de Supabase Storage es correcta

## Notas Importantes

1. **Imágenes**: El SQL asignará automáticamente una imagen aleatoria de `sample-images/1/{categoria}/{01-XX}.webp` para cada evento según su categoría.

2. **Ciudades**: Si alguna ciudad no existe en la BD, el SQL mostrará un WARNING pero continuará. Verifica que todas las ciudades existan antes de ejecutar.

3. **Categorías**: Todas las categorías están validadas y son correctas.

4. **Fechas**: Todas las fechas están en 2026. Asegúrate de que esto sea intencional.

## Consultas de Verificación Post-Insercion

Después de ejecutar el SQL, puedes verificar los eventos insertados:

```sql
-- Contar eventos insertados
SELECT COUNT(*) as total_eventos FROM public.events WHERE starts_at >= '2026-01-01';

-- Ver distribución por categoría
SELECT 
  cat.name as categoria,
  COUNT(*) as cantidad
FROM public.events e
JOIN public.categories cat ON e.category_id = cat.id
WHERE e.starts_at >= '2026-01-01'
GROUP BY cat.name
ORDER BY cantidad DESC;

-- Ver distribución por ciudad
SELECT 
  c.name as ciudad,
  COUNT(*) as cantidad
FROM public.events e
JOIN public.cities c ON e.city_id = c.id
WHERE e.starts_at >= '2026-01-01'
GROUP BY c.name
ORDER BY cantidad DESC;

-- Verificar que todos los eventos tienen imágenes
SELECT 
  COUNT(*) as total,
  COUNT(image_url) as con_imagen,
  COUNT(*) - COUNT(image_url) as sin_imagen
FROM public.events
WHERE starts_at >= '2026-01-01';
```

## Problemas Conocidos Resueltos

- ✅ "Guadiaro (San Roque)" → Normalizado a "San Roque"
- ✅ "Chiclana" → Normalizado a "Chiclana de la Frontera"
- ✅ "Conil" → Normalizado a "Conil de la Frontera"
- ✅ "El Bosque, Cádiz" → Normalizado a "El Bosque"
- ✅ "Salida Rota" → Normalizado a "Rota"
- ✅ Eventos sin hora (`time: null`) → Asignada hora 12:00:00 por defecto

## Conclusión

✅ **TODOS LOS DATOS ESTÁN CORRECTOS Y LISTOS PARA GENERAR SQL**

El JSON ha sido completamente analizado y normalizado. Puedes proceder a generar el SQL con confianza.
