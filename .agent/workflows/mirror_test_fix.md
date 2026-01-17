---
description: Specialized workflow to resolve missing test coverage or broken mirror tests.
---

# Mirror Test Fix Workflow

Use this workflow to achieve 100% logic layer coverage as required by the "Mirror Test Rule".

## Steps

1.  **Identify Missing Coverage**:
    ```bash
    make test_coverage
    ```
    Open `coverage/lcov.info` or the HTML report to find files in `domain`, `data`, or `presentation/bloc` with < 100% coverage.

2.  **Create/Sync Test File**:
    Ensure `test/[path_to_file]_test.dart` exists and mirrors the `lib/` structure.

3.  **Mock Dependencies**:
    Identify all external dependencies (Repositories, Data sources, etc.).
    Use `mocktail` to create mocks.

4.  **Implement Test Cases**:
    -   Test **Initial State** (for BLoCs).
    -   Test **Success Flow**.
    -   Test **Failure Flow** (Expected errors).
    -   Test **Edge Cases** (Empty lists, null values).

5.  **Verify**:
    ```bash
    flutter test [path_to_test_file]
    ```
    Repeat `make test_coverage` to ensure the file now hits 100%.

6.  **Compliance Check**:
    Verify with `mirror_test_rule` skill.
