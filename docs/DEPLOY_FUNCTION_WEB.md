# Desplegar Edge Function desde Supabase Dashboard (Web)

## Método: Crear función directamente en el Dashboard

### Paso 1: Crear nueva función en el Dashboard

1. En el dashboard de Supabase, en la sección **Edge Functions**
2. Haz clic en el botón **"Deploy a new function"** (verde)
3. Si aparece un modal sobre CLI, ciérralo o busca la opción **"Create function"** o **"New function"**

### Paso 2: Crear función manualmente

Si no hay opción directa de subir archivo, puedes:

1. **Crear función con nombre:**
   - Nombre: `send_fcm_notification`
   - Click en **"Create"** o **"New"**

2. **Pegar el código:**
   - Se abrirá un editor de código
   - Copia y pega el contenido completo del archivo `supabase/functions/send_fcm_notification/index.ts`

---

## Alternativa: Usar el código completo aquí

Copia este código completo y pégalo en el editor del dashboard:

```typescript
// supabase/functions/send_fcm_notification/index.ts
// Edge Function para enviar notificaciones FCM usando API V1

import { serve } from "https://deno.land/std@0.168.0/http/server.ts"
import { createClient } from 'https://esm.sh/@supabase/supabase-js@2'
import { create } from "https://deno.land/x/djwt@v2.8/mod.ts"

const FIREBASE_PROJECT_ID = Deno.env.get('FIREBASE_PROJECT_ID')
const FIREBASE_SERVICE_ACCOUNT = Deno.env.get('FIREBASE_SERVICE_ACCOUNT_KEY')

serve(async (req) => {
  // CORS headers
  if (req.method === 'OPTIONS') {
    return new Response(null, {
      headers: {
        'Access-Control-Allow-Origin': '*',
        'Access-Control-Allow-Methods': 'POST',
        'Access-Control-Allow-Headers': 'authorization, x-client-info, apikey, content-type',
      },
    })
  }

  try {
    // Verificar credenciales
    if (!FIREBASE_PROJECT_ID || !FIREBASE_SERVICE_ACCOUNT) {
      return new Response(
        JSON.stringify({ 
          error: 'Firebase credentials not configured',
          hint: 'Configure FIREBASE_PROJECT_ID and FIREBASE_SERVICE_ACCOUNT_KEY in Supabase Edge Function secrets'
        }),
        { 
          status: 500, 
          headers: { 
            'Content-Type': 'application/json',
            'Access-Control-Allow-Origin': '*',
          } 
        }
      )
    }

    // Parsear request
    const { token, title, body, data } = await req.json()

    if (!token || !title || !body) {
      return new Response(
        JSON.stringify({ error: 'Missing required fields: token, title, body' }),
        { 
          status: 400, 
          headers: { 
            'Content-Type': 'application/json',
            'Access-Control-Allow-Origin': '*',
          } 
        }
      )
    }

    // Obtener access token
    const serviceAccount = JSON.parse(FIREBASE_SERVICE_ACCOUNT)
    const accessToken = await getAccessToken(serviceAccount)

    // Enviar notificación usando FCM API V1
    const fcmUrl = `https://fcm.googleapis.com/v1/projects/${FIREBASE_PROJECT_ID}/messages:send`
    
    const message: any = {
      message: {
        token: token,
        notification: {
          title: title,
          body: body,
        },
      },
    }

    if (data) {
      message.message.data = data
    }

    const response = await fetch(fcmUrl, {
      method: 'POST',
      headers: {
        'Authorization': `Bearer ${accessToken}`,
        'Content-Type': 'application/json',
      },
      body: JSON.stringify(message),
    })

    const result = await response.json()

    if (!response.ok) {
      console.error('FCM API Error:', result)
      return new Response(
        JSON.stringify({ error: 'Failed to send notification', details: result }),
        { 
          status: response.status, 
          headers: { 
            'Content-Type': 'application/json',
            'Access-Control-Allow-Origin': '*',
          } 
        }
      )
    }

    return new Response(
      JSON.stringify({ success: true, result }),
      { 
        status: 200, 
        headers: { 
          'Content-Type': 'application/json',
          'Access-Control-Allow-Origin': '*',
        } 
      }
    )

  } catch (error) {
    console.error('Error:', error)
    return new Response(
      JSON.stringify({ error: error.message }),
      { 
        status: 500, 
        headers: { 
          'Content-Type': 'application/json',
          'Access-Control-Allow-Origin': '*',
        } 
      }
    )
  }
})

// Obtener access token usando Service Account
async function getAccessToken(serviceAccount: any): Promise<string> {
  const now = Math.floor(Date.now() / 1000)
  
  // Crear JWT
  const jwt = await createJWT(serviceAccount, now)
  
  // Intercambiar JWT por access token
  const tokenUrl = 'https://oauth2.googleapis.com/token'
  const response = await fetch(tokenUrl, {
    method: 'POST',
    headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
    body: new URLSearchParams({
      grant_type: 'urn:ietf:params:oauth:grant-type:jwt-bearer',
      assertion: jwt,
    }),
  })

  const tokenData = await response.json()
  
  if (!response.ok) {
    throw new Error(`Failed to get access token: ${JSON.stringify(tokenData)}`)
  }
  
  return tokenData.access_token
}

// Crear JWT para autenticación OAuth2
async function createJWT(serviceAccount: any, now: number): Promise<string> {
  // Decodificar la clave privada
  const privateKey = await importPKCS8(serviceAccount.private_key)

  // Crear payload del JWT
  const payload = {
    iss: serviceAccount.client_email,
    scope: 'https://www.googleapis.com/auth/firebase.messaging',
    aud: 'https://oauth2.googleapis.com/token',
    exp: now + 3600,
    iat: now,
  }

  // Firmar JWT
  const jwt = await create(
    { alg: 'RS256', typ: 'JWT' },
    payload,
    privateKey
  )

  return jwt
}

// Importar clave privada PKCS8
async function importPKCS8(pem: string): Promise<CryptoKey> {
  // Remover headers y espacios
  const pemHeader = '-----BEGIN PRIVATE KEY-----'
  const pemFooter = '-----END PRIVATE KEY-----'
  const pemContents = pem
    .replace(pemHeader, '')
    .replace(pemFooter, '')
    .replace(/\s/g, '')
  
  // Decodificar base64
  const binaryDer = Uint8Array.from(atob(pemContents), c => c.charCodeAt(0))
  
  // Importar clave
  const key = await crypto.subtle.importKey(
    'pkcs8',
    binaryDer.buffer,
    {
      name: 'RSASSA-PKCS1-v1_5',
      hash: 'SHA-256',
    },
    false,
    ['sign']
  )
  
  return key
}
```

---

## Nota importante

Algunas versiones del dashboard de Supabase **solo permiten crear funciones desde la CLI**. Si no encuentras la opción de crear/editar funciones en el dashboard web, tendrás que:

1. **Instalar la CLI correctamente** (te puedo ayudar con esto)
2. O **usar GitHub Actions** para desplegar automáticamente

¿Ves alguna opción en el dashboard para crear/editar funciones, o solo aparece el mensaje sobre CLI?
