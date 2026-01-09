---
description: How to refactor UI to use the PassVault Design System
---

# Refactor to Design System Skill

This skill guides the migration of legacy Flutter widgets to `PassVault` Design System components.

## 1. Mapping Table
Use this table to find the correct replacement for standard Flutter widgets.

| Legacy Widget | Design System Component | Path |
| :--- | :--- | :--- |
| `ElevatedButton` | `AppButton` | `lib/core/design_system/components/buttons/app_button.dart` |
| `TextButton` | `AppTextButton` | `lib/core/design_system/components/buttons/app_text_button.dart` |
| `CircularProgressIndicator` | `AppLoader` | `lib/core/design_system/components/feedback/app_loader.dart` |
| `Card`, `Container` (decoration) | `AppCard` | `lib/core/design_system/components/layout/app_card.dart` |
| `TextField`, `TextFormField` | `AppTextField` | `lib/core/design_system/components/inputs/app_text_field.dart` |
| `Colors.blue`, `Colors.red`, etc. | `AppColors.<color>` | `lib/core/design_system/theme/app_colors.dart` |
| `16.0`, `8.0`, etc. | `AppSpacing.<size>` | `lib/core/design_system/theme/app_dimensions.dart` |

## 2. Refactoring Steps

1.  **Identify**: Locate widgets in `lib/features/.../presentation/screens` using legacy components.
2.  **Import**: Add `import 'package:passvault/core/design_system/components/components.dart';`.
3.  **Replace**: Swap the widget with its Design System equivalent.
    *   *Example*:
        ```dart
        // Before
        ElevatedButton(onPressed: () {}, child: Text('Save'))

        // After
        AppButton(text: 'Save', onPressed: () {})
        ```
4.  **Remove Styles**: Remove ad-hoc styles (`style: ElevatedButton.styleFrom(...)`). The DS component handles theming.
5.  **Verify**:
    *   Check for compile errors.
    *   Run widget tests.
    *   Visually verify that the component matches the App Theme.
