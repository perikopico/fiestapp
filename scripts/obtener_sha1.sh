#!/bin/bash
# Script para obtener el SHA-1 de la aplicación Android
# Uso: ./scripts/obtener_sha1.sh

echo "🔍 Obteniendo SHA-1 de la aplicación..."
echo ""

cd android

echo "📦 Ejecutando signingReport..."
./gradlew signingReport

echo ""
echo "✅ Busca en la salida el SHA-1 con formato:"
echo "   SHA1: XX:XX:XX:XX:XX:XX:..."
echo ""
echo "💡 También puedes buscar directamente:"
echo "   grep -A 5 'Variant: debug' app/build/outputs/logs/manifest-merger-*.log"
echo ""

cd ..

