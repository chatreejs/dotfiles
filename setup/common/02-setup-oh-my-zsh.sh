#!/bin/bash

# Install Oh My Zsh
if [ -d ~/.oh-my-zsh ]; then
    echo "✅ Oh My Zsh already installed"
else
    echo "🚀 Installing Oh My Zsh"
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
    echo "✨ Oh My Zsh installed"
fi

# Install Oh My Zsh plugins
echo "🚀 Installing Oh My Zsh plugins"
if [ -d ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions ]; then
    echo "✅ zsh-autosuggestions already installed"
else
    git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
    echo "✨ zsh-autosuggestions installed"
fi

if [ -d ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/fast-syntax-highlighting ]; then
    echo "✅ fast-syntax-highlighting already installed"
else
    git clone https://github.com/zdharma-continuum/fast-syntax-highlighting.git \
  ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/fast-syntax-highlighting
    echo "✨ fast-syntax-highlighting installed"
fi

echo "✨ Oh My Zsh plugins installed"