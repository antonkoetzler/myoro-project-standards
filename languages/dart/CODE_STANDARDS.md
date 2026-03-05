# Dart Code Standards

Documentation is for engineers and AI: key points, behavior, intent; avoid long prose.

## Project structure

```
lib/
  src/
    core/             # Shared utilities, DI config, error classes
    features/
      <feature>/
        <feature>_service.dart
        <feature>_repository.dart
        models/
  <package>.dart      # Public API barrel — only export what is public
test/
  src/
    features/
      <feature>/
        <feature>_service_test.dart
pubspec.yaml
Makefile
```

- One object per file. `<package>.dart` exports only the public API.
- No `part`/`part of` outside of Flutter widget extraction patterns.

## Naming conventions

- **Files:** snake_case (`user_service.dart`). **Classes:** PascalCase. **Functions/vars:** camelCase.
- **Constants:** lowerCamelCase (`const maxRetries = 3`). Private module-level: `_camelCase`.
- **Libraries/packages:** snake_case matching the file or package name.
- **Extensions:** `<TypeName>Extension` or descriptive (`StringValidation`, `DateTimeFormatting`).

## Code style

- **Formatter:** `dart format .` (built-in). No alternatives.
- **Linter:** `dart analyze` with `analysis_options.yaml` — use `lints: recommended` minimum; `lints: strict` preferred.
- Dart 3.0+ minimum. Null safety required everywhere.
- `final` for all local variables that don't reassign. `const` wherever possible.
- `_` for unused parameters. Reuse `_` for multiple unused: `(_, __, state)`.
- No magic numbers. Named constants throughout.

## Key patterns

### Null safety
- `T?` only when null is a meaningful value, not as a convenience.
- Never use `!` (null-forgiving) without a null check above it in the same scope.
- Prefer `??`, `?.`, `??=` operators. Use `if (x case final v?)` for pattern-based null guards.
- `late final` for lazy initialization; document why it cannot be initialized in the constructor.

### Async
- `async`/`await` preferred over raw `Future` chaining.
- Use `Stream` for reactive sequences. Always close `StreamController` (use `addError`, `close` in `finally`).
- Never silently ignore a `Future` — `await` it or explicitly call `unawaited()` from `dart:async`.

### Extension methods
- Use to add behavior to types you don't own, or to group related utilities on a type.
- Keep extensions focused — one concern per extension. Don't make a single extension a dumping ground.

### Records and patterns (Dart 3+)
- Use records for lightweight data tuples: `(int, String)` or `({int count, String label})`.
- Pattern matching in `switch`/`if-case` over cascaded if/else or conditional chains.
- Exhaustive switch on sealed classes — never use a fallthrough `default` case when a sealed hierarchy is complete.

### Error handling
- Typed exception classes extending `Exception`. No bare `throw 'string'`.
- Use a `Result<T>` type (e.g. from `package:result_dart`) for expected failures in domain logic.
- `try`/`catch` only at system boundaries; let typed exceptions propagate through business logic.

## Makefile

| Target | What it does |
|--------|-------------|
| `make run` | `dart run bin/main.dart` |
| `make test` | `dart test` |
| `make build` | `dart compile exe bin/main.dart -o bin/app` |
| `make clean` | Remove `.dart_tool/` and build outputs |
| `make gen` | `dart run build_runner build --delete-conflicting-outputs` |
| `make debug` | `dart --pause-isolates-on-start run bin/main.dart` (DAP attach on published port) |
| `make lint` | `dart analyze` |
| `make format` | `dart format .` |
| `make help` | List targets |

## Testing

- Framework: `package:test`. Co-locate: `test/src/features/<feature>/<name>_test.dart`.
- Mocking: `package:mockito` (code-gen) or `package:mocktail` (no codegen).
- Group related tests with `group()`. Shared state via `setUp`/`tearDown`.
- Run `dart test --coverage=coverage/` in CI.
