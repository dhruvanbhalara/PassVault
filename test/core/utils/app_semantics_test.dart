import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:passvault/core/utils/app_semantics.dart';

void main() {
  group('$AppSemantics', () {
    testWidgets('button wrapper renders child widget', (
      WidgetTester tester,
    ) async {
      // When
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: AppSemantics.button(
              label: 'Save',
              child: const ElevatedButton(onPressed: null, child: Text('Save')),
            ),
          ),
        ),
      );

      // Then
      expect(find.text('Save'), findsOneWidget);
      expect(find.byType(ElevatedButton), findsOneWidget);
    });

    testWidgets('header wrapper renders child widget', (
      WidgetTester tester,
    ) async {
      // When
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: AppSemantics.header(
              label: 'Security',
              child: const Text('Security'),
            ),
          ),
        ),
      );

      // Then
      expect(find.text('Security'), findsOneWidget);
    });

    testWidgets('listItem wrapper renders child widget', (
      WidgetTester tester,
    ) async {
      // When
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: AppSemantics.listItem(
              label: 'Password entry',
              child: const ListTile(title: Text('example.com')),
            ),
          ),
        ),
      );

      // Then
      expect(find.text('example.com'), findsOneWidget);
      expect(find.byType(ListTile), findsOneWidget);
    });

    testWidgets('input wrapper renders child widget', (
      WidgetTester tester,
    ) async {
      // When
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: AppSemantics.input(
              label: 'Password',
              child: const TextField(),
            ),
          ),
        ),
      );

      // Then
      expect(find.byType(TextField), findsOneWidget);
    });

    testWidgets('loading wrapper renders child widget', (
      WidgetTester tester,
    ) async {
      // When
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: AppSemantics.loading(
              child: const CircularProgressIndicator(),
            ),
          ),
        ),
      );

      // Then
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets('image wrapper renders child widget', (
      WidgetTester tester,
    ) async {
      // When
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: AppSemantics.image(
              label: 'Icon',
              child: const Icon(Icons.security),
            ),
          ),
        ),
      );

      // Then
      expect(find.byType(Icon), findsOneWidget);
    });

    testWidgets('link wrapper renders child widget', (
      WidgetTester tester,
    ) async {
      // When
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: AppSemantics.link(
              label: 'Privacy',
              child: const Text('Privacy'),
            ),
          ),
        ),
      );

      // Then
      expect(find.text('Privacy'), findsOneWidget);
    });

    testWidgets('announce does not throw exception', (
      WidgetTester tester,
    ) async {
      // When
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Builder(
              builder: (context) {
                return ElevatedButton(
                  onPressed: () =>
                      AppSemantics.announce(context, 'Test message'),
                  child: const Text('Announce'),
                );
              },
            ),
          ),
        ),
      );

      // Then - tapping should not throw
      await tester.tap(find.text('Announce'));
      await tester.pumpAndSettle();
      expect(find.text('Announce'), findsOneWidget);
    });
  });
}
