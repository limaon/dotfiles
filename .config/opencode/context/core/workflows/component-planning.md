# Component Planning Workflow

## Usage

For multi-component implementations (Auth, DB, UI, etc.).

## Process

1. Decompose the request into functional components with dependencies
2. Define architecture and list components in dependency order
3. For each component: interface, tests, and tasks
4. Present the plan for approval BEFORE implementing
5. Implement incrementally - one component at a time, validating each

## Rules

- NEVER implement the whole plan at once
- Validate each component (type check, lint, test) before proceeding
- Present the master plan for explicit approval
- Integrate and verify compatibility with previous components
