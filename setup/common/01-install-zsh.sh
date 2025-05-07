#!/bin/bash

# Install Zsh
DISTRO=$(source ${PWD}/setup/common/00-check-distro.sh)

install() {
    if [[ $DISTRO == "macos" ]];
    then
        brew install zsh
    elif [[ $DISTRO == "ubuntu" || $DISTRO == "debian" || $DISTRO == "linuxmint" ]];
    then
        sudo apt install zsh -y
    elif [[ $DISTRO == "arch" ]];
    then
        sudo pacman -S zsh
    fi
}

if ! command -v zsh &> /dev/null
then
    echo "🐚  Installing Zsh"
    install
    echo "✨  $(tput setaf 2)Zsh installed$(tput sgr0)"
else
    echo "🐚  $(tput setaf 3)Zsh is already installed (Skipping)$(tput sgr0)"
fi

# Use Zsh as default shell
if [[ $SHELL != $(which zsh) ]]; then
    echo "🐚  Changing default shell to Zsh"
    chsh -s $(which zsh)
    echo "✨  $(tput setaf 2)Default shell changed to Zsh$(tput sgr0)"
else
    echo "✅  $(tput setaf 3)Default shell is already Zsh (Skipping)$(tput sgr0)"
fi
