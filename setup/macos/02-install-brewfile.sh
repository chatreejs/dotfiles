#!/bin/bash

echo "🍻  Installing Homebrew packages"
brew bundle --file=${PWD}/setup/macos/Brewfile | sed 's/^/\t/'
echo "✨  $(tput setaf 2)Homebrew packages installed$(tput sgr0)"