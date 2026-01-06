---
trigger: always_on
---

# 🛡️ PassVault Enterprise Coding Standards (v3.1)

## 1. Security & Data Integrity (Architect Level)
-   **AES-256-GCM**: Use Authenticated Encryption for all sensitive storage.
-   **Key Management**: The Master Key must never be persisted in plaintext. Use `SecureStorage` for the derived encryption key.
-   **Memory Safety**: Erase sensitive data from memory when the app enters the background or the session expires.
-   **Biometric Gate**: Mandatory local authentication for any view/export/delete action.

## 2. Strict Clean Architecture
-   **Domain Purity**: The `domain` layer must be pure Dart. NO `package:flutter` imports are allowed. This ensures 100% testability.
-   **Reactive Repositories**: Prefer `Stream` based repository methods to allow the UI to react to database changes automatically.
-   **Functional Error Handling**: Use `Either<Failure, T>` or a sealed `Result<T>` for all Repository and UseCase returns. NEVER throw exceptions across layers.
-   **Layer Dependency**: `Presentation -> Domain <- Data`. Data layer must only depend on Domain interfaces, never on Presentation widgets.

## 3. Advanced State Management (Bloc/Cubit)
-   **Immunity**: All States and Events MUST be immutable and extend `Equatable`.
-   **Exhaustiveness**: Always use `sealed class` for States to ensure the UI handles all cases (Loading, Success, Failure, Empty).
-   **Concurrency**: Use `transformers` for events that require debouncing (search) or dropping (buttons).
-   **Zero-Logic UI**: Widgets should only call `bloc.add(Event)` or `cubit.method()`. No calculation or conditional logic in `build()`.

## 4. UI Performance & Design System
-   **No Magic Spacing**: Use `spacing` parameter in Rows/Columns or `AppSpacing` tokens. NEVER hardcode pixel values.
-   **Widget Extraction**: Extract complex sub-trees into separate `StatelessWidget` classes. Private `_buildX` methods are strictly forbidden.
-   **Repaint Boundaries**: Wrap heavy animations or independent UI branches in `RepaintBoundary` to optimize frame budgets.
-   **Theming**: Use `ThemeExtensions` for semantic colors. Raw Material colors (`Colors.red`) are prohibited.

## 5. Quality Assurance (The Mirror Rule)
-   **Mirror Test Rule**: 100% file coverage for logic layers (`domain`, `data`, `presentation/bloc`).
-   **Mocking**: Use `mocktail` for dependency injection in tests. Prefer constructor injection over global singletons.
-   **CI/CD**: PRs must pass the `quality_gate` which enforces formatting, analysis (0 warnings), and test suite success.

## 6. Open Source Excellence
-   **Transparency**: Write code that is easy to audit. Avoid obfuscating logic unless required for security (e.g., encryption internals).
-   **Documentation**: Public APIs (Repositories/UseCases) MUST have `///` doc comments.
-   **Contribution Ready**: Ensure new features are accompanied by appropriate test cases so contributors can't break them.
-   **Zero Hardcoded Strings**: Every user-facing string MUST be in an `.arb` file for easy translation by the community.

## 7. Git & Development Flow
-   **Conventional Commits**: Follow `type(scope): message` pattern.
-   **Atomic Commits**: One commit = one logical change.
-   **PR Checklist**: Ensure `checklist.md` is reviewed before marking a task as complete.
