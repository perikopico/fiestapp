# 🔑 Obtener Server Key de Firebase para Notificaciones

## ⚠️ Importante

La API heredada de Firebase está deshabilitada por defecto. Necesitas habilitarla temporalmente para obtener el Server Key.

---

## 📋 Pasos para Habilitar y Obtener el Server Key

### Paso 1: Habilitar la API heredada

1. **En la pantalla donde estás** (Configuración de Cloud Messaging)
2. **Busca la sección "API de Cloud Messaging (heredada)"**
3. **Debería decir "Inhabilitado"** con un menú de tres puntos (⋯) a la derecha
4. **Haz clic en los tres puntos** (⋯)
5. **Selecciona "Habilitar"** o **"Enable"**

### Paso 2: Obtener el Server Key

Una vez habilitada la API heredada:

1. **La sección cambiará a "Habilitado"**
2. **Aparecerá un campo "Clave del servidor"** o **"Server key"**
3. **Haz clic en el icono de "mostrar"** (👁️) o **"copiar"** (📋)
4. **Copia la clave** (empieza con `AAAA...`)

### Paso 3: Agregar al archivo .env

Abre tu archivo `.env` y agrega:

```env
FCM_SERVER_KEY=AAAAxxxxx:APA91b...tu-server-key-completa-aqui...
```

**Importante:**
- No agregues comillas alrededor del valor
- No dejes espacios alrededor del `=`
- Copia la clave completa

---

## 🔄 Alternativa: Usar la API V1 Moderna (Recomendado a largo plazo)

Si prefieres usar la API moderna (HTTP v1), necesitarías:

1. Crear una **Service Account** en Firebase
2. Descargar el archivo JSON de la cuenta de servicio
3. Usar autenticación OAuth2 en lugar de Server Key

**Nota:** Esto requiere más configuración. Para desarrollo rápido, puedes usar la API heredada por ahora y migrar más adelante.

---

## 🚨 Advertencia

La API heredada estará **obsoleta el 20 de junio de 2024**, pero aún funciona. Para producción, considera migrar a la API V1 en el futuro.

---

## ✅ Verificación

Después de agregar el Server Key al `.env`:

1. **Reinicia la app**
2. **Aprueba un evento** desde el panel admin
3. **Verifica los logs** de Flutter para ver si la notificación se envía correctamente

---

**¿Tienes el Server Key? Agrégalo al `.env` y probamos las notificaciones automáticas.**

