// supabase/functions/send-favorite-reminders-v2/index.ts
// ============================================================================
// Edge Function CRON V2: Recordatorios de Favoritos (usando SmartNotificationSender)
// ============================================================================
// 
// Esta es una versión mejorada que usa el SmartNotificationSender para:
// - Manejar quiet hours automáticamente
// - Persistir en historial
// - Encolar notificaciones si es necesario
//
// Configuración CRON: Ejecutar diariamente a las 10:00 AM UTC
// Cron expression: "0 10 * * *"
//
// Requiere secrets:
// - FIREBASE_PROJECT_ID
// - FIREBASE_SERVICE_ACCOUNT_KEY
// ============================================================================

import { serve } from "https://deno.land/std@0.168.0/http/server.ts"
import { createClient } from 'https://esm.sh/@supabase/supabase-js@2'
import { create } from "https://deno.land/x/djwt@v2.8/mod.ts"
import { SmartNotificationSender } from '../_shared/smart-notification-sender.ts'

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

    // Obtener access token de Firebase
    const serviceAccount = JSON.parse(FIREBASE_SERVICE_ACCOUNT_KEY)
    const accessToken = await getAccessToken(serviceAccount)

    // Inicializar SmartNotificationSender
    const sender = new SmartNotificationSender(supabase, accessToken, FIREBASE_PROJECT_ID)

    // Calcular fecha de mañana
    const now = new Date()
    const tomorrow = new Date(now)
    tomorrow.setDate(tomorrow.getDate() + 1)
    tomorrow.setHours(0, 0, 0, 0)
    
    const tomorrowEnd = new Date(tomorrow)
    tomorrowEnd.setHours(23, 59, 59, 999)

    console.log(`🔍 Buscando eventos que empiecen mañana: ${tomorrow.toISOString()} - ${tomorrowEnd.toISOString()}`)

    // Buscar eventos que empiecen mañana
    const { data: events, error: eventsError } = await supabase
      .from('events')
      .select('id, title, starts_at, status')
      .eq('status', 'published')
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
          notifications_sent: 0,
          notifications_queued: 0
        }),
        { status: 200, headers: { 'Content-Type': 'application/json' } }
      )
    }

    console.log(`📅 Encontrados ${events.length} eventos para mañana`)

    let totalSent = 0
    let totalQueued = 0
    let totalFailed = 0
    const invalidTokens: string[] = []

    // Para cada evento, obtener usuarios que lo tienen en favoritos
    for (const event of events) {
      const { data: favorites, error: favoritesError } = await supabase
        .from('user_favorites')
        .select('user_id')
        .eq('event_id', event.id)

      if (favoritesError) {
        console.error(`Error obteniendo favoritos para evento ${event.id}:`, favoritesError)
        continue
      }

      if (!favorites || favorites.length === 0) {
        continue
      }

      console.log(`❤️ Evento "${event.title}" tiene ${favorites.length} usuarios en favoritos`)

      // Para cada usuario con favorito, enviar notificación
      for (const favorite of favorites) {
        const userId = favorite.user_id

        // Obtener tokens FCM del usuario
        const { data: tokens, error: tokensError } = await supabase
          .from('user_fcm_tokens')
          .select('token')
          .eq('user_id', userId)

        if (tokensError || !tokens || tokens.length === 0) {
          console.log(`⚠️ Usuario ${userId} no tiene tokens FCM`)
          continue
        }

        // Enviar a cada token del usuario
        for (const tokenRow of tokens) {
          const result = await sender.send({
            title: '¡Mañana es el gran día!',
            body: `No te pierdas ${event.title}`,
            data: {
              click_action: 'FLUTTER_NOTIFICATION_CLICK',
              view: 'event_detail',
              id: event.id,
              type: 'favorite_reminder'
            },
            notificationType: 'favorite_reminder',
            eventId: event.id,
            target: {
              userId,
              fcmToken: tokenRow.token
            },
            priority: 0
          })

          if (result.success) {
            if (result.wasQueued) {
              totalQueued++
              console.log(`📬 Notificación encolada para usuario ${userId}`)
            } else {
              totalSent++
              console.log(`✅ Notificación enviada a usuario ${userId}`)
            }
          } else {
            totalFailed++
            console.error(`❌ Error enviando notificación a usuario ${userId}: ${result.error}`)
          }
        }
      }
    }

    return new Response(
      JSON.stringify({
        success: true,
        events_found: events.length,
        notifications_sent: totalSent,
        notifications_queued: totalQueued,
        notifications_failed: totalFailed
      }),
      { status: 200, headers: { 'Content-Type': 'application/json' } }
    )
  } catch (error) {
    console.error('Error en send-favorite-reminders-v2:', error)
    return new Response(
      JSON.stringify({ 
        error: 'Internal server error',
        details: error instanceof Error ? error.message : String(error)
      }),
      { status: 500, headers: { 'Content-Type': 'application/json' } }
    )
  }
})

// ============================================================================
// FUNCIONES AUXILIARES
// ============================================================================

async function getAccessToken(serviceAccount: any): Promise<string> {
  const now = Math.floor(Date.now() / 1000)
  const jwt = await createJWT(serviceAccount, now)
  
  const response = await fetch('https://oauth2.googleapis.com/token', {
    method: 'POST',
    headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
    body: new URLSearchParams({
      grant_type: 'urn:ietf:params:oauth:grant-type:jwt-bearer',
      assertion: jwt,
    }),
  })

  if (!response.ok) {
    const error = await response.text()
    throw new Error(`Failed to get access token: ${error}`)
  }

  const data = await response.json()
  return data.access_token
}

async function createJWT(serviceAccount: any, now: number): Promise<string> {
  const header = {
    alg: 'RS256',
    typ: 'JWT',
  }

  const claim = {
    iss: serviceAccount.client_email,
    scope: 'https://www.googleapis.com/auth/firebase.messaging',
    aud: 'https://oauth2.googleapis.com/token',
    exp: now + 3600,
    iat: now,
  }

  const key = await importPKCS8(serviceAccount.private_key)
  
  return await create(header, claim, key)
}

async function importPKCS8(pem: string): Promise<CryptoKey> {
  const pemHeader = '-----BEGIN PRIVATE KEY-----'
  const pemFooter = '-----END PRIVATE KEY-----'
  const pemContents = pem
    .replace(pemHeader, '')
    .replace(pemFooter, '')
    .replace(/\s/g, '')
  
  const binaryDer = Uint8Array.from(atob(pemContents), c => c.charCodeAt(0))
  
  return await crypto.subtle.importKey(
    'pkcs8',
    binaryDer.buffer,
    {
      name: 'RS256',
      hash: 'SHA-256',
    },
    false,
    ['sign']
  )
}
