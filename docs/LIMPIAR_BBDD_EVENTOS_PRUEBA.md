# Limpiar Base de Datos de Eventos de Prueba

Esta guía te ayudará a limpiar todos los eventos de prueba y sus imágenes asociadas de Supabase para empezar con eventos reales.

## ⚠️ ADVERTENCIA IMPORTANTE

**Esto eliminará TODOS los eventos de la base de datos de forma permanente.** Asegúrate de:

1. ✅ Hacer un backup antes de ejecutar (recomendado)
2. ✅ Verificar que realmente quieres eliminar todos los eventos
3. ✅ Tener acceso de administrador en Supabase

## 📋 Pasos para Limpiar la Base de Datos

### Método Recomendado: Usar el Script SQL Completo

Hemos creado un script SQL completo que incluye verificación, limpieza y validación. **Usa este método:**

1. Ve a **Supabase Dashboard → SQL Editor → New Query**
2. Copia y pega el contenido completo del archivo:
   ```
   docs/migrations/014_limpiar_eventos_prueba.sql
   ```
3. El script tiene 4 secciones:
   - **Sección 1 (VERIFICACIÓN)**: Ejecuta primero para ver qué se va a eliminar
   - **Sección 2 (LIMPIEZA)**: Ejecuta después de revisar la verificación
   - **Sección 3 (VERIFICACIÓN FINAL)**: Verifica que todo se eliminó correctamente
   - **Sección 4 y 5**: Notas y opciones de restore

### Método Manual: Pasos Individuales

Si prefieres hacerlo manualmente paso a paso:

#### Paso 1: Verificar Eventos Existentes

Antes de eliminar, revisa qué eventos tienes actualmente:

```sql
-- Ver todos los eventos con información básica
SELECT 
  id,
  title,
  place,
  starts_at,
  created_at,
  image_url
FROM public.events
ORDER BY created_at DESC;
```

#### Paso 2: Hacer Backup (Opcional pero Recomendado)

Si quieres hacer un backup antes de eliminar:

```sql
-- Crear tabla de backup temporal
CREATE TABLE IF NOT EXISTS events_backup AS
SELECT * FROM public.events;

-- Verificar que el backup se creó correctamente
SELECT COUNT(*) as eventos_en_backup FROM events_backup;
```

#### Paso 3: Obtener URLs de Imágenes Antes de Eliminar

**IMPORTANTE**: Guarda las URLs de las imágenes antes de eliminar los eventos para poder limpiar el Storage después:

```sql
-- Obtener todas las URLs de imágenes de eventos
SELECT 
  id,
  title,
  image_url
FROM public.events
WHERE image_url IS NOT NULL 
  AND image_url != ''
  AND image_url LIKE '%event-images%';
```

Copia los resultados de esta consulta, las necesitarás para limpiar el Storage.

#### Paso 4: Eliminar Eventos y Relaciones

El siguiente script eliminará:
- ✅ Todos los favoritos asociados a eventos (relación en cascada)
- ✅ Todos los eventos

```sql
-- ⚠️ ESTO ELIMINARÁ TODOS LOS EVENTOS DE FORMA PERMANENTE
BEGIN;

-- 1. Eliminar todos los favoritos de eventos (si existen)
DELETE FROM public.user_favorites;

-- 2. Eliminar todos los eventos
DELETE FROM public.events;

COMMIT;

-- Verificar que se eliminaron todos
SELECT COUNT(*) as eventos_restantes FROM public.events;
-- Debe devolver 0
```

### Paso 5: Limpiar Imágenes del Storage (IMPORTANTE)

**⚠️ IMPORTANTE**: Las imágenes NO se eliminan automáticamente al ejecutar el script SQL. Debes eliminarlas manualmente desde Supabase Storage.

#### Cómo Eliminar Imágenes del Storage

Las imágenes están en el bucket **`event-images`** de Supabase Storage. Sigue estos pasos:

**Método: Interfaz Web de Supabase (Recomendado)**

1. Ve al [Dashboard de Supabase](https://app.supabase.com)
2. Selecciona tu proyecto
3. En el menú lateral, haz clic en **Storage**
4. Selecciona el bucket **`event-images`**
5. Verás todas las imágenes listadas con sus nombres (ej: `event_1234567890_imagen.jpg`)
6. **Para eliminar todas las imágenes:**
   - Haz clic en el checkbox en la parte superior (selecciona todas)
   - O selecciona las imágenes individualmente que quieras eliminar
   - Haz clic en el botón **Delete** (Eliminar) o en el icono de papelera
   - Confirma la eliminación cuando se solicite

**Método: Usando la CLI de Supabase (Para usuarios avanzados)**

Si tienes la CLI de Supabase instalada y configurada:

```bash
# Listar todas las imágenes
supabase storage ls event-images

# Eliminar todas las imágenes (⚠️ CUIDADO)
# Necesitarías hacer un script para eliminar cada una individualmente
```

**Nota**: Si tienes muchas imágenes (>100), la eliminación desde la interfaz web puede tardar. Ten paciencia o elimínalas en lotes.

### Paso 6: Verificar Limpieza Completa

Ejecuta estas consultas para verificar que todo está limpio:

```sql
-- Verificar eventos
SELECT COUNT(*) as eventos_restantes FROM public.events;
-- Debe ser 0

-- Verificar favoritos
SELECT COUNT(*) as favoritos_restantes FROM public.user_favorites;
-- Debe ser 0

-- Verificar que las categorías y ciudades siguen intactas
SELECT COUNT(*) as categorias FROM public.categories;
SELECT COUNT(*) as ciudades FROM public.cities;
-- Estas deben tener datos (no se eliminan)
```

## 🗑️ Limpieza Parcial (Solo Eventos Específicos)

Si NO quieres eliminar TODOS los eventos, sino solo eventos de prueba específicos, puedes usar este enfoque:

### Opción 1: Eliminar por Fecha

```sql
-- Eliminar solo eventos creados antes de una fecha específica
DELETE FROM public.user_favorites
WHERE event_id IN (
  SELECT id FROM public.events 
  WHERE created_at < '2025-01-01'::timestamp
);

DELETE FROM public.events
WHERE created_at < '2025-01-01'::timestamp;
```

### Opción 2: Eliminar por Título (Palabras Clave)

```sql
-- Eliminar eventos cuyo título contenga palabras clave de prueba
DELETE FROM public.user_favorites
WHERE event_id IN (
  SELECT id FROM public.events 
  WHERE title ILIKE '%test%' 
     OR title ILIKE '%prueba%'
     OR title ILIKE '%demo%'
);

DELETE FROM public.events
WHERE title ILIKE '%test%' 
   OR title ILIKE '%prueba%'
   OR title ILIKE '%demo%';
```

### Opción 3: Eliminar por ID Específico

```sql
-- Eliminar eventos específicos por su ID
DELETE FROM public.user_favorites
WHERE event_id IN (
  'id-del-evento-1'::uuid,
  'id-del-evento-2'::uuid,
  -- ... más IDs
);

DELETE FROM public.events
WHERE id IN (
  'id-del-evento-1'::uuid,
  'id-del-evento-2'::uuid,
  -- ... más IDs
);
```

## 📦 Restaurar desde Backup (Si es Necesario)

Si hiciste backup y necesitas restaurar:

```sql
-- Restaurar eventos desde backup
INSERT INTO public.events
SELECT * FROM events_backup;

-- Eliminar tabla de backup después de restaurar (si ya no la necesitas)
-- DROP TABLE IF EXISTS events_backup;
```

## ✅ Checklist Final

- [ ] Verificados los eventos existentes
- [ ] (Opcional) Creado backup de eventos
- [ ] Obtenidas las URLs de imágenes para referencia
- [ ] Eliminados todos los eventos desde SQL
- [ ] Eliminadas todas las imágenes del bucket `event-images` en Storage
- [ ] Verificada la limpieza completa
- [ ] Verificadas que categorías y ciudades siguen intactas
- [ ] Listo para empezar a crear eventos reales

## 🚀 Próximos Pasos

Una vez limpiada la base de datos:

1. **Verificar permisos RLS**: Asegúrate de que las políticas RLS permitan crear nuevos eventos
2. **Probar creación de evento**: Crea un evento de prueba real para verificar que todo funciona
3. **Verificar carga de imágenes**: Prueba subir una imagen para verificar que el Storage funciona correctamente
4. **Documentar**: Mantén un registro de los eventos reales que vayas creando

## 📞 Notas Importantes

- Las imágenes no se eliminan automáticamente al eliminar eventos desde SQL
- Debes eliminar las imágenes manualmente desde Storage o usar la API
- Las categorías y ciudades NO se eliminan (solo se eliminan eventos y favoritos)
- Los usuarios y autenticación NO se ven afectados por esta limpieza

---

**Fecha**: 2024
**Versión**: 1.0
**Autor**: Sistema de limpieza de eventos de prueba
