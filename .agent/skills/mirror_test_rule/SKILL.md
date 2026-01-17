---
name: mirror_test_rule
description: Enforce the "Mirror Test Rule" for 100% logic layer coverage.
---

# Mirror Test Rule Skill

This skill enforces the "Mirror Test Rule" and Quality Assurance standards from `flutter_rules.md`.

## Core Requirements

1.  **Mirror Test Rule**: 100% file coverage for logic layers (`domain`, `data`, `presentation/bloc`). Every logic file must have a corresponding test file.
2.  **Mocking**: Use `mocktail` for dependency injection in tests.
3.  **Constructor Injection**: Prefer constructor injection over global singletons to facilitate testing.
4.  **No Logic-free Coverage**: Ensure tests actually verify behavior, not Just line hits.

## Audit Workflow

### 1. File Mirror Check
-   For every file in `lib/domain/`, `lib/data/`, or `lib/presentation/bloc/`, verify a corresponding file exists in `test/`.
-   Example: `lib/domain/usecases/get_items.dart` -> `test/domain/usecases/get_items_test.dart`.

### 2. Coverage Verification
-   Run `flutter test --coverage`.
-   Check `coverage/lcov.info` to ensure the mirrored file has 100% coverage.

### 3. Test Quality Audit
-   Are dependencies mocked using `mocktail`?
-   Are edge cases (Loading, Success, Failure) handled in tests?
-   Are asynchronous operations correctly tested using `expectLater` or `blocTest`?

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
