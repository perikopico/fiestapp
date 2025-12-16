#!/bin/bash
# Script para configurar token de GitHub en el remoto

set -e

if [ -z "$1" ]; then
    echo "❌ Error: Se requiere un token de GitHub"
    echo ""
    echo "Uso: ./scripts/configurar_git_token.sh [tu-token]"
    echo ""
    echo "Para obtener un token:"
    echo "1. Ve a: https://github.com/settings/tokens"
    echo "2. Click en 'Generate new token (classic)'"
    echo "3. Nombre: 'fiestapp-push'"
    echo "4. Marca 'repo' (acceso completo a repositorios)"
    echo "5. Click en 'Generate token'"
    echo "6. Copia el token"
    exit 1
fi

TOKEN=$1
USERNAME="perikopico"
REPO="fiestapp"

echo "🔧 Configurando token de GitHub..."

# Configurar URL del remoto con el token
git remote set-url origin "https://${USERNAME}:${TOKEN}@github.com/${USERNAME}/${REPO}.git"

echo "✅ Token configurado"
echo ""
echo "🔄 Intentando hacer push..."
git push origin main

echo ""
echo "✅ Push completado exitosamente"

