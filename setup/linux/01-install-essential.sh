#!/bin/bash

DISTRO=$(source ${PWD}/setup/common/00-check-distro.sh)

log_step "📦  Essential packages"

# Install apt packages
if [[ $DISTRO == "ubuntu" || $DISTRO == "debian" || $DISTRO == "linuxmint" ]]; then
    log_info "Installing essential packages"
    # Refresh the package index first; minimal/Docker images ship without one
    log_indent sudo apt-get update
    log_indent sudo DEBIAN_FRONTEND=noninteractive apt-get install -y build-essential wget git tmux xclip
    log_done "Essential packages installed"
else
    log_skip "No essential packages defined for $DISTRO"
fi
