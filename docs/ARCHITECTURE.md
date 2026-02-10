# Architecture

PassVault follows **Clean Architecture** principles with a feature-first structure.

## Project Structure

```
lib/
├── app.dart                    # App entry & DI setup
├── main.dart                   # Main entry point
├── core/
│   ├── constants/              # App-wide constants
│   ├── di/                     # Dependency Injection (GetIt + Injectable)
│   ├── router/                 # GoRouter navigation
│   ├── services/               # Core services
│   │   ├── database_service.dart
│   │   ├── storage_service.dart # Repository of Hive Boxes
│   │   ├── encrypted_storage_service.dart # Master Key management
│   │   ├── crypto_service.dart # AES-256-GCM logic
│   │   ├── biometric_service.dart
│   │   └── data_service.dart   # Export/Import logic
│   └── theme/                  # App theming & design system
├── features/
│   ├── auth/                   # Authentication & biometrics
│   ├── home/                   # Dashboard & password list
│   ├── onboarding/             # First-run intro flow
│   ├── password_manager/       # Core password CRUD
│   └── settings/               # App preferences & export/import
└── l10n/                       # Localization files
```

## Dependency Flow

```
Presentation → Domain ← Data
     ↓           ↓        ↓
   BLoC      UseCases  Repositories
```

## Layer Responsibilities

| Layer | Responsibility |
|-------|----------------|
| **Presentation** | Widgets, BLoCs, UI state management |
| **Domain** | Business logic, entities, use cases (pure Dart) |
| **Data** | Repositories, data sources, models |
| **Core** | Shared services, theme, DI, routing |

## Security Architecture

1. **Master Key**: Generated via `Hive.generateSecureKey()` and stored in `FlutterSecureStorage`.
2. **Encrypted Storage**: All Hive boxes (`passwords`, `settings`) are encrypted using `HiveAesCipher` with the Master Key.
3. **Data Export**: Files are encrypted using **AES-256-GCM** with a user-provided password derived via **Argon2id**.

## State Management

- **BLoC/Cubit** for feature state
- **GetIt + Injectable** for dependency injection
- **GoRouter** for navigation

## Key Principles

1. **Domain Purity** - Domain layer has no Flutter dependencies
2. **Functional Error Handling** - Use `Either<Failure, T>` for results
3. **Immutable States** - All BLoC states extend `Equatable`
4. **Sealed Classes** - States use sealed classes for exhaustive handling
