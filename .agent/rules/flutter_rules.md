---
trigger: always_on
---

# Flutter & Dart Coding Standards (Bloc Project)

## 1. Project Architecture & Organization
* **Feature-First Clean Architecture:**
    * `lib/features/<feature>/data/`: Data sources, DTOs, Repository Implementations.
    * `lib/features/<feature>/domain/`: Entities, Enums, Repository Interfaces.
    * `lib/features/<feature>/presentation/`:
        * `blocs/` or `cubits/`: State management classes.
        * `pages/`: Full screen widgets (Scaffold).
        * `widgets/`: Reusable UI components.
    * `lib/core/`: Shared utilities, themes, and global service locators.
* **SOLID Principles:**
    * **Single Responsibility:** One class = one purpose.
    * **Dependency Inversion:** Depend on abstractions (Interfaces), not implementations.
    * **Interface Segregation:** Keep interfaces focused (e.g., `PortfolioRepository`).

## 2. Dart 3+ & Language Features
* **Sealed Classes (Union Types):**
    * Use `sealed class` for Bloc States and Events.
    * **Requirement:** Exhaustive `switch` expressions must be used in the Bloc/UI to handle every state.
* **Extensions:**
    * **On Context:** Use extensions on `BuildContext` for repetitive accessors.
        * *Preferred:* `context.colors.primary`, `context.textTheme.headlineLarge`.
    * **On Primitives:** Use extensions for utility logic (e.g., `date.format()`) rather than helper classes.
* **Records & Pattern Matching:**
    * Use **Records** `(double, String)` for returning multiple values.
    * Use **Pattern Matching** for destructuring records and objects.

## 3. Design System & Theming (Strict)
* **Centralized Theme:** All styling must reside in `lib/core/theme/`.
    * `app_theme.dart`: Main `ThemeData` configuration.
    * `app_colors.dart`: Raw color palette (Private/Static).
    * `app_typography.dart`: Text styles.
* **ThemeExtensions:**
    * Use `ThemeExtension` for custom semantic colors and styles.
    * **NEVER** usage of `Colors.red`, `Colors.blue`, or hex codes in Widgets.
    * *Correct:* `color: context.colors.errorSurface`
    * *Incorrect:* `color: Colors.red`
* **Typography:**
    * **NEVER** use raw `TextStyle(...)` in Widgets.
    * Use `context.textTheme.bodyMedium!.copyWith(...)` only if absolutely necessary to override a specific property (like color).
* **Dimensions & Spacing:**
    * Use a standardized spacing class (e.g., `AppSpacing.md` or `16`) rather than magic numbers.

## 4. UI & Widget Guidelines
* **No Helper Methods:** NEVER use private `_build*` methods (e.g., `_buildHeader()`) to return widgets. Extract them into separate `StatelessWidget` classes.
* **Row/Column Spacing:** Use the `spacing` parameter for gaps between children. **Do not** use `SizedBox` for spacing.
    * *Good:* `Column(spacing: AppSpacing.md, children: [...])`
    * *Bad:* `Column(children: [Widget(), SizedBox(height: 16), Widget()])`
* **Performance Optimizations:**
    * **Const Correctness:** Use `const` constructors everywhere possible.
    * **Specialized Widgets:**
        * Use `ColoredBox` instead of `Container` for simple colors.
        * Use `DecoratedBox` instead of `Container` for simple decorations.

## 5. Test Coverage & Structure (Strict)
* **Mirroring Rule:** Every source file in `lib/` MUST have a corresponding test file in `test/` mimicking the exact folder structure.
    * *Source:* `lib/features/home/presentation/blocs/home_bloc.dart`
    * *Test:* `test/features/home/presentation/blocs/home_bloc_test.dart`
* **Naming Conventions:**
    * **File:** `{original_name}_test.dart`
    * **Group:** `group('$ClassName', ...)`
    * **Tests:** Descriptive and behavior-focused.
* **Methodology:**
    * **Unit Tests:** Use `bloc_test` package for testing Blocs/Cubits.
    * **Widget Tests:** Use `BlocProvider.value` to inject mock Blocs into the widget tree.
    * **Mocking:** Use `mocktail` or `mockito`.

## 6. State Management (Bloc / Cubit)
* **Selection:**
    * Use **Cubit** for simple state streams (Boolean toggles, simple data fetching).
    * Use **Bloc** for complex, event-driven logic (Debouncing, distinct events, transforming streams).
* **Structure:**
    * **Events & States:** Must use `sealed class` or `Freezed` unions to ensure exhaustiveness.
    * **Equality:** All States/Events must extend `Equatable` (or use `Freezed`) to prevent unnecessary rebuilds.
* **UI Implementation:**
    * **Build:** Use `BlocBuilder` or `BlocSelector` for drawing widgets based on state.
    * **Side Effects:** Use `BlocListener` for navigation, Snackbars, or Dialogs. **NEVER** perform side effects inside `build()`.
    * **Combined:** Use `BlocConsumer` only when you need both building and listening.
* **Logic Separation:**
    * UI Widgets should only dispatch events (e.g., `context.read<HomeBloc>().add(LoadData())`).
    * All business logic resides in the Bloc/Cubit.

## 7. Localization (Strict)
* **No Hardcoded Strings:** String literals in UI are forbidden.
* **Usage pattern:**
    * Define keys in `lib/l10n/app_en.arb`.
    * Access via: `final l10n = AppLocalizations.of(context)!;` (or `context.l10n`).
    * Use: `Text(l10n.welcomeMessage)`

## 8. Git & Version Control (Conventional Commits)
* **Pattern:** `<type>(<scope>): <short description>`
* **Allowed Types:** `feat`, `fix`, `chore`, `refactor`, `test`, `style`, `docs`, `perf`.
* **Rules:**
    * Use imperative mood ("add" not "added").
    * No period at the end of the subject.
    * Keep the first line under 72 characters.
    * *Example:* `feat(auth): add google sign-in button`

## 9. Dependency Management (Strict)
* **Selection Criteria:**
    * **Latest Versions:** Always use the latest stable version of packages.
    * **Pub Score:** Prioritize packages with the maximum pub points and high popularity.
    * **Maintenance:** Do NOT use deprecated or abandoned packages.

## 10. Code Quality & Formatting
* **Zero Warnings:** Code must pass `dart analyze` with zero errors or warnings.
* **Formatting:** All code must be formatted via `dart format .`.

## 11. AI Agent Instructions (Meta-Rules)
* **Test Generation:** When generating a Bloc/Cubit, you MUST immediately generate its corresponding `bloc_test` file.
* **Theme Enforcement:** Refactor any raw colors/styles (`Colors.blue`) to use the Design System.
* **Pre-Computation Checks:** Before declaring a task complete, verify:
    1.  Did I extract helper methods into Classes?
    2.  Did I use `BlocBuilder`/`BlocListener` correctly?
    3.  Is every string localized?
    4.  Did I generate the test file?