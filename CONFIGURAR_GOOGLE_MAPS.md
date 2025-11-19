# Configurar Google Maps API Key

## Pasos para configurar la API key de Google Maps

### 1. Obtener SHA-1 Fingerprint

Ejecuta este comando en la terminal desde la raíz del proyecto:

```bash
cd android
./gradlew signingReport
```

Busca el SHA-1 en la salida. Debería verse algo como:
```
SHA1: 12:FE:47:5B:A4:14:D7:44:D0:C4:F8:C2:C3:68:F2:6A:63:8A:AD:7A
```

### 2. Crear API Key en Google Cloud Console

1. Ve a [Google Cloud Console](https://console.cloud.google.com/)
2. Crea un nuevo proyecto o selecciona uno existente
3. Habilita la API "Maps SDK for Android":
   - Ve a "APIs & Services" > "Library"
   - Busca "Maps SDK for Android"
   - Haz clic en "Enable"

### 3. Crear y configurar la API Key

1. Ve a "APIs & Services" > "Credentials"
2. Haz clic en "Create Credentials" > "API Key"
3. Se creará una nueva API key
4. Haz clic en "Restrict key" para configurar restricciones
5. En "Application restrictions", selecciona "Android apps"
6. Haz clic en "Add an item" y añade:
   - **Package name**: `com.perikopico.fiestapp`
   - **SHA-1 certificate fingerprint**: El SHA-1 que obtuviste en el paso 1
7. En "API restrictions", selecciona "Restrict key" y marca solo "Maps SDK for Android"
8. Guarda los cambios

### 4. Configurar la API Key en AndroidManifest.xml

1. Abre el archivo `android/app/src/main/AndroidManifest.xml`
2. Busca la línea que dice:
   ```xml
   <meta-data
       android:name="com.google.android.geo.API_KEY"
       android:value="AIzaSyDummyKeyReplaceWithYourActualKey" />
   ```
3. Reemplaza `AIzaSyDummyKeyReplaceWithYourActualKey` con tu API key real

### 5. Reconstruir la app

```bash
flutter clean
flutter pub get
flutter run
```

## Notas importantes

- La API key debe tener restricciones de aplicación Android configuradas
- El SHA-1 fingerprint debe coincidir exactamente con el de tu app
- Puede tardar unos minutos en propagarse después de crear la API key
- Si cambias el SHA-1 (por ejemplo, al firmar la app para producción), necesitarás añadir el nuevo SHA-1 a la API key

