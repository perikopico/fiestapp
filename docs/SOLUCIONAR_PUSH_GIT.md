# 🔧 Solucionar Error de Push a GitHub

## ❌ Error Común

```
Error: Missing VSCODE_GIT_IPC_AUTH_TOKEN
remote: No anonymous write access.
fatal: Autenticación falló para 'https://github.com/...'
```

## ✅ Soluciones

### Opción 1: Usar Token de Acceso Personal (Recomendado)

1. **Crear Personal Access Token en GitHub:**
   - Ve a: https://github.com/settings/tokens
   - Click en "Generate new token (classic)"
   - Nombre: `fiestapp-push`
   - Permisos: Marca `repo` (acceso completo a repositorios)
   - Click en "Generate token"
   - **Copia el token** (solo se muestra una vez)

2. **Configurar Git para usar el token:**
   ```bash
   git config --global credential.helper store
   ```

3. **Hacer push (te pedirá usuario y contraseña):**
   ```bash
   git push origin main
   ```
   - Usuario: tu usuario de GitHub
   - Contraseña: **pega el token** (no tu contraseña real)

### Opción 2: Cambiar a SSH

Si tienes SSH configurado:

```bash
# Cambiar remoto a SSH
git remote set-url origin git@github.com:perikopico/fiestapp.git

# Verificar
git remote -v

# Hacer push
git push origin main
```

### Opción 3: Usar GitHub CLI

```bash
# Instalar GitHub CLI (si no está instalado)
# sudo apt install gh

# Autenticarse
gh auth login

# Hacer push
git push origin main
```

## 🔍 Verificar Configuración

```bash
# Ver remoto actual
git remote -v

# Ver configuración de credenciales
git config --list | grep credential
```

---

**Nota**: El error de `VSCODE_GIT_IPC_AUTH_TOKEN` es de Cursor intentando autenticar, pero puedes hacer push desde terminal sin problemas.

