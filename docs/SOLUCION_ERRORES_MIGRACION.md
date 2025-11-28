# Solución de Errores de Migración SQL

## ✅ Problema Resuelto

### Error: "policy already exists"

El script SQL original intentaba crear políticas que ya existían. He actualizado el script para que:

1. **Elimine las políticas antes de crearlas** usando `DROP POLICY IF EXISTS`
2. Esto permite ejecutar el script múltiples veces sin errores
3. Si las políticas no existen, simplemente las crea

## 📋 Cambios Realizados

He añadido `DROP POLICY IF EXISTS` antes de cada `CREATE POLICY` para:

- ✅ `admins` - política de lectura
- ✅ `user_favorites` - políticas de lectura, inserción y eliminación
- ✅ `events` - todas las políticas (lectura, actualización, inserción, eliminación)

## 🔄 Ahora Puedes:

1. **Ejecutar el script SQL completo** sin errores
2. **Ejecutarlo múltiples veces** si necesitas actualizar algo
3. Las políticas se recrearán cada vez, asegurando que estén actualizadas

## 📝 Ejecutar Migración Corregida

1. Ve a **Supabase Dashboard** > **SQL Editor**
2. Copia y pega el contenido completo de `docs/migrations/001_create_auth_tables.sql`
3. Haz clic en **Run**
4. Deberías ver "Success" sin errores ✅

