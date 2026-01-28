#!/bin/bash
# Script para configurar Android SDK en macOS
# Uso: ./scripts/configurar_android_sdk.sh

echo "🔧 Configurando Android SDK en macOS..."
echo ""

# Verificar si Android Studio está instalado
if [ -d "/Applications/Android Studio.app" ]; then
    echo "✅ Android Studio encontrado"
    ANDROID_SDK_PATH="$HOME/Library/Android/sdk"
    
    if [ -d "$ANDROID_SDK_PATH" ]; then
        echo "✅ Android SDK encontrado en: $ANDROID_SDK_PATH"
    else
        echo "⚠️  Android SDK no encontrado en la ubicación por defecto"
        echo "💡 Abre Android Studio y ve a: Settings → Android SDK"
        echo "💡 Copia la ruta que aparece en 'Android SDK Location'"
        read -p "Ingresa la ruta del Android SDK: " ANDROID_SDK_PATH
    fi
else
    echo "⚠️  Android Studio no está instalado"
    echo "💡 Opciones:"
    echo "   1. Instalar Android Studio: brew install --cask android-studio"
    echo "   2. O instalar solo Command Line Tools: brew install --cask android-commandlinetools"
    read -p "¿Quieres instalar Android Studio ahora? (s/n): " INSTALL
    if [ "$INSTALL" = "s" ] || [ "$INSTALL" = "S" ]; then
        echo "📦 Instalando Android Studio..."
        brew install --cask android-studio
        ANDROID_SDK_PATH="$HOME/Library/Android/sdk"
        echo "✅ Instalación completada"
        echo "💡 Abre Android Studio y completa la configuración inicial"
        echo "💡 El SDK se descargará automáticamente"
    else
        echo "❌ Instalación cancelada"
        exit 1
    fi
fi

# Configurar ANDROID_HOME en .zshrc
echo ""
echo "🔧 Configurando variables de entorno..."

ZSH_FILE="$HOME/.zshrc"

# Verificar si ya está configurado
if grep -q "ANDROID_HOME" "$ZSH_FILE"; then
    echo "⚠️  ANDROID_HOME ya está configurado en .zshrc"
    read -p "¿Quieres actualizarlo? (s/n): " UPDATE
    if [ "$UPDATE" != "s" ] && [ "$UPDATE" != "S" ]; then
        echo "❌ Actualización cancelada"
        exit 1
    fi
    # Eliminar líneas antiguas
    sed -i '' '/ANDROID_HOME/d' "$ZSH_FILE"
    sed -i '' '/Android SDK/d' "$ZSH_FILE"
fi

# Añadir configuración
cat >> "$ZSH_FILE" << EOF

# Android SDK
export ANDROID_HOME=$ANDROID_SDK_PATH
export PATH=\$PATH:\$ANDROID_HOME/emulator
export PATH=\$PATH:\$ANDROID_HOME/platform-tools
export PATH=\$PATH:\$ANDROID_HOME/tools
export PATH=\$PATH:\$ANDROID_HOME/tools/bin
EOF

echo "✅ Variables añadidas a .zshrc"

# Configurar local.properties
echo ""
echo "🔧 Configurando android/local.properties..."

LOCAL_PROPERTIES="android/local.properties"

if [ ! -f "$LOCAL_PROPERTIES" ]; then
    echo "⚠️  local.properties no existe, creando desde ejemplo..."
    cp android/local.properties.example "$LOCAL_PROPERTIES"
fi

# Actualizar sdk.dir si existe
if grep -q "sdk.dir" "$LOCAL_PROPERTIES"; then
    sed -i '' "s|sdk.dir=.*|sdk.dir=$ANDROID_SDK_PATH|" "$LOCAL_PROPERTIES"
    echo "✅ sdk.dir actualizado en local.properties"
else
    echo "sdk.dir=$ANDROID_SDK_PATH" >> "$LOCAL_PROPERTIES"
    echo "✅ sdk.dir añadido a local.properties"
fi

echo ""
echo "✅ Configuración completada!"
echo ""
echo "📋 Próximos pasos:"
echo "   1. Cerrar y abrir una nueva terminal (o ejecutar: source ~/.zshrc)"
echo "   2. Verificar: echo \$ANDROID_HOME"
echo "   3. Verificar: flutter doctor"
echo "   4. Compilar una vez: flutter build apk --debug"
echo "   5. Obtener SHA-1: keytool -list -v -keystore ~/.android/debug.keystore -alias androiddebugkey -storepass android -keypass android | grep SHA1:"
