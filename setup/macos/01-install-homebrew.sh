#!/bin/bash

if ! command -v brew &> /dev/null
then
    echo "🍺  Installing Homebrew"
    yes | /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh)"
    echo "✨  $(tput setaf 2)Homebrew installed$(tput sgr0)"
else
    echo "🍺  $(tput setaf 3)Homebrew is already installed (Skipping)$(tput sgr0)"
fi
