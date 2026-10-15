#!/bin/bash

log_step "⭐  Starship"

if ! command -v starship &> /dev/null
then
    log_info "Installing Starship"
    log_indent sh -c "curl -fsSL https://starship.rs/install.sh | sh -s -- -y"
    log_done "Starship installed"
else
    log_ok "Starship is already installed"
fi
