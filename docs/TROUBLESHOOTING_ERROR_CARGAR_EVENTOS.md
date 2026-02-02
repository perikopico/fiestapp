# Error "Failed host lookup" al cargar eventos

Cuando aparece **"Error al cargar eventos"** con un mensaje tipo:
`Failed host lookup: 'oudofaiekedtaovrdqeo.supabase.co' (OS Error: nodename nor servname provided, or not known, errno = 8)`, la app no puede resolver el nombre del servidor de Supabase.

## Qué hacer (en orden)

### 1. Comprobar conexión a internet en el dispositivo
- Abre Safari (o cualquier navegador) en el iPhone y carga una web.
- Si no hay internet, conéctate a WiFi o datos y vuelve a abrir la app y pulsa **Reintentar**.

### 2. Probar otra red
- Si estás en WiFi (por ejemplo de trabajo o público), prueba con **datos móviles**.
- O al revés: si estás en datos, prueba con otra **WiFi**.
- Algunas redes bloquean o no resuelven bien dominios como `*.supabase.co`.

### 3. Verificar la URL de Supabase en tu proyecto
- Entra en [Supabase Dashboard](https://supabase.com/dashboard) y abre tu proyecto.
- Ve a **Project Settings** → **API**.
- Copia la **Project URL** (algo como `https://xxxxxxxx.supabase.co`).
- En el proyecto de la app, abre el archivo **`.env`** en la raíz y comprueba que coincida exactamente:

  ```
  SUPABASE_URL=https://TU_PROYECTO.supabase.co
  SUPABASE_ANON_KEY=tu_anon_key
  ```

- No debe haber espacios extra, ni `http://` en lugar de `https://`, ni otra URL distinta.
- Si cambias el `.env`, hay que **volver a construir e instalar** la app (el `.env` se incluye en el build).

### 4. Si usas un iPhone/iPad físico
- Asegúrate de haber hecho el build **en el mismo equipo donde tienes el `.env` correcto**.
- Si alguien más te ha pasado el `.app` o el build, puede que ese build use otra URL o no tenga la buena; en ese caso, genera un nuevo build con tu `.env` y vuelve a instalar.

### 5. Después de cambiar algo
- Vuelve a ejecutar la app y pulsa **Reintentar** en la pantalla de error.
- Si has tocado el `.env`, haz un build limpio y reinstala:

  ```bash
  flutter clean && flutter pub get && flutter run --release --device-id "iPhone de Pedro"
  ```

En la mayoría de casos el problema es **red/DNS en el dispositivo** (pasos 1 y 2) o **URL incorrecta en `.env`** (paso 3).
