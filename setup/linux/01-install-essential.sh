#!/bin/bash

DISTRO=$(source ${PWD}/setup/common/00-check-distro.sh)

echo "📦  Installing essential packages"

# Install Exa
if [[ $DISTRO == "ubuntu" || $DISTRO == "debian" || $DISTRO == "linuxmint" ]]; then
    sudo apt install build-essential -y
fi

echo "✨  Done"