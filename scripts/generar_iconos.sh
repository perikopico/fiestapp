#!/bin/bash
# Script para generar iconos de Android usando flutter_launcher_icons
# Uso: ./scripts/generar_iconos.sh

set -e

GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m'

echo "📱 Generando iconos de Android para QuePlan"
echo ""

# Verificar que existe el logo (icono actual de launcher)
LOGO_PATH="assets/logo/icono2.png"

if [ ! -f "$LOGO_PATH" ]; then
    echo -e "${RED}❌ Error: No se encuentra el logo en $LOGO_PATH${NC}"
    echo ""
    echo "Por favor, copia tu logo a: $LOGO_PATH"
    echo ""
    echo "Requisitos del logo:"
    echo "  - Formato: PNG"
    echo "  - Fondo: Transparente"
    echo "  - Tamaño: 1024x1024px (o más grande)"
    echo ""
    exit 1
fi

echo -e "${GREEN}✅ Logo encontrado: $LOGO_PATH${NC}"
echo ""

# Generar iconos
echo -e "${YELLOW}🔄 Generando iconos...${NC}"
flutter pub get
flutter pub run flutter_launcher_icons

echo ""
echo -e "${GREEN}✅ Iconos generados exitosamente${NC}"
echo ""
echo "📝 Próximos pasos:"
echo "1. Limpia el proyecto: flutter clean"
echo "2. Reconstruye: flutter build apk"
echo "3. Instala: flutter install"
echo ""
echo "💡 Si el icono no cambia, desinstala la app anterior:"
echo "   adb uninstall com.perikopico.fiestapp"

