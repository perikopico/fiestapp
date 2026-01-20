// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'QuePlan';

  @override
  String get cancel => 'Cancel';

  @override
  String get save => 'Save';

  @override
  String get delete => 'Delete';

  @override
  String get confirm => 'Confirm';

  @override
  String get continueText => 'Continue';

  @override
  String get back => 'Back';

  @override
  String get next => 'Next';

  @override
  String get done => 'Done';

  @override
  String get search => 'Search';

  @override
  String get filter => 'Filter';

  @override
  String get settings => 'Settings';

  @override
  String get profile => 'Profile';

  @override
  String get login => 'Sign in';

  @override
  String get register => 'Register';

  @override
  String get logout => 'Sign out';

  @override
  String get createAccount => 'Create account';

  @override
  String get saveFavoritesCreateEvents =>
      'Save your favorites and create events';

  @override
  String get continueWithoutAccount => 'Continue without account';

  @override
  String get signUp => 'Sign up';

  @override
  String get signIn => 'Sign in';

  @override
  String get allCategories => 'All';

  @override
  String get allCategoriesLabel => 'All categories';

  @override
  String get viewFeaturedEvents => 'View featured events';

  @override
  String get enableLocationServices =>
      'Please enable location services in Settings to use Radio mode.';

  @override
  String get locationPermissionsDisabled =>
      'Location permissions are disabled. Please enable them in Settings to use Radio mode.';

  @override
  String get locationPermissionRequired =>
      'Location permissions are required to use Radio mode.';

  @override
  String errorLoadingData(String error) {
    return 'Error loading data: $error';
  }

  @override
  String get retry => 'Retry';

  @override
  String get errorConnection =>
      'Connection error. Please check your internet connection.';

  @override
  String get errorPermissions =>
      'Permissions are required to continue. Please check permissions in settings.';

  @override
  String get errorAuthentication =>
      'Authentication error. Please sign in again.';

  @override
  String get errorDatabase => 'Error loading data. Please try again later.';

  @override
  String get errorUnknown => 'An unexpected error occurred. Please try again.';

  @override
  String get mustAcceptTerms =>
      'You must accept the Terms and Privacy Policy to continue';

  @override
  String get consentsSaved => 'Consents saved successfully';

  @override
  String errorSaving(String error) {
    return 'Error saving: $error';
  }

  @override
  String get dataConsent => 'Data Consent';

  @override
  String get acceptTerms => 'I accept the Terms and Conditions';

  @override
  String get readTerms => 'Read terms';

  @override
  String get acceptPrivacy => 'I accept the Privacy Policy';

  @override
  String get readPrivacy => 'Read privacy policy';

  @override
  String get location => 'Location';

  @override
  String get notifications => 'Notifications';

  @override
  String get profileAndFavorites => 'Profile and favorites';

  @override
  String get analytics => 'Analytics';

  @override
  String get saveAndContinue => 'Save and continue';

  @override
  String get acceptAll => 'Accept all';

  @override
  String get aboutQuePlan => 'About QuePlan';

  @override
  String get contact => 'Contact';

  @override
  String get privacyPolicy => 'Privacy Policy';

  @override
  String get termsAndConditions => 'Terms and Conditions';

  @override
  String get manageConsents => 'Manage consents';

  @override
  String get modifyPrivacyPreferences => 'Modify your privacy preferences';

  @override
  String get noEventsFound => 'No events found';

  @override
  String get noEventsFoundDescription =>
      'No events found with the selected filters';

  @override
  String get noSearchResults => 'No results';

  @override
  String get noSearchResultsDescription => 'Try adjusting your search filters';
}
