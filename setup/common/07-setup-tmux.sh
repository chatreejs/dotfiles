#!/bin/bash

TPM_DIR="$HOME/.tmux/plugins/tpm"

log_step "💻  tmux"

if ! command -v tmux &> /dev/null
then
    log_skip "tmux is not installed, skipping tmux plugins"
    return
fi

if ! test -d "$TPM_DIR"
then
    log_info "Installing tmux plugin manager (TPM)"
    log_indent git clone -q --depth 1 https://github.com/tmux-plugins/tpm "$TPM_DIR"
    log_done "TPM installed"
else
    log_ok "TPM is already installed"
fi

log_info "Installing tmux plugins"
log_indent "$TPM_DIR/bin/install_plugins"
log_done "tmux plugins installed"
