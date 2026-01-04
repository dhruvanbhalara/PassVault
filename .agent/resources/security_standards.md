# 🔐 PassVault Security Standards

As a password manager, security is our absolute priority. No code should be merged that compromises these standards.

## 1. Data at Rest (Encryption)
-   **AES-256**: All user data must be encrypted using AES-256 via `HiveAesCipher`.
-   **Key Isolation**: The encryption key must be stored in the device's secure hardware (Secure Enclave / Keystore / KeyChain) using `flutter_secure_storage`.
-   **No Secondary Storage**: Do not cache decrypted passwords in variables outside of the immediate UI view scope.

## 2. Authentication Gate
-   **Biometrics**: Sensitive operations (viewing, editing, exporting) must be gated by `local_auth`.
-   **Session Timeout**: Implement a mandatory background timeout that clears the session and returns to the auth gateway.
-   **Brute Force**: Avoid implementing custom login hints that could leak metadata.

## 3. UI/UX Security
-   **Background Masking**: Ensure the app displays a splash or blurred screen when in the background/switcher mode (using `secure_application` or platform hooks).
-   **Screenshots**: Disable screenshots on sensitive screens (Android) using `window_manager` or platform channels.
-   **Clipboard Integrity**: Automatically clear the clipboard 30-60 seconds after a password is copied.

## 4. Code Hygiene
-   **No Logs**: Use `debugPrint` only for non-sensitive info. Never log the contents of a `PasswordEntry`.
-   **Dependency Audit**: Regularly audit dependencies in `pubspec.yaml` for security vulnerabilities.
-   **Input Validation**: Strict validation for imported JSON/CSV data to prevent injection or corruption.
