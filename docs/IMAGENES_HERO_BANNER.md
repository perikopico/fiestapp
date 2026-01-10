# Imágenes Hero Banner - Supabase Storage

## Ubicación de las Imágenes

Las imágenes del hero banner deben estar almacenadas en **Supabase Storage** en el bucket `hero_banners`.

### Estructura de Carpetas

Las imágenes se organizan por mes en carpetas con nombres en inglés:

```
hero_banners/
├── january/      (enero)
│   ├── imagen1.jpg
│   ├── imagen2.png
│   └── ...
├── february/     (febrero)
│   └── ...
├── march/        (marzo)
│   └── ...
├── april/        (abril)
│   └── ...
├── may/          (mayo)
│   └── ...
├── june/         (junio)
│   └── ...
├── july/         (julio)
│   └── ...
├── august/       (agosto)
│   └── ...
├── september/    (septiembre)
│   └── ...
├── october/      (octubre)
│   └── ...
├── november/     (noviembre)
│   └── ...
└── december/     (diciembre)
    └── ...
```

### Formato de Archivos

- **Formatos soportados**: `.jpg`, `.jpeg`, `.png`, `.webp`
- **Recomendación**: Usar imágenes de alta calidad (mínimo 800px de ancho)
- **Tamaño**: Optimizar imágenes para web (recomendado < 500KB por imagen)
- **Nota**: WebP es el formato recomendado para mejor compresión y calidad

### Configuración en Supabase

1. **Crear el bucket** (si no existe):
   - Ve a Supabase Dashboard → Storage
   - Crea un nuevo bucket llamado `hero_banners`
   - Configura como **público** para que las imágenes sean accesibles

2. **Crear las carpetas**:
   - Dentro del bucket `hero_banners`, crea las carpetas para cada mes
   - Nombres exactos: `january`, `february`, `march`, etc. (en minúsculas)

3. **Subir imágenes**:
   - Sube las imágenes correspondientes a cada mes en su carpeta
   - Puedes subir múltiples imágenes por mes (se seleccionará una aleatoria)

### Políticas de Acceso

El bucket `hero_banners` debe tener políticas que permitan:
- **Lectura pública**: Cualquiera puede leer las imágenes
- **Escritura**: Solo usuarios autenticados con permisos de administrador

Ejemplo de política RLS (Row Level Security):

```sql
-- Permitir lectura pública
CREATE POLICY "Public Access" ON storage.objects
FOR SELECT
USING (bucket_id = 'hero_banners');

-- Permitir escritura solo a administradores
CREATE POLICY "Admin Upload" ON storage.objects
FOR INSERT
WITH CHECK (
  bucket_id = 'hero_banners' AND
  auth.role() = 'authenticated' AND
  -- Aquí puedes agregar verificación de rol de admin
  true
);
```

### Fallback

Si no se encuentran imágenes en la carpeta del mes actual:
1. El sistema busca en la **raíz** del bucket `hero_banners`
2. Si tampoco encuentra nada, usa **imágenes de fallback** de Unsplash

### Verificación

Para verificar que las imágenes están correctamente configuradas:

1. Ve a Supabase Dashboard → Storage → `hero_banners`
2. Verifica que existe la carpeta del mes actual (ej: `january` para enero)
3. Verifica que hay al menos una imagen en formato `.jpg`, `.jpeg` o `.png`
4. Verifica que el bucket es público

### Código Relacionado

- `lib/ui/dashboard/dashboard_screen.dart` - Carga las imágenes del hero banner
- `lib/services/hero_banner_service.dart` - Servicio para obtener banners estacionales

### Solución de Problemas

**Problema**: "No se encontraron imágenes en january"

**Soluciones**:
1. Verifica que el bucket `hero_banners` existe en Supabase Storage
2. Verifica que la carpeta `january` existe dentro del bucket
3. Verifica que hay imágenes en formato `.jpg`, `.jpeg`, `.png` o `.webp` en la carpeta
4. Verifica que el bucket tiene permisos de lectura pública
5. Verifica que el nombre de la carpeta está en minúsculas: `january` (no `January` o `JANUARY`)
