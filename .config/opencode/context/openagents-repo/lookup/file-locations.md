# Lookup: File Locations

**Purpose**: Quick reference for finding files

---

## Directory Tree

```
opencode-agents/
 ~/.config/opencode/
    agent/
       core/                    # Core system agents
       development/             # Dev specialists
       content/                 # Content creators
       data/                    # Data analysts
       product/                 # Product managers (ready)
       learning/                # Educators (ready)
       subagents/               # Delegated specialists
           code/                # Code-related
           core/                # Core workflows
           system-builder/      # System generation
           utils/               # Utilities
    command/                     # Slash commands
    context/                     # Shared knowledge
       core/                    # Core standards & workflows
       development/             # Dev context
       content-creation/        # Content creation context
       data/                    # Data context
       product/                 # Product context
       learning/                # Learning context
       openagents-repo/         # Repo-specific context
    prompts/                     # Model-specific variants
    tool/                        # Custom tools
    plugin/                      # Plugins
 evals/
    framework/                   # Eval framework (TypeScript)
       src/                     # Source code
       scripts/                 # Test utilities
       docs/                    # Framework docs
    agents/                      # Agent test suites
        core/                    # Core agent tests
        development/             # Dev agent tests
        content/                 # Content agent tests
 scripts/
    registry/                    # Registry management
    validation/                  # Validation tools
    testing/                     # Test utilities
    versioning/                  # Version management
    docs/                        # Doc tools
    maintenance/                 # Maintenance
 docs/                            # Documentation
    agents/                      # Agent docs
    contributing/                # Contribution guides
    features/                    # Feature docs
    getting-started/             # User guides
 registry.json                    # Component catalog
 install.sh                       # Installer
 VERSION                          # Current version
 package.json                     # Node dependencies
```

---

## Where Is...?

| Component | Location |
|-----------|----------|
| **Core agents** | `~/.config/opencode/agent/core/` |
| **Category agents** | `~/.config/opencode/agent/{category}/` |
| **Subagents** | `~/.config/opencode/agent/subagents/` |
| **Commands** | `~/.config/opencode/command/` |
| **Context files** | `~/.config/opencode/context/` |
| **Prompt variants** | `~/.config/opencode/prompts/{category}/{agent}/` |
| **Tools** | `~/.config/opencode/tool/` |
| **Plugins** | `~/.config/opencode/plugin/` |
| **Agent tests** | `evals/agents/{category}/{agent}/` |
| **Eval framework** | `evals/framework/src/` |
| **Registry scripts** | `scripts/registry/` |
| **Validation scripts** | `scripts/validation/` |
| **Documentation** | `docs/` |
| **Registry** | `registry.json` |
| **Installer** | `install.sh` |
| **Version** | `VERSION` |

---

## Where Do I Add...?

| What | Where |
|------|-------|
| **New core agent** | `~/.config/opencode/agent/core/{name}.md` |
| **New category agent** | `~/.config/opencode/agent/{category}/{name}.md` |
| **New subagent** | `~/.config/opencode/agent/subagents/{category}/{name}.md` |
| **New command** | `~/.config/opencode/command/{name}.md` |
| **New context** | `~/.config/opencode/context/{category}/{name}.md` |
| **Agent tests** | `evals/agents/{category}/{agent}/tests/` |
| **Test config** | `evals/agents/{category}/{agent}/config/config.yaml` |
| **Documentation** | `docs/{section}/{topic}.md` |
| **Script** | `scripts/{purpose}/{name}.sh` |

---

## Specific File Paths

### Core Files

```
registry.json                        # Component catalog
install.sh                           # Main installer
update.sh                            # Update script
VERSION                              # Current version (0.5.0)
package.json                         # Node dependencies
CHANGELOG.md                         # Release notes
README.md                            # Main documentation
```

### Core Agents

```
~/.config/opencode/agent/core/openagent.md
~/.config/opencode/agent/core/opencoder.md
```

### Meta Agents

```
~/.config/opencode/agent/meta/system-builder.md
```

### Development Agents

```
~/.config/opencode/agent/development/frontend-specialist.md
~/.config/opencode/agent/development/backend-specialist.md
~/.config/opencode/agent/development/devops-specialist.md
~/.config/opencode/agent/development/codebase-agent.md
```

### Content Agents

```
~/.config/opencode/agent/content/copywriter.md
~/.config/opencode/agent/content/technical-writer.md
```

### Key Subagents

```
~/.config/opencode/agent/TestEngineer.md
~/.config/opencode/agent/CodeReviewer.md
~/.config/opencode/agent/CoderAgent.md
~/.config/opencode/agent/TaskManager.md
~/.config/opencode/agent/DocWriter.md
```

### Core Context

```
~/.config/opencode/context/core/standards/code-quality.md
~/.config/opencode/context/core/standards/documentation.md
~/.config/opencode/context/core/standards/test-coverage.md
~/.config/opencode/context/core/standards/security-patterns.md
~/.config/opencode/context/core/workflows/task-delegation.md
~/.config/opencode/context/core/workflows/code-review.md
```

### Registry Scripts

```
scripts/registry/validate-registry.sh
scripts/registry/auto-detect-components.sh
scripts/registry/register-component.sh
scripts/registry/validate-component.sh
```

### Validation Scripts

```
scripts/validation/validate-context-refs.sh
scripts/validation/validate-test-suites.sh
scripts/validation/setup-pre-commit-hook.sh
```

### Eval Framework

```
evals/framework/src/sdk/              # Test runner
evals/framework/src/evaluators/       # Rule evaluators
evals/framework/src/collector/        # Session collection
evals/framework/src/types/            # TypeScript types
```

---

## Path Patterns

### Agents

```
~/.config/opencode/agent/{category}/{agent-name}.md
```

**Examples**:
- `~/.config/opencode/agent/core/openagent.md`
- `~/.config/opencode/agent/development/frontend-specialist.md`
- `~/.config/opencode/agent/TestEngineer.md`

### Context

```
~/.config/opencode/context/{category}/{topic}.md
```

**Examples**:
- `~/.config/opencode/context/core/standards/code-quality.md`
- `~/.config/opencode/context/development/react-patterns.md`
- `~/.config/opencode/context/content-creation/principles/copywriting-frameworks.md`

### Tests

```
evals/agents/{category}/{agent-name}/
 config/config.yaml
 tests/{test-name}.yaml
```

**Examples**:
- `evals/agents/core/openagent/tests/smoke-test.yaml`
- `evals/agents/development/frontend-specialist/tests/approval-gate.yaml`

### Scripts

```
scripts/{purpose}/{action}-{target}.sh
```

**Examples**:
- `scripts/registry/validate-registry.sh`
- `scripts/validation/validate-test-suites.sh`
- `scripts/versioning/bump-version.sh`

---

## Naming Conventions

### Files

- **Agents**: `{name}.md` or `{domain}-specialist.md`
- **Context**: `{topic}.md`
- **Tests**: `{test-name}.yaml`
- **Scripts**: `{action}-{target}.sh`
- **Docs**: `{topic}.md`

### Directories

- **Categories**: lowercase, singular (e.g., `development`, `content`)
- **Purposes**: lowercase, descriptive (e.g., `registry`, `validation`)

---

## Quick Lookups

### Find Agent File

```bash
# By name
find ~/.config/opencode/agent -name "{agent-name}.md"

# By category
ls ~/.config/opencode/agent/{category}/

# All agents
find ~/.config/opencode/agent -name "*.md" -not -path "*/subagents/*"
```

### Find Test File

```bash
# By agent
ls evals/agents/{category}/{agent}/tests/

# All tests
find evals/agents -name "*.yaml"
```

### Find Context File

```bash
# By category
ls ~/.config/opencode/context/{category}/

# All context
find ~/.config/opencode/context -name "*.md"
```

### Find Script

```bash
# By purpose
ls scripts/{purpose}/

# All scripts
find scripts -name "*.sh"
```

---

## Related Files

- **Quick start**: `quick-start.md`
- **Categories**: `core-concepts/categories.md`
- **Commands**: `lookup/commands.md`

---

**Last Updated**: 2025-12-10
**Version**: 0.5.0
