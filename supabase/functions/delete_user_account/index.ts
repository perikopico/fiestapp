// supabase/functions/delete_user_account/index.ts
// Edge Function para eliminar completamente un usuario de auth.users usando Admin API
// Esto es necesario para cumplir con RGPD (Derecho al Olvido)

import { serve } from "https://deno.land/std@0.168.0/http/server.ts"
import { createClient } from 'https://esm.sh/@supabase/supabase-js@2'

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

    // Verificar que las credenciales estén configuradas
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

    // Obtener el token de autorización del request
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

    // Verificar el usuario autenticado usando el token
    const token = authHeader.replace('Bearer ', '')
    const { data: { user }, error: userError } = await supabaseAdmin.auth.getUser(token)

    if (userError || !user) {
      return new Response(
        JSON.stringify({ error: 'Invalid or expired token', details: userError?.message }),
        { 
          status: 401, 
          headers: { 
            'Content-Type': 'application/json',
            'Access-Control-Allow-Origin': '*',
          } 
        }
      )
    }

    // Parsear el body del request (opcional, por si se quiere especificar otro user_id)
    let userIdToDelete = user.id
    try {
      const body = await req.json()
      if (body.user_id && body.user_id !== user.id) {
        // Solo permitir eliminar la propia cuenta por seguridad
        return new Response(
          JSON.stringify({ error: 'You can only delete your own account' }),
          { 
            status: 403, 
            headers: { 
              'Content-Type': 'application/json',
              'Access-Control-Allow-Origin': '*',
            } 
          }
        )
      }
      // Si se especifica user_id y es el mismo, está bien
      if (body.user_id) {
        userIdToDelete = body.user_id
      }
    } catch {
      // Si no hay body, usar el usuario autenticado
    }

    // Verificar que el usuario solo puede eliminar su propia cuenta
    if (userIdToDelete !== user.id) {
      return new Response(
        JSON.stringify({ error: 'You can only delete your own account' }),
        { 
          status: 403, 
          headers: { 
            'Content-Type': 'application/json',
            'Access-Control-Allow-Origin': '*',
          } 
        }
      )
    }

    console.log(`🗑️ Eliminando usuario: ${userIdToDelete} (${user.email})`)

    // Eliminar el usuario usando Admin API
    const { error: deleteError } = await supabaseAdmin.auth.admin.deleteUser(userIdToDelete)

    if (deleteError) {
      console.error('Error al eliminar usuario:', deleteError)
      return new Response(
        JSON.stringify({ 
          error: 'Failed to delete user', 
          details: deleteError.message 
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

    console.log(`✅ Usuario ${userIdToDelete} eliminado exitosamente`)

    return new Response(
      JSON.stringify({ 
        success: true, 
        message: 'User account deleted successfully',
        user_id: userIdToDelete
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

