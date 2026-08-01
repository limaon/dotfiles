# Test Coverage Standards

## Requirements

- Every testing objective needs at least ONE positive test (success case) and ONE negative test (failure/invalid input case)
- Each test includes a comment explaining how it meets the objective
- Use the Arrange-Act-Assert pattern for all tests
- Mock external dependencies and API calls
- Deterministic tests: avoid network and time flakiness

## Coverage

- Cover acceptance criteria, edge cases, and error handling
- Prefer TDD when a tests/ directory exists

## Execution

- Run relevant tests after each change
- Fix lints before finalizing
- Report pass/fail concisely
