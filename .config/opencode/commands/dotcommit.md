---
description: Create organized conventional commits for my dotfiles, grouped by theme
---

Managing dotfiles using a Bare Git Repository. Follow these instructions exactly.

## Environment Configuration

- **Git Command:** `git --git-dir=${XDG_CONFIG_HOME:-$HOME/.config}/dotfiles/ --work-tree=$HOME`
- **Note:** When running git from a shell whose cwd is not `$HOME`, use `git -C "$HOME"` or anchor paths with `:(top)` so pathspecs resolve against the repo root.
- **Scripts Location:** `~/.local/bin`
- **Config Files Location:** `~/.config`

## Commit Workflow

Run these steps in order.

### 1. Inspect Repository State

- Run: `git --git-dir=${XDG_CONFIG_HOME:-$HOME/.config}/dotfiles/ --work-tree=$HOME status`
- Note which files are staged, unstaged (modified), and untracked.
- **Never** use `git add .` or `git add -A` — this would stage untracked personal files in `$HOME`.

### 2. Analyze the Changes

- Run `git diff` (unstaged) and `git diff --cached` (staged) for each group of files.
- Understand the nature of each change before committing: new feature, bug fix, refactor, formatting, or config/tooling update.
- Do not commit blindly — read the diff to classify each change correctly.

### 3. Group Changes by Theme

- Split the changes into logical groups, one theme per commit. Example groups:
  - A script update (`.local/bin`) -> separate commit
  - An app config (`.config/nvim`, `.config/kitty`, ...) -> separate commit
  - Formatting/normalization across many files -> separate commit
- If unsure how to group, present the proposed groups to the user and let them decide.
- Do not mix unrelated changes in a single commit.

### 4. Stage Selectively and Commit Each Group

For each group, in order:

- Stage only the files in that group:
  - `git --git-dir=${XDG_CONFIG_HOME:-$HOME/.config}/dotfiles/ --work-tree=$HOME add <file1> <file2>`
- Review what is staged: `git diff --cached --stat`
- Commit with a conventional message.

### 5. Generate Commit Messages

- **Format:** `<type>(<scope>): <description>`
- **Types:** `feat` (new), `fix` (bug), `refactor` (restructure), `style` (formatting/normalization), `docs`, `perf`, `test`, `chore` (config/tooling)
- **Scopes:** `bin` for `~/.local/bin`, app names (e.g., `nvim`, `bash`, `tmux`, `kitty`), or `opencode` for opencode config.
- **Language:** English, imperative mood, concise first line.

### 6. Execute Each Commit

- Commit: `git --git-dir=${XDG_CONFIG_HOME:-$HOME/.config}/dotfiles/ --work-tree=$HOME commit -m "<message>"`
- Show the resulting commit hash.

### 7. Pre-commit Validation (Tracked Scripts Only)

- Identify files in `~/.local/bin` or with `.sh` extension that are **staged or already tracked** by the repository. Ignore untracked files.
- For the identified tracked/staged scripts:
  - Run `shellcheck <file>` for deep analysis.
  - If `shellcheck` is missing, run `bash -n <file>` for syntax checking.
- **Stop and report** any errors or warnings before committing those scripts.

### 8. Verify Clean State

- Run `git status` after all commits.
- Confirm no staged/modified dotfiles remain. If changes are still pending, report them to the user.

## Final Notes

- **Do not push** unless explicitly asked.
- If the user provides `$ARGUMENTS`, use it as the commit message for the first commit and skip the grouping step if only that change is pending.
- **Synchronize with remote** only on request: `git ... pull --rebase`, and stop if there are merge conflicts.
