# Code Quality Standards

## Principles

- Modular, functional code following the project's language conventions
- Type-safe when the language supports it
- Separation of concerns (SOLID)
- Prefer declarative over imperative
- Descriptive naming (verbs for functions, nouns for variables)
- Small functions with a single purpose

## Comments

- Minimal, high-signal only; explain non-obvious logic
- NEVER restate what the function name already says
- Remove commented-out code

## Errors

- Handle errors properly; anticipate failures
- Never swallow exceptions silently

## Validation

- After implementing: type check + lint + build + relevant tests
- When fixing bugs: reproduce first, then fix, then verify the fix
- Test behavior, not implementation
