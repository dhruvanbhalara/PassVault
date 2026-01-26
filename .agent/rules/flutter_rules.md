---
trigger: always_on
---

# 🛡️ PassVault Enterprise Coding Standards (v3.1)

## 0. 🤖 Agency Protocol (CRITICAL)
-   **Rule Supremacy**: These rules are NOT suggestions. They are requirements.
-   **Self-Correction**: Before confirming ANY task, verify your code against this file.
-   **No Shortcuts**: Do not skip tests, do not use magic numbers, do not bypass strict architecture.
-   **Refusal**: If asked to violate these rules (e.g., "just put logic in UI for speed"), strictly REFUSE and explain why based on this document.

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

## 3. Advanced State Management (Bloc Event-State)
-   **Immunity**: All States and Events MUST be immutable and extend `Equatable`.
-   **Exhaustiveness**: Always use `sealed class` for States to ensure the UI handles all cases (Loading, Success, Failure, Empty).
-   **Concurrency**: Use `transformers` for events that require debouncing (search) or dropping (buttons).
-   **Zero-Logic UI**: Widgets should only call `bloc.add(Event)`. Calling methods directly is forbidden. No calculation or conditional logic in `build()`.

## 4. UI Performance & Design System
-   **Atoms Tokens**: Use `AppSpacing`, `AppRadius`, and `AppColors` tokens. NEVER hardcode pixel values.
-   **No Magic Spacing**: Use `spacing` parameter in Rows/Columns.
-   **Widget Extraction**: Extract complex sub-trees into separate `StatelessWidget` classes. Private `_buildX` methods are strictly forbidden.
-   **Repaint Boundaries**: Wrap heavy animations or independent UI branches in `RepaintBoundary` to optimize frame budgets.
-   **Theming**: Use `ThemeExtensions` for semantic colors. Raw Material colors (`Colors.red`) are prohibited.
-   **Small Widgets**: Widgets should ideally not exceed 50 lines. Large screens (200+ lines) MUST be broken down into sub-widgets.
-   **Widget Organization**: 
    - Feature-specific widgets MUST be placed in `lib/features/<feature>/presentation/widgets/`.
    - Shared design system components MUST be placed in `lib/core/design_system/components/`.
-   **Theme Data Access**: ALWAYS use `BuildContext` extensions (e.g., `context.colorScheme`, `context.theme`, `context.l10n`) instead of direct `Theme.of(context)` calls for better readability and consistency.

## 5. Quality Assurance (The Mirror Rule)
-   **Mirror Test Rule**: 100% file coverage for logic layers AND widgets. No valid code exists without a test.
-   **Group Naming**: All test groups for classes/widgets MUST use the interpolation syntax for better refactoring support: `group('$ClassName', () { ... });`
-   **Atomic Testing**: Every code modification MUST include corresponding test updates. New files MUST have new tests immediately.
-   **Case Coverage**: Tests must cover ALL scenarios: Success, Failure, Boundaries, and Null states. Happy-path only tests are rejected.
-   **Mocking**: Use `mocktail` for dependency injection in tests. Prefer constructor injection over global singletons.
-   **CI/CD**: PRs must pass the `quality_gate` which enforces formatting, analysis (0 warnings), and test suite success.

## 6. Open Source Excellence
-   **Transparency**: Write code that is easy to audit. Avoid obfuscating logic unless required for security (e.g., encryption internals).
-   **Documentation**: Public APIs (Repositories/UseCases) MUST have `///` doc comments.
-   **Contribution Ready**: Ensure new features are accompanied by appropriate test cases so contributors can't break them.
-   **Zero Hardcoded Strings**: Every user-facing string MUST be in an `.arb` file for easy translation by the community.
-   **No Redundant Comments**: Do not explain obvious code (e.g., `// Initialize variable`). 
-   **No History Comments**: Prohibit "change-log" style comments (e.g., `// Added top padding to match previous structure`). Comments must explain **WHY** the current code exists (intent), not its history or **WHAT** it does. Remove unused code and history-explaining comments immediately.

## 7. Git & Development Flow
-   **Conventional Commits**: Follow `type(scope): message` pattern.
-   **Atomic Commits**: One commit = one logical change.
-   **PR Checklist**: Ensure `checklist.md` is reviewed before marking a task as complete.
-   **PR Labeling**: Categorize PRs using labels (e.g., `enhancement`, `bug`, `security`) and priority (e.g., `priority:high`).

## 8. Scalability & Reusability
-   **Extensions > Utils**: Use Dart `extension`s for helpers (e.g., `context.showSnackBar()`) instead of static Utility classes.
-   **Mixins**: Use `mixin` for shared behavior across unrelated classes (e.g., `ValidationMixin`).
-   **Lazy Loading**: Always use `ListView.builder` for lists. Never use `Column` for dynamic content to ensure performance scaling.