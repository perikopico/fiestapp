# 📱 Cargar Logo en Android

Guía para reemplazar el icono de la app en Android con tu nuevo logo.

## 📋 Tamaños Necesarios

Android requiere diferentes tamaños del icono según la densidad de pantalla:

| Carpeta | Tamaño | Densidad |
|---------|--------|----------|
| `mipmap-mdpi` | 48x48 px | Media |
| `mipmap-hdpi` | 72x72 px | Alta |
| `mipmap-xhdpi` | 96x96 px | Extra Alta |
| `mipmap-xxhdpi` | 144x144 px | Extra Extra Alta |
| `mipmap-xxxhdpi` | 192x192 px | Extra Extra Extra Alta |

## 🚀 Opción 1: Manual (Recomendado si tienes el logo en diferentes tamaños)

### Paso 1: Preparar los iconos

1. **Genera o redimensiona tu logo** a los 5 tamaños necesarios:
   - 48x48 px → `ic_launcher.png` para `mipmap-mdpi/`
   - 72x72 px → `ic_launcher.png` para `mipmap-hdpi/`
   - 96x96 px → `ic_launcher.png` para `mipmap-xhdpi/`
   - 144x144 px → `ic_launcher.png` para `mipmap-xxhdpi/`
   - 192x192 px → `ic_launcher.png` para `mipmap-xxxhdpi/`

2. **Guarda tu logo principal** en `assets/logo/icono_original.png` (o donde prefieras)

### Paso 2: Reemplazar los iconos

Reemplaza los archivos en:
```
android/app/src/main/res/
├── mipmap-mdpi/ic_launcher.png
├── mipmap-hdpi/ic_launcher.png
├── mipmap-xhdpi/ic_launcher.png
├── mipmap-xxhdpi/ic_launcher.png
└── mipmap-xxxhdpi/ic_launcher.png
```

### Paso 3: Reconstruir la app

```bash
flutter clean
flutter pub get
flutter build apk
```

## 🚀 Opción 2: Automático con flutter_launcher_icons (Más Fácil)

### Paso 1: Instalar la herramienta

```bash
flutter pub add --dev flutter_launcher_icons
```

### Paso 2: Configurar

Crea o edita `pubspec.yaml` y añade:

```yaml
flutter_launcher_icons:
  android: true
  ios: false  # O true si también quieres iOS
  image_path: "assets/logo/icono_original.png"  # Ruta a tu logo (1024x1024px recomendado)
  adaptive_icon_background: "#0175C2"  # Color de fondo del icono adaptativo
  adaptive_icon_foreground: "assets/logo/icono_original.png"  # Tu logo
```

### Paso 3: Generar iconos automáticamente

```bash
flutter pub get
flutter pub run flutter_launcher_icons
```

Esto generará automáticamente todos los tamaños necesarios.

## 🎨 Opción 3: Usar Herramienta Online

1. Ve a: https://icon.kitchen/ o https://www.appicon.co/
2. Sube tu logo (1024x1024px recomendado)
3. Descarga el paquete de iconos para Android
4. Extrae y reemplaza los archivos en `android/app/src/main/res/`

## 📝 Notas Importantes

### Icono Adaptativo (Android 8.0+)

Android 8.0+ usa iconos adaptativos que requieren:
- **Foreground**: Tu logo (sin fondo, transparente)
- **Background**: Color sólido o gradiente

Si quieres usar iconos adaptativos, crea:
```
android/app/src/main/res/
├── mipmap-anydpi-v26/
│   ├── ic_launcher.xml
│   └── ic_launcher_round.xml
```

### Formato del Logo

- **Formato**: PNG con fondo transparente
- **Forma**: Cuadrada (Android redondea automáticamente)
- **Tamaño recomendado**: 1024x1024px para el original
- **Padding**: Deja espacio alrededor (10-15%) para que no se corte al redondear

## ✅ Verificar

1. **Limpia el proyecto**:
   ```bash
   flutter clean
   ```

2. **Reconstruye**:
   ```bash
   flutter build apk
   ```

3. **Instala en tu dispositivo**:
   ```bash
   flutter install
   ```

4. **Verifica** que el icono aparece correctamente en el launcher

## 🔧 Solución de Problemas

### El icono no cambia
- Ejecuta `flutter clean` y vuelve a construir
- Desinstala la app anterior del dispositivo
- Reinicia el dispositivo o el launcher

### El icono se ve borroso
- Asegúrate de usar imágenes de alta resolución
- Verifica que cada tamaño esté en su carpeta correcta

### El icono se corta
- Añade padding alrededor del logo (10-15% del tamaño)
- Usa la "zona segura" en el centro del icono

