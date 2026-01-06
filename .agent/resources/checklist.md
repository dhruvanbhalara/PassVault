# 🏁 Architect's Pre-Flight Checklist (Open Source Edition)

## 1. 🏗️ Architectural Integrity
- [ ] **Domain Purity**: Does `lib/features/<feature>/domain` have ZERO imports from `package:flutter`?
- [ ] **Boundary Check**: Did I use the Repository interface in the Bloc/Cubit instead of the implementation?
- [ ] **Functional Returns**: Do all Repository and UseCase methods return a `Result` or `Either<Failure, T>`?
- [ ] **DI registration**: Are new classes annotated with `@injectable` and registered via `build_runner`?

## 2. 🛡️ Security & Privacy
- [ ] **Data Masking**: are sensitive strings (passwords) obfuscated by default in the UI?
- [ ] **Auth Gating**: Is this feature/action protected by `local_auth` if it handles user secrets?
- [ ] **Log Audit**: Did I remove all `print` or `debugPrint` calls containing potentially sensitive metadata?

## 3. ⚡ Performance & UI
- [ ] **Widget Extraction**: Did I extract reusable widgets into separate classes instead of private build methods?
- [ ] **Const Usage**: Are all possible widget constructors marked as `const`?
- [ ] **Rebuild Efficiency**: Did I use `BlocSelector` or `Select` (if applicable) to minimize unnecessary rebuilds?
- [ ] **Design System**: Am I using `context.colors` and `AppSpacing` exclusively?

## 4. 🧪 Quality Assurance
- [ ] **Mirror Test**: Does `test/` have a 1:1 mirror of every new file in `lib/`?
- [ ] **Mocking**: Did I use `mocktail` for dependency injection in all unit/widget tests?
- [ ] **Linter**: Does `flutter analyze` report zero issues?
- [ ] **Formatting**: Did I run `dart format .`?

## 5. 🤝 Open Source Excellence
- [ ] **Public ARB**: If I added new strings, are they in `app_en.arb`?
- [ ] **Auditability**: Is the code logic clear enough for a community member to audit for security?
- [ ] **README Update**: Did I update the features list or setup instructions if they changed?
- [ ] **Accessibility**: Do interactive elements have appropriate semantics/labels?
