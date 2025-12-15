# 🔐 Rotar API Keys Expuestas - Acción Urgente

## ⚠️ ALERTA DE SEGURIDAD

Se detectaron API keys de Google Maps expuestas en el repositorio de GitHub. **Debes rotarlas inmediatamente** para evitar uso no autorizado.

## 📋 API Keys Expuestas Detectadas

Las siguientes API keys fueron encontradas en el código y documentación:

1. `AIzaSyDCE_o8jBruKq0__AJRL7SA8ztMCJrsK04` - Encontrada en:
   - `android/app/src/main/AndroidManifest.xml` (ya eliminada)
   - `lib/ui/events/event_submit_screen.dart` (ya eliminada)
   - `lib/services/google_places_service.dart` (ya eliminada)
   - Varios archivos de documentación (ya limpiados)

2. `AIzaSyB3QZYmsSb1GmIewWnDS-KewupE3Ths_dY` - Encontrada en:
   - Archivos de documentación (ya limpiados)

3. `AIzaSyBlGvnFjcZ2NMNBgIt4ylNIo5W8TeBtyuI` - Encontrada en:
   - Archivos de documentación (ya limpiados)

## ✅ Acciones Ya Realizadas

1. ✅ Eliminada API key hardcodeada del `AndroidManifest.xml`
2. ✅ Configurado `build.gradle.kts` para leer la key desde `local.properties`
3. ✅ Eliminados fallbacks hardcodeados en el código Dart
4. ✅ Limpiadas las keys de los archivos de documentación
5. ✅ Verificado que `.env` y `local.properties` están en `.gitignore`

## 🚨 ACCIONES URGENTES REQUERIDAS

### ⚠️ ¿Debo rotar la key aunque tenga restricciones de SHA-1?

**SÍ, DEBES ROTARLA INCLUSO CON RESTRICCIONES DE SHA-1**

**Razones:**

1. **El SHA-1 puede estar expuesto**: Si el SHA-1 está en documentación o commits públicos, cualquiera puede verlo
2. **Package name público**: Tu package name (`com.perikopico.fiestapp`) es público en el código
3. **Cualquiera puede crear una app con el mismo SHA-1**: Si alguien tiene acceso a tu keystore o puede generar el mismo SHA-1, puede usar tu key
4. **No sabes quién ya la vio**: Una vez expuesta, no puedes saber quién la copió
5. **Mejor prevenir que curar**: Rotar es gratis y rápido, un ataque puede costarte dinero

**Conclusión:** **ROTA LA KEY SIEMPRE**, incluso con restricciones.

### 1. Rotar las API Keys en Google Cloud Console

**Para cada API key expuesta:**

1. Ve a [Google Cloud Console](https://console.cloud.google.com/)
2. Navega a **APIs & Services > Credentials**
3. Encuentra cada API key expuesta
4. **ELIMINA** las keys expuestas (recomendado) o al menos **RESTRINGE** temporalmente hasta crear la nueva

### 2. Crear Nueva API Key

1. En Google Cloud Console, crea una **nueva API key**
2. **Configura restricciones INMEDIATAMENTE** (antes de usarla):
   - **Application restrictions**: 
     - Android apps
     - Package name: `com.perikopico.fiestapp`
     - SHA-1: (obtén el SHA-1 de tu app con `cd android && ./gradlew signingReport`)
     - **IMPORTANTE**: Añade TODOS los SHA-1 que uses (debug, release, etc.)
   - **API restrictions**:
     - Maps SDK for Android
     - Places API (New)
     - Geocoding API
3. **NO** añadas la nueva key al código hasta que hayas eliminado/restringido las antiguas

**💡 Tip:** Si tienes múltiples SHA-1 (debug, release, etc.), añádelos todos a la nueva key para evitar problemas.

### 3. Actualizar Configuración Local

Una vez que tengas la nueva API key:

1. **Actualiza `android/local.properties`:**
   ```properties
   GOOGLE_MAPS_API_KEY=TU_NUEVA_API_KEY_AQUI
   ```

2. **Actualiza `.env` (en la raíz del proyecto):**
   ```
   GOOGLE_MAPS_API_KEY=TU_NUEVA_API_KEY_AQUI
   ```

3. **Verifica que funcionan:**
   ```bash
   flutter clean
   flutter pub get
   flutter run
   ```

### 4. Limpiar Historial de Git (Opcional pero Recomendado)

Si el repositorio es público, considera:

1. **Usar BFG Repo-Cleaner o git-filter-repo** para eliminar las keys del historial
2. **O crear un nuevo repositorio** y migrar el código (sin historial)

⚠️ **Nota:** Si el repo es privado, esto es menos crítico, pero aún recomendable.

## 📝 Verificación Post-Rotación

Después de rotar las keys, verifica:

- [ ] Las keys antiguas están eliminadas o restringidas en Google Cloud Console
- [ ] La nueva key está configurada en `local.properties`
- [ ] La nueva key está configurada en `.env`
- [ ] La app compila correctamente
- [ ] Los mapas funcionan en la app
- [ ] Google Places funciona correctamente
- [ ] No hay keys hardcodeadas en el código

## 🔒 Prevención Futura

Para evitar que esto vuelva a pasar:

1. ✅ **NUNCA** hardcodees API keys en el código
2. ✅ **SIEMPRE** usa variables de entorno (`.env`, `local.properties`)
3. ✅ **VERIFICA** que `.env` y `local.properties` están en `.gitignore`
4. ✅ **REVISA** los commits antes de hacer push
5. ✅ Considera usar **GitHub Secrets** para CI/CD
6. ✅ Usa herramientas como **git-secrets** o **truffleHog** para detectar secrets

## 📚 Recursos

- [Google Cloud Console - Credentials](https://console.cloud.google.com/apis/credentials)
- [GitHub - Removing sensitive data](https://docs.github.com/en/authentication/keeping-your-account-and-data-secure/removing-sensitive-data-from-a-repository)
- [BFG Repo-Cleaner](https://rtyley.github.io/bfg-repo-cleaner/)

---

**Fecha de creación:** Diciembre 2024  
**Estado:** 🔴 URGENTE - Requiere acción inmediata

