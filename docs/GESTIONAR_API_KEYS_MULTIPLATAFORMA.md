# 🔑 Gestión de API Keys Multiplataforma

**Fecha**: Enero 2025  
**Contexto**: Desarrollo en Mac para iOS y Android

---

## 📋 Resumen

Este proyecto usa **API Keys diferentes** para Android e iOS. Esta guía explica cómo gestionarlas correctamente.

---

## 🗂️ Estructura de Archivos

### 1. `.env` (Raíz del proyecto)
**Uso**: Código Dart (Places API, Geocoding) - se ejecuta en ambas plataformas  
**API Key**: Android (por defecto)

```env
# Supabase (compartido)
SUPABASE_URL=https://tu-proyecto.supabase.co
SUPABASE_ANON_KEY=tu_clave_anonima

# Google Maps API Key (para código Dart - usa la de Android)
GOOGLE_MAPS_API_KEY=AIzaSyB3QZYmsSb1GmIewWnDS-KewupE3Ths_dY
```

**¿Por qué Android?**  
El código Dart se ejecuta en ambas plataformas. Usamos la API key de Android porque:
- Es la que ya tienes configurada
- Funciona para Places API y Geocoding en ambas plataformas
- Simplifica la gestión

---

### 2. `android/local.properties`
**Uso**: SDK nativo de Google Maps para Android  
**API Key**: Android

```properties
flutter.sdk=/opt/homebrew/share/flutter

# Google Maps API Key para Android (SDK nativo)
GOOGLE_MAPS_API_KEY=AIzaSyB3QZYmsSb1GmIewWnDS-KewupE3Ths_dY
```

**⚠️ IMPORTANTE**: 
- Este archivo está en `.gitignore`
- NO lo subas a Git
- Debe tener la misma API key que `.env`

---

### 3. `ios/Runner/Info.plist`
**Uso**: SDK nativo de Google Maps para iOS  
**API Key**: iOS (diferente a Android)

```xml
<key>GMSApiKey</key>
<string>AIzaSyB-LWdftqdYCjv3QgsUJNI2TeyA1ALCPsc</string>
```

**⚠️ IMPORTANTE**:
- Esta API key es DIFERENTE a la de Android
- Tiene restricciones específicas para iOS en Google Cloud Console
- Bundle ID: `com.perikopico.fiestapp`

---

## 📊 Tabla de Resumen

| Archivo | API Key | Uso | Plataforma |
|---------|---------|-----|------------|
| `.env` | Android | Código Dart (Places, Geocoding) | iOS + Android |
| `android/local.properties` | Android | SDK nativo Google Maps | Solo Android |
| `ios/Runner/Info.plist` | iOS | SDK nativo Google Maps | Solo iOS |

---

## 🔄 Flujo de Uso

### Cuando ejecutas en Android:
1. **SDK nativo de Maps**: Lee desde `android/local.properties`
2. **Código Dart (Places/Geocoding)**: Lee desde `.env`

### Cuando ejecutas en iOS:
1. **SDK nativo de Maps**: Lee desde `ios/Runner/Info.plist`
2. **Código Dart (Places/Geocoding)**: Lee desde `.env` (usa la de Android)

---

## ✅ Ventajas de esta Configuración

1. **Separación clara**: Cada plataforma tiene su API key para el SDK nativo
2. **Seguridad**: Restricciones específicas por plataforma en Google Cloud Console
3. **Simplicidad**: El código Dart usa una sola key (Android) que funciona en ambas
4. **Mantenimiento**: Fácil de actualizar cada key independientemente

---

## 🔧 Cómo Actualizar las API Keys

### Actualizar API Key de Android:

1. **Actualizar `.env`**:
   ```env
   GOOGLE_MAPS_API_KEY=nueva_key_android
   ```

2. **Actualizar `android/local.properties`**:
   ```properties
   GOOGLE_MAPS_API_KEY=nueva_key_android
   ```

3. **Reiniciar la app**

### Actualizar API Key de iOS:

1. **Editar `ios/Runner/Info.plist`**:
   ```xml
   <key>GMSApiKey</key>
   <string>nueva_key_ios</string>
   ```

2. **Reiniciar la app**

---

## 🚨 Problemas Comunes

### Error: "API key not found" en Android
**Solución**: Verifica que `android/local.properties` tiene `GOOGLE_MAPS_API_KEY`

### Error: "API key not found" en iOS
**Solución**: Verifica que `ios/Runner/Info.plist` tiene la clave `GMSApiKey`

### Mapa en blanco en una plataforma
**Solución**: 
- Verifica que la API key tiene las restricciones correctas en Google Cloud Console
- Asegúrate de que las APIs necesarias están habilitadas

---

## 📝 Checklist de Configuración

Antes de compilar, verifica:

- [ ] `.env` tiene `GOOGLE_MAPS_API_KEY` (Android)
- [ ] `android/local.properties` tiene `GOOGLE_MAPS_API_KEY` (Android)
- [ ] `ios/Runner/Info.plist` tiene `GMSApiKey` (iOS)
- [ ] Las API keys tienen las restricciones correctas en Google Cloud Console
- [ ] Las APIs necesarias están habilitadas en Google Cloud Console

---

## 🔐 Seguridad

- ✅ Todos los archivos con API keys están en `.gitignore`
- ✅ No se suben al repositorio
- ✅ Cada API key tiene restricciones específicas en Google Cloud Console
- ⚠️ **NUNCA** compartas estos archivos públicamente

---

## 📚 Referencias

- [Configurar API Keys Separadas](./CONFIGURAR_API_KEYS_SEPARADAS.md)
- [Configurar Google Maps iOS](./CONFIGURAR_GOOGLE_MAPS_IOS.md)
- [Configurar API Keys Seguras](./CONFIGURAR_API_KEYS_SEGURAS.md)

