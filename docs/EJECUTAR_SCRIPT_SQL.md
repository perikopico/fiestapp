# 📝 Cómo Ejecutar el Script SQL en Supabase

## 🎯 Objetivo

Eliminar todos los lugares existentes de Barbate y añadir 20 lugares de interés predefinidos con coordenadas.

## 📋 Pasos

### Paso 1: Obtener el ID de Barbate

1. Ve a tu proyecto en [Supabase](https://supabase.com)
2. Abre el **SQL Editor**
3. Ejecuta esta consulta:

```sql
SELECT id, name FROM cities WHERE name ILIKE '%Barbate%';
```

4. **Anota el ID** que aparece (por ejemplo: `1`, `2`, etc.)

### Paso 2: Preparar el Script

1. Abre el archivo `scripts/populate_barbate_venues.sql`
2. Reemplaza todas las ocurrencias de `{CITY_ID}` con el ID que obtuviste
   - Por ejemplo, si el ID es `1`, reemplaza `{CITY_ID}` por `1`

### Paso 3: Ejecutar el Script

1. En Supabase, ve al **SQL Editor**
2. Pega el script completo (ya con el ID reemplazado)
3. Haz clic en **Run** o presiona `Ctrl+Enter`

### Paso 4: Verificar

El script mostrará al final:
```
total_lugares | aprobados
--------------+----------
           61 |       61
```

## ⚠️ Importante

- **El script elimina TODOS los lugares de Barbate** antes de insertar los nuevos
- Si tienes lugares importantes que quieres conservar, haz un backup primero
- Todos los lugares se crean con `status='approved'` para que estén disponibles inmediatamente

## 📍 Lugares que se insertarán (61 lugares)

### Recintos y Espacios para Eventos (6)
- Recinto Ferial de Barbate
- Polideportivo Municipal
- Pabellón Deportivo
- Centro Cultural de Barbate
- Auditorio Municipal
- Sala de Exposiciones

### Plazas y Espacios Públicos (5)
- Plaza de la Constitución
- Plaza del Ayuntamiento
- Plaza de España
- Plaza de la Iglesia
- Plaza del Mercado

### Paseo Marítimo (5)
- Paseo Marítimo de Barbate
- Paseo Marítimo - Zona Central
- Paseo Marítimo - Zona Este
- Paseo Marítimo - Zona Oeste
- Mirador del Paseo Marítimo

### Playas (7)
- Playa de la Hierbabuena
- Playa del Carmen
- Playa de Barbate
- Playa de Caños de Meca
- Playa de Zahora
- Playa de Los Caños
- Playa de Mangueta

### Puerto y Zona Portuaria (4)
- Puerto Pesquero de Barbate
- Muelle del Puerto
- Lonja del Puerto
- Zona Portuaria

### Bares y Lugares de Copas (21)
- Pub Esencia Café y Copas
- Bar Habana
- Bar El Puerto
- Bar El Chiringuito
- Pub La Terraza
- Bar El Mirador
- Bar La Playa
- Pub El Faro
- Bar La Bahía
- Discoteca La Marina
- Pub El Embarcadero
- Bar El Atún
- Pub La Cofradía
- Bar El Marisquero
- Pub La Lonja
- Bar El Pescador
- Pub El Trafalgar
- Bar La Caleta
- Pub El Puerto Viejo
- Bar La Ribera
- Cafetería El Azul

### Chiringuitos y Terrazas Playeras (5)
- Chiringuito Playa del Carmen
- Chiringuito Playa de la Hierbabuena
- Chiringuito Caños de Meca
- Chiringuito Playa de Zahora
- Terraza Playa de Barbate

### Lugares Culturales y de Interés (8)
- Museo del Atún
- Centro de Interpretación del Atún de Almadraba
- Iglesia de San Paulino
- Torre del Tajo
- Faro de Trafalgar
- Parque Natural de la Breña
- Ermita de San Ambrosio
- Mercado de Abastos

## 🔍 Verificar Resultados

Después de ejecutar, puedes verificar con:

```sql
SELECT name, address, lat, lng, status 
FROM venues 
WHERE city_id = TU_CITY_ID
ORDER BY name;
```

---

**Última actualización**: Diciembre 2024

