# Context Index

Central standards and workflows for OpenCode agents. Load only what the current task needs (lazy loading).

## Standards (fixed rules)

| File                                  | When to load                                                          |
| ------------------------------------- | --------------------------------------------------------------------- |
| `core/standards/code-quality.md`      | Before any code implementation (write/edit)                           |
| `core/standards/documentation.md`     | Before creating/editing documentation                                 |
| `core/standards/test-coverage.md`     | Before writing tests                                                  |
| `core/standards/security-patterns.md` | Before implementing code handling user input, auth, or sensitive data |

## Workflows (processes)

| File                                   | When to load                                       |
| -------------------------------------- | -------------------------------------------------- |
| `core/workflows/code-review.md`        | Before reviewing code                              |
| `core/workflows/task-delegation.md`    | Before delegating tasks to subagents (`task` tool) |
| `core/workflows/component-planning.md` | Before planning multi-component implementations    |

## Usage rules

- NEVER load all files - only the one(s) applicable to the current task.
- Domain-specific context (UI/UX, Next.js, etc.) is loaded via Skills, not context files.
