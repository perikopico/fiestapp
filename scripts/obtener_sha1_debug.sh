#!/bin/bash
# Script para obtener el SHA-1 del keystore de debug usando el JDK de Android Studio

echo "🔍 Obteniendo SHA-1 de Debug..."
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

# Verificar que existe el keystore de debug
if [ ! -f ~/.android/debug.keystore ]; then
    echo "⚠️  El keystore de debug no existe."
    echo "📦 Se creará automáticamente la primera vez que compiles la app."
    echo ""
    echo "💡 Para crearlo, ejecuta:"
    echo "   flutter build apk --debug"
    echo ""
    exit 1
fi

# Obtener SHA-1 usando keytool del JDK de Android Studio
echo "📋 Información del certificado de debug:"
echo ""

"$KEYTOOL" -list -v -keystore ~/.android/debug.keystore \
  -alias androiddebugkey \
  -storepass android \
  -keypass android 2>/dev/null

if [ $? -eq 0 ]; then
    echo ""
    echo "✅ SHA-1 encontrado arriba (busca la línea 'SHA1:')"
    echo ""
    echo "📝 Para copiar solo el SHA-1, ejecuta:"
    echo "   $KEYTOOL -list -v -keystore ~/.android/debug.keystore -alias androiddebugkey -storepass android -keypass android | grep 'SHA1:'"
else
    echo ""
    echo "❌ Error al obtener SHA-1."
fi
