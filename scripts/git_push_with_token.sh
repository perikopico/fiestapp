#!/bin/bash
# Script para hacer push a GitHub usando token de acceso personal
# Uso: ./scripts/git_push_with_token.sh [token]

set -e

TOKEN=$1
REMOTE_URL=$(git remote get-url origin)

if [ -z "$TOKEN" ]; then
    echo "❌ Error: Se requiere un token de GitHub"
    echo ""
    echo "Uso: ./scripts/git_push_with_token.sh [tu-token]"
    echo ""
    echo "Para obtener un token:"
    echo "1. Ve a: https://github.com/settings/tokens"
    echo "2. Click en 'Generate new token (classic)'"
    echo "3. Nombre: 'fiestapp-push'"
    echo "4. Marca 'repo' (acceso completo a repositorios)"
    echo "5. Click en 'Generate token'"
    echo "6. Copia el token y ejecuta:"
    echo "   ./scripts/git_push_with_token.sh [tu-token]"
    exit 1
fi

# Extraer usuario y repo del remoto
if [[ $REMOTE_URL == *"github.com"* ]]; then
    if [[ $REMOTE_URL == *"@"* ]]; then
        # Ya tiene usuario en la URL
        USERNAME=$(echo $REMOTE_URL | sed -n 's/.*github.com[:/]\([^/]*\).*/\1/p')
    else
        USERNAME=$(echo $REMOTE_URL | sed -n 's/.*github.com[:/]\([^/]*\).*/\1/p')
    fi
    REPO=$(echo $REMOTE_URL | sed -n 's/.*github.com[:/][^/]*\/\([^.]*\).*/\1/p')
else
    echo "❌ Error: No se pudo determinar el repositorio de GitHub"
    exit 1
fi

echo "🚀 Configurando push a GitHub..."
echo "📦 Repositorio: $USERNAME/$REPO"

# Configurar URL con token
git remote set-url origin "https://${USERNAME}:${TOKEN}@github.com/${USERNAME}/${REPO}.git"

echo "🔄 Haciendo push..."
git push origin main

echo ""
echo "✅ Push completado exitosamente"
echo "💡 El token se guardó en ~/.git-credentials para futuros pushes"

