---
description: Generate well-formatted conventional commit messages based on staged code changes
---

Analyze the provided code changes and generate semantic commit messages strictly following these instructions. Do not execute git commands; only return the generated messages.

1. **Analyze Staged Files Only**:
   - Strictly evaluate only the files and changes that are currently in the staging area (`git diff --cached`).
   - Completely ignore any unstaged modifications or untracked files.

2. **Analyze and Segment**:
   - Review the staged changes to identify distinct, unrelated logical updates.
   - If multiple unrelated changes exist (e.g., a core feature mixed with an independent bug fix), group them by purpose and generate a separate commit message for each logical group.
   - Briefly specify which files belong to which generated message.

3. **Message Format**:
   - Use the strict format: `<type>: <description>`
   - **Imperative mood**: Write as commands (e.g., "add feature", not "added feature" or "adds feature").
   - **Concise**: Keep the description under 72 characters.

4. **Allowed Types**:
   - `feat`: New features, business logic, UI/UX improvements, types, accessibility.
   - `fix`: Bug fixes, security patches, resolving warnings, CI builds, typos.
   - `docs`: Documentation or source code comments.
   - `style`: Code formatting, structure, animations (no logic change).
   - `refactor`: Restructuring code, removing dead code, architectural changes.
   - `perf`: Performance improvements.
   - `test`: Adding or fixing unit tests, mocks, or snapshots.
   - `chore`: Tooling, dependencies, config files, developer experience, gitignore.
   - `ci`: CI/CD pipeline and deployment changes.
   - `revert`: Reverting previous commits.

## Reference: Good Commit Examples

- feat: add user authentication system
- fix: resolve memory leak in rendering process
- docs: update API documentation with new endpoints
- refactor: simplify error handling logic in parser
- style: reorganize component structure for better readability
- chore: pin dependencies to specific versions
- test: add unit tests for authentication flow
