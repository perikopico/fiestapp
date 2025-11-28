# Configuración de Emails y SMTP en Supabase

Esta guía explica cómo configurar los emails de confirmación y el SMTP en Supabase, y cuándo es necesario hacerlo.

## ⚡ Opción Rápida: Desactivar Confirmación de Email (Para Desarrollo)

**Cuándo usar**: Si estás en fase de desarrollo y quieres probar el registro sin configurar emails.

### Pasos:

1. Ve a tu proyecto en **Supabase Dashboard**
2. Navega a **Authentication > Settings**
3. Busca la sección **Email Auth**
4. **Desactiva** la opción:
   - ☐ **Enable email confirmations**

5. Guarda los cambios

**✅ Ventajas:**
- Puedes probar el registro e inicio de sesión inmediatamente
- No necesitas configurar SMTP
- Los usuarios pueden iniciar sesión sin confirmar email

**⚠️ Desventajas:**
- No es seguro para producción (cualquiera puede registrarse con emails falsos)
- Los usuarios no reciben confirmación de registro

---

## 📧 Opción Completa: Configurar SMTP y Confirmación de Email (Para Producción)

**Cuándo usar**: Cuando estés listo para lanzar la app a producción o cuando necesites enviar emails reales.

### ¿Por qué configurar SMTP?

Supabase tiene un servicio de email integrado con **límites**:
- Plan gratuito: ~4 emails por hora
- Plan Pro: más emails pero aún limitado
- Plan Enterprise: límites personalizados

Para producción, es recomendable usar tu propio servicio SMTP (Gmail, SendGrid, Mailgun, etc.) para:
- ✅ Mayor control
- ✅ Más confiabilidad
- ✅ Sin límites estrictos
- ✅ Emails personalizados con tu dominio

---

## 📋 Paso 1: Configurar SMTP en Supabase

### Opción A: Usar Gmail (Fácil y Gratis)

1. **Habilita la verificación en 2 pasos en tu cuenta de Gmail:**
   - Ve a tu cuenta de Google
   - Seguridad > Verificación en 2 pasos > Activar

2. **Genera una contraseña de aplicación:**
   - Ve a: https://myaccount.google.com/apppasswords
   - Selecciona "Correo" y "Otro (nombre personalizado)"
   - Escribe "Supabase FiestApp"
   - Copia la contraseña generada (16 caracteres)

3. **Configura en Supabase:**
   - Ve a **Settings > Auth > SMTP Settings**
   - Activa **Enable Custom SMTP**
   - Completa los campos:
     ```
     Sender email: tu-email@gmail.com
     Sender name: QuePlan (o el nombre que quieras)
     Host: smtp.gmail.com
     Port: 587
     Username: tu-email@gmail.com
     Password: [la contraseña de aplicación de 16 caracteres]
     Secure: ON (TLS)
     ```

4. **Haz clic en "Save"**

5. **Envía un email de prueba:**
   - Haz clic en "Send test email"
   - Verifica que llegue a tu bandeja de entrada

### Opción B: Usar SendGrid (Recomendado para Producción)

1. **Crea una cuenta en SendGrid:**
   - Ve a: https://sendgrid.com
   - Regístrate (tienen plan gratuito con 100 emails/día)

2. **Crea un API Key:**
   - Ve a Settings > API Keys
   - Crea una nueva clave con permisos "Mail Send"
   - Copia la clave

3. **Verifica tu dominio** (opcional pero recomendado):
   - Ve a Settings > Sender Authentication
   - Sigue las instrucciones para verificar tu dominio

4. **Configura en Supabase:**
   - Ve a **Settings > Auth > SMTP Settings**
   - Activa **Enable Custom SMTP**
   - Completa:
     ```
     Sender email: tu-email@tu-dominio.com
     Sender name: QuePlan
     Host: smtp.sendgrid.net
     Port: 587
     Username: apikey
     Password: [tu API Key de SendGrid]
     Secure: ON (TLS)
     ```

### Opción C: Usar Mailgun

1. **Crea cuenta en Mailgun:**
   - Ve a: https://www.mailgun.com
   - Plan gratuito incluye 5,000 emails/mes

2. **Configura en Supabase:**
   ```
   Host: smtp.mailgun.org
   Port: 587
   Username: postmaster@tu-dominio.mailgun.org
   Password: [tu contraseña de Mailgun]
   ```

### Opción D: Usar otro proveedor SMTP

Cualquier proveedor SMTP estándar funcionará. Solo necesitas:
- Host SMTP
- Puerto (normalmente 587 para TLS o 465 para SSL)
- Usuario/Email
- Contraseña

---

## 📋 Paso 2: Habilitar Confirmación de Email

Una vez configurado el SMTP:

1. Ve a **Authentication > Settings > Email Auth**
2. **Activa**:
   - ☑ **Enable email confirmations**
   - ☑ **Enable email signup**

3. Configura las **Redirect URLs** si es necesario:
   ```
   io.supabase.fiestapp://confirm-email
   http://localhost:3000/auth/callback
   ```

4. **Personaliza los templates de email** (opcional):
   - Ve a **Authentication > Email Templates**
   - Puedes personalizar:
     - Email de confirmación
     - Email de recuperación de contraseña
     - Email de cambio de email

---

## 🧪 Probar la Configuración

### Probar Registro con Confirmación:

1. **Registra un nuevo usuario desde la app**
2. **Revisa tu bandeja de entrada** (y spam)
3. **Deberías recibir un email** con el asunto: "Confirm your email"
4. **Haz clic en el enlace** del email
5. **Intenta iniciar sesión** en la app
6. **Debería funcionar** correctamente

### Si no recibes el email:

1. Revisa la carpeta de **spam**
2. Verifica los logs en Supabase:
   - Ve a **Logs > Auth Logs**
   - Busca intentos de envío de email
3. Verifica la configuración SMTP:
   - Reenvía un email de prueba
   - Revisa errores en la configuración

---

## 🔧 Personalizar Templates de Email

Puedes personalizar los emails que se envían:

1. Ve a **Authentication > Email Templates**
2. Selecciona el template que quieres editar:
   - **Confirm signup**: Email de confirmación
   - **Reset password**: Recuperación de contraseña
   - **Magic link**: Login con link (si lo usas)

3. Usa variables disponibles:
   ```
   {{ .ConfirmationURL }} - URL de confirmación
   {{ .Email }} - Email del usuario
   {{ .Token }} - Token de confirmación
   {{ .TokenHash }} - Hash del token
   ```

Ejemplo de template personalizado:
```html
<h2>Bienvenido a QuePlan</h2>
<p>Hola,</p>
<p>Gracias por registrarte en QuePlan. Por favor, confirma tu email haciendo clic en el siguiente enlace:</p>
<p><a href="{{ .ConfirmationURL }}">Confirmar mi email</a></p>
<p>Si no solicitaste este registro, puedes ignorar este email.</p>
<p>¡Nos vemos en QuePlan!</p>
```

---

## ⚙️ Configuración Avanzada

### Cambiar el dominio del enlace de confirmación:

Por defecto, Supabase usa su propio dominio. Puedes usar un dominio personalizado:

1. Ve a **Settings > Auth > URL Configuration**
2. Configura:
   - **Site URL**: Tu URL de producción
   - **Redirect URLs**: URLs permitidas para redirecciones

### Configurar email de "From" personalizado:

Si usas un dominio propio:
1. Configura el SPF record en tu DNS
2. Configura el DKIM en tu proveedor SMTP
3. Verifica que los emails pasen las validaciones antispam

---

## 📊 Monitoreo de Emails

Para ver estadísticas de emails enviados:

1. Ve a **Logs > Auth Logs** en Supabase
2. Filtra por tipo: "Email sent"
3. Revisa:
   - Emails enviados exitosamente
   - Errores de envío
   - Bounces o rechazos

---

## 🚨 Problemas Comunes

### "Email no enviado" / "SMTP error"

**Soluciones:**
- Verifica las credenciales SMTP
- Asegúrate de que el puerto sea correcto (587 o 465)
- Verifica que TLS/SSL esté configurado correctamente
- Revisa los logs en Supabase para el error específico

### Emails llegan a spam

**Soluciones:**
- Configura SPF y DKIM en tu dominio
- Usa un dominio personalizado en lugar de Gmail genérico
- Verifica que el "Sender name" sea profesional
- Considera usar un servicio como SendGrid que maneja mejor la reputación

### "Email already confirmed" pero no puedo iniciar sesión

**Solución:**
- Verifica en Supabase > Authentication > Users
- Revisa si el email está realmente confirmado
- Prueba cerrar sesión y volver a iniciar

---

## ✅ Checklist Final

Para producción, asegúrate de tener:

- [ ] SMTP configurado con un proveedor confiable
- [ ] Email de confirmación habilitado
- [ ] Templates de email personalizados (opcional pero recomendado)
- [ ] Redirect URLs configuradas correctamente
- [ ] Pruebas realizadas: registro, confirmación, login
- [ ] Emails llegando correctamente (no a spam)
- [ ] Monitoreo de logs configurado

---

## 💡 Recomendación Final

**Para desarrollo/testing:**
- ✅ Desactiva la confirmación de email (más rápido para probar)

**Para producción:**
- ✅ Configura SMTP con SendGrid o Mailgun
- ✅ Habilita la confirmación de email
- ✅ Personaliza los templates
- ✅ Configura un dominio personalizado si es posible

---

**Nota**: Puedes cambiar entre estas configuraciones en cualquier momento desde el Dashboard de Supabase sin afectar a los usuarios ya registrados.
