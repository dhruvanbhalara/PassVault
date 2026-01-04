# 🗺️ PassVault Architecture Map

PassVault uses a **Feature-First Clean Architecture** with strict layer separation to ensure security and testability.

## 🏗️ Core Layer (`lib/core/`)
-   `theme/`: Design system, colors, and typography (Centralized).
-   `services/`: Shared infrastructure.
    -   `database_service.dart`: Hive wrapper.
    -   `storage_service.dart`: Key management and encrypted box setup.
    -   `biometric_service.dart`: Local auth wrapper.
    -   `data_service.dart`: Import/Export (JSON/CSV) logic.
-   `di/`: `injectable` configuration.
-   `router/`: `go_router` definitions.

## 📦 Features Layer (`lib/features/`)

### 🔑 Password Manager (`password_manager/`)
-   **Domain**:
    -   `PasswordEntry`: Core immutable entity with `toJson`/`fromJson`.
    -   `PasswordRepository`: Interface for password operations.
-   **Data**:
    -   `PasswordRepositoryImpl`: Implementation of the repository.
    -   `PasswordLocalDataSource`: Direct Hive interaction.
-   **Presentation**:
    -   `bloc/`: State management for password lists, search, and CRUD.
    -   `pages/`: Dashboard, Add/Edit password screens.
    -   `widgets/`: Password items, copy-to-clipboard buttons, strength indicators.

### 🛡️ Auth (`auth/`)
-   **Domain**: Biometric and Master Key interfaces.
-   **Presentation**: `AuthBloc` for managing session and biometric gates.

### ⚙️ Settings (`settings/`)
-   Theme toggles, Biometric toggle, and App lock configuration.

## 🧪 Testing Strategy (`test/`)
-   **Mirror Rule**: Every file in `lib` has a twin in `test`.
-   **Unit**: Testing entities, repositories, and usecases in isolation.
-   **Bloc**: Exhaustive state transition tests using `bloc_test`.
-   **Widget**: Verifying UI rendering and interaction with mocked Blocs.