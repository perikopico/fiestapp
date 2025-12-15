# Instrucciones para Revisar y Corregir Coordenadas

## Paso 1: Eliminar todos los lugares actuales

Ejecuta este script en Supabase SQL Editor:
```sql
-- Eliminar todos los lugares de Barbate
DELETE FROM venues 
WHERE city_id = 1;
```

O usa el archivo: `scripts/eliminar_todos_lugares_barbate.sql`

---

## Paso 2: Revisar coordenadas

1. Abre el archivo: `docs/LUGARES_BARBATE_PARA_REVISAR.md`
2. Para cada lugar:
   - Busca la dirección en Google Maps
   - Haz clic derecho en el lugar exacto
   - Selecciona "¿Qué hay aquí?"
   - Copia las coordenadas (Lat, Lng)
   - Actualiza las columnas "Lat Corregida" y "Lng Corregida"
   - Si el lugar no existe o no quieres incluirlo, marca "❌" en "Incluir"

---

## Paso 3: Obtener coordenadas en Google Maps

### Método 1: Desde el navegador
1. Abre Google Maps en el navegador
2. Busca el lugar (ej: "Bar Habana, Barbate")
3. Haz clic derecho en el lugar exacto del mapa
4. Selecciona "¿Qué hay aquí?"
5. Las coordenadas aparecerán en la parte inferior (formato: 36.XXXX, -5.XXXX)

### Método 2: Desde la app móvil
1. Abre Google Maps en el móvil
2. Busca el lugar
3. Mantén presionado en el lugar exacto
4. Las coordenadas aparecerán en la parte inferior

### Método 3: Desde la URL
1. Busca el lugar en Google Maps
2. Haz clic en el lugar
3. Copia la URL
4. Las coordenadas están en la URL: `@36.XXXX,-5.XXXX`

---

## Paso 4: Formato de coordenadas

- **Latitud (Lat)**: Entre 36.1800 y 36.2100 (aproximadamente)
- **Longitud (Lng)**: Entre -5.9000 y -5.9300 (aproximadamente)
- **Formato**: Decimal con 4-6 decimales (ej: 36.1932, -5.9222)

---

## Paso 5: Verificar coordenadas

Después de corregir, puedes verificar que las coordenadas son correctas:
1. Abre Google Maps
2. Pega las coordenadas en la búsqueda: `36.1932, -5.9222`
3. Verifica que el marcador esté en el lugar correcto

---

## Paso 6: Después de revisar

Una vez que hayas revisado y corregido todas las coordenadas en el documento:
1. Avísame cuando termines
2. Yo crearé el script SQL final con las coordenadas corregidas
3. Ejecutarás el script en Supabase SQL Editor
4. Los lugares se insertarán con las coordenadas correctas

---

## Lugares prioritarios para revisar

Estos lugares son los más importantes y deben tener coordenadas exactas:

1. **Pub Esencia Café y Copas** - Paseo marítimo
2. **Bar Habana** - Calle Trafalgar
3. **Bar El Puerto** - Calle Puerto
4. **Discoteca La Marina** - Paseo marítimo
5. **Paseo Marítimo de Barbate** - Zona principal

---

## Notas importantes

- ⚠️ Las coordenadas actuales son **aproximadas** y pueden estar incorrectas
- ✅ Usa siempre Google Maps para obtener coordenadas reales
- ✅ Verifica que el marcador esté en el lugar correcto antes de copiar
- ✅ Si un lugar no existe, no lo incluyas (marca "❌" en "Incluir")

