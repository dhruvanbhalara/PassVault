# 🤖 AGENT INSTRUCTIONS (GEMINI)

**CRITICAL**: You are working on **PassVault Enterprise**. This is a **strict Clean Architecture** project with zero tolerance for technical debt.

## 📌 Primary Directives

1.  **Rule Adherence**: You **MUST** read and follow [Rules](rules/flutter_rules.md) for EVERY task.
2.  **Architecture**: Strict `Presentation -> Domain <- Data` flow. Domain is PURE DART.
3.  **State Management**: **Bloc Event-State ONLY**. No Cubits. No direct method calls.
4.  **Workflow**: Use the **Plan-Act-Reflect** pattern. ALWAYS research first, then create a `task.md` (todo list) and `implementation_plan.md` before writing any code.
5.  **UI Quality**: "WOW" factor is mandatory. Use animations, gradients, and **Atoms Tokens**.
6.  **Test Coverage**: **100% Mirror Rule**. Logic files MUST have matching test files.

## 📂 Key Resources
-   **Rules**: [Rules](rules/flutter_rules.md) (The Source of Truth)
-   **Tech Stack**: [Tech Stack](resources/tech_stack.md)
-   **Checklist**: [Checklist](resources/checklist.md) (RUN THIS BEFORE SUBMITTING)
-   **Anti-Patterns**: [Anti-Patterns](resources/anti_patterns.md) (WHAT NOT TO DO)

## ⚡ Workflow Optimization
-   **Explore**: Use `view_file_outline` or `grep_search` before reading entire multi-thousand-line files.
-   **Plan**: Always start with a `implementation_plan.md`. Request user review for architectural shifts.
-   **Verify**: Run relevant tests immediately after modifying code. Do not wait for the end of the task.
-   **Formatting**: Atomic commits should be preceded by `dart format .`.

## 🛡️ Guardrails
-   **Always**: Run tests before marking a task as complete.
-   **Always**: Use `AppLogger` for debugging; delete leftover prints.
-   **Ask**: If requirements are ambiguous or conflict with [Rules](rules/flutter_rules.md).
-   **Never**: Modify `.agent/` documentation without explicit instruction.
