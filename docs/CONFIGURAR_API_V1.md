# 🔔 Configurar Notificaciones con API V1 (Moderna)

## ✅ Estado

La API V1 moderna está habilitada en Firebase. Necesitamos configurarla para enviar notificaciones.

---

## 🔑 Opción 1: Usar Supabase Edge Function (Recomendado)

La mejor forma es crear una **Supabase Edge Function** que use la API V1 de Firebase. Esto mantiene las credenciales seguras en el servidor.

### Ventajas:
- ✅ Credenciales seguras (no en el cliente)
- ✅ Más fácil de mantener
- ✅ Escalable

---

## 🔑 Opción 2: Usar Service Account en Flutter (Alternativa)

Si prefieres hacerlo directamente desde Flutter, necesitas:

1. **Crear Service Account en Firebase:**
   - Firebase Console → Configuración del proyecto → Cuentas de servicio
   - Crear nueva cuenta de servicio
   - Descargar el archivo JSON

2. **Usar el JSON para autenticación OAuth2**

3. **Enviar notificaciones con API V1**

**Nota:** Esto requiere más configuración y el archivo JSON debe mantenerse seguro.

---

## 🎯 Recomendación

**Usar Supabase Edge Function** es la mejor opción porque:
- Las credenciales no están en el código de la app
- Más seguro
- Más fácil de actualizar

---

**¿Prefieres que implementemos la solución con Supabase Edge Function o con Service Account directo?**

