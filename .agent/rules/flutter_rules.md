---
trigger: always_on
---

# 🛡️ PassVault Enterprise Coding Standards (v1.0)

## 0. 🤖 Agency Protocol (CRITICAL)
-   **Rule Supremacy**: These rules are NOT suggestions. They are requirements.
-   **Plan-Act-Reflect**: For EVERY task, the agent MUST:
    1.  **Research**: Explore the codebase, understand requirements, and identify dependencies BEFORE proposing any changes.
    2.  **Plan**: Create/Update `task.md` (todo list) and `implementation_plan.md` (technical design).
    3.  **Act**: Execute small, atomic, and verifiable steps.
    4.  **Reflect**: Verify against tests, lints, and requirements before proceeding or finishing.
-   **No Shortcuts**: Do not skip tests, do not use magic numbers, do not bypass strict architecture.
-   **Self-Correction**: Before confirming ANY task, verify your code against this file.

## 1. Security & Data Integrity (Architect Level)
-   **AES-256-GCM**: Use Authenticated Encryption for all sensitive storage.
-   **Secret Storage**: Mandatory use of `flutter_secure_storage` for encryption keys and master-derived keys.
-   **Key Derivation**: Mandate NIST-approved hashing (**Argon2id**) for master password derivation before local storage encryption and export.
-   **Memory Safety**: Strictly clear sensitive variables (passwords, keys) from memory when the operation finishes or the app enters the background. 
-   **Clipboard Safety**: Mandate programmatic clearing of sensitive data (OTPs, Passwords) after a short duration (30-60s).
-   **Biometric Gate**: Mandatory local authentication for any view, export, or destructive action.
-   **Audit Log**: All security-sensitive actions should be logged via `AppLogger` (excluding raw secrets).

## 2. Strict Clean Architecture (Pattern-First)
-   **Domain Purity**: The `domain` layer must be pure Dart. NO `package:flutter` imports.
-   **Functional Error Handling**: Use `Either<Failure, T>` or `Result<T>` sealed classes. NEVER throw exceptions across layer boundaries.
-   **Pattern Matching**: Exhaustively handle all sealed class states using Dart 3.x `switch` expressions in UI and BLoCs.
-   **Layer Dependency**: `Presentation -> Domain <- Data`. Data layer implements Domain interfaces.
-   **Feature-First 2.0**: Enforce strict separation of `DataSources` (External/Raw) vs `Repositories` (Domain abstraction).

## 3. Advanced State Management (Bloc Event-State)
-   **Sealed States**: Always use `sealed class` for States to ensure exhaustive UI handling.
-   **Immutability**: All States, Events, and Domain Entities MUST be immutable (using `final` and `Equatable` or `freezed`).
-   **Concurrency**: Use `transformers` (e.g., `restartable()`, `droppable()`) for events requiring debouncing (search) or throttling (buttons).
-   **Zero-Logic UI**: Widgets MUST NOT contain business logic, orchestration logic, or direct calls to external services (e.g., Auth, Biometrics, API, Storage). They should ONLY dispatch events (`bloc.add(Event)`) and build UI based on BLoC states. Strictly prohibit logical branching or service orchestration in `build()` or state methods.

## 4. UI Performance & Design System
-   **Atoms Tokens**: Use `AppSpacing`, `AppRadius`, and `AppColors`. No hardcoded pixel values.
-   **Const-First**: Every widget that can be `const` MUST be `const`.
-   **Widget Extraction**: STRICTLY prohibit private `_build*()` methods that return widgets. Extract them into separate `StatelessWidget` or `StatefulWidget` classes (can be private with `_` prefix). This ensures better testability, reusability, and composition.
-   **Lazy Rendering**: Mandatory use of lazy-loading constructs (`SliverList` with `SliverChildBuilderDelegate` or `ListView.builder`) for any list exceeding 10 items.
-   **Sliver Preference**: Prefer `CustomScrollView` with `Slivers` over `SingleChildScrollView` for any non-trivial scrollable layout to ensure lazy loading and avoid jank. Use `SliverList` and `SliverGrid` for mixed content types.
-   **Repaint Boundaries**: Wrap complex animations or heavy UI sections in `RepaintBoundary` to optimize Impeller frame budget.
-   **Isolate Parsing**: Mandate `compute()` or `Isolate` for JSON parsing exceeding 1MB to avoid main-thread jank.
-   **Theme Access**: ALWAYS use `context` extensions (e.g., `context.colorScheme`, `context.theme`).

## 5. Quality Assurance & Advanced Testing (The Mirror Rule)
-   **Mirror Test Rule**: 100% logic and widget coverage. No code without a test.
-   **Test Naming**: Use string interpolation for test group names: `group('$ClassName',` not `group('ClassName',`. This ensures consistency and allows for better tooling support.
- [ ] **Test Structure**: Tests MUST follow a logical `Given-When-Then` sequence without explicit comments. The structure should be inherent in the code flow (e.g., setup, act, expect).
-   **Coverage Targets**: Target 100% logic coverage for `domain` and `bloc` layers.
-   **Mocking Protocol**: Use `mocktail` for all dependency mocking. STRICTLY prohibit using real implementation dependencies in unit tests.
-   **Mirror Organization**: Test files MUST strictly mirror the `lib/` directory structure and end with `_test.dart`.
-   **Test Grouping**: Use `group()` to organize tests by feature, class, or state for clearer reporting.
-   **Pure Logic**: Business logic inside BLoCs or UseCases should be extracted to static pure functions for 100% unit test coverage.
-   **Widget Keys**: Assign distinctive `Key`s to interactive widgets using `Key('feature_action_id')` format.
-   **Test Localization**: STRICTLY prohibit hardcoded strings in tests for text that is localized in the application. Mandatory use of `AppLocalizations` (e.g., via `context.l10n` in widget tests or a helper for unit tests) to ensure test assertions remain in sync with the source of truth.
-   **CI/CD**: Analysis (0 warnings), Formatting, and Tests must pass before PR.

## 6. Open Source & Clean Code
-   **No Redundant Comments**: Do not explain WHAT code does. Explain WHY (intent).
-   **Simple & Informative**: Comments MUST be concise, informative, and understandable. Avoid "wall of text".
-   **No History Comments**: STRICTLY prohibit comments like "fixed X" or "updated Y". Git history is the source of truth.
-   **No Print Statements**: STRICTLY prohibit `print()`. Use `AppLogger`.
-   **Localization**: Zero hardcoded strings. Use `.arb` and `context.l10n`.

## 7. Git & Development Flow
-   **Conventional Commits**: Follow `type(scope): message` pattern.
-   **Atomic Commits**: One commit = one logical change.
-   **PR Checklist**: Ensure `checklist.md` is reviewed before marking a task as complete.
-   **PR Metadata**: ALWAYS specify labels/tags (e.g., `bug`, `feature`) and at least one assignee when creating a Pull Request to ensure trackability.
-   **PR Labeling**: Categorize PRs using labels (e.g., `enhancement`, `bug`, `security`) and priority (e.g., `priority:high`).

## 8. Code Clarity & Maintenance
-   **300-Line Limit**: Strictly flag any file exceeding 300 lines (excluding tests) for decomposition.
-   **Guard Clauses**: Use early returns (e.g., `if (user == null) return;`) to reduce indentation.
-   **Meaningful Naming**: Use intention-revealing names. Boolean variables MUST use prefixes like `is`, `has`, `should`.
-   **Strong Typing**: Strictly prohibit `dynamic`. Use `Object?` or explicit types.
-   **Cascade Pattern**: Use cascade notation (`..`) for cleaner initialization of complex objects where appropriate.

## 9. Agent Guardrails
-   **ALWAYS**: Run `flutter analyze` and `dart format` before committing.
-   **ALWAYS**: Check `implementation_plan.md` status before completing a task.
-   **ASK FIRST**: Before changing global themes, updating critical dependencies, or deleting files. 
-   **NEVER**: Commit raw API keys, secrets, or hardcoded sensitive data.

## 10. Navigation & Dependency Injection Standards
-   **Dynamic Routes**: STRICTLY prohibit hardcoded route strings in `GoRouter` configuration. Use static constants in `AppRoutes`.
-   **Centralized BLoCs**: BLoC providers MUST be injected via `ShellRoute` or `BlocProvider` in `app_router.dart` when shared across multiple screens or within a feature branch.
-   **No Local Providers**: Avoid `BlocProvider` in individual screen `build()` methods if the BLoC is needed by a feature set.