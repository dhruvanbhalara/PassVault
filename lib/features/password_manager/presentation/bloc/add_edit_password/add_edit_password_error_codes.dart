import 'package:passvault/core/design_system/theme/theme.dart';

class AddEditPasswordErrorCodes {
  const AddEditPasswordErrorCodes._();

  static const String entryNotFound = 'entry_not_found';

  /// Maps an error code to a localized user-facing message.
  static String localizedMessage(String errorCode, AppLocalizations l10n) {
    return switch (errorCode) {
      entryNotFound => l10n.entryNotFound,
      _ => errorCode,
    };
  }
}
