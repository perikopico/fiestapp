import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_de.dart';
import 'app_localizations_en.dart';
import 'app_localizations_es.dart';
import 'app_localizations_zh.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('de'),
    Locale('en'),
    Locale('es'),
    Locale('zh'),
  ];

  /// Título de la aplicación
  ///
  /// In es, this message translates to:
  /// **'QuePlan'**
  String get appTitle;

  /// No description provided for @cancel.
  ///
  /// In es, this message translates to:
  /// **'Cancelar'**
  String get cancel;

  /// No description provided for @save.
  ///
  /// In es, this message translates to:
  /// **'Guardar'**
  String get save;

  /// No description provided for @delete.
  ///
  /// In es, this message translates to:
  /// **'Eliminar'**
  String get delete;

  /// No description provided for @confirm.
  ///
  /// In es, this message translates to:
  /// **'Confirmar'**
  String get confirm;

  /// Texto del botón continuar
  ///
  /// In es, this message translates to:
  /// **'Continuar'**
  String get continueText;

  /// No description provided for @back.
  ///
  /// In es, this message translates to:
  /// **'Atrás'**
  String get back;

  /// No description provided for @next.
  ///
  /// In es, this message translates to:
  /// **'Siguiente'**
  String get next;

  /// No description provided for @done.
  ///
  /// In es, this message translates to:
  /// **'Hecho'**
  String get done;

  /// No description provided for @search.
  ///
  /// In es, this message translates to:
  /// **'Buscar'**
  String get search;

  /// No description provided for @filter.
  ///
  /// In es, this message translates to:
  /// **'Filtrar'**
  String get filter;

  /// No description provided for @settings.
  ///
  /// In es, this message translates to:
  /// **'Configuración'**
  String get settings;

  /// No description provided for @profile.
  ///
  /// In es, this message translates to:
  /// **'Perfil'**
  String get profile;

  /// No description provided for @login.
  ///
  /// In es, this message translates to:
  /// **'Iniciar sesión'**
  String get login;

  /// No description provided for @register.
  ///
  /// In es, this message translates to:
  /// **'Registrarse'**
  String get register;

  /// No description provided for @logout.
  ///
  /// In es, this message translates to:
  /// **'Cerrar sesión'**
  String get logout;

  /// No description provided for @createAccount.
  ///
  /// In es, this message translates to:
  /// **'Crear cuenta'**
  String get createAccount;

  /// No description provided for @saveFavoritesCreateEvents.
  ///
  /// In es, this message translates to:
  /// **'Guarda tus favoritos y crea eventos'**
  String get saveFavoritesCreateEvents;

  /// No description provided for @continueWithoutAccount.
  ///
  /// In es, this message translates to:
  /// **'Continuar sin cuenta'**
  String get continueWithoutAccount;

  /// No description provided for @signUp.
  ///
  /// In es, this message translates to:
  /// **'Registrarse'**
  String get signUp;

  /// No description provided for @signIn.
  ///
  /// In es, this message translates to:
  /// **'Iniciar sesión'**
  String get signIn;

  /// Etiqueta para mostrar todas las categorías
  ///
  /// In es, this message translates to:
  /// **'Todas'**
  String get allCategories;

  /// No description provided for @allCategoriesLabel.
  ///
  /// In es, this message translates to:
  /// **'Todas las categorías'**
  String get allCategoriesLabel;

  /// No description provided for @viewFeaturedEvents.
  ///
  /// In es, this message translates to:
  /// **'Ver eventos destacados'**
  String get viewFeaturedEvents;

  /// No description provided for @enableLocationServices.
  ///
  /// In es, this message translates to:
  /// **'Por favor, activa los servicios de ubicación en Configuración para usar el modo Radio.'**
  String get enableLocationServices;

  /// No description provided for @locationPermissionsDisabled.
  ///
  /// In es, this message translates to:
  /// **'Los permisos de ubicación están deshabilitados. Por favor, habilítalos en Configuración para usar el modo Radio.'**
  String get locationPermissionsDisabled;

  /// No description provided for @locationPermissionRequired.
  ///
  /// In es, this message translates to:
  /// **'Se necesitan permisos de ubicación para usar el modo Radio.'**
  String get locationPermissionRequired;

  /// No description provided for @errorLoadingData.
  ///
  /// In es, this message translates to:
  /// **'Error al cargar datos: {error}'**
  String errorLoadingData(String error);

  /// No description provided for @retry.
  ///
  /// In es, this message translates to:
  /// **'Reintentar'**
  String get retry;

  /// No description provided for @errorConnection.
  ///
  /// In es, this message translates to:
  /// **'Error de conexión. Por favor, verifica tu conexión a internet.'**
  String get errorConnection;

  /// No description provided for @errorPermissions.
  ///
  /// In es, this message translates to:
  /// **'Se necesitan permisos para continuar. Por favor, verifica los permisos en la configuración.'**
  String get errorPermissions;

  /// No description provided for @errorAuthentication.
  ///
  /// In es, this message translates to:
  /// **'Error de autenticación. Por favor, inicia sesión nuevamente.'**
  String get errorAuthentication;

  /// No description provided for @errorDatabase.
  ///
  /// In es, this message translates to:
  /// **'Error al cargar los datos. Por favor, intenta de nuevo más tarde.'**
  String get errorDatabase;

  /// No description provided for @errorUnknown.
  ///
  /// In es, this message translates to:
  /// **'Ha ocurrido un error inesperado. Por favor, intenta de nuevo.'**
  String get errorUnknown;

  /// No description provided for @mustAcceptTerms.
  ///
  /// In es, this message translates to:
  /// **'Debes aceptar los Términos y la Política de Privacidad para continuar'**
  String get mustAcceptTerms;

  /// No description provided for @consentsSaved.
  ///
  /// In es, this message translates to:
  /// **'Consentimientos guardados correctamente'**
  String get consentsSaved;

  /// No description provided for @errorSaving.
  ///
  /// In es, this message translates to:
  /// **'Error al guardar: {error}'**
  String errorSaving(String error);

  /// No description provided for @dataConsent.
  ///
  /// In es, this message translates to:
  /// **'Consentimiento de Datos'**
  String get dataConsent;

  /// No description provided for @acceptTerms.
  ///
  /// In es, this message translates to:
  /// **'Acepto los Términos y Condiciones'**
  String get acceptTerms;

  /// No description provided for @readTerms.
  ///
  /// In es, this message translates to:
  /// **'Leer términos'**
  String get readTerms;

  /// No description provided for @acceptPrivacy.
  ///
  /// In es, this message translates to:
  /// **'Acepto la Política de Privacidad'**
  String get acceptPrivacy;

  /// No description provided for @readPrivacy.
  ///
  /// In es, this message translates to:
  /// **'Leer política de privacidad'**
  String get readPrivacy;

  /// No description provided for @location.
  ///
  /// In es, this message translates to:
  /// **'Ubicación'**
  String get location;

  /// No description provided for @notifications.
  ///
  /// In es, this message translates to:
  /// **'Notificaciones'**
  String get notifications;

  /// No description provided for @profileAndFavorites.
  ///
  /// In es, this message translates to:
  /// **'Perfil y favoritos'**
  String get profileAndFavorites;

  /// No description provided for @analytics.
  ///
  /// In es, this message translates to:
  /// **'Analytics'**
  String get analytics;

  /// No description provided for @saveAndContinue.
  ///
  /// In es, this message translates to:
  /// **'Guardar y continuar'**
  String get saveAndContinue;

  /// No description provided for @acceptAll.
  ///
  /// In es, this message translates to:
  /// **'Aceptar todo'**
  String get acceptAll;

  /// No description provided for @aboutQuePlan.
  ///
  /// In es, this message translates to:
  /// **'Sobre QuePlan'**
  String get aboutQuePlan;

  /// No description provided for @contact.
  ///
  /// In es, this message translates to:
  /// **'Contacto'**
  String get contact;

  /// No description provided for @privacyPolicy.
  ///
  /// In es, this message translates to:
  /// **'Política de Privacidad'**
  String get privacyPolicy;

  /// No description provided for @termsAndConditions.
  ///
  /// In es, this message translates to:
  /// **'Términos y Condiciones'**
  String get termsAndConditions;

  /// No description provided for @manageConsents.
  ///
  /// In es, this message translates to:
  /// **'Gestionar consentimientos'**
  String get manageConsents;

  /// No description provided for @modifyPrivacyPreferences.
  ///
  /// In es, this message translates to:
  /// **'Modificar tus preferencias de privacidad'**
  String get modifyPrivacyPreferences;

  /// No description provided for @noEventsFound.
  ///
  /// In es, this message translates to:
  /// **'No hay eventos'**
  String get noEventsFound;

  /// No description provided for @noEventsFoundDescription.
  ///
  /// In es, this message translates to:
  /// **'No se encontraron eventos con los filtros seleccionados'**
  String get noEventsFoundDescription;

  /// No description provided for @noSearchResults.
  ///
  /// In es, this message translates to:
  /// **'No hay resultados'**
  String get noSearchResults;

  /// No description provided for @noSearchResultsDescription.
  ///
  /// In es, this message translates to:
  /// **'Intenta ajustar tus filtros de búsqueda'**
  String get noSearchResultsDescription;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['de', 'en', 'es', 'zh'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'de':
      return AppLocalizationsDe();
    case 'en':
      return AppLocalizationsEn();
    case 'es':
      return AppLocalizationsEs();
    case 'zh':
      return AppLocalizationsZh();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
