#!/bin/bash

log_step "🍺  Homebrew"

if ! command -v brew &> /dev/null
then
    log_info "Installing Homebrew"
    yes | /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh)"
    log_done "Homebrew installed"
else
    log_ok "Homebrew is already installed"
fi
