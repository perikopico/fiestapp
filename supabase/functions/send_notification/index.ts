// supabase/functions/send_notification/index.ts
// Supabase Edge Function para enviar notificaciones usando Firebase Cloud Messaging API V1

import { serve } from "https://deno.land/std@0.168.0/http/server.ts"
import { createClient } from 'https://esm.sh/@supabase/supabase-js@2'

const FIREBASE_PROJECT_ID = Deno.env.get('FIREBASE_PROJECT_ID') || ''
const FIREBASE_SERVICE_ACCOUNT_KEY = Deno.env.get('FIREBASE_SERVICE_ACCOUNT_KEY') || ''

interface NotificationRequest {
  token: string
  title: string
  body: string
  data?: Record<string, any>
}

serve(async (req) => {
  try {
    // Verificar que tenemos las credenciales
    if (!FIREBASE_PROJECT_ID || !FIREBASE_SERVICE_ACCOUNT_KEY) {
      return new Response(
        JSON.stringify({ error: 'Firebase credentials not configured' }),
        { status: 500, headers: { 'Content-Type': 'application/json' } }
      )
    }

    const { token, title, body, data } = await req.json() as NotificationRequest

    if (!token || !title || !body) {
      return new Response(
        JSON.stringify({ error: 'Missing required fields: token, title, body' }),
        { status: 400, headers: { 'Content-Type': 'application/json' } }
      )
    }

    // Obtener access token usando Service Account
    const serviceAccount = JSON.parse(FIREBASE_SERVICE_ACCOUNT_KEY)
    const accessToken = await getAccessToken(serviceAccount)

    // Enviar notificación usando FCM API V1
    const fcmUrl = `https://fcm.googleapis.com/v1/projects/${FIREBASE_PROJECT_ID}/messages:send`
    
    const message = {
      message: {
        token: token,
        notification: {
          title: title,
          body: body,
        },
        ...(data && { data: data }),
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
      console.error('FCM API Error:', error)
      return new Response(
        JSON.stringify({ error: 'Failed to send notification', details: error }),
        { status: response.status, headers: { 'Content-Type': 'application/json' } }
      )
    }

    const result = await response.json()
    return new Response(
      JSON.stringify({ success: true, result }),
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

// Función para obtener access token usando Service Account
async function getAccessToken(serviceAccount: any): Promise<string> {
  const now = Math.floor(Date.now() / 1000)
  const jwt = await createJWT(serviceAccount, now)
  
  const tokenUrl = `https://oauth2.googleapis.com/token`
  const response = await fetch(tokenUrl, {
    method: 'POST',
    headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
    body: new URLSearchParams({
      grant_type: 'urn:ietf:params:oauth:grant-type:jwt-bearer',
      assertion: jwt,
    }),
  })

  const tokenData = await response.json()
  return tokenData.access_token
}

// Crear JWT para autenticación
async function createJWT(serviceAccount: any, now: number): Promise<string> {
  const header = {
    alg: 'RS256',
    typ: 'JWT',
  }

  const payload = {
    iss: serviceAccount.client_email,
    scope: 'https://www.googleapis.com/auth/firebase.messaging',
    aud: 'https://oauth2.googleapis.com/token',
    exp: now + 3600,
    iat: now,
  }

  // Nota: Para producción, necesitarías una librería JWT que soporte RS256
  // Por ahora, esto es un placeholder - necesitarías usar una librería como 'jose'
  // Para simplificar, podemos usar un enfoque diferente
  
  // Por ahora, retornamos un token temporal - en producción usarías una librería JWT
  throw new Error('JWT signing not implemented - use a JWT library')
}

