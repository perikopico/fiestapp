# 🔧 Solución: Error "Code verifier could not be found" en iOS

**Fecha**: Enero 2025  
**Problema**: Error de OAuth PKCE al iniciar sesión con Google en iOS

---

## 🚨 Error Observado

```
AuthException(message: Code verifier could not be found in local storage., statusCode: null, code: null)
```

**Síntomas:**
- El usuario se autentica correctamente con Google
- Aparece el mensaje "✅ Usuario autenticado: info@queplan-app.com"
- Pero luego falla al intercambiar el código por la sesión
- El deep link se maneja múltiples veces

---

## 🔍 Causa del Problema

El error ocurre cuando:
1. El deep link se maneja **múltiples veces** (veo en logs que se maneja 2 veces)
2. El **code verifier** se pierde entre el inicio del flujo OAuth y el callback
3. Supabase intenta intercambiar el código pero no encuentra el code verifier en el almacenamiento local

**Por qué sucede:**
- iOS puede manejar el deep link antes de que Supabase termine de guardar el code verifier
- El AppDelegate y Supabase pueden estar manejando el mismo deep link simultáneamente
- Problemas de timing en el almacenamiento local de iOS

---

## ✅ Soluciones Aplicadas

### 1. Simplificar el flujo OAuth

He simplificado el código de autenticación para evitar intentos múltiples que puedan causar problemas:

```dart
// Antes: Intentaba múltiples métodos
// Ahora: Usa solo el método estándar
await client.auth.signInWithOAuth(
  OAuthProvider.google,
  redirectTo: deepLinkUrl,
);
```

### 2. Mejorar manejo de errores de Firebase

Firebase ahora se inicializa de forma más robusta y los errores no bloquean el login.

---

## 🧪 Cómo Probar

1. **Desinstala completamente la app del iPhone**:
   - Mantén presionado el icono de la app
   - Selecciona "Eliminar app"
   - Confirma la eliminación

2. **Limpia el build de Flutter**:
   ```bash
   flutter clean
   flutter pub get
   ```

3. **Reinstala la app**:
   ```bash
   flutter run
   ```

4. **Intenta iniciar sesión con Google**:
   - Deberías ver que se abre Safari
   - Autoriza con Google
   - Safari se cierra automáticamente
   - La app vuelve al primer plano
   - El login se completa sin errores

---

## 🔄 Si Aún No Funciona

### Opción 1: Verificar que el deep link solo se maneja una vez

Añade logs adicionales para ver cuántas veces se maneja el deep link:

```dart
// En main.dart, después de inicializar Supabase
Supabase.instance.client.auth.onAuthStateChange.listen((data) {
  debugPrint('🔔 Auth state change: ${data.event}');
});
```

### Opción 2: Limpiar almacenamiento local antes de login

Si el problema persiste, puedes intentar limpiar el almacenamiento local antes de iniciar sesión:

```dart
// En auth_service.dart, antes de signInWithOAuth
try {
  // Limpiar cualquier sesión previa que pueda causar conflictos
  await client.auth.signOut();
} catch (e) {
  // Ignorar si no hay sesión
}
```

### Opción 3: Usar un método alternativo de OAuth

Si el problema persiste, puedes considerar usar el método de OAuth con `authFlowType`:

```dart
await client.auth.signInWithOAuth(
  OAuthProvider.google,
  redirectTo: deepLinkUrl,
  authFlowType: AuthFlowType.pkce,
);
```

---

## 📊 Logs Esperados (Cuando Funciona)

```
✅ Redirigiendo a Google OAuth
📍 Deep link: io.supabase.fiestapp://login-callback
supabase.supabase_flutter: INFO: handle deeplink uri
✅ Usuario autenticado: info@queplan-app.com
✅ Favoritos sincronizados
✅ Token FCM guardado después de login
```

**NO deberías ver:**
- ❌ "Code verifier could not be found"
- ❌ Múltiples "handle deeplink uri"
- ❌ Errores de AuthException

---

## 🔍 Debugging Adicional

Si el problema persiste, ejecuta con logs detallados:

```bash
flutter run -v
```

Busca estos mensajes:
- `handle deeplink uri` - Debe aparecer solo UNA vez
- `Code verifier` - No debe aparecer en errores
- `exchangeCodeForSession` - Debe completarse exitosamente

---

## 📝 Notas Importantes

1. **El error de Firebase es secundario**: Los errores de Firebase no bloquean el login, solo afectan las notificaciones push.

2. **El problema principal es OAuth PKCE**: El error "Code verifier could not be found" es el que impide el login.

3. **Los cambios aplicados deberían resolver el problema**: La simplificación del flujo OAuth y el mejor manejo de errores deberían solucionar el issue.

---

## 🔗 Referencias

- [Supabase Flutter OAuth Documentation](https://supabase.com/docs/guides/auth/social-login/auth-google)
- [OAuth PKCE Flow](https://oauth.net/2/pkce/)
- [iOS Deep Links](https://developer.apple.com/documentation/xcode/allowing-apps-and-websites-to-link-to-your-content)

