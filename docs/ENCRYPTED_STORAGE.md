# Encrypted Storage Feature

PassVault uses AES-256-GCM encryption for all local storage and password-protected exports.

## Architecture Overview

```
┌─────────────────────────────────────────────────────────────────┐
│                       Platform Layer                            │
├─────────────────────────────────────────────────────────────────┤
│  FlutterSecureStorage          Hive Boxes (Encrypted)           │
│  (Keychain / EncryptedPrefs)   ├── passwordBox                  │
│                                └── settingsBox                  │
└───────────────┬─────────────────────────┬───────────────────────┘
                │                         │
                ▼                         ▼
┌───────────────────────────────────────────────────────────────────┐
│                        Core Services                              │
├──────────────────┬─────────────────┬─────────────────────────────┤
│ EncryptedStorage │  CryptoService  │  DatabaseService            │
│ Service          │  (PBKDF2+GCM)   │  (Settings I/O)             │
│ (Key Management) │                 │                             │
└────────┬─────────┴────────┬────────┴──────────────┬──────────────┘
         │                  │                       │
         │                  ▼                       │
         │         ┌────────────────┐               │
         │         │  DataService   │               │
         │         │  (Export/Import)│              │
         │         └───────┬────────┘               │
         │                 │                        │
         ▼                 ▼                        ▼
┌───────────────────────────────────────────────────────────────────┐
│                          Features                                 │
├──────────────────────────────────────────────────────────────────┤
│  PasswordLocalDataSource              SettingsBloc               │
└──────────────────────────────────────────────────────────────────┘
```

## Components

### EncryptedStorageService

Manages the master encryption key stored in platform secure storage.

| Platform | Storage |
|----------|---------|
| iOS | Keychain |
| Android | EncryptedSharedPreferences |

**Key Features:**
- Generates 256-bit AES key on first launch
- Key never leaves secure storage in plaintext
- Supports key rotation via `deleteEncryptionKey()`

### CryptoService

Provides AES-256-GCM encryption for export/import operations.

**Encryption Process:**
1. Generate random 32-byte salt
2. Derive key from password using PBKDF2 (100,000 iterations)
3. Generate random 12-byte IV
4. Encrypt data with AES-256-GCM
5. Output: `[salt][iv][ciphertext + auth tag]`

### DataService

Handles password data import/export in multiple formats:

| Format | Extension | Encrypted |
|--------|-----------|-----------|
| JSON | `.json` | ❌ |
| CSV | `.csv` | ❌ |
| PassVault Encrypted | `.pvault` | ✅ AES-256-GCM |

## Dependency Injection Pattern

PassVault uses a unified DI pattern with `injectable`:

| Type | Annotation | Use Case |
|------|------------|----------|
| Services | `@lazySingleton` | Business logic singletons |
| BLoCs | `@injectable` | Per-screen instances |
| Platform Dependencies | `@module` | Async initialization, platform APIs |

**StorageModule** (platform layer):
- `FlutterSecureStorage` - Platform secure storage
- `Box<dynamic>` (named) - Encrypted Hive boxes

**Services** (all use `@lazySingleton`):
- `EncryptedStorageService`
- `CryptoService`
- `DataService`
- `DatabaseService`

## Security Considerations

| Area | Implementation |
|------|----------------|
| Key Storage | Platform-native secure storage |
| Memory Safety | Keys loaded on-demand |
| PBKDF2 Iterations | 100,000 |
| Encryption Mode | AES-256-GCM (authenticated) |

## Usage

### Encrypted Export

```dart
context.read<SettingsBloc>().add(
  ExportEncryptedData(password: 'user_password'),
);
```

### Encrypted Import

```dart
context.read<SettingsBloc>().add(
  ImportEncryptedData(password: 'user_password'),
);
```

## Files

| Path | Purpose |
|------|---------|
| `lib/core/services/encrypted_storage_service.dart` | Key management |
| `lib/core/services/crypto_service.dart` | AES-256-GCM encryption |
| `lib/core/services/storage_service.dart` | Injectable module |
| `lib/core/services/data_service.dart` | Export/import logic |
| `test/core/services/*_test.dart` | Unit tests |
