# Development Workflow

## Makefile as Task Runner

Every project has a `Makefile` in the root. Commands are self-documenting — no memorisation required.

**Required targets:**

| Target | What it does |
|--------|-------------|
| `make run` | Start the application in development mode |
| `make test` | Run the full test suite |
| `make build` | Produce a release artifact |
| `make clean` | Remove build outputs and generated files |
| `make gen` | Run code generation (mocks, serialization, protobufs, etc.) |
| `make debug` | Start the app in debug / DAP-attach mode |
| `make lint` | Run the linter |
| `make format` | Run the formatter |
| `make help` | Print all available targets with a one-line description |

Rules:
- Do not commit VSCode tasks (`tasks.json`) or IDE run configs. The Makefile is the universal interface.
- `make help` must always work. Use a self-documenting pattern — `##` comments parsed by the help target.
- Add language-specific targets as needed (e.g. `make migrate`, `make proto`, `make docker`).

Example self-documenting help target:
```makefile
.DEFAULT_GOAL := help
help: ## Show this help
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | \
	  awk 'BEGIN {FS = ":.*?## "}; {printf "  \033[36m%-15s\033[0m %s\n", $$1, $$2}'
```

## DAP Debugging

- `make debug` starts the application in debug mode, or in attach mode on a known port.
- The port and connection URL are printed to stdout so any DAP client can connect.
- IDEs connect via their DAP adapter — no IDE-specific debug configuration is committed to the repo.
- Language-specific DAP adapters: Dart (`dart debugger`), Python (`debugpy`), Go (`dlv dap`), Node.js (`--inspect`), Java (`jdwp`), C/C++ (`lldb-dap` / `cppdbg`), .NET (`netcoredbg`).
- Do not commit `.vscode/launch.json`, `.idea/runConfigurations/`, `.idea/workspace.xml`, or similar files.

## No Committed IDE Configs

- Do not commit `.vscode/`, `.idea/`, `*.suo`, `*.user`, `*.swp`, or other IDE/editor-specific files.
- Add these patterns to `.gitignore`.
- The Makefile is the universal interface to all project tasks. Any developer with `make` can onboard without an IDE.
- Developer tooling is personal, not shared. Configuration that works on one machine may break another.

## Documentation

- Decisions go in `docs/decisions/` using ADR format (Architecture Decision Records).
- Setup steps go in `README.md`; a new developer must be able to run the project after reading it.
- Nothing in external wikis that isn't also committed to the repo — wikis go stale, git doesn't lie.
- Docs are for engineers and AI: key points, behaviour, intent. No long prose.
- Document the *why*, not the *what* — the code shows what; the docs explain the reasoning.
- Keep docs close to the code. A `README.md` per module or feature folder is encouraged.
