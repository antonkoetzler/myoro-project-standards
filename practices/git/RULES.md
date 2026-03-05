# Git & Version Control

## Conventional Commits

Format: `<type>[scope][!]: <description>`

Types: `feat`, `fix`, `docs`, `style`, `refactor`, `perf`, `test`, `build`, `ci`, `chore`, `revert`

Breaking changes: append `!` and add `BREAKING CHANGE:` footer.

## Branch Naming

- `feature/<ticket>-short-desc` — new functionality
- `fix/<ticket>-short-desc` — bug fixes
- `chore/<desc>` — maintenance
- `hotfix/<desc>` — critical production fixes
- `release/<version>` — release preparation

## Branching Strategy

- **Trunk-Based Development (preferred):** merge to `main` within 1–2 days; use feature flags for incomplete work.
- **Git Flow:** for scheduled-release products only. Document the chosen strategy in `README.md`.

## Pull Requests

- Max ~400 lines changed (excluding generated code).
- Single purpose per PR. Description: What / Why / How to test / Breaking changes.
- All CI checks must pass. At least one approval required.

## Commit Hygiene

- Atomic commits. Present tense imperative: "Add user auth" not "Added user auth".
- No WIP/temp commits on shared branches. No binaries, artifacts, or secrets.

## Merge Policy

- Squash merge for feature branches; merge commit for release branches.
- No force-push to `main` or any shared branch. Delete branches after merging.
