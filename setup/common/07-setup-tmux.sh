#!/bin/bash

TPM_DIR="$HOME/.tmux/plugins/tpm"

if ! command -v tmux &> /dev/null
then
    echo "🚫  $(tput setaf 1)tmux is not installed (Skipping tmux plugins)$(tput sgr0)"
    return
fi

if ! test -d "$TPM_DIR"
then
    echo "🔌  Installing tmux plugin manager (TPM)"
    git clone --depth 1 https://github.com/tmux-plugins/tpm "$TPM_DIR"
    echo "✨  $(tput setaf 2)TPM installed$(tput sgr0)"
else
    echo "✅  $(tput setaf 3)TPM is already installed (Skipping)$(tput sgr0)"
fi

echo "📦  Installing tmux plugins"
"$TPM_DIR/bin/install_plugins"
echo "✨  $(tput setaf 2)tmux plugins installed$(tput sgr0)"
