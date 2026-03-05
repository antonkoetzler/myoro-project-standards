# Flutter Code Standards

Extends `dart/CODE_STANDARDS.md`. Flutter-specific rules only — apply both when working on a Flutter project.

## Project structure

Feature-first under `lib/`. **No exceptions:** single-file modules get their own folder.

```
lib/
  core/
    routing/           # app_routes.dart, app_router.dart
    di/                # injection.dart, injection.config.dart
    l10n/              # localization wiring
    <util>/            # one module per folder
  features/
    <feature>/
      shell/           # <feature>_shell.dart
      screen/          # <feature>_screen.dart
      _widgets/        # private widgets (see below)
```

### Private widgets
- Folder `_widgets/` in the same scope (feature or screen).
- One widget per file, underscore-prefixed: `_widgets/_shell_with_sidebar.dart`.
- Connect with `part '_widgets/_my_widget.dart';` / `part of 'package:.../shell.dart';`.
- Keep `build()` short by extracting layout here.

## Routing

- Path constants in `lib/core/routing/app_routes.dart` (`AppRoutes.home`, `AppRoutes.settings`). No raw strings anywhere else.
- Router built in one place (`app_router.dart`), using only `AppRoutes.*` constants.
- Navigation: `context.go(AppRoutes.home)` etc. Never push raw strings.

## Code style

Extends Dart code style. Flutter additions:

- **Class member order** (within each group: overrides → public → private):
  1. Static: fields → functions → getters → setters → operators
  2. Constructors
  3. Fields (instance variables)
  4. Functions
  5. Getters / Setters / Operators

- **Parameters:** Omit types when inferred — `build(context)` not `build(BuildContext context)`.
- **`final class`** for widgets and classes not designed to be extended.
- **Two-way branches:** Ternary only — no `if`/`return` for binary choices.
- **`build()` minimal:** No logic or long blocks. Extract into named methods, one abstraction level each.
- **Data-driven:** Config+map over repeated similar widgets. Extract repeated patterns into reusable widgets or helpers in `core/`.
- **Constants:** Global constants in `constants.dart` as `const k<Name>`. Widget/feature-private: `_kShellSidebarBreakpoint`. No magic numbers in UI.

## Responsiveness

- Breakpoint-based. Named constants for breakpoints (private or in `constants.dart` when shared).
- `MediaQuery.sizeOf(context)` or `LayoutBuilder` — never `MediaQuery.of(context).size` (causes full rebuilds).

## Dependency injection

- **injectable** + **get_it**: register via annotations, resolve with `getIt<T>()`. No manual registration in `main`.
- `@lazySingleton` for services/repositories. `@injectable` for factories.
- Constructor injection preferred. Run `make gen` after changing injected types.

## Localization

- All user-facing strings via Flutter l10n: `AppLocalizations.of(context)!.screenTitle`. No hardcoded display text.

## Conventions

- `const` constructors and widgets everywhere possible.
- No `print` in production — use a proper logging package.

## Makefile

| Target | What it does |
|--------|-------------|
| `make run` | `flutter run` |
| `make test` | `flutter test` |
| `make build` | `flutter build <platform> --release` |
| `make clean` | `flutter clean` |
| `make gen` | `dart run build_runner build --delete-conflicting-outputs` |
| `make debug` | `flutter run --debug` (DAP attach via Dart DAP adapter) |
| `make lint` | `flutter analyze` |
| `make format` | `dart format .` |
| `make help` | List targets (self-documenting `##` pattern) |

No `.vscode/tasks.json`, `.vscode/launch.json`, `.idea/runConfigurations/` committed.
`make debug` prints the VM Service URL — connect any DAP client there.
