#!/bin/bash

# Install Zsh
DISTRO=$(source ${PWD}/setup/common/00-check-distro.sh)

install() {
    if [[ $DISTRO == "macos" ]];
    then
        brew install zsh
    elif [[ $DISTRO == "ubuntu" || $DISTRO == "debian" ]];
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
    echo "✨  Zsh installed"
else
    echo "🐚  Zsh is already installed (Skipping)"
fi

# Use Zsh as default shell
if [[ $SHELL != $(which zsh) ]]; then
    echo "🐚  Changing default shell to Zsh"
    chsh -s $(which zsh)
    echo "✨  Default shell changed to Zsh"
else
    echo "✅  Default shell is already Zsh (Skipping)"
fi