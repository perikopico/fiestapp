# Scripts de Población de Base de Datos

## 📍 Poblar Lugares de Barbate

Este script elimina todos los lugares existentes de Barbate y añade una lista predefinida de lugares de interés con sus coordenadas.

### Requisitos

1. Tener el archivo `.env` en la raíz del proyecto con:
   - `SUPABASE_URL`
   - `SUPABASE_ANON_KEY`

2. Tener la ciudad "Barbate" creada en la base de datos

### Uso

```bash
# Desde la raíz del proyecto
dart scripts/populate_barbate_venues.dart
```

### Qué hace el script

1. ✅ Busca la ciudad de Barbate en la base de datos
2. 🗑️ Elimina todos los lugares existentes de Barbate
3. 📝 Inserta los lugares de interés con:
   - Nombre
   - Dirección
   - Coordenadas (lat, lng)
   - Status: `approved` (aprobados directamente)

### Lugares incluidos

- **Restaurantes**: El Campero, El Embarcadero, La Cofradía, El Faro, La Lonja, El Atún, La Bahía
- **Bares y Pubs**: Pub Esencia Café y Copas, Bar Habana, El Puerto, El Chiringuito, La Terraza, El Mirador
- **Lugares turísticos**: Plaza de la Constitución, Paseo Marítimo, Playas, Museo del Atún, Iglesia de San Paulino, Puerto Pesquero

### Notas

- Las coordenadas son aproximadas basadas en la ubicación de Barbate
- Todos los lugares se crean con `status='approved'` para que estén disponibles inmediatamente
- Si un lugar ya existe (por nombre), puede dar error de duplicado

---

**Última actualización**: Diciembre 2024

