# Engineering Principles

Documentation is for engineers and AI: key points, behavior, intent; avoid long prose.

## SOLID

Apply at all times. Prefer composition over inheritance.

- **S — Single Responsibility:** One class, one reason to change. A class that does two distinct things should be split into two. Example: a `UserService` that also sends emails violates SRP — extract an `EmailService`.
- **O — Open/Closed:** Extend behavior by adding code, not by modifying existing code. Define extension points via interfaces or abstract classes; closed for modification means existing tests never break.
- **L — Liskov Substitution:** A subtype must honor the full contract of its base type. Never override a method to throw `NotImplementedException` or silently no-op; callers must be able to use subtypes interchangeably.
- **I — Interface Segregation:** Prefer small, focused interfaces over large general-purpose ones. Clients must not be forced to depend on methods they don't use. Split a fat interface into role-specific interfaces.
- **D — Dependency Inversion:** High-level modules must not depend on low-level modules; both depend on abstractions. Inject dependencies via constructor or parameter — never construct concrete collaborators inside a class.

## DRY / YAGNI / KISS

- **DRY — Don't Repeat Yourself:** Every piece of knowledge must have a single, authoritative representation. Duplication is a maintenance liability. When you find yourself copy-pasting logic, extract it.
- **YAGNI — You Aren't Gonna Need It:** Only implement what is required right now. Do not add abstractions, parameters, or features for hypothetical future use; they add complexity without immediate value.
- **KISS — Keep It Simple:** The simplest solution that correctly solves the problem is the right solution. Complexity must justify itself. If a simpler approach works, use it.

## Naming

- Variables and functions must have intent-revealing names. A reader must understand the purpose without reading the implementation.
- No abbreviations unless universally known (`id`, `url`, `http`, `i` in loops). Prefer `userAccountBalance` over `usrAcctBal`.
- Boolean names must be phrased as questions: `isLoading`, `hasPermission`, `canEdit`, `shouldRetry`.
- Functions should be named as verbs (`fetchUser`, `calculateTotal`, `validateInput`). Classes as nouns.
- Avoid generic names like `data`, `info`, `manager`, `handler`, `utils` when a more specific name is possible.

## Functions

- One level of abstraction per function. A function that coordinates high-level steps should not also contain low-level implementation details.
- Aim for functions under ~20 lines. When a function grows beyond that, look for extractable concepts with meaningful names.
- No side effects unless the function's name explicitly says so. A function named `getUser` must not modify state; `saveUser` is expected to.
- Avoid output parameters. Return values; don't modify arguments in place unless the API contract is well-established.

## Uniformity

- Within a codebase, there is one way to do each thing. Pick a pattern and apply it everywhere.
- Inconsistency is a bug: it forces readers to infer intent from variation and makes automated tooling less reliable.
- Enforce via linter and formatter. No style debates in code review. If the tool doesn't enforce it, document it in standards.
- Zero tolerance for `// eslint-disable`, `# noqa`, `// noinspection`, or equivalent suppression comments without an explicit documented reason.

## Clean Code

- Good encapsulation: hide implementation details behind clear interfaces.
- No commented-out code. No TODOs left in production. Dead code gets deleted.
- Comments explain *why*, not *what*. The code shows what; a comment that restates the code adds noise.
