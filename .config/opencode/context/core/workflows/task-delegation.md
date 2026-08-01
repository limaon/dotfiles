# Task Delegation Workflow

## When to delegate (via `task` tool)

Delegate to a subagent when:

- 4+ files, OR >60 min, OR multi-step dependencies
- Specialized knowledge the primary agent lacks
- Independent review (fresh eyes)
- Explicit user request

Execute directly when:

- 1-3 files, straightforward implementation
- Clear bug fix
- Simple enhancement

## How to delegate

1. Choose the appropriate `subagent_type` (domain specialist)
2. Detailed prompt including:
   - Required context (paths of context/standards to load)
   - Requirements and acceptance criteria
   - Expected deliverables and output format
   - Constraints/risks
3. Verify the subagent's result before considering the task complete

## Rules

- Always tell the subagent WHICH context/standard to load
- Don't duplicate the subagent's work after delegating
- Trust the output but validate
