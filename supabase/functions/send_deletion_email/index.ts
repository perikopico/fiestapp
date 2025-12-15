// supabase/functions/send_deletion_email/index.ts
// Edge Function para enviar email de confirmación de eliminación de cuenta
// Incluye toda la información legal necesaria (RGPD)

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

    // Parsear request
    const { user_id, email, deletion_date } = await req.json()

    if (!user_id || !email) {
      return new Response(
        JSON.stringify({ error: 'Missing required fields: user_id, email' }),
        { 
          status: 400, 
          headers: { 
            'Content-Type': 'application/json',
            'Access-Control-Allow-Origin': '*',
          } 
        }
      )
    }

    const deletionDate = deletion_date || new Date().toISOString()
    const formattedDate = new Date(deletionDate).toLocaleDateString('es-ES', {
      year: 'numeric',
      month: 'long',
      day: 'numeric',
      hour: '2-digit',
      minute: '2-digit'
    })

    // Plantilla de email HTML con información legal completa
    const emailHtml = `
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Confirmación de Eliminación de Cuenta - QuePlan</title>
    <style>
        body {
            font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, Oxygen, Ubuntu, Cantarell, sans-serif;
            line-height: 1.6;
            color: #333;
            max-width: 600px;
            margin: 0 auto;
            padding: 20px;
            background-color: #f5f5f5;
        }
        .container {
            background-color: #ffffff;
            border-radius: 8px;
            padding: 30px;
            box-shadow: 0 2px 4px rgba(0,0,0,0.1);
        }
        .header {
            text-align: center;
            margin-bottom: 30px;
            padding-bottom: 20px;
            border-bottom: 2px solid #0175C2;
        }
        .header h1 {
            color: #0175C2;
            margin: 0;
            font-size: 24px;
        }
        .content {
            margin-bottom: 30px;
        }
        .section {
            margin-bottom: 25px;
        }
        .section h2 {
            color: #0175C2;
            font-size: 18px;
            margin-bottom: 10px;
            border-bottom: 1px solid #e0e0e0;
            padding-bottom: 5px;
        }
        .section p {
            margin: 10px 0;
            color: #555;
        }
        .section ul {
            margin: 10px 0;
            padding-left: 20px;
        }
        .section li {
            margin: 5px 0;
            color: #555;
        }
        .highlight {
            background-color: #fff3cd;
            border-left: 4px solid #ffc107;
            padding: 15px;
            margin: 20px 0;
            border-radius: 4px;
        }
        .info-box {
            background-color: #e7f3ff;
            border-left: 4px solid #0175C2;
            padding: 15px;
            margin: 20px 0;
            border-radius: 4px;
        }
        .footer {
            margin-top: 30px;
            padding-top: 20px;
            border-top: 1px solid #e0e0e0;
            text-align: center;
            color: #666;
            font-size: 12px;
        }
        .footer a {
            color: #0175C2;
            text-decoration: none;
        }
    </style>
</head>
<body>
    <div class="container">
        <div class="header">
            <h1>🗑️ Confirmación de Eliminación de Cuenta</h1>
        </div>
        
        <div class="content">
            <p>Estimado/a usuario/a,</p>
            
            <p>Le confirmamos que su solicitud de eliminación de cuenta ha sido procesada correctamente.</p>
            
            <div class="highlight">
                <strong>Fecha de eliminación:</strong> ${formattedDate}<br>
                <strong>Email de la cuenta:</strong> ${email}
            </div>

            <div class="section">
                <h2>📋 Datos Eliminados</h2>
                <p>Hemos eliminado de forma permanente los siguientes datos personales:</p>
                <ul>
                    <li>Datos de perfil y preferencias</li>
                    <li>Favoritos guardados</li>
                    <li>Consentimientos de privacidad</li>
                    <li>Tokens de notificaciones push</li>
                    <li>Eventos creados por usted (anonimizados)</li>
                    <li>Todos los datos asociados a su cuenta</li>
                </ul>
            </div>

            <div class="section">
                <h2>⏱️ Período de Retención</h2>
                <p>Su cuenta de autenticación será eliminada definitivamente de nuestros sistemas en un plazo de <strong>7 días</strong> desde la fecha de eliminación.</p>
                <p>Durante este período, sus datos personales ya han sido eliminados, pero mantenemos un registro técnico mínimo para fines de seguridad y cumplimiento legal.</p>
            </div>

            <div class="section">
                <h2>🔒 Derechos RGPD</h2>
                <p>De acuerdo con el Reglamento General de Protección de Datos (RGPD), usted tiene derecho a:</p>
                <ul>
                    <li><strong>Confirmación:</strong> Confirmar que sus datos han sido eliminados</li>
                    <li><strong>Información:</strong> Recibir información sobre qué datos se han eliminado</li>
                    <li><strong>Derecho al Olvido:</strong> Sus datos personales han sido eliminados permanentemente</li>
                </ul>
            </div>

            <div class="info-box">
                <strong>⚠️ Importante:</strong> Una vez completada la eliminación definitiva (después de 7 días), no podrá recuperar su cuenta ni los datos asociados. Esta acción es irreversible.
            </div>

            <div class="section">
                <h2>❓ ¿Fue un Error?</h2>
                <p>Si solicitó la eliminación por error y desea recuperar su cuenta, debe contactarnos <strong>dentro de los próximos 7 días</strong> a:</p>
                <p style="text-align: center; margin: 15px 0;">
                    <strong>Email:</strong> <a href="mailto:info@queplan-app.com">info@queplan-app.com</a>
                </p>
                <p>Después de este período, la eliminación será definitiva e irreversible.</p>
            </div>

            <div class="section">
                <h2>📧 Contacto</h2>
                <p>Si tiene preguntas sobre esta eliminación o sobre el tratamiento de sus datos personales, puede contactarnos:</p>
                <ul>
                    <li><strong>Email:</strong> info@queplan-app.com</li>
                    <li><strong>Política de Privacidad:</strong> <a href="https://queplan-app.com/privacy">https://queplan-app.com/privacy</a></li>
                    <li><strong>Términos y Condiciones:</strong> <a href="https://queplan-app.com/terms">https://queplan-app.com/terms</a></li>
                </ul>
            </div>
        </div>
        
        <div class="footer">
            <p>Este es un email automático de confirmación. Por favor, no responda a este mensaje.</p>
            <p>© ${new Date().getFullYear()} QuePlan. Todos los derechos reservados.</p>
            <p>
                <a href="https://queplan-app.com/privacy">Política de Privacidad</a> | 
                <a href="https://queplan-app.com/terms">Términos y Condiciones</a>
            </p>
        </div>
    </div>
</body>
</html>
    `

    const emailSubject = 'Confirmación de Eliminación de Cuenta - QuePlan'
    const RESEND_API_KEY = Deno.env.get('RESEND_API_KEY')
    
    // Intentar enviar usando Resend (recomendado) o Supabase SMTP
    if (RESEND_API_KEY) {
      // Usar Resend API para enviar el email
      try {
        const resendResponse = await fetch('https://api.resend.com/emails', {
          method: 'POST',
          headers: {
            'Authorization': `Bearer ${RESEND_API_KEY}`,
            'Content-Type': 'application/json',
          },
          body: JSON.stringify({
            from: 'QuePlan <noreply@queplan-app.com>',
            to: [email],
            subject: emailSubject,
            html: emailHtml,
          }),
        })

        const resendData = await resendResponse.json()

        if (!resendResponse.ok) {
          console.error('Error al enviar email con Resend:', resendData)
          throw new Error(`Resend API error: ${JSON.stringify(resendData)}`)
        }

        console.log(`✅ Email de eliminación enviado a ${email} usando Resend`)
        
        return new Response(
          JSON.stringify({ 
            success: true,
            message: 'Email de eliminación enviado correctamente',
            email: email,
            resend_id: resendData.id
          }),
          { 
            status: 200, 
            headers: { 
              'Content-Type': 'application/json',
              'Access-Control-Allow-Origin': '*',
            } 
          }
        )
      } catch (resendError) {
        console.error('Error con Resend, intentando Supabase SMTP:', resendError)
        // Continuar con Supabase SMTP como fallback
      }
    }

    // Fallback: Sin Resend configurado
    // NOTA: Supabase Edge Functions NO pueden usar SMTP directamente (puertos bloqueados)
    // Para enviar emails personalizados desde Edge Functions, necesitas usar una API como Resend
    // El SMTP configurado en Supabase solo funciona para emails del sistema (confirmación, reset, etc.)
    
    console.log(`⚠️ RESEND_API_KEY no configurado`)
    console.log(`📧 Email de eliminación preparado para: ${email}`)
    console.log(`💡 Para enviar emails personalizados desde Edge Functions, configura RESEND_API_KEY`)
    console.log(`💡 El SMTP de Supabase solo funciona para emails del sistema, no para emails personalizados desde Edge Functions`)
    
    return new Response(
      JSON.stringify({ 
        success: false,
        message: 'Email no enviado: RESEND_API_KEY no configurado',
        email: email,
        subject: emailSubject,
        html: emailHtml,
        note: 'Las Edge Functions no pueden usar SMTP directamente. Configura RESEND_API_KEY en secrets para enviar emails personalizados.'
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

