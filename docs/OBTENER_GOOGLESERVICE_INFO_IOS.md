# 📱 Cómo Obtener GoogleService-Info.plist para iOS

**Guía paso a paso para encontrar la configuración de iOS en Firebase Console**

---

## 🔍 Paso 1: Ubicación en Firebase Console

### Opción A: Desde el Dashboard Principal

1. **En Firebase Console**, estás en la página principal de tu proyecto
2. **Busca el icono de ⚙️ (engranaje)** en la parte superior derecha
   - Puede estar junto a "Project Overview" o en la barra superior
   - O puede estar en el menú lateral izquierdo como "Configuración del proyecto"
3. **Haz clic en el icono ⚙️**
4. **Selecciona "Configuración del proyecto"** o **"Project settings"**

### Opción B: Desde el Menú Lateral

1. En el menú lateral izquierdo, busca:
   - **"Configuración del proyecto"** o **"Project Settings"**
   - Puede estar al final de la lista
   - O puede estar agrupado con otros elementos de configuración

---

## 📱 Paso 2: Agregar App iOS

Una vez en **"Configuración del proyecto"** o **"Project settings"**:

1. **Busca la sección "Your apps"** o **"Tus aplicaciones"**
   - Puede estar en la parte superior de la página
   - O en una pestaña llamada "General" o "General settings"

2. **Verás una lista de apps** (Android, iOS, Web, etc.)
   - Si ya tienes una app Android, la verás aquí
   - Si no hay apps, verás un botón **"Add app"** o **"Agregar app"**

3. **Para agregar iOS**:
   - Haz clic en el icono de **iOS** (icono de Apple 🍎)
   - O haz clic en **"+ Add app"** y selecciona **iOS**

---

## 📝 Paso 3: Configurar la App iOS

Cuando hagas clic en agregar app iOS, te pedirá:

1. **iOS bundle ID**:
   ```
   com.perikopico.fiestapp
   ```
   ⚠️ **IMPORTANTE**: Debe ser exactamente este Bundle ID

2. **App nickname (opcional)**:
   ```
   QuePlan iOS
   ```
   O puedes dejarlo vacío

3. **App Store ID (opcional)**:
   - Déjalo vacío por ahora (solo necesario para producción)

4. **Haz clic en "Register app"** o **"Registrar app"**

---

## 📥 Paso 4: Descargar GoogleService-Info.plist

Después de registrar la app:

1. **Verás una página con instrucciones**
2. **Busca el botón "Download GoogleService-Info.plist"** o **"Descargar GoogleService-Info.plist"**
   - Puede estar en un cuadro destacado
   - O en la sección "Step 2" o "Paso 2"

3. **Haz clic en "Download"** o **"Descargar"**
4. **Guarda el archivo** en tu Mac (por ejemplo, en el Escritorio)

---

## 🗺️ Ruta Alternativa Si No Encuentras "Settings"

Si no encuentras el icono de configuración, intenta:

### Método 1: URL Directa
1. Ve directamente a:
   ```
   https://console.firebase.google.com/project/TU-PROYECTO-ID/settings/general
   ```
   (Reemplaza `TU-PROYECTO-ID` con el ID de tu proyecto)

### Método 2: Desde el Menú de Navegación
1. En la parte superior de Firebase Console, busca:
   - **"Project Overview"** o **"Descripción general"**
   - Haz clic y busca **"Project settings"** en el menú desplegable

### Método 3: Buscar en la Barra Superior
1. En la barra superior de Firebase Console, busca:
   - Un icono de **usuario/perfil** (arriba a la derecha)
   - O un menú de **tres puntos** (⋯)
   - Puede tener opciones de configuración

---

## 📸 Qué Deberías Ver

Cuando encuentres la sección correcta, deberías ver algo como:

```
┌─────────────────────────────────────┐
│  Your apps                          │
├─────────────────────────────────────┤
│  [Android icon] Android app         │
│  [iOS icon]    iOS app              │ ← Si ya existe
│  [Web icon]    Web app              │
│                                     │
│  [+ Add app]                        │ ← Si no existe iOS
└─────────────────────────────────────┘
```

---

## 🔍 Si Ya Tienes una App iOS Configurada

Si ya tienes una app iOS en Firebase:

1. **Haz clic en el icono de iOS** o en el nombre de la app iOS
2. **Busca la sección "Download GoogleService-Info.plist"**
3. **Descarga el archivo**

---

## 💡 Consejos

- **El icono de configuración ⚙️** suele estar en la parte superior derecha
- **"Project settings"** puede estar en inglés o español según tu idioma
- **Si estás en móvil**, usa la versión de escritorio de Firebase Console
- **El archivo se llama igual**: `GoogleService-Info.plist`

---

## 🆘 Si Aún No Lo Encuentras

1. **Toma una captura de pantalla** de lo que ves en Firebase Console
2. **Dime qué opciones ves** en el menú lateral izquierdo
3. **O dime el nombre de tu proyecto** y te guío más específicamente

---

## 📋 Checklist

- [ ] Encontré "Project settings" o "Configuración del proyecto"
- [ ] Encontré la sección "Your apps" o "Tus aplicaciones"
- [ ] Agregué la app iOS (o ya existe)
- [ ] Descargué `GoogleService-Info.plist`
- [ ] Guardé el archivo en mi Mac

