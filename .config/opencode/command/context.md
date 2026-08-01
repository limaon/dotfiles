---
description: Context system manager - harvest summaries, extract knowledge, organize context
---

# Context Manager

## Critical Rules (Absolute Priority, Strict Enforcement)

1. **MVI Strict**: Files MUST be <200 lines. Extract core concepts only (1-3 sentences), 3-5 key points, minimal example, reference link.
2. **Approval Gate**: ALWAYS present approval UI before deleting/archiving files. Letter-based selection (A B C or 'all'). NEVER auto-delete.
3. **Function Structure**: ALWAYS organize by function: `concepts/`, `examples/`, `guides/`, `lookup/`, `errors/` (not flat files).
4. **Lazy Load**: ALWAYS read required context files from `~/.config/opencode/context/core/context-system/` BEFORE executing operations.

## Execution Priority

**Tier 1 - Safety & MVI:**

- Files <200 lines (MVI Strict)
- Show approval before cleanup (Approval Gate)
- Function-based structure (Function Structure)
- Load context before operations (Lazy Load)

**Tier 2 - Core Operations:**

- Harvest (default), Extract, Organize, Update workflows

**Tier 3 - Enhancements:**

- Cross-references, validation, navigation

**Conflict resolution**: Tier 1 always overrides Tier 2/3.

**Arguments**: `$ARGUMENTS`

---

## Default Behavior (No Arguments)

When invoked without arguments: `/context`

### Stage 1: Quick Scan

Scan workspace for summary files:

- `*OVERVIEW.md`, `*SUMMARY.md`, `SESSION-*.md`, `CONTEXT-*.md`
- Files in `.tmp/` directory
- Files >2KB in root directory

### Stage 2: Report

Show what was found:

```
Quick scan results:

Found 3 summary files:
   CONTEXT-SYSTEM-OVERVIEW.md (4.2 KB)
   SESSION-auth-work.md (1.8 KB)
   .tmp/NOTES.md (800 bytes)

Recommended action:
  /context harvest  - Clean up summaries -> permanent context

Other options:
  /context extract {source}  - Extract from docs/code
  /context organize {category}  - Restructure existing files
  /context help  - Show all operations
```

**Purpose**: Quick tidy-up. Default assumes you want to harvest summaries and compact workspace.

---

## Operations

### Primary: Harvest & Compact (Default Focus)

**`/context harvest [path]`** Most Common

- Extract knowledge from AI summaries -> permanent context
- Clean workspace (archive/delete summaries)
- **Reads**: `operations/harvest.md` + `standards/mvi.md`

**`/context compact {file}`**

- Minimize verbose file to MVI format
- **Reads**: `guides/compact.md` + `standards/mvi.md`

---

### Secondary: Custom Context Creation

**`/context extract from {source}`**

- Extract context from docs/code/URLs
- **Reads**: `operations/extract.md` + `standards/mvi.md` + `guides/compact.md`

**`/context organize {category}`**

- Restructure flat files -> function-based folders
- **Reads**: `operations/organize.md` + `standards/structure.md`

**`/context update for {topic}`**

- Update context when APIs/frameworks change
- **Reads**: `operations/update.md` + `guides/workflows.md`

**`/context error for {error}`**

- Add recurring error to knowledge base
- **Reads**: `operations/error.md` + `standards/templates.md`

**`/context create {category}`**

- Create new context category with structure
- **Reads**: `guides/creation.md` + `standards/structure.md` + `standards/templates.md`

---

### Utility Operations

**`/context map [category]`**

- View current context structure, file counts

**`/context validate`**

- Check integrity, references, file sizes

**`/context help`**

- Show all operations with examples

---

## Lazy Loading Strategy

| Operation | Files to read                                                                           |
| --------- | --------------------------------------------------------------------------------------- |
| default   | `operations/harvest.md`, `standards/mvi.md`                                             |
| harvest   | `operations/harvest.md`, `standards/mvi.md`, `guides/workflows.md`                      |
| compact   | `guides/compact.md`, `standards/mvi.md`                                                 |
| extract   | `operations/extract.md`, `standards/mvi.md`, `guides/compact.md`, `guides/workflows.md` |
| organize  | `operations/organize.md`, `standards/structure.md`, `guides/workflows.md`               |
| update    | `operations/update.md`, `guides/workflows.md`, `standards/mvi.md`                       |
| error     | `operations/error.md`, `standards/templates.md`, `guides/workflows.md`                  |
| create    | `guides/creation.md`, `standards/structure.md`, `standards/templates.md`                |

**All files located in**: `~/.config/opencode/context/core/context-system/`

---

## Subagent Routing

- **`harvest`, `extract`, `organize`, `update`, `error`, `create`** -> **ContextOrganizer**
  - Pass: operation name, arguments, lazy load map
  - Subagent loads: required context files from `~/.config/opencode/context/core/context-system/`
  - Subagent executes: multi-stage workflow per operation

- **`map`, `validate`** -> **ContextScout**
  - Pass: operation name, arguments
  - Subagent executes: read-only analysis and reporting

---

## Quick Reference

### Structure

```
~/.config/opencode/context/core/context-system/
├── operations/     # How to do things (harvest, extract, organize, update)
├── standards/      # What to follow (mvi, structure, templates)
└── guides/         # Step-by-step (workflows, compact, creation)
```

### MVI Principle (Quick)

- Core concept: 1-3 sentences
- Key points: 3-5 bullets
- Minimal example: <10 lines
- Reference link: to full docs
- File size: <200 lines

### Function-Based Structure (Quick)

```
{category}/
├── navigation.md       # Navigation
├── concepts/       # What it is
├── examples/       # Working code
├── guides/         # How to
├── lookup/         # Quick reference
└── errors/         # Common issues
```

---

## Examples

### Default (Quick Scan)

```bash
/context
# Scans workspace, suggests harvest if summaries found
```

### Harvest Summaries

```bash
/context harvest
/context harvest .tmp/
/context harvest OVERVIEW.md
```

### Extract from Docs

```bash
/context extract from docs/api.md
/context extract from https://react.dev/hooks
```

### Organize Existing

```bash
/context organize development/
/context organize development/ --dry-run
```

### Update for Changes

```bash
/context update for Next.js 15
/context update for React 19 breaking changes
```

---

## Success Criteria

After any operation:

- [ ] All files <200 lines? (MVI Strict)
- [ ] Function-based structure used? (Function Structure)
- [ ] Approval UI shown for destructive ops? (Approval Gate)
- [ ] Required context loaded? (Lazy Load)
- [ ] `navigation.md` updated?
- [ ] Files scannable in <30 seconds?

---

## Full Documentation

**Context System Location**: `~/.config/opencode/context/core/context-system/`

**Structure**:

- `operations/` - Detailed operation workflows
- `standards/` - MVI, structure, templates
- `guides/` - Interactive examples, creation standards

**Read before using**: `standards/mvi.md` (understand Minimal Viable Information principle)
