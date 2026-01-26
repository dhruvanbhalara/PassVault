---
description: Guide for implementing a new feature following CLEAN architecture and project standards.
---

# Feature Implementation Workflow

This workflow guides you through the creation of a new feature from domain to presentation.

## Steps

### 1. Domain Layer (Foundation)
-   Create Directory: `lib/features/[feature_name]/domain/`.
-   Define **Entities**: Pure Dart classes for business data.
-   Define **Repository Interface**: Abstract class with `Result<T>` returns.
-   Define **Use Cases**: Individual classes for each business action.
-   Use `clean_architecture` skill to verify domain purity.

### 2. Data Layer (Implementation)
-   Create Directory: `lib/features/[feature_name]/data/`.
-   Implement **Models**: JSON serialization (use `Freezed` or `JsonSerializable`).
-   Implement **Data Sources**: Handle Local/Remote storage.
-   Implement **Repository**: Concrete implementation of the domain interface.
-   Verify security with `security_compliance` skill.

### 3. Presentation Layer (UI)
-   Create Directory: `lib/features/[feature_name]/presentation/`.
-   Implement **BLoC**: Follow `bloc_standardization` skill (sealed states, Equatable).
-   Build **Widgets**: Use `ui_standardization` skill (Atoms Tokens, 50-line limit).
-   Register dependencies in your DI container (e.g., `@injectable` or `GetIt`).

### 4. Verification
-   Create Mirror Tests: Follow `mirror_test_rule` skill (Atomic Testing, Case Coverage).
-   Run `make lint` and `make test`.
-   Request review via `pr_preparation` workflow.
