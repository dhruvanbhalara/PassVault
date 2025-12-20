import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';

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
  static const List<Locale> supportedLocales = <Locale>[Locale('en')];

  /// No description provided for @appName.
  ///
  /// In en, this message translates to:
  /// **'PassVault'**
  String get appName;

  /// No description provided for @locked.
  ///
  /// In en, this message translates to:
  /// **'Locked'**
  String get locked;

  /// No description provided for @unlockWithBiometrics.
  ///
  /// In en, this message translates to:
  /// **'Unlock with Biometrics'**
  String get unlockWithBiometrics;

  /// No description provided for @settings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settings;

  /// No description provided for @home.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get home;

  /// No description provided for @addPassword.
  ///
  /// In en, this message translates to:
  /// **'Add Password'**
  String get addPassword;

  /// No description provided for @editPassword.
  ///
  /// In en, this message translates to:
  /// **'Edit Password'**
  String get editPassword;

  /// No description provided for @noPasswords.
  ///
  /// In en, this message translates to:
  /// **'No passwords yet.\nTap + to add one.'**
  String get noPasswords;

  /// No description provided for @passwordCopied.
  ///
  /// In en, this message translates to:
  /// **'Password copied to clipboard'**
  String get passwordCopied;

  /// No description provided for @delete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get delete;

  /// No description provided for @appearance.
  ///
  /// In en, this message translates to:
  /// **'Appearance'**
  String get appearance;

  /// No description provided for @theme.
  ///
  /// In en, this message translates to:
  /// **'Theme'**
  String get theme;

  /// No description provided for @system.
  ///
  /// In en, this message translates to:
  /// **'System Default'**
  String get system;

  /// No description provided for @light.
  ///
  /// In en, this message translates to:
  /// **'Light'**
  String get light;

  /// No description provided for @dark.
  ///
  /// In en, this message translates to:
  /// **'Dark'**
  String get dark;

  /// No description provided for @amoled.
  ///
  /// In en, this message translates to:
  /// **'AMOLED (Pure Black)'**
  String get amoled;

  /// No description provided for @security.
  ///
  /// In en, this message translates to:
  /// **'Security'**
  String get security;

  /// No description provided for @useBiometrics.
  ///
  /// In en, this message translates to:
  /// **'Biometric Authentication'**
  String get useBiometrics;

  /// No description provided for @dataManagement.
  ///
  /// In en, this message translates to:
  /// **'Data Management'**
  String get dataManagement;

  /// No description provided for @exportData.
  ///
  /// In en, this message translates to:
  /// **'Export Data (JSON/CSV)'**
  String get exportData;

  /// No description provided for @importData.
  ///
  /// In en, this message translates to:
  /// **'Import Data'**
  String get importData;

  /// No description provided for @save.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get save;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @appNameLabel.
  ///
  /// In en, this message translates to:
  /// **'App Name'**
  String get appNameLabel;

  /// No description provided for @usernameLabel.
  ///
  /// In en, this message translates to:
  /// **'Username'**
  String get usernameLabel;

  /// No description provided for @passwordLabel.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get passwordLabel;

  /// No description provided for @errorOccurred.
  ///
  /// In en, this message translates to:
  /// **'An error occurred'**
  String get errorOccurred;

  /// No description provided for @success.
  ///
  /// In en, this message translates to:
  /// **'Success'**
  String get success;

  /// No description provided for @exportSuccess.
  ///
  /// In en, this message translates to:
  /// **'Data exported successfully'**
  String get exportSuccess;

  /// No description provided for @importSuccess.
  ///
  /// In en, this message translates to:
  /// **'Data imported successfully'**
  String get importSuccess;

  /// No description provided for @biometricsNotSetup.
  ///
  /// In en, this message translates to:
  /// **'Biometrics not set up or not available.'**
  String get biometricsNotSetup;

  /// No description provided for @enterAppWithoutBiometrics.
  ///
  /// In en, this message translates to:
  /// **'Enter without Biometrics'**
  String get enterAppWithoutBiometrics;

  /// No description provided for @exportJson.
  ///
  /// In en, this message translates to:
  /// **'Export as JSON'**
  String get exportJson;

  /// No description provided for @exportCsv.
  ///
  /// In en, this message translates to:
  /// **'Export as CSV'**
  String get exportCsv;

  /// No description provided for @importJson.
  ///
  /// In en, this message translates to:
  /// **'Import from JSON'**
  String get importJson;

  /// No description provided for @importCsv.
  ///
  /// In en, this message translates to:
  /// **'Import from CSV'**
  String get importCsv;

  /// No description provided for @onboardingTitle1.
  ///
  /// In en, this message translates to:
  /// **'Secure Storage'**
  String get onboardingTitle1;

  /// No description provided for @onboardingDesc1.
  ///
  /// In en, this message translates to:
  /// **'Your passwords are stored locally on your device, encrypted with strong AES-256 encryption. No data ever leaves your phone.'**
  String get onboardingDesc1;

  /// No description provided for @onboardingTitle2.
  ///
  /// In en, this message translates to:
  /// **'Offline First'**
  String get onboardingTitle2;

  /// No description provided for @onboardingDesc2.
  ///
  /// In en, this message translates to:
  /// **'Access your credentials anywhere, anytime, without an internet connection. Total control, total privacy.'**
  String get onboardingDesc2;

  /// No description provided for @onboardingTitle3.
  ///
  /// In en, this message translates to:
  /// **'Biometric Access'**
  String get onboardingTitle3;

  /// No description provided for @onboardingDesc3.
  ///
  /// In en, this message translates to:
  /// **'Unlock your vault with a touch or a glance. Seamless security integrated with your device\'s biometric authentication.'**
  String get onboardingDesc3;

  /// No description provided for @skip.
  ///
  /// In en, this message translates to:
  /// **'Skip'**
  String get skip;

  /// No description provided for @next.
  ///
  /// In en, this message translates to:
  /// **'Next'**
  String get next;

  /// No description provided for @done.
  ///
  /// In en, this message translates to:
  /// **'Done'**
  String get done;

  /// No description provided for @generate.
  ///
  /// In en, this message translates to:
  /// **'Generate'**
  String get generate;

  /// No description provided for @authFailed.
  ///
  /// In en, this message translates to:
  /// **'Authentication failed'**
  String get authFailed;

  /// No description provided for @biometricsNotAvailable.
  ///
  /// In en, this message translates to:
  /// **'Biometrics not available'**
  String get biometricsNotAvailable;

  /// No description provided for @noDataToExport.
  ///
  /// In en, this message translates to:
  /// **'No password data to export'**
  String get noDataToExport;

  /// No description provided for @importFailed.
  ///
  /// In en, this message translates to:
  /// **'Failed to import data'**
  String get importFailed;

  /// No description provided for @passwordGeneration.
  ///
  /// In en, this message translates to:
  /// **'Password Generation'**
  String get passwordGeneration;

  /// No description provided for @passwordLength.
  ///
  /// In en, this message translates to:
  /// **'Password Length'**
  String get passwordLength;

  /// No description provided for @uppercase.
  ///
  /// In en, this message translates to:
  /// **'Uppercase'**
  String get uppercase;

  /// No description provided for @lowercase.
  ///
  /// In en, this message translates to:
  /// **'Lowercase'**
  String get lowercase;

  /// No description provided for @numbers.
  ///
  /// In en, this message translates to:
  /// **'Numbers'**
  String get numbers;

  /// No description provided for @specialCharacters.
  ///
  /// In en, this message translates to:
  /// **'Special Characters'**
  String get specialCharacters;

  /// No description provided for @characters.
  ///
  /// In en, this message translates to:
  /// **'Characters'**
  String get characters;

  /// No description provided for @excludeAmbiguous.
  ///
  /// In en, this message translates to:
  /// **'Exclude Ambiguous'**
  String get excludeAmbiguous;

  /// No description provided for @excludeAmbiguousHint.
  ///
  /// In en, this message translates to:
  /// **'I, l, 1, O, 0'**
  String get excludeAmbiguousHint;

  /// No description provided for @characterSets.
  ///
  /// In en, this message translates to:
  /// **'Character Sets'**
  String get characterSets;

  /// No description provided for @preview.
  ///
  /// In en, this message translates to:
  /// **'Preview'**
  String get preview;

  /// No description provided for @refreshPreview.
  ///
  /// In en, this message translates to:
  /// **'Refresh Preview'**
  String get refreshPreview;

  /// No description provided for @jsonBackupFormat.
  ///
  /// In en, this message translates to:
  /// **'Structured format for backups'**
  String get jsonBackupFormat;

  /// No description provided for @csvSpreadsheetFormat.
  ///
  /// In en, this message translates to:
  /// **'Spreadsheet compatible format'**
  String get csvSpreadsheetFormat;

  /// No description provided for @importFromJsonBackup.
  ///
  /// In en, this message translates to:
  /// **'Import from JSON backup'**
  String get importFromJsonBackup;

  /// No description provided for @importFromSpreadsheet.
  ///
  /// In en, this message translates to:
  /// **'Import from spreadsheet'**
  String get importFromSpreadsheet;

  /// No description provided for @options.
  ///
  /// In en, this message translates to:
  /// **'Options'**
  String get options;

  /// No description provided for @hintAppName.
  ///
  /// In en, this message translates to:
  /// **'e.g. Netflix, Github'**
  String get hintAppName;

  /// No description provided for @hintUsername.
  ///
  /// In en, this message translates to:
  /// **'e.g. john.doe@email.com'**
  String get hintUsername;

  /// No description provided for @hintPassword.
  ///
  /// In en, this message translates to:
  /// **'••••••••••••'**
  String get hintPassword;

  /// No description provided for @uppercaseHint.
  ///
  /// In en, this message translates to:
  /// **'A-Z'**
  String get uppercaseHint;

  /// No description provided for @lowercaseHint.
  ///
  /// In en, this message translates to:
  /// **'a-z'**
  String get lowercaseHint;

  /// No description provided for @numbersHint.
  ///
  /// In en, this message translates to:
  /// **'0-9'**
  String get numbersHint;

  /// No description provided for @specialCharsHint.
  ///
  /// In en, this message translates to:
  /// **'!@#\$%^&*'**
  String get specialCharsHint;
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
      <String>['en'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
