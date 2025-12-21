---
trigger: always_on
---

# Flutter & Dart Coding Standards (Portfolio Project)

## 1. Project Architecture & Organization
* **Feature-First Clean Architecture:**
    * `lib/features/<feature>/data/`: Data sources, DTOs, Repository Implementations.
    * `lib/features/<feature>/domain/`: Entities, Enums, Repository Interfaces.
    * `lib/features/<feature>/presentation/`: Pages, Widgets, Providers/Controllers.
    * `lib/core/`: Shared utilities, themes, and global providers.
* **SOLID Principles:**
    * **Single Responsibility:** One class = one purpose.
    * **Dependency Inversion:** Depend on abstractions (Interfaces), not implementations.
    * **Interface Segregation:** Keep interfaces focused (e.g., `PortfolioRepository`).

## 2. Dart 3+ & Language Features
* **Sealed Classes (Union Types):**
    * Use `sealed class` for state hierarchies (e.g., `PortfolioState`) or fixed polymorphic types.
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
    * Use a standardized spacing class (e.g., `AppSpacing.md` or `16`) rather than magic numbers, unless the specific layout requires a unique pixel value.

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
    * *Source:* `lib/features/home/presentation/widgets/skills_grid.dart`
    * *Test:* `test/features/home/presentation/widgets/skills_grid_test.dart`
* **Naming Conventions:**
    * **File:** `{original_name}_test.dart`
    * **Group:** `group('$ClassName', ...)`
    * **Tests:** Descriptive and behavior-focused.
* **Methodology:**
    * Follow **Arrange-Act-Assert** (AAA).
    * Test business logic in isolation (Unit Tests).
    * Test UI interactions and state (Widget Tests).

## 6. State Management (Riverpod 2.0)
* **Generator Syntax:** Always use `@riverpod` annotations.
* **Usage:**
    * Use `ref.watch` in `build()` for UI updates.
    * Use `ref.read` in callbacks.
    * Separate logic into Notifiers/Controllers; never keep logic in UI widgets.

## 7. Localization (Strict)
* **No Hardcoded Strings:** String literals in UI are forbidden.
* **Usage pattern:**
    * Define keys in `lib/l10n/app_en.arb`.
    * Access via: `final l10n = AppLocalizations.of(context)!;` (or `context.l10n`).
    * Use: `Text(l10n.welcomeMessage)`

## 8. AI Agent Instructions (Meta-Rules)
* **Test Generation:** When generating a new Dart file, you MUST immediately generate its corresponding test file in the mirrored `test/` directory.
* **Theme Enforcement:** If you see `Colors.blue` or `TextStyle(fontSize: 20)` in the code, Refactor it to use the Design System (`context.colors.primary`, `context.textTheme.titleLarge`).
* **Pre-Computation Checks:** Before declaring a task complete, verify:
    1.  Did I extract helper methods into Classes?
    2.  Is the Design System used (No raw colors/styles)?
    3.  Is every string localized?
    4.  Did I generate the test file?