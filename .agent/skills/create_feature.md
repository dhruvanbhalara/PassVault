---
description: How to create a new feature following strict Clean Architecture
---

# Create New Feature Skill

This skill outlines the steps to create a new feature in `PassVault`, enforcing strict Clean Architecture and 100% testability.

## 1. Directory Structure
Create the following directory structure under `lib/features/<feature_name>`:
```
lib/features/<feature_name>/
├── data/
│   ├── datasources/       # Remote/Local data sources
│   ├── models/            # DTOs (extends Entity)
│   └── repositories/      # Implementation of Domain Repositories
├── domain/
│   ├── entities/          # Pure Dart objects (Equatable)
│   ├── repositories/      # Abstract interfaces
│   └── usecases/          # Granular business logic (One class per action)
└── presentation/
    ├── bloc/              # State management (Bloc/Cubit)
    └── screens/           # UI Widgets
```

## 2. Test Mirroring
You **MUST** create a corresponding test structure in `test/features/<feature_name>` that exactly mirrors the `lib` structure.

## 3. Implementation Step-by-Step

### Step 1: Domain Layer (Pure Dart)
1.  **Entity**: Create `domain/entities/<name>.dart`. Must extend `Equatable`.
2.  **Repository Interface**: Create `domain/repositories/<name>_repository.dart`.
    *   Methods must return `Future<Result<T>>` or `Result<T>`.
    *   Use `passvault/core/error/error.dart` for `Result`.
3.  **UseCases**: Create `domain/usecases/<action>_<entity>_usecase.dart`.
    *   One public method `call(...)`.
    *   Annotate with `@lazySingleton`.

### Step 2: Data Layer
1.  **Model**: Create `data/models/<name>_model.dart`.
    *   Extend Entity.
    *   Implement `fromJson`/`toJson`.
2.  **DataSource**: Create `data/datasources/<name>_local_data_source.dart`.
3.  **Repository Implementation**: Create `data/repositories/<name>_repository_impl.dart`.
    *   Implement the Domain Repository interface.
    *   Catch exceptions and return `Error(Failure)`.
    *   Return `Success(Data)` on success.

### Step 3: Presentation Layer
1.  **Bloc/Cubit**: Create `presentation/bloc/<name>_cubit.dart`.
    *   Use `freezed` or `equatable` for State.
    *   Inject UseCases, NOT Repositories.
2.  **Screen**: Create `presentation/screens/<name>_screen.dart`.
    *   Use `BlocBuider`/`BlocListener`.
    *   Use Design System components (`lib/core/design_system/components/components.dart`).

## 4. Checklist
- [ ] Domain layer has NO Flutter dependencies.
- [ ] Repository returns `Result<T>`.
- [ ] Tests created for all layers (100% logic coverage).
- [ ] Di configuration updated (run `flutter packages pub run build_runner build`).
