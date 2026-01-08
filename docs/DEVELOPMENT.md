# Development Guide

## Prerequisites

- Flutter SDK `^3.38.5`
- Dart SDK `^3.10.4`
- Android Studio / Xcode
- VS Code (Recommended)

## Setup

```bash
# Clone the repository
git clone https://github.com/dhruvanbhalara/passvault.git
cd passvault

# Install dependencies
flutter pub get

# Generate files (localization, DI, adapters)
make generate

# Setup git hooks (one-time)
make setup_hooks
```

## Build Variants

| Flavor | Description | Command |
|--------|-------------|---------|
| **dev** | Development build with debug tools | `make run_dev` |
| **prod** | Production build, optimized | `make run_prod` |

## Makefile Commands

```bash
# Code Generation
make generate       # Generate l10n, DI, and Hive adapters

# Running
make run_dev        # Run development flavor
make run_prod       # Run production flavor

# Testing
make test           # Run all tests
make test_coverage  # Run tests with coverage

# Launcher Icons
make icons          # Generate icons for both flavors
make icons_dev      # Generate launcher icons (dev)
make icons_prod     # Generate launcher icons (prod)

# Quality
make lint           # Run Flutter analyze
make format         # Format Dart code
make clean          # Clean build artifacts
```

## Git Hooks

Hooks are stored in `.github/hooks/` and enforce code quality.

| Hook | Trigger | Checks |
|------|---------|--------|
| **pre-commit** | Before each commit | `dart format` + `dart analyze` |
| **pre-push** | Before each push | `flutter test` |

> If a hook fails, the git operation is aborted. Fix the issues and retry.

## Localization

PassVault uses Flutter's `intl` package for i18n.

- **Current Languages**: English (en)
- **Adding Languages**: Add a new `.arb` file in `lib/l10n/`

## Environment Configuration

| File | Purpose |
|------|---------|
| `flutter_launcher_icons-dev.yaml` | Dev app icon configuration |
| `flutter_launcher_icons-prod.yaml` | Prod app icon configuration |
