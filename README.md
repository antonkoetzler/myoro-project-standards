# Code standards (all languages)

One place for language- and framework-specific code standards and Cursor rules. Add a subfolder per language (e.g. `flutter/`, `python/`).

## Layout

- **`flutter/`** — Flutter/Dart: `CODE_STANDARDS.md` + `.cursor/rules/flutter.mdc`
- Add more: `python/`, `typescript/`, etc., each with its own docs and optional `.cursor/rules/*.mdc`

## Where to store this

Use a repo (e.g. `boilerplates` or `standards`) and clone or submodule it where you need it. One place to edit; reuse across projects.

## Import into a new project

For a given language (e.g. Flutter):

1. **Docs:** Copy that language’s `CODE_STANDARDS.md` into the project (e.g. `docs/CODE_STANDARDS.md`).
2. **Cursor:** Copy that language’s `.cursor/rules/*.mdc` into the project’s `.cursor/rules/` (create if needed).

Example (Flutter): copy `standards/flutter/CODE_STANDARDS.md` to `docs/`, and `standards/flutter/.cursor/rules/flutter.mdc` to `.cursor/rules/`.
