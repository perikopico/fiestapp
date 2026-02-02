// supabase/functions/send-favorite-reminders/index.ts
// Edge Function CRON para enviar recordatorios de eventos favoritos (24h antes)
// 
// Configuración CRON: Ejecutar diariamente a las 10:00 AM UTC
// Cron expression: "0 10 * * *"
//
// Requiere secrets:
// - FIREBASE_PROJECT_ID
// - FIREBASE_SERVICE_ACCOUNT_KEY

import { serve } from "https://deno.land/std@0.168.0/http/server.ts"
import { createClient } from 'https://esm.sh/@supabase/supabase-js@2'
import { create } from "https://deno.land/x/djwt@v2.8/mod.ts"

const FIREBASE_PROJECT_ID = Deno.env.get('FIREBASE_PROJECT_ID') || ''
const FIREBASE_SERVICE_ACCOUNT_KEY = Deno.env.get('FIREBASE_SERVICE_ACCOUNT_KEY') || ''

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
    if (!FIREBASE_PROJECT_ID || !FIREBASE_SERVICE_ACCOUNT_KEY) {
      return new Response(
        JSON.stringify({ 
          error: 'Firebase credentials not configured',
          hint: 'Configura los secrets FIREBASE_PROJECT_ID y FIREBASE_SERVICE_ACCOUNT_KEY en Supabase'
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

    const supabaseUrl = Deno.env.get('SUPABASE_URL')!
    const supabaseServiceKey = Deno.env.get('SUPABASE_SERVICE_ROLE_KEY')!
    const supabase = createClient(supabaseUrl, supabaseServiceKey)

    // Calcular fecha de mañana (solo fecha, sin hora)
    const now = new Date()
    const tomorrow = new Date(now)
    tomorrow.setDate(tomorrow.getDate() + 1)
    tomorrow.setHours(0, 0, 0, 0) // Inicio del día de mañana
    
    const tomorrowEnd = new Date(tomorrow)
    tomorrowEnd.setHours(23, 59, 59, 999) // Fin del día de mañana

    console.log(`🔍 Buscando eventos que empiecen mañana: ${tomorrow.toISOString()} - ${tomorrowEnd.toISOString()}`)

    // 1. Buscar eventos que empiecen mañana
    const { data: events, error: eventsError } = await supabase
      .from('events')
      .select('id, title, starts_at, status')
      .eq('status', 'published') // Solo eventos publicados
      .gte('starts_at', tomorrow.toISOString())
      .lte('starts_at', tomorrowEnd.toISOString())

    if (eventsError) {
      console.error('Error fetching events:', eventsError)
      return new Response(
        JSON.stringify({ error: 'Error fetching events', details: eventsError }),
        { status: 500, headers: { 'Content-Type': 'application/json' } }
      )
    }

    if (!events || events.length === 0) {
      console.log('✅ No hay eventos mañana, no se enviarán recordatorios')
      return new Response(
        JSON.stringify({ 
          success: true, 
          message: 'No events tomorrow',
          events_found: 0,
          notifications_sent: 0
        }),
        { status: 200, headers: { 'Content-Type': 'application/json' } }
      )
    }

    console.log(`📅 Encontrados ${events.length} eventos para mañana`)

    // 2. Para cada evento, obtener usuarios que lo tienen en favoritos
    const serviceAccount = JSON.parse(FIREBASE_SERVICE_ACCOUNT_KEY)
    const accessToken = await getAccessToken(serviceAccount)
    
    let totalNotificationsSent = 0
    let totalTokensInvalid = 0
    const invalidTokens: string[] = []

    for (const event of events) {
      // Obtener usuarios que tienen este evento en favoritos
      const { data: favorites, error: favoritesError } = await supabase
        .from('user_favorites')
        .select('user_id')
        .eq('event_id', event.id)

      if (favoritesError) {
        console.error(`Error fetching favorites for event ${event.id}:`, favoritesError)
        continue
      }

      if (!favorites || favorites.length === 0) {
        console.log(`⚠️ Evento ${event.id} no tiene favoritos`)
        continue
      }

      const userIds = favorites.map(f => f.user_id)
      console.log(`❤️ Evento "${event.title}" tiene ${userIds.length} usuarios favoritos`)

      // 3. Obtener tokens FCM de esos usuarios
      const { data: tokens, error: tokensError } = await supabase
        .from('user_fcm_tokens')
        .select('token, user_id')
        .in('user_id', userIds)

      if (tokensError) {
        console.error(`Error fetching tokens for event ${event.id}:`, tokensError)
        continue
      }

      if (!tokens || tokens.length === 0) {
        console.log(`⚠️ No hay tokens FCM para usuarios con evento ${event.id} en favoritos`)
        continue
      }

      console.log(`📱 Enviando recordatorios a ${tokens.length} tokens para evento "${event.title}"`)

      // 4. Enviar notificación a cada token
      for (const tokenData of tokens) {
        try {
          const result = await sendFCMNotification(
            accessToken,
            tokenData.token,
            '¡Mañana es el gran día!',
            `No te pierdas "${event.title}"`,
            {
              click_action: 'FLUTTER_NOTIFICATION_CLICK',
              view: 'event_detail',
              id: event.id,
              type: 'favorite_reminder',
            }
          )

          if (result.success) {
            totalNotificationsSent++
            // Guardar en historial
            await saveNotificationToHistory(
              supabase,
              tokenData.user_id,
              '¡Mañana es el gran día!',
              `No te pierdas "${event.title}"`,
              {
                click_action: 'FLUTTER_NOTIFICATION_CLICK',
                view: 'event_detail',
                id: event.id,
                type: 'favorite_reminder',
              },
              'favorite_reminder',
              event.id,
              tokenData.token,
              result.messageId
            )
          } else if (result.invalidToken) {
            totalTokensInvalid++
            invalidTokens.push(tokenData.token)
          }
        } catch (error) {
          console.error(`Error sending notification to token ${tokenData.token.substring(0, 20)}...:`, error)
        }
      }
    }

    // Eliminar tokens inválidos de la BD
    if (invalidTokens.length > 0) {
      console.log(`🗑️ Eliminando ${invalidTokens.length} tokens inválidos`)
      await supabase
        .from('user_fcm_tokens')
        .delete()
        .in('token', invalidTokens)
    }

    return new Response(
      JSON.stringify({
        success: true,
        events_found: events.length,
        notifications_sent: totalNotificationsSent,
        invalid_tokens_removed: totalTokensInvalid,
        timestamp: new Date().toISOString(),
      }),
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
      JSON.stringify({ error: error.message, stack: error.stack }),
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

// Función para guardar notificación en historial
async function saveNotificationToHistory(
  supabase: any,
  userId: string,
  title: string,
  body: string,
  data: Record<string, any>,
  notificationType: string,
  eventId: string | null,
  fcmToken: string | null,
  fcmMessageId: string | null
) {
  try {
    await supabase
      .from('notifications_history')
      .insert({
        user_id: userId,
        title,
        body,
        data,
        notification_type: notificationType,
        event_id: eventId,
        fcm_token: fcmToken,
        fcm_message_id: fcmMessageId,
        delivery_status: 'sent',
        sent_at: new Date().toISOString(),
      })
  } catch (error) {
    console.error('Error guardando en historial:', error)
    // No lanzar error, solo loguear para no interrumpir el flujo
  }
}

// Función para enviar notificación FCM
async function sendFCMNotification(
  accessToken: string,
  token: string,
  title: string,
  body: string,
  data: Record<string, any>
): Promise<{ success: boolean; invalidToken?: boolean; messageId?: string }> {
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
      android: {
        priority: 'high',
      },
      apns: {
        headers: {
          'apns-priority': '10',
        },
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
    const errorText = await response.text()
    let errorData: any = {}
    try {
      errorData = JSON.parse(errorText)
    } catch {
      errorData = { message: errorText }
    }

    // Detectar token inválido (UNREGISTERED)
    if (errorData.error?.details?.[0]?.errorCode === 'UNREGISTERED' || 
        errorData.error?.code === 404) {
      console.log(`⚠️ Token inválido detectado: ${token.substring(0, 20)}...`)
      return { success: false, invalidToken: true }
    }

    throw new Error(`FCM API Error: ${errorText}`)
  }

  const responseData = await response.json()
  const messageId = responseData.name || null // FCM message ID

  return { success: true, messageId }
}

// Función para obtener access token usando Service Account
async function getAccessToken(serviceAccount: any): Promise<string> {
  const now = Math.floor(Date.now() / 1000)
  const jwt = await createJWT(serviceAccount, now)
  
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
  const privateKey = await importPKCS8(serviceAccount.private_key)

  const payload = {
    iss: serviceAccount.client_email,
    scope: 'https://www.googleapis.com/auth/firebase.messaging',
    aud: 'https://oauth2.googleapis.com/token',
    exp: now + 3600,
    iat: now,
  }

  const jwt = await create(
    { alg: 'RS256', typ: 'JWT' },
    payload,
    privateKey
  )

  return jwt
}

// Importar clave privada PKCS8
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
