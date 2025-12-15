# 🔧 Instalar Supabase CLI

Esta guía explica cómo instalar Supabase CLI para desplegar Edge Functions.

## 📦 Instalación

### Opción 1: Con npm (Recomendado)

```bash
npm install -g supabase
```

### Opción 2: Con Homebrew (macOS/Linux)

```bash
brew install supabase/tap/supabase
```

### Opción 3: Descarga Directa (Linux)

```bash
# Descargar binario
curl -L https://github.com/supabase/cli/releases/latest/download/supabase_linux_amd64.tar.gz | tar -xz

# Mover a /usr/local/bin (requiere sudo)
sudo mv supabase /usr/local/bin/

# O mover a ~/.local/bin (no requiere sudo)
mkdir -p ~/.local/bin
mv supabase ~/.local/bin
export PATH="$HOME/.local/bin:$PATH"
```

## ✅ Verificar Instalación

```bash
supabase --version
```

## 🔐 Autenticarse

```bash
supabase login
```

Esto abrirá el navegador para autenticarte con tu cuenta de Google.

## 🔗 Vincular Proyecto

```bash
cd /home/perikopico/StudioProjects/fiestapp
supabase link --project-ref tu-project-ref
```

Puedes encontrar tu `project-ref` en:
- Supabase Dashboard → Settings → General → Reference ID

## 🚀 Desplegar Funciones

Una vez instalado y autenticado:

```bash
# Desplegar todas las funciones
supabase functions deploy send_deletion_email
supabase functions deploy cleanup_deleted_users
supabase functions deploy delete_user_account
```

---

**Última actualización**: Diciembre 2024

