# 🔧 Desplegar Edge Function para Eliminación de Cuentas

Esta guía explica cómo desplegar la Edge Function `delete_user_account` que permite eliminar completamente usuarios de `auth.users` usando Admin API.

## 📋 Requisitos Previos

1. ✅ Tienes Supabase CLI instalado
2. ✅ Estás autenticado en Supabase CLI (`supabase login`)
3. ✅ Tienes acceso al proyecto Supabase

## 🚀 Paso 1: Configurar Variables de Entorno

La Edge Function necesita la **Service Role Key** de Supabase para usar Admin API.

### Obtener Service Role Key:

1. Ve a [Supabase Dashboard](https://app.supabase.com)
2. Selecciona tu proyecto
3. Ve a **Settings** → **API**
4. Copia la **`service_role` key** (⚠️ NUNCA la expongas en el cliente)

### Configurar en Supabase:

```bash
# Desde el directorio del proyecto
cd /home/perikopico/StudioProjects/fiestapp

# Configurar el secreto (reemplaza YOUR_SERVICE_ROLE_KEY con tu clave real)
supabase secrets set SUPABASE_SERVICE_ROLE_KEY=YOUR_SERVICE_ROLE_KEY
```

**Nota**: La URL de Supabase se obtiene automáticamente del proyecto vinculado.

## 🚀 Paso 2: Desplegar la Edge Function

```bash
# Asegúrate de estar en el directorio del proyecto
cd /home/perikopico/StudioProjects/fiestapp

# Desplegar la función
supabase functions deploy delete_user_account
```

Si es la primera vez, puede pedirte vincular el proyecto:

```bash
supabase link --project-ref tu-project-ref
```

## ✅ Paso 3: Verificar el Despliegue

1. Ve a [Supabase Dashboard](https://app.supabase.com)
2. Selecciona tu proyecto
3. Ve a **Edge Functions**
4. Deberías ver `delete_user_account` en la lista

## 🧪 Paso 4: Probar la Función

Puedes probar la función desde la app:

1. Regístrate con un email de prueba
2. Inicia sesión
3. Ve a **Perfil** → **Eliminar cuenta**
4. Confirma la eliminación
5. Intenta registrarte de nuevo con el mismo email
6. ✅ Deberías recibir un nuevo email de confirmación

## 🔍 Verificar Logs

Para ver los logs de la función:

```bash
supabase functions logs delete_user_account
```

O desde el Dashboard:
- **Edge Functions** → **delete_user_account** → **Logs**

## ⚠️ Seguridad

- ✅ La función verifica que el usuario solo pueda eliminar su propia cuenta
- ✅ Usa Service Role Key solo en el servidor (Edge Function)
- ✅ Requiere autenticación válida (token Bearer)
- ✅ No expone la Service Role Key al cliente

## 🐛 Solución de Problemas

### Error: "Service Role Key not configured"
- Verifica que hayas configurado el secreto: `supabase secrets set SUPABASE_SERVICE_ROLE_KEY=...`

### Error: "Invalid or expired token"
- Asegúrate de estar autenticado antes de llamar a la función
- Verifica que el token no haya expirado

### Error: "Failed to delete user"
- Verifica que la Service Role Key sea correcta
- Revisa los logs de la función para más detalles

### La función no aparece en el Dashboard
- Verifica que el despliegue fue exitoso: `supabase functions list`
- Asegúrate de estar en el proyecto correcto: `supabase projects list`

## 📝 Estructura de Archivos

```
supabase/functions/
└── delete_user_account/
    └── index.ts          # Código de la Edge Function
```

## 🔄 Actualizar la Función

Si necesitas actualizar la función después de hacer cambios:

```bash
supabase functions deploy delete_user_account
```

---

**Última actualización**: Diciembre 2024

