# 📍 Dónde Está el Server Key en Firebase Console

## 🔍 Ubicación Exacta

### En la Pantalla Donde Estás Ahora:

1. **Scroll hacia abajo** un poco
2. **Busca la sección:** `API de Cloud Messaging (heredada)` 
3. **Verás que dice:** `Inhabilitado` con un menú de tres puntos (⋯)
4. **Haz clic en los tres puntos** (⋯)
5. **Selecciona "Habilitar"**

### Después de Habilitar:

1. El estado cambiará a **"Habilitado"**
2. **Aparecerá un campo** que dice **"Clave del servidor"** o **"Server key"**
3. **Haz clic en el icono de ojo** (👁️) para mostrarla
4. **Copia toda la clave** (es muy larga, empieza con `AAAA...`)

---

## 📝 Luego Agrega al .env

```env
FCM_SERVER_KEY=AAAAxxxxx:APA91b...pega-aqui-toda-la-clave...
```

---

## ⚠️ Si No Aparece la Opción de Habilitar

Puede que necesites:
- Verificar que tienes permisos de administrador en el proyecto
- O que la API heredada ya no esté disponible en tu cuenta

En ese caso, podemos usar una **Supabase Edge Function** en su lugar.

---

**¿Ves los tres puntos (⋯) junto a "Inhabilitado"? Haz clic ahí y habilita la API heredada.**

