---
description: Generate a conventional commit message for currently staged dotfiles
---

Run these steps in order.

### 1. Inspect Staged Changes

- Run: `git --git-dir=${XDG_CONFIG_HOME:-$HOME/.config}/dotfiles/ --work-tree=$HOME diff --cached`
- Review only the changes already in the staging area.
- If no files are staged, stop and ask the user to stage the intended files.
- **Never** run `git add` or stage any files.

### 2. Pre-commit Validation (Staged Scripts Only)

- For staged files in `~/.local/bin` or with `.sh` extension:
  - Run `shellcheck <file>` or `bash -n <file>` for syntax checking.
  - **Stop and report** if any errors are found before proceeding.

### 3. Generate Commit Message

- Format: `<type>(<scope>): <description>`
- **Types:** `feat`, `fix`, `refactor`, `style`, `docs`, `perf`, `test`, `chore`
- **Scopes:** `bin` for `~/.local/bin`, app name (e.g., `nvim`, `bash`, `tmux`, `kitty`), or omit/use general scope if multi-app.
- **Rules:** English, imperative mood ("add", not "added"), concise subject line under 72 chars.

### 4. Execute Commit (or Propose Message)

- Commit: `git --git-dir=${XDG_CONFIG_HOME:-$HOME/.config}/dotfiles/ --work-tree=$HOME commit -m "<message>"`
- Show the resulting commit hash.

## Final Notes

- **Never stage files:** Do not use `git add`.
- **Do not push** unless explicitly requested.
