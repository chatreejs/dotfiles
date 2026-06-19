#!/bin/bash

DISTRO=$(source ${PWD}/setup/common/00-check-distro.sh)

# Pinned versions (see CLAUDE.md: "Pin tool versions explicitly").
# LunarVim has no stable release for Neovim 0.11, and copilot.lua requires
# 0.11+, so we track the Nightly (master) branch on purpose and pin Neovim
# itself. Bump NVIM_VERSION here when upgrading.
LV_BRANCH="master"
NVIM_VERSION="v0.11.6"
NVIM_MIN_MINOR=10 # minimum supported Neovim is 0.10

# Return 0 if a Neovim >= 0.${NVIM_MIN_MINOR} is on PATH.
nvim_version_ok() {
    command -v nvim &> /dev/null || return 1
    local line major minor
    line=$(nvim --version | head -1) # e.g. "NVIM v0.11.6"
    major=$(echo "$line" | sed -E 's/^NVIM v([0-9]+)\..*/\1/')
    minor=$(echo "$line" | sed -E 's/^NVIM v[0-9]+\.([0-9]+).*/\1/')
    [[ "$major" -gt 0 ]] || [[ "$major" -eq 0 && "$minor" -ge $NVIM_MIN_MINOR ]]
}

# Install a pinned Neovim from the official GitHub release (apt ships 0.6/0.7,
# which is too old for LunarVim and copilot.lua).
install_neovim_linux() {
    local arch asset
    case "$(uname -m)" in
        x86_64 | amd64) arch="x86_64" ;;
        aarch64 | arm64) arch="arm64" ;;
        *)
            echo "🚫  $(tput setaf 1)Unsupported architecture $(uname -m)$(tput sgr0)"
            return 1
            ;;
    esac
    asset="nvim-linux-${arch}.tar.gz"
    echo "🚀  Installing Neovim ${NVIM_VERSION} (${arch})"
    if ! curl -fsSL "https://github.com/neovim/neovim/releases/download/${NVIM_VERSION}/${asset}" -o /tmp/nvim.tar.gz; then
        echo "🚫  $(tput setaf 1)Failed to download Neovim${NVIM_VERSION}$(tput sgr0)"
        return 1
    fi
    sudo tar -C /opt -xzf /tmp/nvim.tar.gz
    sudo ln -sf "/opt/nvim-linux-${arch}/bin/nvim" /usr/local/bin/nvim
    rm -f /tmp/nvim.tar.gz
}

# Make sure a suitable Neovim is available before installing LunarVim.
ensure_neovim() {
    if [[ $DISTRO == "macos" ]]; then
        # Brewfile installs neovim with `link: false`, so it is not on PATH.
        if command -v brew &> /dev/null && brew list neovim &> /dev/null; then
            export PATH="$(brew --prefix neovim)/bin:$PATH"
        fi
    fi

    if nvim_version_ok; then
        echo "✅  $(tput setaf 2)Neovim $(nvim --version | head -1 | awk '{print $2}') present$(tput sgr0)"
        return 0
    fi

    echo "🚫  $(tput setaf 5)Neovim missing or older than 0.${NVIM_MIN_MINOR}$(tput sgr0)"
    if [[ $DISTRO == "ubuntu" || $DISTRO == "debian" || $DISTRO == "linuxmint" ]]; then
        install_neovim_linux || return 1
    elif [[ $DISTRO == "macos" ]]; then
        echo "🚫  $(tput setaf 1)Install or upgrade Neovim with 'brew install neovim'$(tput sgr0)"
        return 1
    else
        echo "🚫  $(tput setaf 1)Unsupported distribution$(tput sgr0)"
        return 1
    fi
    nvim_version_ok
}

setup_lunarvim() {
    if ! ensure_neovim; then
        echo "🚫  $(tput setaf 1)No suitable Neovim, skipping LunarVim$(tput sgr0)"
        return
    fi

    # Add asdf shims to path (LunarVim LSP servers and copilot need node).
    export PATH="$PATH:$HOME/.asdf/shims:$HOME/.asdf/bin"

    # Install LunarVim from the pinned branch.
    echo "🚀  Installing LunarVim (branch: ${LV_BRANCH}) without dependencies."
    LV_BRANCH="${LV_BRANCH}" bash <(curl -s "https://raw.githubusercontent.com/lunarvim/lunarvim/${LV_BRANCH}/utils/installer/install.sh") --overwrite --no-install-dependencies

    echo "✨  $(tput setaf 2)LunarVim installed$(tput sgr0)"
}

if [ ! -d "$HOME/.local/share/lunarvim" ]; then
    setup_lunarvim
else
    echo "🌙  $(tput setaf 3)LunarVim is already installed (Skipping)$(tput sgr0)"
fi
