# Dart Rules

## Structure

- Feature-first: `lib/src/features/<feature>/`. `<package>.dart` exports public API only.
- One object per file. No `part`/`part of` outside Flutter widget patterns.

## Code style

- `dart format .` (built-in). `dart analyze` with `lints: recommended` or `lints: strict`.
- Dart 3.0+ minimum. Null safety required. `final` for non-reassigning locals. `const` everywhere possible.
- `_` for unused params (reuse for multiple: `(_, __, state)`). No magic numbers.

## Patterns

- **Null safety:** `T?` only when null is meaningful. No `!` without a guard above it. Use `??`, `?.`, `??=`.
- **Async:** `async`/`await` over raw Future chaining. Always close `StreamController`. Never silently ignore a `Future` — use `unawaited()`.
- **Extensions:** `<TypeName>Extension` or descriptive name. One concern per extension.
- **Records (Dart 3+):** Lightweight tuples. Pattern matching in `switch`/`if-case`. Exhaustive switch on sealed classes.
- **Errors:** Typed exception classes. `Result<T>` pattern for expected failures in domain logic. `try`/`catch` at system boundaries only.

## Makefile

- `make run` — `dart run`; `make test` — `dart test`; `make build` — `dart compile exe`
- `make debug` — `--pause-isolates-on-start` (DAP attach); `make gen` — build_runner
- `make lint` — dart analyze; `make format` — dart format .

## Testing

- `package:test` + `package:mockito` or `package:mocktail`. Co-located in `test/src/`.
- `group()` for related cases. `setUp`/`tearDown` for shared state.
