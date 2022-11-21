#!/bin/bash

OS=$(uname -s)

if [[ $OS == "Linux" ]]; then
    if ! command -v starship &> /dev/null
    then
        echo "🚀 Installing Starship"
        curl -fsSL https://starship.rs/install.sh | sh -s -- -y
        echo "✨ Starship installed"
    else
        echo "✅ Starship is installed"
    fi
fi