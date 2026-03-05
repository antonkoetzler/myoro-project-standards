# Engineering Principles

## SOLID

- **S:** One class, one reason to change. Split when a class does two distinct things.
- **O:** Extend by adding code, not modifying existing. Use interfaces/abstract classes for extension points.
- **L:** Subtypes must honor their base type's contract. Never override to throw or silently no-op.
- **I:** Small, focused interfaces. No client depends on methods it doesn't use.
- **D:** Depend on abstractions. Inject dependencies; never construct them inside a class.

## DRY / YAGNI / KISS

- **DRY:** Single authoritative representation for every piece of knowledge. No copy-pasted logic.
- **YAGNI:** Only implement what is required now. No abstractions for hypothetical future use.
- **KISS:** Simplest correct solution wins. Complexity must justify itself.

## Naming

- Intent-revealing names. No abbreviations unless universally known (`id`, `url`, `i` in loops).
- Booleans as questions: `isLoading`, `hasPermission`, `canEdit`.
- Functions as verbs, classes as nouns. No generic names (`data`, `manager`, `utils`).

## Functions

- One abstraction level per function. Extract when a function grows beyond ~20 lines.
- No side effects unless the name says so. Return values; don't mutate arguments.

## Uniformity

- One agreed-upon way per pattern, applied everywhere. Inconsistency is a bug.
- Enforce via linter/formatter. No lint suppression without a documented reason.

## Clean Code

- Small, focused functions. Names communicate intent.
- No commented-out code, no leftover TODOs, no dead code.
- Comments explain *why*, not *what*.
