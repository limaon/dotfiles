---
description: Create well-formatted commits with conventional commit messages for my dotfiles
---

# Dotfiles Commit Command

You are an AI agent specialized in managing dotfiles using a Bare Git Repository. Follow these instructions exactly.

## Environment Configuration

* **Git Command:** `git --git-dir=${XDG_CONFIG_HOME:-$HOME/.config}/dotfiles/ --work-tree=$HOME`
* **Scripts Location:** `~/.local/bin`
* **Config Files Location:** `~/.config`

## Instructions for Agent

1. **Check command mode**:
* If user provides `$ARGUMENTS`, skip to step 4.


2. **Pre-commit validation (Tracked Files Only)**:
* Identify files in `~/.local/bin` or with `.sh` extension that are **staged or already tracked** by the repository.
* **Ignore any untracked files** in these directories.
* For the identified tracked/staged scripts:
* Run `shellcheck <file>` for deep analysis.
* If `shellcheck` is missing, run `bash -n <file>` for syntax checking.


* **Stop and report** any errors or warnings before proceeding.


3. **Analyze git status**:
* Run: `git --git-dir=${XDG_CONFIG_HOME:-$HOME/.config}/dotfiles/ --work-tree=$HOME status --porcelain`
* If no files are staged, ask which specific files to add. **Strictly avoid `add .**` to protect untracked personal files in `$HOME`.


4. **Analyze the changes**:
* Run: `git --git-dir=${XDG_CONFIG_HOME:-$HOME/.config}/dotfiles/ --work-tree=$HOME diff --cached`
* Identify if it's a script update, a config change, or a fix.


5. **Generate commit message**:
* **Format:** `<type>(<scope>): <description>`
* **Scopes:** Use `bin` for `~/.local/bin`, or app names (e.g., `nvim`, `bash`, `tmux`).
* **Language:** English (imperative mood, concise).


6. **Execute the commit**:
* Commit: `git --git-dir=${XDG_CONFIG_HOME:-$HOME/.config}/dotfiles/ --work-tree=$HOME commit -m "<message>"`
* Provide the commit hash and a summary.


7. **Synchronize with remote**:
* Run: `git --git-dir=${XDG_CONFIG_HOME:-$HOME/.config}/dotfiles/ --work-tree=$HOME pull --rebase`
* **Stop and report** if there are merge conflicts.
