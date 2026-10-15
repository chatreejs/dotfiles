#!/bin/bash

log_step "🍻  Homebrew packages"

log_info "Installing packages from Brewfile"
if log_indent brew bundle --file=${PWD}/setup/macos/Brewfile; then
    log_done "Homebrew packages installed"
else
    log_error "Some Homebrew packages failed to install"
fi
