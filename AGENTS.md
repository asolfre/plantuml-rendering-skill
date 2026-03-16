# AGENTS.md

## Project Overview

This repository is an AI agent skill/plugin for rendering PlantUML diagrams as images.
It is not a typical application service: no Node, Python, or compiled code build pipeline.
Runtime behavior is implemented with shell scripts and a bundled PlantUML Java JAR.

## Repository Structure

```text
SKILL.md                                # Skill manifest + agent instructions
scripts/
  render_diagram.sh                     # Main renderer script
  lib/plantuml-mit-1.2026.1.jar         # Bundled PlantUML JAR (MIT variant)
tests/
  diagram.puml                          # Sample Azure architecture diagram
  system-design.puml                    # Sample class diagram
  broken-sequence.puml                  # Intentionally broken input for testing
evals/
  evals.json                            # Eval test case definitions
install.sh                              # Interactive installer (Claude Code / OpenCode / Copilot)
```

## Rules Files (Cursor/Copilot)

- `.cursor/rules/`: not present
- `.cursorrules`: not present
- `.github/copilot-instructions.md`: not present

No external editor-specific rule files are currently enforced in this repo.

## Prerequisites

- Java (JRE or JDK) installed and available on `PATH`
- Bash available for script execution

## Build / Lint / Test Commands

There is no build system and no automated test suite configured.

### Build

- No compile/build step exists.
- Functional verification is done by rendering a `.puml` diagram.

### Test (full)

Manual smoke test:

```bash
./scripts/render_diagram.sh tests/diagram.puml
```

Expected result: PNG output generated next to the source `.puml` file.

### Test (single test)

There is no test framework, so a "single test" means rendering one specific input file:

```bash
./scripts/render_diagram.sh path/to/your/diagram.puml
```

### Lint

No linting is configured, but `shellcheck` is recommended for shell scripts:

```bash
shellcheck install.sh scripts/render_diagram.sh
```

## Install Command

Interactive installer:

```bash
./install.sh
```

Prompts for platform (Claude Code/OpenCode/Copilot) and installation scope (global/local).

## Code Style Guidelines

### Language and Scope

- Primary language is Bash shell scripting.
- Keep scripts small, linear, and easy to audit.

### Imports / Dependencies

- No language-level imports are used (shell scripts).
- Depend only on system tools plus `java`.
- Keep paths relative to script location, not caller CWD.

### Formatting

- Use 4-space indentation inside conditionals for readability.
- Keep one logical check per block and separate major sections with blank lines.
- Prefer clear, short `echo` messages for status and failures.

### Types and Data Handling

- Shell has no static types; treat all inputs as untrusted strings.
- Always quote variable expansions (for example: `"$INPUT_FILE"`, `"$JAR_PATH"`).
- Avoid unquoted arguments and glob-sensitive expansions.

### Naming Conventions

- Use `UPPER_SNAKE_CASE` for variables (`SCRIPT_DIR`, `JAR_PATH`, `INPUT_FILE`).
- Use descriptive script names with verbs (`render_diagram.sh`, `install.sh`).

### Error Handling

- Validate input args early and print usage on missing required args.
- Check prerequisites before execution (`java` present, JAR exists, input file exists).
- Use explicit, distinct exit codes by failure class.
- After critical commands, check return code and print actionable errors.

### Path Handling

- Resolve script-relative directory using `BASH_SOURCE` pattern:

```bash
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"
```

- Do not assume the user runs scripts from repository root.

### Comments

- Add comments for intent and non-obvious logic only.
- Prefer short section comments over line-by-line narration.

## SKILL.md Conventions

`SKILL.md` (at the repo root) uses YAML frontmatter with:

- `name`
- `description`
- `compatibility`
- `user-invokable`
- `metadata.author`
- `metadata.version`

Keep the markdown body focused on invocation and failure fallback guidance.

## PlantUML Conventions

- Use `.puml` extension for source diagrams.
- Include `@startuml` and `@enduml` delimiters.
- Renderer uses `-tpng`, so output is PNG by default.
- On render failure, fallback URL: `https://www.plantuml.com/plantuml/uml/`.

## Known Issues to Preserve or Fix Carefully

- Large binary (16.5 MB PlantUML JAR) is stored directly in git. Consider Git LFS
  if the JAR needs to be updated frequently.
