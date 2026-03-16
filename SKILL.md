---
name: plantuml-rendering
description: Render PlantUML text and .puml files into image outputs (PNG). Use this skill whenever the user mentions PlantUML, .puml files, UML diagram source text, or asks to render/export/generate a sequence/class/activity/component diagram image. Trigger even when the user does not explicitly say "PlantUML" but provides @startuml/@enduml blocks or asks to turn UML-like text into a diagram image.
compatibility: Requires java
user-invokable: true
metadata:
  author: asolfre
  version: "1.1"
---

## Workflow

Use this flow to keep runs predictable and easy to debug.

### 1. Prepare the input

- The renderer expects a `.puml` file on disk with `@startuml` and `@enduml` delimiters.
- If the user provides inline PlantUML text (pasted in chat, in a code block, etc.), save it to a `.puml` file first. Pick a descriptive name based on the content — for example, if it describes authentication flow, save as `auth-flow.puml`. Place it in the same directory as related project files, or in the project root if there is no obvious location.
- Java must be available on the system. If `java` is not found, report that clearly and stop.

### 2. Render the diagram

The render script is bundled with this skill. Resolve its path relative to where this SKILL.md lives — the script is at `scripts/render_diagram.sh` inside this skill's directory.

```bash
<skill-base-dir>/scripts/render_diagram.sh <path-to-puml-file>
```

The script handles path resolution internally, so the `.puml` file path can be absolute or relative to the current working directory.

**Exit codes** the script may return:
| Code | Meaning |
|------|---------|
| 0 | Success — PNG created |
| 1 | No input file argument provided |
| 2 | Java not installed or not in PATH |
| 3 | PlantUML JAR missing from skill bundle |
| 4 | PlantUML execution error |
| 5 | Input file not found on disk |
| 6 | PlantUML exited OK but no PNG was generated (likely syntax issues in the source) |

### 3. Verify the output

After the script runs, confirm the PNG file exists next to the input `.puml` file. The output path follows PlantUML's convention:

```
docs/architecture.puml  →  docs/architecture.png
```

If the script reports exit code 6 (no PNG generated despite no PlantUML error), the source file likely has syntax problems. Check the PlantUML output for warnings like "no image in ...".

### 4. Handle multiple diagrams

If the user has several `.puml` files to render, call the script once per file. There is no batch mode — each invocation renders one diagram.

### 5. Fallback behavior

If local rendering fails for any reason (invalid syntax, environment issue, or user preference), provide this online fallback:

`https://www.plantuml.com/plantuml/uml/`

Tell the user to paste the PlantUML source there to validate syntax or generate an image quickly. If the failure appears environment-related (exit codes 2, 3, or 5), also report the likely cause so the user can fix their setup.
