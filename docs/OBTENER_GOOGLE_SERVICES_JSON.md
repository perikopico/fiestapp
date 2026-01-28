# 📥 Obtener google-services.json para Android

**Fecha**: Enero 2025  
**Problema**: `File google-services.json is missing`

---

## ✅ Solución: Descargar desde Firebase Console

### Paso 1: Ir a Firebase Console

1. **Abre:** https://console.firebase.google.com/
2. **Selecciona tu proyecto** (QuePlan)

---

### Paso 2: Agregar App Android (si no la has agregado)

**Si ya tienes la app Android agregada, ve directamente al Paso 3.**

1. En la pantalla de inicio, haz clic en el **icono de Android** (o "Agregar app")
2. Completa el formulario:
   - **Nombre del paquete Android**: `com.perikopico.fiestapp`
   - **Apodo de la app** (opcional): `QuePlan`
   - **Certificado de firma del depuración SHA-1** (opcional por ahora): Déjalo vacío
3. Haz clic en **"Registrar app"**

---

### Paso 3: Descargar google-services.json

**Opción A: Desde la pantalla de registro (si acabas de agregar la app)**

1. Después de registrar la app, Firebase te mostrará un botón: **"Descargar google-services.json"**
2. **Haz clic en el botón** para descargar el archivo

**Opción B: Desde Project Settings (si ya tenías la app agregada)**

1. En Firebase Console, haz clic en el **icono de configuración** (⚙️) en la parte superior
2. Selecciona **"Project settings"**
3. Desplázate hasta la sección **"Your apps"**
4. Busca tu app Android (`com.perikopico.fiestapp`)
5. Haz clic en el **icono de descarga** (⬇️) al lado de `google-services.json`

---

### Paso 4: Colocar el archivo

**Ubicación exacta:**
```
fiestapp/
└── android/
    └── app/
        └── google-services.json  ← AQUÍ
```

**Pasos:**

1. **Mueve el archivo descargado** a:
   ```
   android/app/google-services.json
   ```

2. **Verifica que esté en el lugar correcto:**
   ```bash
   ls -la android/app/google-services.json
   ```

---

## ✅ Verificar que Funciona

**1. Compilar nuevamente:**
```bash
flutter build apk --debug
```

**Ahora debería compilar sin errores de `google-services.json`.**

---

## 🔄 Solución Temporal (Ya Implementada)

**Ya he modificado `android/app/build.gradle.kts` para hacer el plugin opcional.**

**Esto significa que:**
- ✅ Puedes compilar sin `google-services.json` (para obtener el SHA-1)
- ⚠️ Firebase no funcionará hasta que añadas el archivo
- ✅ Una vez añadas `google-services.json`, Firebase se habilitará automáticamente

**Para compilar ahora (sin Firebase):**
```bash
flutter build apk --debug
```

---

## 📋 Resumen Rápido

### Para Compilar Ahora (Sin Firebase):
```bash
# Puedes compilar sin google-services.json
flutter build apk --debug
```

### Para Habilitar Firebase:
1. Descarga `google-services.json` desde Firebase Console
2. Colócalo en `android/app/google-services.json`
3. Vuelve a compilar

---

## 🎯 Orden Recomendado

**1. Primero: Obtener SHA-1**
```bash
# Compilar (sin Firebase está bien)
flutter build apk --debug

# Obtener SHA-1
./scripts/obtener_sha1_debug.sh
```

**2. Segundo: Configurar API Key en Google Cloud Console**
- Añadir SHA-1 a tu API Key de Android

**3. Tercero: Añadir google-services.json**
- Descargar desde Firebase Console
- Colocar en `android/app/google-services.json`
- Vuelve a compilar para habilitar Firebase

---

**Última actualización**: Enero 2025
