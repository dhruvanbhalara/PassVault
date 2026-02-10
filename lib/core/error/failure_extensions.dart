import 'package:passvault/core/error/failures.dart';
import 'package:passvault/l10n/app_localizations.dart';

/// Extension to map domain [Failure] objects to localized UI strings.
extension FailureLocalization on Failure {
  /// Returns a localized description of the failure.
  String toLocalizedString(AppLocalizations l10n) {
    return switch (this) {
      DatabaseFailure() => l10n.databaseError,
      AuthFailure() => l10n.authError,
      SecurityFailure() => l10n.securityError,
      FileReadFailure() => l10n.fileReadError,
      InvalidFormatFailure() => l10n.invalidFormatError,
      ParsingFailure() => l10n.parsingError,
      NoDataFoundFailure() => l10n.noDataFound,
      DataMigrationFailure() => l10n.migrationError,
      UnknownFailure() => message,
    };
  }
}
