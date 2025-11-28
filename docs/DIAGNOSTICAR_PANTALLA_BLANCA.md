# 🔍 Cómo Diagnosticar Pantalla en Blanco

## 📋 Pasos para Ver los Logs

### Opción 1: Ver logs en la terminal donde ejecutaste Flutter

Si todavía tienes `flutter run` corriendo, **mira la salida en la terminal**. Busca:

- ❌ Mensajes en rojo que digan `ERROR`, `Exception`, `Error`
- ⚠️ Mensajes amarillos con advertencias
- ✅ Mensajes de éxito (✅)

### Opción 2: Ver logs del dispositivo Android

Abre **otra terminal** y ejecuta:

```bash
adb logcat | grep -i "flutter\|error\|exception\|fatal"
```

O para ver solo los logs de Flutter:

```bash
adb logcat | grep -E "flutter|ERROR|Exception"
```

### Opción 3: Ejecutar con modo verbose

Detén la app actual y ejecuta:

```bash
flutter run -d android -v
```

El flag `-v` muestra muchos más detalles y errores.

---

## 🔍 Qué Buscar en los Logs

### Posibles Problemas Comunes:

#### 1. Error cargando `.env`
```
⚠️ Error al cargar .env: ...
```
**Causa**: El archivo `.env` no está en el dispositivo Android o no está en `pubspec.yaml` como asset.

**Solución**: Verifica que `.env` esté listado en `pubspec.yaml`:
```yaml
assets:
  - .env
```

#### 2. Supabase no inicializado
```
❌ Variables de entorno no encontradas
⚠️ Supabase no inicializado
```
**Causa**: El `.env` no se carga o no tiene las variables `SUPABASE_URL` y `SUPABASE_ANON_KEY`.

**Solución**: 
- Verifica que el archivo `.env` existe
- Verifica que tiene las variables necesarias

#### 3. Error al inicializar Supabase
```
❌ Error al inicializar Supabase: ...
```
**Causa**: URL o clave incorrecta de Supabase.

**Solución**: Verifica las credenciales en `.env`.

#### 4. Error en DashboardScreen
Busca errores como:
- `Null check operator used on a null value`
- `NoSuchMethodError`
- `BuilderException`

**Causa**: Algún servicio o widget está intentando acceder a algo que no existe.

#### 5. Error al cargar eventos
```
Error al obtener eventos: ...
```
**Causa**: Problema con la conexión a Supabase o la tabla `events` no existe.

---

## ✅ Cambios Realizados para Mejorar Diagnóstico

He añadido:

1. ✅ **Manejo de errores globales** en `main.dart`
2. ✅ **Verificaciones de Supabase** en los servicios
3. ✅ **Logs más detallados** para saber qué está fallando
4. ✅ **Fallbacks** - La app puede funcionar sin Supabase (modo local)

---

## 🧪 Prueba Rápida

Ejecuta esto en otra terminal mientras la app está corriendo:

```bash
adb logcat -c  # Limpiar logs
adb logcat | grep -E "ERROR|Exception|flutter|❌|⚠️"
```

Luego reinicia la app y verás los errores en tiempo real.

---

## 📝 Comparte los Logs

**Por favor, copia y pega aquí los mensajes que veas en los logs**, especialmente:

1. Cualquier mensaje que empiece con `❌` o `ERROR`
2. Cualquier `Exception` o `Error`
3. Los mensajes de inicialización (✅ o ⚠️)

Con esos logs podremos identificar exactamente qué está fallando.

