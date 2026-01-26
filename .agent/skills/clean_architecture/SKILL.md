---
name: clean_architecture
description: Enforce strict CLEAN architecture boundaries and domain purity.
---

# Clean Architecture Skill

This skill ensures that the PassVault project adheres to the Strict Clean Architecture principles defined in `flutter_rules.md`.

## Core Principles

1.  **Domain Purity**: The `domain` layer must be pure Dart. NO `package:flutter` imports are allowed.
2.  **Dependency Direction**: Dependencies must flow inwards: `Presentation -> Domain <- Data`.
3.  **Reactive Repositories**: Prefer `Stream`-based repository methods for reactive UI.
4.  **Functional Error Handling**: Use `Either<Failure, T>` or `Result<T>` for Repository and UseCase returns. NEVER throw exceptions across layers.
5.  **Data Layer Dependency**: The `data` layer must only depend on `domain` interfaces, never on `presentation` widgets.

## Audit Workflow

When auditing or implementing code, follow these checks:

### 1. Domain Layer Check
-   Verify `lib/domain/` contains NO `import 'package:flutter/...'`.
-   Ensure all business logic, entities, and repository interfaces are defined here.
-   Check that repository interfaces use `Result<T>` or `Either<Failure, T>`.

### 2. Data Layer Check
-   Verify `lib/data/` implements repository interfaces from `lib/domain/`.
-   Ensure it handles external data sources (APIs, Local DB).
-   Check that it converts data models to domain entities.

### 3. Presentation Layer Check
-   Ensure `lib/presentation/` only uses `domain` and `data` layers indirectly via DI/Repositories.
-   Verify BLoCs only call UseCases or Repositories.
-   Check for "Zero-Logic UI" (no logic in `build()` methods).

## Examples

### Good: Pure Domain Entity
```dart
// lib/domain/entities/vault_item.dart (PURE DART)
class VaultItem {
  final String id;
  final String title;
  
  VaultItem({required this.id, required this.title});
}
```

### Bad: Domain Entity with Flutter dependency
```dart
// lib/domain/entities/vault_item.dart
import 'package:flutter/material.dart'; // ERROR: Violates Domain Purity

class VaultItem {
  final String id;
  final Color categoryColor; // ERROR: UI concerns in domain
}
```
