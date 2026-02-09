# Flutter / Dart code standards

Documentation is for engineers and AI: key points, behavior, intent; avoid long prose.

## Project structure

Feature-first under `lib/`. **No exceptions:** single-file modules get their own folder; shell and screen files live in a subfolder.

- `lib/core/` — routing, DI, l10n wiring, shared utilities. One module per folder (e.g. `core/navigator_key/navigator_key.dart`, `core/localization/localization.dart`).
- `lib/features/<feature>/` — one folder per feature. Shell in `features/<feature>/shell/`, screens in `features/<feature>/screen/` (e.g. `features/home/shell/home_shell.dart`, `features/settings/screen/settings_screen.dart`).

## Routing

- **Single source of truth:** Path constants in `lib/core/routing/app_routes.dart` (e.g. `AppRoutes.home`, `AppRoutes.settings`). No raw route strings elsewhere.
- **Navigation:** Use route constants only: `context.go(AppRoutes.home)` etc.
- Router built in one place (`app_router.dart`) using only `AppRoutes.*` constants.

## Class member order

Within each category: overrides → public → private.

1. Static declarations (fields → functions → getters → setters → operators)
2. Constructors
3. Fields (instance variables)
4. Functions
5. Getters
6. Setters
7. Operators

## Naming and files

- **Files:** snake_case (e.g. `app_routes.dart`, `settings_screen.dart`).
- **Parameters:** Omit types when inferred; use `build(context)` not `build(BuildContext context)`. Use `_` for unused; reuse `_` for multiple (e.g. `build(_)`, `(_, _, state)`).
- **Final classes:** Use `final class` for classes not designed to be extended or implemented.
- **Two-way branches:** Use ternary when there are only two possibilities (avoid if/return for binary choices).
- **Build methods:** Keep build() minimal (no heavy logic or long blocks). Extract into named methods. One level of abstraction per method. Short blocks and small functions.
- **Reuse and data-driven:** Prefer data-driven lists (config + map) over repeated similar code. Extract repeated patterns into reusable widgets, extensions, or helpers in core.
- **One object per file:** One class, function, variable, enum, etc. per file. Exception: true global constants in `constants.dart` as `const k<Name>`. Widget/feature-specific constants stay private (e.g. `_kShellSidebarBreakpoint`). **Private widgets:** In a folder `_widgets` in the same scope (same feature/screen). One private widget per file, underscore-prefixed (e.g. `_widgets/_shell_with_sidebar.dart`). Connect via `part '_widgets/_my_widget.dart';` and `part of 'package:.../main_file.dart';`. Keep build short by extracting layout into these private widgets.

## Responsiveness

- Breakpoint-based layout. Named constants (private e.g. `_kShellSidebarBreakpoint`, or global `k<Name>` in `constants.dart` only when shared).
- Use `MediaQuery.sizeOf(context)` or `LayoutBuilder` to switch layouts by width.

## Dependency injection

- Use **injectable** + **get_it**: register via annotations; resolve with `getIt<T>()`. Do not register annotated types manually in `main`.
- **Annotations:** `@lazySingleton` for long-lived single-instance (services, repositories). `@injectable` for factories.
- **Construction:** Prefer constructor injection. Avoid constructing dependencies inside a class when they could be injected. Run `dart run build_runner build --delete-conflicting-outputs` after adding/changing injected types.

## Localization

- All user-facing strings via Flutter l10n (e.g. `AppLocalizations.of(context)!.screenTitle`). No hardcoded display text.

## Conventions

- Prefer `const` constructors and widgets where possible.
- No `print` in production; use proper logging if needed.
- No magic numbers in UI; use named constants. No raw route strings; use route constants from a central place.
