# Guía Rápida: Configuración Google OAuth

## 🔍 Encontrar tu URL de Supabase

1. Ve a [Supabase Dashboard](https://app.supabase.com/)
2. Selecciona tu proyecto
3. Ve a **Settings** (⚙️) > **API**
4. Copia la **Project URL** (se ve así: `https://abcdefghijklmnop.supabase.co`)

## 📋 URLs de Redirección

Añade esta URL en Google Cloud Console > OAuth 2.0 Client:

```
https://TU-PROYECTO-ID.supabase.co/auth/v1/callback
```

**Ejemplo**: Si tu Project URL es `https://xyz123abc.supabase.co`, la URL de redirección será:
```
https://xyz123abc.supabase.co/auth/v1/callback
```

## ⚙️ Restricciones Recomendadas

### Restricción de Aplicación
- ✅ **"Sitios web"** (ya lo tienes configurado correctamente)

### Restricciones de API
- ✅ **"No restrictivo"** (recomendado para empezar)

   O si prefieres ser más específico:
- ✅ Selecciona solo **"People API"** en la lista

## ✅ Configuración Final

### En Google Cloud Console:
```
Application type: Web application
Name: QuePlan - Supabase
Authorized redirect URIs: https://TU-PROYECTO-ID.supabase.co/auth/v1/callback
Application restrictions: Sitios web
API restrictions: No restrictivo (o People API)
```

### En Supabase Dashboard:
1. Authentication > Providers > Google
2. Activa el toggle
3. Pega Client ID y Client Secret
4. Guarda

## 🧪 Probar

1. En la app, toca el botón de login
2. Selecciona "Continuar con Google"
3. Deberías ver la pantalla de Google para autorizar

