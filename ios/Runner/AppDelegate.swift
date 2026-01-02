import Flutter
import UIKit
import GoogleMaps

@main
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    // Configurar Google Maps API Key
    // La API Key se lee desde Info.plist (ver Info.plist para configurarla)
    // Alternativamente, puedes configurarla aquí directamente:
    // GMSServices.provideAPIKey("TU_API_KEY_AQUI")
    
    // NOTA: La API Key debe ser la misma que usas para Android
    // Configúrala en Info.plist con la clave GMSApiKey
    
    GeneratedPluginRegistrant.register(with: self)
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}
