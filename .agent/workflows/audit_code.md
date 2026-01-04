# 🕵️ PassVault Code Audit & Compliance

**Trigger:** `/audit`, "Review security", "Ensure compliance".

**Description:** Performs a deep-dive security and architectural audit of the PR/codebase.

---

## 🛡️ Phase 1: Security Forensics
Check for common security pitfalls in a password manager.

1.  **Encryption Integrity**:
    *   **Command**: `grep -r "Hive.openBox" lib/`
    *   **Check**: Are boxes opened with `encryptionCipher`? (Exception for `settings`)
2.  **Sensitive Logging**:
    *   **Command**: `grep -r "print(" lib/` or `grep -r "debugPrint(" lib/`
    *   **Check**: Are variables like `password`, `secret`, `key` being printed?
3.  **Plaintext Storage**:
    *   **Command**: `grep -r "SharedPreferences" lib/`
    *   **Verdict**: ❌ **CRITICAL**: Use of SharedPreferences for sensitive data is prohibited. Use `SecureStorage` or Encrypted Hive.

## 🏗️ Phase 2: Architectural Consistency
Ensure the "Feature-First Clean Architecture" is maintained.

1.  **Layer Separation**:
    *   **Command**: `grep -r "presentation" lib/features/**/domain/`
    *   **Verdict**: ❌ **VIOLATION**: Domain layer cannot depend on Presentation.
2.  **Dependency Injection**:
    *   **Command**: `grep -r "GetIt.I.get" lib/features/`
    *   **Verdict**: ⚠️ **WARNING**: Prefer constructor injection with `@injectable`. Avoid using the locator directly in UI.

## 🎨 Phase 3: Design & UX Security
1.  **Clipboard Handling**:
    *   **Check**: Does copying a password trigger an auto-clear timer?
2.  **Biometric Gating**:
    *   **Check**: Are `Add` and `Edit` actions gated by `AuthBloc` state?

## 🧪 Phase 4: Automated Quality Gate
Execute the local equivalent of the CI workflow.

1.  `flutter analyze` (Must pass with 0 issues).
2.  `flutter test` (Must pass all tests).
3.  `dart format --set-exit-if-changed .` (Check for formatting regressions).

---

## 📝 Audit Report Template
```markdown
# 🚨 PassVault Audit: [Feature]

### 🔴 Critical Security Risks
* [ ] Found print statement logging `PasswordEntry.password` in `lib/features/password_manager/presentation/bloc/password_bloc.dart:45`.

### 🟡 Architectural Violations
* [ ] `PasswordRepositoryImpl` is missing `@LazySingleton` annotation.
* [ ] Missing test file for `lib/core/services/biometric_service.dart`.

### 🟢 Compliance Success
* [x] AES-256 Encryption correctly applied to new feature box.
* [x] Standard Design System used for all new widgets.
```
