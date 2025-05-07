#!/bin/bash

echo "🔧  $(tput setaf 6)Enabling Key Repeat$(tput sgr0)"
defaults write -g ApplePressAndHoldEnabled -bool false
