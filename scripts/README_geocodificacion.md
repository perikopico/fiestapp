# Script de Geocodificación de Eventos

Este script geocodifica eventos que no tienen coordenadas (lat/lng) usando Google Maps Geocoding API.

## Requisitos

1. **Python 3.8+**
2. **Dependencias Python:**
   ```bash
   pip install supabase python-dotenv requests
   ```

3. **Variables de entorno en `.env`:**
   ```env
   SUPABASE_URL=tu_url_de_supabase
   SUPABASE_SERVICE_ROLE_KEY=tu_service_role_key  # IMPORTANTE: usa service_role, no anon_key
   GOOGLE_MAPS_API_KEY=tu_google_maps_api_key
   ```

   **Nota:** Necesitas `SUPABASE_SERVICE_ROLE_KEY` (no `SUPABASE_ANON_KEY`) porque el script necesita permisos para actualizar eventos.

## Uso

1. **Asegúrate de tener las columnas lat/lng en la tabla events:**
   - Ejecuta primero la migración `033_add_lat_lng_to_events.sql` si no lo has hecho

2. **Ejecuta el script:**
   ```bash
   cd scripts
   python3 geocodificar_eventos.py
   ```

## Qué hace el script

1. **Obtiene eventos sin coordenadas:**
   - Busca eventos donde `lat` o `lng` son NULL
   - Limita a 500 eventos por ejecución (puedes ejecutarlo varias veces)

2. **Geocodifica cada evento:**
   - Construye una query: `"lugar, ciudad"` (ej: "Plaza de España, Cádiz")
   - Si no hay lugar, usa solo la ciudad
   - Llama a Google Maps Geocoding API

3. **Actualiza la base de datos:**
   - Guarda las coordenadas obtenidas en los campos `lat` y `lng`
   - Valida que las coordenadas sean razonables (-90 a 90 para lat, -180 a 180 para lng)

4. **Muestra un resumen:**
   - Cuántos eventos se actualizaron correctamente
   - Cuántos tuvieron errores
   - Cuántos se saltaron

## Límites de API

- El script incluye un delay de 0.1 segundos entre requests para no exceder límites
- Google Maps Geocoding API tiene límites según tu plan:
  - **Free tier:** $200 créditos/mes (≈40,000 requests)
  - **Pay as you go:** $5 por 1,000 requests adicionales

Para 165 eventos, necesitarás aproximadamente 165 requests (dentro del free tier).

## Manejo de errores

- Si un evento no se puede geocodificar, se marca como error pero el script continúa
- Si se excede el límite de API, el script se detiene y muestra un mensaje
- Los eventos que ya tienen coordenadas se saltan automáticamente

## Ejemplo de salida

```
🚀 Iniciando geocodificación de eventos...
📡 Conectado a Supabase: https://xxx.supabase.co
🔑 API Key configurada: ✅

📋 Obteniendo eventos sin coordenadas...
📊 Encontrados 165 eventos sin coordenadas

[1/165] Concierto en la Plaza
  📍 Lugar: Plaza de España
  🏙️  Ciudad: Cádiz
  ✅ Encontrado: 36.5270, -6.2886
  ✅ Actualizado correctamente

...

============================================================
📊 RESUMEN
============================================================
✅ Eventos actualizados: 142
❌ Eventos con error: 23
⚠️  Eventos saltados: 0
📋 Total procesados: 165

🎉 ¡142 eventos ahora tienen coordenadas!
```

## Notas importantes

- **Service Role Key:** Este script necesita la `SUPABASE_SERVICE_ROLE_KEY` porque actualiza datos. **NUNCA** compartas esta key públicamente.

- **Costos:** Google Maps Geocoding API es de pago después del free tier. Verifica tus límites antes de ejecutar.

- **Precisión:** La geocodificación puede no ser 100% precisa, especialmente si el nombre del lugar es ambiguo. Revisa manualmente eventos importantes.

- **Re-ejecución:** Puedes ejecutar el script varias veces de forma segura. Solo actualizará eventos que aún no tienen coordenadas.
