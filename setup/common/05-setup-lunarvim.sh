#!/bin/bash

DISTRO=$(source ${PWD}/setup/common/00-check-distro.sh)

setup_lunarvim() {
    if ! command -v nvim &> /dev/null
    then
        echo "🚫  $(tput setaf 5)Neovim not found$(tput sgr0)"
        echo "🚀  Installing Neovim"
        if [[ $DISTRO == "ubuntu" || $DISTRO == "debian" || $DISTRO == "linuxmint" ]]; then
            sudo apt install neovim -y
        else
            echo "🚫  $(tput setaf 1)Unsupported distribution$(tput sgr0)"
            return
        fi
    fi
    # Add asdf shims to path.
    export PATH="$PATH:$HOME/.asdf/shims:$HOME/.asdf/bin"

    # Fetch the LunarVim script.
    curl -s https://raw.githubusercontent.com/lunarvim/lunarvim/master/utils/installer/install.sh > /tmp/install-lunarvim.sh
    chmod +x /tmp/install-lunarvim.sh

    # Install LunarVim.
    echo "🚀  Installing LunarVim without dependencies."
    /tmp/install-lunarvim.sh --overwrite --no-install-dependencies

    # Cleanup installation script.
    rm /tmp/install-lunarvim.sh

    echo "✨  $(tput setaf 2)LunarVim installed$(tput sgr0)"
}

if [ ! -d "$HOME/.local/share/lunarvim" ]
then
    setup_lunarvim
else
    echo "🌙  $(tput setaf 3)LunarVim is already installed (Skipping)$(tput sgr0)"
fi