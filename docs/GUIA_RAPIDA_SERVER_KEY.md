# ⚡ Guía Rápida: Obtener Server Key

## 📍 En la Pantalla Donde Estás

### Paso 1: Habilitar API Heredada

1. **Busca la sección** que dice: `API de Cloud Messaging (heredada)`
2. **Está en estado** `Inhabilitado` 
3. **A la derecha hay tres puntos** (⋮) → **Haz clic ahí**
4. **Selecciona "Habilitar"**

### Paso 2: Copiar Server Key

Una vez habilitada:
- Aparecerá un campo **"Clave del servidor"** o **"Server key"**
- Haz clic en el icono de ojo (👁️) para mostrarla
- **Copia toda la clave** (es muy larga)

### Paso 3: Agregar al .env

Abre `.env` y agrega:

```env
FCM_SERVER_KEY=AAAAxxxxx:APA91b...pega-aqui-toda-la-clave...
```

---

**¡Eso es todo!** Una vez agregada la clave, las notificaciones automáticas funcionarán. 🎉

