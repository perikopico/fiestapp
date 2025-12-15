// supabase/functions/cleanup_deleted_users/index.ts
// Edge Function para eliminar definitivamente usuarios de auth.users
// que están marcados como eliminados en deleted_users
// 
// Esta función puede ejecutarse manualmente o programarse con un cron job

import { serve } from "https://deno.land/std@0.168.0/http/server.ts"
import { createClient } from 'https://esm.sh/@supabase/supabase-js@2'

serve(async (req) => {
  // CORS headers
  if (req.method === 'OPTIONS') {
    return new Response(null, {
      headers: {
        'Access-Control-Allow-Origin': '*',
        'Access-Control-Allow-Methods': 'POST, GET',
        'Access-Control-Allow-Headers': 'authorization, x-client-info, apikey, content-type',
      },
    })
  }

  try {
    // Verificar autenticación (solo admin puede ejecutar esto)
    const authHeader = req.headers.get('Authorization')
    if (!authHeader) {
      return new Response(
        JSON.stringify({ error: 'Missing authorization header' }),
        { 
          status: 401, 
          headers: { 
            'Content-Type': 'application/json',
            'Access-Control-Allow-Origin': '*',
          } 
        }
      )
    }

    // Crear cliente con Service Role Key para usar Admin API
    const supabaseAdmin = createClient(
      Deno.env.get('SUPABASE_URL') ?? '',
      Deno.env.get('SUPABASE_SERVICE_ROLE_KEY') ?? '',
      {
        auth: {
          autoRefreshToken: false,
          persistSession: false
        }
      }
    )

    if (!Deno.env.get('SUPABASE_SERVICE_ROLE_KEY')) {
      return new Response(
        JSON.stringify({ 
          error: 'Service Role Key not configured',
          hint: 'Configure SUPABASE_SERVICE_ROLE_KEY in Supabase Edge Function secrets'
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

    // Obtener parámetros opcionales
    const url = new URL(req.url)
    const daysOld = parseInt(url.searchParams.get('days') || '7') // Por defecto, usuarios eliminados hace 7+ días
    const limit = parseInt(url.searchParams.get('limit') || '100') // Por defecto, máximo 100 usuarios por ejecución

    console.log(`🧹 Limpiando usuarios eliminados hace ${daysOld}+ días (máximo ${limit} usuarios)`)

    // Obtener usuarios marcados como eliminados
    const cutoffDate = new Date()
    cutoffDate.setDate(cutoffDate.getDate() - daysOld)

    const { data: deletedUsers, error: fetchError } = await supabaseAdmin
      .from('deleted_users')
      .select('user_id, email, deleted_at')
      .lt('deleted_at', cutoffDate.toISOString())
      .limit(limit)

    if (fetchError) {
      console.error('Error al obtener usuarios eliminados:', fetchError)
      return new Response(
        JSON.stringify({ 
          error: 'Failed to fetch deleted users', 
          details: fetchError.message 
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

    if (!deletedUsers || deletedUsers.length === 0) {
      return new Response(
        JSON.stringify({ 
          success: true, 
          message: 'No hay usuarios para eliminar',
          deleted: 0
        }),
        { 
          status: 200, 
          headers: { 
            'Content-Type': 'application/json',
            'Access-Control-Allow-Origin': '*',
          } 
        }
      )
    }

    console.log(`📋 Encontrados ${deletedUsers.length} usuarios para eliminar`)

    // Eliminar usuarios de auth.users
    const deleted: string[] = []
    const errors: Array<{user_id: string, error: string}> = []

    for (const deletedUser of deletedUsers) {
      try {
        const { error: deleteError } = await supabaseAdmin.auth.admin.deleteUser(deletedUser.user_id)
        
        if (deleteError) {
          console.error(`Error al eliminar usuario ${deletedUser.user_id}:`, deleteError)
          errors.push({
            user_id: deletedUser.user_id,
            error: deleteError.message
          })
        } else {
          console.log(`✅ Usuario eliminado: ${deletedUser.email} (${deletedUser.user_id})`)
          deleted.push(deletedUser.user_id)
          
          // Eliminar de deleted_users después de eliminar de auth.users
          await supabaseAdmin
            .from('deleted_users')
            .delete()
            .eq('user_id', deletedUser.user_id)
        }
      } catch (e) {
        console.error(`Error al procesar usuario ${deletedUser.user_id}:`, e)
        errors.push({
          user_id: deletedUser.user_id,
          error: e.message || String(e)
        })
      }
    }

    return new Response(
      JSON.stringify({ 
        success: true,
        message: `Procesados ${deletedUsers.length} usuarios`,
        deleted: deleted.length,
        errors: errors.length,
        deleted_user_ids: deleted,
        errors_details: errors
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
      JSON.stringify({ error: error.message || 'Internal server error' }),
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

