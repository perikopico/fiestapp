# 📋 Ejecutar Migración 012: Verificación de Código por Usuario

## Objetivo
Permitir que los usuarios verifiquen su propio código de ownership directamente desde la app, sin necesidad de que el admin lo haga.

## Pasos

### 1. Ejecutar la Migración SQL

1. Ve a Supabase Dashboard: https://supabase.com/dashboard
2. Selecciona tu proyecto
3. Ve a **SQL Editor**
4. Abre el archivo: `docs/migrations/012_add_user_verification_function.sql`
5. Copia todo el contenido
6. Pégalo en el SQL Editor
7. Haz clic en **Run** o presiona `Ctrl+Enter`
8. Verifica que no hay errores

### 2. Verificar que la Función se Creó

Ejecuta esta consulta en el SQL Editor:

```sql
SELECT 
  routine_name,
  routine_type
FROM information_schema.routines
WHERE routine_schema = 'public'
  AND routine_name = 'verify_venue_ownership_by_user';
```

Deberías ver la función listada.

### 3. Probar la Funcionalidad

1. Como usuario, reclama un venue
2. Como admin, ve la solicitud y contacta al usuario con el código
3. Como usuario, ve a Perfil → "Verificar código de ownership"
4. Introduce el código
5. Verifica que el ownership se asigna correctamente

## Notas

- Esta migración añade una nueva función SQL que permite a los usuarios verificar su propio código
- La función verifica automáticamente que:
  - El usuario está autenticado
  - El código pertenece a una solicitud del usuario
  - La solicitud está pendiente y no expirada
- Una vez verificada, el ownership se asigna automáticamente

