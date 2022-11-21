#!/bin/bash

# Welcom message
echo "👾 Welcome to the dotfiles installer!"

# Check Distro
DISTRO=$(source ${PWD}/setup/common/00-check-distro.sh)
echo "💻 You are Running on $DISTRO"

# Install Homebrew
if [[ $DISTRO == "macos" ]]; then
  source ${PWD}/setup/macos/01-install-homebrew.sh
fi

# Install Homebrew packages from Brewfile
# if [[ $DISTRO == "macos" ]]; then
#     source ${PWD}/setup/macos/02-install-brewfile.sh
# fi

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

# Symlink Config
source ${PWD}/setup/common/04-symlink-config.sh

printf "🎉 All Done! \
\nPlease restart your terminal to apply the changes.\n"