# ⚖️ Verificar Configuración Legal y DNS

**Fecha**: Enero 2025  
**Tiempo estimado**: 15 minutos

---

## 📋 Checklist de Verificación

### 1. Verificar Propagación DNS

**Método 1: Desde terminal**
```bash
nslookup queplan-app.com
# o
dig queplan-app.com
```

**Método 2: Herramienta online**
- Ir a https://dnschecker.org/
- Introducir: `queplan-app.com`
- Verificar que resuelve correctamente

**Resultado esperado**: 
- El dominio debe resolver a la IP de Firebase Hosting
- No debe mostrar errores de DNS

**Tiempo**: 5 minutos

---

### 2. Verificar SSL Activo

**Pasos**:
1. Abrir navegador
2. Ir a: `https://queplan-app.com`
3. Verificar que:
   - [ ] La conexión es segura (candado verde)
   - [ ] No aparece advertencia de certificado
   - [ ] La página carga correctamente

**Resultado esperado**: ✅ SSL activo y funcionando

**Tiempo**: 2 minutos

---

### 3. Verificar URLs Legales

**URLs a verificar**:

#### 3.1. Política de Privacidad
- [ ] Ir a: `https://queplan-app.com/privacy`
- [ ] Verificar que muestra la política de privacidad
- [ ] Verificar que el contenido es correcto
- [ ] Verificar que no hay errores 404

#### 3.2. Términos y Condiciones
- [ ] Ir a: `https://queplan-app.com/terms`
- [ ] Verificar que muestra los términos y condiciones
- [ ] Verificar que el contenido es correcto
- [ ] Verificar que no hay errores 404

**Resultado esperado**: ✅ Ambas URLs funcionan y muestran contenido

**Tiempo**: 5 minutos

---

### 4. Personalizar Documentos Legales (Opcional pero Recomendado)

**Archivos a revisar**:
- `docs/legal/privacy_policy.html`
- `docs/legal/terms_of_service.html`

**Qué personalizar**:
- [ ] Añadir información de contacto real
- [ ] Añadir dirección física si es necesario
- [ ] Revisar y actualizar fechas
- [ ] Verificar que la información es correcta
- [ ] Añadir información específica de QuePlan

**Tiempo**: 30-60 minutos (opcional, puede hacerse después)

---

## ✅ Resultado Esperado

- ✅ DNS resuelve correctamente
- ✅ SSL activo y funcionando
- ✅ URLs legales funcionan
- ⚠️ Documentos personalizados (opcional)

---

## 🐛 Problemas Comunes

### Problema: DNS no resuelve
**Solución**: 
- Verificar configuración DNS en el proveedor de dominio
- Esperar propagación DNS (puede tardar 24-48 horas)
- Verificar registros DNS en Firebase Hosting

### Problema: SSL no funciona
**Solución**:
- Verificar que el dominio está verificado en Firebase
- Verificar que el certificado SSL está activo
- Esperar propagación (puede tardar algunas horas)

### Problema: URLs legales dan 404
**Solución**:
- Verificar que los archivos están en Firebase Hosting
- Verificar configuración de rutas en Firebase
- Verificar que los archivos HTML existen

---

## 📝 Notas

- La propagación DNS puede tardar hasta 48 horas
- Los certificados SSL se generan automáticamente en Firebase
- Los documentos legales pueden personalizarse después del lanzamiento inicial

---

**Tiempo total**: 15 minutos (sin personalización de documentos)




