# 🚀 Guía Rápida: Cargar Logo en Android

## ⚡ Opción Más Rápida (Recomendada)

### 1. Prepara tu logo
- Formato: PNG con fondo transparente
- Tamaño: 1024x1024px (o más grande)
- Guárdalo en: `assets/logo/icono.png`

### 2. Usa el script automático

```bash
./scripts/configurar_icono_android.sh assets/logo/icono.png
```

El script:
- ✅ Copia tu logo a la carpeta de assets
- ✅ Redimensiona automáticamente a todos los tamaños necesarios
- ✅ Reemplaza los iconos en Android

**Nota**: Necesitas ImageMagick instalado. Si no lo tienes:
```bash
sudo apt-get install imagemagick
```

### 3. Reconstruye la app

```bash
flutter clean
flutter build apk
flutter install
```

## 🎨 Opción con flutter_launcher_icons (Más Profesional)

### 1. Instala la herramienta

```bash
flutter pub add --dev flutter_launcher_icons
```

### 2. Añade esto a `pubspec.yaml`:

```yaml
flutter_launcher_icons:
  android: true
  ios: false
  image_path: "assets/logo/icono.png"
  adaptive_icon_background: "#0175C2"
  adaptive_icon_foreground: "assets/logo/icono.png"
```

### 3. Genera los iconos

```bash
flutter pub get
flutter pub run flutter_launcher_icons
```

### 4. Reconstruye

```bash
flutter clean
flutter build apk
```

## 📋 Opción Manual (Si prefieres control total)

1. **Redimensiona tu logo** a estos tamaños:
   - 48x48 px
   - 72x72 px
   - 96x96 px
   - 144x144 px
   - 192x192 px

2. **Reemplaza los archivos** en:
   ```
   android/app/src/main/res/
   ├── mipmap-mdpi/ic_launcher.png    (48x48)
   ├── mipmap-hdpi/ic_launcher.png   (72x72)
   ├── mipmap-xhdpi/ic_launcher.png  (96x96)
   ├── mipmap-xxhdpi/ic_launcher.png (144x144)
   └── mipmap-xxxhdpi/ic_launcher.png (192x192)
   ```

3. **Reconstruye**:
   ```bash
   flutter clean
   flutter build apk
   ```

## ⚠️ Si el icono no cambia

1. **Desinstala la app** del dispositivo:
   ```bash
   adb uninstall com.perikopico.fiestapp
   ```

2. **Limpia completamente**:
   ```bash
   flutter clean
   rm -rf build/
   ```

3. **Reconstruye e instala**:
   ```bash
   flutter build apk
   flutter install
   ```

4. **Reinicia el dispositivo** o el launcher de Android

## 💡 Consejos

- **Padding**: Deja 10-15% de espacio alrededor del logo para que no se corte al redondear
- **Fondo transparente**: Usa PNG con canal alpha
- **Alta resolución**: Usa al menos 1024x1024px para el original
- **Zona segura**: Mantén los elementos importantes en el centro del icono

