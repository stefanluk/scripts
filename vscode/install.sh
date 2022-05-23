#!/bin/bash

yellow='\033[0;33m'

# install vscode with homebrew
#brew update
#brew cask install visual-studio-code

# install extensions
while read EXTENSION
do
    echo $yellow"Install VSCode Extension: $EXTENSION"
    code --install-extension $EXTENSION
done < $HOME/Scripts/vscode/extensions.txt
