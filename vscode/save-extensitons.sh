#!/bin/bash

echo "Saving VSCode extensions..."
code --list-extensions > "$HOME/Scripts/vscode/extensions.txt"
