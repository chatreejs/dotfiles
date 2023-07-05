#!/bin/bash

echo "🍻  Installing Homebrew packages"
brew bundle --file=${PWD}/setup/macos/Brewfile | sed 's/^/\t/'
echo "✨  Homebrew packages installed"