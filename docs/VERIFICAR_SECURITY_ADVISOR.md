# 🔒 Verificar Security Advisor - Supabase

**Fecha**: Enero 2025  
**Prioridad**: 🔴 ALTA - Verificar seguridad antes del lanzamiento

---

## 📋 Pasos para Verificar

### 1. Acceder al Security Advisor

1. Abre **Supabase Dashboard**
2. Selecciona tu proyecto
3. Ve a **Database** (menú lateral izquierdo)
4. Haz clic en **Security Advisor** (o busca en el menú)

### 2. Revisar Errores de Seguridad

El Security Advisor mostrará:
- ⚠️ **Advertencias** - Problemas menores
- ❌ **Errores** - Problemas críticos que deben corregirse

**Errores comunes**:
- Tablas sin RLS habilitado
- Tablas con RLS pero sin políticas
- Políticas que permiten acceso no autorizado

### 3. Qué Buscar

#### ✅ Debe estar correcto (después de migración 007):
- Todas las tablas públicas tienen RLS habilitado
- Todas las tablas tienen políticas apropiadas
- No hay tablas expuestas sin protección

#### ⚠️ Si hay errores:
- Anota qué tablas tienen problemas
- Revisa si falta alguna política
- Ejecuta la migración 007 si no se ejecutó completamente

---

## 🔍 Verificación Manual con SQL

Si el Security Advisor no está disponible o quieres verificar manualmente, ejecuta este script:

**Archivo**: `docs/VERIFICAR_RLS.sql`

Este script te mostrará:
- Estado de RLS en todas las tablas
- Número de políticas por tabla
- Tablas que necesitan atención

---

## ✅ Resultado Esperado

**Ideal**: 
- 0 errores críticos
- 0-2 advertencias menores (aceptables)
- Todas las tablas con RLS habilitado

**Si hay errores**:
- Revisa qué tablas tienen problemas
- Ejecuta la migración 007 nuevamente si es necesario
- Verifica que todas las políticas estén creadas

---

## 📝 Qué Hacer si Hay Errores

### Error: "Table X does not have RLS enabled"
**Solución**: Ejecuta la migración 007 o habilita RLS manualmente:
```sql
ALTER TABLE public.nombre_tabla ENABLE ROW LEVEL SECURITY;
```

### Error: "Table X has RLS but no policies"
**Solución**: Revisa la migración 007 y crea las políticas necesarias

### Error: "Policy allows unauthorized access"
**Solución**: Revisa las políticas y ajusta las condiciones USING/WITH CHECK

---

## 🎯 Siguiente Paso

Después de verificar el Security Advisor:
1. Si hay errores → Corregirlos
2. Si está todo bien → Continuar con testing
3. Documentar cualquier problema encontrado

---

**Tiempo estimado**: 5-10 minutos




