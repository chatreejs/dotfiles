#!/bin/bash

# Pinned asdf release (Linux only; macOS gets asdf from the Brewfile).
ASDF_VERSION="0.16.7"
# Pinned Node version for LunarVim LSP servers and Copilot (see CLAUDE.md).
NODE_VERSION="22.17.1"
ASDF_PLUGINS="nodejs python bun"

install_asdf() {
    local os arch
    os=$(uname -s | tr '[:upper:]' '[:lower:]')
    case "$(uname -m)" in
        x86_64|amd64) arch="amd64" ;;
        aarch64|arm64) arch="arm64" ;;
        *)
            log_error "Unsupported architecture: $(uname -m)"
            return 1
            ;;
    esac

    log_info "Downloading asdf v$ASDF_VERSION ($os-$arch)"
    if ! wget -q "https://github.com/asdf-vm/asdf/releases/download/v$ASDF_VERSION/asdf-v$ASDF_VERSION-$os-$arch.tar.gz" -O asdf.tar.gz
    then
        log_error "Failed to download asdf"
        rm -f asdf.tar.gz
        return 1
    fi

    log_info "Installing asdf"
    tar -xzf asdf.tar.gz
    sudo mv asdf /usr/local/bin
    rm asdf.tar.gz
    log_done "asdf installed"
}

setup_asdf_plugins() {
    local installed
    installed=$(asdf plugin list 2>/dev/null)

    for plugin in $ASDF_PLUGINS
    do
        if echo "$installed" | grep -qx "$plugin"; then
            log_ok "$plugin plugin is already added"
        else
            log_info "Adding $plugin plugin"
            log_indent asdf plugin add "$plugin"
        fi
    done
}

setup_node() {
    # Install and pin Node so LunarVim LSP servers and Copilot have a runtime.
    # asdf 0.16+: `set -u` writes the version to ~/.tool-versions.
    if asdf list nodejs 2>/dev/null | grep -q "$NODE_VERSION"; then
        log_ok "Node.js $NODE_VERSION is already installed"
    else
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
    install_asdf || return
fi

if ! command -v asdf &> /dev/null
then
    log_error "asdf binary is not found"
    return
fi

setup_asdf_plugins
setup_node
