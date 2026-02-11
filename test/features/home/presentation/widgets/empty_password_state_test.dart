import 'package:passvault/features/home/presentation/widgets/empty_password_state.dart';

import '../../../../helpers/test_helpers.dart';

void main() {
  group('$EmptyPasswordState', () {
    testWidgets('renders empty message', (tester) async {
      final l10n = await getL10n();

      await tester.pumpApp(const EmptyPasswordState());

      expect(find.text(l10n.noPasswords), findsOneWidget);
    });
  });
}
