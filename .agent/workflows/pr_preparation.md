---
description: Standardized procedure for preparing and verifying a Pull Request.
---

# PR Preparation Workflow

This workflow ensures that a PR meets all quality gates before being submitted.

// turbo-all

## Steps

1.  **Sync with Master**:
    ```bash
    git fetch origin
    git rebase origin/master
    ```

2.  **Generate Code**: (If applicable)
    ```bash
    make generate
    ```

3.  **Run Quality Gate**:
    ```bash
    make lint
    make test
    ```

4.  **Format Check**:
    ```bash
    make format
    ```

5.  **Audit Code**:
    Run `/audit` to trigger the [audit_code](file:///Users/dhruvanbhalara/Desktop/Github Projects/passvault/.agent/workflows/audit_code.md) workflow for a final compliance check.

6.  **Create PR Description**:
    Construct a PR body that includes:
    -   Goal of the change.
    -   Reference to issue/task.
    -   Summary of changes.
    -   Verification results (Test coverage, lint status).

7.  **Submit PR**:
    ```bash
    gh pr create --fill
    ```
