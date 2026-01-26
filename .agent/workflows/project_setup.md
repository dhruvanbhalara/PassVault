---
description: Onboarding and setup for a new development environment.
---

# Project Setup Workflow

Get the PassVault development environment ready for work.

// turbo-all

## Steps

1.  **Clone & Fetch**:
    ```bash
    git clone [repo_url]
    cd passvault
    ```

2.  **Configure Hooks**:
    Enable the specialized Git hooks for pre-commit and pre-push checks.
    ```bash
    make setup_hooks
    ```

3.  **Install Dependencies**:
    ```bash
    flutter pub get
    ```
    (Optional: `make pod_install` for macOS/iOS developers).

4.  **Initial Generation**:
    Run code generation for BLoCs, Models, and Localizations.
    ```bash
    make generate
    ```

5.  **Verification**:
    Run a full lint and test pass to ensure everything is working correctly.
    ```bash
    make lint
    make test
    ```

6.  **Explore Standards**:
    Familiarize yourself with:
    -   `.agent/GEMINI.md`
    -   `flutter_rules.md` (Agency Protocol)
    -   `.agent/skills/`
    -   `.agent/workflows/`
