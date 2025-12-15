# 🌐 Guía: Configurar Dominio para Documentos Legales

**Dominio**: `queplan-app.com`  
**Fecha**: Diciembre 2024

---

## 📋 Qué Necesitas Hacer

Tu dominio `queplan-app.com` debe servir dos páginas HTML estáticas:
1. **Política de Privacidad**: `https://queplan-app.com/privacy`
2. **Términos y Condiciones**: `https://queplan-app.com/terms`

---

## 🚀 Opción 1: GitHub Pages (GRATIS y FÁCIL)

### Paso 1: Crear Repositorio
1. Crea un nuevo repositorio en GitHub (público o privado)
2. Nombre sugerido: `queplan-legal` o `queplan-docs`

### Paso 2: Crear Archivos HTML
Crea estos archivos en el repositorio:

**`index.html`** (página principal, opcional):
```html
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>QuePlan - Documentos Legales</title>
</head>
<body>
    <h1>QuePlan</h1>
    <ul>
        <li><a href="/privacy">Política de Privacidad</a></li>
        <li><a href="/terms">Términos y Condiciones</a></li>
    </ul>
</body>
</html>
```

**`privacy.html`** (usa la plantilla que crearemos)
**`terms.html`** (usa la plantilla que crearemos)

### Paso 3: Configurar GitHub Pages
1. Ve a **Settings** → **Pages**
2. En **Source**, selecciona la rama `main` y carpeta `/ (root)`
3. Guarda

### Paso 4: Configurar Dominio Personalizado
1. En **Settings** → **Pages**, en **Custom domain**, escribe: `queplan-app.com`
2. GitHub te dará instrucciones para configurar DNS

### Paso 5: Configurar DNS
En tu proveedor de dominio (donde compraste `queplan-app.com`), añade estos registros:

**Tipo A:**
- Nombre: `@` (o raíz)
- Valor: `185.199.108.153`
- Valor: `185.199.109.153`
- Valor: `185.199.110.153`
- Valor: `185.199.111.153`

**Tipo CNAME (opcional, para www):**
- Nombre: `www`
- Valor: `tu-usuario.github.io`

**Tipo CNAME (para GitHub Pages):**
- Nombre: `@` (o raíz)
- Valor: `tu-usuario.github.io` (reemplaza con tu usuario de GitHub)

**Espera 24-48 horas** para que los cambios DNS se propaguen.

---

## 🚀 Opción 2: Netlify (GRATIS y MUY FÁCIL)

### Paso 1: Crear Sitio
1. Ve a [netlify.com](https://netlify.com) y crea cuenta
2. Arrastra una carpeta con tus archivos HTML o conecta con GitHub

### Paso 2: Configurar Dominio
1. En **Domain settings** → **Custom domains**
2. Añade `queplan-app.com`
3. Netlify te dará instrucciones DNS

### Paso 3: Configurar DNS
Añade estos registros en tu proveedor de dominio:

**Tipo A:**
- Nombre: `@`
- Valor: `75.2.60.5`

O usa **CNAME**:
- Nombre: `@`
- Valor: `tu-sitio.netlify.app`

---

## 🚀 Opción 3: Vercel (GRATIS)

Similar a Netlify:
1. Crea cuenta en [vercel.com](https://vercel.com)
2. Importa proyecto o sube archivos
3. Añade dominio personalizado
4. Configura DNS según instrucciones

---

## 🚀 Opción 4: Hosting Tradicional

Si tienes hosting web tradicional:
1. Sube los archivos HTML a la carpeta `public_html` o `www`
2. Asegúrate de que:
   - `privacy.html` sea accesible en `/privacy`
   - `terms.html` sea accesible en `/terms`

Puedes usar `.htaccess` (Apache) para redirecciones:
```apache
RewriteEngine On
RewriteRule ^privacy$ privacy.html [L]
RewriteRule ^terms$ terms.html [L]
```

---

## 📝 Estructura de Archivos Recomendada

```
tu-repositorio/
├── index.html          (opcional, página principal)
├── privacy.html        (Política de Privacidad)
├── terms.html          (Términos y Condiciones)
└── README.md           (opcional)
```

---

## ✅ Verificación

Después de configurar, verifica que funcionen:
- ✅ `https://queplan-app.com/privacy` → Debe mostrar la política
- ✅ `https://queplan-app.com/terms` → Debe mostrar los términos
- ✅ Debe tener certificado SSL (HTTPS)

---

## 🔒 SSL/HTTPS

**Importante**: Los documentos legales DEBEN estar en HTTPS.

- **GitHub Pages**: SSL automático ✅
- **Netlify**: SSL automático ✅
- **Vercel**: SSL automático ✅
- **Hosting tradicional**: Puede requerir certificado SSL (Let's Encrypt es gratis)

---

## 📧 Email de Contacto

También puedes configurar email con tu dominio:
- `info@queplan-app.com`
- `contacto@queplan-app.com`
- `legal@queplan-app.com`

**Opciones:**
1. **Gmail/Google Workspace**: Configurar email empresarial
2. **ProtonMail**: Email profesional con dominio personalizado
3. **Zoho Mail**: Gratis para un dominio
4. **Proveedor de hosting**: Muchos incluyen email

---

## 🎨 Plantillas HTML

He creado plantillas básicas en:
- `docs/legal/privacy_policy.html` (plantilla)
- `docs/legal/terms_of_service.html` (plantilla)

Puedes usarlas como base y personalizarlas.

---

## ⚡ Configuración Rápida (Recomendada)

**Para empezar rápido, usa GitHub Pages:**

1. Crea repo en GitHub
2. Sube los archivos HTML (usa las plantillas)
3. Activa GitHub Pages
4. Configura dominio personalizado
5. Configura DNS
6. Espera 24-48 horas
7. ✅ Listo

**Tiempo total**: ~30 minutos de trabajo + espera DNS

---

## 📚 Recursos

- [GitHub Pages Docs](https://docs.github.com/en/pages)
- [Netlify Docs](https://docs.netlify.com/)
- [Vercel Docs](https://vercel.com/docs)
- [Let's Encrypt (SSL gratis)](https://letsencrypt.org/)

---

**Última actualización**: Diciembre 2024

