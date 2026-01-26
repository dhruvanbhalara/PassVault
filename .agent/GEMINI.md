# 🤖 AGENT INSTRUCTIONS (GEMINI)

**CRITICAL**: You are working on **PassVault Enterprise**. This is a **strict Clean Architecture** project with zero tolerance for technical debt.

## 📌 Primary Directives

1.  **Rule Adherence**: You **MUST** read and follow [flutter_rules.md](.agent/rules/flutter_rules.md) for EVERY task.
2.  **Architecture**: Strict `Presentation -> Domain <- Data` flow. Domain is PURE DART.
3.  **State Management**: **Bloc Event-State ONLY**. No Cubits. No direct method calls.
4.  **UI Quality**: "WOW" factor is mandatory. Use animations, gradients, and **Atoms Tokens** (`AppSpacing`, `AppRadius`).
5.  **Test Coverage**: **100% Mirror Rule**. No logic file exists without a test file. No widget exists without a widget test.

## 📂 Key Resources
-   **Rules**: [.agent/rules/flutter_rules.md](.agent/rules/flutter_rules.md) (The Source of Truth)
-   **Tech Stack**: [.agent/resources/tech_stack.md](.agent/resources/tech_stack.md)
-   **Checklist**: [.agent/resources/checklist.md](.agent/resources/checklist.md) (RUN THIS BEFORE SUBMITTING)
-   **Anti-Patterns**: [.agent/resources/anti_patterns.md](.agent/resources/anti_patterns.md) (WHAT NOT TO DO)

## ⚡ Workflow
For every task:
1.  **Plan**: Create/Update `implementation_plan.md`.
2.  **Execute**: Modify code, following the `50-line widget limit` and `Event-State` rules.
3.  **Verify**: Run tests, check strict linting, and verify UI tokens.
4.  **Reflect**: Consult `checklist.md` to ensure nothing was missed.
