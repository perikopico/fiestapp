// supabase/functions/_shared/smart-notification-sender.ts
// ============================================================================
// Módulo Común: "El Enviador Inteligente"
// ============================================================================
// 
// Abstracción centralizada para el envío de notificaciones FCM que:
// 1. Maneja horas de silencio (quiet hours)
// 2. Persiste en historial
// 3. Encola notificaciones pendientes si es necesario
// 4. Maneja tokens inválidos
// 5. Soporta envío directo (token) y por topic
//
// Uso:
//   import { SmartNotificationSender } from '../_shared/smart-notification-sender.ts'
//   const sender = new SmartNotificationSender(supabase, accessToken)
//   await sender.send({ title, body, data, target: { userId: '...' } })
// ============================================================================

import { SupabaseClient } from 'https://esm.sh/@supabase/supabase-js@2'

// ============================================================================
// TIPOS
// ============================================================================

export interface NotificationTarget {
  userId?: string
  topic?: string
  fcmToken?: string // Token específico (opcional, para envío directo)
}

export interface NotificationPayload {
  title: string
  body: string
  data?: Record<string, any>
  notificationType: string
  eventId?: string
  priority?: number // 0=normal, 1=alta, 2=urgente
}

export interface SendNotificationOptions extends NotificationPayload {
  target: NotificationTarget
  skipQuietHours?: boolean // Forzar envío incluso en quiet hours
  scheduledFor?: Date // Programar para más tarde
}

export interface SendResult {
  success: boolean
  notificationId?: string // ID en notifications_history
  pendingId?: string // ID en pending_notifications (si fue encolada)
  fcmMessageId?: string
  error?: string
  wasQueued?: boolean // true si fue encolada por quiet hours
}

// ============================================================================
// CONFIGURACIÓN DE QUIET HOURS
// ============================================================================

const QUIET_HOURS_START = 22 // 22:00 (10 PM)
const QUIET_HOURS_END = 8 // 08:00 (8 AM)

function isQuietHours(): boolean {
  const now = new Date()
  const hour = now.getHours()
  
  // Si está entre las 22:00 y las 23:59, o entre las 00:00 y las 07:59
  return hour >= QUIET_HOURS_START || hour < QUIET_HOURS_END
}

function getNextQuietHoursEnd(): Date {
  const now = new Date()
  const nextEnd = new Date(now)
  
  if (now.getHours() >= QUIET_HOURS_START) {
    // Ya estamos en quiet hours, el siguiente fin es mañana a las 08:00
    nextEnd.setDate(nextEnd.getDate() + 1)
    nextEnd.setHours(QUIET_HOURS_END, 0, 0, 0)
  } else {
    // Aún no estamos en quiet hours, el siguiente fin es hoy a las 08:00
    // (pero si ya pasó, será mañana)
    nextEnd.setHours(QUIET_HOURS_END, 0, 0, 0)
    if (nextEnd <= now) {
      nextEnd.setDate(nextEnd.getDate() + 1)
    }
  }
  
  return nextEnd
}

// ============================================================================
// CLASE PRINCIPAL
// ============================================================================

export class SmartNotificationSender {
  private supabase: SupabaseClient
  private accessToken: string
  private firebaseProjectId: string

  constructor(
    supabase: SupabaseClient,
    accessToken: string,
    firebaseProjectId: string
  ) {
    this.supabase = supabase
    this.accessToken = accessToken
    this.firebaseProjectId = firebaseProjectId
  }

  // ==========================================================================
  // MÉTODO PRINCIPAL: send()
  // ==========================================================================
  
  async send(options: SendNotificationOptions): Promise<SendResult> {
    const {
      title,
      body,
      data = {},
      notificationType,
      eventId,
      target,
      skipQuietHours = false,
      scheduledFor,
      priority = 0
    } = options

    // Validación
    if (!target.userId && !target.topic) {
      return {
        success: false,
        error: 'Target must have either userId or topic'
      }
    }

    // Si hay una fecha programada explícita, encolar directamente
    if (scheduledFor) {
      return await this.queueNotification({
        title,
        body,
        data,
        notificationType,
        eventId,
        target,
        scheduledFor,
        priority
      })
    }

    // Verificar quiet hours (a menos que se fuerce el envío)
    if (!skipQuietHours && isQuietHours()) {
      const nextEnd = getNextQuietHoursEnd()
      console.log(`🔕 Quiet hours activas. Encolando notificación para ${nextEnd.toISOString()}`)
      
      return await this.queueNotification({
        title,
        body,
        data,
        notificationType,
        eventId,
        target,
        scheduledFor: nextEnd,
        priority
      })
    }

    // Enviar inmediatamente
    return await this.sendImmediate({
      title,
      body,
      data,
      notificationType,
      eventId,
      target,
      priority
    })
  }

  // ==========================================================================
  // ENVÍO INMEDIATO
  // ==========================================================================

  private async sendImmediate(options: {
    title: string
    body: string
    data: Record<string, any>
    notificationType: string
    eventId?: string
    target: NotificationTarget
    priority: number
  }): Promise<SendResult> {
    const { title, body, data, notificationType, eventId, target } = options

    try {
      // Enviar a FCM
      const fcmResult = await this.sendToFCM({
        title,
        body,
        data,
        target
      })

      if (!fcmResult.success) {
        // Si falla, intentar encolar para retry
        if (fcmResult.shouldRetry) {
          const nextRetry = new Date(Date.now() + 5 * 60 * 1000) // 5 minutos
          return await this.queueNotification({
            title,
            body,
            data,
            notificationType,
            eventId,
            target,
            scheduledFor: nextRetry,
            priority: options.priority + 1 // Aumentar prioridad
          })
        }

        // Error fatal, guardar en historial con estado failed
        const historyId = await this.saveToHistory({
          title,
          body,
          data,
          notificationType,
          eventId,
          target,
          deliveryStatus: 'failed',
          errorMessage: fcmResult.error
        })

        return {
          success: false,
          notificationId: historyId,
          error: fcmResult.error
        }
      }

      // Guardar en historial con estado sent
      const historyId = await this.saveToHistory({
        title,
        body,
        data,
        notificationType,
        eventId,
        target,
        deliveryStatus: 'sent',
        fcmMessageId: fcmResult.messageId,
        fcmToken: target.fcmToken
      })

      // Si hay tokens inválidos, eliminarlos
      if (fcmResult.invalidTokens && fcmResult.invalidTokens.length > 0) {
        await this.cleanupInvalidTokens(fcmResult.invalidTokens)
      }

      return {
        success: true,
        notificationId: historyId,
        fcmMessageId: fcmResult.messageId
      }
    } catch (error) {
      console.error('Error en sendImmediate:', error)
      
      const historyId = await this.saveToHistory({
        title,
        body,
        data,
        notificationType,
        eventId,
        target,
        deliveryStatus: 'failed',
        errorMessage: error instanceof Error ? error.message : String(error)
      })

      return {
        success: false,
        notificationId: historyId,
        error: error instanceof Error ? error.message : String(error)
      }
    }
  }

  // ==========================================================================
  // ENCOLAR NOTIFICACIÓN
  // ==========================================================================

  private async queueNotification(options: {
    title: string
    body: string
    data: Record<string, any>
    notificationType: string
    eventId?: string
    target: NotificationTarget
    scheduledFor: Date
    priority: number
  }): Promise<SendResult> {
    const { title, body, data, notificationType, eventId, target, scheduledFor, priority } = options

    try {
      const { data: pending, error } = await this.supabase
        .from('pending_notifications')
        .insert({
          user_id: target.userId || null,
          topic_name: target.topic || null,
          title,
          body,
          data,
          notification_type: notificationType,
          event_id: eventId || null,
          scheduled_for: scheduledFor.toISOString(),
          priority,
          fcm_token: target.fcmToken || null,
          status: 'pending'
        })
        .select('id')
        .single()

      if (error) {
        console.error('Error encolando notificación:', error)
        return {
          success: false,
          error: `Failed to queue notification: ${error.message}`
        }
      }

      console.log(`✅ Notificación encolada (ID: ${pending.id}) para ${scheduledFor.toISOString()}`)

      return {
        success: true,
        pendingId: pending.id,
        wasQueued: true
      }
    } catch (error) {
      console.error('Error en queueNotification:', error)
      return {
        success: false,
        error: error instanceof Error ? error.message : String(error)
      }
    }
  }

  // ==========================================================================
  // ENVÍO A FCM
  // ==========================================================================

  private async sendToFCM(options: {
    title: string
    body: string
    data: Record<string, any>
    target: NotificationTarget
  }): Promise<{
    success: boolean
    messageId?: string
    error?: string
    shouldRetry?: boolean
    invalidTokens?: string[]
  }> {
    const { title, body, data, target } = options

    const fcmUrl = `https://fcm.googleapis.com/v1/projects/${this.firebaseProjectId}/messages:send`

    // Construir mensaje según el tipo de target
    let message: any

    if (target.topic) {
      // Envío por topic
      message = {
        message: {
          topic: target.topic,
          notification: {
            title,
            body
          },
          data: this.serializeData(data),
          android: {
            priority: 'high'
          },
          apns: {
            headers: {
              'apns-priority': '10'
            }
          }
        }
      }
    } else if (target.fcmToken) {
      // Envío directo por token
      message = {
        message: {
          token: target.fcmToken,
          notification: {
            title,
            body
          },
          data: this.serializeData(data),
          android: {
            priority: 'high'
          },
          apns: {
            headers: {
              'apns-priority': '10'
            }
          }
        }
      }
    } else if (target.userId) {
      // Obtener tokens del usuario
      const tokens = await this.getUserTokens(target.userId)
      
      if (tokens.length === 0) {
        return {
          success: false,
          error: 'No FCM tokens found for user',
          shouldRetry: false
        }
      }

      // Enviar al primer token (o implementar batching si hay muchos)
      message = {
        message: {
          token: tokens[0],
          notification: {
            title,
            body
          },
          data: this.serializeData(data),
          android: {
            priority: 'high'
          },
          apns: {
            headers: {
              'apns-priority': '10'
            }
          }
        }
      }
    } else {
      return {
        success: false,
        error: 'Invalid target',
        shouldRetry: false
      }
    }

    try {
      const response = await fetch(fcmUrl, {
        method: 'POST',
        headers: {
          'Authorization': `Bearer ${this.accessToken}`,
          'Content-Type': 'application/json'
        },
        body: JSON.stringify(message)
      })

      const responseData = await response.json()

      if (!response.ok) {
        const error = responseData.error || 'Unknown FCM error'
        const shouldRetry = response.status >= 500 // Retry en errores de servidor
        
        // Detectar tokens inválidos
        const invalidTokens: string[] = []
        if (error.errorCode === 'UNREGISTERED' && target.fcmToken) {
          invalidTokens.push(target.fcmToken)
        }

        return {
          success: false,
          error: `FCM error: ${error.message || JSON.stringify(error)}`,
          shouldRetry,
          invalidTokens
        }
      }

      return {
        success: true,
        messageId: responseData.name // FCM message ID
      }
    } catch (error) {
      return {
        success: false,
        error: error instanceof Error ? error.message : String(error),
        shouldRetry: true
      }
    }
  }

  // ==========================================================================
  // GUARDAR EN HISTORIAL
  // ==========================================================================

  private async saveToHistory(options: {
    title: string
    body: string
    data: Record<string, any>
    notificationType: string
    eventId?: string
    target: NotificationTarget
    deliveryStatus: 'sent' | 'delivered' | 'failed' | 'pending'
    fcmMessageId?: string
    fcmToken?: string
    errorMessage?: string
  }): Promise<string> {
    const {
      title,
      body,
      data,
      notificationType,
      eventId,
      target,
      deliveryStatus,
      fcmMessageId,
      fcmToken,
      errorMessage
    } = options

    const { data: history, error } = await this.supabase
      .from('notifications_history')
      .insert({
        user_id: target.userId || null,
        topic_name: target.topic || null,
        title,
        body,
        data,
        notification_type: notificationType,
        event_id: eventId || null,
        delivery_status: deliveryStatus,
        fcm_message_id: fcmMessageId || null,
        fcm_token: fcmToken || null,
        error_message: errorMessage || null,
        sent_at: new Date().toISOString()
      })
      .select('id')
      .single()

    if (error) {
      console.error('Error guardando en historial:', error)
      throw new Error(`Failed to save to history: ${error.message}`)
    }

    return history.id
  }

  // ==========================================================================
  // UTILIDADES
  // ==========================================================================

  private async getUserTokens(userId: string): Promise<string[]> {
    const { data, error } = await this.supabase
      .from('user_fcm_tokens')
      .select('token')
      .eq('user_id', userId)

    if (error || !data) {
      console.error('Error obteniendo tokens:', error)
      return []
    }

    return data.map(row => row.token)
  }

  private async cleanupInvalidTokens(tokens: string[]): Promise<void> {
    if (tokens.length === 0) return

    const { error } = await this.supabase
      .from('user_fcm_tokens')
      .delete()
      .in('token', tokens)

    if (error) {
      console.error('Error eliminando tokens inválidos:', error)
    } else {
      console.log(`🗑️ Eliminados ${tokens.length} tokens inválidos`)
    }
  }

  private serializeData(data: Record<string, any>): Record<string, string> {
    const serialized: Record<string, string> = {}
    for (const [key, value] of Object.entries(data)) {
      serialized[key] = typeof value === 'string' ? value : JSON.stringify(value)
    }
    return serialized
  }
}
