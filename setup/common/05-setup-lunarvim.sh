#!/bin/bash

setup_lunarvim() {
    if ! command -v nvim &> /dev/null
    then
        echo "🚫  $(tput setaf 5)Neovim not found$(tput sgr0)"
        echo "🚀  Installing Neovim"
        LV_BRANCH='release-1.4/neovim-0.9' bash <(curl -s https://raw.githubusercontent.com/LunarVim/LunarVim/rolling/utils/installer/install-neovim-from-release)
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