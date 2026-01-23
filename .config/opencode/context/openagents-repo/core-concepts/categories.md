# Core Concept: Category System

**Purpose**: Understanding how components are organized
**Priority**: HIGH - Load this before adding categories or organizing components

---

## What Are Categories?

Categories are domain-based groupings that organize agents, context files, and tests by expertise area.

**Benefits**:
- **Scalability** - Easy to add new domains
- **Discovery** - Find agents by domain
- **Organization** - Clear structure
- **Modularity** - Install only what you need

---

## Available Categories

### Core (`core/`)
**Purpose**: Essential system agents (always available)

**Agents**:
- openagent, opencoder, system-builder

**When to use**: System-level tasks, orchestration

**Status**:  Stable

---

### Development (`development/`)
**Purpose**: Software development specialists

**Agents**:
- frontend-specialist, backend-specialist, devops-specialist, codebase-agent

**Context**:
- clean-code.md, react-patterns.md, api-design.md

**When to use**: Building applications, dev tasks

**Status**:  Active

---

### Content (`content/`)
**Purpose**: Content creation specialists

**Agents**:
- copywriter, technical-writer

**Context**:
- copywriting-frameworks.md, tone-voice.md

**When to use**: Writing, documentation, marketing

**Status**:  Active

---

### Data (`data/`)
**Purpose**: Data analysis specialists

**Agents**:
- data-analyst

**Context**:
- (Ready for data-specific context)

**When to use**: Data tasks, analysis, reporting

**Status**:  Active

---

### Product (`product/`)
**Purpose**: Product management specialists

**Agents**:
- (Ready for product agents)

**Context**:
- (Ready for product context)

**When to use**: Product strategy, roadmaps, requirements

**Status**: Ready (no agents yet)

---

### Learning (`learning/`)
**Purpose**: Education and coaching specialists

**Agents**:
- (Ready for learning agents)

**Context**:
- (Ready for learning context)

**When to use**: Teaching, training, curriculum

**Status**: Ready (no agents yet)

---

## Category Structure

### Directory Layout

```
.opencode/
 agent/{category}/           # Agents by category
 context/{category}/         # Context by category
 prompts/{category}/         # Prompt variants by category
evals/agents/{category}/        # Tests by category
```

### Example: Development Category

```
.opencode/agent/development/
 0-category.json             # Category metadata
 frontend-specialist.md
 backend-specialist.md
 devops-specialist.md
 codebase-agent.md

.opencode/context/development/
 navigation.md
 clean-code.md
 react-patterns.md
 api-design.md

evals/agents/development/
 frontend-specialist/
 backend-specialist/
 devops-specialist/
 codebase-agent/
```

---

## Category Metadata

### 0-category.json

Each category has a metadata file:

```json
{
  "name": "Development",
  "description": "Software development specialists",
  "icon": "",
  "order": 2,
  "status": "active"
}
```

**Fields**:
- `name`: Display name
- `description`: Brief description
- `icon`: Emoji icon
- `order`: Display order
- `status`: active, ready, planned

---

## Naming Conventions

### Category Names

 **Lowercase** - `development`, not `Development`
 **Singular** - `content`, not `contents`
 **Descriptive** - Clear domain name
 **Consistent** - Follow existing patterns

### Agent Names

 **Kebab-case** - `frontend-specialist.md`
 **Descriptive** - Clear purpose
 **Suffix** - Use `-specialist`, `-agent`, `-writer` as appropriate

### Context Names

 **Kebab-case** - `react-patterns.md`
 **Descriptive** - Clear topic
 **Specific** - Focused on one topic

---

## Path Resolution

The system resolves agent paths flexibly:

### Resolution Order

1. **Check for `/`** - If present, treat as category path
2. **Check core/** - For backward compatibility
3. **Search categories** - Look in all categories
4. **Error** - If not found

### Examples

```bash
# Short ID (backward compatible)
"openagent" → ".opencode/agent/core/openagent.md"

# Category path
"development/frontend-specialist" → ".opencode/agent/development/frontend-specialist.md"

# Subagent path
"TestEngineer" → ".opencode/agent/TestEngineer.md"
```

---

## Adding a New Category

### Step 1: Create Directory Structure

```bash
# Create agent directory
mkdir -p .opencode/agent/{category}

# Create context directory
mkdir -p .opencode/context/{category}

# Create eval directory
mkdir -p evals/agents/{category}
```

### Step 2: Add Category Metadata

```bash
cat > .opencode/agent/{category}/0-category.json << 'EOF'
{
  "name": "Category Name",
  "description": "Brief description",
  "icon": "",
  "order": 10,
  "status": "ready"
}
EOF
```

### Step 3: Add Context README

```bash
cat > .opencode/context/{category}/navigation.md << 'EOF'
# Category Name Context

Context files for {category} specialists.

## Available Context

- (List context files here)

## When to Use

- (Describe when to use this context)
EOF
```

### Step 4: Validate

```bash
# Validate structure
./scripts/registry/validate-component.sh

# Update registry
./scripts/registry/auto-detect-components.sh --auto-add
```

---

## Category Guidelines

### When to Create a New Category

 **Distinct domain** - Clear expertise area
 **Multiple agents** - Plan for 2+ agents
 **Shared context** - Common knowledge to share
 **User demand** - Requested by users

### When NOT to Create a Category

 **Single agent** - Use existing category
 **Overlapping** - Fits in existing category
 **Too specific** - Too narrow focus
 **Unclear domain** - Not well-defined

---

## Category vs Subagent

### Use Category Agent When:
- User-facing specialist
- Broad domain expertise
- Direct invocation by user
- Example: `frontend-specialist`

### Use Subagent When:
- Delegated subtask
- Narrow focus
- Invoked by other agents
- Example: `tester`

---

## Context Organization

### Category Context Structure

```
.opencode/context/{category}/
 navigation.md               # Overview
 {topic-1}.md           # Specific topic
 {topic-2}.md           # Specific topic
 {topic-3}.md           # Specific topic
```

### Context Loading

Agents load category context based on task:

```markdown
<!-- Context: development/react-patterns | Priority: high -->
```

Loads: `.opencode/context/development/react-patterns.md`

---

## Best Practices

### Organization

 **Clear categories** - Well-defined domains
 **Consistent naming** - Follow conventions
 **Proper metadata** - Complete 0-category.json
 **README files** - Document each category

### Scalability

 **Modular** - Categories are independent
 **Extensible** - Easy to add new categories
 **Maintainable** - Clear structure
 **Testable** - Each category has tests

### Discovery

 **Descriptive names** - Clear purpose
 **Good descriptions** - Explain when to use
 **Proper tags** - Aid discovery
 **Documentation** - Document in README

---

## Migration from Flat Structure

### Old Structure (Flat)

```
.opencode/agent/
 openagent.md
 opencoder.md
 frontend-specialist.md
 copywriter.md
```

### New Structure (Category-Based)

```
.opencode/agent/
 core/
    openagent.md
    opencoder.md
 development/
    frontend-specialist.md
 content/
     copywriter.md
```

### Backward Compatibility

Old paths still work:
- `openagent` → resolves to `core/openagent`
- `opencoder` → resolves to `core/opencoder`

New agents use category paths:
- `development/frontend-specialist`
- `content/copywriter`

---

## Common Patterns

### Category with Multiple Agents

```
development/
 0-category.json
 frontend-specialist.md
 backend-specialist.md
 devops-specialist.md
```

### Category with Shared Context

```
context/development/
 navigation.md
 clean-code.md
 react-patterns.md
 api-design.md
```

### Category with Tests

```
evals/agents/development/
 frontend-specialist/
    config/config.yaml
    tests/smoke-test.yaml
 backend-specialist/
 devops-specialist/
```

---

## Related Files

- **Adding agents**: `guides/adding-agent.md`
- **Adding categories**: `guides/add-category.md`
- **Agent concepts**: `core-concepts/agents.md`
- **File locations**: `lookup/file-locations.md`

---

**Last Updated**: 2025-12-10
**Version**: 0.5.0
