#!/bin/bash

log_step "🍻  Homebrew packages"

log_info "Installing packages from Brewfile"
# Not wrapped in log_indent: piping brew hides its download progress, buffers
# its output and buries the sudo password prompt of pkg casks (e.g. temurin).
# --verbose stops brew bundle from capturing each install's output until it
# finishes, so download progress shows live.
if brew bundle --verbose --file=${PWD}/setup/macos/Brewfile; then
    log_done "Homebrew packages installed"
else
    log_error "Some Homebrew packages failed to install"
fi
