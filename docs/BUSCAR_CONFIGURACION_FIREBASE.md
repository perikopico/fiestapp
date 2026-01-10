# 🔍 Dónde Encontrar la Configuración de iOS en Firebase

**Guía visual paso a paso**

---

## 📍 Ubicación Exacta

Basándome en lo que ves en el menú lateral, sigue estos pasos:

### Paso 1: Buscar el Icono de Configuración

1. **Mira la parte SUPERIOR de la pantalla** (no el menú lateral)
2. **Busca un icono de ⚙️ (engranaje)** en la esquina superior derecha
   - Está al lado del nombre de tu proyecto
   - O junto a "Project Overview"
3. **Haz clic en ese icono ⚙️**

### Paso 2: Si No Ves el Icono ⚙️

**Opción A: Desde el nombre del proyecto**
1. Haz clic en el **nombre de tu proyecto** (parte superior)
2. Se abrirá un menú desplegable
3. Busca **"Project settings"** o **"Configuración del proyecto"**

**Opción B: URL Directa**
1. Copia esta URL y reemplaza `TU-PROYECTO-ID`:
   ```
   https://console.firebase.google.com/project/TU-PROYECTO-ID/settings/general
   ```
2. Para encontrar tu Project ID:
   - Mira la URL actual en el navegador
   - O ve a "Descripción general" y mira la URL

---

## 🎯 Qué Buscar Específicamente

Cuando hagas clic en configuración, deberías ver una página con estas pestañas/secciones:

- **General** ← **AQUÍ ES DONDE ESTÁ**
- Usage and billing
- Service accounts
- etc.

En la pestaña **"General"**, busca:

```
┌─────────────────────────────────────┐
│  Your apps                         │
├─────────────────────────────────────┤
│  [Icono Android] Android app       │
│  [Icono iOS]    iOS app             │ ← Si existe
│  [Icono Web]    Web app             │
│                                     │
│  [+ Add app]                        │ ← Si no existe
└─────────────────────────────────────┘
```

---

## 📱 Si No Tienes App iOS

1. Haz clic en **"+ Add app"** o **"Agregar app"**
2. Selecciona el icono de **iOS** (🍎)
3. Completa:
   - **iOS bundle ID**: `com.perikopico.fiestapp`
   - **App nickname**: `QuePlan iOS` (opcional)
4. Haz clic en **"Register app"**

---

## 📥 Descargar el Archivo

Después de agregar/registrar la app iOS:

1. Verás una página con **pasos de configuración**
2. En el **Paso 2** o sección de descarga, busca:
   - **"Download GoogleService-Info.plist"**
   - O un botón de descarga
3. **Haz clic y descarga el archivo**

---

## 🗺️ Ruta Visual Completa

```
Firebase Console
  └─ Tu Proyecto (parte superior)
      └─ ⚙️ Icono de Configuración (esquina superior derecha)
          └─ Project settings / Configuración del proyecto
              └─ Pestaña "General"
                  └─ Sección "Your apps"
                      └─ [iOS icon] iOS app
                          └─ Download GoogleService-Info.plist
```

---

## 💡 Pista Visual

El icono de configuración ⚙️ suele estar:
- **Arriba a la derecha** junto al nombre del proyecto
- O en un menú de **tres puntos** (⋯) o **menú hamburguesa** (☰)

---

## 🆘 Si Aún No Lo Encuentras

**Dime:**
1. ¿Qué ves cuando haces clic en el nombre de tu proyecto (parte superior)?
2. ¿Hay algún icono de engranaje ⚙️ visible en la pantalla?
3. ¿Puedes ver el **Project ID** en alguna parte? (suele ser algo como `queplan-479012`)

Con esa información te guío más específicamente.

