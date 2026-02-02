// supabase/functions/handle-event-update/index.ts
// Edge Function Webhook para manejar actualizaciones de eventos
// 
// Maneja dos escenarios:
// 1. Cambios críticos en eventos (fecha, hora, lugar, estado cancelado)
// 2. Nuevos eventos publicados (status: pending -> published)
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

    // Parsear el payload del webhook
    const payload = await req.json()
    const { type, table, record, old_record } = payload

    if (type !== 'UPDATE' || table !== 'events') {
      return new Response(
        JSON.stringify({ 
          success: true, 
          message: 'Not an event update, skipping' 
        }),
        { status: 200, headers: { 'Content-Type': 'application/json' } }
      )
    }

    const eventId = record.id
    const oldStatus = old_record?.status
    const newStatus = record.status
    const oldStartsAt = old_record?.starts_at
    const newStartsAt = record.starts_at
    const oldPlace = old_record?.place
    const newPlace = record.place
    const oldVenueId = old_record?.venue_id
    const newVenueId = record.venue_id

    console.log(`📝 Evento ${eventId} actualizado`)

    // ESCENARIO 3: Nuevo evento publicado (pending -> published)
    if (oldStatus === 'pending' && newStatus === 'published') {
      console.log(`✅ Nuevo evento publicado: ${eventId}`)
      await handleNewEventPublished(supabase, record)
      return new Response(
        JSON.stringify({ 
          success: true, 
          scenario: 'new_event_published',
          event_id: eventId 
        }),
        { status: 200, headers: { 'Content-Type': 'application/json' } }
      )
    }

    // ESCENARIO 2: Cambio crítico en evento existente
    const hasCriticalChange = 
      oldStartsAt !== newStartsAt || // Fecha/hora cambiada
      oldPlace !== newPlace || // Lugar cambiado
      oldVenueId !== newVenueId || // Venue cambiado
      (oldStatus !== 'cancelled' && newStatus === 'cancelled') // Cancelado

    if (hasCriticalChange && newStatus === 'published') {
      console.log(`⚠️ Cambio crítico detectado en evento ${eventId}`)
      await handleCriticalEventChange(supabase, record, old_record)
      return new Response(
        JSON.stringify({ 
          success: true, 
          scenario: 'critical_change',
          event_id: eventId 
        }),
        { status: 200, headers: { 'Content-Type': 'application/json' } }
      )
    }

    // No hay cambios críticos, no hacer nada
    return new Response(
      JSON.stringify({ 
        success: true, 
        message: 'No critical changes detected, skipping notification' 
      }),
      { status: 200, headers: { 'Content-Type': 'application/json' } }
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

// ESCENARIO 3: Manejar nuevo evento publicado
async function handleNewEventPublished(supabase: any, event: any) {
  try {
    // Obtener información de la ciudad del evento
    // Asumiendo que tenemos city_id o city_name en el evento
    // Si no está directamente, necesitaríamos hacer JOIN con cities
    const cityId = event.city_id
    const cityName = event.city_name

    if (!cityId && !cityName) {
      console.log('⚠️ Evento sin ciudad, no se puede enviar notificación por topic')
      return
    }

    // Normalizar nombre de ciudad para el topic
    // Los topics de FCM solo permiten: [a-zA-Z0-9-_.~%]
    const normalizedCityName = (cityName || `city_${cityId}`)
      .toLowerCase()
      .replace(/[^a-z0-9]/g, '_')
      .replace(/_+/g, '_')
      .replace(/^_|_$/g, '')
    
    const topic = `city_${normalizedCityName}`
    
    console.log(`📢 Enviando notificación al topic: ${topic}`)

    const serviceAccount = JSON.parse(FIREBASE_SERVICE_ACCOUNT_KEY)
    const accessToken = await getAccessToken(serviceAccount)

    const fcmUrl = `https://fcm.googleapis.com/v1/projects/${FIREBASE_PROJECT_ID}/messages:send`
    
    const message = {
      message: {
        topic: topic,
        notification: {
          title: `¡Nuevo plan en ${cityName || 'tu ciudad'}! 🌊`,
          body: `"${event.title}" acaba de publicarse. ¡Échale un vistazo!`,
        },
        data: {
          view: 'event_detail',
          id: event.id,
          type: 'new_event_in_city',
          city_id: String(cityId || ''),
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
      throw new Error(`FCM API Error: ${errorText}`)
    }

    const responseData = await response.json()
    const messageId = responseData.name || null

    // Guardar en historial (notificación por topic)
    await saveTopicNotificationToHistory(
      supabase,
      topic,
      `¡Nuevo plan en ${cityName || 'tu ciudad'}! 🌊`,
      `"${event.title}" acaba de publicarse. ¡Échale un vistazo!`,
      {
        view: 'event_detail',
        id: event.id,
        type: 'new_event_in_city',
        city_id: String(cityId || ''),
      },
      'new_event',
      event.id,
      messageId
    )

    console.log(`✅ Notificación enviada al topic ${topic}`)
  } catch (error) {
    console.error('Error en handleNewEventPublished:', error)
    throw error
  }
}

// ESCENARIO 2: Manejar cambio crítico en evento
async function handleCriticalEventChange(supabase: any, newEvent: any, oldEvent: any) {
  try {
    const eventId = newEvent.id
    const eventTitle = newEvent.title

    // Obtener usuarios que tienen este evento en favoritos
    const { data: favorites, error: favoritesError } = await supabase
      .from('user_favorites')
      .select('user_id')
      .eq('event_id', eventId)

    if (favoritesError) {
      throw new Error(`Error fetching favorites: ${favoritesError.message}`)
    }

    if (!favorites || favorites.length === 0) {
      console.log(`⚠️ Evento ${eventId} no tiene favoritos, no se enviará notificación`)
      return
    }

    const userIds = favorites.map(f => f.user_id)
    console.log(`❤️ Evento "${eventTitle}" tiene ${userIds.length} usuarios favoritos`)

    // Obtener tokens FCM de esos usuarios
    const { data: tokens, error: tokensError } = await supabase
      .from('user_fcm_tokens')
      .select('token, user_id')
      .in('user_id', userIds)

    if (tokensError) {
      throw new Error(`Error fetching tokens: ${tokensError.message}`)
    }

    if (!tokens || tokens.length === 0) {
      console.log(`⚠️ No hay tokens FCM para usuarios con evento ${eventId} en favoritos`)
      return
    }

    console.log(`📱 Enviando alertas a ${tokens.length} tokens`)

    const serviceAccount = JSON.parse(FIREBASE_SERVICE_ACCOUNT_KEY)
    const accessToken = await getAccessToken(serviceAccount)

    const invalidTokens: string[] = []
    let notificationsSent = 0

    // Enviar notificación a cada token
    for (const tokenData of tokens) {
      try {
        const result = await sendFCMNotification(
          accessToken,
          tokenData.token,
          `⚠️ Cambio importante en "${eventTitle}"`,
          'Se ha modificado el horario o lugar. Revisa los detalles.',
          {
            click_action: 'FLUTTER_NOTIFICATION_CLICK',
            view: 'event_detail',
            id: eventId,
            type: 'event_critical_change',
          }
        )

        if (result.success) {
          notificationsSent++
          // Guardar en historial
          await saveNotificationToHistory(
            supabase,
            tokenData.user_id,
            `⚠️ Cambio importante en "${eventTitle}"`,
            'Se ha modificado el horario o lugar. Revisa los detalles.',
            {
              click_action: 'FLUTTER_NOTIFICATION_CLICK',
              view: 'event_detail',
              id: eventId,
              type: 'event_critical_change',
            },
            'critical_change',
            eventId,
            tokenData.token,
            result.messageId
          )
        } else if (result.invalidToken) {
          invalidTokens.push(tokenData.token)
        }
      } catch (error) {
        console.error(`Error sending notification to token ${tokenData.token.substring(0, 20)}...:`, error)
      }
    }

    // Eliminar tokens inválidos
    if (invalidTokens.length > 0) {
      console.log(`🗑️ Eliminando ${invalidTokens.length} tokens inválidos`)
      await supabase
        .from('user_fcm_tokens')
        .delete()
        .in('token', invalidTokens)
    }

    console.log(`✅ Enviadas ${notificationsSent} notificaciones de cambio crítico`)
  } catch (error) {
    console.error('Error en handleCriticalEventChange:', error)
    throw error
  }
}

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

// Función para guardar notificación por topic en historial
async function saveTopicNotificationToHistory(
  supabase: any,
  topicName: string,
  title: string,
  body: string,
  data: Record<string, any>,
  notificationType: string,
  eventId: string | null,
  fcmMessageId: string | null
) {
  try {
    await supabase
      .from('notifications_history')
      .insert({
        topic_name: topicName,
        title,
        body,
        data,
        notification_type: notificationType,
        event_id: eventId,
        fcm_message_id: fcmMessageId,
        delivery_status: 'sent',
        sent_at: new Date().toISOString(),
      })
  } catch (error) {
    console.error('Error guardando notificación por topic en historial:', error)
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
