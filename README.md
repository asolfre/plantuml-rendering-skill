# plantuml-rendering-skill
AI agent skill that renders PlantUML diagrams as PNG images.

## Install

Run the interactive installer from the repository root:

```bash
./install.sh
```

If execute permissions are not preserved in your environment, run:

```bash
bash install.sh
```

The installer prompts for:
- target platform (`Claude Code`, `OpenCode`, or `Copilot`)
- install scope (`global` or `local`)

## Use the skill script directly

```bash
./scripts/render_diagram.sh path/to/diagram.puml
```

Output is written next to the input file as `*.png`.
