# 🚀 Desplegar Edge Functions Manualmente

Si no puedes usar Supabase CLI, puedes desplegar las funciones desde el Dashboard.

## 📋 Funciones a Desplegar

1. `send_deletion_email` - Envía email de confirmación de eliminación
2. `cleanup_deleted_users` - Limpia usuarios eliminados periódicamente  
3. `delete_user_account` - Elimina usuarios de auth.users

## 🚀 Opción 1: Desde Supabase Dashboard (Más Fácil)

### Paso 1: Crear las Funciones

1. Ve a [Supabase Dashboard](https://app.supabase.com)
2. Selecciona tu proyecto
3. Ve a **Edge Functions**
4. Haz clic en **Create a new function**

### Paso 2: Para cada función:

1. **Nombre de la función**: `send_deletion_email` (o el nombre correspondiente)
2. **Código**: Copia y pega el contenido de:
   - `supabase/functions/send_deletion_email/index.ts`
3. Haz clic en **Deploy**

Repite para las otras dos funciones.

## 🔧 Opción 2: Instalar Supabase CLI

Si prefieres usar CLI:

```bash
# Instalar (requiere sudo o usar --prefix)
sudo npm install -g supabase
# O
npm install -g supabase --prefix ~/.local
export PATH="$HOME/.local/bin:$PATH"

# Autenticarse
supabase login

# Vincular proyecto
cd /home/perikopico/StudioProjects/fiestapp
supabase link --project-ref tu-project-ref

# Desplegar
supabase functions deploy send_deletion_email
supabase functions deploy cleanup_deleted_users
supabase functions deploy delete_user_account
```

## ⚙️ Configurar Secrets

Después de desplegar, configura los secrets:

1. Ve a **Edge Functions** → Selecciona la función
2. Ve a **Settings** → **Secrets**
3. Añade:
   - `SUPABASE_SERVICE_ROLE_KEY` (obligatorio)
   - `RESEND_API_KEY` (opcional, para emails)

O desde CLI:
```bash
supabase secrets set SUPABASE_SERVICE_ROLE_KEY=tu_key
supabase secrets set RESEND_API_KEY=tu_key  # Opcional
```

## ✅ Verificar

1. Ve a **Edge Functions** en el Dashboard
2. Deberías ver las 3 funciones desplegadas
3. Haz clic en cada una para ver los logs

---

**Última actualización**: Diciembre 2024

