# Configurar Pantalla de Consentimiento OAuth de Google

## 📋 Paso a Paso

### 1. Seleccionar Tipo de Usuario
- **Selecciona: "External"** (para usuarios fuera de tu organización)
- Si fuera para uso interno de una empresa, usarías "Internal"

### 2. Información de la App (Paso 1: App information)

**Campos obligatorios:**
- **App name**: `QuePlan`
- **User support email**: Tu email (ejemplo: `tu@email.com`)
- **App logo**: (Opcional) Puedes dejarlo en blanco por ahora

**Campos opcionales:**
- App domain: Puedes dejarlo vacío
- Application home page: Puedes dejar vacío o poner tu sitio web si lo tienes
- Privacy policy link: (Opcional) Si tienes una política de privacidad
- Terms of service link: (Opcional) Si tienes términos de servicio

**Haz clic en "SAVE AND CONTINUE"**

### 3. Scopes (Paso 2: Scopes)

- Puedes dejarlo como está o hacer clic en "ADD OR REMOVE SCOPES"
- Los scopes necesarios generalmente ya vienen incluidos:
  - `userinfo.email`
  - `userinfo.profile`
  - `openid`
  
**Haz clic en "SAVE AND CONTINUE"**

### 4. Test users (Paso 3: Test users)

- Si tu app está en "Testing" mode (por defecto), puedes añadir emails de prueba
- Por ahora puedes dejarlo vacío y añadir usuarios después si necesitas probar
- O añade tu propio email si quieres probar la autenticación

**Haz clic en "SAVE AND CONTINUE"**

### 5. Resumen (Paso 4: Summary)

- Revisa la información
- Haz clic en "BACK TO DASHBOARD"

## ✅ Después de Configurar

Una vez completada la pantalla de consentimiento:

1. Vuelve a **Credentials**
2. Ahora deberías poder crear el **OAuth 2.0 Client ID**
3. Selecciona **"Web application"**
4. Añade la URL de redirección de Supabase

## ⚠️ Nota Importante

- La app estará en modo "Testing" por defecto
- Solo los usuarios que añadas como "Test users" podrán iniciar sesión
- Cuando estés listo para producción, tendrás que publicar la app (requiere verificación de Google, pero eso es para más adelante)

