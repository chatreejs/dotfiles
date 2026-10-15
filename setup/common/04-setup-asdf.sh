#!/bin/bash

# Pinned Node version for LunarVim LSP servers and Copilot (see CLAUDE.md).
NODE_VERSION="22.17.1"

setup_asdf() {
    if ! test -e ~/.asdf
    then
        log_info "Downloading asdf v0.16.7"
        wget -q https://github.com/asdf-vm/asdf/releases/download/v0.16.7/asdf-v0.16.7-linux-amd64.tar.gz -O asdf.tar.gz

        if [ $? -ne 0 ]; then
            log_error "Failed to download asdf"
            return
        fi

        log_info "Installing asdf"
        tar -xzf asdf.tar.gz
        sudo mv asdf /usr/local/bin
        rm asdf.tar.gz
        log_done "asdf installed"
    else
        log_ok "asdf is already installed"
    fi

    # HACK: add asdf to PATH!
    export PATH="$PATH:$HOME/.asdf/bin"

    if ! command -v asdf &> /dev/null
    then
        log_error "asdf binary is not found"
        return
    fi

    log_info "Updating asdf to latest stable version"
    log_indent asdf update

    for plugin in nodejs python bun
    do
        log_info "Adding $plugin plugin"
        log_indent asdf plugin add $plugin
    done

    # Install and pin Node so LunarVim LSP servers and Copilot have a runtime.
    # asdf 0.16+: `set -u` writes the version to ~/.tool-versions.
    if ! asdf list nodejs 2>/dev/null | grep -q "$NODE_VERSION"; then
        log_info "Installing Node.js $NODE_VERSION"
        log_indent asdf install nodejs "$NODE_VERSION"
    fi
    asdf set -u nodejs "$NODE_VERSION"
    log_done "Node.js $NODE_VERSION set as the default"
}

log_step "📦  asdf"

if command -v asdf &> /dev/null
then
    log_ok "asdf is already installed"
else
    setup_asdf
fi
