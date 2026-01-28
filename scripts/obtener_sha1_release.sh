#!/bin/bash
# Script para obtener el SHA-1 del keystore de release

echo "🔍 Obteniendo SHA-1 de Release..."
echo ""

# Ruta del JDK de Android Studio
JAVA_HOME_AS="/Applications/Android Studio.app/Contents/jbr/Contents/Home"
KEYTOOL="$JAVA_HOME_AS/bin/keytool"

# Verificar que existe el JDK de Android Studio
if [ ! -f "$KEYTOOL" ]; then
    echo "❌ No se encontró el JDK de Android Studio en: $JAVA_HOME_AS"
    echo "💡 Verifica que Android Studio esté instalado."
    exit 1
fi

# Ruta del keystore
KEYSTORE_PATH="$HOME/upload-keystore.jks"

# Verificar que existe el keystore
if [ ! -f "$KEYSTORE_PATH" ]; then
    echo "❌ El keystore de release no existe en: $KEYSTORE_PATH"
    echo ""
    echo "💡 Para crearlo, ejecuta:"
    echo "   ./scripts/crear_keystore_release.sh"
    echo ""
    exit 1
fi

echo "📋 Información del certificado de release:"
echo ""

# Obtener SHA-1 usando keytool del JDK de Android Studio
"$KEYTOOL" -list -v -keystore "$KEYSTORE_PATH" -alias upload 2>/dev/null

if [ $? -eq 0 ]; then
    echo ""
    echo "✅ SHA-1 encontrado arriba (busca la línea 'SHA1:')"
    echo ""
    echo "📝 Para copiar solo el SHA-1, ejecuta:"
    echo "   $KEYTOOL -list -v -keystore $KEYSTORE_PATH -alias upload | grep 'SHA1:'"
    echo ""
    echo "🔑 Obtener solo el valor del SHA-1:"
    "$KEYTOOL" -list -v -keystore "$KEYSTORE_PATH" -alias upload 2>/dev/null | grep "SHA1:" | awk '{print $2}'
else
    echo ""
    echo "❌ Error al obtener SHA-1."
    echo "💡 Verifica que la contraseña del keystore sea correcta."
fi
