// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for German (`de`).
class AppLocalizationsDe extends AppLocalizations {
  AppLocalizationsDe([String locale = 'de']) : super(locale);

  @override
  String get appTitle => 'QuePlan';

  @override
  String get cancel => 'Abbrechen';

  @override
  String get save => 'Speichern';

  @override
  String get delete => 'Löschen';

  @override
  String get confirm => 'Bestätigen';

  @override
  String get continueText => 'Fortfahren';

  @override
  String get back => 'Zurück';

  @override
  String get next => 'Weiter';

  @override
  String get done => 'Fertig';

  @override
  String get search => 'Suchen';

  @override
  String get filter => 'Filtern';

  @override
  String get settings => 'Einstellungen';

  @override
  String get profile => 'Profil';

  @override
  String get login => 'Anmelden';

  @override
  String get register => 'Registrieren';

  @override
  String get logout => 'Abmelden';

  @override
  String get createAccount => 'Konto erstellen';

  @override
  String get saveFavoritesCreateEvents =>
      'Speichere deine Favoriten und erstelle Veranstaltungen';

  @override
  String get continueWithoutAccount => 'Ohne Konto fortfahren';

  @override
  String get signUp => 'Registrieren';

  @override
  String get signIn => 'Anmelden';

  @override
  String get allCategories => 'Alle';

  @override
  String get allCategoriesLabel => 'Alle Kategorien';

  @override
  String get viewFeaturedEvents => 'Empfohlene Veranstaltungen anzeigen';

  @override
  String get enableLocationServices =>
      'Bitte aktivieren Sie die Ortungsdienste in den Einstellungen, um den Radio-Modus zu verwenden.';

  @override
  String get locationPermissionsDisabled =>
      'Standortberechtigungen sind deaktiviert. Bitte aktivieren Sie sie in den Einstellungen, um den Radio-Modus zu verwenden.';

  @override
  String get locationPermissionRequired =>
      'Standortberechtigungen sind erforderlich, um den Radio-Modus zu verwenden.';

  @override
  String errorLoadingData(String error) {
    return 'Fehler beim Laden der Daten: $error';
  }

  @override
  String get retry => 'Wiederholen';

  @override
  String get errorConnection =>
      'Verbindungsfehler. Bitte überprüfen Sie Ihre Internetverbindung.';

  @override
  String get errorPermissions =>
      'Berechtigungen sind erforderlich, um fortzufahren. Bitte überprüfen Sie die Berechtigungen in den Einstellungen.';

  @override
  String get errorAuthentication =>
      'Authentifizierungsfehler. Bitte melden Sie sich erneut an.';

  @override
  String get errorDatabase =>
      'Fehler beim Laden der Daten. Bitte versuchen Sie es später erneut.';

  @override
  String get errorUnknown =>
      'Ein unerwarteter Fehler ist aufgetreten. Bitte versuchen Sie es erneut.';

  @override
  String get mustAcceptTerms =>
      'Sie müssen die Allgemeinen Geschäftsbedingungen und die Datenschutzrichtlinie akzeptieren, um fortzufahren';

  @override
  String get consentsSaved => 'Einverständnisse erfolgreich gespeichert';

  @override
  String errorSaving(String error) {
    return 'Fehler beim Speichern: $error';
  }

  @override
  String get dataConsent => 'Dateneinverständnis';

  @override
  String get acceptTerms =>
      'Ich akzeptiere die Allgemeinen Geschäftsbedingungen';

  @override
  String get readTerms => 'Bedingungen lesen';

  @override
  String get acceptPrivacy => 'Ich akzeptiere die Datenschutzrichtlinie';

  @override
  String get readPrivacy => 'Datenschutzrichtlinie lesen';

  @override
  String get location => 'Standort';

  @override
  String get notifications => 'Benachrichtigungen';

  @override
  String get profileAndFavorites => 'Profil und Favoriten';

  @override
  String get analytics => 'Analysen';

  @override
  String get saveAndContinue => 'Speichern und fortfahren';

  @override
  String get acceptAll => 'Alle akzeptieren';

  @override
  String get aboutQuePlan => 'Über QuePlan';

  @override
  String get contact => 'Kontakt';

  @override
  String get privacyPolicy => 'Datenschutzrichtlinie';

  @override
  String get termsAndConditions => 'Allgemeine Geschäftsbedingungen';

  @override
  String get manageConsents => 'Einverständnisse verwalten';

  @override
  String get modifyPrivacyPreferences => 'Ihre Datenschutzeinstellungen ändern';

  @override
  String get noEventsFound => 'Keine Veranstaltungen gefunden';

  @override
  String get noEventsFoundDescription =>
      'Keine Veranstaltungen mit den ausgewählten Filtern gefunden';

  @override
  String get noSearchResults => 'Keine Ergebnisse';

  @override
  String get noSearchResultsDescription =>
      'Versuchen Sie, Ihre Suchfilter anzupassen';
}
