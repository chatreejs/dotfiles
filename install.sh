#!/bin/bash

# Output helpers used by every step
source ${PWD}/setup/common/log.sh

# Check Distro
DISTRO=$(source ${PWD}/setup/common/00-check-distro.sh)
OS=$(uname -s)

# Welcome message
echo "${_bold}dotfiles installer v1.1.0${_reset}"
echo "Installing configuration for ${_bold}$DISTRO${_reset}"

# Load machine-specific settings (see .env.example)
if [[ -f ${PWD}/.env ]]; then
    set -a
    source ${PWD}/.env
    set +a
    echo "Using machine-specific settings from .env"
fi

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

# Trust root CA in installed JDKs
if [[ $DISTRO == "macos" ]]; then
    source ${PWD}/setup/macos/05-trust-java-certs.sh
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

# Setup tmux plugins
source ${PWD}/setup/common/07-setup-tmux.sh

# Add Zsh Config
source ${PWD}/setup/common/99-add-zsh-config.sh

echo
echo "✨  ${_bold}Done! All configuration is now installed.${_reset}"
echo "    Please restart your terminal to load the new configuration."
