import Flutter
import UIKit
import GoogleMaps

@main
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    // Inicializar Google Maps explícitamente
    // La API Key debe venir de un archivo de configuración no versionado
    // o de variables de entorno en producción
    if let path = Bundle.main.path(forResource: "GoogleService-Info", ofType: "plist"),
       let dict = NSDictionary(contentsOfFile: path),
       let apiKey = dict["GMSApiKey"] as? String, !apiKey.isEmpty {
      GMSServices.provideAPIKey(apiKey)
      print("✅ Google Maps API Key configurada desde GoogleService-Info.plist")
    } else if let infoPath = Bundle.main.path(forResource: "Info", ofType: "plist"),
              let infoDict = NSDictionary(contentsOfFile: infoPath),
              let apiKey = infoDict["GMSApiKey"] as? String, !apiKey.isEmpty {
      GMSServices.provideAPIKey(apiKey)
      print("✅ Google Maps API Key configurada desde Info.plist")
    } else {
      // En producción, esto debe fallar si no hay key configurada
      // NO usar fallback hardcodeado por seguridad
      fatalError("❌ GOOGLE_MAPS_API_KEY no configurada. Configura GMSApiKey en GoogleService-Info.plist o Info.plist")
    }
    
    GeneratedPluginRegistrant.register(with: self)
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
  
  // Manejar deep links cuando la app está abierta
  override func application(
    _ app: UIApplication,
    open url: URL,
    options: [UIApplication.OpenURLOptionsKey : Any] = [:]
  ) -> Bool {
    // Asegurar que la app vuelva al primer plano después del OAuth
    if url.scheme == "io.supabase.fiestapp" {
      // Forzar que la app esté activa y traerla al frente
      DispatchQueue.main.async {
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
           let window = windowScene.windows.first {
          window.makeKeyAndVisible()
          // Asegurar que la app esté en primer plano
          window.rootViewController?.viewDidAppear(false)
        }
      }
    }
    // Pasar el deep link a Flutter
    return super.application(app, open: url, options: options)
  }
  
  // Manejar deep links cuando la app está cerrada
  override func application(
    _ application: UIApplication,
    continue userActivity: NSUserActivity,
    restorationHandler: @escaping ([UIUserActivityRestoring]?) -> Void
  ) -> Bool {
    // Manejar Universal Links si los usas en el futuro
    return super.application(application, continue: userActivity, restorationHandler: restorationHandler)
  }
}
