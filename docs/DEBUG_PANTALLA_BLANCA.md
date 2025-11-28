# 🔍 Debug: Pantalla en Blanco en Android

## ✅ Lo que acabo de arreglar:

- `kAdminPin` ahora retorna `null` en lugar de lanzar excepción
- Uso de `kAdminPin` protegido con verificaciones null
- Esto debería evitar crashes al iniciar

## 📋 Cómo ver los logs para diagnosticar:

### Opción 1: Ver logs en tiempo real

En la terminal donde ejecutaste `flutter run`, deberías ver logs. Busca:

- ❌ **Errores rojos** (Exception, Error, etc.)
- ⚠️ **Advertencias** que digan algo sobre `.env` o `ADMIN_PIN`
- ✅ **Mensajes de éxito** (✅ Firebase inicializado, ✅ Supabase inicializado, etc.)

### Opción 2: Ver logs completos

```bash
flutter run -d android -v
```

El flag `-v` (verbose) mostrará muchos más detalles.

### Opción 3: Ver logs del dispositivo

```bash
adb logcat | grep -i "flutter\|error\|exception"
```

## 🔍 Qué buscar en los logs:

### Posibles problemas:

1. **Error cargando .env**:
   ```
   ⚠️ Error al cargar .env: ...
   ```
   **Solución**: Verifica que `.env` existe y está en `pubspec.yaml` como asset

2. **Error inicializando Supabase**:
   ```
   ❌ Variables de entorno no encontradas
   ```
   **Solución**: Verifica que `.env` tiene `SUPABASE_URL` y `SUPABASE_ANON_KEY`

3. **Error en DashboardScreen**:
   Busca mensajes de error relacionados con:
   - Cargar eventos
   - Servicios
   - Autenticación

## 🚨 Verificación rápida:

Verifica que `.env` está en assets:

```bash
# Ver si .env está en pubspec.yaml
grep "\.env" pubspec.yaml

# Ver si el archivo existe
ls -la .env
```

## ✅ Próximos pasos:

1. **Reinicia la app** con los cambios que acabo de hacer
2. **Mira los logs** en la terminal
3. **Copia los errores** que veas y compártelos

Los cambios deberían evitar el crash, pero si sigue habiendo pantalla en blanco, necesitamos ver los logs para saber qué está fallando.

