#!/bin/bash

setup_lunarvim() {
    if ! command -v nvim &> /dev/null
    then
        echo "🚫  Neovim not found"
        echo "🚀  Installing Neovim"
        bash <(curl -s https://raw.githubusercontent.com/LunarVim/LunarVim/rolling/utils/installer/install-neovim-from-release)
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

    echo "✨  LunarVim installed"
}

if [ ! -d "$HOME/.local/share/lunarvim" ]
then
    setup_lunarvim
else
    echo "🌙  LunarVim is already installed (Skipping)"
fi