import 'package:passvault/features/password_manager/presentation/bloc/add_edit_password/add_edit_password_error_codes.dart';

import '../../../../../helpers/test_helpers.dart';

void main() {
  late AppLocalizations l10n;

  setUpAll(() async {
    l10n = await getL10n();
  });

  group('$AddEditPasswordErrorCodes', () {
    test('entryNotFound constant has expected value', () {
      expect(AddEditPasswordErrorCodes.entryNotFound, 'entry_not_found');
    });

    group('localizedMessage', () {
      test('returns localized string for entryNotFound code', () {
        final result = AddEditPasswordErrorCodes.localizedMessage(
          AddEditPasswordErrorCodes.entryNotFound,
          l10n,
        );

        expect(result, l10n.entryNotFound);
      });

      test('returns raw error code for unknown codes', () {
        final result = AddEditPasswordErrorCodes.localizedMessage(
          'unknown_error_code',
          l10n,
        );

        expect(result, 'unknown_error_code');
      });
    });
  });
}
