# 🔓 Guía: Deshabilitar Política de Restricción

## ⚠️ Importante

Aunque seas administrador del **proyecto**, la política está a nivel de **organización**. Necesitas acceder a nivel de organización.

---

## 📋 Paso 1: Cambiar a Nivel de Organización

1. Ve a: https://console.cloud.google.com/
2. En el **selector de proyectos** (arriba, donde dice "queplan-5b9da")
3. Haz clic en el dropdown
4. **Selecciona tu organización** (no el proyecto individual)
   - Puede decir algo como "Organización" o mostrar el nombre de tu org

---

## 📋 Paso 2: Ir a Organization Policies

1. En el menú lateral izquierdo:
   - **"IAM & Admin"** → **"Organization policies"**
   - O **"IAM y administración"** → **"Políticas de la organización"**

2. O usa esta URL directa (reemplaza ORG_ID con el ID de tu organización):
   ```
   https://console.cloud.google.com/iam-admin/orgpolicies
   ```

---

## 📋 Paso 3: Buscar la Política

1. En la barra de búsqueda, busca:
   - `Disable service account key creation`
   - O `iam.disableServiceAccountKeyCreation`

2. O busca en la lista: **"Restrict service account key creation"**

---

## 📋 Paso 4: Editar la Política

1. Haz clic en la política encontrada
2. Haz clic en **"Edit"** o **"Editar"**
3. Cambia de **"Enforced"** a **"Not enforced"**
4. O agrega una excepción para tu proyecto específico
5. Guarda los cambios

---

## 📋 Paso 5: Verificar

1. Vuelve a tu proyecto
2. Intenta crear una Service Account key de nuevo
3. Debería funcionar ahora

---

## 🔍 Si No Encuentras Organization Policies

Si no ves la opción "Organization policies", puede que:

1. **No tengas una organización creada** (solo proyectos individuales)
2. En ese caso, la política debería estar en el nivel del proyecto
3. Busca en: **"IAM & Admin"** → **"Org Policies"** (a nivel de proyecto)

---

## 🆘 Verificar Permisos

Asegúrate de tener el rol:
- **"Organization Policy Administrator"** (`roles/orgpolicy.policyAdmin`)
- O ser **Owner** de la organización

---

**¿Puedes acceder al nivel de organización y ver "Organization policies"?**

