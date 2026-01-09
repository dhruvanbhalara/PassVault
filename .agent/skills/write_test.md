---
description: How to write comprehensive tests in PassVault
---

# Write Test Skill

This skill outlines the standards for writing Unit and Widget tests in `PassVault`.

## 1. The Mirror Rule
The `test` directory MUST exactly mirror the `lib` directory structure.
*   `lib/features/auth/presentation/auth_screen.dart` -> `test/features/auth/presentation/auth_screen_test.dart`

## 2. Unit Testing (Logic)
Used for: UseCases, Repositories, Blocs, Entities.

### Setup
*   **Mocktail**: Use `mocktail` for mocking dependencies.
*   **SetUp**: Initialize mocks and the System Under Test (SUT) in `setUp()`.
*   **TearDown**: Dispose resources in `tearDown()`.

### Pattern
```dart
test('Should [return success] when [repository call succeeds]', () async {
  // Arrange
  when(() => mockRepo.getData()).thenAnswer((_) async => Right(data));

  // Act
  final result = await useCase();

  // Assert
  expect(result, Right(data));
  verify(() => mockRepo.getData()).called(1);
});
```

## 3. Widget Testing (UI)
Used for: Screens, Dialogs, Atomic Components.

### Setup
*   **PumpApp**: Wrap the widget in `MaterialApp` with specific theme/localization if needed.
*   **Finder**: Use `find.byType`, `find.byKey`, or `find.text`.

### Pattern
```dart
testWidgets('Should [render loading state] when [bloc emits Loading]', (tester) async {
  // Arrange
  when(() => mockBloc.state).thenReturn(LoadingState());

  // Act
  await tester.pumpWidget(MaterialApp(home: MyScreen()));

  // Assert
  expect(find.byType(AppLoader), findsOneWidget);
});
```

## 4. Checklist
- [ ] Test file location mirrors source file.
- [ ] Mocks are reset in `setUp`.
- [ ] Test description clearly states "Should... when...".
- [ ] All code paths (Success, Failure, Loading) are covered.
