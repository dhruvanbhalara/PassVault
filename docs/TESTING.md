# Testing

## Overview

**135 tests** covering unit, BLoC, and widget layers.

```bash
# Run all tests
flutter test

# Run with coverage
flutter test --coverage
```

## Test Structure

Test structure mirrors `lib/`:

```
test/
├── core/
│   └── services/               # CryptoService, EncryptedStorageService tests
├── features/
│   ├── auth/presentation/
│   │   ├── bloc/               # AuthBloc tests
│   │   └── screens/            # AuthScreen widget tests
│   ├── home/presentation/      # HomeScreen tests
│   ├── onboarding/presentation/
│   │   ├── bloc/               # OnboardingBloc tests
│   │   └── screens/            # IntroScreen tests
│   ├── password_manager/
│   │   ├── domain/             # UseCase, Entity tests
│   │   └── presentation/       # AddEditPasswordBloc tests
│   └── settings/
│       ├── domain/             # PasswordGenerationSettings tests
│       └── presentation/
│           ├── bloc/           # SettingsBloc tests
│           └── screens/        # SettingsScreen tests
```

## Test Categories

| Category | Count | Description |
|----------|-------|-------------|
| Unit | ~40 | UseCases, Entities, Services |
| BLoC | ~20 | State management logic |
| Widget | ~75 | Screen and component rendering |

## Testing Patterns

### BLoC Tests (bloc_test)

```dart
blocTest<SettingsBloc, SettingsState>(
  'emits success when export succeeds',
  build: () => bloc,
  act: (bloc) => bloc.add(ExportData(isJson: true)),
  expect: () => [
    isA<SettingsState>().having((s) => s.status, 'status', SettingsStatus.loading),
    isA<SettingsState>().having((s) => s.status, 'status', SettingsStatus.success),
  ],
);
```

### Security Tests

```dart
test('encrypts and decrypts correctly', () {
  final encrypted = cryptoService.encrypt(data, password);
  final decrypted = cryptoService.decrypt(encrypted, password);
  expect(decrypted, equals(data));
});
```

### Mocking (mocktail)

```dart
class MockPasswordRepository extends Mock implements PasswordRepository {}

when(() => mockRepo.getPasswords()).thenAnswer((_) async => [testEntry]);
```

## Code Coverage

Generate coverage report:

```bash
flutter test --coverage
genhtml coverage/lcov.info -o coverage/html
open coverage/html/index.html
```
