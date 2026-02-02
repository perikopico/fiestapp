// supabase/functions/notify_venue_ownership_request/index.ts
// Supabase Edge Function para notificar a admins sobre solicitudes de ownership de venues

import { serve } from "https://deno.land/std@0.168.0/http/server.ts"
import { createClient } from 'https://esm.sh/@supabase/supabase-js@2'
import { create } from "https://deno.land/x/djwt@v2.8/mod.ts"

const FIREBASE_PROJECT_ID = Deno.env.get('FIREBASE_PROJECT_ID') || ''
const FIREBASE_SERVICE_ACCOUNT_KEY = Deno.env.get('FIREBASE_SERVICE_ACCOUNT_KEY') || ''

interface OwnershipRequestNotification {
  request_id: string
  venue_id: string
  venue_name: string
  user_id: string
  user_email: string
  verification_method: string
  contact_info: string
  verification_code: string
}

serve(async (req) => {
  try {
    // Verificar que tenemos las credenciales
    if (!FIREBASE_PROJECT_ID || !FIREBASE_SERVICE_ACCOUNT_KEY) {
      console.error('Firebase credentials not configured')
      return new Response(
        JSON.stringify({ error: 'Firebase credentials not configured' }),
        { status: 500, headers: { 'Content-Type': 'application/json' } }
      )
    }

    const supabaseUrl = Deno.env.get('SUPABASE_URL')!
    const supabaseServiceKey = Deno.env.get('SUPABASE_SERVICE_ROLE_KEY')!
    const supabase = createClient(supabaseUrl, supabaseServiceKey)

    const { request_id } = await req.json() as { request_id: string }

    if (!request_id) {
      return new Response(
        JSON.stringify({ error: 'Missing request_id' }),
        { status: 400, headers: { 'Content-Type': 'application/json' } }
      )
    }

    // Obtener información de la solicitud
    const { data: request, error: requestError } = await supabase
      .from('venue_ownership_requests')
      .select(`
        id,
        venue_id,
        user_id,
        verification_code,
        verification_method,
        contact_info,
        venues!inner(name)
      `)
      .eq('id', request_id)
      .single()

    if (requestError || !request) {
      console.error('Error fetching request:', requestError)
      return new Response(
        JSON.stringify({ error: 'Request not found', details: requestError }),
        { status: 404, headers: { 'Content-Type': 'application/json' } }
      )
    }

    // Obtener email del usuario
    const { data: userData, error: userError } = await supabase.auth.admin.getUserById(
      request.user_id
    )

    if (userError || !userData) {
      console.error('Error fetching user:', userError)
      return new Response(
        JSON.stringify({ error: 'User not found', details: userError }),
        { status: 404, headers: { 'Content-Type': 'application/json' } }
      )
    }

    // Obtener todos los admins
    const { data: admins, error: adminsError } = await supabase
      .from('admins')
      .select('user_id')

    if (adminsError || !admins) {
      console.error('Error fetching admins:', adminsError)
      return new Response(
        JSON.stringify({ error: 'Error fetching admins', details: adminsError }),
        { status: 500, headers: { 'Content-Type': 'application/json' } }
      )
    }

    // Obtener tokens FCM de todos los admins
    const adminUserIds = admins.map(a => a.user_id)
    const { data: fcmTokens, error: tokensError } = await supabase
      .from('user_fcm_tokens')
      .select('token, user_id')
      .in('user_id', adminUserIds)

    if (tokensError) {
      console.error('Error fetching FCM tokens:', tokensError)
    }

    // Preparar mensaje de notificación
    const venueName = (request.venues as any).name
    const userEmail = userData.user.email || 'Usuario desconocido'
    const title = 'Nueva solicitud de ownership de venue'
    const body = `${userEmail} solicita ser dueño de "${venueName}"`
    
    const notificationData = {
      type: 'venue_ownership_request',
      request_id: request_id,
      venue_id: request.venue_id,
      venue_name: venueName,
      user_id: request.user_id,
      user_email: userEmail,
      verification_method: request.verification_method,
      contact_info: request.contact_info,
      verification_code: request.verification_code
    }

    // Enviar notificaciones a todos los admins que tengan tokens FCM
    const results = []
    if (fcmTokens && fcmTokens.length > 0) {
      for (const tokenData of fcmTokens) {
        try {
          const result = await sendFCMNotification(
            tokenData.token,
            title,
            body,
            notificationData
          )
          results.push({ user_id: tokenData.user_id, success: result.success })
        } catch (error) {
          console.error(`Error sending notification to ${tokenData.user_id}:`, error)
          results.push({ user_id: tokenData.user_id, success: false, error: error.message })
        }
      }
    }

    return new Response(
      JSON.stringify({ 
        success: true, 
        notifications_sent: results.filter(r => r.success).length,
        total_admins: admins.length,
        admins_with_tokens: fcmTokens?.length || 0,
        results 
      }),
      { status: 200, headers: { 'Content-Type': 'application/json' } }
    )

  } catch (error) {
    console.error('Error:', error)
    return new Response(
      JSON.stringify({ error: error.message }),
      { status: 500, headers: { 'Content-Type': 'application/json' } }
    )
  }
})

// Función para enviar notificación FCM
async function sendFCMNotification(
  token: string,
  title: string,
  body: string,
  data: Record<string, any>
): Promise<{ success: boolean }> {
  const serviceAccount = JSON.parse(FIREBASE_SERVICE_ACCOUNT_KEY)
  const accessToken = await getAccessToken(serviceAccount)

  const fcmUrl = `https://fcm.googleapis.com/v1/projects/${FIREBASE_PROJECT_ID}/messages:send`
  
  const message = {
    message: {
      token: token,
      notification: {
        title: title,
        body: body,
      },
      data: {
        ...Object.fromEntries(
          Object.entries(data).map(([k, v]) => [k, String(v)])
        )
      },
    },
  }

  const response = await fetch(fcmUrl, {
    method: 'POST',
    headers: {
      'Authorization': `Bearer ${accessToken}`,
      'Content-Type': 'application/json',
    },
    body: JSON.stringify(message),
  })

  if (!response.ok) {
    const error = await response.text()
    throw new Error(`FCM API Error: ${error}`)
  }

  return { success: true }
}

// Función para obtener access token usando Service Account (igual que en send_fcm_notification)
async function getAccessToken(serviceAccount: any): Promise<string> {
  const now = Math.floor(Date.now() / 1000)
  
  // Crear JWT firmado con la private_key del service account
  const jwt = await createJWT(serviceAccount, now)
  
  // Intercambiar JWT por un access token OAuth2
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

// Crear JWT para autenticación OAuth2 (RS256)
async function createJWT(serviceAccount: any, now: number): Promise<string> {
  // Importar la clave privada en formato PKCS8
  const privateKey = await importPKCS8(serviceAccount.private_key)

  const payload = {
    iss: serviceAccount.client_email,
    scope: 'https://www.googleapis.com/auth/firebase.messaging',
    aud: 'https://oauth2.googleapis.com/token',
    exp: now + 3600, // 1 hora
    iat: now,
  }

  // Firmar el JWT con RS256
  const jwt = await create(
    { alg: 'RS256', typ: 'JWT' },
    payload,
    privateKey
  )

  return jwt
}

// Importar clave privada PKCS8 desde un PEM
async function importPKCS8(pem: string): Promise<CryptoKey> {
  const pemHeader = '-----BEGIN PRIVATE KEY-----'
  const pemFooter = '-----END PRIVATE KEY-----'
  const pemContents = pem
    .replace(pemHeader, '')
    .replace(pemFooter, '')
    .replace(/\s/g, '')
  
  const binaryDer = Uint8Array.from(atob(pemContents), c => c.charCodeAt(0))

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

