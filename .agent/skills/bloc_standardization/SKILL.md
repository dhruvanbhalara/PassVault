---
name: bloc_standardization
description: Standardize BLoC and Cubit implementations according to project standards.
---

# BLoC Standardization Skill

This skill enforces the "Advanced State Management" rules from `flutter_rules.md`.

## Core Rules

1.  **Immutability**: All States and Events MUST be immutable and extend `Equatable`.
2.  **Exhaustiveness**: Use `sealed class` for States to ensure the UI handles all cases (Loading, Success, Failure, Empty).
3.  **Concurrency**: Use BLoC transformers for events that require debouncing (search) or dropping (repeated clicks).
4.  **Zero-Logic UI**: Widgets should only call `bloc.add(Event)` or `cubit.method()`. No calculation or conditional logic in `build()`.

## Audit Checklist

### 1. State/Event Audit
-   Are states defined as a `sealed class`?
-   Do all events and states extend `Equatable`?
-   Is `@immutable` used?

### 2. Logic Audit
-   Are there any complex logic or calculations in the widget's `build` method?
-   Are event transformers used where necessary?
-   Is business logic properly encapsulated in the BLoC/Cubit?

## Implementation Examples

### Good: Sealed State with Equatable
```dart
@immutable
sealed class VaultState extends Equatable {
  const VaultState();

  @override
  List<Object?> get props => [];
}

final class VaultInitial extends VaultState {}
final class VaultLoading extends VaultState {}
final class VaultSuccess extends VaultState {
  final List<VaultItem> items;
  const VaultSuccess(this.items);

  @override
  List<Object?> get props => [items];
}
```

### Bad: Non-sealed State
```dart
abstract class VaultState {} // ERROR: Should be a sealed class for exhaustiveness

class VaultLoading extends VaultState {}
// Missing Equatable and Immutability
```
