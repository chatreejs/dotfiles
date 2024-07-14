#!/bin/bash

# Check Distro
DISTRO=$(source ${PWD}/setup/common/00-check-distro.sh)
OS=$(uname -s)

# Welcom message
echo "$(tput bold)dotfiles installer v1.1.0$(tput sgr0)"
echo "==> Installing configuration for $DISTRO"

# Install essential packages Linux
if [[ $OS == "Linux" ]]; then
  source ${PWD}/setup/linux/01-install-essential.sh
fi

# Install Homebrew
if [[ $DISTRO == "macos" ]]; then
  source ${PWD}/setup/macos/01-install-homebrew.sh
fi

# Install Homebrew packages from Brewfile
if [[ $DISTRO == "macos" ]]; then
 source ${PWD}/setup/macos/02-install-brewfile.sh
fi

# Enable Key Repeat
if [[ $DISTRO == "macos" ]]; then
  source ${PWD}/setup/macos/03-enable-key-repeat.sh
fi

# Install Zsh
source ${PWD}/setup/common/01-install-zsh.sh

# Setup Oh My Zsh
source ${PWD}/setup/common/02-setup-oh-my-zsh.sh

# Install Starship
source ${PWD}/setup/common/03-install-starship.sh

# Setup asdf
source ${PWD}/setup/common/04-setup-asdf.sh

# Setup LunarVim
source ${PWD}/setup/common/05-setup-lunarvim.sh

# Symlink Config
source ${PWD}/setup/common/06-symlink-config.sh

echo "✨  Done! all configuration is now installed."
echo "$(tput bold)Please restart your terminal to update configuration."
