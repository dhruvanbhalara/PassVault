---
name: security_compliance
description: Ensure security best practices are followed, including encryption and key management.
---

# Security Compliance Skill

This skill enforces the security and data integrity principles required for PassVault Enterprise, as defined in `flutter_rules.md`.

## Core Requirements

1.  **AES-256-GCM**: Use Authenticated Encryption for all sensitive data stored locally.
2.  **Key Management**: The Master Key must NEVER be persisted in plaintext. Use `flutter_secure_storage` for derived encryption keys.
3.  **Memory Safety**: Erase sensitive data (like plaintext passwords or decrypted keys) from memory when the session expires or the app goes to the background.
4.  **Biometric Gate**: Any view, export, or delete action MUST be preceded by local authentication.

## Security Audit Checklist

### 1. Storage Audit
-   Is sensitive data encrypted using AES-256-GCM?
-   Are keys stored safely in `SecureStorage`?
-   Check `lib/data/datasources/` for any plaintext storage of sensitive fields.

### 2. Logic Audit
-   Is there a session timeout mechanism that clears decrypted data?
-   Are `TextEditingController`s cleared after use?
-   Is `LocalAuthentication` triggered before sensitive operations?

### 3. Dependency Audit
-   Ensure cryptographically sound packages are used (e.g., `cryptography`, `flutter_secure_storage`).
-   Avoid using `shared_preferences` for sensitive data.

## Implementation Examples

### Good: Secure Storage Usage
```dart
// lib/data/repositories/secure_storage_repository.dart
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SecureKeyStore {
  final _storage = const FlutterSecureStorage();
  
  Future<void> saveKey(String key, String value) async {
    await _storage.write(key: key, value: value);
  }
}
```

### Bad: Plaintext Storage
```dart
// lib/data/datasources/local_datasource.dart
import 'package:shared_preferences/shared_preferences.dart';

Future<void> savePassword(String password) async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.setString('user_pwd', password); // CRITICAL: NEVER store secrets in SharedPreferences
}
```
