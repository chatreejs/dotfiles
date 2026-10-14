#!/bin/bash

DISTRO=$(source ${PWD}/setup/common/00-check-distro.sh)

echo "📦  Installing essential packages"

# Install Exa
if [[ $DISTRO == "ubuntu" || $DISTRO == "debian" || $DISTRO == "linuxmint" ]]; then
    # Refresh the package index first; minimal/Docker images ship without one
    sudo apt-get update
    sudo DEBIAN_FRONTEND=noninteractive apt-get install -y build-essential wget git tmux xclip
fi

echo "✨  Done"
