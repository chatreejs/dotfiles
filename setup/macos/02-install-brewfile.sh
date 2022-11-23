#!/bin/bash

echo "🍻  Installing Homebrew packages"
brew bundle --file=${PWD}/setup/macos/Brewfile
echo "✨  Homebrew packages installed"