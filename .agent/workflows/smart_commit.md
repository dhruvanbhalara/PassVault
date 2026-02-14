---
description: Standardized procedure for making atomic, scoped commits following Conventional Commits.
---

# Smart Commit Workflow

This workflow ensures that every commit is atomic, scoped, and quality-checked before being added to the history.

// turbo-all

## Steps

1.  **Check Status**:
    View the current state of your workspace to identify logical groups of changes.
    ```bash
    git status
    ```

2.  **Select Scope**:
    Identify the *single* logical change you want to commit.
    -   **Rule**: One commit = One logical change.
    -   **Rule**: Group files by feature/scope (e.g., `auth`, `profile`, `core`).
    -   **Rule**: **Ignore documentation** (e.g., `.md`, `docs/`) unless explicitly specified by the user.
    -   **Action**: Use `git add <file>` for specific files. DO NOT use `git add .` unless all changes are related to the same atomic scope.

3.  **Pre-Commit Quality Gate**:
    Before committing, ensure the staged code is clean.
    ```bash
    dart format .
    flutter analyze
    ```
    *If analysis fails, FIX the issues before proceeding.*

4.  **Construct Commit Message**:
    Follow the **Conventional Commits** pattern: `type(scope): message`
    -   **Types**:
        -   `feat`: A new feature
        -   `fix`: A bug fix
        -   `docs`: Documentation only changes
        -   `style`: Changes that do not affect the meaning of the code (white-space, formatting, etc)
        -   `refactor`: A code change that neither fixes a bug nor adds a feature
        -   `perf`: A code change that improves performance
        -   `test`: Adding missing tests or correcting existing tests
        -   `chore`: Changes to the build process or auxiliary tools and libraries
    -   **Scope**: The module or feature affected (e.g., `auth`, `ui`, `deps`).
    -   **Message**: Concise description of the change (imperative mood, e.g., "add google login" not "added google login").

5.  **Commit**:
    ```bash
    git commit -m "type(scope): message"
    ```

6.  **Verify & Repeat**:
    Check if there are remaining changes.
    ```bash
    git status
    ```
    *If changes remain, repeat steps 2-5 for the next logical scope.*
