# 🔐 Guía: Verificar Restricciones de API Keys

**Fecha**: Enero 2025  
**Tiempo estimado**: 15-20 minutos  
**Prioridad**: 🔴 CRÍTICO

---

## 📋 Resumen

Esta guía te ayudará a verificar que las API Keys tienen las restricciones correctas configuradas para proteger tu aplicación.

### API Keys a Verificar:
1. **Google Maps API Key** (en Google Cloud Console)
2. **Supabase Keys** (verificar que no hay service key en el cliente)

---

## 🗺️ 1. Verificar Google Maps API Key

### Paso 1: Acceder a Google Cloud Console

1. Ve a: https://console.cloud.google.com/
2. **Selecciona el proyecto correcto** (el que contiene tu API Key de Google Maps)
3. Si no estás seguro del proyecto, busca en la barra superior

### Paso 2: Navegar a Credentials

1. En el menú lateral izquierdo, ve a:
   - **APIs & Services** → **Credentials**
2. O usa el buscador: escribe "Credentials" y selecciona

### Paso 3: Encontrar tu API Key de Google Maps

1. En la lista de **API Keys**, busca la que usas para Google Maps
2. Si tienes varias, busca por:
   - Nombre de la key (si le pusiste un nombre descriptivo)
   - Fecha de creación
   - Último uso
3. **Haz clic en el nombre de la API Key** para editarla

### Paso 4: Verificar Restricciones de Aplicación

**⚠️ IMPORTANTE**: La API Key DEBE tener restricciones de aplicación configuradas.

#### 4.1 Verificar Restricción de Aplicación

1. En la página de edición de la API Key, busca la sección **"Application restrictions"**
2. **Verifica que NO dice "None"** (esto es inseguro)
3. **Debe estar configurado como "Android apps"** O **"iOS apps"** O **ambos**

**⚠️ IMPORTANTE**: Si tu app va a salir para Android E iOS, puedes:
- **Opción A (Recomendada)**: Usar la MISMA API Key con restricciones para AMBAS plataformas
  - Selecciona "Android apps" y añade las restricciones de Android
  - Luego añade también "iOS apps" y añade las restricciones de iOS
  - ✅ Más simple de mantener
  - ✅ Una sola API Key para gestionar
  
- **Opción B**: Crear API Keys separadas para Android e iOS
  - Una API Key solo para Android
  - Otra API Key solo para iOS
  - ✅ Más seguro (si una se compromete, la otra sigue segura)
  - ❌ Más complejo de mantener

**Recomendación**: Usa la **Opción A** (misma API Key para ambas plataformas).

#### 4.2 Verificar Restricciones de Android

1. En la sección de restricciones de Android, verifica:
   - ✅ **Package name**: `com.perikopico.fiestapp`
   - ✅ Debe coincidir exactamente con el package name de tu app Android

#### 4.3 Verificar SHA-1 Certificate Fingerprint

**Para Debug (desarrollo)**:
1. Debe tener el SHA-1 del certificado de debug
2. Para obtenerlo, ejecuta:
   ```bash
   cd android
   ./gradlew signingReport
   ```
3. Busca en la salida el SHA-1 bajo "Variant: debug"
4. Copia el SHA-1 y verifica que está en Google Cloud Console

**Para Release (producción)**:
1. Si ya tienes el keystore de release, obtén su SHA-1:
   ```bash
   keytool -list -v -keystore ~/upload-keystore.jks -alias upload
   ```
2. Añade este SHA-1 también a las restricciones

**⚠️ NOTA**: Puedes tener múltiples SHA-1 (uno para debug, uno para release)

#### 4.4 Verificar Restricciones de iOS (si aplica)

Si tu app también va a iOS, añade restricciones de iOS a la misma API Key:

1. En la misma sección de "Application restrictions", busca **"iOS apps"**
2. Añade el **Bundle ID** de iOS:
   - ✅ **Bundle ID**: `com.perikopico.fiestapp`
   - ✅ Debe coincidir exactamente con el Bundle ID de tu app iOS

**⚠️ IMPORTANTE**: 
- Puedes tener restricciones para Android E iOS en la misma API Key
- Google Cloud Console permite añadir múltiples restricciones de aplicación
- Selecciona "Android apps" y añade las restricciones de Android
- Luego selecciona también "iOS apps" y añade el Bundle ID de iOS

### Paso 5: Verificar Restricciones de API

1. En la misma página, busca la sección **"API restrictions"**
2. **Verifica que NO dice "Don't restrict key"** (esto es inseguro)
3. **Debe estar configurado como "Restrict key"**
4. **APIs permitidas** deben incluir:
   - ✅ **Maps SDK for Android** (obligatorio si usas Android)
   - ✅ **Maps SDK for iOS** (obligatorio si usas iOS)
   - ✅ **Places API** (si usas búsqueda de lugares)
   - ✅ **Geocoding API** (si usas geocodificación)
   - ❌ NO debe incluir APIs que no uses

**⚠️ NOTA**: Si usas la misma API Key para Android e iOS, debes habilitar AMBAS APIs:
- Maps SDK for Android
- Maps SDK for iOS

### Paso 6: Guardar Cambios

1. Si hiciste cambios, haz clic en **"Save"**
2. ⚠️ **IMPORTANTE**: Los cambios pueden tardar hasta 5 minutos en aplicarse

### ✅ Checklist de Google Maps API Key

**Restricciones de Aplicación**:
- [ ] API Key tiene restricción de aplicación configurada (NO "None")
- [ ] Restricción de aplicación incluye "Android apps" (si usas Android)
- [ ] Package name de Android es correcto: `com.perikopico.fiestapp`
- [ ] SHA-1 fingerprint de debug está configurado (Android)
- [ ] SHA-1 fingerprint de release está configurado (Android, si ya tienes keystore)
- [ ] Restricción de aplicación incluye "iOS apps" (si usas iOS)
- [ ] Bundle ID de iOS es correcto: `com.perikopico.fiestapp` (si usas iOS)

**Restricciones de API**:
- [ ] API Key tiene restricción de API configurada (NO "Don't restrict key")
- [ ] Maps SDK for Android está habilitada (si usas Android)
- [ ] Maps SDK for iOS está habilitada (si usas iOS)
- [ ] Places API está habilitada (si usas búsqueda de lugares)
- [ ] Geocoding API está habilitada (si usas geocodificación)
- [ ] Solo las APIs necesarias están permitidas
- [ ] Cambios guardados

---

## 🔐 2. Verificar Supabase Keys

### SUPABASE_ANON_KEY (Clave Pública)

**✅ Esta clave está diseñada para ser pública**

- ✅ Es segura de exponer en el cliente
- ✅ Las políticas RLS protegen los datos
- ✅ No permite operaciones administrativas

**Verificación**:
- ✅ RLS está habilitado en todas las tablas
- ✅ Políticas de seguridad están configuradas
- ✅ Security Advisor muestra todo en verde

**No requiere restricciones adicionales** porque:
- Está protegida por Row Level Security (RLS)
- Solo permite operaciones según las políticas definidas
- No puede hacer operaciones administrativas

### SUPABASE_SERVICE_KEY (Clave de Servicio)

**⚠️ CRÍTICO**: Esta clave NO debe estar en el código del cliente

#### Verificación:

1. **Verificar que NO está en `.env` del proyecto Flutter**:
   ```bash
   cd /home/perikopico/StudioProjects/fiestapp
   grep -i "SERVICE" .env
   ```
   - ✅ No debe aparecer `SUPABASE_SERVICE_KEY`
   - ✅ Solo debe aparecer `SUPABASE_ANON_KEY`

2. **Verificar que NO está en el código**:
   ```bash
   grep -r "SERVICE_KEY" lib/
   ```
   - ✅ No debe aparecer ninguna referencia

3. **Verificar Edge Functions**:
   - Las Edge Functions deben usar variables de entorno de Supabase
   - No deben tener la service key hardcodeada

### ✅ Checklist de Supabase Keys

- [x] RLS habilitado en todas las tablas ✅
- [x] Security Advisor en verde ✅
- [ ] Verificar que SUPABASE_SERVICE_KEY NO está en `.env`
- [ ] Verificar que SUPABASE_SERVICE_KEY NO está en el código
- [ ] Verificar que Edge Functions usan variables de entorno

---

## 🔍 3. Verificar Otras API Keys (si aplica)

### Firebase (si usas Firebase)

- ✅ `google-services.json` está en `.gitignore`
- ✅ No hay API Keys de Firebase hardcodeadas

### Resend API Key (si usas Resend para emails)

- ✅ Está configurado como secret en Supabase Edge Functions
- ✅ NO está en el código del cliente
- ✅ NO está en `.env` del proyecto Flutter

---

## 📝 4. Obtener SHA-1 Fingerprint

### Para Debug (desarrollo)

```bash
cd /home/perikopico/StudioProjects/fiestapp/android
./gradlew signingReport
```

Busca en la salida:
```
Variant: debug
Config: debug
Store: /path/to/debug.keystore
Alias: AndroidDebugKey
SHA1: XX:XX:XX:XX:XX:XX:XX:XX:XX:XX:XX:XX:XX:XX:XX:XX:XX:XX:XX:XX
```

### Para Release (producción)

Si ya tienes el keystore de release:

```bash
keytool -list -v -keystore ~/upload-keystore.jks -alias upload
```

Busca la línea que dice:
```
SHA1: XX:XX:XX:XX:XX:XX:XX:XX:XX:XX:XX:XX:XX:XX:XX:XX:XX:XX:XX:XX
```

**⚠️ NOTA**: Si aún no has creado el keystore de release, hazlo antes de publicar. Ver `docs/GUIA_SIGNING_RELEASE.md`.

---

## ✅ 5. Checklist Final

### Google Maps API Key
- [ ] Restricción de aplicación: "Android apps" (NO "None")
- [ ] Package name correcto: `com.perikopico.fiestapp`
- [ ] SHA-1 de debug configurado
- [ ] SHA-1 de release configurado (si aplica)
- [ ] Restricción de API: "Restrict key" (NO "Don't restrict key")
- [ ] Solo APIs necesarias permitidas

### Supabase
- [x] RLS habilitado ✅
- [x] Security Advisor en verde ✅
- [ ] SUPABASE_SERVICE_KEY NO está en `.env`
- [ ] SUPABASE_SERVICE_KEY NO está en el código

### Archivos Sensibles
- [x] `.env` en `.gitignore` ✅
- [x] `local.properties` en `.gitignore` ✅
- [x] `google-services.json` en `.gitignore` ✅

---

## 🐛 Solución de Problemas

### Problema: "API key not valid" en Google Maps

**Causas posibles**:
1. API Key incorrecta
2. Restricciones muy estrictas
3. SHA-1 no coincide

**Solución**:
1. Verificar que la API Key en `local.properties` es correcta
2. Verificar que el SHA-1 en Google Cloud Console coincide con el de tu app
3. Verificar que el package name es correcto

### Problema: Google Maps no carga

**Causas posibles**:
1. API Key no configurada
2. Restricciones bloquean la app
3. APIs no habilitadas

**Solución**:
1. Verificar que `GOOGLE_MAPS_API_KEY` está en `android/local.properties`
2. Verificar restricciones en Google Cloud Console
3. Verificar que "Maps SDK for Android" está habilitada en el proyecto

---

## 📊 Resultado Esperado

Después de completar esta verificación:

✅ **Google Maps API Key**:
- Tiene restricciones de aplicación configuradas
- Tiene restricciones de API configuradas
- Solo permite tu app Android
- Solo permite las APIs necesarias

✅ **Supabase Keys**:
- ANON_KEY es pública (correcto, protegida por RLS)
- SERVICE_KEY no está en el cliente (correcto)
- Edge Functions usan variables de entorno

✅ **Seguridad General**:
- No hay API Keys hardcodeadas
- Archivos sensibles están en `.gitignore`
- Restricciones apropiadas configuradas

---

## 🔄 Próximos Pasos

Después de verificar las restricciones:

1. **Probar Google Maps en la app** (ver `docs/ROADMAP_VERIFICACION_PRE_LANZAMIENTO.md`)
2. **Actualizar el roadmap** marcando esta tarea como completada
3. **Documentar cualquier problema encontrado**

---

**Última actualización**: Enero 2025  
**Próxima acción**: Verificar restricciones en Google Cloud Console

