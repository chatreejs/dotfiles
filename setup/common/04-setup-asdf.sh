#!/bin/bash

# Pinned Node version for LunarVim LSP servers and Copilot (see CLAUDE.md).
NODE_VERSION="22.17.1"

setup_asdf() {
    if ! test -e ~/.asdf
    then
        wget https://github.com/asdf-vm/asdf/releases/download/v0.16.7/asdf-v0.16.7-linux-amd64.tar.gz -O asdf.tar.gz
        
        if [ $? -ne 0 ]; then
            echo "🚫  $(tput setaf 1)Failed to download asdf$(tput sgr0)"
            return
        fi
        
        echo "📦  $(tput setaf 2)Installing asdf$(tput sgr0)"
        tar -xzvf asdf.tar.gz
        sudo mv asdf /usr/local/bin
        rm asdf.tar.gz
        echo "📦  $(tput setaf 2)asdf installed$(tput sgr0)"
    else
        echo "✅  $(tput setaf 3)asdf is already installed (Skipping)$(tput sgr0)"
    fi
    
    # HACK: add asdf to PATH!
    export PATH="$PATH:$HOME/.asdf/bin"
    
    if ! command -v asdf
    then
        echo "🚫  $(tput setaf 1)asdf binary is not found.$(tput sgr0)"
        return
    fi
    
    echo "📦  Updating asdf to latest stable version"
    asdf update
    
    for plugin in nodejs python
    do
        echo -e "🔌  adding $plugin plugin"
        asdf plugin add $plugin
    done

    # Install and pin Node so LunarVim LSP servers and Copilot have a runtime.
    # asdf 0.16+: `set -u` writes the version to ~/.tool-versions.
    if ! asdf list nodejs 2>/dev/null | grep -q "$NODE_VERSION"; then
        echo "📦  Installing Node.js $NODE_VERSION"
        asdf install nodejs "$NODE_VERSION"
    fi
    asdf set -u nodejs "$NODE_VERSION"
}

if command -v asdf &> /dev/null
then
    echo "✅  $(tput setaf 3)asdf is already installed (Skipping)$(tput sgr0)"
else
    echo "🚀  Installing asdf"
    setup_asdf
    echo "✨  $(tput setaf 2)asdf installed$(tput sgr0)"
fi
