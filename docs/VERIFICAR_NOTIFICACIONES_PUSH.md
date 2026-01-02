# 📱 Verificar Notificaciones Push

**Fecha**: Enero 2025  
**Tiempo estimado**: 10 minutos

---

## 📋 Checklist de Verificación

### 1. Verificar Edge Function Desplegada

**Pasos**:
1. Ir a Supabase Dashboard
2. Navegar a **Edge Functions** (menú lateral)
3. Buscar la función `send_fcm_notification`
4. Verificar que:
   - [ ] La función existe
   - [ ] Está desplegada (no en borrador)
   - [ ] Tiene la última versión

**Resultado esperado**: ✅ Función desplegada y activa

**Tiempo**: 2 minutos

---

### 2. Verificar Variables de Entorno

**Pasos**:
1. En Supabase Dashboard, ir a **Project Settings** > **Edge Functions** > **Secrets**
2. Verificar que existen:
   - [ ] `FIREBASE_PROJECT_ID` - ID del proyecto Firebase
   - [ ] `FIREBASE_SERVICE_ACCOUNT_KEY` - JSON del Service Account

**Nota**: Si no están configuradas, la función no funcionará completamente, pero el sistema seguirá funcionando (solo no enviará notificaciones push automáticas).

**Tiempo**: 2 minutos

---

### 3. Verificar Tabla de Tokens FCM

**Verificar en Supabase SQL Editor**:
```sql
-- Verificar que la tabla existe
SELECT table_name 
FROM information_schema.tables 
WHERE table_schema = 'public' 
  AND table_name = 'user_fcm_tokens';

-- Verificar que hay tokens guardados
SELECT COUNT(*) as total_tokens
FROM user_fcm_tokens;
```

**Resultado esperado**: 
- Tabla existe
- Hay tokens guardados (si hay usuarios con la app instalada)

**Tiempo**: 1 minuto

---

### 4. Probar Envío de Notificación

#### Opción A: Desde la App (si hay funcionalidad)
1. [ ] Como admin, buscar opción de enviar notificación de prueba
2. [ ] Enviar notificación
3. [ ] Verificar que llega al dispositivo

#### Opción B: Desde Supabase (Edge Function)
1. [ ] Ir a Supabase Dashboard > Edge Functions
2. [ ] Seleccionar `send_fcm_notification`
3. [ ] Ir a "Invoke" o "Test"
4. [ ] Enviar payload de prueba:
```json
{
  "token": "TOKEN_FCM_DEL_DISPOSITIVO",
  "title": "Test de notificación",
  "body": "Esta es una notificación de prueba"
}
```
5. [ ] Verificar que llega al dispositivo

**Resultado esperado**: ✅ Notificación llega al dispositivo

**Tiempo**: 5 minutos

---

## 🐛 Problemas Comunes

### Problema: Edge Function no está desplegada
**Solución**:
- Desplegar manualmente desde el código
- O usar Supabase CLI: `supabase functions deploy send_fcm_notification`

### Problema: Variables de entorno no configuradas
**Solución**:
- Configurar en Supabase Dashboard > Project Settings > Edge Functions > Secrets
- O dejar para más adelante (el sistema funcionará sin notificaciones push)

### Problema: Notificación no llega
**Posibles causas**:
1. Token FCM no válido
2. Variables de entorno incorrectas
3. Firebase no configurado correctamente
4. Permisos de notificaciones no concedidos

**Soluciones**:
- Verificar que el token FCM es válido
- Verificar configuración de Firebase
- Verificar permisos en la app

---

## ✅ Resultado Esperado

- ✅ Edge Function desplegada
- ✅ Variables de entorno configuradas (opcional)
- ✅ Tabla de tokens existe
- ✅ Notificaciones funcionan (opcional, puede probarse después)

---

## 📝 Notas

- Las notificaciones push son opcionales para el funcionamiento básico
- El sistema funcionará sin ellas (solo no enviará notificaciones automáticas)
- Se puede configurar después del lanzamiento si es necesario

---

**Tiempo total**: 10 minutos




