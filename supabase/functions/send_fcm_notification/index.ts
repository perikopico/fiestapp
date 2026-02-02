// supabase/functions/send_fcm_notification/index.ts
// Edge Function para enviar notificaciones FCM.
// 
// SEGURIDAD: Solo admins pueden invocar esta función (validación de JWT).
// Se usa desde la app cuando un admin aprueba/rechaza eventos.
//
// - Secret necesario en Supabase:
//   - FCM_LEGACY_SERVER_KEY  -> Clave de servidor de Cloud Messaging (heredada)
//
// La interfaz de la función se mantiene igual:
//   { token, title, body, data? }

import { serve } from "https://deno.land/std@0.168.0/http/server.ts"
import { createClient } from 'https://esm.sh/@supabase/supabase-js@2'

const FCM_LEGACY_SERVER_KEY = Deno.env.get('FCM_LEGACY_SERVER_KEY')

const corsHeaders = {
  'Access-Control-Allow-Origin': '*',
  'Access-Control-Allow-Methods': 'POST',
  'Access-Control-Allow-Headers': 'authorization, x-client-info, apikey, content-type',
}

function jsonResponse(obj: object, status: number) {
  return new Response(JSON.stringify(obj), {
    status,
    headers: { 'Content-Type': 'application/json', ...corsHeaders },
  })
}

serve(async (req) => {
  if (req.method === 'OPTIONS') {
    return new Response(null, { headers: corsHeaders })
  }

  try {
    // 1. Verificar autenticación y permisos de admin
    const authHeader = req.headers.get('Authorization')
    if (!authHeader?.startsWith('Bearer ')) {
      return jsonResponse({ error: 'Missing or invalid authorization header' }, 401)
    }

    const supabaseUrl = Deno.env.get('SUPABASE_URL')!
    const supabaseAnonKey = Deno.env.get('SUPABASE_ANON_KEY')!
    const supabase = createClient(supabaseUrl, supabaseAnonKey, {
      global: { headers: { Authorization: authHeader } },
    })

    const { data: { user }, error: userError } = await supabase.auth.getUser(
      authHeader.replace('Bearer ', '')
    )

    if (userError || !user) {
      return jsonResponse({ error: 'Invalid or expired token' }, 401)
    }

    // Verificar que el usuario es admin (RLS en admins permite leer solo si eres admin)
    const { data: adminRow, error: adminError } = await supabase
      .from('admins')
      .select('user_id')
      .eq('user_id', user.id)
      .maybeSingle()

    if (adminError || !adminRow) {
      return jsonResponse({ error: 'Forbidden: admin access required' }, 403)
    }

    // 2. Verificar credenciales FCM
    if (!FCM_LEGACY_SERVER_KEY) {
      return jsonResponse({
        error: 'FCM legacy server key not configured',
        hint: 'Configura el secret FCM_LEGACY_SERVER_KEY en Supabase con la clave de servidor de Firebase Cloud Messaging (heredada)',
      }, 500)
    }

    // 3. Parsear request
    const { token, title, body, data } = await req.json()

    if (!token || !title || !body) {
      return jsonResponse({ error: 'Missing required fields: token, title, body' }, 400)
    }

    // Construir payload para API heredada
    const message: any = {
      to: token,
      notification: {
        title: title,
        body: body,
      },
    }

    if (data) {
      message.data = data
    }

    // Enviar notificación usando FCM HTTP legacy API
    const response = await fetch('https://fcm.googleapis.com/fcm/send', {
      method: 'POST',
      headers: {
        'Authorization': `key=${FCM_LEGACY_SERVER_KEY}`,
        'Content-Type': 'application/json',
      },
      body: JSON.stringify(message),
    })

    const resultText = await response.text()
    let result: unknown = resultText
    try {
      result = JSON.parse(resultText)
    } catch {
      // Si la respuesta no es JSON, devolvemos el texto plano
    }

    if (!response.ok) {
      console.error('FCM API Error:', result)
      return jsonResponse({ error: 'Failed to send notification', details: result }, response.status)
    }

    return jsonResponse({ success: true, result }, 200)

  } catch (error) {
    console.error('Error:', error)
    return jsonResponse(
      { error: error instanceof Error ? error.message : String(error) },
      500
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
