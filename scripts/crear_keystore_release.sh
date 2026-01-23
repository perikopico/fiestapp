#!/bin/bash
# Script para crear el keystore de release para Android

echo "🔐 Creando keystore de release para Android..."
echo ""
echo "⚠️  IMPORTANTE:"
echo "   - Guarda la contraseña en un lugar seguro"
echo "   - Si pierdes el keystore, NO podrás actualizar la app en Play Store"
echo "   - Haz backup del keystore después de crearlo"
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

# Verificar si ya existe
if [ -f "$KEYSTORE_PATH" ]; then
    echo "⚠️  El keystore ya existe en: $KEYSTORE_PATH"
    echo ""
    read -p "¿Quieres sobrescribirlo? (s/N): " -n 1 -r
    echo ""
    if [[ ! $REPLY =~ ^[Ss]$ ]]; then
        echo "❌ Operación cancelada."
        exit 1
    fi
fi

echo "📝 Creando keystore en: $KEYSTORE_PATH"
echo ""
echo "💡 Te pedirá:"
echo "   1. Contraseña del keystore (guárdala bien)"
echo "   2. Información personal (nombre, organización, etc.)"
echo "   3. Contraseña del alias (puede ser la misma)"
echo ""

# Crear el keystore
"$KEYTOOL" -genkey -v \
  -keystore "$KEYSTORE_PATH" \
  -keyalg RSA \
  -keysize 2048 \
  -validity 10000 \
  -alias upload

if [ $? -eq 0 ]; then
    echo ""
    echo "✅ Keystore creado exitosamente!"
    echo ""
    echo "📋 Próximos pasos:"
    echo "   1. Obtener SHA-1: ./scripts/obtener_sha1_release.sh"
    echo "   2. Crear android/key.properties con las credenciales"
    echo "   3. Configurar signing en android/app/build.gradle.kts"
    echo ""
    echo "💾 HAZ BACKUP del keystore ahora:"
    echo "   cp $KEYSTORE_PATH ~/backup-upload-keystore.jks"
else
    echo ""
    echo "❌ Error al crear el keystore."
    exit 1
fi
