plugins {
    id("com.android.application")
    id("kotlin-android")
    // The Flutter Gradle Plugin must be applied after the Android and Kotlin Gradle plugins.
    id("dev.flutter.flutter-gradle-plugin")
}

// Aplicar plugin de Google Services solo si existe google-services.json
val googleServicesJson = file("google-services.json")
if (googleServicesJson.exists()) {
    apply(plugin = "com.google.gms.google-services")
} else {
    println("⚠️  google-services.json no encontrado. Firebase deshabilitado para esta compilación.")
    println("💡 Para habilitar Firebase, descarga google-services.json desde Firebase Console y colócalo en android/app/")
}

// Leer API key desde local.properties
val googleMapsApiKey = run {
    val localPropertiesFile = rootProject.file("local.properties")
    if (localPropertiesFile.exists()) {
        val lines = localPropertiesFile.readLines()
        val apiKeyLine = lines.find { it.startsWith("GOOGLE_MAPS_API_KEY=") }
        apiKeyLine?.substringAfter("=")?.trim() ?: ""
    } else {
        ""
    }
}

android {
    namespace = "com.perikopico.fiestapp"
    compileSdk = flutter.compileSdkVersion
    ndkVersion = flutter.ndkVersion

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_11
        targetCompatibility = JavaVersion.VERSION_11
    }

    kotlinOptions {
        jvmTarget = JavaVersion.VERSION_11.toString()
    }

    defaultConfig {
        applicationId = "com.perikopico.fiestapp"
        // You can update the following values to match your application needs.
        // For more information, see: https://flutter.dev/to/review-gradle-config.
        minSdk = flutter.minSdkVersion
        targetSdk = flutter.targetSdkVersion
        versionCode = flutter.versionCode
        versionName = flutter.versionName
        
        // Inyectar API key de Google Maps desde local.properties
        // Si no está definida, usar una cadena vacía (la app fallará si no está configurada)
        manifestPlaceholders["GOOGLE_MAPS_API_KEY"] = googleMapsApiKey
    }

    buildTypes {
        release {
            // ⚠️ CRÍTICO: Configurar signing para release antes de publicar en Play Store
            // Pasos:
            // 1. Crear keystore: keytool -genkey -v -keystore ~/upload-keystore.jks -keyalg RSA -keysize 2048 -validity 10000 -alias upload
            // 2. Crear key.properties en android/ con las credenciales
            // 3. Configurar signingConfigs en este archivo
            // 4. Cambiar esta línea para usar el signing config de release
            // 
            // Por ahora usa debug keys solo para desarrollo/testing
            // TODO: Configurar signing para release antes de publicar
            signingConfig = signingConfigs.getByName("debug")
        }
    }
}

flutter {
    source = "../.."
}
