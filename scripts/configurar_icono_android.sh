#!/bin/bash
# Script para configurar el icono de Android
# Uso: ./scripts/configurar_icono_android.sh [ruta-al-logo.png]

set -e

LOGO_PATH=$1
ANDROID_RES_DIR="android/app/src/main/res"

# Colores para output
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m' # No Color

echo "📱 Configurando icono de Android para QuePlan"
echo ""

if [ -z "$LOGO_PATH" ]; then
    echo -e "${RED}❌ Error: Se requiere la ruta al logo${NC}"
    echo ""
    echo "Uso: ./scripts/configurar_icono_android.sh [ruta-al-logo.png]"
    echo ""
    echo "Ejemplo:"
    echo "  ./scripts/configurar_icono_android.sh assets/logo/icono.png"
    echo ""
    echo "El logo debe ser PNG con fondo transparente, preferiblemente 1024x1024px"
    exit 1
fi

if [ ! -f "$LOGO_PATH" ]; then
    echo -e "${RED}❌ Error: No se encuentra el archivo: $LOGO_PATH${NC}"
    exit 1
fi

echo -e "${YELLOW}📋 Verificando dependencias...${NC}"

# Verificar si ImageMagick está instalado (para redimensionar)
if ! command -v convert &> /dev/null; then
    echo -e "${YELLOW}⚠️  ImageMagick no está instalado${NC}"
    echo "Para redimensionar automáticamente, instala ImageMagick:"
    echo "  sudo apt-get install imagemagick"
    echo ""
    echo "O redimensiona manualmente tu logo a estos tamaños:"
    echo "  - 48x48 px → mipmap-mdpi/ic_launcher.png"
    echo "  - 72x72 px → mipmap-hdpi/ic_launcher.png"
    echo "  - 96x96 px → mipmap-xhdpi/ic_launcher.png"
    echo "  - 144x144 px → mipmap-xxhdpi/ic_launcher.png"
    echo "  - 192x192 px → mipmap-xxxhdpi/ic_launcher.png"
    echo ""
    read -p "¿Quieres continuar y copiar el logo manualmente? (s/n): " continue
    
    if [ "$continue" != "s" ] && [ "$continue" != "S" ]; then
        exit 0
    fi
fi

echo -e "${GREEN}✅ Preparando iconos...${NC}"

# Crear directorio de assets si no existe
mkdir -p assets/logo

# Copiar logo original a assets
cp "$LOGO_PATH" assets/logo/icono_original.png
echo -e "${GREEN}✅ Logo copiado a assets/logo/icono_original.png${NC}"

# Si ImageMagick está disponible, redimensionar automáticamente
if command -v convert &> /dev/null; then
    echo -e "${YELLOW}🔄 Redimensionando iconos...${NC}"
    
    # Redimensionar a los tamaños necesarios
    convert "$LOGO_PATH" -resize 48x48 "$ANDROID_RES_DIR/mipmap-mdpi/ic_launcher.png"
    convert "$LOGO_PATH" -resize 72x72 "$ANDROID_RES_DIR/mipmap-hdpi/ic_launcher.png"
    convert "$LOGO_PATH" -resize 96x96 "$ANDROID_RES_DIR/mipmap-xhdpi/ic_launcher.png"
    convert "$LOGO_PATH" -resize 144x144 "$ANDROID_RES_DIR/mipmap-xxhdpi/ic_launcher.png"
    convert "$LOGO_PATH" -resize 192x192 "$ANDROID_RES_DIR/mipmap-xxxhdpi/ic_launcher.png"
    
    echo -e "${GREEN}✅ Iconos redimensionados y copiados${NC}"
else
    echo -e "${YELLOW}⚠️  ImageMagick no disponible${NC}"
    echo "Por favor, redimensiona manualmente tu logo y copia los archivos a:"
    echo "  $ANDROID_RES_DIR/mipmap-*/ic_launcher.png"
fi

echo ""
echo -e "${GREEN}✅ Configuración completada${NC}"
echo ""
echo "📝 Próximos pasos:"
echo "1. Limpia el proyecto: flutter clean"
echo "2. Reconstruye: flutter build apk"
echo "3. Instala: flutter install"
echo ""
echo "💡 Si el icono no cambia, desinstala la app anterior del dispositivo"

