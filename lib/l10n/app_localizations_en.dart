// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appName => 'PassVault';

  @override
  String get locked => 'Locked';

  @override
  String get unlockWithBiometrics => 'Unlock with Biometrics';

  @override
  String get settings => 'Settings';

  @override
  String get home => 'Home';

  @override
  String get addPassword => 'Add Password';

  @override
  String get editPassword => 'Edit Password';

  @override
  String get noPasswords => 'No passwords yet.\nTap + to add one.';

  @override
  String get passwordCopied => 'Password copied to clipboard';

  @override
  String get delete => 'Delete';

  @override
  String get appearance => 'Appearance';

  @override
  String get theme => 'Theme';

  @override
  String get system => 'System Default';

  @override
  String get light => 'Light';

  @override
  String get dark => 'Dark';

  @override
  String get amoled => 'AMOLED (Pure Black)';

  @override
  String get security => 'Security';

  @override
  String get useBiometrics => 'Biometric Authentication';

  @override
  String get dataManagement => 'Data Management';

  @override
  String get exportData => 'Export Data (JSON/CSV)';

  @override
  String get importData => 'Import Data';

  @override
  String get save => 'Save';

  @override
  String get cancel => 'Cancel';

  @override
  String get appNameLabel => 'App Name';

  @override
  String get usernameLabel => 'Username';

  @override
  String get passwordLabel => 'Password';

  @override
  String get errorOccurred => 'An error occurred';

  @override
  String get success => 'Success';

  @override
  String get exportSuccess => 'Data exported successfully';

  @override
  String get importSuccess => 'Data imported successfully';

  @override
  String get biometricsNotSetup => 'Biometrics not set up or not available.';

  @override
  String get enterAppWithoutBiometrics => 'Enter without Biometrics';

  @override
  String get exportJson => 'Export as JSON';

  @override
  String get exportCsv => 'Export as CSV';

  @override
  String get importJson => 'Import from JSON';

  @override
  String get importCsv => 'Import from CSV';

  @override
  String get onboardingTitle1 => 'Secure Storage';

  @override
  String get onboardingDesc1 =>
      'Your passwords are stored locally on your device, encrypted with strong AES-256 encryption. No data ever leaves your phone.';

  @override
  String get onboardingTitle2 => 'Offline First';

  @override
  String get onboardingDesc2 =>
      'Access your credentials anywhere, anytime, without an internet connection. Total control, total privacy.';

  @override
  String get onboardingTitle3 => 'Biometric Access';

  @override
  String get onboardingDesc3 =>
      'Unlock your vault with a touch or a glance. Seamless security integrated with your device\'s biometric authentication.';

  @override
  String get skip => 'Skip';

  @override
  String get next => 'Next';

  @override
  String get done => 'Done';

  @override
  String get generate => 'Generate';

  @override
  String get authFailed => 'Authentication failed';

  @override
  String get biometricsNotAvailable => 'Biometrics not available';

  @override
  String get noDataToExport => 'No password data to export';

  @override
  String get importFailed => 'Failed to import data';

  @override
  String get passwordGeneration => 'Password Generation';

  @override
  String get passwordLength => 'Password Length';

  @override
  String get uppercase => 'Uppercase';

  @override
  String get lowercase => 'Lowercase';

  @override
  String get numbers => 'Numbers';

  @override
  String get specialCharacters => 'Special Characters';

  @override
  String get characters => 'Characters';

  @override
  String get excludeAmbiguous => 'Exclude Ambiguous';

  @override
  String get excludeAmbiguousHint => 'I, l, 1, O, 0';

  @override
  String get characterSets => 'Character Sets';

  @override
  String get preview => 'Preview';

  @override
  String get refreshPreview => 'Refresh Preview';

  @override
  String get jsonBackupFormat => 'Structured format for backups';

  @override
  String get csvSpreadsheetFormat => 'Spreadsheet compatible format';

  @override
  String get importFromJsonBackup => 'Import from JSON backup';

  @override
  String get importFromSpreadsheet => 'Import from spreadsheet';

  @override
  String get options => 'Options';

  @override
  String get hintAppName => 'e.g. Netflix, Github';

  @override
  String get hintUsername => 'e.g. john.doe@email.com';

  @override
  String get hintPassword => '••••••••••••';

  @override
  String get uppercaseHint => 'A-Z';

  @override
  String get lowercaseHint => 'a-z';

  @override
  String get numbersHint => '0-9';

  @override
  String get specialCharsHint => '!@#\$%^&*';

  @override
  String get wrongPassword => 'Incorrect password. Please try again.';

  @override
  String get exportEncrypted => 'Export Encrypted (.pvault)';

  @override
  String get encryptedPasswordProtected => 'Password-protected secure backup';

  @override
  String get importEncrypted => 'Import from Encrypted (.pvault)';

  @override
  String get importFromEncryptedBackup => 'Import password-protected backup';

  @override
  String get enterExportPassword => 'Enter a password to protect your backup';

  @override
  String get enterImportPassword => 'Enter the backup password';

  @override
  String get passwordRequired => 'Password is required';

  @override
  String get export => 'Export';

  @override
  String get import => 'Import';

  @override
  String get processing => 'Processing...';

  @override
  String get databaseCleared => 'Database cleared successfully';

  @override
  String get fileNotFound => 'File not found';

  @override
  String get clearDatabase => 'Clear Database';

  @override
  String get debugDeleteAllPasswords => 'Debug: Delete all passwords';

  @override
  String get clearDatabaseTitle => 'Clear Database?';

  @override
  String get clearDatabaseMessage =>
      'This will permanently delete ALL passwords from the database. This action cannot be undone.\\n\\nThis is a DEBUG feature for testing.';

  @override
  String get clearAll => 'Clear All';
}
