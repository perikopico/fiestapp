// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Spanish Castilian (`es`).
class AppLocalizationsEs extends AppLocalizations {
  AppLocalizationsEs([String locale = 'es']) : super(locale);

  @override
  String get appTitle => 'QuePlan';

  @override
  String get cancel => 'Cancelar';

  @override
  String get save => 'Guardar';

  @override
  String get delete => 'Eliminar';

  @override
  String get confirm => 'Confirmar';

  @override
  String get continueText => 'Continuar';

  @override
  String get back => 'Atrás';

  @override
  String get next => 'Siguiente';

  @override
  String get done => 'Hecho';

  @override
  String get search => 'Buscar';

  @override
  String get filter => 'Filtrar';

  @override
  String get settings => 'Configuración';

  @override
  String get profile => 'Perfil';

  @override
  String get login => 'Iniciar sesión';

  @override
  String get register => 'Registrarse';

  @override
  String get logout => 'Cerrar sesión';

  @override
  String get createAccount => 'Crear cuenta';

  @override
  String get saveFavoritesCreateEvents => 'Guarda tus favoritos y crea eventos';

  @override
  String get continueWithoutAccount => 'Continuar sin cuenta';

  @override
  String get signUp => 'Registrarse';

  @override
  String get signIn => 'Iniciar sesión';

  @override
  String get allCategories => 'Todas';

  @override
  String get allCategoriesLabel => 'Todas las categorías';

  @override
  String get viewFeaturedEvents => 'Ver eventos destacados';

  @override
  String get enableLocationServices =>
      'Por favor, activa los servicios de ubicación en Configuración para usar el modo Radio.';

  @override
  String get locationPermissionsDisabled =>
      'Los permisos de ubicación están deshabilitados. Por favor, habilítalos en Configuración para usar el modo Radio.';

  @override
  String get locationPermissionRequired =>
      'Se necesitan permisos de ubicación para usar el modo Radio.';

  @override
  String errorLoadingData(String error) {
    return 'Error al cargar datos: $error';
  }

  @override
  String get retry => 'Reintentar';

  @override
  String get errorConnection =>
      'Error de conexión. Por favor, verifica tu conexión a internet.';

  @override
  String get errorPermissions =>
      'Se necesitan permisos para continuar. Por favor, verifica los permisos en la configuración.';

  @override
  String get errorAuthentication =>
      'Error de autenticación. Por favor, inicia sesión nuevamente.';

  @override
  String get errorDatabase =>
      'Error al cargar los datos. Por favor, intenta de nuevo más tarde.';

  @override
  String get errorUnknown =>
      'Ha ocurrido un error inesperado. Por favor, intenta de nuevo.';

  @override
  String get mustAcceptTerms =>
      'Debes aceptar los Términos y la Política de Privacidad para continuar';

  @override
  String get consentsSaved => 'Consentimientos guardados correctamente';

  @override
  String errorSaving(String error) {
    return 'Error al guardar: $error';
  }

  @override
  String get dataConsent => 'Consentimiento de Datos';

  @override
  String get acceptTerms => 'Acepto los Términos y Condiciones';

  @override
  String get readTerms => 'Leer términos';

  @override
  String get acceptPrivacy => 'Acepto la Política de Privacidad';

  @override
  String get readPrivacy => 'Leer política de privacidad';

  @override
  String get location => 'Ubicación';

  @override
  String get notifications => 'Notificaciones';

  @override
  String get profileAndFavorites => 'Perfil y favoritos';

  @override
  String get analytics => 'Analytics';

  @override
  String get saveAndContinue => 'Guardar y continuar';

  @override
  String get acceptAll => 'Aceptar todo';

  @override
  String get aboutQuePlan => 'Sobre QuePlan';

  @override
  String get contact => 'Contacto';

  @override
  String get privacyPolicy => 'Política de Privacidad';

  @override
  String get termsAndConditions => 'Términos y Condiciones';

  @override
  String get manageConsents => 'Gestionar consentimientos';

  @override
  String get modifyPrivacyPreferences =>
      'Modificar tus preferencias de privacidad';

  @override
  String get noEventsFound => 'No hay eventos';

  @override
  String get noEventsFoundDescription =>
      'No se encontraron eventos con los filtros seleccionados';

  @override
  String get noSearchResults => 'No hay resultados';

  @override
  String get noSearchResultsDescription =>
      'Intenta ajustar tus filtros de búsqueda';
}
