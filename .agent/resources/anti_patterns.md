# 🚫 PassVault Anti-Patterns

### 1. 🛡️ Security Violations
-   **❌ Hardcoding Encryption Keys**: Never hardcode keys. Always use `SecureStorage`.
-   **❌ Unencrypted Persistence**: Never write sensitive data to `SharedPreferences` or unencrypted Hive boxes.
-   **❌ Plaintext Password Display**: Never display passwords in plain text by default. Always use "masked" view with a toggle.
-   **❌ Clipboard Negligence**: Never leave a password on the clipboard forever. (Implement auto-clear after 30s).

### 2. 🏗️ Architectural Leakage
-   **❌ UI Logic Hubs**: Putting business logic (like manual JSON parsing) inside a `build()` method. Use BLoC.
-   **❌ Repository in Page**: Directly calling `Hive.box` or a repository from a Widget. Widgets should only know about Blocs.
-   **❌ Global Variables**: Using global variables for state. Use `GetIt` for services and BLoC for state.
-   **❌ Direct Bloc Access**: Calling `bloc.method()` directly. ALWAYS use `bloc.add(Event)`.

### 3. 🎨 UI & Performance
-   **❌ Magic Numbers**: Using raw `16.0` instead of `AppSpacing.md`.
-   **❌ Massive Widgets**: Writing widgets larger than 50 lines. Extract them!
-   **❌ Theme Overwrites**: Using `TextStyle(color: Colors.red)` instead of semantic tokens like `context.colors.error`.
-   **❌ Rebuilding Everything**: Using a single massive BLoC for the whole app. Split BLoCs by feature/responsibility.
-   **❌ Synchronous Heavy Operations**: Running CSV/JSON parsing for 1000+ entries on the main thread. Use `Isolate`.

### 4. 🧪 Testing Failures
-   **❌ Logic-less Tests**: Writing tests that only verify `1 == 1`.
-   **❌ No Mocking**: Testing a Repository by opening a real Hive box. Use `mocktail` to mock the data source.
-   **❌ Ignoring Coverage**: Submitting PRs that decrease overall code coverage.
-   **❌ Redundant Comments**: Adding comments like `// Ignore docs` that add noise without value.
