#!/bin/bash
# Script para hacer push a GitHub usando token de acceso personal

set -e

echo "🚀 Push a GitHub"
echo ""

# Verificar que estamos en el directorio correcto
if [ ! -f "pubspec.yaml" ]; then
    echo "❌ Error: No estás en el directorio del proyecto Flutter"
    exit 1
fi

# Verificar si hay cambios para hacer push
if ! git rev-parse --verify origin/main >/dev/null 2>&1; then
    echo "⚠️  La rama remota 'main' no existe aún"
    echo "💡 Ejecuta: git push -u origin main"
    exit 1
fi

# Verificar si hay commits para hacer push
LOCAL=$(git rev-parse @)
REMOTE=$(git rev-parse @{u} 2>/dev/null || echo "")
BASE=$(git merge-base @ @{u} 2>/dev/null || echo "")

if [ "$LOCAL" = "$REMOTE" ] && [ -n "$REMOTE" ]; then
    echo "✅ No hay cambios para hacer push"
    exit 0
fi

echo "📋 Opciones para hacer push:"
echo ""
echo "1. Usar token de GitHub (recomendado)"
echo "2. Configurar credenciales manualmente"
echo ""
read -p "Selecciona una opción (1 o 2): " option

case $option in
    1)
        echo ""
        echo "📝 Para usar un token:"
        echo "1. Ve a: https://github.com/settings/tokens"
        echo "2. Click en 'Generate new token (classic)'"
        echo "3. Nombre: 'fiestapp-push'"
        echo "4. Marca 'repo' (acceso completo a repositorios)"
        echo "5. Click en 'Generate token'"
        echo "6. Copia el token"
        echo ""
        read -p "Pega tu token de GitHub: " token
        
        if [ -z "$token" ]; then
            echo "❌ Token vacío"
            exit 1
        fi
        
        # Obtener el usuario de GitHub del remoto
        REMOTE_URL=$(git remote get-url origin)
        if [[ $REMOTE_URL == *"github.com"* ]]; then
            USERNAME=$(echo $REMOTE_URL | sed -n 's/.*github.com[:/]\([^/]*\).*/\1/p')
        else
            read -p "Ingresa tu usuario de GitHub: " USERNAME
        fi
        
        # Configurar URL con token
        git remote set-url origin "https://${USERNAME}:${token}@github.com/${USERNAME}/fiestapp.git"
        
        echo ""
        echo "🔄 Haciendo push..."
        git push origin main
        
        echo ""
        echo "✅ Push completado"
        echo "💡 El token se guardó en ~/.git-credentials"
        ;;
    2)
        echo ""
        echo "Para configurar credenciales manualmente:"
        echo "1. Crea un token en: https://github.com/settings/tokens"
        echo "2. Ejecuta: git push origin main"
        echo "3. Cuando pida usuario: tu usuario de GitHub"
        echo "4. Cuando pida contraseña: pega el token (no tu contraseña)"
        echo ""
        echo "O ejecuta directamente:"
        echo "git push origin main"
        ;;
    *)
        echo "❌ Opción inválida"
        exit 1
        ;;
esac

