#!/bin/bash

DISTRO=$(source ${PWD}/setup/common/00-check-distro.sh)

echo "📦 Installing essential packages"

# Install Exa
if [[ $DISTRO == "ubuntu" || $DISTRO == "debian" ]]; then
    sudo apt install exa
fi

echo "✨ Done"