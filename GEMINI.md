# PassVault - Gemini Agent Context

## Project Overview
PassVault is a secure, offline-first password manager built with Flutter using strict Clean Architecture. This project aims for enterprise-grade security and maintainability.

## Technology Stack
- **Framework**: Flutter (Latest Stable)
- **Language**: Dart (3.0+)
- **State Management**: Bloc / Cubit
- **DI**: GetIt + Injectable
- **Local Database**: Hive (Encrypted Boxes)
- **Code Generation**: Freezed, JsonSerializable

## Key Architectural Principles
Refer to `.agent/rules/flutter_rules.md` for the complete rule set.
1.  **Strict Clean Architecture**:
    *   `domain` layer must be pure Dart (no Flutter imports).
    *   Dependencies flow: `Presentation -> Domain <- Data`.
2.  **Atomic Design System**:
    *   Core components are in `lib/core/design_system/components`.
    *   Use `AppTheme` tokens (colors, spacing), never hardcoded values.
3.  **Functional Error Handling**:
    *   Repositories and UseCases return `Result<T>` (sealed class).
    *   Never throw exceptions in domain logic.

## Developing New Features
Follow the **Create Feature Skill** (`.agent/skills/create_feature.md`):
1.  Define Domain Entities and Interfaces first.
2.  Implement Data Layer (Models, Datasources, Repositories).
3.  Implement Presentation Layer (Bloc/Cubit, Screens).
4.  Ensure 100% test coverage for logic layers.

## Testing Guidelines
- **Unit Tests**: Required for UseCases, Repositories, Blocs.
- **Widget Tests**: Required for atomic components and screens.
- **Mirror Rule**: Test directory structure must mirror `lib`.
