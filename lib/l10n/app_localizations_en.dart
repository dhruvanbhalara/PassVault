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
  String get apply => 'Apply';

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
  String get databaseError => 'Database error occurred';

  @override
  String get authError => 'Authentication error';

  @override
  String get securityError => 'Security violation or error';

  @override
  String get migrationError => 'Data migration failed';

  @override
  String get fileReadError => 'Could not read the file';

  @override
  String get invalidFormatError => 'Invalid file format';

  @override
  String get parsingError => 'Error parsing file content';

  @override
  String get noDataFound => 'No valid data found';

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

  @override
  String get resolveDuplicatesTitle => 'Resolve Duplicates';

  @override
  String resolveRemainingDuplicates(int count) {
    return 'Please resolve all $count remaining duplicates';
  }

  @override
  String resolveCountDuplicates(int count) {
    return 'Resolve $count Duplicates';
  }

  @override
  String duplicatesFoundCount(int count) {
    return '$count duplicate(s) found';
  }

  @override
  String get chooseResolutionAction => 'Choose action:';

  @override
  String get keepExistingTitle => 'Keep Existing';

  @override
  String get keepExistingSubtitle => 'Ignore imported entry';

  @override
  String get replaceWithNewTitle => 'Replace with New';

  @override
  String get replaceWithNewSubtitle => 'Update with imported data';

  @override
  String get keepBothTitle => 'Keep Both';

  @override
  String get keepBothSubtitle => 'Save both entries';

  @override
  String get bulkActionsTitle => 'Bulk Actions';

  @override
  String get bulkActionsSubtitle =>
      'Apply a single decision to all remaining conflicts:';

  @override
  String get keepAllExisting => 'Keep All Existing';

  @override
  String get replaceAll => 'Replace All';

  @override
  String get keepAllBothAction => 'Keep All Both';

  @override
  String get noStrategiesFound => 'No strategies found.';

  @override
  String get newStrategy => 'New Strategy';

  @override
  String get editStrategy => 'Edit Strategy';

  @override
  String get setAsDefault => 'Set as Default';

  @override
  String get generationStrategy => 'Generation Strategy';

  @override
  String get strategyName => 'Strategy Name';

  @override
  String get hintStrategyName => 'e.g. High Security, PIN';

  @override
  String get minLabel => '16';

  @override
  String get maxLabel => '64';

  @override
  String get passwordGenerationSubtitle =>
      'Manage your custom presets used for generating secure passwords.';

  @override
  String get noStrategiesDescription =>
      'Create your first strategy to get started.';

  @override
  String get onboardingTitle4 => 'Smart Strategies';

  @override
  String get onboardingDesc4 =>
      'Create custom password presets for different needs. PINs, high-security phrases, or legacy formats—managed your way.';

  @override
  String get activeDefaultLabel => 'Active Strategy';

  @override
  String get activeConfiguration => 'Active Configuration';

  @override
  String get savedStrategies => 'Saved Strategies';

  @override
  String get exportVault => 'Export Vault';

  @override
  String get entryDetails => 'Entry Details';

  @override
  String get resolveConflicts => 'Resolve Conflicts';

  @override
  String get resolveConflictsDesc => 'Please resolve all remaining duplicates';

  @override
  String get exportFormat => 'EXPORT FORMAT';

  @override
  String get jsonRecommended => 'JSON (Recommended)';

  @override
  String get jsonDesc => 'Structured data, easy to import back.';

  @override
  String get csvSpreadsheet => 'CSV Spreadsheet';

  @override
  String get csvDesc => 'Viewable in Excel or Google Sheets.';

  @override
  String get encryptWithPassword => 'Encrypt with Password';

  @override
  String get encryptDesc => 'Highly recommended for security.';

  @override
  String get encryptionPassword => 'Encryption Password';

  @override
  String get exportNow => 'Export Now';

  @override
  String get warningSensitiveData =>
      'Exported files contain your sensitive data. Keep them secure or delete them after use.';

  @override
  String get passwordGenerator => 'Password Generator';

  @override
  String get lengthLabel => 'LENGTH';

  @override
  String get uppercaseLabel => 'Uppercase (A-Z)';

  @override
  String get lowercaseLabel => 'Lowercase (a-z)';

  @override
  String get numbersLabel => 'Numbers (0-9)';

  @override
  String get symbolsLabel => 'Symbols (!@#\$)';

  @override
  String get generateNew => 'Generate New';

  @override
  String get copyPassword => 'Copy Password';

  @override
  String get excellentSecurity => 'EXCELLENT SECURITY';

  @override
  String get usernameEmailLabel => 'USERNAME / EMAIL';

  @override
  String get createdOnLabel => 'CREATED ON';

  @override
  String get lastModifiedLabel => 'LAST MODIFIED';

  @override
  String get launchWebsite => 'Launch Website';

  @override
  String get enableBiometricLogin => 'Enable Biometric Login';

  @override
  String get headingEnableBiometrics => 'Enable Biometrics';

  @override
  String get descEnableBiometrics =>
      'Unlock your vault faster with fingerprint or FaceID';

  @override
  String get privacyNotice => 'Your biometric data stays on your device';

  @override
  String get enableNow => 'Enable Now';

  @override
  String get skipForNow => 'Skip for Now';

  @override
  String get biometricNotSupported =>
      'Your device does not support biometric authentication.';

  @override
  String get noBiometricsEnrolled => 'No Biometrics Enrolled';

  @override
  String get noBiometricsEnrolledDesc =>
      'Please enroll a fingerprint or face in your device settings first, then try again.';

  @override
  String get confirmBiometricReason =>
      'Confirm your biometric to enable quick unlock';

  @override
  String get biometricAuthFailed =>
      'Biometric authentication failed. Please try again.';

  @override
  String get biometricSetupError => 'An error occurred during biometric setup.';

  @override
  String get masterPasswordSetupTitle => 'Create Master Password';

  @override
  String get masterPasswordStepIndicator => 'Step 1 of 2';

  @override
  String get masterPasswordLabel => 'Create Password';

  @override
  String get masterPasswordHint => 'Enter your master password';

  @override
  String get showPassword => 'Show password';

  @override
  String get hidePassword => 'Hide password';

  @override
  String get confirmPasswordLabel => 'Confirm Password';

  @override
  String get confirmPasswordHint => 'Repeat your master password';

  @override
  String get passwordsMatchError => 'Passwords don\'t match';

  @override
  String get masterPasswordSecurityTips =>
      'Use 12+ characters, mix upper/lowercase, numbers, and symbols for a strong password.';

  @override
  String get continueToBiometrics => 'Continue to biometric setup';

  @override
  String get continueDisabledFixErrors =>
      'Continue button disabled, fix password errors first';

  @override
  String get strengthVeryWeak => 'Very weak';

  @override
  String get strengthWeak => 'Weak';

  @override
  String get strengthFair => 'Fair';

  @override
  String get strengthGood => 'Good';

  @override
  String get strengthStrong => 'Strong';

  @override
  String get strengthVeryStrong => 'Very strong';

  @override
  String get english => 'English';

  @override
  String get dangerZone => 'Danger Zone';

  @override
  String get logout => 'Logout from PassVault';

  @override
  String get masterAccount => 'Master Account';

  @override
  String get lastSyncedMock => 'Last synched: 2 mins ago';

  @override
  String get tapToAuthenticate => 'Tap to Authenticate';

  @override
  String get unlockVaultTitle => 'Unlock Your Vault';

  @override
  String get biometricAuthRequired =>
      'Biometric authentication is required to access your passwords.';

  @override
  String get searchPasswords => 'Search passwords...';

  @override
  String get searchPasswordsSemantics => 'Search passwords';

  @override
  String get clearSearch => 'Clear search';

  @override
  String get searchYourVault => 'Search your vault';

  @override
  String get vault => 'Vault';

  @override
  String get generator => 'Generator';

  @override
  String get language => 'Language';

  @override
  String get filterAll => 'All';

  @override
  String get filterFavorites => 'Favorites';

  @override
  String get filterWork => 'Work';

  @override
  String get filterSocial => 'Social';

  @override
  String get filterPersonal => 'Personal';

  @override
  String get optionIcon => 'Option icon';

  @override
  String get loading => 'Loading';

  @override
  String tabSemanticsLabel(String label) {
    return '$label tab';
  }

  @override
  String get loadingPasswords => 'Loading passwords';

  @override
  String filterChipSemantics(String label) {
    return 'Filter by $label';
  }

  @override
  String filterChipSelectedSemantics(String label) {
    return 'Filter by $label, selected';
  }

  @override
  String get radioButtonSemanticsPrefix => 'Radio button';

  @override
  String get selectedState => 'selected';

  @override
  String get notSelectedState => 'not selected';

  @override
  String get serviceNameLabel => 'Service Name';

  @override
  String get enterServiceName => 'Enter service name';

  @override
  String get enterUsername => 'Enter username';

  @override
  String get enterPasswordValidator => 'Enter password';

  @override
  String get savePassword => 'Save Password';

  @override
  String get updatePassword => 'Update Password';
}
