# Git & Version Control

## Conventional Commits

All commits must follow the Conventional Commits specification:

```
<type>[optional scope][optional !]: <description>

[optional body]

[optional footer(s)]
```

**Types:** `feat`, `fix`, `docs`, `style`, `refactor`, `perf`, `test`, `build`, `ci`, `chore`, `revert`

**Scope:** the module, component, or area affected — e.g. `feat(auth): add OAuth2 login`

**Breaking changes:** append `!` to the type/scope — e.g. `feat(api)!: remove deprecated endpoints` — and include a `BREAKING CHANGE:` footer.

Examples:
```
feat(user): add email verification flow
fix(auth): handle token expiry on refresh
docs: update API setup instructions
chore(deps): bump lodash to 4.17.21
feat(api)!: remove v1 endpoints
```

## Branch Naming

| Prefix | Use |
|--------|-----|
| `feature/<ticket>-short-desc` | New functionality |
| `fix/<ticket>-short-desc` | Bug fixes |
| `chore/<desc>` | Maintenance, dependency updates |
| `hotfix/<desc>` | Critical production fixes |
| `release/<version>` | Release preparation |

Keep descriptions short (3–5 words, kebab-case). Example: `feature/AUTH-42-oauth2-login`

## Branching Strategy

**Trunk-Based Development (preferred):** Short-lived branches merged to `main` within 1–2 days. Feature flags for in-progress work that must reach main before it's complete. Requires a solid CI pipeline.

**Git Flow (for scheduled-release products):** `main` is always production-ready. `develop` is integration. `feature/*` branches off `develop`. `release/*` branches off `develop` for stabilisation. `hotfix/*` branches off `main`.

Choose one strategy per project and document it in `README.md`. Do not mix strategies.

## Pull Request Rules

- Maximum ~400 lines changed per PR (excluding generated code and migrations).
- Single purpose: one PR, one reason to merge. Split large changes into a stack.
- PR description must include: **What** changed, **Why** it was needed, **How** to test it, any **breaking changes**.
- All CI checks must pass before merge. No bypassing required status checks.
- At least one approval required. Author must not merge their own PR without explicit policy.

## Commit Hygiene

- **Atomic commits:** each commit is a single logical change that leaves the codebase in a working state.
- **Present tense imperative:** "Add user auth" not "Added user auth" or "Adding user auth".
- No "WIP", "temp", "fix stuff", or "asdf" commits on shared branches.
- No binary files, build artifacts, or secrets in commits — ever.

## Merge Policy

- **Squash merge** for feature branches: one clean commit on `main` per PR.
- **Merge commit** for release branches: preserves release history.
- **No force-push to `main`** or any shared branch, ever. Use a revert commit instead.
- Delete branches after merging.
