---
description: How to implement localization and avoid hardcoded strings
---

# Localize App Skill

This skill outlines the standard process for internationalization (i18n) in `PassVault`.

## 1. Zero Hardcoded Strings Policy
**NEVER** use hardcoded strings in the UI.
*   ❌ `Text('Settings')`
*   ✅ `Text(l10n.settings)`

## 2. Implementation Steps

### Step 1: Add Key to ARB
Open `lib/l10n/app_en.arb` and add your new key-value pair in camelCase.
```json
{
  "settingsTitle": "Settings",
  "@settingsTitle": {
    "description": "Title for the settings screen"
  },
  "saveButton": "Save",
  "@saveButton": {
    "description": "Label for save button"
  }
}
```

### Step 2: Generate Code
Run the build runner or standard flutter gen command (usually automatic on save in VS Code, or `flutter gen-l10n`).

### Step 3: Use in Code
Access the string via `AppLocalizations`.

**Pattern A (Variable)**:
```dart
final l10n = AppLocalizations.of(context)!;
return Text(l10n.settingsTitle);
```

**Pattern B (Direct)**:
```dart
Text(AppLocalizations.of(context)!.saveButton)
```

## 3. Parametrized Messages
For dynamic strings, use placeholders.

**ARB**:
```json
{
  "welcomeMessage": "Welcome back, {userName}!",
  "@welcomeMessage": {
    "placeholders": {
      "userName": {
        "type": "String"
      }
    }
  }
}
```

**Dart**:
```dart
Text(l10n.welcomeMessage('Dhruvan'))
```

## 4. Checklist
- [ ] Added key to `app_en.arb`.
- [ ] Added description metadata in ARB.
- [ ] Verified no hardcoded string remains in widget.
- [ ] Verified context accessing loc is valid (under MaterialApp).
