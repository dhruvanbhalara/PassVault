---
name: ui_standardization
description: Maintain UI consistency, performance, and design system adherence.
---

# UI Standardization Skill

This skill enforces the "UI Performance & Design System" rules from `flutter_rules.md`.

## Core Rules

1.  **No Magic Spacing**: Use `spacing` parameters in Rows/Columns or `AppSpacing` tokens. NEVER hardcode pixel values (e.g., `SizedBox(height: 10)`).
2.  **Widget Extraction**: Extract complex sub-trees into separate `StatelessWidget` classes. Private `_buildX` methods are strictly forbidden.
3.  **Repaint Boundaries**: Wrap heavy animations or independent UI branches in `RepaintBoundary` to optimize frame budgets.
4.  **Theming**: Use `ThemeExtensions` for semantic colors. Raw Material colors (`Colors.red`) are prohibited. Use `context.colors.primary` instead of `Theme.of(context).primaryColor`.
5.  **Aesthetics**: Always prioritize "Wow UI" with smooth gradients, micro-animations, and premium typography as per Web Application Development guidelines.

## Audit Checklist

### 1. Spacing Audit
-   Search for hardcoded `SizedBox` or `Padding` values.
-   Ensure `AppSpacing` or similar tokens are used.

### 2. Composition Audit
-   Are there any private `_build...` methods in widgets?
-   Convert them to separate `StatelessWidget` classes for better performance and readability.

### 3. Performance Audit
-   Are `RepaintBoundary` widgets used for animations or complex static regions?
-   Ensure `const` constructors are used wherever possible.

### 4. Theming Audit
-   Are raw colors (`Colors.blue`) used?
-   Replace with `ThemeExtension` or `ColorScheme` references.

## Implementation Examples

### Good: Widget Extraction & Spacing Tokens
```dart
class VaultCard extends StatelessWidget {
  const VaultCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const VaultHeader(),
        AppSpacing.vGapMedium, // Good: Spacing token
        const VaultDetails(),
      ],
    );
  }
}
```

### Bad: Magic Spacing & build methods
```dart
Widget _buildHeader() { // ERROR: Private build method forbidden
  return Padding(
    padding: EdgeInsets.all(12), // ERROR: Magic number
    child: Text('Vault'),
  );
}
```
