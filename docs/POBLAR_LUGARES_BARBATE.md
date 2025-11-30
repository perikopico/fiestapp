# 📍 Guía: Poblar Lugares de Barbate en la Base de Datos

## 🎯 Objetivo

Eliminar todos los lugares existentes de Barbate y añadir una lista predefinida de lugares de interés con sus coordenadas.

## 📋 Requisitos Previos

1. ✅ Tener el archivo `.env` en la raíz del proyecto con:
   ```env
   SUPABASE_URL=tu_url_de_supabase
   SUPABASE_ANON_KEY=tu_clave_anon
   ```

2. ✅ Tener la ciudad "Barbate" creada en la base de datos (tabla `cities`)

3. ✅ Tener las dependencias instaladas:
   ```bash
   flutter pub get
   ```

## 🚀 Ejecución del Script

### Opción 1: Ejecutar directamente con Dart

```bash
# Desde la raíz del proyecto
dart scripts/populate_barbate_venues.dart
```

### Opción 2: Si hay problemas con las dependencias

Puedes ejecutarlo desde el contexto de Flutter:

```bash
flutter run -d linux scripts/populate_barbate_venues.dart
```

O mejor aún, crear un script helper:

```bash
# Crear script ejecutable
chmod +x scripts/run_populate.sh
./scripts/run_populate.sh
```

## 📝 Qué hace el script

1. **Busca la ciudad de Barbate** en la base de datos
2. **Elimina todos los lugares existentes** de Barbate (para evitar duplicados)
3. **Inserta los lugares de interés** con:
   - Nombre del lugar
   - Dirección completa
   - Coordenadas GPS (lat, lng)
   - Status: `approved` (aprobados directamente)

## 📍 Lugares incluidos (20 lugares)

### Restaurantes (7)
- El Campero
- Restaurante El Embarcadero
- Restaurante La Cofradía
- Restaurante El Faro
- Restaurante La Lonja
- Restaurante El Atún
- Restaurante La Bahía

### Bares y Pubs (6)
- Pub Esencia Café y Copas
- Bar Habana
- Bar El Puerto
- Bar El Chiringuito
- Pub La Terraza
- Bar El Mirador

### Lugares Turísticos y Culturales (7)
- Plaza de la Constitución
- Paseo Marítimo de Barbate
- Playa de la Hierbabuena
- Playa del Carmen
- Museo del Atún
- Iglesia de San Paulino
- Puerto Pesquero de Barbate
- Playa de Caños de Meca

## ⚠️ Notas Importantes

1. **Coordenadas**: Las coordenadas son aproximadas basadas en la ubicación de Barbate. Si necesitas coordenadas más precisas, puedes:
   - Buscarlas en Google Maps
   - Usar la API de Geocoding de Google
   - Actualizarlas manualmente después

2. **Duplicados**: Si un lugar ya existe (mismo nombre en la misma ciudad), el script mostrará un error pero continuará con los demás.

3. **Status**: Todos los lugares se crean con `status='approved'` para que estén disponibles inmediatamente en la app.

4. **Eliminación**: El script elimina TODOS los lugares de Barbate antes de insertar los nuevos. Si tienes lugares importantes que quieres conservar, haz un backup primero.

## 🔍 Verificar Resultados

Después de ejecutar el script, puedes verificar en Supabase:

```sql
SELECT name, address, lat, lng, status 
FROM venues 
WHERE city_id = (SELECT id FROM cities WHERE name ILIKE '%Barbate%')
ORDER BY name;
```

O desde la app:
- Abre "Crear evento"
- Selecciona ciudad "Barbate"
- Escribe en el campo "Lugar"
- Deberías ver los lugares en las sugerencias

## 🐛 Solución de Problemas

### Error: "No se encontró la ciudad de Barbate"
- Verifica que la ciudad existe en la tabla `cities`
- El nombre debe contener "Barbate" (case insensitive)

### Error: "SUPABASE_URL o SUPABASE_ANON_KEY no encontrados"
- Verifica que el archivo `.env` existe en la raíz
- Verifica que tiene las variables correctas

### Error: "Error al eliminar lugares"
- Puede ser normal si no hay lugares existentes
- El script continuará con la inserción

### Error de compilación
- Asegúrate de tener todas las dependencias: `flutter pub get`
- Verifica que tienes Dart SDK instalado

## 📊 Ejemplo de Salida

```
🚀 Iniciando script de población de lugares de Barbate...

✅ Archivo .env cargado
✅ Supabase inicializado

📍 Buscando ID de la ciudad de Barbate...
✅ Ciudad encontrada: Barbate (ID: 1)

🗑️  Eliminando todos los lugares existentes...
✅ Lugares eliminados correctamente

📝 Insertando 20 lugares de interés...

✅ El Campero
✅ Pub Esencia Café y Copas
✅ Restaurante El Embarcadero
...

📊 Resumen:
   ✅ Insertados: 20
   ❌ Errores: 0
   📍 Total: 20

✅ Script completado exitosamente!
```

---

**Última actualización**: Diciembre 2024

