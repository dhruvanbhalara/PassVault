import 'package:passvault/features/password_manager/domain/entities/duplicate_resolution_choice.dart';
import 'package:passvault/features/password_manager/presentation/widgets/resolution_choice_buttons.dart';

import '../../../../helpers/test_helpers.dart';

class MockOnChoiceChanged extends Mock {
  void call(DuplicateResolutionChoice choice);
}

void main() {
  group('$ResolutionChoiceButtons', () {
    testWidgets('renders all options', (tester) async {
      final l10n = await getL10n();
      final onChoiceChanged = MockOnChoiceChanged();

      await tester.pumpApp(
        ResolutionChoiceButtons(
          selectedChoice: DuplicateResolutionChoice.keepExisting,
          onChoiceChanged: onChoiceChanged.call,
        ),
      );

      expect(find.text(l10n.keepExistingTitle), findsOneWidget);
      expect(find.text(l10n.replaceWithNewTitle), findsOneWidget);
      expect(find.text(l10n.keepBothTitle), findsOneWidget);
    });
  });
}
