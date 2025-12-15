# 🔥 Guía: Configurar Firebase Hosting para Documentos Legales

**Dominio**: `queplan-app.com`  
**Plataforma**: Firebase Hosting (GRATIS)  
**Fecha**: Diciembre 2024

---

## ✅ Ventajas de Firebase Hosting

- ✅ **GRATIS** (generoso plan gratuito)
- ✅ **SSL automático** (HTTPS)
- ✅ **Rápido** (CDN global de Google)
- ✅ **Fácil de configurar**
- ✅ **Mismo ecosistema** que Firebase que ya usas
- ✅ **Dominio personalizado** fácil de configurar

---

## 📋 Requisitos Previos

1. ✅ Tienes Google Workspace con dominio `queplan-app.com`
2. ✅ Ya usas Firebase en tu proyecto (Firebase Messaging)
3. ✅ Tienes acceso a Firebase Console

---

## 🚀 Paso 1: Instalar Firebase CLI

### En tu máquina local:

```bash
# Instalar Firebase CLI globalmente
npm install -g firebase-tools

# O si usas macOS con Homebrew:
brew install firebase-tools

# Verificar instalación
firebase --version
```

### Iniciar sesión:

```bash
firebase login
```

Esto abrirá el navegador para autenticarte con tu cuenta de Google.

---

## 🚀 Paso 2: Crear Proyecto de Hosting

### Opción A: Usar el mismo proyecto Firebase

Si ya tienes un proyecto Firebase para la app:

```bash
# Navegar a tu proyecto
cd /home/perikopico/StudioProjects/fiestapp

# Inicializar Firebase Hosting
firebase init hosting
```

**Preguntas que te hará:**
1. **¿Qué proyecto Firebase quieres usar?**
   - Selecciona tu proyecto existente o crea uno nuevo

2. **¿Qué directorio usar para archivos públicos?**
   - Crea una carpeta nueva: `legal-docs` o `hosting`

3. **¿Configurar como single-page app?**
   - **No** (para documentos HTML estáticos)

4. **¿Configurar GitHub Actions?**
   - **No** (por ahora)

### Opción B: Proyecto separado (recomendado)

Mejor crear un proyecto Firebase separado solo para hosting:

```bash
# Crear carpeta para hosting
mkdir queplan-legal-hosting
cd queplan-legal-hosting

# Inicializar Firebase
firebase init hosting
```

---

## 🚀 Paso 3: Estructura de Archivos

Después de `firebase init hosting`, tendrás algo como:

```
queplan-legal-hosting/
├── .firebaserc          (configuración del proyecto)
├── firebase.json        (configuración de hosting)
└── public/              (o el nombre que elegiste)
    ├── index.html       (opcional)
    ├── privacy.html     (Política de Privacidad)
    └── terms.html       (Términos y Condiciones)
```

### Copiar archivos HTML:

```bash
# Desde tu proyecto Flutter
cp docs/legal/privacy_policy.html queplan-legal-hosting/public/privacy.html
cp docs/legal/terms_of_service.html queplan-legal-hosting/public/terms.html
```

---

## 🚀 Paso 4: Configurar firebase.json

Edita `firebase.json` para configurar las rutas:

```json
{
  "hosting": {
    "public": "public",
    "ignore": [
      "firebase.json",
      "**/.*",
      "**/node_modules/**"
    ],
    "rewrites": [
      {
        "source": "/privacy",
        "destination": "/privacy.html"
      },
      {
        "source": "/terms",
        "destination": "/terms.html"
      }
    ],
    "headers": [
      {
        "source": "**/*.html",
        "headers": [
          {
            "key": "Cache-Control",
            "value": "max-age=3600"
          }
        ]
      }
    ]
  }
}
```

Esto hace que:
- `/privacy` → muestre `privacy.html`
- `/terms` → muestre `terms.html`
- Sin necesidad de `.html` en la URL

---

## 🚀 Paso 5: Desplegar

```bash
# Desplegar a Firebase
firebase deploy --only hosting
```

Esto te dará una URL temporal tipo:
- `https://tu-proyecto.web.app`
- `https://tu-proyecto.firebaseapp.com`

**¡Ya tienes los documentos online!** Pero ahora vamos a usar tu dominio.

---

## 🌐 Paso 6: Configurar Dominio Personalizado

### En Firebase Console:

1. Ve a [Firebase Console](https://console.firebase.google.com)
2. Selecciona tu proyecto
3. Ve a **Hosting** → **Add custom domain**
4. Escribe: `queplan-app.com`
5. Firebase te dará instrucciones DNS

### Configurar DNS en Google Workspace:

1. Ve a [Google Admin Console](https://admin.google.com)
2. **Apps** → **Google Workspace** → **Domains**
3. Selecciona `queplan-app.com`
4. Ve a **DNS** o **Registrar DNS**

Añade estos registros:

**Tipo A:**
```
Nombre: @
Valor: 151.101.1.195
TTL: 3600
```

**Tipo A:**
```
Nombre: @
Valor: 151.101.65.195
TTL: 3600
```

**O mejor, usa CNAME (más fácil):**

**Tipo CNAME:**
```
Nombre: @
Valor: tu-proyecto.web.app
TTL: 3600
```

**Nota**: Si no puedes usar CNAME en la raíz (@), usa los registros A que Firebase te proporcione.

### Verificar Dominio:

Firebase te pedirá verificar el dominio. Tienes dos opciones:

**Opción 1: TXT Record (recomendado)**
- Añade un registro TXT con el valor que Firebase te dé
- Espera a que se verifique (puede tardar minutos u horas)

**Opción 2: HTML File**
- Descarga el archivo HTML que Firebase te da
- Súbelo a tu dominio en la ruta que indique
- Firebase lo verificará automáticamente

---

## 🚀 Paso 7: Esperar y Verificar

1. **Espera 24-48 horas** para propagación DNS
2. Verifica que funcionen:
   - ✅ `https://queplan-app.com/privacy`
   - ✅ `https://queplan-app.com/terms`
3. Verifica SSL:
   - Firebase configura SSL automáticamente
   - Puede tardar unas horas después de verificar el dominio

---

## 🔄 Actualizar Documentos

Cada vez que quieras actualizar los documentos:

```bash
# Editar archivos en public/
# Luego desplegar:
firebase deploy --only hosting
```

Los cambios se publican en segundos.

---

## 📝 Estructura Final Recomendada

```
queplan-legal-hosting/
├── .firebaserc
├── firebase.json
└── public/
    ├── index.html          (opcional, página principal)
    ├── privacy.html        (Política de Privacidad)
    └── terms.html          (Términos y Condiciones)
```

---

## 🎨 Mejorar los HTML (Opcional)

Puedes mejorar los HTML con:
- CSS más bonito
- Responsive design
- Navegación entre páginas
- Footer común

Ejemplo de `index.html`:

```html
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>QuePlan - Documentos Legales</title>
    <style>
        body {
            font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, sans-serif;
            max-width: 800px;
            margin: 50px auto;
            padding: 20px;
            line-height: 1.6;
        }
        h1 { color: #0175C2; }
        .links {
            list-style: none;
            padding: 0;
        }
        .links li {
            margin: 15px 0;
        }
        .links a {
            display: block;
            padding: 15px;
            background: #f5f5f5;
            border-radius: 8px;
            text-decoration: none;
            color: #0175C2;
            font-weight: bold;
        }
        .links a:hover {
            background: #e0e0e0;
        }
    </style>
</head>
<body>
    <h1>QuePlan</h1>
    <p>Documentos legales y políticas</p>
    <ul class="links">
        <li><a href="/privacy">Política de Privacidad</a></li>
        <li><a href="/terms">Términos y Condiciones</a></li>
    </ul>
</body>
</html>
```

---

## ⚡ Comandos Útiles

```bash
# Ver estado del proyecto
firebase projects:list

# Ver hosting activo
firebase hosting:channel:list

# Ver logs de despliegue
firebase hosting:clone

# Eliminar despliegue
firebase hosting:channel:delete <channel-id>
```

---

## 🆘 Solución de Problemas

### DNS no se propaga
- Espera 24-48 horas
- Usa herramientas como [whatsmydns.net](https://www.whatsmydns.net) para verificar

### SSL no se activa
- Espera unas horas después de verificar dominio
- Firebase configura SSL automáticamente

### Error al desplegar
- Verifica que estés autenticado: `firebase login`
- Verifica que el proyecto esté correcto: `firebase use`

---

## 📚 Recursos

- [Firebase Hosting Docs](https://firebase.google.com/docs/hosting)
- [Dominios personalizados en Firebase](https://firebase.google.com/docs/hosting/custom-domain)
- [Firebase CLI Reference](https://firebase.google.com/docs/cli)

---

## ✅ Checklist

- [ ] Firebase CLI instalado
- [ ] Iniciado sesión en Firebase CLI
- [ ] Proyecto Firebase creado/inicializado
- [ ] `firebase init hosting` ejecutado
- [ ] Archivos HTML copiados a `public/`
- [ ] `firebase.json` configurado
- [ ] Primer despliegue exitoso
- [ ] Dominio añadido en Firebase Console
- [ ] DNS configurado en Google Workspace
- [ ] Dominio verificado
- [ ] SSL activo (puede tardar horas)
- [ ] URLs funcionando:
  - [ ] `https://queplan-app.com/privacy`
  - [ ] `https://queplan-app.com/terms`

---

**Última actualización**: Diciembre 2024

