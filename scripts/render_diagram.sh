#!/bin/bash

# Define the path to the bundled JAR relative to this script
# This ensures it works even if the user calls the script from another directory
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"
JAR_PATH="${SCRIPT_DIR}/lib/plantuml-mit-1.2026.1.jar"

# Check if the user provided an input file
INPUT_FILE="$1"
if [ -z "$INPUT_FILE" ]; then
    echo "Usage: ./render_diagram.sh <path_to_puml_file>"
    exit 1
fi

# Check if the input file actually exists on disk
if [ ! -f "$INPUT_FILE" ]; then
    echo "Error: Input file not found: $INPUT_FILE"
    echo "Please check the path and try again."
    exit 5
fi

# Check if Java is installed and available in the PATH
if ! command -v java &> /dev/null; then
    echo "Error: Java is not installed or not found in your system's PATH."
    echo "This skill requires Java to render diagrams."
    exit 2
fi

# Check if the PlantUML JAR is exactly where we expect it
if [ ! -f "$JAR_PATH" ]; then
    echo "Error: Could not find the PlantUML JAR at $JAR_PATH."
    echo "Please ensure the skill folder is intact and contains the /lib directory."
    exit 3
fi

# Execute PlantUML
# The -tpng flag ensures it outputs a PNG; -charset UTF-8 for consistent encoding
echo "Rendering diagram for $INPUT_FILE..."
java -jar "$JAR_PATH" -tpng -charset UTF-8 "$INPUT_FILE"

# Check if PlantUML itself reported an error
if [ $? -ne 0 ]; then
    echo "Error: PlantUML encountered an issue while rendering."
    exit 4
fi

# Verify the output PNG was actually created
# PlantUML sometimes exits 0 but produces no image (e.g., warnings without output)
OUTPUT_FILE="${INPUT_FILE%.puml}.png"
if [ ! -s "$OUTPUT_FILE" ]; then
    echo "Error: PlantUML exited successfully but no PNG was generated at $OUTPUT_FILE."
    echo "The input file may contain syntax issues that prevented image creation."
    exit 6
fi

echo "Success! Diagram rendered: $OUTPUT_FILE"