/// Centralized route constants for the application.
abstract class AppRoutes {
  // Root Routes
  static const String intro = '/intro';
  static const String auth = '/auth';

  // Shell Branches
  static const String home = '/home';
  static const String generator = '/generator';
  static const String settings = '/settings';

  // Sub-routes (Relative Paths)
  static const String addPasswordRoute = 'add-password';
  static const String editPasswordRoute = 'edit-password';
  static const String groupedPasswordDetailsRoute = 'group';
  static const String groupedPasswordKeyParam = 'groupKey';
  static const String groupedPasswordDetailsSubRoute =
      '$groupedPasswordDetailsRoute/:$groupedPasswordKeyParam';
  static const String exportVaultRoute = 'export';
  static const String strategyRoute = 'strategy';
  static const String strategyEditorRoute = 'strategy-editor';

  // Full Paths (for Navigation)
  static const String addPassword = '$home/$addPasswordRoute';
  static const String editPassword = '$home/$editPasswordRoute';
  static String groupedPasswordDetailsPath(String groupKey) =>
      '$home/$groupedPasswordDetailsRoute/${Uri.encodeComponent(groupKey)}';
  static const String exportVault = '$settings/$exportVaultRoute';
  static const String strategy = '$settings/$strategyRoute';
  static const String strategyEditor =
      '$settings/$strategyRoute/$strategyEditorRoute';
  static const String resolveDuplicates = '/resolve-duplicates';
}
