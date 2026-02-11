import 'package:passvault/features/password_manager/presentation/widgets/password_strength_indicator.dart';

import '../../../../helpers/test_helpers.dart';

void main() {
  group('$PasswordStrengthIndicator', () {
    testWidgets('shows correct percentage text', (tester) async {
      await tester.pumpApp(const PasswordStrengthIndicator(strength: 0.75));

      expect(find.text('75%'), findsOneWidget);
    });

    testWidgets('shows LinearProgressIndicator', (tester) async {
      await tester.pumpApp(const PasswordStrengthIndicator(strength: 0.5));

      final progressFinder = find.byType(LinearProgressIndicator);
      expect(progressFinder, findsOneWidget);
      final progress = tester.widget<LinearProgressIndicator>(progressFinder);
      expect(progress.value, 0.5);
    });
  });
}
