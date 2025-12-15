# 📧 SMTP vs Resend para Emails Personalizados

## ⚠️ Limitación Importante

**Supabase Edge Functions NO pueden usar SMTP directamente** debido a restricciones de red (puertos 25, 465, 587 bloqueados).

## 🔍 Diferencia entre SMTP y Resend

### SMTP en Supabase (Ya configurado)
- ✅ Funciona para **emails del sistema**:
  - Confirmación de registro
  - Reset de contraseña
  - Cambios de email
  - Notificaciones del sistema
- ❌ **NO funciona** para emails personalizados desde Edge Functions

### Resend API (Recomendado para Edge Functions)
- ✅ Funciona para **emails personalizados** desde Edge Functions
- ✅ API simple y confiable
- ✅ Mejor deliverability
- ✅ Plan gratuito disponible (100 emails/día)
- ✅ No requiere configuración de servidor

## 🚀 Solución Recomendada

### Opción 1: Usar Resend (Más Fácil)

1. **Crear cuenta en Resend**:
   - Ve a https://resend.com
   - Regístrate (gratis)
   - Verifica tu dominio (opcional pero recomendado)

2. **Obtener API Key**:
   - Settings → API Keys → Create
   - Copia la clave

3. **Añadir en Supabase**:
   - Edge Functions → Secrets
   - Añade: `RESEND_API_KEY` = tu clave

4. **Listo**: La función `send_deletion_email` usará Resend automáticamente

### Opción 2: Usar SendGrid (Alternativa)

Similar a Resend, pero con SendGrid:
- Crear cuenta en https://sendgrid.com
- Obtener API Key
- Añadir `SENDGRID_API_KEY` en secrets
- Modificar la función para usar SendGrid API

### Opción 3: Función SQL + Trigger (Más Complejo)

Crear una función SQL que se ejecute cuando se elimine un usuario y envíe el email usando el SMTP de Supabase. Esto requiere:
- Crear función SQL con `pg_notify`
- Configurar trigger en `deleted_users`
- Configurar webhook o función que escuche el evento

**No recomendado** por complejidad.

## ✅ Recomendación Final

**Usa Resend**:
- ✅ Más simple
- ✅ Mejor para Edge Functions
- ✅ Plan gratuito suficiente para empezar
- ✅ Ya está implementado en el código

El SMTP que tienes configurado seguirá funcionando para los emails del sistema de Supabase (confirmación, reset, etc.), pero para emails personalizados desde Edge Functions, Resend es la mejor opción.

---

**Última actualización**: Diciembre 2024

