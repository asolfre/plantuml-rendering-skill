# plantuml-rendering-skill

[![License: MIT](https://img.shields.io/badge/License-MIT-green.svg)](LICENSE)
[![Platform](https://img.shields.io/badge/Platform-macOS%20%7C%20Linux-blue.svg)](#prerequisites)
[![Requires](https://img.shields.io/badge/Requires-Java-orange.svg)](#prerequisites)
[![Claude Code](https://img.shields.io/badge/Supports-Claude%20Code-blueviolet.svg)](#supported-platforms)
[![OpenCode](https://img.shields.io/badge/Supports-OpenCode-blueviolet.svg)](#supported-platforms)
[![Copilot](https://img.shields.io/badge/Supports-GitHub%20Copilot-blueviolet.svg)](#supported-platforms)

**AI agent skill that gives coding assistants the ability to render PlantUML diagrams as PNG images locally -- no external services needed.**

## What is this?

This is a self-contained skill (plugin) for AI coding assistants. It bundles a PlantUML JAR (MIT variant, v1.2026.1) and a shell script so the agent can render `.puml` files into PNG images on your machine. When you ask your AI assistant to render a diagram, it automatically invokes this skill -- no manual Java commands, no copy-pasting to web tools.

## Why use it?

| | Without this skill | With this skill |
|---|---|---|
| **Rendering** | Manually run `java -jar plantuml.jar ...` or paste code into a web tool | Agent renders the diagram for you automatically |
| **Setup** | Download the PlantUML JAR yourself and figure out the right flags | JAR is bundled -- nothing extra to download |
| **Error handling** | Cryptic Java stack traces or silent failures | Clear exit codes, actionable error messages, and an automatic fallback to the [online PlantUML server](https://www.plantuml.com/plantuml/uml/) |
| **Inline diagrams** | Copy text to a file manually, then render | Paste `@startuml` blocks in chat -- the agent saves and renders them for you |
| **Multiple diagrams** | Run the command once per file yourself | Ask the agent to render them all; it handles each file sequentially |

## Supported Platforms

- **Claude Code** -- installs to `.claude/skills/plantuml-rendering/`
- **OpenCode** -- installs to `.opencode/skills/plantuml-rendering/` (local) or `~/.config/opencode/skills/plantuml-rendering/` (global)
- **GitHub Copilot** -- installs to `.github/skills/plantuml-rendering/` (local) or `~/.copilot/skills/plantuml-rendering/` (global)

## Prerequisites

- **Java** (JRE or JDK) installed and available on `PATH`
- **Bash** (ships with macOS and most Linux distributions)

## Installation

Run the interactive installer from the repository root:

```bash
./install.sh
```

If execute permissions are not preserved in your environment:

```bash
bash install.sh
```

The installer prompts for:
1. **Target platform** -- Claude Code, OpenCode, or GitHub Copilot
2. **Install scope** -- Global (available in all projects) or Local (current project only)

It copies the skill manifest, render script, and bundled PlantUML JAR to the appropriate directory and verifies that Java is available.

### Example: Install into a project as an OpenCode skill

1. `cd` into your project directory:

   ```bash
   cd /path/to/project-a
   ```

2. Run the installer from the cloned repo:

   ```bash
   bash /path/to/plantuml-rendering-skill/install.sh
   ```

3. When prompted, select:
   - **Platform:** `2` (OpenCode)
   - **Scope:** `2` (Locally)

This creates the following structure inside your project:

```
project-a/
└── .opencode/skills/plantuml-rendering/
    ├── SKILL.md
    ├── scripts/
    │   ├── render_diagram.sh
    │   └── lib/plantuml-mit-1.2026.1.jar
```

Any OpenCode session started from `project-a/` will now have the PlantUML rendering skill available.

## Usage

### Ask your AI assistant

Once installed, just ask in natural language:

> Render the PlantUML file at `tests/diagram.puml` as a PNG.

> I have this diagram, generate the image:
> ```
> @startuml
> Alice -> Bob: Hello
> Bob --> Alice: Hi back
> @enduml
> ```

> Render all `.puml` files in the `docs/` folder.

The agent will invoke the bundled render script, produce the PNG, and confirm the output path.

### Direct script invocation

You can also run the render script directly from a terminal:

```bash
./scripts/render_diagram.sh path/to/diagram.puml
```

The output PNG is written next to the input file (e.g., `diagram.puml` produces `diagram.png` in the same directory).

## How it works

1. **Input validation** -- Checks that a `.puml` file path was provided and the file exists on disk.
2. **Prerequisite checks** -- Verifies Java is on `PATH` and the bundled PlantUML JAR is present.
3. **Rendering** -- Invokes `java -jar plantuml.jar -tpng -charset UTF-8` on the input file.
4. **Output verification** -- Confirms the PNG was generated and is non-empty.
5. **Fallback** -- If rendering fails, the agent provides the [PlantUML online server](https://www.plantuml.com/plantuml/uml/) as a fallback so you can still get your diagram.

## Exit codes

| Code | Meaning |
|------|---------|
| `0` | Success -- PNG generated |
| `1` | No input file argument provided |
| `2` | Java is not installed or not on `PATH` |
| `3` | Bundled PlantUML JAR not found |
| `4` | PlantUML encountered a rendering error |
| `5` | Input `.puml` file does not exist |
| `6` | PlantUML exited successfully but no PNG was generated (likely a syntax issue in the input) |

## Project structure

```
plantuml-rendering-skill/
├── SKILL.md                            # Skill manifest and agent workflow instructions
├── install.sh                          # Interactive installer (Claude Code / OpenCode / Copilot)
├── scripts/
│   ├── render_diagram.sh              # Core rendering script
│   └── lib/
│       └── plantuml-mit-1.2026.1.jar  # Bundled PlantUML engine (MIT variant, ~16.5 MB)
├── tests/
│   ├── diagram.puml                   # Sample Azure architecture diagram
│   ├── system-design.puml             # Sample class diagram
│   └── broken-sequence.puml           # Intentionally broken input for error-handling tests
├── evals/
│   └── evals.json                     # Eval test case definitions
└── AGENTS.md                          # Agent-facing project conventions and coding guidelines
```

## Evals

The `evals/` directory contains 5 test cases (`evals.json`) that benchmark how well an AI agent performs with and without this skill installed. The cases cover:

- Rendering a complex Azure architecture diagram
- Rendering a simple class diagram
- Handling broken input (missing `@startuml`/`@enduml` delimiters)
- Saving and rendering inline PlantUML text from chat
- Handling a non-existent file path gracefully

These are useful for contributors developing the skill or anyone benchmarking agent performance using the [skill-creator](https://github.com/anomalyco/opencode) eval framework.

## License

[MIT](LICENSE) -- Angel Solino
