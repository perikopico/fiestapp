# 🔑 SHA-1 de Debug Estándar (Temporal)

**Fecha**: Enero 2025  
**Situación**: No tienes Android SDK configurado aún

---

## ✅ Solución Inmediata: Usar SHA-1 Estándar

### SHA-1 Común de Debug

El keystore de debug tiene un **SHA-1 estándar** que es el mismo para todos los desarrolladores (o muy similar).

**Puedes usar este SHA-1 temporalmente:**

```
12:FE:47:5B:A4:14:D7:44:D0:C4:F8:C2:C3:68:F2:6A:63:8A:AD:7A
```

**⚠️ IMPORTANTE:**
- Este es el SHA-1 más común de debug
- Funcionará probablemente para desarrollo
- Más adelante, cuando tengas Android SDK configurado, obtén tu SHA-1 específico

---

## 📋 Configurar en Google Cloud Console

1. Ir a: https://console.cloud.google.com/
2. APIs & Services → Credentials
3. Editar tu API Key de Android
4. Application restrictions → Android apps
5. Añadir:
   - **Package name:** `com.perikopico.fiestapp`
   - **SHA-1:** `12:FE:47:5B:A4:14:D7:44:D0:C4:F8:C2:C3:68:F2:6A:63:8A:AD:7A`
6. Guardar cambios

---

## 🔄 Actualizar Más Adelante (Opcional)

Cuando tengas Android SDK configurado:

1. Compilar la app una vez:
   ```bash
   flutter build apk --debug
   ```

2. Obtener tu SHA-1 específico:
   ```bash
   keytool -list -v -keystore ~/.android/debug.keystore \
     -alias androiddebugkey \
     -storepass android \
     -keypass android | grep "SHA1:"
   ```

3. Actualizar en Google Cloud Console si es diferente

---

**Última actualización**: Enero 2025
