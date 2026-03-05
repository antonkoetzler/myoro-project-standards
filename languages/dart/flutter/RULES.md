# Flutter Rules

Extends Dart rules. Also select "Dart (general)" for complete Dart language rules.

You are the code owner for the dev cycle. Do not delegate work to the user when you can do it yourself (run commands, tests, verification). Senior Flutter/Dart standards: anti-fragile, consistent, scalable.

## Structure

- Feature-first under `lib/`. Single-file modules in their own folder — no exceptions.
- `lib/core/` — routing, DI, l10n, shared utilities. One module per folder.
- `lib/features/<feature>/shell/` and `features/<feature>/screen/` for shells and screens.
- Private widgets: `_widgets/` folder in same scope, underscore-prefixed files (`_widgets/_shell_sidebar.dart`), connected via `part`/`part of`.

## Routing

- Path constants in `lib/core/routing/app_routes.dart` (`AppRoutes.home`). No raw strings anywhere.
- Router built in one place (`app_router.dart`) using only `AppRoutes.*` constants.

## Code style

- Class member order: (1) Static: fields→functions→getters→setters→operators. (2) Constructors. (3) Fields. (4) Functions. (5) Getters/Setters/Operators. Within each: overrides→public→private.
- Omit parameter types when inferred: `build(context)` not `build(BuildContext context)`.
- `final class` for widgets/classes not designed for extension. Ternary for two-way branches — no `if`/`return` binary choices.
- `build()` minimal: no logic, no long blocks. Extract to named methods. One abstraction level per method.
- Data-driven over repeated widget blocks. Extract patterns into reusable widgets/extensions in `core/`.
- `const` constructors everywhere possible. No magic numbers. No `print` in production.
- `MediaQuery.sizeOf(context)` over `.of(context).size` for breakpoint checks.

## Dependency injection

- injectable + get_it. `@lazySingleton` for services/repos. `@injectable` for factories.
- Constructor injection. Run `make gen` after changing injected types.

## Localization

- All user-facing strings via Flutter l10n. No hardcoded display text.

## Makefile

- `make run` — flutter run; `make test` — flutter test; `make build` — flutter build --release
- `make gen` — build_runner; `make debug` — flutter run --debug (DAP attach via Dart DAP adapter)
- `make lint` — flutter analyze; `make format` — dart format .; `make help` — list targets
- No `.vscode/tasks.json`, `.vscode/launch.json`, `.idea/` committed.
