# Development Workflow

## Makefile

Every project has a `Makefile`. No committed VSCode `tasks.json` or IDE run configs.

Required targets: `run`, `test`, `build`, `clean`, `gen`, `debug`, `lint`, `format`, `help`.

`make help` must always work (self-documenting `##` comment pattern).

## DAP Debugging

- `make debug` starts the app in debug/attach mode; prints port/URL to stdout.
- IDEs connect via DAP adapter. No IDE debug configs committed.
- Do not commit `.vscode/launch.json`, `.idea/runConfigurations/`, or similar.

## No Committed IDE Configs

- No `.vscode/`, `.idea/`, `*.suo`, `*.user`, `*.swp` in the repo.
- Add to `.gitignore`. The Makefile is the universal project interface.

## Documentation

- Decisions in `docs/decisions/` (ADR format). Setup in `README.md`.
- Nothing in external wikis that isn't also in the repo.
- Key points, behaviour, intent. No long prose. Document the *why*.
