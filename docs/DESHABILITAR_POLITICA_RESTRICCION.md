# 🔓 Deshabilitar Política de Restricción de Service Account Keys

## 🎯 Objetivo

Deshabilitar la política `iam.disableServiceAccountKeyCreation` para poder crear claves de Service Account.

---

## 📋 Paso 1: Ir a Políticas de la Organización

1. Ve a: https://console.cloud.google.com/
2. Selecciona proyecto **"queplan-5b9da"** (o "QuePlan")
3. En el menú lateral izquierdo, busca:
   - **"IAM & Admin"** → **"Organization policies"** o **"Políticas de la organización"**
   - O directamente: https://console.cloud.google.com/iam-admin/orgpolicies

---

## 📋 Paso 2: Buscar la Política

1. En la lista de políticas, busca:
   - **"Restrict service account key creation"** o **"Restringir creación de claves de cuenta de servicio"**
   - O busca por ID: `iam.disableServiceAccountKeyCreation`

2. Haz clic en esa política

---

## 📋 Paso 3: Modificar la Política

1. Verás que está **"Enforced"** o **"Aplicada"**
2. Haz clic en **"Edit"** o **"Editar"**
3. Cambia a:
   - **"Not enforced"** o **"No aplicada"**
   - O agrega una excepción para tu proyecto
4. Guarda los cambios

---

## 📋 Paso 4: Verificar

1. Vuelve a intentar crear una clave de Service Account
2. Debería funcionar ahora

---

## 🔄 Alternativa: Aplicar Solo a Tu Proyecto

Si no puedes modificar la política de organización, puedes:

1. Buscar la política
2. Agregar una **excepción** o **"Exception"**
3. Incluir solo tu proyecto: `queplan-5b9da`

---

**¿Puedes ver la sección de "Organization policies" en Google Cloud Console?**


