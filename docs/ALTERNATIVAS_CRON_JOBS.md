# 🔄 Alternativas para Cron Jobs en Supabase

Si no puedes usar `pg_cron` en Supabase (no está disponible en tu plan o no puedes habilitarlo), aquí tienes varias alternativas:

## Opción 1: GitHub Actions (Gratis) ⭐ Recomendado

### Configuración:

1. Crea un archivo `.github/workflows/daily-reminders.yml`:

```yaml
name: Send Favorite Reminders

on:
  schedule:
    # Ejecuta diariamente a las 10:00 AM UTC
    - cron: '0 10 * * *'
  workflow_dispatch: # Permite ejecución manual

jobs:
  send-reminders:
    runs-on: ubuntu-latest
    steps:
      - name: Call Supabase Edge Function
        run: |
          curl -X POST \
            'https://oudofaiekedtaovrdqeo.supabase.co/functions/v1/send-favorite-reminders' \
            -H 'Authorization: Bearer ${{ secrets.SUPABASE_SERVICE_ROLE_KEY }}' \
            -H 'Content-Type: application/json' \
            -d '{}'
```

2. Ve a tu repositorio en GitHub → Settings → Secrets → Actions
3. Agrega el secret `SUPABASE_SERVICE_ROLE_KEY` con tu Service Role Key
4. El workflow se ejecutará automáticamente cada día

**Ventajas:**
- ✅ Gratis para repositorios públicos
- ✅ Fácil de configurar
- ✅ Puedes ver el historial de ejecuciones
- ✅ Permite ejecución manual

---

## Opción 2: Vercel Cron (Gratis)

### Configuración:

1. Crea un archivo `vercel.json` en la raíz del proyecto:

```json
{
  "crons": [
    {
      "path": "/api/cron/reminders",
      "schedule": "0 10 * * *"
    }
  ]
}
```

2. Crea `api/cron/reminders.ts`:

```typescript
export default async function handler(req: any, res: any) {
  const response = await fetch(
    'https://oudofaiekedtaovrdqeo.supabase.co/functions/v1/send-favorite-reminders',
    {
      method: 'POST',
      headers: {
        'Authorization': `Bearer ${process.env.SUPABASE_SERVICE_ROLE_KEY}`,
        'Content-Type': 'application/json',
      },
      body: JSON.stringify({}),
    }
  );

  const data = await response.json();
  res.status(200).json(data);
}
```

3. Despliega en Vercel y configura el secret `SUPABASE_SERVICE_ROLE_KEY`

---

## Opción 3: cron-job.org (Gratis)

### Configuración:

1. Ve a [cron-job.org](https://cron-job.org) y crea una cuenta
2. Crea un nuevo cron job:
   - **URL:** `https://oudofaiekedtaovrdqeo.supabase.co/functions/v1/send-favorite-reminders`
   - **Schedule:** `0 10 * * *` (10:00 AM UTC diariamente)
   - **Method:** POST
   - **Headers:**
     - `Authorization: Bearer [TU-SERVICE-ROLE-KEY]`
     - `Content-Type: application/json`
   - **Body:** `{}`

**Ventajas:**
- ✅ Muy fácil de configurar
- ✅ No requiere código adicional
- ✅ Dashboard para ver ejecuciones

---

## Opción 4: Crear Endpoint Público con Secret

Si prefieres mantener todo en Supabase, puedes crear una Edge Function pública que valide un secret:

### Nueva Edge Function: `send-favorite-reminders-public`

```typescript
// supabase/functions/send-favorite-reminders-public/index.ts
import { serve } from "https://deno.land/std@0.168.0/http/server.ts"

const CRON_SECRET = Deno.env.get('CRON_SECRET') || ''

serve(async (req) => {
  // Validar secret
  const authHeader = req.headers.get('Authorization')
  if (authHeader !== `Bearer ${CRON_SECRET}`) {
    return new Response(
      JSON.stringify({ error: 'Unauthorized' }),
      { status: 401, headers: { 'Content-Type': 'application/json' } }
    )
  }

  // Llamar a la función interna
  const supabaseUrl = Deno.env.get('SUPABASE_URL')!
  const response = await fetch(
    `${supabaseUrl}/functions/v1/send-favorite-reminders`,
    {
      method: 'POST',
      headers: {
        'Authorization': `Bearer ${Deno.env.get('SUPABASE_SERVICE_ROLE_KEY')}`,
        'Content-Type': 'application/json',
      },
      body: JSON.stringify({}),
    }
  )

  const data = await response.json()
  return new Response(JSON.stringify(data), {
    status: 200,
    headers: { 'Content-Type': 'application/json' },
  })
})
```

Luego usa cualquier servicio de cron externo para llamar a esta función pública con el secret.

---

## Opción 5: Usar pg_cron directamente con SQL

Si `pg_cron` está disponible pero no ves la interfaz en el Dashboard:

1. Ve a **Supabase Dashboard** → **SQL Editor**
2. Ejecuta este SQL:

```sql
-- Habilitar pg_cron
CREATE EXTENSION IF NOT EXISTS pg_cron;

-- Crear el cron job
SELECT cron.schedule(
  'send-favorite-reminders-daily',
  '0 10 * * *',
  $$
  SELECT net.http_post(
    url := 'https://oudofaiekedtaovrdqeo.supabase.co/functions/v1/send-favorite-reminders',
    headers := jsonb_build_object(
      'Content-Type', 'application/json',
      'Authorization', 'Bearer [TU-SERVICE-ROLE-KEY]'
    ),
    body := '{}'::jsonb
  ) AS request_id;
  $$
);

-- Verificar que se creó
SELECT * FROM cron.job WHERE jobname = 'send-favorite-reminders-daily';
```

3. Ver el historial de ejecuciones:

```sql
SELECT * FROM cron.job_run_details 
WHERE jobid = (SELECT jobid FROM cron.job WHERE jobname = 'send-favorite-reminders-daily')
ORDER BY start_time DESC 
LIMIT 10;
```

---

## Recomendación

Para tu caso, recomiendo **GitHub Actions** porque:
- ✅ Es gratis
- ✅ Ya tienes el código en GitHub
- ✅ Fácil de mantener y ver el historial
- ✅ No requiere servicios externos adicionales

¿Quieres que te ayude a configurar alguna de estas opciones?
