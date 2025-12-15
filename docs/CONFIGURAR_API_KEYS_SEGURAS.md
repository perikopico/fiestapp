# 🔐 Configurar API Keys de Forma Segura

## ⚠️ Problema de Seguridad

Las API keys estaban hardcodeadas en el código fuente, lo cual es un riesgo de seguridad si el código se sube a un repositorio público.

## ✅ Solución Implementada

Ahora las API keys se cargan desde archivos de configuración que están en `.gitignore`:

### Para Android (AndroidManifest.xml)
- **Archivo**: `android/local.properties`
- **Variable**: `GOOGLE_MAPS_API_KEY`
- **Estado**: ✅ Ya está en `.gitignore`

### Para Código Dart (Places API, Geocoding)
- **Archivo**: `.env` (en la raíz del proyecto)
- **Variable**: `GOOGLE_MAPS_API_KEY`
- **Estado**: ✅ Ya está en `.gitignore`

## 📝 Pasos para Configurar

### 1. Configurar API Key para Android

1. Abre el archivo `android/local.properties`
2. Añade la siguiente línea (si no está ya):
   ```
   GOOGLE_MAPS_API_KEY=TU_API_KEY_AQUI
   ```
   **⚠️ IMPORTANTE:** Reemplaza `TU_API_KEY_AQUI` con tu API key real de Google Maps.

### 2. Configurar API Key para Código Dart

1. Abre el archivo `.env` en la raíz del proyecto
2. Añade la siguiente línea:
   ```
   GOOGLE_MAPS_API_KEY=TU_API_KEY_AQUI
   ```
   **⚠️ IMPORTANTE:** Reemplaza `TU_API_KEY_AQUI` con tu API key real de Google Maps.

## 🔍 Verificación

### Verificar que local.properties tiene la key:
```bash
cat android/local.properties | grep GOOGLE_MAPS_API_KEY
```

### Verificar que .env tiene la key:
```bash
cat .env | grep GOOGLE_MAPS_API_KEY
```

## ⚠️ Importante

- **NUNCA** subas `local.properties` o `.env` al repositorio
- Estos archivos ya están en `.gitignore`
- Si necesitas compartir el proyecto, usa los archivos `.example` como plantilla

## 📋 Archivos de Ejemplo

- `android/local.properties.example` - Plantilla para local.properties
- `.env.example` - Plantilla para .env (si existe)

## 🔄 Fallback

Si las variables de entorno no están configuradas, el código usará una API key por defecto (solo para desarrollo). En producción, esto debería fallar si no hay key configurada.

