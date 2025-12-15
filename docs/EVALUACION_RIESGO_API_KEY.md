# 🔍 Evaluación de Riesgo: API Key con Restricciones

## ✅ Tu Situación Actual

**API Key con restricciones:**
- ✅ Restricción de aplicación: Android apps
- ✅ Package name: `com.perikopico.fiestapp`
- ✅ SHA-1: Configurado

## ⚠️ Factores de Riesgo

### 1. SHA-1 También Está Expuesto

**Problema:** El SHA-1 está mencionado en varios archivos de documentación:
- `12:FE:47:5B:A4:14:D7:44:D0:C4:F8:C2:C3:68:F2:6A:63:8A:AD:7A`

**Impacto:** Si el repositorio es público, cualquiera puede ver:
- La API key (ya eliminada del código)
- El SHA-1 (en documentación)
- El package name (en el código)

### 2. Package Name Es Público

El package name `com.perikopico.fiestapp` está en:
- `android/app/build.gradle.kts`
- `AndroidManifest.xml`
- Cualquier archivo de configuración

### 3. ¿Es el Repositorio Público o Privado?

**Si es PRIVADO:**
- ✅ Riesgo menor (solo personas con acceso pueden ver)
- ⚠️ Pero aún existe riesgo si alguien con acceso la copia

**Si es PÚBLICO:**
- 🔴 Riesgo mayor (cualquiera puede ver SHA-1 + package name)
- ⚠️ Alguien podría intentar usar la key

## 🎯 Evaluación de Riesgo

### Con Restricciones de SHA-1 + Package Name:

**Protección:**
- ✅ Google valida que la app tenga el SHA-1 correcto
- ✅ Google valida que la app tenga el package name correcto
- ✅ Solo apps firmadas con tu keystore pueden usar la key

**Riesgo Residual:**
- ⚠️ Si alguien tiene acceso a tu keystore, puede usar la key
- ⚠️ Si alguien puede generar el mismo SHA-1, puede usar la key
- ⚠️ No puedes saber si alguien ya la copió antes de que la elimináramos del código

## 💡 Recomendación

### Opción A: Seguir Usándola (Riesgo Aceptable)

**Si:**
- ✅ El repositorio es PRIVADO
- ✅ Tienes restricciones estrictas (SHA-1 + package name)
- ✅ Monitoreas el uso en Google Cloud Console
- ✅ Tienes alertas de facturación configuradas

**Acciones:**
1. **Monitorear uso en Google Cloud Console:**
   - Ve a **APIs & Services > Dashboard**
   - Revisa el uso de Maps API, Places API, Geocoding API
   - Configura alertas de facturación

2. **Configurar alertas:**
   - En Google Cloud Console, ve a **Billing > Budgets & alerts**
   - Crea una alerta si el uso supera un umbral

3. **Revisar logs periódicamente:**
   - Verifica que el uso coincide con tu app
   - Busca peticiones sospechosas

### Opción B: Rotarla (Más Seguro)

**Si:**
- 🔴 El repositorio es PÚBLICO
- 🔴 Quieres máxima seguridad
- 🔴 Prefieres prevenir que curar

**Ventajas:**
- ✅ Elimina cualquier riesgo residual
- ✅ Te da tranquilidad
- ✅ Es gratis y rápido

## 📊 Comparación

| Factor | Con Restricciones | Sin Restricciones |
|--------|------------------|-------------------|
| Riesgo de uso no autorizado | 🟡 Bajo-Medio | 🔴 Alto |
| Protección | ✅ Buena | ❌ Ninguna |
| Necesita rotación | ⚠️ Depende del contexto | ✅ Sí, urgente |

## 🎯 Decisión Final

**Puedes seguir usándola SI:**
1. ✅ Tienes restricciones de SHA-1 + package name
2. ✅ Monitoreas el uso regularmente
3. ✅ Tienes alertas de facturación
4. ✅ El repositorio es privado (o estás dispuesto a aceptar el riesgo)

**Deberías rotarla SI:**
1. 🔴 El repositorio es público
2. 🔴 Quieres máxima seguridad
3. 🔴 Prefieres prevenir que curar
4. 🔴 Has visto uso sospechoso en Google Cloud Console

## 📝 Cómo Monitorear el Uso

1. **Google Cloud Console > APIs & Services > Dashboard**
   - Revisa el uso diario/semanal
   - Verifica que coincide con tu app

2. **Configurar Alertas de Facturación:**
   - Billing > Budgets & alerts
   - Crea alerta si el uso supera X€/mes

3. **Revisar Logs:**
   - APIs & Services > Logs
   - Busca peticiones inusuales

---

**Conclusión:** Con restricciones estrictas, el riesgo es aceptable si monitoreas. Pero rotarla es la opción más segura.

