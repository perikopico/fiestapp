# ✅ Verificar Restricciones de la API Key

## Lo que ya tienes correcto ✅

- **Restricción de API:** "Maps SDK for Android" ✅

## Lo que debes verificar ahora

### 1. Restricciones de Aplicación (Application Restrictions)

En la página de detalles de tu API key, busca la sección **"Application restrictions"**.

**¿Qué opciones ves?**

A) **"None"** (Sin restricciones)
- ✅ Esto funcionará para pruebas
- ⚠️ Menos seguro, pero funciona

B) **"Android apps"** (Restricciones de Android)
- ✅ Más seguro (recomendado)
- Requiere configurar:
  - Package name: `com.perikopico.fiestapp`
  - SHA-1: (obtener con `./gradlew signingReport`)

C) **"HTTP referrers (web sites)"** (Solo para web)
- ❌ No aplica para Android

D) **"IP addresses"** (Solo para servidores)
- ❌ No aplica para apps móviles

---

### 2. Si tienes "Android apps" configurado

Verifica que tengas:

1. **Package name:** `com.perikopico.fiestapp`
   - Debe ser exactamente este

2. **SHA-1 certificate fingerprint:**
   - Debe coincidir con el SHA-1 de tu app
   - Si no lo tienes, obténlo con:
     ```bash
     cd android && ./gradlew signingReport
     ```

---

### 3. Opciones recomendadas

#### Opción A: Sin restricciones (para probar rápido)

**Application restrictions:** Selecciona **"None"**

**Ventajas:**
- ✅ Funciona inmediatamente
- ✅ No necesitas configurar SHA-1

**Desventajas:**
- ⚠️ Menos seguro (cualquiera con la API key puede usarla)

#### Opción B: Con restricciones Android (recomendado)

**Application restrictions:** Selecciona **"Android apps"**

**Luego añade:**
- Package name: `com.perikopico.fiestapp`
- SHA-1: (tu SHA-1)

**Ventajas:**
- ✅ Más seguro
- ✅ Solo tu app puede usar la API key

**Desventajas:**
- Necesitas obtener el SHA-1 primero

---

## 📋 Checklist

- [ ] "Maps SDK for Android" está en las restricciones de API ✅ (ya lo tienes)
- [ ] Application restrictions está configurado (None o Android apps)
- [ ] Si elegiste Android apps, el package name es `com.perikopico.fiestapp`
- [ ] Si elegiste Android apps, el SHA-1 está configurado y es correcto

---

## 🎯 Próximos pasos

1. **Si tienes "None" en Application restrictions:**
   - Debería funcionar ya
   - Si no funciona, el problema es otro (ver logs)

2. **Si tienes "Android apps" configurado:**
   - Verifica que el package name sea exactamente `com.perikopico.fiestapp`
   - Verifica que el SHA-1 coincida con el de tu app

3. **Si no tienes ninguna restricción de aplicación:**
   - Puedes dejarlo así para probar
   - O configurar "Android apps" para mayor seguridad

---

## 🔍 ¿Qué error ves en la app?

Después de verificar las restricciones, prueba la app y dime:
- ¿Se muestra el mapa?
- ¿Aparece algún error?
- ¿Qué dice en los logs?

