
# Flutter & Dart Coding Standards (PassVault Project)

## 1. Project Architecture & Organization
* **Feature-First Clean Architecture:**
    * `lib/features/<feature>/data/`: Data sources, DTOs, Repository Implementations.
    * `lib/features/<feature>/domain/`: Entities, Enums, Repository Interfaces, UseCases.
    * `lib/features/<feature>/presentation/`: Pages, Widgets, BLoCs/Cubits.
    * `lib/core/`: Shared utilities, themes, global providers, and DI setup.
* **SOLID Principles:**
    * **Single Responsibility:** One class = one purpose.
    * **Dependency Inversion:** Depend on abstractions (Interfaces), not implementations.
    * **Interface Segregation:** Keep interfaces focused.

## 2. Dart 3+ & Language Features
* **Sealed Classes (Union Types):**
    * Use `sealed class` for state hierarchies (e.g., `AuthState`) or fixed polymorphic types.
    * **Requirement:** Exhaustive `switch` expressions must be used to handle these states.
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
* **Row/Column Spacing:** Use the `spacing` parameter for gaps between children. **Do not** use `SizedBox` for spacing unless necessary for specific layouts not covered by `spacing`.
* **Performance Optimizations:**
    * **Const Correctness:** Use `const` constructors everywhere possible.
    * **Specialized Widgets:**
        * Use `ColoredBox` instead of `Container` for simple colors.
        * Use `DecoratedBox` instead of `Container` for simple decorations.

## 5. Test Coverage & Structure (Strict)
* **Mirroring Rule:** Every source file in `lib/` MUST have a corresponding test file in `test/` mimicking the exact folder structure.
* **Naming Conventions:**
    * **File:** `{original_name}_test.dart`
    * **Group:** `group('$ClassName', ...)`
* **Methodology:**
    * Follow **Arrange-Act-Assert** (AAA).
    * Test business logic in isolation (Unit Tests).
    * Test UI interactions and state (Widget Tests).

## 6. State Management (flutter_bloc 8+)
* **Pattern:** BLoC (Business Logic Component)
    * **Events:** Define user actions or system events as `Equatable` classes (or sealed classes).
    * **States:** Define UI states as `Equatable` classes (or sealed classes).
    * **BLoC:** Handle events and emit states. Use `on<Event>` handlers.
* **Structure:**
    * Place BLoCs in `lib/features/<feature>/presentation/bloc/`.
* **Usage:**
    * Use `BlocProvider` to inject BLoCs.
    * Use `BlocBuilder`, `BlocListener`, or `BlocConsumer` in UI.
    * **NEVER** put business logic inside UI widgets; dispatch events instead.
* **Dependency Injection:**
    * Use `@injectable` to register BLoCs.
    * Inject `UseCases` or `Repositories` into BLoCs.

## 7. Localization (Strict)
* **No Hardcoded Strings:** String literals in UI are forbidden.
* **Usage pattern:**
    * Define keys in `lib/l10n/app_en.arb`.
    * Access via: `final l10n = AppLocalizations.of(context)!;` (or `context.l10n`).
    * Use: `Text(l10n.welcomeMessage)`

## 8. AI Agent Instructions (Meta-Rules)
* **Test Generation:** When generating a new Dart file, you MUST immediately generate its corresponding test file in the mirrored `test/` directory.
* **Theme Enforcement:** Refactor any raw colors/styles to use the Design System (`context.colors...`).
* **Pre-Computation Checks:** Before declaring a task complete, verify:
    1.  Did I extract helper methods into Classes?
    2.  Is the Design System used?
    3.  Is every string localized?
    4.  Did I generate the test file?
