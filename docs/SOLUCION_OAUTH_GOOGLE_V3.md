# 🔧 Solución: Problema Intermitente con Login de Google OAuth

## Problema
A veces el login con Google funciona, pero la mayoría de las veces redirige a Gmail en lugar de volver a la app.

## Causa Principal
El navegador (Chrome/Gmail) está interceptando el deep link antes de que llegue a la app. Esto sucede porque:
1. El navegador predeterminado puede capturar URLs que parecen ser de su dominio
2. El intent-filter no es lo suficientemente específico
3. Android puede estar confundiendo el deep link con una URL de Gmail

## Soluciones Implementadas

### 1. Intent-Filter Mejorado
He mejorado el `AndroidManifest.xml` para que los intent-filters sean más específicos:
- Añadido `android:autoVerify="true"` para verificación automática
- Especificado `android:host` para cada deep link
- Separados los intent-filters por tipo de callback

### 2. Verificación de URLs en Supabase
Asegúrate de que estas URLs estén en Supabase Dashboard → Authentication → URL Configuration:
```
io.supabase.fiestapp://login-callback
io.supabase.fiestapp://auth/confirmed
io.supabase.fiestapp://reset-password
```

## Soluciones Adicionales

### Solución 1: Cambiar Navegador Predeterminado Temporalmente
1. Ve a Configuración → Apps → Navegador predeterminado
2. Cambia temporalmente a Chrome (si no es el predeterminado)
3. O desactiva Gmail como app predeterminada para links

### Solución 2: Usar Custom Tabs en lugar de Navegador Completo
Podríamos implementar Chrome Custom Tabs que manejan mejor los deep links. Esto requeriría:
- Añadir dependencia `flutter_inappwebview` o similar
- Modificar el código de OAuth para usar Custom Tabs

### Solución 3: Verificar que el Deep Link Funciona
Prueba abrir manualmente el deep link:
```bash
adb shell am start -a android.intent.action.VIEW -d "io.supabase.fiestapp://login-callback?code=test"
```

Si esto NO abre la app, hay un problema con el AndroidManifest.xml.

### Solución 4: Limpiar Caché del Navegador
1. Ve a Configuración → Apps → Chrome (o tu navegador)
2. Almacenamiento → Limpiar caché
3. Vuelve a intentar

### Solución 5: Verificar Políticas de Android
En Android 12+, puede haber políticas que bloqueen deep links. Verifica:
1. Configuración → Apps → QuePlan → Abrir por defecto
2. Asegúrate de que "Abrir links compatibles" esté activado

## Debugging

### Ver Logs de Android
```bash
adb logcat | grep -i "supabase\|oauth\|deep\|intent"
```

Busca mensajes como:
- `Intent received: io.supabase.fiestapp://login-callback`
- `Deep link captured`
- `OAuth callback received`

### Verificar que el Intent-Filter Está Registrado
```bash
adb shell dumpsys package com.perikopico.fiestapp | grep -A 10 "io.supabase.fiestapp"
```

Deberías ver los intent-filters listados.

## Si Nada Funciona

Considera usar un método alternativo:
1. **Usar Custom Tabs**: Más control sobre el flujo OAuth
2. **Usar WebView interno**: Manejar OAuth completamente dentro de la app
3. **Usar Firebase Auth directamente**: En lugar de Supabase OAuth

## Notas

- El problema es intermitente porque depende de qué app capture primero el deep link
- Gmail puede estar configurado como handler predeterminado para ciertos tipos de URLs
- La solución más robusta sería usar Chrome Custom Tabs o WebView interno

