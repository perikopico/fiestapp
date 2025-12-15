# ⚡ Pasos Rápidos para Desbloquear

## 🎯 Objetivo

Deshabilitar la política que impide crear Service Account keys.

---

## 📍 Pasos

### 1. Ir a Organization Policies

Ve a esta URL (o busca en el menú):
```
https://console.cloud.google.com/iam-admin/orgpolicies
```

**Importante:** Si estás en un proyecto, cambia al nivel de **organización** (selector arriba).

### 2. Buscar la Política

En la barra de búsqueda, escribe:
```
iam.disableServiceAccountKeyCreation
```

O busca:
```
Disable service account key creation
```

### 3. Editar

1. Haz clic en la política
2. Clic en **"Edit"**
3. Cambia a **"Not enforced"**
4. Guarda

### 4. Probar

Vuelve a intentar crear la Service Account key. Debería funcionar.

---

**¿Puedes probar estos pasos? Si no encuentras algo, dímelo y te guío más específicamente.**












