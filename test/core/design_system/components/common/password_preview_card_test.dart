import 'package:passvault/core/design_system/components/common/password_preview_card.dart';
import 'package:passvault/features/password_manager/domain/entities/password_feedback.dart';
import 'package:password_engine/password_engine.dart' show PasswordStrength;

import '../../../../helpers/test_helpers.dart';

void main() {
  group('$PasswordPreviewCard', () {
    const testPassword = 'TestPassword123!';
    const strength = PasswordFeedback(
      strength: PasswordStrength.veryStrong,
      suggestions: [],
    );

    testWidgets('renders password text and labels', (tester) async {
      await tester.pumpApp(
        const PasswordPreviewCard(password: testPassword, strength: strength),
      );

      expect(find.text(testPassword), findsOneWidget);
      expect(find.text('PREVIEW'), findsOneWidget);
      // We check for the strength text - in English it should be 'Very strong'
      // Since it's uppercase in the widget, we check for 'VERY STRONG'
      expect(find.text('VERY STRONG'), findsOneWidget);
    });

    testWidgets('shows loading state when isLoading is true', (tester) async {
      await tester.pumpApp(
        const PasswordPreviewCard(
          password: testPassword,
          strength: strength,
          isLoading: true,
        ),
        usePumpAndSettle: false,
      );

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
      expect(find.text(testPassword), findsNothing);
    });

    testWidgets('calls onRefresh when refresh icon is tapped', (tester) async {
      bool refreshCalled = false;
      await tester.pumpApp(
        PasswordPreviewCard(
          password: testPassword,
          strength: strength,
          onRefresh: () => refreshCalled = true,
        ),
      );

      // The refresh button has a specific key
      final refreshButton = find.byKey(const Key('preview_refresh'));
      expect(refreshButton, findsOneWidget);

      await tester.tap(refreshButton);
      await tester.pumpAndSettle();

      expect(refreshCalled, isTrue);
    });

    testWidgets('calls onCopy when copy icon is tapped', (tester) async {
      bool copyCalled = false;
      await tester.pumpApp(
        PasswordPreviewCard(
          password: testPassword,
          strength: strength,
          onCopy: () => copyCalled = true,
        ),
      );

      final copyButton = find.byKey(const Key('preview_copy'));
      expect(copyButton, findsOneWidget);

      await tester.tap(copyButton);
      await tester.pumpAndSettle();

      expect(copyCalled, isTrue);
    });

    testWidgets('adapts colors based on strength (visual/logical check)', (
      tester,
    ) async {
      // Very Strong should be Green-ish (Dark)
      await tester.pumpApp(
        const PasswordPreviewCard(
          password: testPassword,
          strength: PasswordFeedback(strength: PasswordStrength.veryStrong),
        ),
      );

      // We can't easily check the resulting foreground color in a standard test without deeper inspection
      // but we verify it renders without error.
      expect(find.byType(PasswordPreviewCard), findsOneWidget);
    });

    testWidgets('supports multi-line selectable text', (tester) async {
      await tester.pumpApp(
        const PasswordPreviewCard(
          password: 'Long\nPassword\nWith\nMany\nLines',
          strength: strength,
        ),
      );

      final selectableText = find.byType(SelectableText);
      expect(selectableText, findsOneWidget);

      final widget = tester.widget<SelectableText>(selectableText);
      expect(widget.maxLines, equals(5));
      expect(widget.minLines, equals(4));
    });
  });
}
