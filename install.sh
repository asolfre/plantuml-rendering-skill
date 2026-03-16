#!/bin/bash

SKILL_NAME="plantuml-rendering"

SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"
SKILL_PATH="${SCRIPT_DIR}"

echo "🌿 PlantUML Rendering Agent Skill Installer 🌿"
echo "------------------------------------------"

# 1. Ask the user for the target platform
echo "Which AI assistant are you installing this skill for?"
echo "1) Claude Code"
echo "2) OpenCode"
echo "3) Copilot"
read -p "Select a platform (1, 2 or 3): " PLATFORM_CHOICE

if [ "$PLATFORM_CHOICE" == "1" ]; then
    PLATFORM_PATH=".claude/skills/$SKILL_NAME"
    PLATFORM_PATH_GLOBAL=".claude/skills/$SKILL_NAME"
    PLATFORM_NAME="Claude Code"
elif [ "$PLATFORM_CHOICE" == "2" ]; then
    PLATFORM_PATH=".opencode/skills/$SKILL_NAME"
    PLATFORM_PATH_GLOBAL=".config/opencode/skills/$SKILL_NAME"
    PLATFORM_NAME="OpenCode"
elif [ "$PLATFORM_CHOICE" == "3" ]; then
    PLATFORM_PATH=".github/skills/$SKILL_NAME"
    PLATFORM_PATH_GLOBAL=".copilot/skills/$SKILL_NAME"
    PLATFORM_NAME="Copilot"
else
    echo "❌ Invalid choice. Aborting installation."
    exit 1
fi

# 2. Ask the user for the installation scope
echo ""
echo "Where would you like to install the skill for $PLATFORM_NAME?"
echo "1) Globally (Available in all projects - ~/$PLATFORM_PATH_GLOBAL/)"
echo "2) Locally (Only available in the current directory - ./$PLATFORM_PATH/)"
read -p "Select an option (1 or 2): " SCOPE_CHOICE

if [ "$SCOPE_CHOICE" == "1" ]; then
    #TARGET_DIR="$HOME/$PLATFORM_PATH"
    TARGET_DIR="$HOME/$PLATFORM_PATH_GLOBAL"
elif [ "$SCOPE_CHOICE" == "2" ]; then
    TARGET_DIR="./$PLATFORM_PATH"
else
    echo "❌ Invalid choice. Aborting installation."
    exit 1
fi

# 3. Create the target directories
echo ""
echo "📂 Creating directory at $TARGET_DIR..."
mkdir -p "$TARGET_DIR/scripts"
mkdir -p "$TARGET_DIR/scripts/lib"

# 4. Copy the files into the selected folder
echo "📦 Copying files..."
# Make sure SKILL.md, render_diagram.sh, and lib/plantuml.jar exist in the current directory
if [ -f "${SKILL_PATH}/SKILL.md" ]; then cp "${SKILL_PATH}/SKILL.md" "$TARGET_DIR/"; fi
if [ -f "${SKILL_PATH}/scripts/render_diagram.sh" ]; then cp "${SKILL_PATH}/scripts/render_diagram.sh" "$TARGET_DIR/scripts/"; fi
if [ -f "${SKILL_PATH}/scripts/lib/plantuml-mit-1.2026.1.jar" ]; then cp "${SKILL_PATH}/scripts/lib/plantuml-mit-1.2026.1.jar" "$TARGET_DIR/scripts/lib/"; else echo "⚠️ Missing lib/plantuml-mit-1.2026.1.jar"; fi

# 5. Make the execution script executable
echo "🔧 Setting permissions..."
if [ -f "$TARGET_DIR/scripts/render_diagram.sh" ]; then
    chmod +x "$TARGET_DIR/scripts/render_diagram.sh"
fi

# 6. Check for Java requirement
echo "☕ Checking prerequisites..."
if ! command -v java &> /dev/null; then
    echo "⚠️ WARNING: Java is not installed or not in your PATH."
    echo "   $PLATFORM_NAME will not be able to run this skill until Java is installed."
    echo "   Download it here: https://www.java.com/download/"
else
    echo "✅ Java detected!"
fi

echo "------------------------------------------"
echo "🎉 Installation Complete!"
echo "Your PlantUML Rendering skill is now ready to be used with $PLATFORM_NAME."
