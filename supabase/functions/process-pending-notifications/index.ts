// supabase/functions/process-pending-notifications/index.ts
// ============================================================================
// Edge Function CRON para procesar notificaciones pendientes
// ============================================================================
// 
// Ejecuta cada 5 minutos para procesar notificaciones en cola que:
// - Fueron encoladas durante quiet hours
// - Están programadas para enviarse ahora
// - Necesitan retry después de un fallo
//
// Configuración CRON: "*/5 * * * *" (cada 5 minutos)
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

    // Obtener notificaciones pendientes listas para procesar
    const { data: pendingNotifications, error: fetchError } = await supabase
      .rpc('get_pending_notifications_ready', { p_limit: 100 })

    if (fetchError) {
      console.error('Error obteniendo notificaciones pendientes:', fetchError)
      return new Response(
        JSON.stringify({ error: 'Error fetching pending notifications', details: fetchError }),
        { status: 500, headers: { 'Content-Type': 'application/json' } }
      )
    }

    if (!pendingNotifications || pendingNotifications.length === 0) {
      console.log('✅ No hay notificaciones pendientes para procesar')
      return new Response(
        JSON.stringify({ 
          success: true, 
          message: 'No pending notifications',
          processed: 0
        }),
        { status: 200, headers: { 'Content-Type': 'application/json' } }
      )
    }

    console.log(`📬 Procesando ${pendingNotifications.length} notificaciones pendientes`)

    // Inicializar sender
    const sender = new SmartNotificationSender(supabase, accessToken, FIREBASE_PROJECT_ID)

    let processed = 0
    let succeeded = 0
    let failed = 0
    const errors: string[] = []

    // Procesar cada notificación
    for (const pending of pendingNotifications) {
      try {
        // Marcar como procesando
        await supabase
          .from('pending_notifications')
          .update({ 
            status: 'processing',
            updated_at: new Date().toISOString()
          })
          .eq('id', pending.id)

        // Construir target
        const target: any = {}
        if (pending.user_id) {
          target.userId = pending.user_id
        }
        if (pending.topic_name) {
          target.topic = pending.topic_name
        }
        if (pending.fcm_token) {
          target.fcmToken = pending.fcm_token
        }

        // Enviar (forzar envío, saltando quiet hours ya que estamos procesando cola)
        const result = await sender.send({
          title: pending.title,
          body: pending.body,
          data: pending.data || {},
          notificationType: pending.notification_type,
          eventId: pending.event_id,
          target,
          skipQuietHours: true, // Forzar envío ya que estamos procesando cola
          priority: pending.priority || 0
        })

        if (result.success) {
          // Marcar como enviada y eliminar de cola
          await supabase
            .from('pending_notifications')
            .update({
              status: 'sent',
              processed_at: new Date().toISOString(),
              updated_at: new Date().toISOString()
            })
            .eq('id', pending.id)

          // Eliminar de cola (opcional, podemos mantener para auditoría)
          // await supabase.from('pending_notifications').delete().eq('id', pending.id)

          succeeded++
          console.log(`✅ Notificación ${pending.id} enviada exitosamente`)
        } else {
          // Incrementar retry count
          const newRetryCount = (pending.retry_count || 0) + 1
          const maxRetries = pending.max_retries || 3

          if (newRetryCount >= maxRetries) {
            // Máximo de reintentos alcanzado, marcar como fallida
            await supabase
              .from('pending_notifications')
              .update({
                status: 'failed',
                last_error: result.error || 'Max retries exceeded',
                processed_at: new Date().toISOString(),
                updated_at: new Date().toISOString()
              })
              .eq('id', pending.id)

            console.error(`❌ Notificación ${pending.id} falló después de ${maxRetries} intentos`)
            failed++
          } else {
            // Programar nuevo intento (exponencial backoff)
            const nextRetry = new Date(Date.now() + Math.pow(2, newRetryCount) * 60 * 1000)
            
            await supabase
              .from('pending_notifications')
              .update({
                status: 'pending',
                retry_count: newRetryCount,
                scheduled_for: nextRetry.toISOString(),
                last_error: result.error || 'Retry scheduled',
                updated_at: new Date().toISOString()
              })
              .eq('id', pending.id)

            console.log(`🔄 Notificación ${pending.id} programada para retry #${newRetryCount} en ${nextRetry.toISOString()}`)
          }

          errors.push(`Notification ${pending.id}: ${result.error}`)
        }

        processed++
      } catch (error) {
        console.error(`Error procesando notificación ${pending.id}:`, error)
        
        // Marcar como fallida
        await supabase
          .from('pending_notifications')
          .update({
            status: 'failed',
            last_error: error instanceof Error ? error.message : String(error),
            processed_at: new Date().toISOString(),
            updated_at: new Date().toISOString()
          })
          .eq('id', pending.id)

        failed++
        errors.push(`Notification ${pending.id}: ${error instanceof Error ? error.message : String(error)}`)
      }
    }

    return new Response(
      JSON.stringify({
        success: true,
        processed,
        succeeded,
        failed,
        errors: errors.length > 0 ? errors : undefined
      }),
      { status: 200, headers: { 'Content-Type': 'application/json' } }
    )
  } catch (error) {
    console.error('Error en process-pending-notifications:', error)
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
// FUNCIONES AUXILIARES (copiadas de otras Edge Functions)
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
