#!/bin/bash

if ! command -v starship &> /dev/null
then
    echo "🚀  Installing Starship"
    curl -fsSL https://starship.rs/install.sh | sh -s -- -y
    echo "✨  $(tput setaf 2)Starship installed$(tput sgr0)"
else
    echo "✅  $(tput setaf 3)Starship is already installed (Skipping)$(tput sgr0)"
fi
