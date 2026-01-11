# Categorías e Imágenes de Muestra

## Numeración de Categorías para Supabase Storage

Las imágenes de muestra están organizadas en Supabase Storage en la siguiente estructura:

```
sample-images/{province_id}/{category_number}/
```

Donde:
- `{province_id}`: ID de la provincia (1 = Cádiz)
- `{category_number}`: Número de la categoría (1-7)

## Mapeo de Categorías a Números

### Orden de las categorías (según migración SQL 013):

| Número | Slug de Categoría | Nombre de Categoría | Carpeta en Storage |
|--------|-------------------|---------------------|-------------------|
| 1 | `musica` | Música | `sample-images/1/1/` |
| 2 | `gastronomia` | Gastronomía | `sample-images/1/2/` |
| 3 | `deportes` | Deportes | `sample-images/1/3/` |
| 4 | `arte-y-cultura` | Arte y Cultura | `sample-images/1/4/` |
| 5 | `aire-libre` | Aire Libre | `sample-images/1/5/` |
| 6 | `tradiciones` | Tradiciones | `sample-images/1/6/` |
| 7 | `mercadillos` | Mercadillos | `sample-images/1/7/` |

## Cómo Subir Imágenes de Muestra

### En Supabase Dashboard:

1. Ve a **Storage** en el panel lateral
2. Selecciona el bucket `sample-images` (crearlo si no existe)
3. Crea las siguientes carpetas si no existen:
   - `1/` (provincia de Cádiz)
   - `1/1/` (Música)
   - `1/2/` (Gastronomía)
   - `1/3/` (Deportes)
   - `1/4/` (Arte y Cultura)
   - `1/5/` (Aire Libre)
   - `1/6/` (Tradiciones)
   - `1/7/` (Mercadillos)

4. Sube las imágenes correspondientes a cada carpeta

### Estructura de Carpetas Completa:

```
sample-images/
└── 1/                    # Provincia: Cádiz
    ├── 1/                # Categoría 1: Música
    │   ├── musica-1.jpg
    │   ├── musica-2.jpg
    │   └── ...
    ├── 2/                # Categoría 2: Gastronomía
    │   ├── gastronomia-1.jpg
    │   ├── gastronomia-2.jpg
    │   └── ...
    ├── 3/                # Categoría 3: Deportes
    │   └── ...
    ├── 4/                # Categoría 4: Arte y Cultura
    │   └── ...
    ├── 5/                # Categoría 5: Aire Libre
    │   └── ...
    ├── 6/                # Categoría 6: Tradiciones
    │   └── ...
    └── 7/                # Categoría 7: Mercadillos
        └── ...
```

## Funcionamiento en la App

Cuando el usuario está creando un evento:

1. **Selecciona una categoría** en el paso 4 del wizard
2. **En el paso 5 (Imagen)**:
   - Al hacer clic en "Seleccionar imagen", aparece un diálogo con 3 opciones:
     - **Galería**: Abre la galería del dispositivo
     - **Cámara**: Abre la cámara para tomar una foto
     - **Imágenes de muestra**: Muestra las imágenes de la categoría seleccionada
3. **Si selecciona "Imágenes de muestra"**:
   - La app busca imágenes en: `sample-images/1/{category_number}/`
   - Muestra un grid con todas las imágenes disponibles
   - El usuario puede seleccionar una imagen
   - La imagen se descarga y se guarda localmente
   - Luego puede recortarla (opcional) igual que las otras opciones

## Notas Importantes

### Verificación del ID de Categoría en Supabase

Para verificar el ID real de cada categoría en tu base de datos, ejecuta esta consulta:

```sql
SELECT 
  id,
  slug,
  name,
  CASE slug
    WHEN 'musica' THEN 1
    WHEN 'gastronomia' THEN 2
    WHEN 'deportes' THEN 3
    WHEN 'arte-y-cultura' THEN 4
    WHEN 'aire-libre' THEN 5
    WHEN 'tradiciones' THEN 6
    WHEN 'mercadillos' THEN 7
  END as numero_carpeta
FROM public.categories
WHERE slug IN (
  'musica', 'gastronomia', 'deportes', 'arte-y-cultura',
  'aire-libre', 'tradiciones', 'mercadillos'
)
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

**IMPORTANTE**: El servicio `SampleImageService` NO usa el ID numérico de la categoría en la BD, sino que usa un mapeo basado en el slug. Esto asegura que la estructura de carpetas sea consistente independientemente del orden de inserción en la BD.

### Si los IDs en la BD no coinciden con 1-7

No es un problema. El servicio mapea las categorías por su **slug**, no por su **ID**:

- `musica` → carpeta `1`
- `gastronomia` → carpeta `2`
- `deportes` → carpeta `3`
- `arte-y-cultura` → carpeta `4`
- `aire-libre` → carpeta `5`
- `tradiciones` → carpeta `6`
- `mercadillos` → carpeta `7`

## Formato de Imágenes Recomendado

- **Formatos soportados**: `.jpg`, `.jpeg`, `.png`, `.webp`
- **Formato preferido**: `.webp` (más eficiente en tamaño y calidad)
- **Tamaño recomendado**: 1200x800px o proporción 3:2
- **Peso máximo**: < 2MB por imagen (se comprimen automáticamente en la app)
- **Nomenclatura**: Usa nombres descriptivos, por ejemplo:
  - `musica-concierto-1.webp`
  - `gastronomia-tapas-1.webp`
  - `deportes-surf-1.webp`
  - etc.

### Notas sobre formato WebP

- La app **detecta automáticamente** la extensión del archivo desde la URL
- Las imágenes WebP se descargan y procesan correctamente
- Después del recorte, las imágenes se guardan como JPG para consistencia con el resto del sistema
- `ImageCropScreen` puede manejar WebP sin problemas ya que trabaja con bytes directamente

## Permisos de Storage

Asegúrate de que el bucket `sample-images` tenga permisos de lectura pública para que las imágenes se puedan cargar en la app. En Supabase:

1. Ve a **Storage** > **Policies**
2. Crea una política para el bucket `sample-images`:
   ```sql
   CREATE POLICY "Public Access"
   ON storage.objects FOR SELECT
   USING (bucket_id = 'sample-images');
   ```

O usa la interfaz gráfica para configurar acceso público de lectura.
