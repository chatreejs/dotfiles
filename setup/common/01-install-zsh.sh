#!/bin/bash

# Install Zsh
DISTRO=$(source ${PWD}/setup/common/00-check-distro.sh)

install() {
    if [[ $DISTRO == "macos" ]];
    then
        log_indent brew install zsh
    elif [[ $DISTRO == "ubuntu" || $DISTRO == "debian" || $DISTRO == "linuxmint" ]];
    then
        log_indent sudo apt install zsh -y
    elif [[ $DISTRO == "arch" ]];
    then
        sudo pacman -S zsh
    fi
}

log_step "🐚  Zsh"

if ! command -v zsh &> /dev/null
then
    log_info "Installing Zsh"
    install
    log_done "Zsh installed"
else
    log_ok "Zsh is already installed"
fi

# Use Zsh as default shell
if [[ $SHELL != $(which zsh) ]]; then
    log_info "Changing default shell to Zsh"
    chsh -s $(which zsh)
    log_done "Default shell changed to Zsh"
else
    log_ok "Zsh is already the default shell"
fi
