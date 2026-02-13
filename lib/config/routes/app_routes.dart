/// Centralized route constants for the application.
abstract class AppRoutes {
  static const String intro = '/intro';

  static const String auth = '/auth';

  static const String home = '/home';
  static const String generator = '/generator';
  static const String settings = '/settings';

  static const String addPassword = '/home/add-password';
  static const String editPassword = '/home/edit-password';
  static const String exportVault = '/settings/export';
  static const String passwordGeneration = '/settings/password-generation';

  static const String addPasswordRoute = 'add-password';
  static const String editPasswordRoute = 'edit-password';
  static const String exportVaultRoute = 'export';
  static const String passwordGenerationRoute = 'password-generation';

  static const String resolveDuplicates = '/resolve-duplicates';
}
