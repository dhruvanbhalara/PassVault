---
description: How to add a new atom/component to the Design System
---

# Add Design System Component Skill

This skill outlines the steps to add a new reusable component to the `PassVault` Design System.

## 1. Categorization
Determine the category for the new component:
- **Buttons**: `lib/core/design_system/components/buttons` (e.g., `AppButton`, `AppTextButton`)
- **Inputs**: `lib/core/design_system/components/inputs` (e.g., `AppTextField`)
- **Layout**: `lib/core/design_system/components/layout` (e.g., `AppCard`)
- **Feedback**: `lib/core/design_system/components/feedback` (e.g., `AppLoader`)

## 2. Implementation
1.  **Create File**: Create `lib/core/design_system/components/<category>/<name>.dart`.
2.  **Use Tokens**:
    *   Colors: `AppColors.<color>` or `context.theme.<color>`.
    *   Spacing: `AppSpacing.<size>`.
    *   Typography: `Theme.of(context).textTheme.<style>`.
3.  **Stateless**: Prefer `StatelessWidget`. Use `StatefulWidget` only for internal animation/interaction state.
4.  **Constructor**: Expose specific properties (e.g., `onPressed`, `label`), NOT generic style objects unless strictly necessary.

## 3. Export
Add the new component export to the central barrel file:
`lib/core/design_system/components/components.dart`

## 4. Testing
Create a widget test in `test/core/design_system/components/<category>/<name>_test.dart`.
- Use `testWidgets`.
- Wrap the widget in `MaterialApp` (or use `pumpApp` helper if available).
- Verify rendering, styling (color/font), and interaction (tap callbacks).

## 5. Checklist
- [ ] Component placed in correct category directory.
- [ ] No hardcoded pixels (used `AppSpacing` or `AppDimensions`).
- [ ] No hardcoded colors (used `AppColors` or `Theme`).
- [ ] Exported in `components.dart`.
- [ ] Widget tests passed.
