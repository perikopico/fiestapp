# Actualizar Categorías Finales en Supabase

Este documento explica cómo actualizar las categorías finales de la aplicación en Supabase.

## 📋 Lista de Categorías Finales

La aplicación utiliza **7 categorías principales**:

1. **MÚSICA** (`musica`)
   - Icono: `music_note`
   - Color: `#9C27B0` (Purple)
   - Descripción: Conciertos, festivales, flamenco, sesiones DJ y vida nocturna.

2. **GASTRONOMÍA** (`gastronomia`)
   - Icono: `restaurant`
   - Color: `#FF6F00` (Amber)
   - Descripción: Rutas de tapas, catas de vino, mostos, ventas y jornadas del atún.

3. **DEPORTES** (`deportes`)
   - Icono: `sports_soccer`
   - Color: `#4CAF50` (Green)
   - Descripción: Motor (Jerez), surf/kite (Tarifa), polo, hípica y competiciones.

4. **ARTE Y CULTURA** (`arte-y-cultura`)
   - Icono: `palette`
   - Color: `#2196F3` (Blue)
   - Descripción: Teatro, exposiciones, museos, cine y visitas históricas.

5. **AIRE LIBRE** (`aire-libre`)
   - Icono: `hiking`
   - Color: `#00BCD4` (Cyan/Teal)
   - Descripción: Senderismo, rutas en kayak, playas y naturaleza activa.

6. **TRADICIONES** (`tradiciones`)
   - Icono: `festival`
   - Color: `#E91E63` (Pink/Red)
   - Descripción: Carnaval, Semana Santa, Ferias, Zambombas y Romerías.

7. **MERCADILLOS** (`mercadillos`)
   - Icono: `storefront`
   - Color: `#FF9800` (Orange)
   - Descripción: Artesanía, antigüedades, rastros y moda (no alimentación).

## 🚀 Pasos para Actualizar en Supabase

### Paso 1: Acceder al SQL Editor de Supabase

1. Ve al [Dashboard de Supabase](https://app.supabase.com)
2. Selecciona tu proyecto
3. En el menú lateral, haz clic en **SQL Editor**
4. Haz clic en **New Query**

### Paso 2: Ejecutar la Migración

1. Copia todo el contenido del archivo:
   ```
   docs/migrations/013_update_final_categories.sql
   ```

2. Pega el SQL en el editor de Supabase

3. **IMPORTANTE**: Lee la sección de "Limpieza de categorías antiguas" antes de ejecutar
   - Por defecto, la limpieza está **comentada** (no se ejecutará)
   - Si tienes eventos asociados a categorías antiguas, NO descomentes esa sección
   - El script usa `UPSERT` (INSERT ... ON CONFLICT), por lo que actualizará las categorías existentes o las creará si no existen

4. Haz clic en **Run** (o presiona `Ctrl+Enter` / `Cmd+Enter`)

### Paso 3: Verificar la Ejecución

El script incluye una consulta de verificación al final que mostrará todas las categorías insertadas/actualizadas. Deberías ver:

- ✅ 7 categorías listadas
- ✅ Todos los campos (slug, name, icon, color) completos

**Nota**: La tabla `categories` no incluye una columna `description`. Solo almacena: `id`, `slug`, `name`, `icon`, y `color`.

### Paso 4: Verificar en la Tabla

Ejecuta esta consulta para ver todas las categorías:

```sql
SELECT 
  id,
  slug,
  name,
  icon,
  color,
  created_at
FROM public.categories
ORDER BY 
  CASE slug
    WHEN 'musica' THEN 1
    WHEN 'gastronomia' THEN 2
    WHEN 'deportes' THEN 3
    WHEN 'arte-y-cultura' THEN 4
    WHEN 'aire-libre' THEN 5
    WHEN 'tradiciones' THEN 6
    WHEN 'mercadillos' THEN 7
  END;
```

## ⚠️ Consideraciones Importantes

### Eventos Existentes

Si ya tienes eventos en la base de datos asociados a categorías antiguas (como "tradicion", "motor", "mercados"):

1. **Opción 1 (Recomendada)**: Mantener las categorías antiguas y migrar gradualmente
   - No ejecutes la sección de limpieza
   - Las categorías nuevas se añadirán
   - Migra los eventos manualmente a las nuevas categorías cuando sea necesario

2. **Opción 2**: Migrar eventos a las nuevas categorías primero
   - Actualiza los `category_id` de los eventos antes de eliminar categorías antiguas
   - Ejecuta la limpieza después
   - **CUIDADO**: Esto puede afectar eventos en producción

### Políticas RLS

Las categorías tienen RLS (Row Level Security) habilitado con estas políticas:
- **Lectura pública**: Cualquiera puede leer categorías
- **Escritura admin**: Solo administradores pueden modificar categorías

Si necesitas modificar las categorías después, asegúrate de estar autenticado como administrador.

## 📱 Actualización en la App Flutter

El código Flutter ya ha sido actualizado para:

✅ Reconocer todos los iconos de las nuevas categorías (`icon_mapper.dart`)
✅ Aplicar los colores correctos en todos los widgets (`_getColorForCategory`)
✅ Mapear nombres antiguos a nuevos (compatibilidad retroactiva)

No necesitas hacer cambios adicionales en el código después de ejecutar el SQL.

## 🔄 Rollback (Reversión)

Si necesitas revertir los cambios:

1. Restaura las categorías antiguas desde un backup
2. O ejecuta manualmente los INSERTs de las categorías anteriores

## ✅ Checklist Final

- [ ] Ejecutado el script SQL en Supabase
- [ ] Verificadas las 7 categorías en la tabla
- [ ] Verificados iconos y colores en la app
- [ ] (Opcional) Migrados eventos antiguos a nuevas categorías
- [ ] Probada la app con las nuevas categorías

## 📞 Soporte

Si encuentras algún problema:

1. Verifica los logs en Supabase (Database > Logs)
2. Revisa que las políticas RLS permitan lectura pública
3. Comprueba que los slugs sean exactamente los especificados (case-sensitive)

---

**Fecha de actualización**: 2024
**Versión de migración**: 013
**Autor**: Sistema de migración de categorías
