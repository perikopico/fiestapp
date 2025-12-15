#!/bin/bash
# Script para solucionar problemas de instalación de la app
# Desinstala la versión anterior antes de instalar la nueva

echo "🔍 Buscando dispositivos conectados..."
adb devices

echo ""
echo "🗑️ Desinstalando versión anterior de la app..."
adb uninstall com.perikopico.fiestapp

if [ $? -eq 0 ]; then
    echo "✅ App desinstalada correctamente"
else
    echo "⚠️ La app no estaba instalada o ya fue desinstalada"
fi

echo ""
echo "🚀 Ahora puedes ejecutar: flutter run -d <device-id>"

