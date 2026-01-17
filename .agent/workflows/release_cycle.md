---
description: Standardized procedure for a fresh project release.
---

# Release Cycle Workflow

This workflow guides you through releasing a new version of the PassVault app.

// turbo-all

## Steps

1.  **Version Bump**:
    -   Update `version` in `pubspec.yaml`.
    -   Update build number (e.g., `1.0.0+1` -> `1.0.1+2`).

2.  **Changelog Update**:
    -   Summarize changes since the last tag.
    -   Update `CHANGELOG.md`.

3.  **Produce Builds**:
    ```bash
    make build_apk_prod
    make build_ipa_prod
    ```

4.  **Verification**:
    -   Verify the artifacts in `build/app/outputs/flutter-apk/` and `build/ios/ipa/`.

5.  **Tagging & Pushing**:
    -   Commit the version bump.
    -   Tag the commit: `git tag v[version]`.
    -   Push: `git push origin master --tags`.

6.  **CI Release**:
    -   Ensure the `release.yaml` workflow triggers and creates the GitHub Release with the produced artifacts.
