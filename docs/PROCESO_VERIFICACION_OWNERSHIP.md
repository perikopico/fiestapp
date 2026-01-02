# 📋 Proceso de Verificación de Ownership de Venues

## Flujo Completo

### 1. Usuario Reclama un Venue

**Pasos del usuario:**
1. Va a Perfil → "Reclamar un lugar"
2. Selecciona la ciudad
3. Busca el lugar (o lo crea si no existe)
4. Selecciona el método de contacto:
   - **Email**: Introduce su email (ej: `restaurante@ejemplo.com`)
   - **Teléfono**: Introduce su teléfono (ej: `+34 600 000 000`)
   - **Redes Sociales**: Introduce su handle (ej: `@restaurante_insta`)
5. Envía la solicitud

**Lo que sucede automáticamente:**
- ✅ Se crea una solicitud en la base de datos
- ✅ Se genera un código de verificación único de 6 dígitos (ej: `123456`)
- ✅ Se crea una notificación para los administradores
- ✅ Se intenta enviar una notificación push a los admins (si tienen la app instalada)

---

### 2. Admin Ve la Solicitud

**En el panel de administración:**
1. El admin va a Perfil → "Solicitudes de ownership"
2. Ve todas las solicitudes pendientes
3. Para cada solicitud, el admin puede ver:
   - **Nombre del venue** (ej: "Restaurante La Terraza")
   - **Email del usuario** (ej: `usuario@email.com`)
   - **Método de contacto** (email, teléfono o redes sociales)
   - **Información de contacto** (el email/teléfono/handle que el usuario proporcionó)
   - **Código de verificación** (ej: `123456`) ⭐ **IMPORTANTE**
   - **Fecha de solicitud**
   - **Fecha de expiración** (7 días desde la solicitud)

---

### 3. Admin Contacta al Usuario (MANUAL)

**⚠️ IMPORTANTE: El proceso es MANUAL. No hay envío automático de emails.**

El admin debe:
1. **Contactar al usuario** usando el método que el usuario eligió:
   - Si eligió **email**: Enviar un email al email proporcionado
   - Si eligió **teléfono**: Llamar o enviar WhatsApp/SMS
   - Si eligió **redes sociales**: Contactar por Instagram/Facebook/etc.

2. **Proporcionar el código de verificación**:
   - El admin copia el código que aparece en el panel (ej: `123456`)
   - Se lo envía al usuario por el método elegido
   - Ejemplo de mensaje:
     ```
     Hola, has solicitado ser dueño de "Restaurante La Terraza" en QuePlan.
     Tu código de verificación es: 123456
     Por favor, introduce este código en la app para completar la verificación.
     ```

3. **Verificar la identidad** (opcional pero recomendado):
   - Confirmar que el usuario es realmente el dueño del negocio
   - Puede hacer preguntas adicionales si es necesario

---

### 4. Usuario Introduce el Código

**Pasos del usuario:**
1. Recibe el código del admin (por email, teléfono o redes sociales)
2. Va a la app → Perfil → "Verificar código de ownership"
3. Introduce el código de 6 dígitos que recibió
4. Toca "Verificar código"
5. Si el código es correcto, el ownership se asigna automáticamente

**Nota**: El usuario puede verificar su propio código directamente desde la app. No necesita que el admin lo haga.

---

### 5. Verificación Completada

**Cuando el código es correcto:**
- ✅ El ownership se asigna al usuario
- ✅ El venue queda vinculado al usuario
- ✅ La solicitud se marca como "verificada"
- ✅ El usuario ahora puede aprobar/rechazar eventos de su venue

---

## Resumen del Flujo

```
Usuario → Reclama venue → Proporciona email/teléfono/redes
    ↓
Sistema → Genera código → Crea notificación para admin
    ↓
Admin → Ve solicitud en panel → Ve código de verificación
    ↓
Admin → Busca contacto oficial del negocio → Verifica que coincide
    ↓
Admin → Contacta manualmente al usuario → Le envía el código
    ↓
Usuario → Recibe código → Va a Perfil → "Verificar código de ownership"
    ↓
Usuario → Introduce código en la app → Verifica automáticamente
    ↓
Sistema → Asigna ownership → Usuario es dueño del venue
```

---

## Mejoras Posibles

### Opción 1: Envío Automático de Email
Podríamos implementar un sistema que envíe automáticamente un email al usuario con el código cuando se crea la solicitud. Esto requeriría:
- Configurar un servicio de email (SendGrid, Resend, etc.)
- Crear una Edge Function que envíe el email
- Añadir la configuración en Supabase

### ✅ Opción 2: Pantalla para Usuario Introducir Código - IMPLEMENTADA
- ✅ Pantalla "Verificar código de ownership" añadida en el perfil del usuario
- ✅ El usuario puede introducir el código que recibió
- ✅ El sistema verifica automáticamente

### Opción 3: Notificación Push al Usuario
Cuando el admin verifica, podríamos enviar una notificación push al usuario confirmando que es dueño.

---

## Preguntas Frecuentes

**P: ¿El código se envía automáticamente al email?**
R: No, actualmente el proceso es manual. El admin debe contactar al usuario y darle el código.

**P: ¿Qué pasa si el código expira?**
R: El código expira después de 7 días. El usuario puede crear una nueva solicitud.

**P: ¿Puedo verificar el código yo mismo como usuario?**
R: ✅ Sí, ahora puedes. Ve a Perfil → "Verificar código de ownership" e introduce el código que recibiste del admin.

**P: ¿Qué información ve el admin?**
R: El admin ve:
- Email del usuario (de Supabase Auth)
- Método de contacto elegido
- Información de contacto proporcionada
- Código de verificación
- Fechas de solicitud y expiración

