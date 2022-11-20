#!/bin/bash

# Install Zsh
DISTRO=$(source ${PWD}/setup/common/00-check-distro.sh)

if [[ $DISTRO == "macos" ]]; then
    if ! command -v zsh &> /dev/null
    then
        echo "🐚 Installing Zsh..."
        brew install zsh
        echo "✨ Zsh installed"
    else
        echo "✅ Zsh is installed"
    fi
elif [[ $DISTRO == "ubuntu" ]]; then
    if ! command -v zsh &> /dev/null
    then
        echo "🐚 Installing Zsh..."
        sudo apt install zsh
        echo "✨ Zsh installed"
    else
        echo "✅ Zsh is installed"
    fi
fi

# Use Zsh as default shell
if [[ $SHELL != "/bin/zsh" ]]; then
    echo "🐚 Changing default shell to Zsh..."
    chsh -s $(which zsh)
    echo "✨ Default shell changed to Zsh"
else
    echo "✅ Default shell is already Zsh"
fi