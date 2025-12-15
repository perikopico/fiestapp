# 🔒 Guía para Corregir Errores de Seguridad en Supabase

Has recibido una notificación de Supabase Security Advisor indicando que hay **3 errores** en tu proyecto que requieren atención inmediata.

## 📋 Problemas Comunes Detectados

Los errores más comunes que detecta Supabase Security Advisor son:

1. **Tablas sin RLS (Row Level Security) habilitado**
   - Las tablas `cities` y `categories` probablemente no tienen RLS configurado
   - Otras tablas como `venues`, `user_fcm_tokens` pueden tener el mismo problema

2. **Tablas con RLS habilitado pero sin políticas**
   - Si RLS está habilitado pero no hay políticas, nadie puede acceder a los datos

3. **Políticas RLS demasiado permisivas**
   - Políticas que permiten acceso público a datos sensibles

## ✅ Solución Rápida

### Paso 1: Ejecutar el Script de Corrección

1. Ve a tu proyecto en [Supabase Dashboard](https://app.supabase.com)
2. Navega a **SQL Editor**
3. Abre el archivo: `docs/migrations/007_fix_security_issues.sql`
4. Copia todo el contenido del archivo
5. Pégalo en el SQL Editor de Supabase
6. Haz clic en **RUN** o presiona `Ctrl+Enter` (o `Cmd+Enter` en Mac)
7. Verifica que no haya errores en la ejecución

### Paso 2: Verificar el Estado de Seguridad

Después de ejecutar el script, verifica el estado:

1. Ve a **Security Advisor** en el Dashboard de Supabase
2. Deberías ver que los errores se han reducido o eliminado
3. Si aún hay errores, revisa qué tablas específicas están causando problemas

### Paso 3: Verificación Manual (Opcional)

Ejecuta este query en el SQL Editor para ver el estado de todas las tablas:

```sql
SELECT 
    tablename AS "Tabla",
    CASE 
        WHEN rowsecurity THEN '✅ RLS Habilitado' 
        ELSE '❌ RLS Deshabilitado' 
    END AS "Estado",
    (SELECT COUNT(*) FROM pg_policies 
     WHERE schemaname = 'public' 
     AND tablename = t.tablename) AS "Políticas"
FROM pg_tables t
WHERE schemaname = 'public'
ORDER BY tablename;
```

## 🔍 Qué Hace el Script

El script `007_fix_security_issues.sql` realiza las siguientes acciones:

1. **Habilita RLS** en todas las tablas públicas que lo necesiten:
   - `cities`
   - `categories`
   - `venues`
   - `venue_managers`
   - `user_fcm_tokens`

2. **Crea políticas de seguridad** apropiadas:
   - **cities**: Lectura pública, modificación solo para admins
   - **categories**: Lectura pública, modificación solo para admins
   - Verifica que otras tablas tengan sus políticas configuradas

3. **Muestra un reporte** del estado de seguridad después de la ejecución

## 📊 Tablas y sus Políticas de Seguridad

### Tablas de Referencia (Lectura Pública)

- **`cities`**: Cualquiera puede leer, solo admins pueden modificar
- **`categories`**: Cualquiera puede leer, solo admins pueden modificar

### Tablas de Usuario

- **`user_favorites`**: Los usuarios solo pueden ver/editar sus propios favoritos
- **`user_fcm_tokens`**: Los usuarios solo pueden gestionar sus propios tokens

### Tablas de Contenido

- **`events`**: 
  - Lectura pública de eventos publicados
  - Los usuarios pueden ver sus propios eventos (incluso pendientes)
  - Solo admins pueden aprobar/rechazar/eliminar

- **`venues`**: 
  - Lectura pública de lugares aprobados
  - Los usuarios pueden ver lugares que crearon
  - Solo admins pueden aprobar/rechazar/eliminar

### Tablas de Administración

- **`admins`**: Los usuarios pueden ver si son admin, pero no pueden modificarlo
- **`venue_managers`**: Solo admins pueden gestionar

## 🚨 Si Aún Hay Errores

Si después de ejecutar el script aún aparecen errores en Security Advisor:

1. **Revisa el Security Advisor** en Supabase Dashboard
   - Te mostrará exactamente qué tablas tienen problemas
   - Lee las recomendaciones específicas

2. **Verifica tablas adicionales** que puedan existir:
   ```sql
   SELECT table_name 
   FROM information_schema.tables 
   WHERE table_schema = 'public'
   ORDER BY table_name;
   ```

3. **Habilita RLS manualmente** en tablas que falten:
   ```sql
   ALTER TABLE public.nombre_tabla ENABLE ROW LEVEL SECURITY;
   ```

4. **Crea políticas apropiadas** según el tipo de datos:
   - Si son datos públicos: `USING (true)` para SELECT
   - Si son datos privados: `USING (auth.uid() = user_id)`
   - Si son datos de admin: Verificar existencia en tabla `admins`

## 📝 Ejemplo de Política para Nueva Tabla

Si necesitas crear una política para una nueva tabla, aquí tienes ejemplos:

### Lectura Pública
```sql
CREATE POLICY "Anyone can read" ON public.tabla
  FOR SELECT
  USING (true);
```

### Solo el Propietario
```sql
CREATE POLICY "Users can manage own data" ON public.tabla
  FOR ALL
  USING (auth.uid() = user_id)
  WITH CHECK (auth.uid() = user_id);
```

### Solo Admins
```sql
CREATE POLICY "Admins can manage" ON public.tabla
  FOR ALL
  USING (
    EXISTS (
      SELECT 1 FROM public.admins
      WHERE admins.user_id = auth.uid()
    )
  )
  WITH CHECK (
    EXISTS (
      SELECT 1 FROM public.admins
      WHERE admins.user_id = auth.uid()
    )
  );
```

## ✅ Checklist de Verificación

Después de ejecutar el script, verifica:

- [ ] No hay errores en la ejecución del script SQL
- [ ] Security Advisor muestra menos errores (o ninguno)
- [ ] Las tablas `cities` y `categories` tienen RLS habilitado
- [ ] Puedes leer datos de `cities` y `categories` desde la app
- [ ] Los usuarios pueden gestionar sus propios favoritos
- [ ] Los eventos públicos se pueden leer sin autenticación

## 🔗 Recursos Adicionales

- [Documentación de RLS en Supabase](https://supabase.com/docs/guides/auth/row-level-security)
- [Security Advisor de Supabase](https://supabase.com/docs/guides/platform/security-advisor)
- [Mejores Prácticas de Seguridad](https://supabase.com/docs/guides/platform/security)

## 📞 Obtener Ayuda

Si después de seguir esta guía sigues teniendo problemas:

1. Revisa los logs en Supabase Dashboard > Logs
2. Consulta la documentación oficial de Supabase
3. Revisa el Security Advisor para ver recomendaciones específicas

---

**Última actualización**: Diciembre 2024

