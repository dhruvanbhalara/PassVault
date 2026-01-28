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
-   **Key Derivation**: Mandate NIST-approved hashing (Argon2 or PBKDF2) for master password derivation before local storage encryption.
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
-   **Zero-Logic UI**: Widgets should ONLY call `bloc.add(Event)`. No logical branching in `build()`.

## 4. UI Performance & Design System
-   **Atoms Tokens**: Use `AppSpacing`, `AppRadius`, and `AppColors`. No hardcoded pixel values.
-   **Const-First**: Every widget that can be `const` MUST be `const`.
-   **Lazy Rendering**: Mandatory `ListView.builder` for any list exceedng 10 items.
-   **Repaint Boundaries**: Wrap complex animations or heavy UI sections in `RepaintBoundary` to optimize Impeller frame budget.
-   **Isolate Parsing**: Mandate `compute()` or `Isolate` for JSON parsing exceeding 1MB to avoid main-thread jank.
-   **Theme Access**: ALWAYS use `context` extensions (e.g., `context.colorScheme`, `context.theme`).

## 5. Quality Assurance & Advanced Testing (The Mirror Rule)
-   **Mirror Test Rule**: 100% logic and widget coverage. No code without a test.
-   **Test Structure**: Mandate the `Given-When-Then` pattern within `test()` blocks for readability (e.g., `// Given`, `// When`, `// Then`).
-   **Coverage Targets**: Target 100% logic coverage for `domain` and `bloc` layers.
-   **Mocking Protocol**: Use `mocktail` for all dependency mocking. STRICTLY prohibit using real implementation dependencies in unit tests.
-   **Mirror Organization**: Test files MUST strictly mirror the `lib/` directory structure and end with `_test.dart`.
-   **Test Grouping**: Use `group()` to organize tests by feature, class, or state for clearer reporting.
-   **Pure Logic**: Business logic inside BLoCs or UseCases should be extracted to static pure functions for 100% unit test coverage.
-   **Widget Keys**: Assign distinctive `Key`s to interactive widgets using `Key('feature_action_id')` format.
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