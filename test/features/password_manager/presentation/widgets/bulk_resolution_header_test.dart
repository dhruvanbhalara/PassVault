import 'package:passvault/features/password_manager/domain/entities/duplicate_resolution_choice.dart';
import 'package:passvault/features/password_manager/presentation/widgets/bulk_resolution_header.dart';

import '../../../../helpers/test_helpers.dart';

class MockOnChoiceChanged extends Mock {
  void call(DuplicateResolutionChoice choice);
}

void main() {
  group('$BulkResolutionHeader', () {
    testWidgets('calls onChoiceSelected for each bulk action', (tester) async {
      final l10n = await getL10n();
      final onChoiceSelected = MockOnChoiceChanged();
      await tester.pumpApp(
        BulkResolutionHeader(onChoiceSelected: onChoiceSelected.call),
      );

      await tester.tap(find.text(l10n.keepAllExisting));
      verify(
        () => onChoiceSelected.call(DuplicateResolutionChoice.keepExisting),
      ).called(1);

      await tester.tap(find.text(l10n.replaceAll));
      verify(
        () => onChoiceSelected.call(DuplicateResolutionChoice.replaceWithNew),
      ).called(1);

      await tester.tap(find.text(l10n.keepAllBothAction));
      verify(
        () => onChoiceSelected.call(DuplicateResolutionChoice.keepBoth),
      ).called(1);
    });
  });
}
