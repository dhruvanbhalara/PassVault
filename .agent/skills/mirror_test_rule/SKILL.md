---
name: mirror_test_rule
description: Enforce the "Mirror Test Rule" for 100% logic layer coverage.
---

# Mirror Test Rule Skill

This skill enforces the "Mirror Test Rule" and Quality Assurance standards from `flutter_rules.md`.

## Core Requirements

1.  **Mirror Test Rule**: 
    -   **Logic**: 100% file coverage for logic layers (`domain`, `data`, `presentation/bloc`).
    -   **Widgets**: Every extracted widget file (in `presentation/widgets`) must have a corresponding widget test file.
2.  **Mocking**: Use `mocktail` for dependency injection in tests.
3.  **Constructor Injection**: Prefer constructor injection over global singletons to facilitate testing.
5.  **Atomic Testing**: Never commit code without its test.
6.  **Comprehensive Cases**: You must test:
    -   **Happy Path**: Standard success scenario.
    -   **Failure Path**: Error handling and exceptions.
    -   **Boundary conditions**: Empty lists, max values, null inputs.

## Audit Workflow

### 1. File Mirror Check
-   For every file in `lib/domain/`, `lib/data/`, `lib/presentation/bloc/`, OR `lib/presentation/widgets/`, verify a corresponding file exists in `test/`.
-   Example: `lib/domain/usecases/get_items.dart` -> `test/domain/usecases/get_items_test.dart`.
-   Example: `lib/features/x/presentation/widgets/my_widget.dart` -> `test/features/x/presentation/widgets/my_widget_test.dart`.

### 2. Coverage Verification
-   Run `flutter test --coverage`.
-   Check `coverage/lcov.info` to ensure the mirrored file has 100% coverage.

### 3. Test Quality Audit
-   Are dependencies mocked using `mocktail`?
-   Are edge cases (Loading, Success, Failure) handled in tests?
-   Are asynchronous operations correctly tested using `expectLater` or `blocTest`?
-   **CRITICAL**: Did you test what happens when the operation fails? (e.g. ServerException)
-   **CRITICAL**: Did you test empty or null states?

## Implementation Examples

### Good: Mirrored Test with Mocktail
```dart
// test/domain/usecases/get_items_test.dart
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';

class MockVaultRepository extends Mock implements VaultRepository {}

void main() {
  late GetItems usecase;
  late MockVaultRepository mockRepository;

  setUp(() {
    mockRepository = MockVaultRepository();
    usecase = GetItems(mockRepository);
  });

  test('should get items from the repository', () async {
    // ... test logic
  });
}
```

### Bad: Missing Mirror
-   `lib/domain/usecases/delete_item.dart` exists, but NO `test/domain/usecases/delete_item_test.dart`.
