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

  /// No description provided for @apply.
  ///
  /// In en, this message translates to:
  /// **'Apply'**
  String get apply;

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

  /// No description provided for @databaseError.
  ///
  /// In en, this message translates to:
  /// **'Database error occurred'**
  String get databaseError;

  /// No description provided for @authError.
  ///
  /// In en, this message translates to:
  /// **'Authentication error'**
  String get authError;

  /// No description provided for @securityError.
  ///
  /// In en, this message translates to:
  /// **'Security violation or error'**
  String get securityError;

  /// No description provided for @migrationError.
  ///
  /// In en, this message translates to:
  /// **'Data migration failed'**
  String get migrationError;

  /// No description provided for @fileReadError.
  ///
  /// In en, this message translates to:
  /// **'Could not read the file'**
  String get fileReadError;

  /// No description provided for @invalidFormatError.
  ///
  /// In en, this message translates to:
  /// **'Invalid file format'**
  String get invalidFormatError;

  /// No description provided for @parsingError.
  ///
  /// In en, this message translates to:
  /// **'Error parsing file content'**
  String get parsingError;

  /// No description provided for @noDataFound.
  ///
  /// In en, this message translates to:
  /// **'No valid data found'**
  String get noDataFound;

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

  /// No description provided for @strategy.
  ///
  /// In en, this message translates to:
  /// **'Strategy'**
  String get strategy;

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

  /// No description provided for @wrongPassword.
  ///
  /// In en, this message translates to:
  /// **'Incorrect password. Please try again.'**
  String get wrongPassword;

  /// No description provided for @exportEncrypted.
  ///
  /// In en, this message translates to:
  /// **'Export Encrypted (.pvault)'**
  String get exportEncrypted;

  /// No description provided for @encryptedPasswordProtected.
  ///
  /// In en, this message translates to:
  /// **'Password-protected secure backup'**
  String get encryptedPasswordProtected;

  /// No description provided for @importEncrypted.
  ///
  /// In en, this message translates to:
  /// **'Import from Encrypted (.pvault)'**
  String get importEncrypted;

  /// No description provided for @importFromEncryptedBackup.
  ///
  /// In en, this message translates to:
  /// **'Import password-protected backup'**
  String get importFromEncryptedBackup;

  /// No description provided for @enterExportPassword.
  ///
  /// In en, this message translates to:
  /// **'Enter a password to protect your backup'**
  String get enterExportPassword;

  /// No description provided for @enterImportPassword.
  ///
  /// In en, this message translates to:
  /// **'Enter the backup password'**
  String get enterImportPassword;

  /// No description provided for @passwordRequired.
  ///
  /// In en, this message translates to:
  /// **'Password is required'**
  String get passwordRequired;

  /// No description provided for @export.
  ///
  /// In en, this message translates to:
  /// **'Export'**
  String get export;

  /// No description provided for @import.
  ///
  /// In en, this message translates to:
  /// **'Import'**
  String get import;

  /// No description provided for @processing.
  ///
  /// In en, this message translates to:
  /// **'Processing...'**
  String get processing;

  /// No description provided for @databaseCleared.
  ///
  /// In en, this message translates to:
  /// **'Database cleared successfully'**
  String get databaseCleared;

  /// No description provided for @fileNotFound.
  ///
  /// In en, this message translates to:
  /// **'File not found'**
  String get fileNotFound;

  /// No description provided for @clearDatabase.
  ///
  /// In en, this message translates to:
  /// **'Clear Database'**
  String get clearDatabase;

  /// No description provided for @debugDeleteAllPasswords.
  ///
  /// In en, this message translates to:
  /// **'Debug: Delete all passwords'**
  String get debugDeleteAllPasswords;

  /// No description provided for @clearDatabaseTitle.
  ///
  /// In en, this message translates to:
  /// **'Clear Database?'**
  String get clearDatabaseTitle;

  /// No description provided for @clearDatabaseMessage.
  ///
  /// In en, this message translates to:
  /// **'This will permanently delete ALL passwords from the database. This action cannot be undone.\\n\\nThis is a DEBUG feature for testing.'**
  String get clearDatabaseMessage;

  /// No description provided for @clearAll.
  ///
  /// In en, this message translates to:
  /// **'Clear All'**
  String get clearAll;

  /// No description provided for @resolveDuplicatesTitle.
  ///
  /// In en, this message translates to:
  /// **'Resolve Duplicates'**
  String get resolveDuplicatesTitle;

  /// No description provided for @resolveRemainingDuplicates.
  ///
  /// In en, this message translates to:
  /// **'Please resolve all {count} remaining duplicates'**
  String resolveRemainingDuplicates(int count);

  /// No description provided for @resolveCountDuplicates.
  ///
  /// In en, this message translates to:
  /// **'Resolve {count} Duplicates'**
  String resolveCountDuplicates(int count);

  /// No description provided for @duplicatesFoundCount.
  ///
  /// In en, this message translates to:
  /// **'{count} duplicate(s) found'**
  String duplicatesFoundCount(int count);

  /// No description provided for @chooseResolutionAction.
  ///
  /// In en, this message translates to:
  /// **'Choose action:'**
  String get chooseResolutionAction;

  /// No description provided for @keepExistingTitle.
  ///
  /// In en, this message translates to:
  /// **'Keep Existing'**
  String get keepExistingTitle;

  /// No description provided for @keepExistingSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Ignore imported entry'**
  String get keepExistingSubtitle;

  /// No description provided for @replaceWithNewTitle.
  ///
  /// In en, this message translates to:
  /// **'Replace with New'**
  String get replaceWithNewTitle;

  /// No description provided for @replaceWithNewSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Update with imported data'**
  String get replaceWithNewSubtitle;

  /// No description provided for @keepBothTitle.
  ///
  /// In en, this message translates to:
  /// **'Keep Both'**
  String get keepBothTitle;

  /// No description provided for @keepBothSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Save both entries'**
  String get keepBothSubtitle;

  /// No description provided for @bulkActionsTitle.
  ///
  /// In en, this message translates to:
  /// **'Bulk Actions'**
  String get bulkActionsTitle;

  /// No description provided for @bulkActionsSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Apply a single decision to all remaining conflicts:'**
  String get bulkActionsSubtitle;

  /// No description provided for @keepAllExisting.
  ///
  /// In en, this message translates to:
  /// **'Keep All Existing'**
  String get keepAllExisting;

  /// No description provided for @replaceAll.
  ///
  /// In en, this message translates to:
  /// **'Replace All'**
  String get replaceAll;

  /// No description provided for @keepAllBothAction.
  ///
  /// In en, this message translates to:
  /// **'Keep All Both'**
  String get keepAllBothAction;

  /// No description provided for @noStrategiesFound.
  ///
  /// In en, this message translates to:
  /// **'No strategies found.'**
  String get noStrategiesFound;

  /// No description provided for @newStrategy.
  ///
  /// In en, this message translates to:
  /// **'New Strategy'**
  String get newStrategy;

  /// No description provided for @editStrategy.
  ///
  /// In en, this message translates to:
  /// **'Edit Strategy'**
  String get editStrategy;

  /// No description provided for @setAsDefault.
  ///
  /// In en, this message translates to:
  /// **'Set as Default'**
  String get setAsDefault;

  /// No description provided for @generationStrategy.
  ///
  /// In en, this message translates to:
  /// **'Generation Strategy'**
  String get generationStrategy;

  /// No description provided for @strategyName.
  ///
  /// In en, this message translates to:
  /// **'Strategy Name'**
  String get strategyName;

  /// No description provided for @hintStrategyName.
  ///
  /// In en, this message translates to:
  /// **'e.g. High Security, PIN'**
  String get hintStrategyName;

  /// No description provided for @minLabel.
  ///
  /// In en, this message translates to:
  /// **'16'**
  String get minLabel;

  /// No description provided for @maxLabel.
  ///
  /// In en, this message translates to:
  /// **'64'**
  String get maxLabel;

  /// No description provided for @strategySubtitle.
  ///
  /// In en, this message translates to:
  /// **'Manage your custom presets used for generating secure passwords.'**
  String get strategySubtitle;

  /// No description provided for @noStrategiesDescription.
  ///
  /// In en, this message translates to:
  /// **'Create your first strategy to get started.'**
  String get noStrategiesDescription;

  /// No description provided for @onboardingTitle4.
  ///
  /// In en, this message translates to:
  /// **'Smart Strategies'**
  String get onboardingTitle4;

  /// No description provided for @onboardingDesc4.
  ///
  /// In en, this message translates to:
  /// **'Create custom password presets for different needs. PINs, high-security phrases, or legacy formats—managed your way.'**
  String get onboardingDesc4;

  /// No description provided for @activeDefaultLabel.
  ///
  /// In en, this message translates to:
  /// **'Active Strategy'**
  String get activeDefaultLabel;

  /// No description provided for @activeConfiguration.
  ///
  /// In en, this message translates to:
  /// **'Active Configuration'**
  String get activeConfiguration;

  /// No description provided for @savedStrategies.
  ///
  /// In en, this message translates to:
  /// **'Saved Strategies'**
  String get savedStrategies;

  /// No description provided for @exportVault.
  ///
  /// In en, this message translates to:
  /// **'Export Vault'**
  String get exportVault;

  /// No description provided for @entryDetails.
  ///
  /// In en, this message translates to:
  /// **'Entry Details'**
  String get entryDetails;

  /// No description provided for @resolveConflicts.
  ///
  /// In en, this message translates to:
  /// **'Resolve Conflicts'**
  String get resolveConflicts;

  /// No description provided for @resolveConflictsDesc.
  ///
  /// In en, this message translates to:
  /// **'Please resolve all remaining duplicates'**
  String get resolveConflictsDesc;

  /// No description provided for @exportFormat.
  ///
  /// In en, this message translates to:
  /// **'EXPORT FORMAT'**
  String get exportFormat;

  /// No description provided for @jsonRecommended.
  ///
  /// In en, this message translates to:
  /// **'JSON (Recommended)'**
  String get jsonRecommended;

  /// No description provided for @jsonDesc.
  ///
  /// In en, this message translates to:
  /// **'Structured data, easy to import back.'**
  String get jsonDesc;

  /// No description provided for @csvSpreadsheet.
  ///
  /// In en, this message translates to:
  /// **'CSV Spreadsheet'**
  String get csvSpreadsheet;

  /// No description provided for @csvDesc.
  ///
  /// In en, this message translates to:
  /// **'Viewable in Excel or Google Sheets.'**
  String get csvDesc;

  /// No description provided for @encryptWithPassword.
  ///
  /// In en, this message translates to:
  /// **'Encrypt with Password'**
  String get encryptWithPassword;

  /// No description provided for @encryptDesc.
  ///
  /// In en, this message translates to:
  /// **'Highly recommended for security.'**
  String get encryptDesc;

  /// No description provided for @encryptionPassword.
  ///
  /// In en, this message translates to:
  /// **'Encryption Password'**
  String get encryptionPassword;

  /// No description provided for @exportNow.
  ///
  /// In en, this message translates to:
  /// **'Export Now'**
  String get exportNow;

  /// No description provided for @warningSensitiveData.
  ///
  /// In en, this message translates to:
  /// **'Exported files contain your sensitive data. Keep them secure or delete them after use.'**
  String get warningSensitiveData;

  /// No description provided for @passwordGenerator.
  ///
  /// In en, this message translates to:
  /// **'Password Generator'**
  String get passwordGenerator;

  /// No description provided for @lengthLabel.
  ///
  /// In en, this message translates to:
  /// **'Length'**
  String get lengthLabel;

  /// No description provided for @uppercaseLabel.
  ///
  /// In en, this message translates to:
  /// **'Uppercase (A-Z)'**
  String get uppercaseLabel;

  /// No description provided for @lowercaseLabel.
  ///
  /// In en, this message translates to:
  /// **'Lowercase (a-z)'**
  String get lowercaseLabel;

  /// No description provided for @numbersLabel.
  ///
  /// In en, this message translates to:
  /// **'Numbers (0-9)'**
  String get numbersLabel;

  /// No description provided for @symbolsLabel.
  ///
  /// In en, this message translates to:
  /// **'Symbols (!@#\$)'**
  String get symbolsLabel;

  /// No description provided for @generateNew.
  ///
  /// In en, this message translates to:
  /// **'Generate New'**
  String get generateNew;

  /// No description provided for @copyPassword.
  ///
  /// In en, this message translates to:
  /// **'Copy Password'**
  String get copyPassword;

  /// No description provided for @excellentSecurity.
  ///
  /// In en, this message translates to:
  /// **'EXCELLENT SECURITY'**
  String get excellentSecurity;

  /// No description provided for @usernameEmailLabel.
  ///
  /// In en, this message translates to:
  /// **'USERNAME / EMAIL'**
  String get usernameEmailLabel;

  /// No description provided for @createdOnLabel.
  ///
  /// In en, this message translates to:
  /// **'CREATED ON'**
  String get createdOnLabel;

  /// No description provided for @lastModifiedLabel.
  ///
  /// In en, this message translates to:
  /// **'LAST MODIFIED'**
  String get lastModifiedLabel;

  /// No description provided for @launchWebsite.
  ///
  /// In en, this message translates to:
  /// **'Launch Website'**
  String get launchWebsite;

  /// No description provided for @enableBiometricLogin.
  ///
  /// In en, this message translates to:
  /// **'Enable Biometric Login'**
  String get enableBiometricLogin;

  /// No description provided for @headingEnableBiometrics.
  ///
  /// In en, this message translates to:
  /// **'Enable Biometrics'**
  String get headingEnableBiometrics;

  /// No description provided for @descEnableBiometrics.
  ///
  /// In en, this message translates to:
  /// **'Unlock your vault faster with fingerprint or FaceID'**
  String get descEnableBiometrics;

  /// No description provided for @privacyNotice.
  ///
  /// In en, this message translates to:
  /// **'Your biometric data stays on your device'**
  String get privacyNotice;

  /// No description provided for @enableNow.
  ///
  /// In en, this message translates to:
  /// **'Enable Now'**
  String get enableNow;

  /// No description provided for @skipForNow.
  ///
  /// In en, this message translates to:
  /// **'Skip for Now'**
  String get skipForNow;

  /// No description provided for @biometricNotSupported.
  ///
  /// In en, this message translates to:
  /// **'Your device does not support biometric authentication.'**
  String get biometricNotSupported;

  /// No description provided for @noBiometricsEnrolled.
  ///
  /// In en, this message translates to:
  /// **'No Biometrics Enrolled'**
  String get noBiometricsEnrolled;

  /// No description provided for @noBiometricsEnrolledDesc.
  ///
  /// In en, this message translates to:
  /// **'Please enroll a fingerprint or face in your device settings first, then try again.'**
  String get noBiometricsEnrolledDesc;

  /// No description provided for @confirmBiometricReason.
  ///
  /// In en, this message translates to:
  /// **'Confirm your biometric to enable quick unlock'**
  String get confirmBiometricReason;

  /// No description provided for @biometricAuthFailed.
  ///
  /// In en, this message translates to:
  /// **'Biometric authentication failed. Please try again.'**
  String get biometricAuthFailed;

  /// No description provided for @biometricSetupError.
  ///
  /// In en, this message translates to:
  /// **'An error occurred during biometric setup.'**
  String get biometricSetupError;

  /// No description provided for @masterPasswordSetupTitle.
  ///
  /// In en, this message translates to:
  /// **'Create Master Password'**
  String get masterPasswordSetupTitle;

  /// No description provided for @masterPasswordStepIndicator.
  ///
  /// In en, this message translates to:
  /// **'Step 1 of 2'**
  String get masterPasswordStepIndicator;

  /// No description provided for @masterPasswordLabel.
  ///
  /// In en, this message translates to:
  /// **'Create Password'**
  String get masterPasswordLabel;

  /// No description provided for @masterPasswordHint.
  ///
  /// In en, this message translates to:
  /// **'Enter your master password'**
  String get masterPasswordHint;

  /// No description provided for @showPassword.
  ///
  /// In en, this message translates to:
  /// **'Show password'**
  String get showPassword;

  /// No description provided for @hidePassword.
  ///
  /// In en, this message translates to:
  /// **'Hide password'**
  String get hidePassword;

  /// No description provided for @confirmPasswordLabel.
  ///
  /// In en, this message translates to:
  /// **'Confirm Password'**
  String get confirmPasswordLabel;

  /// No description provided for @confirmPasswordHint.
  ///
  /// In en, this message translates to:
  /// **'Repeat your master password'**
  String get confirmPasswordHint;

  /// No description provided for @passwordsMatchError.
  ///
  /// In en, this message translates to:
  /// **'Passwords don\'t match'**
  String get passwordsMatchError;

  /// No description provided for @masterPasswordSecurityTips.
  ///
  /// In en, this message translates to:
  /// **'Use 12+ characters, mix upper/lowercase, numbers, and symbols for a strong password.'**
  String get masterPasswordSecurityTips;

  /// No description provided for @continueToBiometrics.
  ///
  /// In en, this message translates to:
  /// **'Continue to biometric setup'**
  String get continueToBiometrics;

  /// No description provided for @continueDisabledFixErrors.
  ///
  /// In en, this message translates to:
  /// **'Continue button disabled, fix password errors first'**
  String get continueDisabledFixErrors;

  /// No description provided for @strength.
  ///
  /// In en, this message translates to:
  /// **'Strength'**
  String get strength;

  /// No description provided for @strengthVeryWeak.
  ///
  /// In en, this message translates to:
  /// **'Very weak'**
  String get strengthVeryWeak;

  /// No description provided for @strengthWeak.
  ///
  /// In en, this message translates to:
  /// **'Weak'**
  String get strengthWeak;

  /// No description provided for @strengthFair.
  ///
  /// In en, this message translates to:
  /// **'Fair'**
  String get strengthFair;

  /// No description provided for @strengthGood.
  ///
  /// In en, this message translates to:
  /// **'Good'**
  String get strengthGood;

  /// No description provided for @strengthStrong.
  ///
  /// In en, this message translates to:
  /// **'Strong'**
  String get strengthStrong;

  /// No description provided for @strengthVeryStrong.
  ///
  /// In en, this message translates to:
  /// **'Very strong'**
  String get strengthVeryStrong;

  /// No description provided for @english.
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get english;

  /// No description provided for @dangerZone.
  ///
  /// In en, this message translates to:
  /// **'Danger Zone'**
  String get dangerZone;

  /// No description provided for @logout.
  ///
  /// In en, this message translates to:
  /// **'Logout from PassVault'**
  String get logout;

  /// No description provided for @masterAccount.
  ///
  /// In en, this message translates to:
  /// **'Master Account'**
  String get masterAccount;

  /// No description provided for @lastSyncedMock.
  ///
  /// In en, this message translates to:
  /// **'Last synched: 2 mins ago'**
  String get lastSyncedMock;

  /// No description provided for @tapToAuthenticate.
  ///
  /// In en, this message translates to:
  /// **'Tap to Authenticate'**
  String get tapToAuthenticate;

  /// No description provided for @unlockVaultTitle.
  ///
  /// In en, this message translates to:
  /// **'Unlock Your Vault'**
  String get unlockVaultTitle;

  /// No description provided for @biometricAuthRequired.
  ///
  /// In en, this message translates to:
  /// **'Biometric authentication is required to access your passwords.'**
  String get biometricAuthRequired;

  /// No description provided for @searchPasswords.
  ///
  /// In en, this message translates to:
  /// **'Search passwords...'**
  String get searchPasswords;

  /// No description provided for @searchPasswordsSemantics.
  ///
  /// In en, this message translates to:
  /// **'Search passwords'**
  String get searchPasswordsSemantics;

  /// No description provided for @clearSearch.
  ///
  /// In en, this message translates to:
  /// **'Clear search'**
  String get clearSearch;

  /// No description provided for @searchYourVault.
  ///
  /// In en, this message translates to:
  /// **'Search your vault'**
  String get searchYourVault;

  /// No description provided for @vault.
  ///
  /// In en, this message translates to:
  /// **'Vault'**
  String get vault;

  /// No description provided for @generator.
  ///
  /// In en, this message translates to:
  /// **'Generator'**
  String get generator;

  /// No description provided for @language.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get language;

  /// No description provided for @filterAll.
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get filterAll;

  /// No description provided for @filterFavorites.
  ///
  /// In en, this message translates to:
  /// **'Favorites'**
  String get filterFavorites;

  /// No description provided for @filterWork.
  ///
  /// In en, this message translates to:
  /// **'Work'**
  String get filterWork;

  /// No description provided for @filterSocial.
  ///
  /// In en, this message translates to:
  /// **'Social'**
  String get filterSocial;

  /// No description provided for @filterPersonal.
  ///
  /// In en, this message translates to:
  /// **'Personal'**
  String get filterPersonal;

  /// No description provided for @optionIcon.
  ///
  /// In en, this message translates to:
  /// **'Option icon'**
  String get optionIcon;

  /// No description provided for @loading.
  ///
  /// In en, this message translates to:
  /// **'Loading'**
  String get loading;

  /// No description provided for @tabSemanticsLabel.
  ///
  /// In en, this message translates to:
  /// **'{label} tab'**
  String tabSemanticsLabel(String label);

  /// No description provided for @loadingPasswords.
  ///
  /// In en, this message translates to:
  /// **'Loading passwords'**
  String get loadingPasswords;

  /// No description provided for @filterChipSemantics.
  ///
  /// In en, this message translates to:
  /// **'Filter by {label}'**
  String filterChipSemantics(String label);

  /// No description provided for @filterChipSelectedSemantics.
  ///
  /// In en, this message translates to:
  /// **'Filter by {label}, selected'**
  String filterChipSelectedSemantics(String label);

  /// No description provided for @radioButtonSemanticsPrefix.
  ///
  /// In en, this message translates to:
  /// **'Radio button'**
  String get radioButtonSemanticsPrefix;

  /// No description provided for @selectedState.
  ///
  /// In en, this message translates to:
  /// **'selected'**
  String get selectedState;

  /// No description provided for @notSelectedState.
  ///
  /// In en, this message translates to:
  /// **'not selected'**
  String get notSelectedState;

  /// No description provided for @serviceNameLabel.
  ///
  /// In en, this message translates to:
  /// **'Service Name'**
  String get serviceNameLabel;

  /// No description provided for @enterServiceName.
  ///
  /// In en, this message translates to:
  /// **'Enter service name'**
  String get enterServiceName;

  /// No description provided for @enterUsername.
  ///
  /// In en, this message translates to:
  /// **'Enter username'**
  String get enterUsername;

  /// No description provided for @enterPasswordValidator.
  ///
  /// In en, this message translates to:
  /// **'Enter password'**
  String get enterPasswordValidator;

  /// No description provided for @savePassword.
  ///
  /// In en, this message translates to:
  /// **'Save Password'**
  String get savePassword;

  /// No description provided for @updatePassword.
  ///
  /// In en, this message translates to:
  /// **'Update Password'**
  String get updatePassword;
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
