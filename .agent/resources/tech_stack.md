# 🛠️ PassVault Technical Stack (v3.0)

As Sr. Architect, I have curated this stack for maximum security, performance, and maintenance.

### 🏗️ Foundation
- **Flutter Framework**: Latest Stable Channel.
- **Clean Architecture**: Mandatory 3-layer separation (Presentation, Domain, Data).
- **Dependency Injection**: `injectable` + `get_it` (Type-safe and test-friendly).

### 🧠 State Management
- **Bloc**: `flutter_bloc` (Event-Driven only). Custom transformers for event control.
- **Immutability**: `equatable` (Mandatory for States/Events).
- **Navigation**: `go_router` (Declarative, URL-aware).

### 🛡️ Security & Storage
- **Encryption**: `hive_ce` with `AES-256-GCM` authenticated encryption.
- **Key Management**: `flutter_secure_storage` (Hardware-backed secrets).
- **Authentication**: `local_auth` (Biometric gates).

### 🎨 Design System
- **Theming**: `ThemeExtension` for semantic color palettes (Amoled, Dark, Light).
- **Icons**: `lucide_icons_flutter` (Modern, consistent).
- **Typography**: Google Fonts (Inter/Outfit).
- **Structure**: Shared `core/theme` tokens.

### 🧪 Quality Assurance
- **Analysis**: Custom `analysis_options.yaml` with strict lints.
- **Testing**: `mocktail` (Mocking), `bloc_test` (States).
- **Linting**: No-warning policy (`dart analyze`).
- **Formatting**: Mandatory `dart format`.