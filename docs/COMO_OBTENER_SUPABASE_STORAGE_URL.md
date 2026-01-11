# Cómo Obtener la URL de Supabase Storage

La URL de Supabase Storage tiene el formato:
```
https://[TU-PROYECTO-ID].supabase.co/storage/v1/object/public
```

## Opción 1: Desde el Dashboard de Supabase (Recomendado)

1. **Ve a tu proyecto en Supabase Dashboard**
   - Accede a https://supabase.com/dashboard
   - Selecciona tu proyecto

2. **Ir a Storage**
   - En el menú lateral, haz clic en **"Storage"**
   - O ve directamente a: `https://supabase.com/dashboard/project/[TU-PROYECTO-ID]/storage/buckets`

3. **Ver la URL en cualquier archivo público**
   - Haz clic en el bucket `sample-images`
   - Abre cualquier carpeta (ej: `1/1/`)
   - Haz clic en un archivo (ej: `01.webp`)
   - En la URL del archivo verás algo como:
     ```
     https://[TU-PROYECTO-ID].supabase.co/storage/v1/object/public/sample-images/1/1/01.webp
     ```
   - **La URL base es todo hasta `/storage/v1/object/public`**
   - Ejemplo: `https://abcdefghijklmnop.supabase.co/storage/v1/object/public`

## Opción 2: Desde la Configuración del Proyecto

1. **Ve a Settings → API**
   - En el menú lateral: **Settings** → **API**
   - O directamente: `https://supabase.com/dashboard/project/[TU-PROYECTO-ID]/settings/api`

2. **Busca la "Project URL"**
   - Verás algo como: `https://abcdefghijklmnop.supabase.co`
   - **La URL de Storage es esa URL + `/storage/v1/object/public`**
   - Resultado: `https://abcdefghijklmnop.supabase.co/storage/v1/object/public`

## Opción 3: Desde el archivo .env (si lo tienes)

Si tienes acceso al archivo `.env` del proyecto:

1. **Abre el archivo `.env`** (está en la raíz del proyecto, pero puede estar en `.gitignore`)
2. **Busca `SUPABASE_URL`**
   ```
   SUPABASE_URL=https://abcdefghijklmnop.supabase.co
   ```
3. **Construye la URL de Storage**
   - Agrega `/storage/v1/object/public` al final
   - Resultado: `https://abcdefghijklmnop.supabase.co/storage/v1/object/public`

## Opción 4: Probando con un archivo existente

Si ya tienes imágenes cargadas en Supabase Storage:

1. **Abre una imagen en tu navegador** (debe ser pública)
2. **Copia la URL completa**
   - Ejemplo: `https://abcdefghijklmnop.supabase.co/storage/v1/object/public/sample-images/1/1/01.webp`
3. **Elimina la parte después de `/public`**
   - Resultado: `https://abcdefghijklmnop.supabase.co/storage/v1/object/public`

## Opción 5: Desde la URL de cualquier servicio de Supabase

Si conoces la URL base de tu proyecto Supabase (usada para la API):

- **URL de API**: `https://[PROYECTO-ID].supabase.co/rest/v1/`
- **URL de Storage**: `https://[PROYECTO-ID].supabase.co/storage/v1/object/public`

Solo cambia `/rest/v1/` por `/storage/v1/object/public`

## Verificación

Para verificar que la URL es correcta, intenta acceder a:
```
https://[TU-URL]/sample-images/1/1/01.webp
```

Si puedes ver la imagen en el navegador, la URL es correcta ✅

## Ejemplo Completo

Supongamos que tu proyecto Supabase tiene el ID: `abcdefghijklmnop`

- **URL Base**: `https://abcdefghijklmnop.supabase.co`
- **URL de Storage**: `https://abcdefghijklmnop.supabase.co/storage/v1/object/public`
- **URL de un archivo**: `https://abcdefghijklmnop.supabase.co/storage/v1/object/public/sample-images/1/1/01.webp`

## Notas Importantes

⚠️ **La URL debe terminar en `/storage/v1/object/public`** (sin barra final)

❌ Incorrecto: `https://xxx.supabase.co/storage/v1/object/public/`

✅ Correcto: `https://xxx.supabase.co/storage/v1/object/public`

## Después de Obtener la URL

Una vez que tengas la URL, reemplázala en el archivo SQL:

1. Abre: `docs/migrations/016_insertar_eventos_YYYYMMDD_HHMMSS.sql`
2. Busca: `{SUPABASE_STORAGE_URL}`
3. Reemplaza con tu URL real
4. Guarda el archivo
5. Ejecuta el SQL en Supabase SQL Editor
